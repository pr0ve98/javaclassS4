package com.spring.javaclassS4.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.javaclassS4.dao.CommunityDAO;
import com.spring.javaclassS4.service.CommunityService;
import com.spring.javaclassS4.service.HomeService;
import com.spring.javaclassS4.service.ReviewService;
import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.GameVO;
import com.spring.javaclassS4.vo.ReplyVO;
import com.spring.javaclassS4.vo.ReviewVO;

@Controller
public class HomeController {
	
	@Autowired
	HomeService homeService;
	
	@Autowired
	ReviewService reviewService;
	
	@Autowired
	CommunityService communityService;
	
	@Autowired
	CommunityDAO communityDAO;
	
	@RequestMapping(value = {"/", "/main"}, method = RequestMethod.GET)
	public String home(Model model, HttpSession session) {
		String mid = session.getAttribute("sMid")==null ? "" : (String)session.getAttribute("sMid");
		ArrayList<GameVO> newgamelist = homeService.getNewGameList();
		int myGameAllCount = homeService.getMyGameCount(mid);
		int myGame5Star = homeService.getMyGameStar(mid, 5);
		int myGame3Star = homeService.getMyGameStar(mid, 3);
		int myGame2Star = homeService.getMyGameStar(mid, 2);
		int myGamePlay = homeService.getMyGameState(mid, "play");
		int myGameStop = homeService.getMyGameState(mid, "stop");
		int myGameDone = homeService.getMyGameState(mid, "done");
		int myGamePin = homeService.getMyGameState(mid, "pin");
		int myGameFolder = homeService.getMyGameState(mid, "folder");
		int myGameNone = homeService.getMyGameState(mid, "none");
		model.addAttribute("myGameAllCount", myGameAllCount);
		model.addAttribute("myGame5Star", myGame5Star);
		model.addAttribute("myGame3Star", myGame3Star);
		model.addAttribute("myGame2Star", myGame2Star);
		model.addAttribute("myGamePlay", myGamePlay);
		model.addAttribute("myGameStop", myGameStop);
		model.addAttribute("myGameDone", myGameDone);
		model.addAttribute("myGamePin", myGamePin);
		model.addAttribute("myGameFolder", myGameFolder);
		model.addAttribute("myGameNone", myGameNone);
		
		
		model.addAttribute("newgamelist", newgamelist);
		model.addAttribute("flag", "main");
		return "home";
	}
	
