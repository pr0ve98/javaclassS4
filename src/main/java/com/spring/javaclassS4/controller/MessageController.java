package com.spring.javaclassS4.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MessageController {
	
	@RequestMapping(value = "/message/{msgFlag}", method = RequestMethod.GET)
	public String getMessage(Model model,
			@PathVariable String msgFlag,
			@RequestParam(name="mid", defaultValue = "", required = false) String mid,
			@RequestParam(name="idx", defaultValue = "", required = false) String idx,
			@RequestParam(name="pag", defaultValue = "1", required = false) String pag,
			@RequestParam(name="pageSize", defaultValue = "5", required = false) String pageSize
			) {
		
		if(msgFlag.equals("memberLoginOk")) {
			model.addAttribute("msg", mid+"님 로그인 되었습니다!");
			model.addAttribute("url", "/");
		}
		else if(msgFlag.equals("memberLoginNo")) {
			model.addAttribute("msg", "해당 유저가 없거나 비밀번호가 틀립니다\\n카카오로 가입했다면 카카오 로그인을 해주세요");
			model.addAttribute("url", "/");
		}
		else if(msgFlag.equals("emailNo")) {
			model.addAttribute("msg", "중복되는 이메일입니다! 다시 시도해주세요");
			model.addAttribute("url", "/");
		}
		else if(msgFlag.equals("memberJoinOk")) {
			model.addAttribute("msg", "회원가입 완료! 로그인해주세요");
			model.addAttribute("url", "/");
		}
		else if(msgFlag.equals("memberJoinNo")) {
			model.addAttribute("msg", "회원가입 실패...");
			model.addAttribute("url", "/");
		}
		
		return "include/message";
	}
}
