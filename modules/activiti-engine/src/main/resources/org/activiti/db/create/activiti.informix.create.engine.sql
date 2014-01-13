create table ACT_GE_PROPERTY (
    NAME_ VARCHAR(64),
    VALUE_ VARCHAR(255),
    REV_ INTEGER,
    primary key (NAME_)
);

insert into ACT_GE_PROPERTY
values ('schema.version', '5.15-SNAPSHOT', 1);

insert into ACT_GE_PROPERTY
values ('schema.history', 'create(5.15-SNAPSHOT)', 1);

insert into ACT_GE_PROPERTY
values ('next.dbid', '1', 1);

create table ACT_GE_BYTEARRAY (
    ID_ VARCHAR(64),
    REV_ INTEGER,
    NAME_ VARCHAR(255),
    DEPLOYMENT_ID_ VARCHAR(64),
    BYTES_ BYTE IN TABLE,
    GENERATED_ BOOLEAN,
    primary key (ID_)
);

create table ACT_RE_DEPLOYMENT (
    ID_ VARCHAR(64),
    NAME_ VARCHAR(255),
    CATEGORY_ VARCHAR(255),
    TENANT_ID_ VARCHAR(255),
    DEPLOY_TIME_ DATETIME YEAR TO FRACTION(5),
    primary key (ID_)
);

create table ACT_RE_MODEL (
    ID_ VARCHAR(64) not null,
    REV_ INTEGER,
    NAME_ VARCHAR(255),
    KEY_ VARCHAR(255),
    CATEGORY_ VARCHAR(255),
    CREATE_TIME_ DATETIME YEAR TO FRACTION(5),
    LAST_UPDATE_TIME_ DATETIME YEAR TO FRACTION(5),
    VERSION_ INTEGER,
    META_INFO_ LVARCHAR(2000),
    DEPLOYMENT_ID_ VARCHAR(64),
    EDITOR_SOURCE_VALUE_ID_ VARCHAR(64),
    EDITOR_SOURCE_EXTRA_VALUE_ID_ VARCHAR(64),
    TENANT_ID_ VARCHAR(255),
    primary key (ID_)
);

create table ACT_RU_EXECUTION (
    ID_ VARCHAR(64),
    REV_ INTEGER,
    PROC_INST_ID_ VARCHAR(64),
    BUSINESS_KEY_ VARCHAR(255),
    PARENT_ID_ VARCHAR(64),
    PROC_DEF_ID_ VARCHAR(64),
    SUPER_EXEC_ VARCHAR(64),
    ACT_ID_ VARCHAR(255),
    IS_ACTIVE_ BOOLEAN,
    IS_CONCURRENT_ BOOLEAN,
    IS_SCOPE_ BOOLEAN,
    IS_EVENT_SCOPE_ BOOLEAN,
    SUSPENSION_STATE_ INTEGER,
    CACHED_ENT_STATE_ INTEGER,
    TENANT_ID_ VARCHAR(255),
    primary key (ID_)
);

create table ACT_RU_JOB (
    ID_ VARCHAR(64) NOT NULL,
    REV_ INTEGER,
    TYPE_ VARCHAR(255) NOT NULL,
    LOCK_EXP_TIME_ DATETIME YEAR TO FRACTION(5),
    LOCK_OWNER_ VARCHAR(255),
    EXCLUSIVE_ BOOLEAN,
    EXECUTION_ID_ VARCHAR(64),
    PROCESS_INSTANCE_ID_ VARCHAR(64),
    PROC_DEF_ID_ VARCHAR(64),
    RETRIES_ INTEGER,
    EXCEPTION_STACK_ID_ VARCHAR(64),
    EXCEPTION_MSG_ LVARCHAR(2000),
    DUEDATE_ DATETIME YEAR TO FRACTION(5),
    REPEAT_ VARCHAR(255),
    HANDLER_TYPE_ VARCHAR(255),
    HANDLER_CFG_ LVARCHAR(2000),
    TENANT_ID_ VARCHAR(255),
    primary key (ID_)
);

create table ACT_RE_PROCDEF (
    ID_ VARCHAR(64) NOT NULL,
    REV_ INTEGER,
    CATEGORY_ VARCHAR(255),
    NAME_ VARCHAR(255),
    KEY_ VARCHAR(255) NOT NULL,
    VERSION_ INTEGER NOT NULL,
    DEPLOYMENT_ID_ VARCHAR(64),
    RESOURCE_NAME_ LVARCHAR(2000),
    DGRM_RESOURCE_NAME_ LVARCHAR(4000),
    DESCRIPTION_ LVARCHAR(2000),
    HAS_START_FORM_KEY_ BOOLEAN,
    SUSPENSION_STATE_ INTEGER,
    TENANT_ID_ VARCHAR(255),
    primary key (ID_)
);

