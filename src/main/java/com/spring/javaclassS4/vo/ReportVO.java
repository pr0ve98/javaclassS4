package com.spring.javaclassS4.vo;

import lombok.Data;

@Data
public class ReportVO {
	private int reIdx;
	private String reportMid;
	private String sufferMid;
	private String contentPart;
	private int contentIdx;
	private String reason;
	private int complete;
}
