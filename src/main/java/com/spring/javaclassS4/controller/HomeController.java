package com.spring.javaclassS4.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.javaclassS4.service.HomeService;
import com.spring.javaclassS4.vo.GameVO;

@Controller
public class HomeController {
	
	@Autowired
	HomeService homeService;
	
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
	public String gameView(Model model, @PathVariable int gameIdx) {
		GameVO vo = homeService.getGame(gameIdx);
		model.addAttribute("vo", vo);
		return "game/gameView";
	}
	
}
