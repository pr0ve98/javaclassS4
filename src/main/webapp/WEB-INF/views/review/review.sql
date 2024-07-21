show tables;

create table itReview (
	revIdx int not null auto_increment primary key,
	revMid varchar(30) not null,
	revGameIdx int not null,
	rating int not null,
	state varchar(30) default '상태없음'
);
