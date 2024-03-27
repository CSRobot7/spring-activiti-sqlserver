IF OBJECT_ID('hibernate_sequences', 'U') IS NOT NULL
DROP TABLE hibernate_sequences;
GO

CREATE TABLE hibernate_sequences (
     sequence_name nvarchar(255) DEFAULT NULL,
     sequence_next_hi_value int DEFAULT NULL
);
GO

IF OBJECT_ID('leaveapply', 'U') IS NOT NULL
DROP TABLE leaveapply;
GO

CREATE TABLE leaveapply (
    id int IDENTITY(1,1) NOT NULL,
    user_id nvarchar(20) DEFAULT NULL,
    start_time datetime DEFAULT NULL,
    end_time datetime DEFAULT NULL,
    leave_type nvarchar(45) DEFAULT NULL,
    reason nvarchar(400) DEFAULT NULL,
    apply_time datetime DEFAULT NULL,
    reality_start_time datetime DEFAULT NULL,
    reality_end_time datetime DEFAULT NULL,
    model_key nvarchar(20) NOT NULL DEFAULT '',
    CONSTRAINT PK_leaveapply PRIMARY KEY CLUSTERED (id)
)
WITH (DATA_COMPRESSION = NONE);
GO

SET IDENTITY_INSERT leaveapply ON;

INSERT INTO leaveapply (id, user_id, start_time, end_time, leave_type, reason, apply_time, reality_start_time, reality_end_time, model_key)
VALUES
    (1, 'admin', '2024-03-19T23:00:17', '2024-03-20T23:00:17', N'事假', '', '2024-03-19T23:01:40', NULL, NULL, ''),
    (4, 'admin', '2024-03-20T22:10:14', '2024-03-21T22:10:14', N'事假', '123', '2024-03-20T22:11:24', NULL, NULL, 'leave'),
    (7, 'admin', '2024-03-20T22:40:10', '2024-03-21T22:40:10', N'事假', '', '2024-03-20T22:48:51', NULL, NULL, 'leave2'),
    (8, 'admin', '2024-03-20T14:40:16', '2024-03-21T14:40:16', N'事假', '', '2024-03-20T23:40:29', NULL, NULL, 'leave3');

SET IDENTITY_INSERT leaveapply OFF;
GO

IF OBJECT_ID('meeting', 'U') IS NOT NULL
DROP TABLE meeting;
GO

CREATE TABLE meeting (
     id int IDENTITY(1,1) NOT NULL,
     topic nvarchar(100) DEFAULT NULL,
     host nvarchar(50) DEFAULT NULL,
     place nvarchar(50) DEFAULT NULL,
     peoplelist nvarchar(255) DEFAULT NULL,
     start_time datetime DEFAULT NULL,
     end_time datetime DEFAULT NULL,
     content nvarchar(max) DEFAULT NULL, -- 注意：text类型在SQL Server中可用nvarchar(max)替代
     CONSTRAINT PK_meeting PRIMARY KEY CLUSTERED (id)
);
GO

IF OBJECT_ID('purchase', 'U') IS NOT NULL
DROP TABLE purchase;
GO

CREATE TABLE purchase (
      id int IDENTITY(1,1) NOT NULL,
      itemlist nvarchar(MAX) NOT NULL, -- 注意：text在SQL Server中对应的是 nvarchar(MAX)
      total nvarchar(10) NOT NULL,
      applytime datetime DEFAULT NULL,
      applyer nvarchar(45) DEFAULT NULL,
      CONSTRAINT PK_purchase PRIMARY KEY CLUSTERED (id)
)
WITH (DATA_COMPRESSION = NONE);
GO


IF OBJECT_ID('sys_config', 'U') IS NOT NULL
DROP TABLE sys_config;
GO

CREATE TABLE sys_config (
    config_id int IDENTITY(1,1) NOT NULL,
    config_name nvarchar(100) DEFAULT '',
    config_key nvarchar(100) DEFAULT '',
    config_value nvarchar(500) DEFAULT '',
    config_type nchar(1) DEFAULT 'N',
    create_by nvarchar(64) DEFAULT '',
    create_time datetime DEFAULT NULL,
    update_by nvarchar(64) DEFAULT '',
    update_time datetime DEFAULT NULL,
    remark nvarchar(500) DEFAULT NULL,
    CONSTRAINT PK_sys_config PRIMARY KEY CLUSTERED (config_id)
)
WITH (DATA_COMPRESSION = NONE);
GO

IF OBJECT_ID('sys_dept', 'U') IS NOT NULL
DROP TABLE sys_dept;
GO

