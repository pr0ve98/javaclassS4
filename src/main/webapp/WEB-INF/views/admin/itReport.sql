create table itReport (
	reIdx int not null auto_increment primary key,
	reportMid varchar(30) not null,
	sufferMid varchar(30) not null,
	contentPart char(3) not null,
	contentIdx int not null,
	reason varchar(50) not null,
	complete int not null default 0
);

create table itBan (
	banMid varchar(30) not null primary key,
	banDay int not null default 3,
	banTime datetime default now()
);

create table itSupport (
	supIdx int not null auto_increment primary key,
	supEmail varchar(100) not null,
	main varchar(50) not null,
	sub varchar(30),
	supContent text not null,
	supImg varchar(200),
	supComplete int not null default 0
);