create table ACT_RU_TASK (
    ID_ VARCHAR(64),
    REV_ INTEGER,
    EXECUTION_ID_ VARCHAR(64),
    PROC_INST_ID_ VARCHAR(64),
    PROC_DEF_ID_ VARCHAR(64),
    NAME_ VARCHAR(255),
    PARENT_TASK_ID_ VARCHAR(64),
    DESCRIPTION_ LVARCHAR(2000),
    TASK_DEF_KEY_ VARCHAR(255),
    OWNER_ VARCHAR(255),
    ASSIGNEE_ VARCHAR(255),
    DELEGATION_ VARCHAR(64),
    PRIORITY_ INTEGER,
    CREATE_TIME_ DATETIME YEAR TO FRACTION(5),
    DUE_DATE_ DATETIME YEAR TO FRACTION(5),
    CATEGORY_ VARCHAR(255),
    SUSPENSION_STATE_ INTEGER,
    TENANT_ID_ VARCHAR(255),
    primary key (ID_)
);

create table ACT_RU_IDENTITYLINK (
    ID_ VARCHAR(64),
    REV_ INTEGER,
    GROUP_ID_ VARCHAR(255),
    TYPE_ VARCHAR(255),
    USER_ID_ VARCHAR(255),
    TASK_ID_ VARCHAR(64),
    PROC_INST_ID_ VARCHAR(64),
    PROC_DEF_ID_ VARCHAR(64),
    primary key (ID_)
);

create table ACT_RU_VARIABLE (
    ID_ VARCHAR(64) not null,
    REV_ INTEGER,
    TYPE_ VARCHAR(255) not null,
    NAME_ VARCHAR(255) not null,
    EXECUTION_ID_ VARCHAR(64),
    PROC_INST_ID_ VARCHAR(64),
    TASK_ID_ VARCHAR(64),
    BYTEARRAY_ID_ VARCHAR(64),
    DOUBLE_ DOUBLE PRECISION,
    LONG_ NUMERIC(19,0),
    TEXT_ LVARCHAR(2000),
    TEXT2_ LVARCHAR(2000),
    primary key (ID_)
);

create table ACT_RU_EVENT_SUBSCR (
    ID_ VARCHAR(64) not null,
    REV_ integer,
    EVENT_TYPE_ VARCHAR(255) not null,
    EVENT_NAME_ VARCHAR(255),
    EXECUTION_ID_ VARCHAR(64),
    PROC_INST_ID_ VARCHAR(64),
    ACTIVITY_ID_ VARCHAR(64),
    CONFIGURATION_ VARCHAR(255),
    CREATED_ DATETIME YEAR TO FRACTION(5) not null,
    primary key (ID_)
);

create index ACT_IDX_EXEC_BUSKEY on ACT_RU_EXECUTION(BUSINESS_KEY_);
create index ACT_IDX_TASK_CREATE on ACT_RU_TASK(CREATE_TIME_);
create index ACT_IDX_IDENT_LNK_USER on ACT_RU_IDENTITYLINK(USER_ID_);
create index ACT_IDX_IDENT_LNK_GROUP on ACT_RU_IDENTITYLINK(GROUP_ID_);
create index ACT_IDX_EVENT_SUBSCR_CONFIG_ on ACT_RU_EVENT_SUBSCR(CONFIGURATION_);
create index ACT_IDX_VARIABLE_TASK_ID on ACT_RU_VARIABLE(TASK_ID_);

create index ACT_IDX_BYTEAR_DEPL on ACT_GE_BYTEARRAY(DEPLOYMENT_ID_);
alter table ACT_GE_BYTEARRAY
    add constraint foreign key (DEPLOYMENT_ID_) 
    references ACT_RE_DEPLOYMENT (ID_)
	constraint ACT_FK_BYTEARR_DEPL;

alter table ACT_RE_PROCDEF
    add constraint unique (KEY_,VERSION_)
	constraint ACT_UNIQ_PROCDEF;
    
create index ACT_IDX_EXE_PROCINST on ACT_RU_EXECUTION(PROC_INST_ID_);
alter table ACT_RU_EXECUTION
    add constraint foreign key (PROC_INST_ID_)
    references ACT_RU_EXECUTION (ID_)
	constraint ACT_FK_EXE_PROCINST;

create index ACT_IDX_EXE_PARENT on ACT_RU_EXECUTION(PARENT_ID_);
alter table ACT_RU_EXECUTION
    add constraint foreign key (PARENT_ID_) 
    references ACT_RU_EXECUTION (ID_)
	constraint ACT_FK_EXE_PARENT;
    
create index ACT_IDX_EXE_SUPER on ACT_RU_EXECUTION(SUPER_EXEC_);
alter table ACT_RU_EXECUTION
    add constraint foreign key (SUPER_EXEC_)
	references ACT_RU_EXECUTION (ID_)
	constraint ACT_FK_EXE_SUPER;
    
create index ACT_IDX_EXE_PROCDEF on ACT_RU_EXECUTION(PROC_DEF_ID_);
alter table ACT_RU_EXECUTION
    add constraint foreign key (PROC_DEF_ID_) 
    references ACT_RE_PROCDEF (ID_)
	constraint ACT_FK_EXE_PROCDEF;    

