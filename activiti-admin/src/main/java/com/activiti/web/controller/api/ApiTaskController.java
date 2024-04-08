package com.activiti.web.controller.api;

import com.activiti.common.core.domain.entity.SysRole;
import com.activiti.common.core.domain.entity.SysUser;
import com.activiti.common.core.page.TableDataInfo;
import com.activiti.common.utils.StringUtils;
import com.activiti.system.domain.TaskInfo;
import com.activiti.web.dto.QueryTaskRequest;
import com.activiti.web.dto.StartTaskDTO;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.activiti.engine.IdentityService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.activiti.engine.task.TaskQuery;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

import static com.activiti.common.utils.ShiroUtils.getSysUser;

@Api(value = "任务api相关接口")
@Controller
@RequestMapping("/api/task")
public class ApiTaskController {

  @Resource
  private IdentityService identityService;

  @Resource
  private RuntimeService runtimeService;

  @Resource
  private TaskService taskService;

  @ResponseBody
  @PostMapping("/start")
  public Boolean startTask(@Valid @RequestBody StartTaskDTO startTaskDTO) {
    identityService.setAuthenticatedUserId(String.valueOf(startTaskDTO.getUserId()));
    HashMap<String, Object> variables = new HashMap<>();
    variables.put("applyuserid", startTaskDTO.getUserId());
    runtimeService.startProcessInstanceByKey(startTaskDTO.getModelKey(), String.valueOf(startTaskDTO.getBusinessId()), variables);
    // 自动完成第一个任务
    Task autoTask = taskService.createTaskQuery().processDefinitionKey(startTaskDTO.getModelKey()).processInstanceBusinessKey(String.valueOf(startTaskDTO.getBusinessId())).singleResult();
    taskService.complete(autoTask.getId());
    return true;
  }

  @ApiOperation("查询我的待办任务列表")
  @PostMapping("/mylist")
  @ResponseBody
  public TableDataInfo mylist(@RequestBody QueryTaskRequest request)
  {
    TaskQuery condition = taskService.createTaskQuery().taskCandidateOrAssigned(request.getUserName());

    if (CollectionUtils.isNotEmpty(request.getRoleNames())) {
      condition.taskCandidateGroupIn(request.getRoleNames());
    }

    // 过滤掉流程挂起的待办任务
    int total = condition.active().orderByTaskCreateTime().desc().list().size();
    int start = (request.getPageNum()-1) * request.getPageSize();
    List<Task> taskList = condition.active().orderByTaskCreateTime().desc().listPage(start, request.getPageSize());

    List<TaskInfo> tasks = new ArrayList<>();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    taskList.stream().forEach(a->{
      ProcessInstance process = runtimeService.createProcessInstanceQuery().processInstanceId(a.getProcessInstanceId()).singleResult();
      TaskInfo info = new TaskInfo();
      info.setAssignee(Objects.isNull(a.getAssignee()) ? request.getUserName() : a.getAssignee());
      info.setBusinessKey(process.getBusinessKey());
      info.setCreateTime(sdf.format(a.getCreateTime()));
      info.setTaskName(a.getName());
      info.setExecutionId(a.getExecutionId());
      info.setProcessInstanceId(a.getProcessInstanceId());
      info.setProcessName(process.getProcessDefinitionName());
      info.setStarter(process.getStartUserId());
      info.setStartTime(sdf.format(process.getStartTime()));
      info.setTaskId(a.getId());
      tasks.add(info);
    });
    TableDataInfo rspData = new TableDataInfo();
    rspData.setCode(0);
    rspData.setRows(tasks);
    rspData.setTotal(total);
    return rspData;
  }
}
