package com.spring.javaclassS4.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HomeController {
	
	@RequestMapping(value = {"/", "/main"}, method = RequestMethod.GET)
	public String home(Model model) {
		model.addAttribute("flag", "main");
		return "home";
	}
	
}
