
drop table if exists threads;
create table threads (

	id int not null auto_increment primary key

) type = innodb;

drop table if exists colors;
create table colors (

	id int not null auto_increment primary key,
	description varchar(30) not null,
	hex_value char(6) not null

) type = innodb;

drop table if exists users;
create table users (

	id int not null auto_increment primary key,
	name varchar(50) not null,
	pass varchar(30) not null,
	email varchar(100) not null,
	created datetime not null,
	color int not null references colors(id)

) type = innodb;

drop table if exists posts;
create table posts (

	id int not null auto_increment primary key,
	thread int not null references threads(id),
	posted datetime not null,
	user int not null references users(id),
	parent int references posts(id),
	subject varchar(60) not null,
	body text not null,
	line_breaks bit not null default 1

) type = innodb;

drop table if exists errors;
create table errors (

	id int not null auto_increment primary key,
	user_desc text not null,
	sys_desc text,
	occurred datetime not null

) type = myisam;

drop table if exists amendments;
create table amendments (

	id int not null auto_increment primary key,
	post int not null references posts(id),
	amended datetime not null,
	subject varchar(60) not null,
	body text not null,
	line_breaks bit not null default 1,
	public bit not null default 1

) type = innodb;

insert into colors ( description, hex_value ) values ( 'black', '000000' );
