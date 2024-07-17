package com.spring.javaclassS4.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
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
	@RequestMapping(value = "/gameInput", method = RequestMethod.POST)
	public String gameInput(@RequestParam("fileName") MultipartFile fileName, @RequestParam("gameTitle") String gameTitle,
        @RequestParam("gameSubTitle") String gameSubTitle, @RequestParam("jangre") String jangre,
        @RequestParam("platform") String platform, @RequestParam("showDate") String showDate,
        @RequestParam("price") String price, @RequestParam("metascore") String metascore,
        @RequestParam("steamscore") String steamscore, @RequestParam("steamPage") String steamPage,
        @RequestParam("developer") String developer, @RequestParam("gameInfo") String gameInfo,
        HttpServletRequest request) {
		
		int pri, meta;
		
		if(price.equals("")) pri = 0;
		else pri = Integer.parseInt(price);
		if(metascore.equals("")) meta = 0;
		else meta = Integer.parseInt(metascore);

		GameVO vo = new GameVO();
		vo.setGameTitle(gameTitle);
		vo.setGameSubTitle(gameSubTitle);
		vo.setJangre(jangre);
		vo.setPlatform(platform);
		vo.setShowDate(showDate);
		vo.setPrice(pri);
		vo.setMetascore(meta);
		vo.setSteamscore(steamscore);
		vo.setSteamPage(steamPage);
		vo.setDeveloper(developer);
		vo.setGameInfo(gameInfo);
			
		GameVO testvo = adminService.gameTitleSearch(vo.getGameTitle());
		if(testvo != null) return "2";
		
		int res = adminService.gameInput(vo, fileName, request);
		if(res != 0) return "1";
		else return "0";
	}
	
	@ResponseBody
	@RequestMapping(value = "/gameInput2", method = RequestMethod.POST)
	public String gameInput2(@RequestBody GameVO vo) {
		GameVO testvo = adminService.gameTitleSearch(vo.getGameTitle());
		if(testvo != null) return "2";
		
		int res = adminService.gameInput2(vo);
		if(res != 0) return "1";
		else return "0";
	}
	
	
}
