show tables;

create table itCommunity (
	cmIdx int not null auto_increment primary key,
	mid varchar(30) not null,	/* 작성자 */
	section char(4) not null,	/* 피드 / 뉴스 구분 */
	part varchar(20) not null,	/* 카테고리 구분 */
	cmGameIdx int,	/* 주제 게임 idx */
	cmContent longtext,			/* 내용 */
	cmDate datetime,			/* 작성시간 */
	cmHostIp varchar(30),		/* 작성아이피 */
	foreign key(mid) references itMember(mid) on update cascade on delete cascade,
	foreign key(cmGameIdx) references itGame(gameIdx) on delete cascade
);