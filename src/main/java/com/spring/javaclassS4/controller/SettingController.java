package com.spring.javaclassS4.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.javaclassS4.service.MemberService;
import com.spring.javaclassS4.service.SettingService;
import com.spring.javaclassS4.vo.MemberVO;

@Controller
@RequestMapping("/setting")
public class SettingController {
	
	@Autowired
	SettingService settingService;
	
	@Autowired
	MemberService memberService;
	
	@RequestMapping(value = "/profile", method = RequestMethod.GET)
	public String settingGet(HttpSession session, Model model) {
		String mid = (String) session.getAttribute("sMid");
		MemberVO vo = memberService.getMemberIdCheck(mid);
		
		if(vo.getIdChange().equals("OK")) model.addAttribute("idChange", "OK");
		
		return "setting/profile";
	}
	
	
}