	@RequestMapping(value = "/gameview/{gameIdx}", method = RequestMethod.GET)
	public String gameView(Model model, @PathVariable int gameIdx, HttpSession session) {
		String mid = session.getAttribute("sMid")==null ? "" : (String)session.getAttribute("sMid");
		GameVO vo = homeService.getGame(gameIdx);
		model.addAttribute("vo", vo);
		
		// 워드크라우드용
		Map<String, Integer> positiveKeywords = new HashMap<>();
		Map<String, Integer> negativeKeywords = new HashMap<>();
		
		int positiveCnt = homeService.reviewGameIdxAll(gameIdx);
		if(positiveCnt >= 3) positiveKeywords = homeService.positiveMap(gameIdx);
		
		int negativeCnt = homeService.reviewGameIdxN(gameIdx);
		if(negativeCnt >= 3) negativeKeywords = homeService.negativeMap(gameIdx);
		
		ObjectMapper objectMapper = new ObjectMapper();
		try {
		    String positiveKeywordsJson = objectMapper.writeValueAsString(positiveKeywords);
		    String negativeKeywordsJson = objectMapper.writeValueAsString(negativeKeywords);
		
		    model.addAttribute("positiveKeywordsJson", positiveKeywordsJson);
		    model.addAttribute("negativeKeywordsJson", negativeKeywordsJson);
		} catch (Exception e) {
		    e.printStackTrace();
		}
		
		// 평점용
		int rating1 = homeService.getRatingCount(gameIdx, 1);
		int rating2 = homeService.getRatingCount(gameIdx, 2);
		int rating3 = homeService.getRatingCount(gameIdx, 3);
		int rating4 = homeService.getRatingCount(gameIdx, 4);
		int rating5 = homeService.getRatingCount(gameIdx, 5);
		model.addAttribute("rating1", rating1);
		model.addAttribute("rating2", rating2);
		model.addAttribute("rating3", rating3);
		model.addAttribute("rating4", rating4);
		model.addAttribute("rating5", rating5);
		int totRatingCnt = homeService.allCount(gameIdx);
		model.addAttribute("totRatingCnt", totRatingCnt);
		
		// 리뷰 수정용
		String cmContent = communityDAO.getCMReview(gameIdx, mid);
		ReviewVO revVO = reviewService.getMidAndIdx(gameIdx, mid);
		model.addAttribute("cmContent", cmContent);
		model.addAttribute("revVO", revVO);
		int reviewContentCnt = homeService.getGameViewRCTotRecCnt(gameIdx, "리뷰");
		model.addAttribute("reviewContentCnt", reviewContentCnt);
		
		// 긍정/비판
		CommunityVO posiBest = homeService.getPosiBest(gameIdx, session);
		CommunityVO negaBest = homeService.getNegaBest(gameIdx, session);
		CommunityVO myReview = homeService.getMyReview(gameIdx, session);
		model.addAttribute("posiBest", posiBest);
		model.addAttribute("negaBest", negaBest);
		model.addAttribute("myReview", myReview);
		
		// 일지
		ArrayList<CommunityVO> ilgilist = homeService.getIlgiList(gameIdx, session);
		int ilgiCnt = homeService.ilgiCnt(gameIdx);
		model.addAttribute("ilgilist", ilgilist);
		model.addAttribute("ilgiCnt", ilgiCnt);
		
		// 소식정보
		ArrayList<CommunityVO> infolist = homeService.getInfolist(gameIdx, session);
		int infoCnt = homeService.infoCnt(gameIdx);
		model.addAttribute("infolist", infolist);
		model.addAttribute("infoCnt", infoCnt);
        
		return "game/gameView";
	}
	
