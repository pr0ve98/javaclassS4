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
import com.spring.javaclassS4.vo.CommunityVO;

@Controller
@RequestMapping("/news")
public class NewsController {
	
	@Autowired
	CommunityService communityService;
	
	@RequestMapping(value = "/newsRecent", method = RequestMethod.GET)
	public String newsRecent(HttpSession session, Model model,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "20", required = false) int pageSize) {
		
		int totRecCnt = communityService.getNewsCnt("전체");
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totRecCnt", totRecCnt);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> vos = communityService.getNewsList(startIndexNo, pageSize, "전체");
		model.addAttribute("cmVOS", vos);
		
		return "news/newsRecent";
	}
	
	@RequestMapping(value = "/newsReport", method = RequestMethod.GET)
	public String newsReport(HttpSession session, Model model,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "20", required = false) int pageSize) {
		
		int totRecCnt = communityService.getNewsCnt("전체");
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totRecCnt", totRecCnt);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> vos = communityService.getNewsList(startIndexNo, pageSize, "취재");
		model.addAttribute("cmVOS", vos);
		
		return "news/newsReport";
	}
	
	@RequestMapping(value = "/newsSale", method = RequestMethod.GET)
	public String newsSale(HttpSession session, Model model,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "20", required = false) int pageSize) {
		
		int totRecCnt = communityService.getNewsCnt("전체");
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totRecCnt", totRecCnt);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> vos = communityService.getNewsList(startIndexNo, pageSize, "예판");
		model.addAttribute("cmVOS", vos);
		
		return "news/newsSale";
	}
	
	@RequestMapping(value = "/newsInput", method = RequestMethod.GET)
	public String newsInput(Model model,
			@RequestParam(name="part", defaultValue = "", required = false) String part) {
		model.addAttribute("part", part);
		return "news/newsInput";
	}
	
	@RequestMapping(value = "/{cmIdx}", method = RequestMethod.GET)
	public String newsInput(@PathVariable int cmIdx, Model model, HttpSession session) {
		String mid = session.getAttribute("sMid")==null ? "" : (String) session.getAttribute("sMid");
		CommunityVO cmVO = communityService.getNewsContentCmIdx(cmIdx, mid);
		model.addAttribute("cmVO", cmVO);
		return "news/newsView";
	}
	
	@RequestMapping(value = "/{cmIdx}/edit", method = RequestMethod.GET)
	public String newsEdit(@PathVariable int cmIdx, Model model, HttpSession session) {
		CommunityVO vo = communityService.getCommunityIdx(cmIdx);
		model.addAttribute("vo", vo);
		return "news/newsEdit";
	}
}