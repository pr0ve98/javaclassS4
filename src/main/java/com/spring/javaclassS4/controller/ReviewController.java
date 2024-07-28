package com.spring.javaclassS4.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.javaclassS4.service.ReviewService;
import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.ReviewVO;

@Controller
@RequestMapping("/review")
public class ReviewController {
	
	@Autowired
	ReviewService reviewService;
	
	@RequestMapping(value = "", method = RequestMethod.GET)
	public String settingGet(HttpSession session, Model model,
			@RequestParam(name="viewpart", defaultValue = "manyReview", required = false) String viewpart,
			@RequestParam(name="search", defaultValue = "", required = false) String search,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "20", required = false) int pageSize) {
		
		String mid = session.getAttribute("sMid")==null ? "" : (String)session.getAttribute("sMid");
		
		int totRecCnt = reviewService.getGameTotRecCnt(search, mid);
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totRecCnt", totRecCnt);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> vos = reviewService.getGameList(startIndexNo, pageSize, viewpart, search, mid);
		
		int rating1 = reviewService.getRatingCount(mid, 1);
		int rating2 = reviewService.getRatingCount(mid, 2);
		int rating3 = reviewService.getRatingCount(mid, 3);
		int rating4 = reviewService.getRatingCount(mid, 4);
		int rating5 = reviewService.getRatingCount(mid, 5);
		model.addAttribute("rating1", rating1);
		model.addAttribute("rating2", rating2);
		model.addAttribute("rating3", rating3);
		model.addAttribute("rating4", rating4);
		model.addAttribute("rating5", rating5);
		int totRatingCnt = rating1 + rating2 + rating3 + rating4 + rating5;
		model.addAttribute("totRatingCnt", totRatingCnt);
		
		model.addAttribute("vos", vos);
		model.addAttribute("viewpart", viewpart);
		model.addAttribute("search", search);
		model.addAttribute("flag", "review");
		
		return "review/reviewAdd";
	}
	
	@ResponseBody
	@RequestMapping(value = "/reviewAdd", method = RequestMethod.POST)
	public String reviewAdd(int gameIdx, int rating, String state, String mid) {
		ReviewVO testvo = reviewService.getMidAndIdx(gameIdx, mid);
		
		if(testvo != null) reviewService.setReviewEdit(mid, gameIdx, rating, state);
		else reviewService.setReviewInput(mid, gameIdx, rating, state);
		
		CommunityVO testvo2 = reviewService.getReviewMore(gameIdx, mid);
		testvo2.setState(state);
		testvo2.setRating(rating);
		if(testvo2 != null) reviewService.reviewMoreEdit(testvo2);
		
		int rating1 = reviewService.getRatingCount(mid, 1);
		int rating2 = reviewService.getRatingCount(mid, 2);
		int rating3 = reviewService.getRatingCount(mid, 3);
		int rating4 = reviewService.getRatingCount(mid, 4);
		int rating5 = reviewService.getRatingCount(mid, 5);
		int ratingTotalCnt = rating1 + rating2 + rating3 + rating4 + rating5;
		return rating1 + "|" + rating2 + "|" + rating3 + "|" + rating4 + "|" + rating5 + "|" + ratingTotalCnt;
	}
	
	@ResponseBody
	@RequestMapping(value = "/reviewDelete", method = RequestMethod.POST)
	public String reviewDelete(int gameIdx, String mid) {
		reviewService.setReviewDelete(mid, gameIdx);
		
		int rating1 = reviewService.getRatingCount(mid, 1);
		int rating2 = reviewService.getRatingCount(mid, 2);
		int rating3 = reviewService.getRatingCount(mid, 3);
		int rating4 = reviewService.getRatingCount(mid, 4);
		int rating5 = reviewService.getRatingCount(mid, 5);
		int ratingTotalCnt = rating1 + rating2 + rating3 + rating4 + rating5;
		return rating1 + "|" + rating2 + "|" + rating3 + "|" + rating4 + "|" + rating5 + "|" + ratingTotalCnt;
	}
	
	@ResponseBody
	@RequestMapping(value = "/reviewMoreInput", method = RequestMethod.POST)
	public void reviewMoreInput(CommunityVO vo, HttpServletRequest request) {
		CommunityVO testvo = reviewService.getReviewMore(vo.getCmGameIdx(), vo.getMid());
		
		vo.setSection("피드");
		vo.setPart("리뷰");
		vo.setPublicType("전체");
		vo.setCmHostIp(request.getRemoteAddr());
		reviewService.setReviewEdit(vo.getMid(), vo.getGameIdx(), vo.getRating(), vo.getState());
		if(testvo != null) reviewService.reviewMoreEdit(vo);
		else reviewService.reviewMoreInput(vo);
	}
	
	@Transactional
	@ResponseBody
	@RequestMapping(value = "/reviewInput", method = RequestMethod.POST)
	public void reviewInput(CommunityVO vo, HttpServletRequest request) {
		ReviewVO testvo = reviewService.getMidAndIdx(vo.getCmGameIdx(), vo.getMid());
		CommunityVO cvo = reviewService.getReviewMore(vo.getCmGameIdx(), vo.getMid());
		
		vo.setSection("피드");
		vo.setPart("리뷰");
		vo.setPublicType("전체");
		vo.setCmHostIp(request.getRemoteAddr());
		
		if(testvo == null && cvo == null) {
			reviewService.setReviewInput(vo.getMid(), vo.getCmGameIdx(), vo.getRating(), vo.getState());
			reviewService.reviewMoreInput(vo);
		}
		else if(testvo != null && cvo == null) {
			reviewService.setReviewEdit(vo.getMid(), vo.getCmGameIdx(), vo.getRating(), vo.getState());
			reviewService.reviewMoreInput(vo);
		}
		else if(testvo == null && cvo != null) {
			reviewService.setReviewInput(vo.getMid(), vo.getCmGameIdx(), vo.getRating(), vo.getState());
			reviewService.reviewMoreEdit(vo);
		}
		else {
			reviewService.setReviewEdit(vo.getMid(), vo.getCmGameIdx(), vo.getRating(), vo.getState());
			reviewService.reviewMoreEdit(vo);
		}
	}
}
