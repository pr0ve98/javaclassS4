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
	public String review(HttpSession session, Model model,
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
	@RequestMapping(value = "/rootData", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String rootData(HttpSession session, HttpServletRequest request,
			@RequestParam(name="viewpart", defaultValue = "manyReview", required = false) String viewpart,
			@RequestParam(name="search", defaultValue = "", required = false) String search,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "20", required = false) int pageSize) {
		
		String mid = session.getAttribute("sMid")==null ? "" : (String)session.getAttribute("sMid");
		int startIndexNo = (page - 1) * pageSize;
		String str = "";
		
		ArrayList<CommunityVO> vos = reviewService.getGameList(startIndexNo, pageSize, viewpart, search, mid);
		
		for(CommunityVO vo : vos) {
			str += "<div class=\"cm-box\" style=\"padding:0\" data-game-idx=\""+vo.getGameIdx()+"\" data-rating=\""+vo.getRating()+"\">"
				+ "<div class=\"review-viewflex\"><div>";
			if(vo.getGameImg() != null && vo.getGameImg().indexOf("http") == -1) str += "<img src=\""+request.getContextPath()+"/game/"+vo.getGameImg()+"\" class=\"review-game-i\">";
			else str += "<img src=\""+vo.getGameImg()+"\" class=\"review-game-i\">";
			str += "</div><div class=\"review-add\">"
				+ "<div style=\"display: flex; justify-content: space-between; align-items: center;\">"
				+ "<div class=\"review-add-title\" onclick=\"location.href='"+request.getContextPath()+"/gameview/"+vo.getGameIdx()+"';\">"+vo.getGameTitle()+"</div>"
				+ "<div style=\"position: relative; cursor: pointer;\">"
				+ "<img id=\"stateIcon\" src=\""+request.getContextPath()+"/images/"+(vo.getState() == null ? "none" : vo.getState())+"Icon.svg\" onclick=\"toggleContentMenu("+vo.getGameIdx()+")\">"
				+ "<div id=\"contentMenu"+vo.getGameIdx()+"\" class=\"review-menu\">"
				+ "<div class=\"review-menu-star\">"
				+ "<div id=\"zero-rating-area1\" style=\"position: absolute; left: 0px; width: 20px; height: 24px; cursor: pointer;\"></div>"
				+ "<span class=\"review-star-add mr-1\" style=\"width: 25px; height: 25px;\" data-index=\"1\"></span>"
				+ "<span class=\"review-star-add mr-1\" style=\"width: 25px; height: 25px;\" data-index=\"2\"></span>"
				+ "<span class=\"review-star-add mr-1\" style=\"width: 25px; height: 25px;\" data-index=\"3\"></span>"
				+ "<span class=\"review-star-add mr-1\" style=\"width: 25px; height: 25px;\" data-index=\"4\"></span>"
				+ "<span class=\"review-star-add mr-1\" style=\"width: 25px; height: 25px;\" data-index=\"5\"></span></div>"
				+ "<div id=\"startext"+vo.getGameIdx()+"\">이 게임에 별점을 주세요!</div>"
				+ "<div id=\"moreReviewInput"+vo.getGameIdx()+"\" style=\"display: "+(vo.getRating() != 0 ? "block" : "none")+"\" onclick=\"showPopupReviewAllAdd("+vo.getGameIdx()+", '"+vo.getGameTitle()+"', '"+vo.getGameImg()+"')\"><i class=\"fa-solid fa-pencil\"></i>&nbsp;&nbsp;평가도 남겨보세요</div>"
				+ "<hr/><div class=\"state-buttons\" style=\"display: flex;\">"
				+ "<div class=\"state-button "+(vo.getState() != null && vo.getState().equals("play") ? "selected" : "")+"\" data-state=\"play\">"
				+ "<div class=\"button-background\">"
				+ "<span class=\"state-icon\" style=\"mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Play.svg&quot;);\"></span></div></div>"
				+ "<div class=\"state-button "+(vo.getState() != null && vo.getState().equals("done") ? "selected" : "")+"\" data-state=\"done\">"
				+ "<div class=\"button-background\">"
				+ "<span class=\"state-icon\" style=\"mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Check.svg&quot;);\"></span></div></div>"
				+ "<div class=\"state-button "+(vo.getState() != null && vo.getState().equals("stop") ? "selected" : "")+"\" data-state=\"stop\">"
				+ "<div class=\"button-background\">"
				+ "<span class=\"state-icon\" style=\"mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Cancel.svg&quot;);\"></span></div></div>"
				+ "<div class=\"state-button "+(vo.getState() != null && vo.getState().equals("folder") ? "selected" : "")+"\" data-state=\"folder\">"
				+ "<div class=\"button-background\">"
				+ "<span class=\"state-icon\" style=\"mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Folder.svg&quot;);\"></span></div></div>"
				+ "<div class=\"state-button "+(vo.getState() != null && vo.getState().equals("pin") ? "selected" : "")+"\" data-state=\"pin\">"
				+ "<div class=\"button-background\">"
				+ "<span class=\"state-icon\" style=\"mask-image: url(&quot;https://djf7qc4xvps5h.cloudfront.net/resource/minimap/icon/solid/Pin.svg&quot;);\"></span></div></div></div>"
				+ "<div id=\"statetext"+vo.getGameIdx()+"\">";
			if(vo.getState() != null && vo.getState().equals("play")) str += "<font color=\"#fff\">하고있어요</font>";
			else if(vo.getState() != null && vo.getState().equals("done")) str += "<font color=\"#fff\">다했어요</font>";
			else if(vo.getState() != null && vo.getState().equals("stop")) str += "<font color=\"#fff\">그만뒀어요</font>";
			else if(vo.getState() != null && vo.getState().equals("folder")) str += "<font color=\"#fff\">모셔놨어요</font>";
			else if(vo.getState() != null && vo.getState().equals("pin")) str += "<font color=\"#fff\">관심있어요</font>";
			else str += "현재 게임 상태를 선택해주세요";
			str += "</div></div></div></div>";
			if(vo.getShowDate() != null) str += "<div style=\"margin-bottom: 30px;\">"+vo.getShowDate().substring(0,4)+"</div>";
			str += "<div style=\"display: flex; position: relative;\">"
				+ "<div id=\"zero-rating-area2\" style=\"position: absolute; left: -20px; width: 20px; height: 40px; cursor: pointer;\"></div>"
				+ "<span class=\"review-star-add mr-1\" data-index=\"1\"></span>"
				+ "<span class=\"review-star-add mr-1\" data-index=\"2\"></span>"
				+ "<span class=\"review-star-add mr-1\" data-index=\"3\"></span>"
				+ "<span class=\"review-star-add mr-1\" data-index=\"4\"></span>"
				+ "<span class=\"review-star-add mr-1\" data-index=\"5\"></span>"
				+ "</div></div></div></div>";
		}
		return str;
	}
	
	@ResponseBody
	@RequestMapping(value = "/reviewAdd", method = RequestMethod.POST)
	public String reviewAdd(int gameIdx, int rating, String state, String mid) {
		ReviewVO testvo = reviewService.getMidAndIdx(gameIdx, mid);
		
		if(testvo != null) reviewService.setReviewEdit(mid, gameIdx, rating, state);
		else reviewService.setReviewInput(mid, gameIdx, rating, state);
		
		CommunityVO testvo2 = reviewService.getReviewMore(gameIdx, mid);
		if(testvo2 != null) {
			testvo2.setState(state);
			testvo2.setRating(rating);
			reviewService.reviewMoreEdit(testvo2);
		}
		
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
