
-- default icons
insert into icons ( name, filename ) values ( 'Low Priority', 'priority_low.png' );
insert into icons ( name, filename ) values ( 'Medium Priority', 'priority_medium.png' );
insert into icons ( name, filename ) values ( 'High Priority', 'priority_high.png' );
insert into icons ( name, filename ) values ( 'Bug', 'type_bug.png' );
insert into icons ( name, filename ) values ( 'Feature', 'type_feature.png' );
insert into icons ( name, filename ) values ( 'Pending', 'status_pending.png' );
insert into icons ( name, filename ) values ( 'Accepted', 'status_accepted.png' );
insert into icons ( name, filename ) values ( 'Rejected', 'status_rejected.png' );
insert into icons ( name, filename ) values ( 'Closed', 'status_closed' );

-- task priorities
insert into task_priorities ( name, icon ) values ( 'Low Priority', 1 );
insert into task_priorities ( name, icon ) values ( 'Medium Priority', 2 );
insert into task_priorities ( name, icon ) values ( 'High Priority', 3 );

-- task types
insert into task_types ( name, icon ) values ( 'Bug', 4 );
insert into task_types ( name, icon ) values ( 'Feature', 5 );

-- task status
insert into task_status ( name, closed, icon ) values ( 'Pending', 0, 6 );
insert into task_status ( name, closed, icon ) values ( 'Accepted', 0, 7 );
insert into task_status ( name, closed, icon ) values ( 'Rejected', 1, 8 );
insert into task_status ( name, closed, icon ) values ( 'Closed', 1, 9 );

-- create a default user (password is 'admin')
insert into users ( name, pass, email, date_created )
values ( 'admin', '21232f297a57a5a743894a0e4a801fc3', 'noemail@nowhere.net', now() );
