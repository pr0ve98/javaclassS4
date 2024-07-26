package com.spring.javaclassS4.controller;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
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
			@RequestParam(name="viewpart", defaultValue = "gameIdx desc", required = false) String viewpart,
			@RequestParam(name="searchpart", defaultValue = "제목", required = false) String searchpart,
			@RequestParam(name="search", defaultValue = "", required = false) String search,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "20", required = false) int pageSize) {
		
		int totRecCnt = adminService.getGameTotRecCnt(searchpart, search);
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totRecCnt", totRecCnt);
		model.addAttribute("totPage", totPage);
		
		ArrayList<GameVO> vos = adminService.getGameList(startIndexNo, pageSize, viewpart, searchpart, search);
		
		model.addAttribute("vos", vos);
		model.addAttribute("viewpart", viewpart);
		model.addAttribute("searchpart", searchpart);
		model.addAttribute("search", search);
		
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
	
	@ResponseBody
	@RequestMapping(value = "/gameEdit", method = RequestMethod.POST)
	public String gameEdit(@RequestParam("fileName") MultipartFile fileName, @RequestParam("gameIdx") String gameIdx,
			@RequestParam("gameTitle") String gameTitle,
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
		vo.setGameIdx(Integer.parseInt(gameIdx));
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
		
		int res = adminService.gameEdit(vo, fileName, request);
		if(res == 1) return "1";
		else if(res == 2) return "2";
		else return "0";
	}
	
	@ResponseBody
	@RequestMapping(value = "/gameEdit2", method = RequestMethod.POST)
	public String gameEdit2(@RequestBody GameVO vo) {
		int res = adminService.gameEdit2(vo);
		if(res == 1) return "1";
		else if(res == 2) return "2";
		else return "0";
	}
	
	@ResponseBody
	@RequestMapping(value = "/gameDelete", method = RequestMethod.POST)
	public String gameDelete(int gameIdx, String gameImg, HttpServletRequest request) {
		int res = adminService.gameDelete(gameIdx, gameImg, request);
		if(res != 0) return "1";
		else return "0";
	}
	
	@RequestMapping(value = "/userlist", method = RequestMethod.GET)
	public String userlist(HttpSession session, Model model,
			@RequestParam(name="viewpart", defaultValue = "all", required = false) String viewpart,
			@RequestParam(name="searchpart", defaultValue = "아이디", required = false) String searchpart,
			@RequestParam(name="search", defaultValue = "", required = false) String search,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "10", required = false) int pageSize) {
		
		int totRecCnt = 0;
		ArrayList<GameVO> vos = null;
		
		if(viewpart.equals("all")) {
			totRecCnt = adminService.getAllUserTotRecCnt(searchpart, search);
			int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
			int startIndexNo = (page - 1) * pageSize;
			model.addAttribute("page", page);
			model.addAttribute("totRecCnt", totRecCnt);
			model.addAttribute("totPage", totPage);
			
			vos = adminService.getAllUserList(startIndexNo, pageSize, searchpart, search);
			model.addAttribute("vos", vos);
		}
		else if(viewpart.equals("0") || viewpart.equals("1") || viewpart.equals("2")) {
			totRecCnt = adminService.getLevelUserTotRecCnt(viewpart, searchpart, search);
			int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
			int startIndexNo = (page - 1) * pageSize;
			model.addAttribute("page", page);
			model.addAttribute("totRecCnt", totRecCnt);
			model.addAttribute("totPage", totPage);
			
			vos = adminService.getLevelUserList(startIndexNo, pageSize, viewpart, searchpart, search);
			model.addAttribute("vos", vos);
		}
		else if(viewpart.equals("NO") || viewpart.equals("OK") || viewpart.equals("BAN")|| viewpart.equals("OUT")) {
			totRecCnt = adminService.getStateUserTotRecCnt(viewpart, searchpart, search);
			int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
			int startIndexNo = (page - 1) * pageSize;
			model.addAttribute("page", page);
			model.addAttribute("totRecCnt", totRecCnt);
			model.addAttribute("totPage", totPage);
			
			vos = adminService.getStateUserList(startIndexNo, pageSize, viewpart, searchpart, search);
			model.addAttribute("vos", vos);
		}
		else {
			totRecCnt = adminService.getKakaoUserTotRecCnt(viewpart, searchpart, search);
			int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
			int startIndexNo = (page - 1) * pageSize;
			model.addAttribute("page", page);
			model.addAttribute("totRecCnt", totRecCnt);
			model.addAttribute("totPage", totPage);
			
			vos = adminService.getKakaoUserList(startIndexNo, pageSize, viewpart, searchpart, search);
			model.addAttribute("vos", vos);
		}
		
		model.addAttribute("viewpart", viewpart);
		model.addAttribute("searchpart", searchpart);
		model.addAttribute("search", search);
		
		return "admin/userlist";
	}
	
	@ResponseBody
	@RequestMapping(value = "/levelChange", method = RequestMethod.POST)
	public String levelChange(int level, int idx, String nickname) {
		int res = adminService.levelChange(level, idx, nickname);
		return res+"";
	}
	
	@ResponseBody
	@RequestMapping(value = "/banInput", method = RequestMethod.POST)
	public void banInput(String banMid, String reason) {
		adminService.banInput(banMid, reason);
	}
	
	@ResponseBody
	@RequestMapping(value = "/bannerChange", method = RequestMethod.POST)
	public void bannerChange(HttpSession session, MultipartFile fName, HttpServletRequest request) {
		adminService.bannerChange(fName, request, session);
	}
	
	
}
