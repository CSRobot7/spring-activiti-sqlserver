package com.activiti.web.controller.activiti;

import com.activiti.common.core.controller.BaseController;
import com.activiti.common.core.domain.AjaxResult;
import com.activiti.common.core.domain.entity.SysRole;
import com.activiti.common.core.domain.entity.SysUser;
import com.activiti.common.core.page.TableDataInfo;
import com.activiti.common.utils.StringUtils;
import com.activiti.system.domain.TaskInfo;
import com.activiti.web.util.ActivitiTracingChart;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.activiti.bpmn.model.BpmnModel;
import org.activiti.engine.FormService;
import org.activiti.engine.HistoryService;
import org.activiti.engine.ProcessEngine;
import org.activiti.engine.ProcessEngineConfiguration;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.history.HistoricActivityInstance;
import org.activiti.engine.runtime.Execution;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Comment;
import org.activiti.engine.task.Task;
import org.activiti.engine.task.TaskQuery;
import org.activiti.image.ProcessDiagramGenerator;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

@Api(value = "待办任务接口")
@Controller
@RequestMapping("/task/manage")
public class TaskController extends BaseController {

    @Autowired
    private RuntimeService runtimeService;

    @Autowired
    private TaskService taskService;

    @Autowired
    FormService formService;

    @Resource
    private HistoryService historyService;

    @Resource
    private ActivitiTracingChart activitiTracingChart;

    @Resource
    private RepositoryService repositoryService;

    @Resource
    private ProcessEngine processEngine;

    private String prefix = "activiti/task";
    private Task a;

    @GetMapping("/mytask")
    public String mytasks()
    {
        return prefix + "/mytasks";
    }

    @GetMapping("/alltasks")
    public String alltasks()
    {
        return prefix + "/alltasks";
    }

    /**
     * 查询我的待办任务列表
     */
    @ApiOperation("查询我的待办任务列表")
    @PostMapping("/mylist")
    @ResponseBody
    public TableDataInfo mylist(TaskInfo param)
    {
        SysUser user = getSysUser();
        String username = user.getLoginName();
        TaskQuery condition = taskService.createTaskQuery().taskCandidateOrAssigned(username);
        List<String> roleNames = Optional.ofNullable(user.getRoles())
            .orElse(new ArrayList<>())
            .stream().map(SysRole::getRoleName)
            .collect(Collectors.toList());
        if (CollectionUtils.isNotEmpty(roleNames)) {
            condition.taskCandidateGroupIn(roleNames);
        }
        if (StringUtils.isNotEmpty(param.getTaskName())) {
            condition.taskName(param.getTaskName());
        }
        if (StringUtils.isNotEmpty(param.getProcessName())) {
            condition.processDefinitionName(param.getProcessName());
        }
        // 过滤掉流程挂起的待办任务
        int total = condition.active().orderByTaskCreateTime().desc().list().size();
        int start = (param.getPageNum()-1) * param.getPageSize();
        List<Task> taskList = condition.active().orderByTaskCreateTime().desc().listPage(start, param.getPageSize());

        List<TaskInfo> tasks = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        taskList.stream().forEach(a->{
            ProcessInstance process = runtimeService.createProcessInstanceQuery().processInstanceId(a.getProcessInstanceId()).singleResult();
            TaskInfo info = new TaskInfo();
            info.setAssignee(Objects.isNull(a.getAssignee()) ? username : a.getAssignee());
            info.setBusinessKey(process.getBusinessKey());
            info.setCreateTime(sdf.format(a.getCreateTime()));
            info.setTaskName(a.getName());
            info.setExecutionId(a.getExecutionId());
            info.setProcessInstanceId(a.getProcessInstanceId());
            info.setProcessName(process.getProcessDefinitionName());
            info.setStarter(process.getStartUserId());
            info.setStartTime(sdf.format(process.getStartTime()));
            info.setTaskId(a.getId());
            String formKey = formService.getTaskFormData(a.getId()).getFormKey();
            //todo 可以根据模型分类确定跳转的自定义表单，先简单处理
            if (a.getProcessDefinitionId().contains("leave")) {
                formKey = "leaveapply/check";
            }
            info.setFormKey(formKey);
            tasks.add(info);
        });
        TableDataInfo rspData = new TableDataInfo();
        rspData.setCode(0);
        rspData.setRows(tasks);
        rspData.setTotal(total);
        return rspData;
    }

