
package com.spring.javaclassS4.controller;

import java.net.HttpURLConnection;
import java.net.URL;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS4.service.MemberService;
import com.spring.javaclassS4.vo.MemberVO;

@Controller
@RequestMapping("/member")
public class MemberController {
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@Transactional
	@RequestMapping(value = "/kakaoLogin", method = RequestMethod.GET)
	public String kakaoLoginGet(String accessToken, String nickname, String email, String flag,
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
			vo.setMemImg("noimage.jpg");
			
			try {
				memberService.setMemberInput(vo);
				memberService.setMemberBasicGameList(mid);
			} catch (Exception e) {
				return "redirect:/message/memberJoinNo";
			}
			
		}
		
		if(vo.getLoginState().equals("BAN")) return "redirect:/message/userBAN";
		if(vo.getLoginState().equals("OUT")) return "redirect:/message/userOUT";
		if(vo.getLoginState().equals("NO")) return "redirect:/message/loginStateNO";
		
		session.setAttribute("sMid", vo.getMid());
		session.setAttribute("sNickname", vo.getNickname());
		session.setAttribute("sLevel", vo.getLevel());
		session.setAttribute("sMemImg", vo.getMemImg());
		session.setAttribute("sKakao", "OK");
		
		return "redirect:/message/memberLoginOk?mid="+vo.getMid()+"&flag="+flag;
	}
	
	@RequestMapping(value = "/memberLogin", method = RequestMethod.POST)
	public String memberLoginPost(String email, String pwd, String flag, HttpSession session) {
		MemberVO vo = memberService.getMemberEmailCheck(email);
		
		if(vo == null) return "redirect:/message/memberLoginNo";
		else if(vo.getLoginState().equals("BAN")) return "redirect:/message/userBAN";
		else if(vo.getLoginState().equals("OUT")) return "redirect:/message/userOUT";
		else if(vo.getLoginState().equals("NO")) {
			
			return "redirect:/message/loginStateNO";
		}
		else if(!passwordEncoder.matches(pwd, vo.getPwd())) return "redirect:/message/memberLoginNo";
		else {
			session.setAttribute("sMid", vo.getMid());
			session.setAttribute("sNickname", vo.getNickname());
			session.setAttribute("sLevel", vo.getLevel());
			session.setAttribute("sMemImg", vo.getMemImg());
			session.setAttribute("sKakao", "NO");
			return "redirect:/message/memberLoginOk?mid="+vo.getMid()+"&flag="+flag;
		}
	}
	
	@RequestMapping(value = "/memberLogout", method = RequestMethod.GET)
	public String memberLogoutGet(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}
	
	@RequestMapping(value = "/kakaoLogout", method = RequestMethod.GET)
	public String kakaoLogoutGet(HttpSession session) {
		String accessToken = (String) session.getAttribute("sAccessToken");
		String reqURL = "https://kapi.kakao.com/v1/user/unlink";
		
		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.addRequestProperty("Authorization", " " + accessToken);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		session.invalidate();
		
		return "redirect:/";
	}
	
	@Transactional
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
		
		int res = 0;
		try {
			res = memberService.setMemberInput(vo);
			memberService.setMemberBasicGameList(mid);
		} catch (Exception e) {
			res = 0;
		}
		
		if(res != 0) return "redirect:/message/memberJoinOk";
		else return "redirect:/message/memberJoinNo";
	}
	
	@ResponseBody
	@RequestMapping(value = "/memberIdCheck", method = RequestMethod.POST)
	public String memberIdCheckPost(String mid) {
		MemberVO vo = memberService.getMemberIdCheck(mid);
		if(vo != null) return "0";
		else return "1";
	}
	
	@ResponseBody
	@RequestMapping(value = "/memberIdChange", method = RequestMethod.POST)
	public String memberIdChangePost(String mid, HttpSession session) {
		String sMid = (String) session.getAttribute("sMid");
		
		if(sMid == null) return "redirect:/";
		
		int res = memberService.setMemberIdChange(mid, sMid);
		if(res != 0) {
			session.setAttribute("sMid", mid);
			return "1";
		}
		else return "0";
	}
	
	@ResponseBody
	@RequestMapping(value = "/memberPhotoChange", method = RequestMethod.POST)
	public String memberPhotoChangePost(String mid, HttpSession session, MultipartFile fName, HttpServletRequest request) {
		int res = memberService.setmemberPhotoChangePost(mid, fName, request, session);
		
		if(res != 0) return "1";
		else return "0";
	}
	
	@ResponseBody
	@RequestMapping(value = "/memberEdit", method = RequestMethod.POST)
	public String memberEditPost(String nickname, String memInfo, HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		
		if(mid == null) return "redirect:/";
		
		int res = memberService.setmemberEdit(nickname, memInfo, mid);
		if(res != 0) {
			session.setAttribute("sNickname", nickname);
			return "1";
		}
		else return "0";
	}
	
}
