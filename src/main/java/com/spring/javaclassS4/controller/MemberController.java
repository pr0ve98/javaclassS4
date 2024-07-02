package com.spring.javaclassS4.controller;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.spring.javaclassS4.service.MemberService;
import com.spring.javaclassS4.vo.MemberVO;

@Controller
@RequestMapping("/member")
public class MemberController {
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@RequestMapping(value = "/kakaoLogin", method = RequestMethod.GET)
	public String kakaoLoginGet(String accessToken, String nickname, String email,
			HttpServletRequest request, HttpSession session) throws MessagingException {
		
		session.setAttribute("sAccessToken", accessToken);
		
		MemberVO vo = memberService.getMemberEmailCheck(email);
		
		if(vo == null) {
			String mid = email.substring(0, email.indexOf("@"));
			
			// 만약에 기존에 같은 아이디가 존재한다면 랜덤숫자 부여
			MemberVO midVO = memberService.getMemberIdCheck(mid);
			if(midVO != null) {
				mid = mid + "_" + (int)(Math.random()*(9999-1111+1)+1111);
			}
			vo = new MemberVO();
			vo.setMid(mid);
			vo.setNickname(nickname);
			vo.setEmail(email);
			vo.setPwd("kakaoMember");
			
			memberService.setMemberInput(vo);
			
		}
		
		session.setAttribute("sMid", vo.getMid());
		session.setAttribute("sNickname", vo.getNickname());
		session.setAttribute("sLevel", vo.getLevel());
		session.setAttribute("sMemImg", vo.getMemImg());
		
		return "redirect:/message/memberLoginOk?mid="+vo.getMid();
	}
	
	@RequestMapping(value = "/memberLogin", method = RequestMethod.POST)
	public String memberLoginPost(String email, String pwd, HttpSession session) {
		MemberVO vo = memberService.getMemberEmailCheck(email);
		
		if(vo == null) return "redirect:/message/memberLoginNo";
		else if(!passwordEncoder.matches(pwd, vo.getPwd())) return "redirect:/message/memberLoginNo";
		else {
			session.setAttribute("sMid", vo.getMid());
			session.setAttribute("sNickname", vo.getNickname());
			session.setAttribute("sLevel", vo.getLevel());
			session.setAttribute("sMemImg", vo.getMemImg());
			return "redirect:/message/memberLoginOk?mid="+vo.getMid();
		}
	}
	
	@RequestMapping(value = "/memberJoin", method = RequestMethod.POST)
	public String memberJoinPost(String email, String pwd) {
		if(memberService.getMemberEmailCheck(email) != null) return "redirect:/message/emailNo";
		
		String mid = email.substring(0, email.indexOf("@"));
		
		// 만약에 기존에 같은 아이디가 존재한다면 랜덤숫자 부여
		MemberVO midVO = memberService.getMemberIdCheck(mid);
		if(midVO != null) {
			mid = mid + "_" + (int)(Math.random()*(9999-1111+1)+1111);
		}
		
		MemberVO vo = new MemberVO();
		vo.setMid(mid);
		vo.setNickname(mid);
		vo.setEmail(email);
		vo.setPwd(passwordEncoder.encode(pwd));
		
		int res = memberService.setMemberInput(vo);
		if(res != 0) return "redirect:/message/memberJoinOk";
		else return "redirect:/message/memberJoinNo";
	}
}