CREATE TABLE sys_dept (
  dept_id bigint IDENTITY(1,1) NOT NULL,
  parent_id bigint DEFAULT 0,
  ancestors nvarchar(50) DEFAULT '',
  dept_name nvarchar(30) DEFAULT '',
  order_num int DEFAULT 0,
  leader nvarchar(20) DEFAULT NULL,
  phone nvarchar(11) DEFAULT NULL,
  email nvarchar(50) DEFAULT NULL,
  status char(1) DEFAULT '0',
  del_flag char(1) DEFAULT '0',
  create_by nvarchar(64) DEFAULT '',
  create_time datetime DEFAULT NULL,
  update_by nvarchar(64) DEFAULT '',
  update_time datetime DEFAULT NULL,
  PRIMARY KEY CLUSTERED (dept_id)
)
WITH (DATA_COMPRESSION = NONE);
GO

SET IDENTITY_INSERT sys_dept ON;
INSERT INTO sys_dept (dept_id, parent_id, ancestors, dept_name, order_num, leader, phone, email, status, del_flag, create_by, create_time, update_by, update_time)
VALUES
    (100, 0, '0', N'流程科技', 0, N'流程', '15888888888', 'activiti@qq.com', '0', '0', N'admin', '2022-05-26T15:25:37', NULL, NULL),
    (101, 100, '0,100', N'深圳总公司', 1, N'流程', '15888888888', 'activiti@qq.com', '0', '0', N'admin', '2022-05-26T15:25:37', NULL, NULL),
    (102, 100, '0,100', N'长沙分公司', 2, N'流程', '15888888888', 'activiti@qq.com', '0', '0', N'admin', '2022-05-26T15:25:37', NULL, NULL),
    (103, 101, '0,100,101', N'研发部门', 1, N'流程', '15888888888', 'activiti@qq.com', '0', '0', N'admin', '2022-05-26T15:25:37', NULL, NULL),
    (104, 101, '0,100,101', N'市场部门', 2, N'流程', '15888888888', 'activiti@qq.com', '0', '0', N'admin', '2022-05-26T15:25:37', NULL, NULL),
    (105, 101, '0,100,101', N'测试部门', 3, N'流程', '15888888888', 'activiti@qq.com', '0', '0', N'admin', '2022-05-26T15:25:37', NULL, NULL),
    (106, 101, '0,100,101', N'财务部门', 4, N'流程', '15888888888', 'activiti@qq.com', '0', '0', N'admin', '2022-05-26T15:25:37', NULL, NULL),
    (107, 101, '0,100,101', N'运维部门', 5, N'流程', '15888888888', 'activiti@qq.com', '0', '0', N'admin', '2022-05-26T15:25:37', NULL, NULL),
    (108, 102, '0,100,102', N'市场部门', 1, N'流程', '15888888888', 'activiti@qq.com', '0', '0', N'admin', '2022-05-26T15:25:37', NULL, NULL),
    (109, 102, '0,100,102', N'财务部门', 2, N'流程', '15888888888', 'activiti@qq.com', '0', '0', N'admin', '2022-05-26T15:25:37', NULL, NULL);
SET IDENTITY_INSERT sys_dept OFF;
GO

IF OBJECT_ID('sys_dict_data', 'U') IS NOT NULL
DROP TABLE sys_dict_data;
GO

CREATE TABLE sys_dict_data (
   dict_code bigint IDENTITY(1,1) NOT NULL,
   dict_sort int DEFAULT 0,
   dict_label nvarchar(100) DEFAULT '',
   dict_value nvarchar(100) DEFAULT '',
   dict_type nvarchar(100) DEFAULT '',
   css_class nvarchar(100) DEFAULT NULL,
   list_class nvarchar(100) DEFAULT NULL,
   is_default char(1) DEFAULT 'N',
   status char(1) DEFAULT '0',
   create_by nvarchar(64) DEFAULT '',
   create_time datetime DEFAULT NULL,
   update_by nvarchar(64) DEFAULT '',
   update_time datetime DEFAULT NULL,
   remark nvarchar(500) DEFAULT NULL,
   PRIMARY KEY CLUSTERED (dict_code)
);
GO

SET IDENTITY_INSERT sys_dict_data ON;

