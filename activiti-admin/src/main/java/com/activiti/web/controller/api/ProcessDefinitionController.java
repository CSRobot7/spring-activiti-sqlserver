package com.activiti.web.controller.api;

import com.activiti.common.utils.StringUtils;
import com.activiti.system.domain.Process;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.repository.ProcessDefinitionQuery;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/api/process-definition")
public class ProcessDefinitionController {

  @Resource
  private RepositoryService repositoryService;


  @GetMapping("/query/list")
  @ResponseBody
  public List<Process> queryPrcessDefinitionList(@RequestParam String pdCategory) {
    ProcessDefinitionQuery queryCondition = repositoryService.createProcessDefinitionQuery();
    queryCondition.latestVersion();
    queryCondition.active();
    final ProcessDefinitionQuery query = queryCondition.orderByDeploymentId().active();
    if (StringUtils.isNotBlank(pdCategory)) {
      query.processDefinitionCategory(pdCategory);
    }
    List<ProcessDefinition> pageList = query.desc().list();
    List<Process> pdList = new ArrayList<>();
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
    return pdList;
  }
}
