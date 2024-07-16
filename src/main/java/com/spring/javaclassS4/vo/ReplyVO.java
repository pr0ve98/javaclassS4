package com.spring.javaclassS4.vo;

import lombok.Data;

@Data
public class ReplyVO {
	private int replyIdx;
	private int replyCmIdx;
	private String replyMid;
	private int replyParentIdx;
	private String replyContent;
	private String replyHostIp;
	private String replyDate;
	
	private int hour_diff;
	private int min_diff;
	private int childReplyCount;
	
	// 멤버
	private String nickname;
	private String memImg;
	private String title;
}