	@ResponseBody
	@RequestMapping(value = "/gameViewCommunityView", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String gameViewCommunityView(int cmIdx, HttpSession session, HttpServletRequest request) {
		String mid = session.getAttribute("sMid")==null ? "" : (String) session.getAttribute("sMid");
		String memImg = session.getAttribute("sMemImg")==null ? "" : (String) session.getAttribute("sMemImg");
		int level = session.getAttribute("sLevel")==null ? 2 : (int) session.getAttribute("sLevel");
		CommunityVO vo = homeService.gameViewCommunityView(cmIdx, session);
		ArrayList<ReplyVO> parent = vo.getParentsReply();
		ArrayList<ReplyVO> child = vo.getChildReply();
		int replyCount = vo.getReplyCount();
		String str = "";
		
	    str += "<div style=\"display:flex; justify-content:space-between;\">"
	        + "<div style=\"display:flex; align-items:center;\">";
	    str += "<img src=\"" + request.getContextPath() + "/member/" + vo.getMemImg() + "\" alt=\"프로필\" class=\"text-pic\"><div>";
	    if(!vo.getTitle().equals("없음")) str += "<div style=\"font-size:12px;\">" + vo.getTitle() + "</div>";
	    str += "<div style=\"font-weight:bold;\">" + vo.getNickname() + "</div><div>";
	    
	    if (vo.getPart().equals("소식/정보")) str += "<span class=\"badge badge-secondary\">소식/정보</span>&nbsp;";
	    else if (vo.getPart().equals("자유")) str += "<span class=\"badge badge-secondary\">자유글</span>&nbsp;";
	    else if (vo.getPart().equals("세일")) str += "<span class=\"badge badge-secondary\">세일정보</span>&nbsp;";
	    else str += "<div style=\"color:#b2bdce; font-size:12px; cursor:pointer;\" onclick=\"location.href='"+request.getContextPath()+"/gameview/"+vo.getCmGameIdx()+"';\"><i class=\"fa-solid fa-gamepad fa-xs\" style=\"color: #b2bdce;\"></i>&nbsp;" + vo.getGameTitle() + "</div>";
	    
	    str += "</div></div></div>";
	    
	    if(!mid.equals("")) {
		    str += "<div style=\"display: flex; align-items: center;\">";
		    if(!mid.equals(vo.getMid()) && vo.getFollow() == 0) str += "<div class=\"replyok-button mr-4 fb"+vo.getMid()+"\" onclick=\"followAdd('"+vo.getMid()+"')\"><i class=\"fa-solid fa-plus fa-sm\"></i>&nbsp;팔로우</div>";
		    str +="<div style=\"position:relative;\">"
		        + "<i class=\"fa-solid fa-bars fa-xl\" onclick=\"toggleContentMenu(" + vo.getCmIdx() + ")\" style=\"color: #D5D5D5;cursor:pointer;\"></i>"
		        + "<div id=\"contentMenu" + vo.getCmIdx() + "\" class=\"content-menu\">";
		    
		    if (mid.equals(vo.getMid())) {
		    	str += "<div onclick=\"contentDelete("+vo.getCmIdx()+")\"><font color=\"red\">삭제</font></div>";
		    }
		    else if (level == 0) {
		        str += "<div onclick=\"contentDelete("+vo.getCmIdx()+")\"><font color=\"red\">삭제</font></div>";
		        str += "<div onclick=\"location.href='"+request.getContextPath()+"/admin/userlist?page=1&viewpart=all&searchpart=아이디&search="+vo.getMid()+"';\">사용자 제재</div>";
		    }
		    else {
		    	str += "<div class=\"ufb"+vo.getMid()+"\" onclick=\"followDelete('"+vo.getMid()+"')\">언팔로우</div>";
		    	str += "<div onclick=\"reportPopup("+vo.getCmIdx()+", '게시글')\">신고</div>";
		    }
		    
		    str += "</div></div></div>";
	    }
	    
	    str += "</div>";
	    str += "<div class=\"community-content\">";
	    
	    if (vo.getLongContent() == 1) {
	        str += "<div class=\"cm-content moreGra\" id=\"cmContent" + vo.getCmIdx() + "\">" + vo.getCmContent() + "</div>"
	            + "<div onclick=\"showAllContent(" + vo.getCmIdx() + ")\" id=\"moreBtn" + vo.getCmIdx() + "\" style=\"cursor:pointer; color:#00c722; font-weight:bold;\">더 보기</div>";
	    } else str += "<div class=\"cm-content\" id=\"cmContent" + vo.getCmIdx() + "\">" + vo.getCmContent() + "</div>";
	    
	    str += "<div style=\"color:#b2bdce; font-size:12px;\" class=\"mt-2\">";
	    
	    if (vo.getHour_diff() < 1) str += vo.getMin_diff() + "분 전";
	    else if (vo.getHour_diff() < 24 && vo.getHour_diff() >= 1) str += vo.getHour_diff() + "시간 전";
	    else str += vo.getCmDate().substring(0, 10);
	    
	    str += "</div><div style=\"color:#b2bdce; font-size:12px;\" class=\"mt-2\"><span id=\"cm-likeCnt" + vo.getCmIdx() + "\">이 글을 " + vo.getLikeCnt() + "명이 좋아합니다.</span></div></div>";
	    
	    if (!mid.equals("")) {
	        str += "<hr/><div class=\"community-footer\"><span id=\"cm-like" + vo.getCmIdx() + "\">";
	        if (vo.getLikeSW() == 0) str += "<span onclick=\"likeAdd(" + vo.getCmIdx() + ")\"><i class=\"fa-solid fa-heart\"></i>&nbsp;&nbsp;좋아요</span>";
	        else str += "<span style=\"color:#00c722;\" onclick=\"likeDelete(" + vo.getCmIdx() + ")\"><i class=\"fa-solid fa-heart\"></i>&nbsp;&nbsp;좋아요</span>";
	        str += "</span><span onclick=\"replyPreview("+vo.getCmIdx()+")\"><i class=\"fa-solid fa-comment-dots\"></i>&nbsp;&nbsp;댓글</span></div><hr/>";
	    }
	    str += "<div id=\"replyList" + vo.getCmIdx() + "\" class=\"replyList\">";
	    
	    if(replyCount > 2) str += "<div id=\"moreReply"+vo.getCmIdx()+"\" onclick=\"parentReplyMore("+vo.getCmIdx()+")\" class=\"moreReply\">"+replyCount+"개의 댓글 모두 보기</div>";
		for(ReplyVO p : parent) {
			p.setChildReplyCount(communityService.getChildReplyCount(p.getReplyIdx()));
			str += "<div style=\"display:flex; align-items:flex-start;\" class=\"mb-4\">"
				+"<img src=\""+request.getContextPath()+"/member/"+p.getMemImg()+"\" alt=\"프로필\" class=\"reply-pic\"><div>";
			if(!p.getTitle().equals("없음")) str += "<div style=\"font-size:12px;\">"+p.getTitle()+"</div>";
			str += "<div style=\"font-weight:bold;\">"+p.getNickname()+"</div>"
				+ "<div>"+p.getReplyContent().replace("\n", "<br/>")+"</div>"
				+ "<div style=\"color:#b2bdce; font-size:12px;\" class=\"mt-2\">";
			if(p.getHour_diff() < 1) str += p.getMin_diff()+"분 전";
			else if(p.getHour_diff() < 24 && p.getHour_diff() >= 1) str += p.getHour_diff()+"시간 전";
			else str += p.getReplyDate().substring(0,10);
			if(!mid.equals("")) {
				str += "<div class=\"replymenu\"><span class=\"mr-2\" onclick=\"rreplyPreview("+p.getReplyIdx()+")\">답글</span>";
				if(mid.equals(p.getReplyMid())) str += "<span class=\"mr-2\" onclick=\"replyEditPopup("+p.getReplyIdx()+", '"+p.getReplyContent()+"')\">수정</span>";
				if((mid.equals(p.getReplyMid()) && level != 0) || level == 0) str += "<span class=\"mr-2\" onclick=\"replyDelete("+p.getReplyIdx()+", 0)\">삭제</span>";
				str += "<span class=\"mr-2\" onclick=\"reportPopup("+p.getReplyIdx()+", '댓글', '"+p.getReplyMid()+"')\">신고</span>";
				str += "</div>";
			}
			str += "</div></div></div>"
				+ "<div id=\"rreplyList"+p.getReplyIdx()+"\" class=\"rreplyList\">";
			if(p.getChildReplyCount() > 1) str += "<div id=\"moreRReply"+p.getReplyIdx()+"\" onclick=\"childReplyMore("+p.getReplyIdx()+","+vo.getCmIdx()+")\" class=\"moreReply\"> ──&nbsp;&nbsp;"+p.getChildReplyCount()+"개의 답글 모두 보기</div>";
			for(ReplyVO c : child) {
				if(c.getReplyParentIdx() == p.getReplyIdx()) {
					str += "<div style=\"display:flex; align-items:flex-start;\" class=\"mb-4\">"
						+ "<img src=\""+request.getContextPath()+"/member/"+c.getMemImg()+"\" alt=\"프로필\" class=\"reply-pic\"><div>";
					if(!c.getTitle().equals("없음")) str += "<div style=\"font-size:12px;\">"+c.getTitle()+"</div>";
					str += "<div style=\"font-weight:bold;\">"+c.getNickname()+"</div>"
						+ "<div>"+c.getReplyContent().replace("\n", "<br/>")+"</div>"
						+ "<div style=\"color:#b2bdce; font-size:12px;\" class=\"mt-2\">";
					if(c.getHour_diff() < 1) str += c.getMin_diff()+"분 전";
					else if(c.getHour_diff() < 24 && c.getHour_diff() >= 1) str += c.getHour_diff()+"시간 전";
					else str += c.getReplyDate().substring(0,10);
					if(!mid.equals("")) {
						str += "<div class=\"replymenu\"><span class=\"mr-2\" onclick=\"rreplyPreview("+p.getReplyIdx()+")\">답글</span>";
						if(mid.equals(c.getReplyMid())) str += "<span class=\"mr-2\" onclick=\"replyEditPopup("+c.getReplyIdx()+", '"+c.getReplyContent()+"')\">수정</span>";
						if((mid.equals(c.getReplyMid()) && level != 0) || level == 0) str += "<span class=\"mr-2\" onclick=\"replyDelete("+c.getReplyIdx()+", 1)\">삭제</span>";
						str += "<span class=\"mr-2\" onclick=\"reportPopup("+c.getReplyIdx()+", '댓글', '"+c.getReplyMid()+"')\">신고</span>";
						str += "</div>";
					}
					str += "</div></div></div>";
				}
			}
			str += "</div>"
				+ "<div id=\"rreplyWrite"+p.getReplyIdx()+"\" style=\"display:none; justify-content: center;\">"
				+ "<div style=\"display:flex;\">"
				+ "<img src=\""+request.getContextPath()+"/member/"+memImg+"\" alt=\"프로필\" class=\"reply-pic\">"
				+ "<textarea id=\"rreplyContent"+p.getReplyIdx()+"\" name=\"rreplyContent\" rows=\"2\" placeholder=\"답글을 작성해 보세요.\" class=\"form-control textarea\" style=\"background-color:#32373d;\"></textarea></div>"
				+ "<div style=\"display:flex; justify-content: flex-end; margin-top: 5px;\">"
				+ "<div class=\"replyno-button mr-2\" onclick=\"rreplyPreview("+p.getReplyIdx()+")\">취소</div>"
				+ "<div class=\"replyok-button\" onclick=\"rreplyInput("+p.getReplyIdx()+", "+vo.getCmIdx()+")\">작성</div>"
				+ "</div></div>";
		}
		str += "</div>";
	    if(!mid.equals("")) {
				str += "<div id=\"replyPreview"+vo.getCmIdx()+"\" style=\"display:flex; align-items: center; justify-content: center;\">"
				+"<img src=\""+request.getContextPath()+"/member/"+memImg+"\" alt=\"프로필\" class=\"reply-pic\">"	
				+"<div class=\"text-input\" onclick=\"replyPreview("+vo.getCmIdx()+")\">댓글을 작성해 보세요.</div></div>"		
		        + "<div id=\"replyWrite"+vo.getCmIdx()+"\" style=\"display:none; justify-content: center;\">"
		        +"<div style=\"display:flex;\">"
		        +"<img src=\""+request.getContextPath()+"/member/"+memImg+"\" alt=\"프로필\" class=\"reply-pic\">"
		        +"<textarea id=\"replyContent"+vo.getCmIdx()+"\" name=\"replyContent\" rows=\"2\" placeholder=\"댓글을 작성해 보세요.\" class=\"form-control textarea\" style=\"background-color:#32373d;\"></textarea></div>"
		        +"<div style=\"display:flex; justify-content: flex-end; margin-top: 5px;\">"
		        +"<div class=\"replyno-button mr-2\" onclick=\"replyCancel("+vo.getCmIdx()+")\">취소</div>"
		        +"<div class=\"replyok-button\" onclick=\"replyInput("+vo.getCmIdx()+")\">작성</div>"
		        +"</div></div>";
	    }
	    str += "</div>";
		return str;
	}
	
	
	@RequestMapping(value = "/gameview/{gameIdx}/review", method = RequestMethod.GET)
	public String gameReview(Model model, @PathVariable int gameIdx, HttpSession session,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "20", required = false) int pageSize) {
		String mid = (String) session.getAttribute("sMid");
		GameVO vo = homeService.getGame(gameIdx);
		model.addAttribute("vo", vo);
		
		int totRecCnt = homeService.getGameViewRCTotRecCnt(gameIdx, "리뷰");
		int totPage = (totRecCnt % pageSize)== 0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("totRecCnt", totRecCnt);
		model.addAttribute("page", page);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> cmVOS = homeService.getGameViewRCList(mid, startIndexNo, pageSize, gameIdx, "리뷰");
		model.addAttribute("cmVOS", cmVOS);
		
		// 리뷰 수정용
		String cmContent = communityDAO.getCMReview(gameIdx, mid);
		ReviewVO revVO = reviewService.getMidAndIdx(gameIdx, mid);
		model.addAttribute("cmContent", cmContent);
		model.addAttribute("revVO", revVO);
		
		int ilgiCnt = homeService.ilgiCnt(gameIdx);
		int infoCnt = homeService.infoCnt(gameIdx);
		model.addAttribute("ilgiCnt", ilgiCnt);
		model.addAttribute("infoCnt", infoCnt);
		
		return "game/gameReview";
	}
	
