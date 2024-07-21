show tables;

create table itCommunity (
	cmIdx int not null auto_increment primary key,
	mid varchar(30) not null,	/* 작성자 */
	section char(4) not null,	/* 피드 / 뉴스 구분 */
	part varchar(20) not null,	/* 카테고리 구분 */
	cmGameIdx int,	/* 주제 게임 idx */
	cmContent longtext,			/* 내용 */
	cmDate datetime default now(),			/* 작성시간 */
	cmHostIp varchar(30),		/* 작성아이피 */
	publicType char(3),
	foreign key(mid) references itMember(mid) on update cascade on delete cascade,
	foreign key(cmGameIdx) references itGame(gameIdx) on delete cascade
);

drop table itCommunity;

create table itLike (
	likeIdx int not null auto_increment primary key,
	likeCmIdx int not null,
	likeMid varchar(30) not null,
	foreign key(likeCmIdx) references itCommunity(cmIdx) on delete cascade,
	foreign key(likeMid) references itMember(mid) on delete cascade
);

create table itReply (
	replyIdx int not null auto_increment primary key,
	replyCmIdx int not null,
	replyMid varchar(30) not null,
	replyParantIdx int,
	replyContent varchar(400) not null,
	replyHostIp varchar(30) not null,
	replyDate datetime default now(),
	foreign key(replyParantIdx) references itReply(replyIdx) on delete cascade
);

ALTER TABLE itReview CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;