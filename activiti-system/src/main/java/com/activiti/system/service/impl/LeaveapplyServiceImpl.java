package com.activiti.system.service.impl;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import com.activiti.common.core.domain.entity.LeaveapplyPo;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.activiti.engine.HistoryService;
import org.activiti.engine.IdentityService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.collections4.MapUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import com.activiti.system.mapper.LeaveapplyMapper;
import com.activiti.system.domain.Leaveapply;
import com.activiti.system.service.ILeaveapplyService;
import com.activiti.common.core.text.Convert;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

/**
 * 请假Service业务层处理
 * 
 * @author shenzhanwang
 * @date 2022-04-02
 */
@Service
@Transactional
public class LeaveapplyServiceImpl implements ILeaveapplyService {
    @Resource
    private LeaveapplyMapper leaveapplyMapper;

    @Resource
    private RuntimeService runtimeService;

    @Resource
    private TaskService taskService;

    @Resource
    IdentityService identityService;

    @Resource
    HistoryService historyService;

    /**
     * 查询请假
     * 
     * @param id 请假主键
     * @return 请假
     */
    @Override
    public Leaveapply selectLeaveapplyById(Long id) {
        return leaveapplyMapper.selectLeaveapplyById(id);
    }

    /**
     * 查询请假列表
     * 
     * @param leaveapply 请假
     * @return 请假
     */
    @Override
    public List<Leaveapply> selectLeaveapplyList(Leaveapply leaveapply) {
        LambdaQueryWrapper<LeaveapplyPo> queryWrapper = Wrappers.lambdaQuery();
        queryWrapper
            .eq(StringUtils.isNotEmpty(leaveapply.getUserId()), LeaveapplyPo::getUserId, leaveapply.getUserId())
            .eq(StringUtils.isNotEmpty(leaveapply.getLeaveType()), LeaveapplyPo::getLeaveType, leaveapply.getLeaveType())
            .ge(MapUtils.isNotEmpty(leaveapply.getParams()) && StringUtils.isNotBlank(String.valueOf(leaveapply.getParams().get("beginApplyTime"))), LeaveapplyPo::getApplyTime, leaveapply.getParams().get("beginApplyTime"))
            .le(MapUtils.isNotEmpty(leaveapply.getParams()) && StringUtils.isNotBlank(String.valueOf(leaveapply.getParams().get("endApplyTime"))), LeaveapplyPo::getApplyTime, leaveapply.getParams().get("endApplyTime"));
        return leaveapplyMapper.selectList(queryWrapper).stream().map(this::convert).collect(Collectors.toList());
    }

    private Leaveapply convert(LeaveapplyPo po) {
        Leaveapply leaveapply = new Leaveapply();
      try {
        BeanUtils.copyProperties(leaveapply, po);
      } catch (IllegalAccessException e) {
        throw new RuntimeException(e);
      } catch (InvocationTargetException e) {
        throw new RuntimeException(e);
      }
      return leaveapply;
    }

    /**
     * 新增请假
     * 
     * @param leaveapply 请假
     * @return 结果
     */
    @Override
    public int insertLeaveapply(Leaveapply leaveapply)
    {
        int rows = leaveapplyMapper.insertLeaveapply(leaveapply);
        // 发起请假流程
        identityService.setAuthenticatedUserId(leaveapply.getUserId());
        HashMap<String, Object> variables = new HashMap<>();
        variables.put("applyuserid", leaveapply.getUserId());
//        variables.put("deptleader", leaveapply.getDeptleader());
        runtimeService.startProcessInstanceByKey(leaveapply.getModelKey(), String.valueOf(leaveapply.getId()), variables);
        // 自动完成第一个任务
        Task autoTask = taskService.createTaskQuery().processDefinitionKey(leaveapply.getModelKey()).processInstanceBusinessKey(String.valueOf(leaveapply.getId())).singleResult();
        taskService.complete(autoTask.getId());
        return rows;
    }

    /**
     * 修改请假
     * 
     * @param leaveapply 请假
     * @return 结果
     */
    @Override
    public int updateLeaveapply(Leaveapply leaveapply)
    {
        return leaveapplyMapper.updateLeaveapply(leaveapply);
    }

    /**
     * 批量删除请假
     * 
     * @param ids 需要删除的请假主键
     * @return 结果
     */
    @Override
    public int deleteLeaveapplyByIds(String ids)
    {
        String[] keys = Convert.toStrArray(ids);
        for (String key : keys) {
            ProcessInstance process = runtimeService.createProcessInstanceQuery().processDefinitionKey("leave").processInstanceBusinessKey(key).singleResult();
            if (process != null) {
                runtimeService.deleteProcessInstance(process.getId(), "删除");
            }
            // 删除历史数据
            HistoricProcessInstance history = historyService.createHistoricProcessInstanceQuery().processDefinitionKey("leave").processInstanceBusinessKey(key).singleResult();
            if (history != null){
                historyService.deleteHistoricProcessInstance(history.getId());
            }
            leaveapplyMapper.deleteLeaveapplyById(Long.parseLong(key));
        }
        return keys.length;
    }

    /**
     * 删除请假信息
     * 
     * @param id 请假主键
     * @return 结果
     */
    @Override
    public int deleteLeaveapplyById(Long id)
    {
        return leaveapplyMapper.deleteLeaveapplyById(id);
    }
}
