package com.spring.javaclassS4.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaclassS4.dao.ReviewDAO;
import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.ReviewVO;

@Service
public class ReviewServiceImpl implements ReviewService {

	@Autowired
	ReviewDAO reviewDAO;
	
	@Override
	public int getGameTotRecCnt(String searchpart, String search, String mid) {
		return reviewDAO.getGameTotRecCnt(searchpart, search, mid);
	}

	@Override
	public ArrayList<CommunityVO> getGameList(int startIndexNo, int pageSize, String viewpart, String searchpart,
			String search, String mid) {
		return reviewDAO.getGameList(startIndexNo, pageSize, viewpart, searchpart, search, mid);
	}

	@Override
	public ReviewVO getMidAndIdx(int gameIdx, String mid) {
		return reviewDAO.getMidAndIdx(gameIdx, mid);
	}

	@Override
	public void setReviewEdit(String mid, int gameIdx, int rating, String state) {
		reviewDAO.setReviewEdit(mid, gameIdx, rating, state);
	}

	@Override
	public void setReviewInput(String mid, int gameIdx, int rating, String state) {
		reviewDAO.setReviewInput(mid, gameIdx, rating, state);
	}

	@Override
	public void setReviewDelete(String mid, int gameIdx) {
		reviewDAO.setReviewDelete(mid, gameIdx);
	}


}
