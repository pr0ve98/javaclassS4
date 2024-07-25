show tables;

create table itMember (
	idx int not null auto_increment,
	mid varchar(30) not null,					/* 아이디 */
	nickname varchar(30) not null,				/* 닉네임 */
	email varchar(60) not null,					/* 이메일 */
	pwd varchar(100) not null,					/* 비밀번호 */
	memImg varchar(200) default 'noimage.jpg',	/* 프로필 이미지 */
	level int default 2,						/* 권한(일반:2, 우수:1, GM:0) */
	title varchar(300),							/* 칭호 */
	primary key(idx),
	unique(mid),
	unique(email)
);

drop table itMember;

create table itFollow (
	myMid varchar(30) not null,
	youMid varchar(30) not null
);

ALTER TABLE itFollow CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;