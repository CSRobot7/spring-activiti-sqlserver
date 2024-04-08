package com.activiti.web.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.NonNull;

import javax.validation.constraints.NotBlank;
import java.io.Serializable;


@Data
public class StartTaskDTO implements Serializable {

  @NonNull
  @ApiModelProperty("业务id")
  private Long businessId;

  @NotBlank
  @ApiModelProperty("业务关联的模型key")
  private String modelKey;

  @NonNull
  @ApiModelProperty("流程发起人id")
  private Long userId;
}
