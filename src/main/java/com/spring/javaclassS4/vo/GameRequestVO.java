package com.spring.javaclassS4.vo;

import lombok.Data;

@Data
public class GameRequestVO {
	private int grIdx;
	private String reqMid;
	private int gameIdx;
	private String gameTitle;
	private String gameSubTitle;
	private String jangre;
	private String platform;
	private String showDate;
	private int price;
	private int metascore;
	private String steamscore;
	private String steamPage;
	private String developer;
	private String gameInfo;
	private int grComplete;
	private String reason;
	
	private String gameImg;
	private String changeText;
}
