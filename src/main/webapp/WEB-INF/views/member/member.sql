show tables;

create table itMember (
	idx int not null auto_increment,
	mid varchar(30) not null,
	nickname varchar(30) not null,
	email varchar(60) not null,
	pwd varchar(100) not null,
	primary key(idx),
	unique(mid),
	unique(email)
);

drop table itMember;