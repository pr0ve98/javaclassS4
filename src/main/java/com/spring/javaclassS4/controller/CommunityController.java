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
import com.spring.javaclassS4.vo.ReplyVO;
import com.spring.javaclassS4.vo.ReportVO;

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
	
	@RequestMapping(value = "/review", method = RequestMethod.GET)
	public String reviewGet(Model model, HttpSession session,
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
		
		int totRecCnt = communityService.getTotRecCnt("review");
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> cmVOS = communityService.getCommunityPartList(mid, startIndexNo, pageSize, "review");
		
		model.addAttribute("cmVOS", cmVOS);
		model.addAttribute("flag", "community");
		return "community/review";
	}
	
	@RequestMapping(value = "/follow", method = RequestMethod.GET)
	public String followGet(Model model, HttpSession session,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "10", required = false) int pageSize) {
		String mid = (String) session.getAttribute("sMid");
		int totRecCnt = communityService.getFollowTotRecCnt(mid, "follow");
		int totPage = (totRecCnt % pageSize)==0 ? (totRecCnt / pageSize) : (totRecCnt / pageSize)+1;
		int startIndexNo = (page - 1) * pageSize;
		model.addAttribute("page", page);
		model.addAttribute("totPage", totPage);
		
		ArrayList<CommunityVO> cmVOS = communityService.getCommunityFollowList(mid, startIndexNo, pageSize);
		
		model.addAttribute("cmVOS", cmVOS);
		model.addAttribute("flag", "community");
		return "community/follow";
	}
	
	@RequestMapping(value = "/my", method = RequestMethod.GET)
	public String myGet(Model model, HttpSession session,
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
	@RequestMapping(value = "/reviewGameSearch", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String reviewGameSearch(String game) {
		return communityService.reviewGameSearch(game);
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
		
		String str = "", str2 = "";
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
	        str2 += "<button class=\"gameedit-button " + activeClass + "\" data-game=\"" + vo.getGameTitle() + "\" data-editidx=\"" + vo.getGameIdx() + "\">"
	        		+ "<img src=\"" + vo.getGameImg() + "\" alt=\"" + vo.getGameIdx() + "\">"
	        		+ "<div class=\"game-name\">" + vo.getGameTitle() + "</div></button>";
	    }
	    return str + "|" + str2;
	}
	
	@ResponseBody
	@RequestMapping(value = "/communityInput", method = RequestMethod.POST)
	public String communityInputPost(CommunityVO vo, HttpServletRequest request) {
		String hostIp = request.getRemoteAddr();
		vo.setCmHostIp(hostIp);
		return communityService.communityInput(vo)+"";
	}
	
	@ResponseBody
	@RequestMapping(value = "/communityEdit", method = RequestMethod.POST)
	public String communityEditPost(CommunityVO vo, HttpServletRequest request) {
		String hostIp = request.getRemoteAddr();
		vo.setCmHostIp(hostIp);
		int sw = 0;
		if(vo.getPart().equals("자유") || vo.getSection().equals("뉴스")) sw = 1;
		return communityService.communityEdit(vo, sw)+"";
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
		String mid = session.getAttribute("sMid")==null ? "" : (String) session.getAttribute("sMid");
		String memImg = session.getAttribute("sMemImg")==null ? "" : (String) session.getAttribute("sMemImg");
		int level = session.getAttribute("sLevel")==null ? 2 : (int) session.getAttribute("sLevel");
		int startIndexNo = (page - 1) * pageSize;
		ArrayList<CommunityVO> cmVOS = null;
		
		if(part.equals("recent")) cmVOS = communityService.getCommunityList(mid, startIndexNo, pageSize);
		else if(part.equals("follow")) cmVOS = communityService.getCommunityFollowList(mid, startIndexNo, pageSize);
		else cmVOS = communityService.getCommunityPartList(mid, startIndexNo, pageSize, part);
		
		
		String str = "";
		for (CommunityVO vo : cmVOS) {
			ArrayList<ReplyVO> parent = vo.getParentsReply();
			ArrayList<ReplyVO> child = vo.getChildReply();
			int replyCount = vo.getReplyCount();
			
		    str += "<div class=\"cm-box\" id=\"cmbox" + vo.getCmIdx() + "\"><div style=\"display:flex; justify-content:space-between;\">"
		        + "<div style=\"display:flex; align-items:center;\">";
		    str += "<img src=\"" + request.getContextPath() + "/member/" + vo.getMemImg() + "\" alt=\"프로필\" class=\"text-pic\"><div>";
		    if(!vo.getTitle().equals("없음")) str += "<div style=\"font-size:12px;\">" + vo.getTitle() + "</div>";
		    str += "<div style=\"font-weight:bold;\">" + vo.getNickname() + "</div><div>";
		    
		    if (vo.getPart().equals("소식/정보")) str += "<span class=\"badge badge-secondary\">소식/정보</span>&nbsp;";
		    else if (vo.getPart().equals("자유")) str += "<span class=\"badge badge-secondary\">자유글</span>&nbsp;";
		    else if (vo.getPart().equals("세일")) str += "<span class=\"badge badge-secondary\">세일정보</span>&nbsp;";
		    else str += "<div style=\"color:#b2bdce; font-size:12px; cursor:pointer;\" onclick=\"location.href='"+request.getContextPath()+"/gameview/"+vo.getCmGameIdx()+"';\"><i class=\"fa-solid fa-gamepad fa-xs\" style=\"color: #b2bdce;\"></i>&nbsp;" + vo.getGameTitle() + "</div>";
		    
		    str += "</div></div></div>";
		    
		    if(!mid.equals("")) {
			    str += "<div style=\"display: flex; align-items: center;\">";
			    if(!mid.equals(vo.getMid()) && vo.getFollow() == 0) str += "<div class=\"replyok-button mr-4 fb"+vo.getMid()+"\" onclick=\"followAdd('"+vo.getMid()+"')\"><i class=\"fa-solid fa-plus fa-sm\"></i>&nbsp;팔로우</div>";
			    str +="<div style=\"position:relative;\">"
			        + "<i class=\"fa-solid fa-bars fa-xl\" onclick=\"toggleContentMenu(" + vo.getCmIdx() + ")\" style=\"color: #D5D5D5;cursor:pointer;\"></i>"
			        + "<div id=\"contentMenu" + vo.getCmIdx() + "\" class=\"content-menu\">";
			    
			    if (mid.equals(vo.getMid())) {
			    	str += "<div onclick=\"showPopupEdit('" + vo.toString().replace("\"", "quot;") + "')\">수정</div>";
			    	str += "<div onclick=\"contentDelete("+vo.getCmIdx()+")\"><font color=\"red\">삭제</font></div>";
			    }
			    else if (level == 0) {
			        str += "<div onclick=\"contentDelete("+vo.getCmIdx()+")\"><font color=\"red\">삭제</font></div>";
			        str += "<div onclick=\"location.href='"+request.getContextPath()+"/admin/userlist?page=1&viewpart=all&searchpart=아이디&search="+vo.getMid()+"';\">사용자 제재</div>";
			    }
			    else {
			    	str += "<div class=\"ufb"+vo.getMid()+"\" onclick=\"followDelete('"+vo.getMid()+"')\">언팔로우</div>";
			    	str += "<div onclick=\"reportPopup("+vo.getCmIdx()+", '게시글')\">신고</div>";
			    }
			    
			    str += "</div></div></div>";
		    }
		    
		    str += "</div>";
		    str += "<div class=\"community-content\">";
		    
		    if (vo.getLongContent() == 1) {
		        str += "<div class=\"cm-content moreGra\" id=\"cmContent" + vo.getCmIdx() + "\">" + vo.getCmContent() + "</div>"
		            + "<div onclick=\"showAllContent(" + vo.getCmIdx() + ")\" id=\"moreBtn" + vo.getCmIdx() + "\" style=\"cursor:pointer; color:#00c722; font-weight:bold;\">더 보기</div>";
		    } else str += "<div class=\"cm-content\" id=\"cmContent" + vo.getCmIdx() + "\">" + vo.getCmContent() + "</div>";
		    
		    str += "<div style=\"color:#b2bdce; font-size:12px;\" class=\"mt-2\">";
		    
		    if (vo.getHour_diff() < 1) str += vo.getMin_diff() + "분 전";
		    else if (vo.getHour_diff() < 24 && vo.getHour_diff() >= 1) str += vo.getHour_diff() + "시간 전";
		    else str += vo.getCmDate().substring(0, 10);
		    
		    str += "</div><div style=\"color:#b2bdce; font-size:12px;\" class=\"mt-2\"><span id=\"cm-likeCnt" + vo.getCmIdx() + "\">이 글을 " + vo.getLikeCnt() + "명이 좋아합니다.</span></div></div>";
		    
		    if (!mid.equals("")) {
		        str += "<hr/><div class=\"community-footer\"><span id=\"cm-like" + vo.getCmIdx() + "\">";
		        if (vo.getLikeSW() == 0) str += "<span onclick=\"likeAdd(" + vo.getCmIdx() + ")\"><i class=\"fa-solid fa-heart\"></i>&nbsp;&nbsp;좋아요</span>";
		        else str += "<span style=\"color:#00c722;\" onclick=\"likeDelete(" + vo.getCmIdx() + ")\"><i class=\"fa-solid fa-heart\"></i>&nbsp;&nbsp;좋아요</span>";
		        str += "</span><span onclick=\"replyPreview("+vo.getCmIdx()+")\"><i class=\"fa-solid fa-comment-dots\"></i>&nbsp;&nbsp;댓글</span></div><hr/>";
		    }
		    str += "<div id=\"replyList" + vo.getCmIdx() + "\" class=\"replyList\">";
		    
		    if(replyCount > 2) str += "<div id=\"moreReply"+vo.getCmIdx()+"\" onclick=\"parentReplyMore("+vo.getCmIdx()+")\" class=\"moreReply\">"+replyCount+"개의 댓글 모두 보기</div>";
			for(ReplyVO p : parent) {
				p.setChildReplyCount(communityService.getChildReplyCount(p.getReplyIdx()));
				str += "<div style=\"display:flex; align-items:flex-start;\" class=\"mb-4\">"
					+"<img src=\""+request.getContextPath()+"/member/"+p.getMemImg()+"\" alt=\"프로필\" class=\"reply-pic\"><div>";
				if(!p.getTitle().equals("없음")) str += "<div style=\"font-size:12px;\">"+p.getTitle()+"</div>";
				str += "<div style=\"font-weight:bold;\">"+p.getNickname()+"</div>"
					+ "<div>"+p.getReplyContent().replace("\n", "<br/>")+"</div>"
					+ "<div style=\"color:#b2bdce; font-size:12px;\" class=\"mt-2\">";
				if(p.getHour_diff() < 1) str += p.getMin_diff()+"분 전";
				else if(p.getHour_diff() < 24 && p.getHour_diff() >= 1) str += p.getHour_diff()+"시간 전";
				else str += p.getReplyDate().substring(0,10);
				if(!mid.equals("")) {
					str += "<div class=\"replymenu\"><span class=\"mr-2\" onclick=\"rreplyPreview("+p.getReplyIdx()+")\">답글</span>";
					if(mid.equals(p.getReplyMid())) str += "<span class=\"mr-2\" onclick=\"replyEditPopup("+p.getReplyIdx()+", '"+p.getReplyContent()+"')\">수정</span>";
					if((mid.equals(p.getReplyMid()) && level != 0) || level == 0) str += "<span class=\"mr-2\" onclick=\"replyDelete("+p.getReplyIdx()+", 0)\">삭제</span>";
					str += "<span class=\"mr-2\" onclick=\"reportPopup("+p.getReplyIdx()+", '댓글', '"+p.getReplyMid()+"')\">신고</span>";
					str += "</div>";
				}
				str += "</div></div></div>"
					+ "<div id=\"rreplyList"+p.getReplyIdx()+"\" class=\"rreplyList\">";
				if(p.getChildReplyCount() > 1) str += "<div id=\"moreRReply"+p.getReplyIdx()+"\" onclick=\"childReplyMore("+p.getReplyIdx()+","+vo.getCmIdx()+")\" class=\"moreReply\"> ──&nbsp;&nbsp;"+p.getChildReplyCount()+"개의 답글 모두 보기</div>";
				for(ReplyVO c : child) {
					if(c.getReplyParentIdx() == p.getReplyIdx()) {
						str += "<div style=\"display:flex; align-items:flex-start;\" class=\"mb-4\">"
							+ "<img src=\""+request.getContextPath()+"/member/"+c.getMemImg()+"\" alt=\"프로필\" class=\"reply-pic\"><div>";
						if(!c.getTitle().equals("없음")) str += "<div style=\"font-size:12px;\">"+c.getTitle()+"</div>";
						str += "<div style=\"font-weight:bold;\">"+c.getNickname()+"</div>"
							+ "<div>"+c.getReplyContent().replace("\n", "<br/>")+"</div>"
							+ "<div style=\"color:#b2bdce; font-size:12px;\" class=\"mt-2\">";
						if(c.getHour_diff() < 1) str += c.getMin_diff()+"분 전";
						else if(c.getHour_diff() < 24 && c.getHour_diff() >= 1) str += c.getHour_diff()+"시간 전";
						else str += c.getReplyDate().substring(0,10);
						if(!mid.equals("")) {
							str += "<div class=\"replymenu\"><span class=\"mr-2\" onclick=\"rreplyPreview("+p.getReplyIdx()+")\">답글</span>";
							if(mid.equals(c.getReplyMid())) str += "<span class=\"mr-2\" onclick=\"replyEditPopup("+c.getReplyIdx()+", '"+c.getReplyContent()+"')\">수정</span>";
							if((mid.equals(c.getReplyMid()) && level != 0) || level == 0) str += "<span class=\"mr-2\" onclick=\"replyDelete("+c.getReplyIdx()+", 1)\">삭제</span>";
							str += "<span class=\"mr-2\" onclick=\"reportPopup("+c.getReplyIdx()+", '댓글', '"+c.getReplyMid()+"')\">신고</span>";
							str += "</div>";
						}
						str += "</div></div></div>";
					}
				}
				str += "</div>"
					+ "<div id=\"rreplyWrite"+p.getReplyIdx()+"\" style=\"display:none; justify-content: center;\">"
					+ "<div style=\"display:flex;\">"
					+ "<img src=\""+request.getContextPath()+"/member/"+memImg+"\" alt=\"프로필\" class=\"reply-pic\">"
					+ "<textarea id=\"rreplyContent"+p.getReplyIdx()+"\" name=\"rreplyContent\" rows=\"2\" placeholder=\"답글을 작성해 보세요.\" class=\"form-control textarea\" style=\"background-color:#32373d;\"></textarea></div>"
					+ "<div style=\"display:flex; justify-content: flex-end; margin-top: 5px;\">"
					+ "<div class=\"replyno-button mr-2\" onclick=\"rreplyPreview("+p.getReplyIdx()+")\">취소</div>"
					+ "<div class=\"replyok-button\" onclick=\"rreplyInput("+p.getReplyIdx()+", "+vo.getCmIdx()+")\">작성</div>"
					+ "</div></div>";
			}
			str += "</div>";
		    if(!mid.equals("")) {
					str += "<div id=\"replyPreview"+vo.getCmIdx()+"\" style=\"display:flex; align-items: center; justify-content: center;\">"
					+"<img src=\""+request.getContextPath()+"/member/"+memImg+"\" alt=\"프로필\" class=\"reply-pic\">"	
					+"<div class=\"text-input\" onclick=\"replyPreview("+vo.getCmIdx()+")\">댓글을 작성해 보세요.</div></div>"		
			        + "<div id=\"replyWrite"+vo.getCmIdx()+"\" style=\"display:none; justify-content: center;\">"
			        +"<div style=\"display:flex;\">"
			        +"<img src=\""+request.getContextPath()+"/member/"+memImg+"\" alt=\"프로필\" class=\"reply-pic\">"
			        +"<textarea id=\"replyContent"+vo.getCmIdx()+"\" name=\"replyContent\" rows=\"2\" placeholder=\"댓글을 작성해 보세요.\" class=\"form-control textarea\" style=\"background-color:#32373d;\"></textarea></div>"
			        +"<div style=\"display:flex; justify-content: flex-end; margin-top: 5px;\">"
			        +"<div class=\"replyno-button mr-2\" onclick=\"replyCancel("+vo.getCmIdx()+")\">취소</div>"
			        +"<div class=\"replyok-button\" onclick=\"replyInput("+vo.getCmIdx()+")\">작성</div>"
			        +"</div></div>";
		    }
		    str += "</div></div>";
		}
		return str;
	}
	
	@ResponseBody
	@RequestMapping(value = "/rootDataReview", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String rootDataReview(HttpSession session, HttpServletRequest request, String part,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "10", required = false) int pageSize) {
		String mid = session.getAttribute("sMid")==null ? "" : (String) session.getAttribute("sMid");
		String memImg = session.getAttribute("sMemImg")==null ? "" : (String) session.getAttribute("sMemImg");
		int level = session.getAttribute("sLevel")==null ? 2 : (int) session.getAttribute("sLevel");
		int startIndexNo = (page - 1) * pageSize;
		ArrayList<CommunityVO> cmVOS = communityService.getCommunityPartList(mid, startIndexNo, pageSize, "review");
		
		
		String str = "";
		for (CommunityVO vo : cmVOS) {
			ArrayList<ReplyVO> parent = vo.getParentsReply();
			ArrayList<ReplyVO> child = vo.getChildReply();
			int replyCount = vo.getReplyCount();
			
			str += "<div class=\"cm-box\" id=\"cmbox" + vo.getCmIdx() + "\"><div style=\"display:flex; justify-content:space-between;\">"
					+ "<div>";
			str += "<img src=\"" + request.getContextPath() + "/member/" + vo.getMemImg() + "\" alt=\"프로필\" class=\"text-pic\" style=\"width:20px; height:20px;\">"
					+ "<b>"+vo.getNickname()+"</b>님이 평가를 남기셨습니다</div>";
			
			if(!mid.equals("")) {
				str += "<div style=\"display: flex; align-items: center;\">";
				str +="<div style=\"position:relative;\">"
						+ "<i class=\"fa-solid fa-bars fa-xl\" onclick=\"toggleContentMenu(" + vo.getCmIdx() + ")\" style=\"color: #D5D5D5;cursor:pointer;\"></i>"
						+ "<div id=\"contentMenu" + vo.getCmIdx() + "\" class=\"content-menu\">";
				
				if (mid.equals(vo.getMid())) {
					str += "<div onclick=\"reviewGameEdit("+vo.getGameIdx()+", '"+vo.getGameImg()+"', '"+vo.getGameTitle()+"', "+vo.getRating()+", '"+vo.getState()+"','"+vo.getCmContent()+"')\">수정</div>";
					str += "<div onclick=\"contentDelete("+vo.getCmIdx()+")\"><font color=\"red\">삭제</font></div>";
				}
				else if (level == 0) {
					str += "<div onclick=\"contentDelete("+vo.getCmIdx()+")\"><font color=\"red\">삭제</font></div>";
					str += "<div onclick=\"location.href='"+request.getContextPath()+"/admin/userlist?page=1&viewpart=all&searchpart=아이디&search="+vo.getMid()+"';\">사용자 제재</div>";
				}
				else {
					str += "<div onclick=\"reportPopup("+vo.getCmIdx()+", '게시글', '"+vo.getMid()+"')\">신고</div>";
				}
				
				str += "</div></div></div>";
			}
			str += "</div><hr/>";
			str += "<div style=\"display:flex; margin: 0 20px; align-items:center; gap:20px; cursor:pointer;\" onclick=\"location.href='"+request.getContextPath()+"/gameview/"+vo.getGameIdx()+"'\"><div>";
			if(vo.getGameImg().indexOf("http") == -1) str += "<img src=\""+request.getContextPath()+"/game/"+vo.getGameImg()+"\" alt=\""+vo.getGameTitle()+"\" class=\"re-gameImg\">";
			else str += "<img src=\""+vo.getGameImg()+"\" alt=\""+vo.getGameTitle()+"\" class=\"re-gameImg\">";
			str += "</div><div class=\"review-info\";><div class=\"game-title\">"+vo.getGameTitle()+"</div>"
				+ "<div class=\"review-game-info\">"
				+ "<span class=\"review-star\"><i class=\"fa-solid fa-star\" style=\"color: #FFD43B;\"></i>&nbsp;"+vo.getRating()+"</span>"
				+ "<span class=\"review-state-"+vo.getState()+"\">";
			if(vo.getState().equals("play")) str += "<i class=\"fa-solid fa-play\"></i>&nbsp;하고있어요";
			else if(vo.getState().equals("stop")) str += "<i class=\"fa-solid fa-xmark\"></i>&nbsp;그만뒀어요";
			else if(vo.getState().equals("done")) str += "<i class=\"fa-solid fa-check\"></i>&nbsp;다했어요";
			else if(vo.getState().equals("folder")) str += "<i class=\"fa-solid fa-folder\"></i>&nbsp;모셔놨어요";
			else if(vo.getState().equals("pin")) str += "<i class=\"fa-solid fa-thumbtack\"></i>&nbsp;관심있어요";
			else str += "<i class=\"fa-solid fa-ellipsis\"></i>&nbsp;상태없음";
			str += "</span></div></div></div>";
			
			str += "<div class=\"community-content\">";
			
			if (vo.getLongContent() == 1) {
				str += "<div class=\"cm-content moreGra\" id=\"cmContent" + vo.getCmIdx() + "\">" + vo.getCmContent() + "</div>"
						+ "<div onclick=\"showAllContent(" + vo.getCmIdx() + ")\" id=\"moreBtn" + vo.getCmIdx() + "\" style=\"cursor:pointer; color:#00c722; font-weight:bold;\">더 보기</div>";
			} else str += "<div class=\"cm-content\" id=\"cmContent" + vo.getCmIdx() + "\">" + vo.getCmContent() + "</div>";
			
			str += "<div style=\"color:#b2bdce; font-size:12px;\" class=\"mt-2\">";
			
			if (vo.getHour_diff() < 1) str += vo.getMin_diff() + "분 전";
			else if (vo.getHour_diff() < 24 && vo.getHour_diff() >= 1) str += vo.getHour_diff() + "시간 전";
			else str += vo.getCmDate().substring(0, 10);
			
			str += "</div><div style=\"color:#b2bdce; font-size:12px;\" class=\"mt-2\"><span id=\"cm-likeCnt" + vo.getCmIdx() + "\">이 글을 " + vo.getLikeCnt() + "명이 좋아합니다.</span></div></div>";
			
			if (!mid.equals("")) {
				str += "<hr/><div class=\"community-footer\"><span id=\"cm-like" + vo.getCmIdx() + "\">";
				if (vo.getLikeSW() == 0) str += "<span onclick=\"likeAdd(" + vo.getCmIdx() + ")\"><i class=\"fa-solid fa-heart\"></i>&nbsp;&nbsp;좋아요</span>";
				else str += "<span style=\"color:#00c722;\" onclick=\"likeDelete(" + vo.getCmIdx() + ")\"><i class=\"fa-solid fa-heart\"></i>&nbsp;&nbsp;좋아요</span>";
				str += "</span><span onclick=\"replyPreview("+vo.getCmIdx()+")\"><i class=\"fa-solid fa-comment-dots\"></i>&nbsp;&nbsp;댓글</span></div><hr/>";
			}
			str += "<div id=\"replyList" + vo.getCmIdx() + "\" class=\"replyList\">";
			
			if(replyCount > 2) str += "<div id=\"moreReply"+vo.getCmIdx()+"\" onclick=\"parentReplyMore("+vo.getCmIdx()+")\" class=\"moreReply\">"+replyCount+"개의 댓글 모두 보기</div>";
			for(ReplyVO p : parent) {
				p.setChildReplyCount(communityService.getChildReplyCount(p.getReplyIdx()));
				str += "<div style=\"display:flex; align-items:flex-start;\" class=\"mb-4\">"
						+"<img src=\""+request.getContextPath()+"/member/"+p.getMemImg()+"\" alt=\"프로필\" class=\"reply-pic\"><div>";
				if(!p.getTitle().equals("없음")) str += "<div style=\"font-size:12px;\">"+p.getTitle()+"</div>";
				str += "<div style=\"font-weight:bold;\">"+p.getNickname()+"</div>"
						+ "<div>"+p.getReplyContent().replace("\n", "<br/>")+"</div>"
						+ "<div style=\"color:#b2bdce; font-size:12px;\" class=\"mt-2\">";
				if(p.getHour_diff() < 1) str += p.getMin_diff()+"분 전";
				else if(p.getHour_diff() < 24 && p.getHour_diff() >= 1) str += p.getHour_diff()+"시간 전";
				else str += p.getReplyDate().substring(0,10);
				if(!mid.equals("")) {
					str += "<div class=\"replymenu\"><span class=\"mr-2\" onclick=\"rreplyPreview("+p.getReplyIdx()+")\">답글</span>";
					if(mid.equals(p.getReplyMid())) str += "<span class=\"mr-2\" onclick=\"replyEditPopup("+p.getReplyIdx()+", '"+p.getReplyContent()+"')\">수정</span>";
					if((mid.equals(p.getReplyMid()) && level != 0) || level == 0) str += "<span class=\"mr-2\" onclick=\"replyDelete("+p.getReplyIdx()+", 0)\">삭제</span>";
					str += "<span class=\"mr-2\" onclick=\"reportPopup("+p.getReplyIdx()+", '댓글', '"+p.getReplyMid()+"')\">신고</span>";
					str += "</div>";
				}
				str += "</div></div></div>"
						+ "<div id=\"rreplyList"+p.getReplyIdx()+"\" class=\"rreplyList\">";
				if(p.getChildReplyCount() > 1) str += "<div id=\"moreRReply"+p.getReplyIdx()+"\" onclick=\"childReplyMore("+p.getReplyIdx()+","+vo.getCmIdx()+")\" class=\"moreReply\"> ──&nbsp;&nbsp;"+p.getChildReplyCount()+"개의 답글 모두 보기</div>";
				for(ReplyVO c : child) {
					if(c.getReplyParentIdx() == p.getReplyIdx()) {
						str += "<div style=\"display:flex; align-items:flex-start;\" class=\"mb-4\">"
								+ "<img src=\""+request.getContextPath()+"/member/"+c.getMemImg()+"\" alt=\"프로필\" class=\"reply-pic\"><div>";
						if(!c.getTitle().equals("없음")) str += "<div style=\"font-size:12px;\">"+c.getTitle()+"</div>";
						str += "<div style=\"font-weight:bold;\">"+c.getNickname()+"</div>"
								+ "<div>"+c.getReplyContent().replace("\n", "<br/>")+"</div>"
								+ "<div style=\"color:#b2bdce; font-size:12px;\" class=\"mt-2\">";
						if(c.getHour_diff() < 1) str += c.getMin_diff()+"분 전";
						else if(c.getHour_diff() < 24 && c.getHour_diff() >= 1) str += c.getHour_diff()+"시간 전";
						else str += c.getReplyDate().substring(0,10);
						if(!mid.equals("")) {
							str += "<div class=\"replymenu\"><span class=\"mr-2\" onclick=\"rreplyPreview("+p.getReplyIdx()+")\">답글</span>";
							if(mid.equals(c.getReplyMid())) str += "<span class=\"mr-2\" onclick=\"replyEditPopup("+c.getReplyIdx()+", '"+c.getReplyContent()+"')\">수정</span>";
							if((mid.equals(c.getReplyMid()) && level != 0) || level == 0) str += "<span class=\"mr-2\" onclick=\"replyDelete("+c.getReplyIdx()+", 1)\">삭제</span>";
							str += "<span class=\"mr-2\" onclick=\"reportPopup("+c.getReplyIdx()+", '댓글', '"+c.getReplyMid()+"')\">신고</span>";
							str += "</div>";
						}
						str += "</div></div></div>";
					}
				}
				str += "</div>"
						+ "<div id=\"rreplyWrite"+p.getReplyIdx()+"\" style=\"display:none; justify-content: center;\">"
						+ "<div style=\"display:flex;\">"
						+ "<img src=\""+request.getContextPath()+"/member/"+memImg+"\" alt=\"프로필\" class=\"reply-pic\">"
						+ "<textarea id=\"rreplyContent"+p.getReplyIdx()+"\" name=\"rreplyContent\" rows=\"2\" placeholder=\"답글을 작성해 보세요.\" class=\"form-control textarea\" style=\"background-color:#32373d;\"></textarea></div>"
						+ "<div style=\"display:flex; justify-content: flex-end; margin-top: 5px;\">"
						+ "<div class=\"replyno-button mr-2\" onclick=\"rreplyPreview("+p.getReplyIdx()+")\">취소</div>"
						+ "<div class=\"replyok-button\" onclick=\"rreplyInput("+p.getReplyIdx()+", "+vo.getCmIdx()+")\">작성</div>"
						+ "</div></div>";
			}
			str += "</div>";
			if(!mid.equals("")) {
				str += "<div id=\"replyPreview"+vo.getCmIdx()+"\" style=\"display:flex; align-items: center; justify-content: center;\">"
						+"<img src=\""+request.getContextPath()+"/member/"+memImg+"\" alt=\"프로필\" class=\"reply-pic\">"	
						+"<div class=\"text-input\" onclick=\"replyPreview("+vo.getCmIdx()+")\">댓글을 작성해 보세요.</div></div>"		
						+ "<div id=\"replyWrite"+vo.getCmIdx()+"\" style=\"display:none; justify-content: center;\">"
						+"<div style=\"display:flex;\">"
						+"<img src=\""+request.getContextPath()+"/member/"+memImg+"\" alt=\"프로필\" class=\"reply-pic\">"
						+"<textarea id=\"replyContent"+vo.getCmIdx()+"\" name=\"replyContent\" rows=\"2\" placeholder=\"댓글을 작성해 보세요.\" class=\"form-control textarea\" style=\"background-color:#32373d;\"></textarea></div>"
						+"<div style=\"display:flex; justify-content: flex-end; margin-top: 5px;\">"
						+"<div class=\"replyno-button mr-2\" onclick=\"replyCancel("+vo.getCmIdx()+")\">취소</div>"
						+"<div class=\"replyok-button\" onclick=\"replyInput("+vo.getCmIdx()+")\">작성</div>"
						+"</div></div>";
			}
			str += "</div></div>";
		}
		return str;
	}
	
	@ResponseBody
	@RequestMapping(value = "/newsRootData", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String newsRootData(HttpSession session, HttpServletRequest request, String part,
			@RequestParam(name="page", defaultValue = "1", required = false) int page,
			@RequestParam(name="pageSize", defaultValue = "10", required = false) int pageSize) {
		int startIndexNo = (page - 1) * pageSize;
		ArrayList<CommunityVO> cmVOS = null;
		
		if(part.equals("recent")) cmVOS = communityService.getNewsList(startIndexNo, pageSize, "전체");
		else if(part.equals("report")) cmVOS = communityService.getNewsList(startIndexNo, pageSize, "취재");
		else cmVOS = communityService.getNewsList(startIndexNo, pageSize, "예판");
		
		String str = "";
		for (CommunityVO vo : cmVOS) {
			str += "<div class=\"cm-box\" id=\"cmbox"+vo.getCmIdx()+"\">"
				+ "<div class=\"newsCmBox\"><div>";
			if(vo.getNewsThumnail().indexOf("http") == -1) str += "<img src=\""+request.getContextPath()+"/community/"+vo.getNewsThumnail()+"\" alt=\"뉴스썸네일\" class=\"re-gameImg\" style=\"height: 120px;\">";
			else str += "<img src=\""+vo.getNewsThumnail()+"\" alt=\"뉴스썸네일\" class=\"re-gameImg\" style=\"height: 120px;\">";
			str += "</div><div><div style=\"color:#00c722; font-weight: bold;\">"+vo.getPart()+"</div>"
				+ "<div class=\"game-title\" style=\"cursor: pointer;\" onclick=\"location.href='"+request.getContextPath()+"/news/"+vo.getCmIdx()+"';\">"+vo.getNewsTitle()+"</div>"
				+ "<div style=\"color:#b2bdce; font-size:12px;\" class=\"mt-2\">";
			if(vo.getHour_diff() < 1) str += vo.getMin_diff()+"분 전";
			else if(vo.getHour_diff() < 24 && vo.getHour_diff() >= 1) str += vo.getHour_diff()+"시간 전";
			else str += vo.getCmDate().substring(0,10);
			str += "</div><div style=\"color:#b2bdce; font-size:12px;\" class=\"mt-2\"><span id=\"cm-likeCnt"+vo.getCmIdx()+"\">이 글을 "+vo.getLikeCnt()+"명이 좋아합니다.</span></div>"
				+ "</div></div></div>";
		}
		return str;
	}
	
	@ResponseBody
	@RequestMapping(value = "/getCmContent", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String getCmContentPost(int cmIdx) {
		CommunityVO vo = communityService.getCommunityIdx(cmIdx);
		return vo.getCmContent();
	}
	
	@ResponseBody
	@RequestMapping(value = "/communityDelete", method = RequestMethod.POST)
	public String setCommunityDeletePost(int cmIdx, HttpServletRequest request) {
		CommunityVO vo = communityService.getCommunityIdx(cmIdx);
		if(vo.getPart().equals("리뷰")) communityService.setReviewDelete(vo.getMid(), vo.getCmGameIdx());
		return communityService.setCommunityDelete(cmIdx, request)+"";
	}
	
	@ResponseBody
	@RequestMapping(value = "/replyInput", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String setReplyInputPost(int replyCmIdx, String replyContent, HttpSession session, HttpServletRequest request) {
		ReplyVO vo = new ReplyVO();
		vo.setReplyCmIdx(replyCmIdx);
		vo.setReplyContent(replyContent);
		vo.setReplyMid((String)session.getAttribute("sMid"));
		vo.setReplyHostIp(request.getRemoteAddr());
		
		return communityService.replyInput(vo, request, session);
	}
	
	@ResponseBody
	@RequestMapping(value = "/parentReplyMore", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String parentReplyMorePost(int replyCmIdx, HttpSession session, HttpServletRequest request) {
		return communityService.parentReplyMore(replyCmIdx, request, session);
	}
	
	@ResponseBody
	@RequestMapping(value = "/rreplyInput", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String setRReplyInputPost(ReplyVO vo, HttpSession session, HttpServletRequest request) {
		return communityService.rreplyInput(vo, request, session);
	}
	
	@ResponseBody
	@RequestMapping(value = "/childReplyMore", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String childReplyMorePost(int replyCmIdx, int replyParentIdx, HttpSession session, HttpServletRequest request) {
		return communityService.childReplyMore(replyCmIdx, replyParentIdx, request, session);
	}
	
	@ResponseBody
	@RequestMapping(value = "/replyEdit", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String replyEdit(String replyContent, int replyIdx, String replyMid, HttpServletRequest request, HttpSession session) {
		return communityService.replyEdit(replyContent, replyIdx, replyMid, request, session);
	}
	
	@ResponseBody
	@RequestMapping(value = "/replyDelete", method = RequestMethod.POST)
	public String replyDelete(int replyIdx) {
		return communityService.replyDelete(replyIdx)+"";
	}
	
	@ResponseBody
	@RequestMapping(value = "/followInput", method = RequestMethod.POST)
	public void followInput(String youMid, HttpSession session) {
		String myMid = session.getAttribute("sMid")==null ? "" : (String)session.getAttribute("sMid");
		communityService.followInput(myMid, youMid);
	}
	
	@ResponseBody
	@RequestMapping(value = "/followDelete", method = RequestMethod.POST)
	public void followDelete(String youMid, HttpSession session) {
		String myMid = session.getAttribute("sMid")==null ? "" : (String)session.getAttribute("sMid");
		communityService.followDelete(myMid, youMid);
	}
	
	@ResponseBody
	@RequestMapping(value = "/reportInput", method = RequestMethod.POST)
	public void reportInput(ReportVO vo) {
		communityService.reportInput(vo);
	}
		
	
}