INSERT INTO sys_dict_data (dict_code, dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark)
VALUES
    (1, 1, N'男', '0', 'sys_user_sex', NULL, NULL, 'Y', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'性别男'),
    (2, 2, N'女', '1', 'sys_user_sex', NULL, NULL, 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'性别女'),
    (3, 3, N'未知', '2', 'sys_user_sex', NULL, NULL, 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'性别未知'),
    (4, 1, N'显示', '0', 'sys_show_hide', NULL, 'primary', 'Y', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'显示菜单'),
    (5, 2, N'隐藏', '1', 'sys_show_hide', NULL, 'danger', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'隐藏菜单'),
    (6, 1, N'正常', '0', 'sys_normal_disable', NULL, 'primary', 'Y', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'正常状态'),
    (7, 2, N'停用', '1', 'sys_normal_disable', NULL, 'danger', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'停用状态'),
    (8, 1, N'正常', '0', 'sys_job_status', NULL, 'primary', 'Y', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'正常状态'),
    (9, 2, N'暂停', '1', 'sys_job_status', NULL, 'danger', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'停用状态'),
    (10, 1, N'默认', 'DEFAULT', 'sys_job_group', NULL, NULL, 'Y', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'默认分组'),
    (11, 2, N'系统', 'SYSTEM', 'sys_job_group', NULL, NULL, 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'系统分组'),
    (12, 1, N'是', 'Y', 'sys_yes_no', NULL, 'primary', 'Y', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'系统默认是'),
    (13, 2, N'否', 'N', 'sys_yes_no', NULL, 'danger', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'系统默认否'),
    (14, 1, N'通知', '1', 'sys_notice_type', NULL, 'warning', 'Y', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'通知'),
    (15, 2, N'公告', '2', 'sys_notice_type', NULL, 'success', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'公告'),
    (16, 1, N'正常', '0', 'sys_notice_status', NULL, 'primary', 'Y', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'正常状态'),
    (17, 2, N'关闭', '1', 'sys_notice_status', NULL, 'danger', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'关闭状态'),
    (19, 1, N'新增', '1', 'sys_oper_type', NULL, 'info', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'新增操作'),
    (20, 2, N'修改', '2', 'sys_oper_type', NULL, 'info', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'修改操作'),
    (21, 3, N'删除', '3', 'sys_oper_type', NULL, 'danger', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'删除操作'),
    (22, 4, N'授权', '4', 'sys_oper_type', NULL, 'primary', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'授权操作'),
    (23, 5, N'导出', '5', 'sys_oper_type', NULL, 'warning', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'导出操作'),
    (24, 6, N'导入', '6', 'sys_oper_type', NULL, 'warning', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'导入操作'),
    (25, 7, N'强退', '7', 'sys_oper_type', NULL, 'danger', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'强退操作'),
    (26, 8, N'生成代码', '8', 'sys_oper_type', NULL, 'warning', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'生成操作'),
    (27, 9, N'清空数据', '9', 'sys_oper_type', NULL, 'danger', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'清空操作'),
    (28, 1, N'成功', '0', 'sys_common_status', NULL, 'primary', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'正常状态'),
    (29, 2, N'失败', '1', 'sys_common_status', NULL, 'danger', 'N', '0', 'admin', '2022-05-26 15:25:38', NULL, NULL, N'停用状态');

SET IDENTITY_INSERT sys_dict_data OFF;
GO

IF OBJECT_ID('sys_dict_type', 'U') IS NOT NULL
DROP TABLE sys_dict_type;

CREATE TABLE sys_dict_type (
   dict_id bigint IDENTITY(1,1) NOT NULL,
   dict_name nvarchar(100) DEFAULT '',
   dict_type nvarchar(100) DEFAULT '',
   status char(1) DEFAULT '0',
   create_by nvarchar(64) DEFAULT '',
   create_time datetime2 DEFAULT NULL,
   update_by nvarchar(64) DEFAULT '',
   update_time datetime2 DEFAULT NULL,
   remark nvarchar(500) DEFAULT NULL,
   PRIMARY KEY (dict_id),
   CONSTRAINT UX_dict_type UNIQUE (dict_type)
);

SET IDENTITY_INSERT sys_dict_type ON;

