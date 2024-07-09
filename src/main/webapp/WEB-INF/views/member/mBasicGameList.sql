create table itGameList (
	glIdx int not null auto_increment primary key,
	glMid varchar(30) not null,
	gamelist varchar(40) default '1222/99/47/1224/1225/1226/1227',
	foreign key(glMid) references itMember(mid) on update cascade on delete cascade
);