	@RequestMapping(value = "/gameview/{gameIdx}/record", method = RequestMethod.GET)
	public String gameRecord(Model model, @PathVariable int gameIdx, HttpSession session,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "20", required = false) int pageSize) {
		String mid = (String) session.getAttribute("sMid");
		GameVO vo = homeService.getGame(gameIdx);
		model.addAttribute("vo", vo);
		
		int totRecCnt = homeService.getGameViewRCTotRecCnt(gameIdx, "일지");
		int totPage = (totRecCnt % pageSize)== 0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> cmVOS = homeService.getGameViewRCList(mid, startIndexNo, pageSize, gameIdx, "일지");
		model.addAttribute("cmVOS", cmVOS);
		
		int ilgiCnt = homeService.ilgiCnt(gameIdx);
		int infoCnt = homeService.infoCnt(gameIdx);
		int reviewCnt = homeService.getGameViewRCTotRecCnt(gameIdx, "리뷰");
		model.addAttribute("reviewCnt", reviewCnt);
		model.addAttribute("ilgiCnt", ilgiCnt);
		model.addAttribute("infoCnt", infoCnt);
		
		return "game/gameRecord";
	}
	
	@RequestMapping(value = "/gameview/{gameIdx}/info", method = RequestMethod.GET)
	public String gameInfo(Model model, @PathVariable int gameIdx, HttpSession session,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "20", required = false) int pageSize) {
		String mid = (String) session.getAttribute("sMid");
		GameVO vo = homeService.getGame(gameIdx);
		model.addAttribute("vo", vo);
		
		int totRecCnt = homeService.getGameViewRCTotRecCnt(gameIdx, "소식/정보");
		int totPage = (totRecCnt % pageSize)== 0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> cmVOS = homeService.getGameViewRCList(mid, startIndexNo, pageSize, gameIdx, "소식/정보");
		model.addAttribute("cmVOS", cmVOS);
		
		int ilgiCnt = homeService.ilgiCnt(gameIdx);
		int infoCnt = homeService.infoCnt(gameIdx);
		int reviewCnt = homeService.getGameViewRCTotRecCnt(gameIdx, "리뷰");
		model.addAttribute("reviewCnt", reviewCnt);
		model.addAttribute("ilgiCnt", ilgiCnt);
		model.addAttribute("infoCnt", infoCnt);
		
		return "game/gameInfo";
	}
	
}
