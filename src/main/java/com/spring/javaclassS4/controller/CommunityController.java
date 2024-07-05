package com.spring.javaclassS4.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.javaclassS4.service.CommunityService;

@Controller
@RequestMapping("/community")
public class CommunityController {
	
	@Autowired
	CommunityService communityService;
	
	@RequestMapping(value = "/recent", method = RequestMethod.GET)
	public String kakaoLoginGet(Model model) {
		model.addAttribute("flag", "community");
		return "community/recent";
	}
	
	
}
