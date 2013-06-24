
create table users (
	id int not null identity(1,1),
	name varchar(50) not null,
	pass char(32) not null,
	email varchar(255) not null,
	date_created datetime not null,
	constraint PKusers primary key ( id ),
	constraint UKusers_name unique ( name )
);







--
--  documents
--

create table doc_folders (
	id int not null auto_increment,
	name varchar(50) not null,
	parent_id int not null,
	constraint PKdoc_folders primary key ( id ),
	constraint FKdoc_folders_parent foreign key ( parent_id ) references doc_folders ( id )
);

create table doc_folder_hierarchy (
	doc_id int not null,
	tree_id int not null,
	left_node smallint not null,
	right_node smallint not null,
	constraint FKdoc_folder_hierarchy foreign key ( doc_id ) references docs ( id )
);

create table docs (
	id int not null identity(1,1),
	user_id int not null,
	group_id int not null,
	folder_id int unsigned null,
	date_created datetime not null,
	name varchar(100) not null,
	bin_size int not null,
	bin_type varchar(50) not null,
	constraint PKdocs primary key ( id ),
	constraint FKdocs_user_user foreign key ( user_id ) references users ( id ),
	constraint FKdocs_folder foreign key ( folder_id ) references doc_folders ( id )
);

create table doc_data (
	id int not null identity(1,1),
	doc_id int not null,
	bin_data image not null,
	constraint UKdoc_data_doc_id unique ( doc_id ),
	constraint PKdoc_data primary key ( id ),
	constraint FKdoc_data_doc foreign key ( doc_id ) references docs ( id )
);





--
--  icons
--

create table icons (
	id int not null identity(1,1),
	name varchar(50) not null,
	filename varchar(100) not null,
	constraint UKicons_name unique ( name ),
	constraint UKicons_filename unique ( filename ),
	constraint PKicons primary key ( id )
);





--
--  groups
--

create table groups (
	id int not null identity(1,1),
	name varchar(50),
	date_created datetime not null,
	constraint PKgroups primary key ( id ),
	constraint UKgroups_name unique ( name )
);

create table group_users (
	user_id int not null,
	group_id int not null,
	date_joined datetime not null,
	constraint PKgroup_users primary key ( user_id, group_id ),
	constraint FKgroup_users_user foreign key ( user_id ) references users ( id ),
	constraint FKgroup_users_group foreign key ( group_id ) references groups ( id )
);

create table group_pending (
	user_id int not null,
	group_id int not null,
	date_requested datetime not null,
	constraint PKgroup_pending primary key ( user_id, group_id ),
	constraint FKgroup_pending_user foreign key ( user_id ) references users ( id ),
	constraint FKgroup_pending_group foreign key ( group_id ) references groups ( id )
);

create table group_tags (
	id int not null identity(1,1),
	group_id int not null,
	name varchar(50) not null,
	constraint PKgroup_tags primary key ( id ),
	constraint UKgroup_tags_group_name unique ( group_id, name ),
	constraint FKgroup_tags_group foreign key ( group_id ) references groups ( id )
);






--
--  pages
--

create table pages (
	id int not null identity(1,1),
	user_id int not null,
	group_id int not null,
	name varchar(100) not null,
	body text not null,
	parent_id int null,
	date_edited datetime not null,
	date_created datetime not null,
	constraint PKpages primary key ( id ),
	constraint UKpages_group_name unique ( group_id, name ),
	constraint FKpages_user foreign key ( user_id ) references users ( id ),
	constraint FKpages_group foreign key ( group_id ) references groups ( id ),
	constraint FKpages_parent foreign key ( parent_id ) references pages ( id )
);

create table page_history (
	id int not null identity(1,1),
	page_id int not null,
	user_id int not null,
	body text not null,
	date_edited datetime not null,
	constraint PKpage_history primary key ( id ),
	constraint FKpage_history_page foreign key ( page_id ) references pages ( id ),
	constraint FKpage_history_user foreign key ( user_id ) references users ( id )
);

create table page_projects (
	page_id int not null,
	project_id int not null,
	constraint PKpage_projects primary key ( page_id, project_id ),
	constraint FKpage_projects_page foreign key ( page_id ) references pages ( id ),
	constraint FKpage_projects_project foreign key ( project_id ) references projects ( id )
);

create table page_hierarchy (
	tree_id int not null,
	page_id int not null,
	left_node int not null,
	right_node int not null,
	constraint FKpage_hierarchy_page foreign key ( page_id ) references pages ( id )
);





--
--  projects
--

create table projects (
	id int not null identity(1,1),
	name varchar(50) not null,
	group_id int not null,
	parent_id int null,
	page_id int null,
	date_created datetime not null,
	constraint PKprojects primary key ( id ),
	constraint FKprojects_group foreign key ( group_id ) references groups ( id ),
	constraint FKprojects_parent foreign key ( parent_id ) references parents ( id ),
	constraint FKprojects_page foreign key ( page_id ) references pages ( id )
);

