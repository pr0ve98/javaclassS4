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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS4.service.CommunityService;
import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.GameVO;

@Controller
@RequestMapping("/community")
public class CommunityController {
	
	@Autowired
	CommunityService communityService;
	
	@RequestMapping(value = "/recent", method = RequestMethod.GET)
	public String recentGet(Model model, HttpSession session,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "10", required = false) int pageSize) {
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
		
		int totRecCnt = communityService.getTotRecCnt("recent");
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> cmVOS = communityService.getCommunityList(mid, startIndexNo, pageSize);
		
		model.addAttribute("cmVOS", cmVOS);
		model.addAttribute("flag", "community");
		return "community/recent";
	}
	
	@RequestMapping(value = "/info", method = RequestMethod.GET)
	public String infoGet(Model model, HttpSession session,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "10", required = false) int pageSize) {
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
		
		int totRecCnt = communityService.getTotRecCnt("info");
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> cmVOS = communityService.getCommunityPartList(mid, startIndexNo, pageSize, "info");
		
		model.addAttribute("cmVOS", cmVOS);
		model.addAttribute("flag", "community");
		return "community/info";
	}
	
	@RequestMapping(value = "/sale", method = RequestMethod.GET)
	public String saleGet(Model model, HttpSession session,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "10", required = false) int pageSize) {
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
		
		int totRecCnt = communityService.getTotRecCnt("sale");
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> cmVOS = communityService.getCommunityPartList(mid, startIndexNo, pageSize, "sale");
		
		model.addAttribute("cmVOS", cmVOS);
		model.addAttribute("flag", "community");
		return "community/sale";
	}
	
	@RequestMapping(value = "/my", method = RequestMethod.GET)
	public String myGet(Model model, HttpSession session,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "10", required = false) int pageSize) {
		String mid = (String) session.getAttribute("sMid");
		
		int totRecCnt = communityService.getMyTotRecCnt(mid);
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> cmVOS = communityService.getCommunityPartList(mid, startIndexNo, pageSize, "my");
		
		model.addAttribute("cmVOS", cmVOS);
		model.addAttribute("flag", "community");
		return "community/my";
	}
	
	@ResponseBody
	@RequestMapping(value = "/imageUpload", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String imageUploadPost(MultipartFile file, HttpServletRequest request) {
		return communityService.imageUpload(file, request);
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteImage", method = RequestMethod.POST, produces = "application/text; charset=utf8")
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
		
		if(mid == null) return "redirect:/";
		
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
	
	@ResponseBody
	@RequestMapping(value = "/communityInput", method = RequestMethod.POST)
	public String communityInputPost(CommunityVO vo, HttpServletRequest request) {
		String hostIp = request.getRemoteAddr();
		vo.setCmHostIp(hostIp);
		return communityService.communityInput(vo)+"";
	}
	
	@ResponseBody
	@RequestMapping(value = "/showAllContent", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String showAllContentPost(int cmIdx) {
		CommunityVO vo = communityService.showAllContent(cmIdx);
		return vo.getCmContent();
	}
	
	@ResponseBody
	@RequestMapping(value = "/likeAdd", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String likeAddPost(int cmIdx, HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		if(mid == null) return "redirect:/";
		
		communityService.setLikeAdd(mid, cmIdx);
		CommunityVO vo = communityService.getCommunityIdx(cmIdx);
		String str = "이 글을 "+vo.getLikeCnt() +"명이 좋아합니다.";
		String str2 = "<span style=\"color:#00c722;\" onclick=\"likeDelete("+vo.getCmIdx()+")\"><i class=\"fa-solid fa-heart\"></i>&nbsp;&nbsp;좋아요</span>";
		return str + "%" + str2;
	}
	
	@ResponseBody
	@RequestMapping(value = "/likeDelete", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String likeDeletePost(int cmIdx, HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		if(mid == null) return "redirect:/";
		
		communityService.setlikeDelete(mid, cmIdx);
		CommunityVO vo = communityService.getCommunityIdx(cmIdx);
		String str = "이 글을 "+vo.getLikeCnt() +"명이 좋아합니다.";
		String str2 = "<span onclick=\"likeAdd("+vo.getCmIdx()+")\"><i class=\"fa-solid fa-heart\"></i>&nbsp;&nbsp;좋아요</span>";
		return str + "%" + str2;
	}
	
	@ResponseBody
	@RequestMapping(value = "/rootData", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String rootDataPost(HttpSession session, HttpServletRequest request, String part,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "10", required = false) int pageSize) {
		String mid = (String) session.getAttribute("sMid");
		int startIndexNo = (page - 1) * pageSize;
		ArrayList<CommunityVO> cmVOS = null;
		if(part.equals("recent")) cmVOS = communityService.getCommunityList(mid, startIndexNo, pageSize);
		else if(part.equals("info")) cmVOS = communityService.getCommunityPartList(mid, startIndexNo, pageSize, part);
		else if(part.equals("sale")) cmVOS = communityService.getCommunityPartList(mid, startIndexNo, pageSize, part);
		else if(part.equals("my")) cmVOS = communityService.getCommunityPartList(mid, startIndexNo, pageSize, part);
		
		String str = "";
		for(CommunityVO vo : cmVOS) {
			str += "<div class=\"cm-box\"><div style=\"display:flex; align-items: center;\">";
			str += "<img src=\""+request.getContextPath()+"/member/"+vo.getMemImg()+"\" alt=\"프로필\" class=\"text-pic\"><div>"
					+"<div style=\"font-size:12px;\">"+vo.getTitle()+"</div>"
					+"<div style=\"font-weight:bold;\">"+vo.getNickname()+"</div><div>";
			// 카테고리 분류
			if(vo.getPart().equals("소식/정보")) str += "<span class=\"badge badge-secondary\">소식/정보</span>&nbsp;";
			else if(vo.getPart().equals("자유")) str += "<span class=\"badge badge-secondary\">자유글</span>&nbsp;";
			else if(vo.getPart().equals("세일")) str += "<span class=\"badge badge-secondary\">세일정보</span>&nbsp;";
			else str += "<span style=\"color:#b2bdce; font-size:12px;\"><i class=\"fa-solid fa-gamepad fa-xs\" style=\"color: #b2bdce;\"></i>&nbsp;"+vo.getGameTitle()+"</span>";
			
			str += "</div></div></div>"
				+"<div class=\"community-content\">";
			
			// 긴 글인지 아닌지 유무
			if(vo.getLongContent() == 1) {
				str += "<div class=\"cm-content moreGra\" id=\"cmContent"+vo.getCmIdx()+"\">"+vo.getCmContent()+"</div>"
					+"<div onclick=\"showAllContent("+vo.getCmIdx()+")\" id=\"moreBtn"+vo.getCmIdx()+"\" style=\"cursor:pointer; color:#00c722; font-weight:bold;\">더 보기</div>";
			}
			else str += "<div class=\"cm-content\" id=\"cmContent"+vo.getCmIdx()+"\">"+vo.getCmContent()+"</div>";
			
			str += "<div style=\"color:#b2bdce; font-size:12px;\" class=\"mt-2\">";
			
			// 시간 표시
			if(vo.getHour_diff() < 1) str += vo.getMin_diff()+"분 전";
			else if(vo.getHour_diff() < 24 && vo.getHour_diff() >= 1) str += vo.getHour_diff()+"시간 전";
			else str += vo.getCmDate().substring(0,10);
			
			str += "</div><div style=\"color:#b2bdce; font-size:12px;\" class=\"mt-2\"><span id=\"cm-likeCnt"+vo.getCmIdx()+"\">이 글을 "+vo.getLikeCnt()+"명이 좋아합니다.</span></div></div>";
			
			// 비로그인 유저 기능 사용 불가
			if(mid != null) {
				str += "<hr/><div class=\"community-footer\"><span id=\"cm-like"+vo.getCmIdx()+"\">";
				if(vo.getLikeSW() == 0) str += "<span onclick=\"likeAdd("+vo.getCmIdx()+")\"><i class=\"fa-solid fa-heart\"></i>&nbsp;&nbsp;좋아요</span>";
				else str += "<span style=\"color:#00c722;\" onclick=\"likeDelete("+vo.getCmIdx()+")\"><i class=\"fa-solid fa-heart\"></i>&nbsp;&nbsp;좋아요</span>";
				str += "</span><span><i class=\"fa-solid fa-comment-dots\"></i>&nbsp;&nbsp;댓글</span></div><hr/>"
					+"<div style=\"display:flex; align-items: center; justify-content: center;\">"
					+"<img src=\""+request.getContextPath()+"/member/"+vo.getMemImg()+"\" alt=\"프로필\" class=\"text-pic\">"
					+"<div class=\"text-input\">댓글을 작성해 보세요.</div></div>";
			}
			str += "</div>";
		}
		
		return str;
	}
		
	
}