create index ACT_IDX_TSKASS_TASK on ACT_RU_IDENTITYLINK(TASK_ID_);
alter table ACT_RU_IDENTITYLINK
    add constraint foreign key (TASK_ID_) 
    references ACT_RU_TASK (ID_)
	constraint ACT_FK_TSKASS_TASK;

create index ACT_IDX_ATHRZ_PROCEDEF on ACT_RU_IDENTITYLINK(PROC_DEF_ID_);
alter table ACT_RU_IDENTITYLINK
    add constraint foreign key (PROC_DEF_ID_) 
    references ACT_RE_PROCDEF (ID_)
	constraint ACT_FK_ATHRZ_PROCEDEF;
    
create index ACT_IDX_IDL_PROCINST on ACT_RU_IDENTITYLINK(PROC_INST_ID_);
alter table ACT_RU_IDENTITYLINK
    add constraint foreign key (PROC_INST_ID_) 
    references ACT_RU_EXECUTION (ID_)
	constraint ACT_FK_IDL_PROCINST;    

create index ACT_IDX_TASK_EXEC on ACT_RU_TASK(EXECUTION_ID_);
alter table ACT_RU_TASK
    add constraint foreign key (EXECUTION_ID_)
    references ACT_RU_EXECUTION (ID_)
	constraint ACT_FK_TASK_EXE;
    
create index ACT_IDX_TASK_PROCINST on ACT_RU_TASK(PROC_INST_ID_);
alter table ACT_RU_TASK
    add constraint foreign key (PROC_INST_ID_)
    references ACT_RU_EXECUTION (ID_)
	constraint ACT_FK_TASK_PROCINST;
    
create index ACT_IDX_TASK_PROCDEF on ACT_RU_TASK(PROC_DEF_ID_);
alter table ACT_RU_TASK
  add constraint foreign key (PROC_DEF_ID_)
  references ACT_RE_PROCDEF (ID_)
  constraint ACT_FK_TASK_PROCDEF;
  
create index ACT_IDX_VAR_EXE on ACT_RU_VARIABLE(EXECUTION_ID_);
alter table ACT_RU_VARIABLE 
    add constraint foreign key (EXECUTION_ID_) 
    references ACT_RU_EXECUTION (ID_)
	constraint ACT_FK_VAR_EXE;

create index ACT_IDX_VAR_PROCINST on ACT_RU_VARIABLE(PROC_INST_ID_);
alter table ACT_RU_VARIABLE
    add constraint foreign key (PROC_INST_ID_)
    references ACT_RU_EXECUTION(ID_)
	constraint ACT_FK_VAR_PROCINST;

create index ACT_IDX_VAR_BYTEARRAY on ACT_RU_VARIABLE(BYTEARRAY_ID_);
alter table ACT_RU_VARIABLE 
    add constraint foreign key (BYTEARRAY_ID_) 
    references ACT_GE_BYTEARRAY (ID_)
	constraint ACT_FK_VAR_BYTEARRAY ;

create index ACT_IDX_JOB_EXCEPTION on ACT_RU_JOB(EXCEPTION_STACK_ID_);
alter table ACT_RU_JOB 
    add constraint foreign key (EXCEPTION_STACK_ID_) 
    references ACT_GE_BYTEARRAY (ID_)
	constraint ACT_FK_JOB_EXCEPTION;
    
create index ACT_IDX_EVENT_SUBSCR on ACT_RU_EVENT_SUBSCR(EXECUTION_ID_);
alter table ACT_RU_EVENT_SUBSCR
    add constraint foreign key (EXECUTION_ID_)
    references ACT_RU_EXECUTION(ID_)
	constraint ACT_FK_EVENT_EXEC;

create index ACT_IDX_MODEL_SOURCE on ACT_RE_MODEL(EDITOR_SOURCE_VALUE_ID_);
alter table ACT_RE_MODEL 
    add constraint foreign key (EDITOR_SOURCE_VALUE_ID_) 
    references ACT_GE_BYTEARRAY (ID_)
	constraint ACT_FK_MODEL_SOURCE;

create index ACT_IDX_MODEL_SOURCE_EXTRA on ACT_RE_MODEL(EDITOR_SOURCE_EXTRA_VALUE_ID_);
alter table ACT_RE_MODEL 
    add constraint foreign key (EDITOR_SOURCE_EXTRA_VALUE_ID_) 
    references ACT_GE_BYTEARRAY (ID_)
	constraint ACT_FK_MODEL_SOURCE_EXTRA;
    
create index ACT_IDX_MODEL_DEPLOYMENT on ACT_RE_MODEL(DEPLOYMENT_ID_);    
alter table ACT_RE_MODEL 
    add constraint foreign key (DEPLOYMENT_ID_) 
    references ACT_RE_DEPLOYMENT (ID_)
	constraint ACT_FK_MODEL_DEPLOYMENT;        