    /**
     * 查询所有待办任务列表
     */
    @ApiOperation("查询所有待办任务列表")
    @PostMapping("/alllist")
    @ResponseBody
    public TableDataInfo alllist(TaskInfo param)
    {
        TaskQuery condition = taskService.createTaskQuery();
        if (StringUtils.isNotEmpty(param.getTaskName())) {
            condition.taskName(param.getTaskName());
        }
        if (StringUtils.isNotEmpty(param.getProcessName())) {
            condition.processDefinitionName(param.getProcessName());
        }
        int total = condition.active().orderByTaskCreateTime().desc().list().size();
        int start = (param.getPageNum()-1) * param.getPageSize();
        List<Task> taskList = condition.active().orderByTaskCreateTime().desc().listPage(start, param.getPageSize());
        List<TaskInfo> tasks = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        taskList.stream().forEach(a->{
            ProcessInstance process = runtimeService.createProcessInstanceQuery().processInstanceId(a.getProcessInstanceId()).singleResult();
            TaskInfo info = new TaskInfo();
            info.setAssignee(a.getAssignee());
            info.setBusinessKey(process.getBusinessKey());
            info.setCreateTime(sdf.format(a.getCreateTime()));
            info.setTaskName(a.getName());
            info.setExecutionId(a.getExecutionId());
            info.setProcessInstanceId(a.getProcessInstanceId());
            info.setProcessName(process.getProcessDefinitionName());
            info.setStarter(process.getStartUserId());
            info.setStartTime(sdf.format(process.getStartTime()));
            info.setTaskId(a.getId());
            String formKey = formService.getTaskFormData(a.getId()).getFormKey();
            info.setFormKey(formKey);
            tasks.add(info);
        });
        TableDataInfo rspData = new TableDataInfo();
        rspData.setCode(0);
        rspData.setRows(tasks);
        rspData.setTotal(total);
        return rspData;
    }

    /**
     * 用taskid查询formkey
     **/
    @ApiOperation("用taskid查询formkey")
    @PostMapping("/forminfo/{taskId}")
    @ResponseBody
    public AjaxResult alllist(@PathVariable String taskId)
    {
        String formKey = formService.getTaskFormData(taskId).getFormKey();
        return AjaxResult.success(formKey);
    }

    @ApiOperation("办理一个用户任务")
    @RequestMapping(value = "/completeTask/{taskId}", method = RequestMethod.POST)
    @ResponseBody
    public AjaxResult completeTask(@PathVariable("taskId") String taskId, @RequestBody(required=false) Map<String, Object> variables) {
        SysUser user = getSysUser();
        String username = user.getLoginName();
        taskService.setAssignee(taskId, username);
        // 查出流程实例id
        String processInstanceId = taskService.createTaskQuery().taskId(taskId).singleResult().getProcessInstanceId();
        if (variables == null) {
            taskService.complete(taskId);
        } else {
            // 添加审批意见
            if (variables.get("comment") != null) {
                taskService.addComment(taskId, processInstanceId, (String) variables.get("comment"));
                variables.remove("comment");
            }
            taskService.complete(taskId, variables);
        }
        return AjaxResult.success();
    }

    @ApiOperation("任务办理时间轴")
    @RequestMapping(value = "/history/{taskId}", method = RequestMethod.GET)
    @ResponseBody
    public List<TaskInfo> history(@PathVariable String taskId) {
        String processInstanceId = taskService.createTaskQuery().taskId(taskId).singleResult().getProcessInstanceId();
        List<HistoricActivityInstance> history = historyService.createHistoricActivityInstanceQuery().processInstanceId(processInstanceId).activityType("userTask").orderByHistoricActivityInstanceStartTime().asc().list();
        List<TaskInfo> infos  = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        history.stream().forEach(h->{
            TaskInfo info = new TaskInfo();
            info.setProcessInstanceId(h.getProcessInstanceId());
            info.setStartTime(sdf.format(h.getStartTime()));
            if (h.getEndTime() != null) {
                info.setEndTime(sdf.format(h.getEndTime()));
            }
            info.setAssignee(h.getAssignee());
            info.setTaskName(h.getActivityName());
            List<Comment> comments = taskService.getTaskComments(h.getTaskId());
            if (comments.size() > 0) {
                info.setComment(comments.get(0).getFullMessage());
            }
            infos.add(info);
        });
        return infos;
    }

    @GetMapping(value = "/processDiagram/{taskid}")
    public void genProcessDiagram(HttpServletResponse httpServletResponse, @PathVariable String taskid) throws IOException {
        final Task task = taskService.createTaskQuery().taskId(taskid).singleResult();
        if (Objects.isNull(task)) {
            return;
        }
        String processInstanceId = task.getProcessInstanceId();

        List<Execution> executions = runtimeService.createExecutionQuery()
            .processInstanceId(processInstanceId)
            .list();

        List<String> highLightedActivities = new ArrayList<>();
        List<String> highLightedFlows = new ArrayList<>();
        for (Execution exe : executions) {
            List<String> ids = runtimeService.getActiveActivityIds(exe.getId());
            highLightedActivities.addAll(ids);
        }

        //获取流程图
        ProcessInstance processInstance = runtimeService.createProcessInstanceQuery().processInstanceId(processInstanceId).singleResult();
        BpmnModel bpmnModel = repositoryService.getBpmnModel(processInstance.getProcessDefinitionId());
        ProcessEngineConfiguration engconf = processEngine.getProcessEngineConfiguration();
        ProcessDiagramGenerator diagramGenerator = engconf.getProcessDiagramGenerator();
        InputStream in = diagramGenerator.generateDiagram(bpmnModel,
            "png",
            highLightedActivities,
            highLightedFlows,
            "宋体", "微软雅黑", "黑体", null, 2.0);

        OutputStream out = null;
        byte[] buf = new byte[1024];
        int legth = 0;
        try {
            out = httpServletResponse.getOutputStream();
            while ((legth = in.read(buf)) != -1) {
                out.write(buf, 0, legth);
            }
        } finally {
            if (in != null) {
                in.close();
            }
            if (out != null) {
                out.close();
            }
        }
    }

}
