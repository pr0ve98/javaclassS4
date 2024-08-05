package com.spring.javaclassS4.interceptor;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class Level3Interceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		HttpSession session = request.getSession();
		int level = session.getAttribute("sLevel")==null ? 99 : (int) session.getAttribute("sLevel");
		
		// 관리자(0), 우수회원(1), 정회원(2), 비회원(3)
		if(level > 3) {
			RequestDispatcher dispatcher = request.getRequestDispatcher("/message/memberNo");
			dispatcher.forward(request, response);
			return false;
		}
		return true;
	}
	
}
