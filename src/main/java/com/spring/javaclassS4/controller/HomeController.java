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

import com.spring.javaclassS4.service.AdminService;
import com.spring.javaclassS4.service.HomeService;
import com.spring.javaclassS4.vo.GameVO;

@Controller
public class HomeController {
	
	@Autowired
	HomeService homeService;
	
	@Autowired
	AdminService adminService;
	
	@RequestMapping(value = {"/", "/main"}, method = RequestMethod.GET)
	public String home(Model model) {
		ArrayList<GameVO> newgamelist = homeService.getNewGameList();
		
		model.addAttribute("newgamelist", newgamelist);
		model.addAttribute("flag", "main");
		return "home";
	}
	
	@RequestMapping(value = "/gameview/{gameIdx}", method = RequestMethod.GET)
	public String gameView(Model model, @PathVariable int gameIdx) {
		GameVO vo = homeService.getGame(gameIdx);
		model.addAttribute("vo", vo);
		return "game/gameView";
	}
	
	@RequestMapping(value = "/review", method = RequestMethod.GET)
	public String settingGet(HttpSession session, Model model,
			@RequestParam(name="viewpart", defaultValue = "gameIdx desc", required = false) String viewpart,
			@RequestParam(name="searchpart", defaultValue = "제목", required = false) String searchpart,
			@RequestParam(name="search", defaultValue = "", required = false) String search,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "20", required = false) int pageSize) {
		
		int totRecCnt = adminService.getGameTotRecCnt(searchpart, search);
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totRecCnt", totRecCnt);
		model.addAttribute("totPage", totPage);
		
		ArrayList<GameVO> vos = adminService.getGameList(startIndexNo, pageSize, viewpart, searchpart, search);
		
		model.addAttribute("vos", vos);
		model.addAttribute("viewpart", viewpart);
		model.addAttribute("searchpart", searchpart);
		model.addAttribute("search", search);
		
		return "review/reviewAdd";
	}
	
}
