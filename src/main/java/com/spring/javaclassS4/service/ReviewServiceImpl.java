package com.spring.javaclassS4.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.javaclassS4.dao.ReviewDAO;
import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.ReviewVO;

@Service
public class ReviewServiceImpl implements ReviewService {

	@Autowired
	ReviewDAO reviewDAO;
	
	@Override
	public int getGameTotRecCnt(String search, String mid) {
		return reviewDAO.getGameTotRecCnt(search, mid);
	}

	@Override
	public ArrayList<CommunityVO> getGameList(int startIndexNo, int pageSize, String viewpart,
			String search, String mid) {
		return reviewDAO.getGameList(startIndexNo, pageSize, viewpart, search, mid);
	}

	@Override
	public ReviewVO getMidAndIdx(int gameIdx, String mid) {
		return reviewDAO.getMidAndIdx(gameIdx, mid);
	}

	@Transactional
	@Override
	public void setReviewEdit(String mid, int gameIdx, int rating, String state) {
		reviewDAO.setReviewEdit(mid, gameIdx, rating, state);
		int reviewCount = reviewDAO.getGameReviewCount(gameIdx);
		if(reviewCount >= 3) {
			List<Integer> reviewTotal = reviewDAO.getGameReviewTotal(gameIdx);
			int rt = 0;
			for(int su : reviewTotal) {
				rt += su;
			}
			double invenscore = ((double)rt / reviewCount);
			invenscore = Math.round(invenscore * 10) / 10.0;
			reviewDAO.setInvenscore(invenscore, gameIdx);
		}
		else {
			reviewDAO.setInvenscore(0, gameIdx);
		}
	}

	@Transactional
	@Override
	public void setReviewInput(String mid, int gameIdx, int rating, String state) {
		reviewDAO.setReviewInput(mid, gameIdx, rating, state);
		int reviewCount = reviewDAO.getGameReviewCount(gameIdx);
		if(reviewCount >= 3) {
			List<Integer> reviewTotal = reviewDAO.getGameReviewTotal(gameIdx);
			int rt = 0;
			for(int su : reviewTotal) {
				rt += su;
			}
			double invenscore = ((double)rt / reviewCount);
			invenscore = Math.round(invenscore * 10) / 10.0;
			reviewDAO.setInvenscore(invenscore, gameIdx);
		}
	}

	@Transactional
	@Override
	public void setReviewDelete(String mid, int gameIdx) {
		reviewDAO.setReviewDelete(mid, gameIdx);
		int reviewCount = reviewDAO.getGameReviewCount(gameIdx);
		if(reviewCount >= 3) {
			List<Integer> reviewTotal = reviewDAO.getGameReviewTotal(gameIdx);
			int rt = 0;
			for(int su : reviewTotal) {
				rt += su;
			}
			double invenscore = ((double)rt / reviewCount);
			invenscore = Math.round(invenscore * 10) / 10.0;
			reviewDAO.setInvenscore(invenscore, gameIdx);
		}
		else {
			reviewDAO.setInvenscore(0, gameIdx);
		}
	}

	@Override
	public CommunityVO getReviewMore(int cmGameIdx, String mid) {
		return reviewDAO.getReviewMore(cmGameIdx, mid);
	}

	@Override
	public void reviewMoreInput(CommunityVO vo) {
		reviewDAO.reviewMoreInput(vo);
	}

	@Override
	public void reviewMoreEdit(CommunityVO vo) {
		reviewDAO.reviewMoreEdit(vo);
	}

	@Override
	public int getRatingCount(String mid, int rating) {
		return reviewDAO.getRatingCount(mid, rating);
	}


}
