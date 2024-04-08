package com.activiti.web.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.NonNull;

import javax.validation.constraints.NotBlank;
import java.io.Serializable;
import java.util.List;

@Data
public class QueryTaskRequest implements Serializable {
  @NotBlank
  @ApiModelProperty("人员名称")
  private String userName;

  @ApiModelProperty("人员角色列表")
  private List<String> roleNames;

  @NonNull
  @ApiModelProperty("页号")
  private Integer pageNum;

  @NonNull
  @ApiModelProperty("页大小")
  private Integer pageSize;
}
