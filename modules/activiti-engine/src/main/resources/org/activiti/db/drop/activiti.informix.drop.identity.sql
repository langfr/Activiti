alter table ACT_ID_MEMBERSHIP 
    drop CONSTRAINT ACT_FK_MEMB_GROUP;
    
alter table ACT_ID_MEMBERSHIP 
    drop CONSTRAINT ACT_FK_MEMB_USER;

drop index if exists ACT_IDX_MEMB_GROUP;
drop index if exists ACT_IDX_MEMB_USER;

drop table if exists ACT_ID_INFO;
drop table if exists ACT_ID_MEMBERSHIP;
drop table if exists ACT_ID_GROUP;
drop table if exists ACT_ID_USER;