create table project_hierarchy (
	tree_id int not null,
	project_id int not null,
	left_node int not null,
	right_node int not null,
	constraint FKproject_hierarchy_project foreign key ( project_id ) references projects ( id )
);

create table project_users (
	user_id int not null,
	project_id int not null,
	constraint PKproject_users primary key ( user_id, project_id ),
	constraint FKprojects_users_user foreign key ( user_id ) references users ( id ),
	constraint FKprojects_users_project foreign key ( project_id ) references projects ( id )
);







--
--  tasks
--

create table task_status (
	id int not null identity(1,1),
	name varchar(50) not null,
	closed smallint not null,
	icon int null,
	constraint UKtask_status_name unique ( name ),
	constraint PKtask_status primary key ( id ),
	constraint FKtask_status_icon foreign key ( icon ) references icons ( id )
);

create table task_types (
	id int not null identity(1,1),
	name varchar(50) not null,
	icon int null,
	constraint UKtask_types_name unique ( name ),
	constraint PKtask_types primary key ( id ),
	constraint FKtask_types_icon foreign key ( icon ) references icons ( id )
);

create table task_priorities (
	id int not null identity(1,1),
	name varchar(50) not null,
	icon int null,
	constraint UKtask_priorities_name unique ( name ),
	constraint PKtask_priorities primary key ( id ),
	constraint FKtask_priorities_icon foreign key ( icon ) references icons ( id )
);

create table tasks (
	id int not null identity(1,1),
	constraint PKtasks primary key ( id )
);

create table task_history (
	id int not null identity(1,1),
	name varchar(50) not null,
	task_id int not null,
	user_id int not null,
	project_id int not null,
	status_id int not null,
	type_id int not null,
	priority_id int not null,
	date_actioned datetime not null,
	description text not null,
	constraint PKtask_history primary key ( id ),
	constraint FKtask_history_task foreign key ( task_id ) references tasks ( id ),
	constraint FKtask_history_user foreign key ( user_id ) references users ( id ),
	constraint FKtask_history_status foreign key ( status_id ) references task_status ( id ),
	constraint FKtask_history_type foreign key ( type_id ) references task_types ( id ),
	constraint FKtask_history_priority foreign key ( priority_id ) references task_priorities ( id ),
	constraint FKtask_history_project foreign key ( project_id ) references projects ( id )
);

create table task_users (
	task_id int not null,
	user_id int not null,
	constraint PKtask_users primary key ( task_id, user_id ),
	constraint FKtask_users_task foreign key ( task_id ) references tasks ( id ),
	constraint FKtask_users_user foreign key ( user_id ) references users ( id )
);

create table task_docs (
	task_history_id int not null,
	doc_id int not null,
	constraint PKtask_docs primary key ( task_history_id, doc_id ),
	constraint FKtask_docs_history foreign key ( task_history_id ) references task_history ( id ),
	constraint FKtask_docs_doc foreign key ( doc_id ) references docs ( id )
);










--
--  user_links
--

create table user_feeds (
	id int unsigned not null auto_increment,
	user_id int unsigned not null,
	name varchar(50) not null,
	url varchar(255) not null,
	constraint PKuser_feeds primary key ( id ),
	constraint FKuser_feeds_user foreign key ( user_id ) references users ( id )
);







--
--  views
--

create view vTaskInfo
as
select h.task_id, max(h.id) as newest, min(h.id) as oldest
from task_history h
group by h.task_id;

--
--  displays task information
--

create view vTasks
as
select t.id,
	n.name, o.description, n.date_actioned as dateUpdated, n.id as historyID,
	o.date_actioned as dateCreated,
	c.id as creatorID, c.name as creatorName, c.email as creatorEmail,
	s.id as statusID, s.name as statusName, s.closed as statusClosed,
	si.id as statusIconID, si.name as statusIconName, si.filename as statusIconFile,
	ty.id as typeID, ty.name as typeName,
	tyi.id as typeIconID, tyi.name as typeIconName, tyi.filename as typeIconFile,
	p.id as priorityID, p.name as priorityName,
	pi.id as priorityIconID, pi.name as priorityIconName, pi.filename as priorityIconFile,
	pr.id as projectID, pr.name as projectName, pr.parent_id as projectParentID,
	gr.id as projectGroupID, gr.name as projectGroupName
from tasks t
	inner join vTaskInfo i
	on i.task_id = t.id
	inner join task_history n
		inner join projects pr
			inner join groups gr
			on gr.id = pr.group_id
		on pr.id = n.project_id
		inner join task_status s
			left outer join icons si
			on si.id = s.icon
		on s.id = n.status_id
		inner join task_types ty
			left outer join icons tyi
			on tyi.id = ty.icon
		on ty.id = n.type_id
		inner join task_priorities p
			left outer join icons pi
			on pi.id = p.icon
		on p.id = n.priority_id
	on n.id = i.newest
	inner join task_history o
		inner join users c
		on c.id = o.user_id
	on o.id = i.oldest;
