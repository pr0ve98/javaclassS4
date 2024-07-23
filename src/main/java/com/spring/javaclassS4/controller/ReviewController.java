package com.spring.javaclassS4.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
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
			@RequestParam(name="viewpart", defaultValue = "gameIdx desc", required = false) String viewpart,
			@RequestParam(name="searchpart", defaultValue = "제목", required = false) String searchpart,
			@RequestParam(name="search", defaultValue = "", required = false) String search,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "20", required = false) int pageSize) {
		
		String mid = session.getAttribute("sMid")==null ? "" : (String)session.getAttribute("sMid");
		
		int totRecCnt = reviewService.getGameTotRecCnt(searchpart, search, mid);
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totRecCnt", totRecCnt);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> vos = reviewService.getGameList(startIndexNo, pageSize, viewpart, searchpart, search, mid);
		
		model.addAttribute("vos", vos);
		model.addAttribute("viewpart", viewpart);
		model.addAttribute("searchpart", searchpart);
		model.addAttribute("search", search);
		model.addAttribute("flag", "review");
		
		return "review/reviewAdd";
	}
	
	@ResponseBody
	@RequestMapping(value = "/reviewAdd", method = RequestMethod.POST)
	public void reviewAdd(int gameIdx, int rating, String state, String mid) {
		ReviewVO testvo = reviewService.getMidAndIdx(gameIdx, mid);
		
		if(testvo != null) reviewService.setReviewEdit(mid, gameIdx, rating, state);
		else reviewService.setReviewInput(mid, gameIdx, rating, state);
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/reviewDelete", method = RequestMethod.POST)
	public void reviewDelete(int gameIdx, String mid) {
		reviewService.setReviewDelete(mid, gameIdx);
	}
	
	@ResponseBody
	@RequestMapping(value = "/reviewMoreInput", method = RequestMethod.POST)
	public void reviewMoreInput(CommunityVO vo, HttpServletRequest request) {
		CommunityVO testvo = reviewService.getReviewMore(vo.getCmGameIdx(), vo.getMid());
		
		vo.setSection("피드");
		vo.setPart("리뷰");
		vo.setPublicType("전체");
		vo.setCmHostIp(request.getRemoteAddr());
		if(testvo != null) reviewService.reviewMoreEdit(vo);
		else reviewService.reviewMoreInput(vo);
	}
	
}
