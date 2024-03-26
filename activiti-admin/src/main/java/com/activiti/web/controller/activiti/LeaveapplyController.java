package com.activiti.web.controller.activiti;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.activiti.common.core.domain.entity.SysUser;
import com.activiti.system.domain.Process;
import com.activiti.system.service.ISysUserService;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.repository.ProcessDefinitionQuery;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.activiti.system.domain.Leaveapply;
import com.activiti.system.service.ILeaveapplyService;
import com.activiti.common.core.controller.BaseController;
import com.activiti.common.core.domain.AjaxResult;
import com.activiti.common.utils.poi.ExcelUtil;
import com.activiti.common.core.page.TableDataInfo;

import javax.annotation.Resource;

/**
 * 请假Controller
 * 
 * @author shenzhanwang
 * @date 2022-04-02
 */
@Controller
@RequestMapping("/leaveapply")
public class LeaveapplyController extends BaseController {
    private String prefix = "activiti/leaveapply";

    @Autowired
    private ILeaveapplyService leaveapplyService;

    @Autowired
    private ISysUserService userService;

    @Resource
    private RuntimeService runtimeService;

    @Resource
    private TaskService taskService;

    @Resource
    private RepositoryService repositoryService;

    @GetMapping()
    public String leaveapply() {
        return prefix + "/leaveapply";
    }

    /**
     * 部门领导审批
     * @return
     */
    @GetMapping("/deptleadercheck")
    public String deptleadercheck(String taskid, ModelMap mmap) {
        Task t = taskService.createTaskQuery().taskId(taskid).singleResult();
        String processId = t.getProcessInstanceId();
        ProcessInstance p = runtimeService.createProcessInstanceQuery().processInstanceId(processId).singleResult();
        if (p != null) {
            Leaveapply apply = leaveapplyService.selectLeaveapplyById(Long.parseLong(p.getBusinessKey()));
            mmap.put("apply", apply);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            mmap.put("startTime", sdf.format(apply.getStartTime()));
            mmap.put("endTime", sdf.format(apply.getEndTime()));
            mmap.put("taskid", taskid);
            mmap.put("userlist", userService.selectUserList(new SysUser()));
        }
        return prefix + "/deptleadercheck";
    }

    //通用的审批页面
    @GetMapping("/check")
    public String check(String taskid, ModelMap mmap) {
        Task t = taskService.createTaskQuery().taskId(taskid).singleResult();
        String processId = t.getProcessInstanceId();
        ProcessInstance p = runtimeService.createProcessInstanceQuery().processInstanceId(processId).singleResult();
        if (p != null) {
            Leaveapply apply = leaveapplyService.selectLeaveapplyById(Long.parseLong(p.getBusinessKey()));
            mmap.put("apply", apply);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            mmap.put("startTime", sdf.format(apply.getStartTime()));
            mmap.put("endTime", sdf.format(apply.getEndTime()));
            mmap.put("taskid", taskid);
            mmap.put("userlist", userService.selectUserList(new SysUser()));
        }
        return prefix + "/check";
    }

    /**
     * 人事审批
     * @return
     */
    @GetMapping("/hrcheck")
    public String hrcheck(String taskid, ModelMap mmap) {
        Task t = taskService.createTaskQuery().taskId(taskid).singleResult();
        String processId = t.getProcessInstanceId();
        ProcessInstance p = runtimeService.createProcessInstanceQuery().processInstanceId(processId).singleResult();
        if (p != null) {
            Leaveapply apply = leaveapplyService.selectLeaveapplyById(Long.parseLong(p.getBusinessKey()));
            mmap.put("apply", apply);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            mmap.put("startTime", sdf.format(apply.getStartTime()));
            mmap.put("endTime", sdf.format(apply.getEndTime()));
            mmap.put("taskid", taskid);
        }
        return prefix + "/hrcheck";
    }

    /**
     * 销假
     * @return
     */
    @GetMapping("/destroyapply")
    public String destroyapply(String taskid, ModelMap mmap) {
        Task t = taskService.createTaskQuery().taskId(taskid).singleResult();
        String processId = t.getProcessInstanceId();
        ProcessInstance p = runtimeService.createProcessInstanceQuery().processInstanceId(processId).singleResult();
        if (p != null) {
            Leaveapply apply = leaveapplyService.selectLeaveapplyById(Long.parseLong(p.getBusinessKey()));
            mmap.put("apply", apply);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            mmap.put("startTime", sdf.format(apply.getStartTime()));
            mmap.put("endTime", sdf.format(apply.getEndTime()));
            mmap.put("taskid", taskid);
        }
        return prefix + "/destroyapply";
    }


