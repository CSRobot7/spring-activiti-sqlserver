package com.activiti.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.activiti.common.core.domain.entity.SysUserPo;
import org.apache.ibatis.annotations.Mapper;

/**
 * 用户表 数据层
 * 
 *
 */
@Mapper
public interface SysUserMapperV2 extends BaseMapper<SysUserPo> {
}
