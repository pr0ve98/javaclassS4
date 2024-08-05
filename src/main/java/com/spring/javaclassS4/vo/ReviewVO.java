package com.spring.javaclassS4.vo;

import lombok.Data;

@Data
public class ReviewVO {
	private int revIdx;
	private String revMid;
	private int revGameIdx;
	private int rating;
	private String state;
	
	// 게임 정보
	private int gameIdx;
	private String gameImg;
	private String gameTitle;
	
	private String cmContent;
}
