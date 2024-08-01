package com.spring.javaclassS4.vo;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class CommunityVO {
	private int cmIdx;
	private String mid;
	private String section;
	private String part;
	private int cmGameIdx;
	private String cmContent;
	private String cmDate;
	private String cmHostIp;
	private String publicType;
	private String newsTitle;
	
	private int hour_diff;
	private int min_diff;
	private int longContent; /* 파싱했는지 안 했는지 판단 0: 파싱x 1:파싱 */
	
	// 유저 정보
	private int idx;
	private String title;
	private String nickname;
	private String memImg;
	
	// 게임 정보
	private int gameIdx;
	private String gameTitle;
	private String gameImg;
	private String showDate;
	
	// 좋아요
	private int likeCnt;
	private List<String> likeMember;
	private int likeSW;
	
	// 댓글
	private ArrayList<ReplyVO> parentsReply;
	private ArrayList<ReplyVO> childReply;
	private int replyCount;
	
	// 리뷰용
	private int rating;
	private String state;
	
	// 팔로우 여부
	private int follow;
	
	// 뉴스 썸네일
	private String newsThumnail;
}
