package com.spring.javaclassS4.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS4.service.AdminService;
import com.spring.javaclassS4.vo.GameVO;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@Autowired
	AdminService adminService;
	
	@RequestMapping(value = "/gamelist", method = RequestMethod.GET)
	public String settingGet(HttpSession session, Model model,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "20", required = false) int pageSize) {
		
		int totRecCnt = adminService.getGameTotRecCnt();
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totRecCnt", totRecCnt);
		model.addAttribute("totPage", totPage);
		
		ArrayList<GameVO> vos = adminService.getGameList(startIndexNo, pageSize);
		
		model.addAttribute("vos", vos);
		
		return "admin/gamelist";
	}
	
	@ResponseBody
	@RequestMapping(value = "/gameAdd", method = RequestMethod.POST)
	public String gameAdd(String mid, MultipartFile fName, HttpServletRequest request) {
		int res = adminService.gameAdd(mid, fName, request);
		
		if(res != 0) return "1";
		else return "0";
	}
	
	
}
