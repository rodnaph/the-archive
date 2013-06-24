
create table users (
	id int unsigned not null auto_increment,
	name varchar(50) not null unique,
	pass char(32) not null,
	date_created datetime not null,
	primary key ( id )
);

create table pages (
	id int unsigned not null auto_increment,
	name varchar(255) not null unique,
	date_edited datetime not null,
	body text not null,
	user_id int unsigned not null,
	primary key ( id )
);

create table bug_status (
	id int unsigned not null,
	name varchar(255) not null unique,
	primary key ( id )
);

create table bug_comments (
	id int unsigned not null auto_increment,
	body text not null,
	user_name varchar(50) not null,
	bug_id int unsigned not null,
	date_posted datetime not null,
	primary key ( id )
);

create table bugs (
	id int unsigned not null auto_increment,
	name varchar(50) not null,
	body text not null,
	user_name varchar(50) not null,
	date_created datetime not null,
	bug_status_id int unsigned not null,
	primary key ( id )
);

CREATE TABLE `comments` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `page_id` int(10) unsigned NOT NULL default '0',
  `name` varchar(50) NOT NULL default '',
  `email` varchar(255) default NULL,
  `body` text NOT NULL,
  `date_posted` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

create table enigform_users (
	id int unsigned not null auto_increment,
	name varchar(50) not null,
	gpgkeyid varchar(50) not null,
	unique ( name ),
	unique ( gpgkeyid ),
	primary key ( id )
);
