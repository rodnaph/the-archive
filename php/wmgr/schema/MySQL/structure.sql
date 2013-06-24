
create table users (
	id int unsigned not null auto_increment,
	name varchar(50) not null,
	pass char(32) not null,
	email varchar(255) not null,
	date_created datetime not null,
	primary key ( id ),
	unique ( name )
);







--
--  documents
--

create table doc_folders (
	id int unsigned not null auto_increment,
	name varchar(50) not null,
	parent_id int unsigned not null,
	constraint PKdoc_folders primary key ( id ),
	constraint FKdoc_folders_parent foreign key ( parent_id ) references doc_folders ( id )
);

create table doc_folder_hierarchy (
	doc_id int unsigned not null,
	tree_id int unsigned not null,
	left_node smallint unsigned not null,
	right_node smallint unsigned not null,
	constraint FKdoc_folder_hierarchy foreign key ( doc_id ) references docs ( id )
);

create table docs (
	id int unsigned not null auto_increment,
	user_id int unsigned not null,
	group_id int unsigned not null,
	folder_id int unsigned null,
	date_created datetime not null,
	name varchar(100) not null,
	bin_size int unsigned not null,
	bin_type varchar(50) not null,
	constraint PKdocs primary key ( id ),
	constraint FKdocs_user foreign key ( user_id ) references users ( id ),
	constraint FKdocs_folder foreign key ( folder_id ) references doc_folders ( id )
);

create table doc_data (
	id int unsigned not null auto_increment,
	doc_id int unsigned not null,
	bin_data longblob not null,
	unique ( doc_id ),
	primary key ( id )
);





--
--  icons
--

create table icons (
	id int not null auto_increment,
	name varchar(50) not null,
	filename varchar(100) not null,
	unique ( name ),
	unique ( filename ),
	primary key ( id )
);





--
--  groups
--

create table groups (
	id int unsigned not null auto_increment,
	name varchar(50),
	date_created datetime not null,
	primary key ( id ),
	unique ( name )
);

create table group_users (
	user_id int unsigned not null,
	group_id int unsigned not null,
	date_joined datetime not null,
	primary key ( user_id, group_id ),
	index ( group_id )
);

create table group_pending (
	user_id int unsigned not null,
	group_id int unsigned not null,
	date_requested datetime not null,
	primary key ( user_id, group_id ),
	index ( group_id )
);

create table group_tags (
	id int unsigned not null auto_increment,
	group_id int unsigned not null,
	name varchar(50) not null,
	primary key ( id ),
	unique ( group_id, name ),
	index ( group_id )
);





--
--  projects
--

create table projects (
	id int unsigned not null auto_increment,
	name varchar(50) not null,
	parent_id int unsigned null,
	group_id int unsigned not null,
	page_id int unsigned null,
	date_created datetime not null,
	primary key ( id )
);

create table project_hierarchy (
	tree_id smallint unsigned not null,
	project_id int unsigned not null,
	left_node smallint unsigned not null,
	right_node smallint unsigned not null
);

create table project_users (
	user_id int unsigned not null,
	project_id int unsigned not null,
	primary key ( user_id, project_id )
);







--
--  tasks
--

create table task_status (
	id int unsigned not null auto_increment,
	name varchar(50) not null,
	closed smallint not null,
	icon int unsigned null,
	unique ( name ),
	primary key ( id )
);

create table task_types (
	id int unsigned not null auto_increment,
	name varchar(50) not null,
	icon int unsigned null,
	unique ( name ),
	primary key ( id )
);

create table task_priorities (
	id int unsigned not null auto_increment,
	name varchar(50) not null,
	icon int unsigned null,
	unique ( name ),
	primary key ( id )
);

create table tasks (
	id int unsigned not null auto_increment,
	primary key ( id )
);

create table task_history (
	id int unsigned not null auto_increment,
	name varchar(50) not null,
	task_id int unsigned not null,
	user_id int unsigned not null,
	project_id int unsigned not null,
	status_id int unsigned not null,
	type_id int unsigned not null,
	priority_id int unsigned not null,
	date_actioned datetime not null,
	description text not null,
	primary key ( id ),
	index ( task_id )
);

create table task_users (
	task_id int unsigned not null,
	user_id int unsigned not null,
	primary key ( task_id, user_id )
);

create table task_docs (
	task_history_id int unsigned not null,
	doc_id int unsigned not null,
	primary key ( task_history_id, doc_id )
);





--
--  pages
--

create table pages (
	id int unsigned not null auto_increment,
	user_id int unsigned not null,
	group_id int unsigned not null,
	name varchar(100) not null,
	body text not null,
	parent_id int unsigned null,
	date_edited datetime not null,
	date_created datetime not null,
	primary key ( id ),
	unique ( group_id, name )
);

create table page_history (
	id int unsigned not null auto_increment,
	page_id int unsigned not null,
	user_id int unsigned not null,
	body text not null,
	date_edited datetime not null,
	primary key ( id )
);

create table page_projects (
	page_id int unsigned not null,
	project_id int unsigned not null,
	primary key ( page_id, project_id )
);

create table page_hierarchy (
	tree_id int unsigned not null,
	page_id int unsigned not null,
	left_node int unsigned not null,
	right_node int unsigned not null
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
	on n.id = i.newest
	inner join task_history o
	on o.id = i.oldest
	inner join users c
	on c.id = o.user_id
	inner join task_status s
	on s.id = n.status_id
	inner join task_types ty
	on ty.id = n.type_id
	inner join task_priorities p
	on p.id = n.priority_id
	left outer join icons tyi
	on tyi.id = ty.icon
	left outer join icons si
	on si.id = s.icon
	left outer join icons pi
	on pi.id = p.icon
	inner join projects pr
	on pr.id = n.project_id
	inner join groups gr
	on gr.id = pr.group_id;
