package com.spring.javaclassS4.service;

import java.util.ArrayList;

import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.ReviewVO;

public interface ReviewService {

	public int getGameTotRecCnt(String search, String mid);

	public ArrayList<CommunityVO> getGameList(int startIndexNo, int pageSize, String viewpart,
			String search, String mid);

	public ReviewVO getMidAndIdx(int gameIdx, String mid);

	public void setReviewEdit(String mid, int gameIdx, int rating, String state);

	public void setReviewInput(String mid, int gameIdx, int rating, String state);

	public void setReviewDelete(String mid, int gameIdx);

	public CommunityVO getReviewMore(int cmGameIdx, String mid);

	public void reviewMoreInput(CommunityVO vo);

	public void reviewMoreEdit(CommunityVO vo);

	public int getRatingCount(String mid, int rating);
}