INSERT INTO sys_dict_type (dict_id, dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark)
VALUES
    (1,N'用户性别','sys_user_sex','0','admin','2022-05-26T15:25:38',NULL,NULL,N'用户性别列表'),
    (2,N'菜单状态','sys_show_hide','0','admin','2022-05-26T15:25:38',NULL,NULL,N'菜单状态列表'),
    (3,N'系统开关','sys_normal_disable','0','admin','2022-05-26T15:25:38',NULL,NULL,N'系统开关列表'),
    (4,N'任务状态','sys_job_status','0','admin','2022-05-26T15:25:38',NULL,NULL,N'任务状态列表'),
    (5,N'任务分组','sys_job_group','0','admin','2022-05-26T15:25:38',NULL,NULL,N'任务分组列表'),
    (6,N'系统是否','sys_yes_no','0','admin','2022-05-26T15:25:38',NULL,NULL,N'系统是否列表'),
    (7,N'通知类型','sys_notice_type','0','admin','2022-05-26T15:25:38',NULL,NULL,N'通知类型列表'),
    (8,N'通知状态','sys_notice_status','0','admin','2022-05-26T15:25:38',NULL,NULL,N'通知状态列表'),
    (9,N'操作类型','sys_oper_type','0','admin','2022-05-26T15:25:38',NULL,NULL,N'操作类型列表'),
    (10,N'系统状态','sys_common_status','0','admin','2022-05-26T15:25:38',NULL,NULL,N'登录状态列表');
SET IDENTITY_INSERT sys_dict_type OFF;
GO

IF OBJECT_ID('sys_menu', 'U') IS NOT NULL
DROP TABLE sys_menu;
GO

CREATE TABLE sys_menu (
  menu_id bigint IDENTITY(1,1) NOT NULL,
  menu_name nvarchar(50) NOT NULL,
  parent_id bigint NULL DEFAULT 0,
  order_num int NULL DEFAULT 0,
  url nvarchar(200) NULL DEFAULT '#',
  target nvarchar(20) NULL DEFAULT '',
  menu_type char(1) NULL DEFAULT '',
  visible char(1) NULL DEFAULT '0',
  is_refresh char(1) NULL DEFAULT '1',
  perms nvarchar(100) NULL,
  icon nvarchar(100) NOT NULL DEFAULT '#',
  create_by nvarchar(64) NULL DEFAULT '',
  create_time datetime NULL,
  update_by nvarchar(64) NULL DEFAULT '',
  update_time datetime NULL,
  remark nvarchar(500) NULL DEFAULT '',
  CONSTRAINT PK_menu_id PRIMARY KEY CLUSTERED (menu_id)
) ON [PRIMARY];
GO

SET IDENTITY_INSERT sys_menu ON;

INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, url, target, menu_type, visible, is_refresh, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES
    (1, N'系统管理', 0, 4, '#', 'menuItem', 'M', '0', '1', '', 'fa fa-gear', 'admin', '2022-03-31T14:22:06', 'admin', '2022-03-31T15:05:06', N'系统管理目录'),
    (3, N'系统工具', 0, 6, '#', 'menuItem', 'M', '0', '1', '', 'fa fa-bars', 'admin', '2022-03-31T14:22:06', 'admin', '2022-03-31T15:05:21', N'系统工具目录'),
    (100, N'用户管理', 1, 1, '/system/user', '', 'C', '0', '1', 'system:user:view', 'fa fa-user-o', 'admin', '2022-03-31T14:22:06', NULL, NULL, N'用户管理菜单'),
    (101, N'角色管理', 1, 2, '/system/role', '', 'C', '0', '1', 'system:role:view', 'fa fa-user-secret', 'admin', '2022-03-31T14:22:06', NULL, NULL, N'角色管理菜单'),
    (102, N'菜单管理', 1, 3, '/system/menu', '', 'C', '0', '1', 'system:menu:view', 'fa fa-th-list', 'admin', '2022-03-31T14:22:06', NULL, NULL, N'菜单管理菜单'),
    (103, N'部门管理', 1, 4, '/system/dept', '', 'C', '0', '1', 'system:dept:view', 'fa fa-outdent', 'admin', '2022-03-31T14:22:06', NULL, NULL, N'部门管理菜单'),
    (104, N'岗位管理', 1, 5, '/system/post', '', 'C', '0', '1', 'system:post:view', 'fa fa-address-card-o', 'admin', '2022-03-31T14:22:06', NULL, NULL, N'岗位管理菜单'),
    (116, N'系统接口', 3, 3, '/tool/swagger', '', 'C', '0', '1', 'tool:swagger:view', 'fa fa-gg', 'admin', '2022-03-31T14:22:06', NULL, NULL, N'系统接口菜单'),
    (1000, N'用户查询', 100, 1, '#', '', 'F', '0', '1', 'system:user:list', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1001, N'用户新增', 100, 2, '#', '', 'F', '0', '1', 'system:user:add', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1002, N'用户修改', 100, 3, '#', '', 'F', '0', '1', 'system:user:edit', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1003, N'用户删除', 100, 4, '#', '', 'F', '0', '1', 'system:user:remove', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1004, N'用户导出', 100, 5, '#', '', 'F', '0', '1', 'system:user:export', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1005, N'用户导入', 100, 6, '#', '', 'F', '0', '1', 'system:user:import', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1006, N'重置密码', 100, 7, '#', '', 'F', '0', '1', 'system:user:resetPwd', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1007, N'角色查询', 101, 1, '#', '', 'F', '0', '1', 'system:role:list', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1008, N'角色新增', 101, 2, '#', '', 'F', '0', '1', 'system:role:add', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1009, N'角色修改', 101, 3, '#', '', 'F', '0', '1', 'system:role:edit', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1010, N'角色删除', 101, 4, '#', '', 'F', '0', '1', 'system:role:remove', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1011, N'角色导出', 101, 5, '#', '', 'F', '0', '1', 'system:role:export', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1012, N'菜单查询', 102, 1, '#', '', 'F', '0', '1', 'system:menu:list', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1013, N'菜单新增', 102, 2, '#', '', 'F', '0', '1', 'system:menu:add', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1014, N'菜单修改', 102, 3, '#', '', 'F', '0', '1', 'system:menu:edit', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1015, N'菜单删除', 102, 4, '#', '', 'F', '0', '1', 'system:menu:remove', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1016, N'部门查询', 103, 1, '#', '', 'F', '0', '1', 'system:dept:list', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1017, N'部门新增', 103, 2, '#', '', 'F', '0', '1', 'system:dept:add', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1018, N'部门修改', 103, 3, '#', '', 'F', '0', '1', 'system:dept:edit', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1019, N'部门删除', 103, 4, '#', '', 'F', '0', '1', 'system:dept:remove', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1020, N'岗位查询', 104, 1, '#', '', 'F', '0', '1', 'system:post:list', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1021, N'岗位新增', 104, 2, '#', '', 'F', '0', '1', 'system:post:add', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1022, N'岗位修改', 104, 3, '#', '', 'F', '0', '1', 'system:post:edit', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1023, N'岗位删除', 104, 4, '#', '', 'F', '0', '1', 'system:post:remove', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1024, N'岗位导出', 104, 5, '#', '', 'F', '0', '1', 'system:post:export', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1039, N'操作查询', 116, 1, '#', '', 'F', '0', '1', 'monitor:operlog:list', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1040, N'操作删除', 116, 2, '#', '', 'F', '0', '1', 'monitor:operlog:remove', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1041, N'详细信息', 116, 3, '#', '', 'F', '0', '1', 'monitor:operlog:detail', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1042, N'日志导出', 116, 4, '#', '', 'F', '0', '1', 'monitor:operlog:export', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1043, N'登录查询', 116, 5, '#', '', 'F', '0', '1', 'monitor:logininfor:list', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1044, N'登录删除', 116, 6, '#', '', 'F', '0', '1', 'monitor:logininfor:remove', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1045, N'日志导出', 116, 7, '#', '', 'F', '0', '1', 'monitor:logininfor:export', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1046, N'账户解锁', 116, 8, '#', '', 'F', '0', '1', 'monitor:logininfor:unlock', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1047, N'在线查询', 116, 9, '#', '', 'F', '0', '1', 'monitor:online:list', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1048, N'批量强退', 116, 10, '#', '', 'F', '0', '1', 'monitor:online:batchForceLogout', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1049, N'单条强退', 116, 11, '#', '', 'F', '0', '1', 'monitor:online:forceLogout', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1050, N'任务查询', 116, 12, '#', '', 'F', '0', '1', 'monitor:job:list', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1051, N'任务新增', 116, 13, '#', '', 'F', '0', '1', 'monitor:job:add', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1052, N'任务修改', 116, 14, '#', '', 'F', '0', '1', 'monitor:job:edit', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1053, N'任务删除', 116, 15, '#', '', 'F', '0', '1', 'monitor:job:remove', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1054, N'状态修改', 116, 16, '#', '', 'F', '0', '1', 'monitor:job:changeStatus', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1055, N'任务详细', 116, 17, '#', '', 'F', '0', '1', 'monitor:job:detail', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1056, N'任务导出', 116, 18, '#', '', 'F', '0', '1', 'monitor:job:export', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1057, N'生成查询', 116, 19, '#', '', 'F', '0', '1', 'tool:gen:list', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1058, N'生成修改', 116, 20, '#', '', 'F', '0', '1', 'tool:gen:edit', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1059, N'生成删除', 116, 21, '#', '', 'F', '0', '1', 'tool:gen:remove', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1060, N'预览代码', 116, 22, '#', '', 'F', '0', '1', 'tool:gen:preview', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (1061, N'生成代码', 116, 23, '#', '', 'F', '0', '1', 'tool:gen:code', '#', 'admin', '2022-03-31T14:22:06', NULL, NULL, ''),
    (2000, N'功能表', 0, 1, '#', 'menuItem', 'M', '0', '1', '', 'fa fa-bank', 'admin', '2022-03-31T15:02:44', 'admin', '2022-03-31T15:05:58', ''),
    (2001, N'待办任务', 0, 2, '#', 'menuItem', 'M', '0', '1', '', 'fa fa-bell-o', 'admin', '2022-03-31T15:04:15', 'admin', '2022-03-31T15:06:02', ''),
    (2002, N'流程管理', 0, 0, '#', 'menuItem', 'M', '0', '1', '', 'fa fa-balance-scale', 'admin', '2022-03-31T15:10:38', 'admin', '2022-04-01T11:06:44', ''),
    (2003, N'部署管理', 2002, 2, '/flow/manage', 'menuItem', 'C', '0', '1', '', 'fa fa-birthday-cake', 'admin', '2022-04-01T09:30:03', 'admin', '2022-04-02T08:45:49', ''),
    (2004, N'模型管理', 2002, 1, '/model/manage', 'menuItem', 'C', '0', '1', '', 'fa fa-glass', 'admin', '2022-04-01T11:00:23', 'admin', '2022-05-27T09:57:51', ''),
    (2005, N'请假申请', 2000, 1, '/leaveapply', 'menuItem', 'C', '0', '1', '', '#', 'admin', '2022-04-02T08:43:27', 'admin', '2022-04-02T14:25:38', ''),
    (2006, N'我的待办', 2001, 1, '/task/manage/mytask', 'menuItem', 'C', '0', '1', '', '#', 'admin', '2022-04-02T08:44:00', 'admin', '2022-04-13T14:10:52', ''),
    (2008, N'全部待办', 2001, 2, '/task/manage/alltasks', 'menuItem', 'C', '0', '1', '', '#', 'admin', '2022-04-02T08:44:24', 'admin', '2022-04-29T11:08:52', ''),
    (2012, N'采购申请', 2000, 2, '/purchase', 'menuItem', 'C', '0', '1', NULL, '#', 'admin', '2022-05-28T10:39:32', NULL, NULL, ''),
    (2013, N'发起会议', 2000, 3, '/meeting', 'menuItem', 'C', '0', '1', NULL, '#', 'admin', '2022-05-30T16:49:20', NULL, NULL, '');

SET IDENTITY_INSERT sys_menu OFF;
GO

IF OBJECT_ID('sys_post', 'U') IS NOT NULL
DROP TABLE sys_post;

CREATE TABLE sys_post (
  post_id bigint IDENTITY(1,1) NOT NULL,
  post_code nvarchar(64) NOT NULL,
  post_name nvarchar(50) NOT NULL,
  post_sort int NOT NULL,
  status char(1) NOT NULL,
  create_by nvarchar(64) DEFAULT '',
  create_time datetime2 DEFAULT NULL,
  update_by nvarchar(64) DEFAULT '',
  update_time datetime2 DEFAULT NULL,
  remark nvarchar(500) DEFAULT NULL,
  PRIMARY KEY (post_id)
);

SET IDENTITY_INSERT sys_post ON;

INSERT INTO sys_post (post_id, post_code, post_name, post_sort, status, create_by, create_time, update_by, update_time, remark)
VALUES
    (1, 'ceo', N'董事长', 1, '0', 'admin', '2022-05-26T15:25:37', NULL, NULL, NULL),
    (2, 'se', N'项目经理', 2, '0', 'admin', '2022-05-26T15:25:37', NULL, NULL, NULL),
    (3, 'hr', N'人力资源', 3, '0', 'admin', '2022-05-26T15:25:37', NULL, NULL, NULL),
    (4, 'user', N'普通员工', 4, '0', 'admin', '2022-05-26T15:25:37', NULL, NULL, NULL);

SET IDENTITY_INSERT sys_post OFF;


IF OBJECT_ID('sys_role', 'U') IS NOT NULL
DROP TABLE sys_role;
GO

CREATE TABLE sys_role (
  role_id bigint NOT NULL IDENTITY(1,1), -- 在SQL Server中建议使用bigint而不是bigint(20)
  role_name nvarchar(30) NOT NULL,
  role_key nvarchar(100) NOT NULL,
  role_sort int NOT NULL,
  data_scope char(1) DEFAULT '1',
  status char(1) NOT NULL,
  del_flag char(1) DEFAULT '0',
  create_by nvarchar(64) DEFAULT '',
  create_time datetime,
  update_by nvarchar(64) DEFAULT '',
  update_time datetime,
  remark nvarchar(500),
  CONSTRAINT PK_sys_role PRIMARY KEY CLUSTERED (role_id) -- SQL Server中的PRIMARY KEY语法
);
GO

-- 因为role_id是IDENTITY列，如果要手动插入ID，需要以下语句
SET IDENTITY_INSERT sys_role ON;
GO

INSERT INTO sys_role (role_id, role_name, role_key, role_sort, data_scope, status, del_flag, create_by, create_time, update_by, update_time, remark)
VALUES
(1, N'超级管理员', 'admin', 1, '1', '0', '0', 'admin', '2022-05-26 15:25:37', null, null, N'超级管理员'),
(2, N'普通角色', 'common', 2, '2', '0', '0', 'admin', '2022-05-26 15:25:37', 'admin', '2022-06-17 15:40:00', N'普通角色'),
(3, N'人事', 'HR', 3, '1', '0', '0', 'admin', '2024-03-20 23:33:57', null, null, null);
GO

SET IDENTITY_INSERT sys_role OFF;
GO

-- sys_role_dept表
IF OBJECT_ID('sys_role_dept', 'U') IS NOT NULL
DROP TABLE sys_role_dept;
GO

CREATE TABLE sys_role_dept (
   role_id bigint NOT NULL,
   dept_id bigint NOT NULL,
   CONSTRAINT PK_sys_role_dept PRIMARY KEY CLUSTERED (role_id, dept_id)
);
GO

INSERT INTO sys_role_dept (role_id, dept_id)
VALUES
(2, 100),
(2, 101),
(2, 105);
GO

-- sys_role_menu表
IF OBJECT_ID('sys_role_menu', 'U') IS NOT NULL
DROP TABLE sys_role_menu;
GO

CREATE TABLE sys_role_menu (
   role_id bigint NOT NULL,
   menu_id bigint NOT NULL,
   CONSTRAINT PK_sys_role_menu PRIMARY KEY CLUSTERED (role_id, menu_id)
);
GO

INSERT INTO sys_role_menu (role_id,menu_id) VALUES
(2,1),(2,2),(2,3),(2,100),(2,101),(2,102),(2,103),(2,104),(2,105),(2,106),(2,107),(2,108),(2,109),(2,110),(2,111),(2,112),(2,113),(2,114),(2,115),(2,116),(2,500),(2,501),(2,1000),(2,1001),(2,1002),(2,1003),(2,1004),(2,1005),(2,1006),(2,1007),(2,1008),(2,1009),(2,1010),(2,1011),(2,1012),(2,1013),(2,1014),(2,1015),(2,1016),(2,1017),(2,1018),(2,1019),(2,1020),(2,1021),(2,1022),(2,1023),(2,1024),(2,1025),(2,1026),(2,1027),(2,1028),(2,1029),(2,1030),(2,1031),(2,1032),(2,1033),(2,1034),(2,1035),(2,1036),(2,1037),(2,1038),(2,1039),(2,1040),(2,1041),(2,1042),(2,1043),(2,1044),(2,1045),(2,1046),(2,1047),(2,1048),(2,1049),(2,1050),(2,1051),(2,1052),(2,1053),(2,1054),(2,1055),(2,1056),(2,1057),(2,1058),(2,1059),(2,1060),(2,1061),(2,2000),(2,2001),(2,2002),(2,2003),(2,2004),(2,2005),(2,2006),(2,2007),(2,2009),(2,2011),(2,2012),(2,2013),(3,1),(3,3),(3,100),(3,101),(3,102),(3,103),(3,104),(3,116),(3,1000),(3,1001),(3,1002),(3,1003),(3,1004),(3,1005),(3,1006),(3,1007),(3,1008),(3,1009),(3,1010),(3,1011),(3,1012),(3,1013),(3,1014),(3,1015),(3,1016),(3,1017),(3,1018),(3,1019),(3,1020),(3,1021),(3,1022),(3,1023),(3,1024),(3,2000),(3,2001),(3,2003),(3,2004),(3,2005),(3,2006),(3,2007),(3,2008),(3,2012),(3,2013);

-- sys_user表
IF OBJECT_ID('sys_user', 'U') IS NOT NULL
DROP TABLE sys_user;
GO

CREATE TABLE sys_user (
  user_id bigint NOT NULL IDENTITY(1,1),
  dept_id bigint,
  login_name nvarchar(30) NOT NULL,
  user_name nvarchar(30) DEFAULT '',
  user_type nvarchar(2) DEFAULT '00',
  email nvarchar(50) DEFAULT '',
  phonenumber nvarchar(11) DEFAULT '',
  sex char(1) DEFAULT '0',
  avatar nvarchar(100) DEFAULT '',
  password nvarchar(50) DEFAULT '',
  salt nvarchar(20) DEFAULT '',
  status char(1) DEFAULT '0',
  del_flag char(1) DEFAULT '0',
  login_ip nvarchar(128) DEFAULT '',
  login_date datetime,
  pwd_update_date datetime,
  create_by nvarchar(64) DEFAULT '',
  create_time datetime,
  update_by nvarchar(64) DEFAULT '',
  update_time datetime,
  remark nvarchar(500),
  CONSTRAINT PK_sys_user PRIMARY KEY CLUSTERED (user_id)
);
GO

-- 开启手动插入IDENTITY列的值
SET IDENTITY_INSERT sys_user ON;
GO

INSERT INTO sys_user (user_id, dept_id, login_name, user_name, user_type, email, phonenumber, sex, avatar, password, salt, status, del_flag, login_ip, login_date, pwd_update_date, create_by, create_time, update_by, update_time, remark)
VALUES
(1, 103, 'admin', N'流程', '00', 'test@163.com', '15888888888', '1', '', '29c67a30398638269fe600f73a054934', '111111', '0', '0', '127.0.0.1', '2024-03-20 23:48:17', '2022-05-26 15:25:37', 'admin', '2022-05-26 15:25:37', null, '2024-03-20 23:48:16', N'管理员'),
(2, 105, 'ac', N'流程曼', '00', 'test@qq.com', '15666666666', '1', '', '84f1a6eddf7d8dd6a6164f3fe581a83f', '222222', '0', '0', '127.0.0.1', '2022-06-17 15:40:09', '2022-05-26 15:25:37', 'admin', '2022-05-26 15:25:37', 'admin', '2022-06-17 15:40:08', N'测试员'),
(3, 103, 'kobe', N'科比', '00', 'test@163.com', '15888888888', '1', '', '18f29f17b98fc15ee24b4575101c5085', '111111', '0', '0', '127.0.0.1', '2024-03-20 23:14:25', '2022-05-26 15:25:37', 'admin', '2022-05-26 15:25:37', null, '2024-03-20 23:14:25', N'管理员');
GO

-- 关闭手动插入IDENTITY列的值
SET IDENTITY_INSERT sys_user OFF;
GO

IF OBJECT_ID('sys_user_online', 'U') IS NOT NULL
DROP TABLE sys_user_online;

CREATE TABLE sys_user_online (
     session_id nvarchar(50) NOT NULL DEFAULT '' ,
     login_name nvarchar(50) DEFAULT '',
     dept_name nvarchar(50) DEFAULT '',
     ipaddr nvarchar(128) DEFAULT '',
     login_location nvarchar(255) DEFAULT '',
     browser nvarchar(50) DEFAULT '',
     os nvarchar(50) DEFAULT '',
     status nvarchar(10) DEFAULT '',
     start_timestamp datetime2 DEFAULT NULL,
     last_access_time datetime2 DEFAULT NULL,
     expire_time int DEFAULT '0',
     PRIMARY KEY (sessionId)
);

INSERT INTO sys_user_online
VALUES
    (
        '895c506f-c22f-498b-a5ff-dac1fe80553f',
        'admin',
        N'研发部门',
        '127.0.0.1',
        N'内网IP',
        'Chrome 12',
        'Windows 10',
        'on_line',
        '2024-03-20 21:31:30',
        '2024-03-20 23:48:17',
        1800000
    );

IF OBJECT_ID('sys_user_post', 'U') IS NOT NULL
DROP TABLE sys_user_post;

CREATE TABLE sys_user_post (
   user_id bigint NOT NULL,
   post_id bigint NOT NULL,
   PRIMARY KEY (user_id, post_id)
);

INSERT INTO sys_user_post
VALUES
    (1,1),
    (2,2);


IF OBJECT_ID('sys_user_role', 'U') IS NOT NULL
DROP TABLE sys_user_role;

CREATE TABLE sys_user_role (
   user_id bigint NOT NULL,
   role_id bigint NOT NULL,
   PRIMARY KEY (user_id, role_id)
);

INSERT INTO sys_user_role
VALUES
    (1,1),
    (2,2),
    (3,3);