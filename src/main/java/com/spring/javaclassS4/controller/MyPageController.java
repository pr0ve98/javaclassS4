package com.spring.javaclassS4.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.javaclassS4.service.CommunityService;
import com.spring.javaclassS4.service.MemberService;
import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.FollowVO;
import com.spring.javaclassS4.vo.GameVO;
import com.spring.javaclassS4.vo.MemberVO;
import com.spring.javaclassS4.vo.ReviewVO;

@Controller
@RequestMapping("/mypage")
public class MyPageController {
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	CommunityService communityService;
	
	@RequestMapping(value = "/{mid}", method = RequestMethod.GET)
	public String myPage(HttpSession session, Model model,@PathVariable String mid) {
		String sMid = session.getAttribute("sMid")==null ? "" : (String)session.getAttribute("sMid");
		
		MemberVO member = memberService.getMemberIdCheck(mid);
		if(member == null || member.getLoginState().equals("OUT")) return "redirect:/errorPage";
		model.addAttribute("member", member);
		
		String isFollow = "NO";
		FollowVO fvo = memberService.isMyFollower(sMid, mid);
		if(fvo != null) isFollow = "OK";
		model.addAttribute("isFollow", isFollow);
		
		int follower = memberService.getFollowerAndFollowing(mid, "follower");
		int following = memberService.getFollowerAndFollowing(mid, "following");
		model.addAttribute("follower", follower);
		model.addAttribute("following", following);
		
		int mygame = communityService.getMygameAndPart(mid, "game");
		int myreview = communityService.getMygameAndPart(mid, "review");
		int myilji = communityService.getMygameAndPart(mid, "ilji");
		model.addAttribute("mygame", mygame);
		model.addAttribute("myreview", myreview);
		model.addAttribute("myilji", myilji);
		
		ArrayList<ReviewVO> mygameVOS = communityService.getRecentMyGame(mid);
		model.addAttribute("mygameVOS", mygameVOS);
		
		ArrayList<CommunityVO> myreviewVOS = communityService.getMyReview(mid);
		model.addAttribute("myreviewVOS", myreviewVOS);
		
		return "mypage/mymain";
	}
	
	@RequestMapping(value = "/{mid}/myreview", method = RequestMethod.GET)
	public String myReview(HttpSession session, Model model, @PathVariable String mid,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "10", required = false) int pageSize) {
		String sMid = session.getAttribute("sMid")==null ? "" : (String)session.getAttribute("sMid");
		MemberVO member = memberService.getMemberIdCheck(mid);
		if(member == null || member.getLoginState().equals("OUT")) return "redirect:/errorPage";
		model.addAttribute("member", member);
		
		int totRecCnt = communityService.getMygameAndPart(mid, "review");
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> cmVOS = communityService.getMyReviewList(sMid, mid, startIndexNo, pageSize);
		model.addAttribute("cmVOS", cmVOS);
		
		return "mypage/myreview";
	}
	
	@RequestMapping(value = "/{mid}/myrecord", method = RequestMethod.GET)
	public String myrecord(HttpSession session, Model model, @PathVariable String mid,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "10", required = false) int pageSize) {
		String sMid = session.getAttribute("sMid")==null ? "" : (String)session.getAttribute("sMid");
		MemberVO member = memberService.getMemberIdCheck(mid);
		if(member == null || member.getLoginState().equals("OUT")) return "redirect:/errorPage";
		model.addAttribute("member", member);
		
		if(sMid != null) {
			String[] gamelist = communityService.getMemberGamelist(sMid).split("/");
			
			GameVO vo = null;
			ArrayList<GameVO> vos = new ArrayList<GameVO>();
			for(int i=0; i<gamelist.length; i++) {
				vo = communityService.getGameIdx(Integer.parseInt(gamelist[i]));
				vos.add(vo);
			}
			
			model.addAttribute("vos", vos);
		}
		
		int totRecCnt = communityService.getMygameAndPart(mid, "ilji");
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> cmVOS = communityService.getMyRecordList(sMid, mid, startIndexNo, pageSize);
		model.addAttribute("cmVOS", cmVOS);
		
		return "mypage/myrecord";
	}
	
	@RequestMapping(value = "/{mid}/mygame", method = RequestMethod.GET)
	public String mygame(HttpSession session, Model model, @PathVariable String mid,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "12", required = false) int pageSize) {
		MemberVO member = memberService.getMemberIdCheck(mid);
		if(member == null || member.getLoginState().equals("OUT")) return "redirect:/errorPage";
		model.addAttribute("member", member);
		
		int totRecCnt = communityService.getMygameAndPart(mid, "game");
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("totRecCnt", totRecCnt);
		model.addAttribute("page", page);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> vos = communityService.getMyGameList(mid, startIndexNo, pageSize);
		model.addAttribute("vos", vos);
		
		return "mypage/mygame";
	}
	
}