    /**
     * 调整申请
     * @return
     */
    @GetMapping("/modifyapply")
    public String modifyapply(String taskid, ModelMap mmap)
    {
        Task t = taskService.createTaskQuery().taskId(taskid).singleResult();
        String processId = t.getProcessInstanceId();
        ProcessInstance p = runtimeService.createProcessInstanceQuery().processInstanceId(processId).singleResult();
        if (p != null) {
            Leaveapply apply = leaveapplyService.selectLeaveapplyById(Long.parseLong(p.getBusinessKey()));
            mmap.put("apply", apply);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            mmap.put("startTime", sdf.format(apply.getStartTime()));
            mmap.put("endTime", sdf.format(apply.getEndTime()));
            mmap.put("taskid", taskid);
        }
        return prefix + "/modifyapply";
    }

    /**
     * 发起请假申请
     * 驳回后使用
     * @return
     */
    @GetMapping("/addleave")
    public String addLeave(String taskid, ModelMap mmap)
    {
        Task t = taskService.createTaskQuery().taskId(taskid).singleResult();
        String processId = t.getProcessInstanceId();
        ProcessInstance p = runtimeService.createProcessInstanceQuery().processInstanceId(processId).singleResult();
        if (p != null) {
            Leaveapply apply = leaveapplyService.selectLeaveapplyById(Long.parseLong(p.getBusinessKey()));
            mmap.put("apply", apply);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            mmap.put("startTime", sdf.format(apply.getStartTime()));
            mmap.put("endTime", sdf.format(apply.getEndTime()));
            mmap.put("taskid", taskid);
        }
        return prefix + "/addleave";
    }

    /**
     * 查询请假列表
     */
    @PostMapping("/list")
    @ResponseBody
    public TableDataInfo list(Leaveapply leaveapply)
    {
        SysUser user = getSysUser();
        String username = user.getLoginName();
        leaveapply.setUserId(username);
        startPage();
        List<Leaveapply> list = leaveapplyService.selectLeaveapplyList(leaveapply);
        return getDataTable(list);
    }

    /**
     * 导出请假列表
     */
    @PostMapping("/export")
    @ResponseBody
    public AjaxResult export(Leaveapply leaveapply)
    {
        SysUser user = getSysUser();
        String username = user.getLoginName();
        leaveapply.setUserId(username);
        List<Leaveapply> list = leaveapplyService.selectLeaveapplyList(leaveapply);
        ExcelUtil<Leaveapply> util = new ExcelUtil<Leaveapply>(Leaveapply.class);
        return util.exportExcel(list, "请假数据");
    }

    /**
     * 新增请假
     */
    @GetMapping("/add")
    public String add(ModelMap mmap) {
        ProcessDefinitionQuery queryCondition = repositoryService.createProcessDefinitionQuery();
        queryCondition.latestVersion();
        queryCondition.active();
        List<ProcessDefinition> pageList = queryCondition.orderByDeploymentId().desc().list();
        List<Process> pdList = new ArrayList<Process>();
        for (int i = 0; i < pageList.size(); i++) {
            Process p = new Process();
            p.setDeploymentId(pageList.get(i).getDeploymentId());
            p.setId(pageList.get(i).getId());
            p.setKey(pageList.get(i).getKey());
            p.setName(pageList.get(i).getName());
            p.setResourceName(pageList.get(i).getResourceName());
            p.setDiagramresourceName(pageList.get(i).getDiagramResourceName());
            p.setVersion(pageList.get(i).getVersion());
            p.setSuspended(pageList.get(i).isSuspended());
            pdList.add(p);
        }

        SysUser user = getSysUser();
        mmap.put("user", user);
        mmap.put("pdList", pdList);
        return prefix + "/add";
    }

    /**
     * 发起请假流程
     */
    @PostMapping("/add")
    @ResponseBody
    public AjaxResult addSave(Leaveapply leaveapply) {
        leaveapply.setApplyTime(new Date());
        return toAjax(leaveapplyService.insertLeaveapply(leaveapply));
    }

    @PostMapping("/update")
    @ResponseBody
    public AjaxResult update(Leaveapply leaveapply)
    {
        return toAjax(leaveapplyService.updateLeaveapply(leaveapply));
    }

    /**
     * 删除请假
     */
    @PostMapping( "/remove")
    @ResponseBody
    public AjaxResult remove(String ids)
    {
        return toAjax(leaveapplyService.deleteLeaveapplyByIds(ids));
    }

}
