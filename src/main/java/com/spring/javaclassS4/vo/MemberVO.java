package com.spring.javaclassS4.vo;

import lombok.Data;

@Data
public class MemberVO {
	private int idx;
	private String mid;
	private String nickname;
	private String email;
	private String pwd;
	private String memImg;
	private int level;
	private String title;
	private String memInfo;
	private String idChange;
	private String loginState;
	
	// 제재중 계정
	private int banDay;
}
