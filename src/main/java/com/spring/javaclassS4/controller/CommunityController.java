package com.spring.javaclassS4.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS4.service.CommunityService;
import com.spring.javaclassS4.vo.GameVO;

@Controller
@RequestMapping("/community")
public class CommunityController {
	
	@Autowired
	CommunityService communityService;
	
	@RequestMapping(value = "/recent", method = RequestMethod.GET)
	public String kakaoLoginGet(Model model, HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		if(mid != null) {
			String[] gamelist = communityService.getMemberGamelist(mid).split("/");
			
			GameVO vo = null;
			ArrayList<GameVO> vos = new ArrayList<GameVO>();
			for(int i=0; i<gamelist.length; i++) {
				vo = communityService.getGameIdx(Integer.parseInt(gamelist[i]));
				vos.add(vo);
			}
			
			model.addAttribute("vos", vos);
		}
		model.addAttribute("flag", "community");
		return "community/recent";
	}
	
	@ResponseBody
	@RequestMapping(value = "/imageUpload", method = RequestMethod.POST)
	public String imageUploadPost(MultipartFile file, HttpServletRequest request) {
		return communityService.imageUpload(file, request);
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteImage", method = RequestMethod.POST)
	public void deleteImagePost(String src, HttpServletRequest request) {
		communityService.deleteImage(src, request);
	}
	
	@ResponseBody
	@RequestMapping(value = "/gameSearch", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String gameSearchPost(String game) {
		return communityService.gameSearch(game);
	}
	
	@ResponseBody
	@RequestMapping(value = "/memGameListEdit", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String memGameListEditPost(int gameIdx, HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		String gamelist = communityService.getMemberGamelist(mid);
		
		List<String> gameListArray = new ArrayList<>(Arrays.asList(gamelist.split("/")));
	    boolean gameExists = gameListArray.contains(String.valueOf(gameIdx));
		
	    if(!gameExists) {
	    	gamelist = gameIdx + "/" + gamelist.substring(0, gamelist.lastIndexOf("/"));
	    	communityService.setMemGameListEdit(gamelist, mid);
	    }
		
		String str = "";
		String[] gamelist2 = communityService.getMemberGamelist(mid).split("/");
		
	    GameVO vo = null;
	    boolean activeSet = false;
	    for (String game : gamelist2) {
	        vo = communityService.getGameIdx(Integer.parseInt(game));
	        String activeClass = "";
	        if (!gameExists && !activeSet) {
	            activeClass = "active";
	            activeSet = true; // 첫 번째 추가된 게임에만 active 클래스를 추가
	        } else if (game.equals(String.valueOf(gameIdx)) && gameExists) {
	            activeClass = "active";
	        }
	        str += "<button class=\"game-button " + activeClass + "\" data-game=\"" + vo.getGameTitle() + "\" data-idx=\"" + vo.getGameIdx() + "\">"
	                + "<img src=\"" + vo.getGameImg() + "\" alt=\"" + vo.getGameIdx() + "\">"
	                + "<div class=\"game-name\">" + vo.getGameTitle() + "</div></button>";
	    }
	    return str;
	}
		
	
}
