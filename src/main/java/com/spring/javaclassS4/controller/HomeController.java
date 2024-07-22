package com.spring.javaclassS4.controller;

import java.util.ArrayList;

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
	
}
