package com.spring.javaclassS4.vo;

import lombok.Data;

@Data
public class AlramVO {
	private int idx;
	private int cmIdx;
	private String type;
	private String youMid;
	private String youName;
	private String youImg;
	private int gameIdx;
	private String gameTitle;
	private String gameImg;
	private int comType;
	private String date;
	
	private int adminCount;
}
