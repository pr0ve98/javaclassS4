package com.spring.javaclassS4.service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS4.common.JavaclassProvide;
import com.spring.javaclassS4.dao.CommunityDAO;
import com.spring.javaclassS4.dao.MemberDAO;
import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.FollowVO;
import com.spring.javaclassS4.vo.GameVO;
import com.spring.javaclassS4.vo.ReplyVO;
import com.spring.javaclassS4.vo.ReportVO;
import com.spring.javaclassS4.vo.ReviewVO;

@Service
public class CommunityServiceImpl implements CommunityService {
	
	@Autowired
	JavaclassProvide javaclassProvide;
	
	@Autowired
	MemberDAO memberDAO;
	
	@Autowired
	CommunityDAO communityDAO;

	@Override
	public String imageUpload(MultipartFile fName, HttpServletRequest request) {
		String uid = UUID.randomUUID().toString().substring(0,8);
		String sFileName = uid + "_" + fName.getOriginalFilename();
		
		try {
			javaclassProvide.writeFile(fName, sFileName, "community");
			return request.getContextPath()+"/community/"+sFileName;
		} catch (IOException e) {
			e.printStackTrace();
			return "";
		}
	}

	@Override
	public void deleteImage(String src, HttpServletRequest request) {
		String fName = src.substring(src.lastIndexOf("/")+1);
		if(fName != null) {
			String realPath = request.getSession().getServletContext().getRealPath("/resources/data/community/");
			
			File file = new File(realPath + fName);
			if(file.exists() && file.isFile()) {
				file.delete();
			}
		}
	}

	@Override
	public String getMemberGamelist(String mid) {
		return memberDAO.getMemberGamelist(mid);
	}

	@Override
	public GameVO getGameIdx(int gameIdx) {
		return communityDAO.getGameIdx(gameIdx);
	}

	@Override
	public String gameSearch(String game) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String str = "";
		ArrayList<GameVO> vos = communityDAO.gameSearch(game);
		if(vos.isEmpty()) return str = "<div class=\"text-center\" style=\"margin: 30px 0;\">검색한 게임이 없습니다</div>";
		for(GameVO vo : vos) {
			String gamename = vo.getGameTitle() + " ("+vo.getShowDate().split("-")[0]+")";
			str += "<div class=\"result-item\" data-gamesearchidx=\""+vo.getGameIdx()+"\" onclick=\"gamelistAdd("+vo.getGameIdx()+")\">";
			if(vo.getGameImg() != null && !vo.getGameImg().equals("")) {
				if(vo.getGameImg().indexOf("http") == -1) str += "<img src=\""+request.getContextPath()+"/game/"+vo.getGameImg()+"\" alt=\""+gamename+"\">";
				else str += "<img src=\""+vo.getGameImg()+"\" alt=\""+gamename+"\">";
			}
			str	+= "<span>"+gamename+"</span></div>";
		}
		return str;
	}
	
	@Override
	public String reviewGameSearch(String game) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		HttpSession session = request.getSession();
		String mid = session.getAttribute("sMid") == null ? "" : (String)session.getAttribute("sMid");
		List<ReviewVO> reviewList = communityDAO.getReviewIdx(mid);
		
		String str = "";
		ArrayList<GameVO> vos = communityDAO.gameSearch(game);
		if(vos.isEmpty()) return str = "<div class=\"text-center\" style=\"margin: 30px 0;\">검색한 게임이 없습니다</div>";
		for(GameVO vo : vos) {
			String gamename = vo.getGameTitle() + " ("+vo.getShowDate().split("-")[0]+")";
			boolean reviewFound = false;
			for(ReviewVO review : reviewList) {
		        if(review.getRevGameIdx() == vo.getGameIdx()) {
		        	reviewFound = true;
		        	String cmContent = communityDAO.getCMReview(review.getRevGameIdx(), review.getRevMid());
		        	if(cmContent == null) str += "<div class=\"result-item\" data-gamesearchidx=\""+vo.getGameIdx()+"\" onclick=\"reviewGameEdit("+vo.getGameIdx()+", '"+vo.getGameImg()+"', '"+vo.getGameTitle()+"', "+review.getRating()+", '"+review.getState()+"','')\">";
		        	else str += "<div class=\"result-item\" data-gamesearchidx=\""+vo.getGameIdx()+"\" onclick=\"reviewGameEdit("+vo.getGameIdx()+", '"+vo.getGameImg()+"', '"+vo.getGameTitle()+"', "+review.getRating()+", '"+review.getState()+"','"+cmContent+"')\">";
		        	break;
		        }
			}
			if(reviewFound == false) str += "<div class=\"result-item\" data-gamesearchidx=\""+vo.getGameIdx()+"\" onclick=\"reviewGameAdd("+vo.getGameIdx()+", '"+vo.getGameImg()+"', '"+vo.getGameTitle()+"')\">";
		    if(vo.getGameImg() != null && !vo.getGameImg().equals("")) {
				if(vo.getGameImg().indexOf("http") == -1) str += "<img src=\""+request.getContextPath()+"/game/"+vo.getGameImg()+"\" alt=\""+gamename+"\">";
				else str += "<img src=\""+vo.getGameImg()+"\" alt=\""+gamename+"\">";
			}
			str	+= "<span>"+gamename+"</span></div>";
		}
		return str;
	}

	@Override
	public int setMemGameListEdit(String gamelist, String mid) {
		return communityDAO.setMemGameListEdit(gamelist, mid);
	}

	@Override
	public int communityInput(CommunityVO vo) {
		return communityDAO.communityInput(vo);
	}

	@Override
	public ArrayList<CommunityVO> getCommunityList(String mid, int startIndexNo, int pageSize) {
		ArrayList<CommunityVO> vos = communityDAO.getCommunityList(startIndexNo, pageSize);
		// 글 내용이 길다면 조금만 보여주기
		for(int i=0; i<vos.size(); i++) {
			Document doc = Jsoup.parse(vos.get(i).getCmContent());
			Elements ptag = doc.select("p");
			Elements img = doc.select("img");
			
			StringBuilder reContent = new StringBuilder();
			
			if(!img.isEmpty()) {
				Element firstImg = img.first();
				for (Element e : ptag) {
					reContent.append(e.outerHtml());
					if(e.equals(firstImg.parent())) {
						vos.get(i).setLongContent(1);
						break;
					}
				}
			}
			else {
				if(ptag.size() < 7) {
					ptag.forEach(p -> reContent.append(p.outerHtml()));
					vos.get(i).setLongContent(0);
				}
				else {
					ptag.stream().limit(7).forEach(p -> reContent.append(p.outerHtml()));
					vos.get(i).setLongContent(1);
				}
			}
			vos.get(i).setCmContent(reContent.toString());
			List<String> likeMember = communityDAO.getLikeMember(vos.get(i).getCmIdx());
			if(mid != null && likeMember.size() > 0) {
				for(int j=0; j<likeMember.size(); j++) {
					if(mid.equals(likeMember.get(j))) {
						vos.get(i).setLikeSW(1);
						break;
					}
					else vos.get(i).setLikeSW(0);
				}
			}
			vos.get(i).setLikeMember(likeMember);
			vos.get(i).setLikeCnt(likeMember.size());
			
	        ArrayList<ReplyVO> parentsReply = communityDAO.getCommunityReply(vos.get(i).getCmIdx());
	        ArrayList<ReplyVO> childsReply = new ArrayList<>(); // 자식 댓글 리스트를 반복문 밖에서 초기화

	        for (ReplyVO k : parentsReply) {
	            int childReplyCount = communityDAO.getChildReplyCount(k.getReplyIdx());
	            k.setChildReplyCount(childReplyCount);

	            ArrayList<ReplyVO> childReplies = communityDAO.getCommunityChildReply(vos.get(i).getCmIdx(), k.getReplyIdx());
	            
	            // 자식 댓글을 추가
	            if (childReplies != null) {
	                childsReply.addAll(childReplies);
	            }
	        }
		        
			int replyCount = communityDAO.getReplyCount(vos.get(i).getCmIdx());
			vos.get(i).setParentsReply(parentsReply);
			vos.get(i).setChildReply(childsReply);
			vos.get(i).setReplyCount(replyCount);
			
			if(vos.get(i).getCmGameIdx() != 0) {
				GameVO vo = communityDAO.getGameIdx(vos.get(i).getCmGameIdx());
				vos.get(i).setGameImg(vo.getGameImg());
			}
			
			FollowVO fVO = communityDAO.getFollow(mid, vos.get(i).getMid());
			if(fVO == null) vos.get(i).setFollow(0);
			else vos.get(i).setFollow(1);
		}
		return vos;
	}
	
	@Override
	public ArrayList<CommunityVO> getCommunityPartList(String mid, int startIndexNo, int pageSize, String part) {
		ArrayList<CommunityVO> vos = communityDAO.getCommunityPartList(mid, startIndexNo, pageSize, part);
		// 글 내용이 길다면 조금만 보여주기
		for(int i=0; i<vos.size(); i++) {
			Document doc = Jsoup.parse(vos.get(i).getCmContent());
			Elements ptag = doc.select("p");
			Elements img = doc.select("img");
			
			StringBuilder reContent = new StringBuilder();
			
			if(!img.isEmpty()) {
				Element firstImg = img.first();
				for (Element e : ptag) {
					reContent.append(e.outerHtml());
					if(e.equals(firstImg.parent())) {
						vos.get(i).setLongContent(1);
						break;
					}
				}
			}
			else {
				if(ptag.size() < 7) {
					ptag.forEach(p -> reContent.append(p.outerHtml()));
					vos.get(i).setLongContent(0);
				}
				else {
					ptag.stream().limit(7).forEach(p -> reContent.append(p.outerHtml()));
					vos.get(i).setLongContent(1);
				}
			}
			vos.get(i).setCmContent(reContent.toString());
			List<String> likeMember = communityDAO.getLikeMember(vos.get(i).getCmIdx());
			if(mid != null && likeMember.size() > 0) {
				for(int j=0; j<likeMember.size(); j++) {
					if(mid.equals(likeMember.get(j))) vos.get(i).setLikeSW(1);
					else vos.get(i).setLikeSW(0);
				}
			}
			vos.get(i).setLikeMember(likeMember);
			vos.get(i).setLikeCnt(likeMember.size());
			
	        ArrayList<ReplyVO> parentsReply = communityDAO.getCommunityReply(vos.get(i).getCmIdx());
	        ArrayList<ReplyVO> childsReply = new ArrayList<>(); // 자식 댓글 리스트를 반복문 밖에서 초기화

	        for (ReplyVO k : parentsReply) {
	            int childReplyCount = communityDAO.getChildReplyCount(k.getReplyIdx());
	            k.setChildReplyCount(childReplyCount);

	            ArrayList<ReplyVO> childReplies = communityDAO.getCommunityChildReply(vos.get(i).getCmIdx(), k.getReplyIdx());
	            
	            // 자식 댓글을 추가
	            if (childReplies != null) {
	                childsReply.addAll(childReplies);
	            }
	        }
		        
			int replyCount = communityDAO.getReplyCount(vos.get(i).getCmIdx());
			vos.get(i).setParentsReply(parentsReply);
			vos.get(i).setChildReply(childsReply);
			vos.get(i).setReplyCount(replyCount);
			
			if(vos.get(i).getCmGameIdx() != 0) {
				GameVO vo = communityDAO.getGameIdx(vos.get(i).getCmGameIdx());
				vos.get(i).setGameImg(vo.getGameImg());
			}
			
			FollowVO fVO = communityDAO.getFollow(mid, vos.get(i).getMid());
			if(fVO == null) vos.get(i).setFollow(0);
			else vos.get(i).setFollow(1);
		}
		return vos;
	}

	@Override
	public CommunityVO showAllContent(int cmIdx) {
		return communityDAO.showAllContent(cmIdx);
	}

	@Override
	public void setLikeAdd(String mid, int cmIdx) {
		communityDAO.setLikeAdd(mid, cmIdx);
	}
	
	@Override
	public void setlikeDelete(String mid, int cmIdx) {
		communityDAO.setlikeDelete(mid, cmIdx);
	}

	@Override
	public CommunityVO getCommunityIdx(int cmIdx) {
		List<String> likeMember = communityDAO.getLikeMember(cmIdx);
		CommunityVO vo = communityDAO.getCommunityIdx(cmIdx);
		vo.setLikeMember(likeMember);
		vo.setLikeCnt(likeMember.size());
		return vo;
	}

	@Override
	public int getTotRecCnt(String part) {
		return communityDAO.getTotRecCnt(part);
	}
	
	@Override
	public int getMyTotRecCnt(String mid) {
		return communityDAO.getMyTotRecCnt(mid);
	}

	@Override
	public int communityEdit(CommunityVO vo, int sw) {
		return communityDAO.communityEdit(vo, sw);
	}

	@Override
	public int setCommunityDelete(int cmIdx, HttpServletRequest request) {
		CommunityVO vo = communityDAO.getCommunityIdx(cmIdx);
		
		Document doc = Jsoup.parse(vo.getCmContent()); // content에 뽑아낼 html 문자열을 넣는다
		 
        Elements imgElements = doc.select("img"); // html 코드에서 img만 추출
        for (Element imgElement : imgElements) {
            String src = imgElement.attr("src"); // img 코드에서 src만 추출
            if(src.indexOf("http") == -1) {
            	String fileName = src.substring(src.lastIndexOf("/") + 1);
            
				String realPath = request.getSession().getServletContext().getRealPath("/resources/data/community/");
				
				File file = new File(realPath + fileName);
				if(file.exists() && file.isFile()) {
					file.delete();
				}
            }
        }

		return communityDAO.setCommunityDelete(cmIdx);
	}

	@Override
	public String replyInput(ReplyVO vo, HttpServletRequest request, HttpSession session) {
		int res = communityDAO.replyInput(vo);
		ArrayList<ReplyVO> parent = communityDAO.getCommunityAllReply(vo.getReplyCmIdx(), 0);
		ArrayList<ReplyVO> child = null;
		String str = "";
		
		String mid = session.getAttribute("sMid")==null ? "" : (String) session.getAttribute("sMid");
		String memImg = session.getAttribute("sMemImg")==null ? "" : (String) session.getAttribute("sMemImg");
		int level = session.getAttribute("sLevel")==null ? 2 : (int) session.getAttribute("sLevel");
		
		for(ReplyVO p : parent) {
			child = communityDAO.getCommunityChildReply(vo.getReplyCmIdx(), p.getReplyIdx());
			p.setChildReplyCount(communityDAO.getChildReplyCount(p.getReplyIdx()));
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
			if(p.getChildReplyCount() > 1) str += "<div id=\"moreRReply"+p.getReplyIdx()+"\" onclick=\"childReplyMore("+p.getReplyIdx()+","+vo.getReplyCmIdx()+")\" class=\"moreReply\"> ──&nbsp;&nbsp;"+p.getChildReplyCount()+"개의 답글 모두 보기</div>";
			for(ReplyVO c : child) {
				child = communityDAO.getCommunityChildReply(vo.getReplyCmIdx(), p.getReplyIdx());
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
				+ "<div class=\"replyok-button\" onclick=\"rreplyInput("+p.getReplyIdx()+", "+vo.getReplyCmIdx()+")\">작성</div>"
				+ "</div></div>";
		}
		
		return res + "|" + str;
	}
	
	@Override
	public String parentReplyMore(int replyCmIdx, HttpServletRequest request, HttpSession session) {
		ArrayList<ReplyVO> parent = communityDAO.getCommunityAllReply(replyCmIdx, 0);
		ArrayList<ReplyVO> child = null;
		String str = "";
		
		String mid = session.getAttribute("sMid")==null ? "" : (String) session.getAttribute("sMid");
		String memImg = session.getAttribute("sMemImg")==null ? "" : (String) session.getAttribute("sMemImg");
		int level = session.getAttribute("sLevel")==null ? 2 : (int) session.getAttribute("sLevel");
		
		for(ReplyVO p : parent) {
			child = communityDAO.getCommunityChildReply(replyCmIdx, p.getReplyIdx());
			p.setChildReplyCount(communityDAO.getChildReplyCount(p.getReplyIdx()));
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
			if(p.getChildReplyCount() > 1) str += "<div id=\"moreRReply"+p.getReplyIdx()+"\" onclick=\"childReplyMore("+p.getReplyIdx()+","+replyCmIdx+")\" class=\"moreReply\"> ──&nbsp;&nbsp;"+p.getChildReplyCount()+"개의 답글 모두 보기</div>";
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
					+ "<div class=\"replyok-button\" onclick=\"rreplyInput("+p.getReplyIdx()+", "+replyCmIdx+")\">작성</div>"
					+ "</div></div>";
		}
		
		return str;
	}
	
	@Override
	public String rreplyInput(ReplyVO vo, HttpServletRequest request, HttpSession session) {
		vo.setReplyMid((String)session.getAttribute("sMid"));
		vo.setReplyHostIp(request.getRemoteAddr());
		int res = communityDAO.rreplyInput(vo);
		ArrayList<ReplyVO> child = communityDAO.getCommunityChildAllReply(vo.getReplyCmIdx(), vo.getReplyParentIdx());
		String str = "";
		
		String mid = session.getAttribute("sMid")==null ? "" : (String) session.getAttribute("sMid");
		int level = session.getAttribute("sLevel")==null ? 2 : (int) session.getAttribute("sLevel");
	
		for(ReplyVO c : child) {
			if(c.getReplyParentIdx() == vo.getReplyParentIdx()) {
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
					str += "<div class=\"replymenu\"><span class=\"mr-2\" onclick=\"rreplyPreview("+vo.getReplyParentIdx()+")\">답글</span>";
					if(mid.equals(c.getReplyMid())) str += "<span class=\"mr-2\" onclick=\"replyEditPopup("+c.getReplyIdx()+", '"+c.getReplyContent()+"')\">수정</span>";
					if((mid.equals(c.getReplyMid()) && level != 0) || level == 0) str += "<span class=\"mr-2\" onclick=\"replyDelete("+c.getReplyIdx()+", 1)\">삭제</span>";
					str += "<span class=\"mr-2\" onclick=\"reportPopup("+c.getReplyIdx()+", '댓글', '"+c.getReplyMid()+"')\">신고</span>";
					str += "</div>";
				}
				str += "</div></div></div>";
			}
		}
		
		return res + "|" + str;
	}
	
	@Override
	public String childReplyMore(int replyCmIdx, int replyParentIdx, HttpServletRequest request, HttpSession session) {
		ArrayList<ReplyVO> child = communityDAO.getCommunityChildAllReply(replyCmIdx, replyParentIdx);
		String str = "";
		
		String mid = session.getAttribute("sMid")==null ? "" : (String) session.getAttribute("sMid");
		int level = session.getAttribute("sLevel")==null ? 2 : (int) session.getAttribute("sLevel");
		
		for(ReplyVO c : child) {
			if(c.getReplyParentIdx() == replyParentIdx) {
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
					str += "<div class=\"replymenu\"><span class=\"mr-2\" onclick=\"rreplyPreview("+replyParentIdx+")\">답글</span>";
					if(mid.equals(c.getReplyMid())) str += "<span class=\"mr-2\" onclick=\"replyEditPopup("+c.getReplyIdx()+", '"+c.getReplyContent()+"')\">수정</span>";
					if((mid.equals(c.getReplyMid()) && level != 0) || level == 0) str += "<span class=\"mr-2\" onclick=\"replyDelete("+c.getReplyIdx()+", 1)\">삭제</span>";
					str += "<span class=\"mr-2\" onclick=\"reportPopup("+c.getReplyIdx()+", '댓글', '"+c.getReplyMid()+"')\">신고</span>";
					str += "</div>";
				}
				str += "</div></div></div>";
			}
		}
		
		return str;
	}

	@Override
	public int getChildReplyCount(int replyIdx) {
		return communityDAO.getChildReplyCount(replyIdx);
	}

	@Override
	public ArrayList<ReplyVO> getCommunityChildReply(int cmIdx, int replyIdx) {
		return communityDAO.getCommunityChildReply(cmIdx, replyIdx);
	}

	@Override
	public String replyEdit(String replyContent, int replyIdx, String replyMid, HttpServletRequest request, HttpSession session) {
		int res = communityDAO.replyEdit(replyContent, replyIdx, replyMid);
		ReplyVO vo = communityDAO.getCommunityReplyIdx(replyIdx);
		ArrayList<ReplyVO> parent = communityDAO.getCommunityAllReply(vo.getReplyCmIdx(), 0);
		ArrayList<ReplyVO> child = null;
		String str = "";
		
		String mid = session.getAttribute("sMid")==null ? "" : (String) session.getAttribute("sMid");
		String memImg = session.getAttribute("sMemImg")==null ? "" : (String) session.getAttribute("sMemImg");
		int level = session.getAttribute("sLevel")==null ? 2 : (int) session.getAttribute("sLevel");
		
		for(ReplyVO p : parent) {
			child = communityDAO.getCommunityChildReply(vo.getReplyCmIdx(), p.getReplyIdx());
			p.setChildReplyCount(communityDAO.getChildReplyCount(p.getReplyIdx()));
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
			if(p.getChildReplyCount() > 1) str += "<div id=\"moreRReply"+p.getReplyIdx()+"\" onclick=\"childReplyMore("+p.getReplyIdx()+","+vo.getReplyCmIdx()+")\" class=\"moreReply\"> ──&nbsp;&nbsp;"+p.getChildReplyCount()+"개의 답글 모두 보기</div>";
			for(ReplyVO c : child) {
				child = communityDAO.getCommunityChildReply(vo.getReplyCmIdx(), p.getReplyIdx());
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
				+ "<div class=\"replyok-button\" onclick=\"rreplyInput("+p.getReplyIdx()+", "+vo.getReplyCmIdx()+")\">작성</div>"
				+ "</div></div>";
		}
		
		return res + "|" + str + "|" + vo.getReplyCmIdx();
	}

	@Override
	public int replyDelete(int replyIdx) {
		return communityDAO.replyDelete(replyIdx);
	}

	@Override
	public void setReviewDelete(String mid, int cmGameIdx) {
		communityDAO.setReviewDelete(mid, cmGameIdx);
	}

	@Override
	public void followInput(String myMid, String youMid) {
		communityDAO.followInput(myMid, youMid);
	}

	@Override
	public void followDelete(String myMid, String youMid) {
		communityDAO.followDelete(myMid, youMid);
	}

	@Override
	public void reportInput(ReportVO vo) {
		communityDAO.reportInput(vo);
	}

	@Override
	public ArrayList<CommunityVO> getCommunityFollowList(String mid, int startIndexNo, int pageSize) {
		List<String> mids = communityDAO.getFollowMids(mid);
		ArrayList<CommunityVO> vos = null;
		
		if(mids.size() > 0) {
			String midsStr = "";
			for(int i=0; i<mids.size(); i++) {
				midsStr += "'" + mids.get(i) + "', ";
			}
			midsStr = midsStr.substring(0, midsStr.length()-2);
			
			vos = communityDAO.getCommunityFollowList(midsStr, startIndexNo, pageSize);
			// 글 내용이 길다면 조금만 보여주기
			for(int i=0; i<vos.size(); i++) {
				Document doc = Jsoup.parse(vos.get(i).getCmContent());
				Elements ptag = doc.select("p");
				Elements img = doc.select("img");
				
				StringBuilder reContent = new StringBuilder();
				
				if(!img.isEmpty()) {
					Element firstImg = img.first();
					for (Element e : ptag) {
						reContent.append(e.outerHtml());
						if(e.equals(firstImg.parent())) {
							vos.get(i).setLongContent(1);
							break;
						}
					}
				}
				else {
					if(ptag.size() < 7) {
						ptag.forEach(p -> reContent.append(p.outerHtml()));
						vos.get(i).setLongContent(0);
					}
					else {
						ptag.stream().limit(7).forEach(p -> reContent.append(p.outerHtml()));
						vos.get(i).setLongContent(1);
					}
				}
				vos.get(i).setCmContent(reContent.toString());
				List<String> likeMember = communityDAO.getLikeMember(vos.get(i).getCmIdx());
				if(mid != null && likeMember.size() > 0) {
					for(int j=0; j<likeMember.size(); j++) {
						if(mid.equals(likeMember.get(j))) vos.get(i).setLikeSW(1);
						else vos.get(i).setLikeSW(0);
					}
				}
				vos.get(i).setLikeMember(likeMember);
				vos.get(i).setLikeCnt(likeMember.size());
				
		        ArrayList<ReplyVO> parentsReply = communityDAO.getCommunityReply(vos.get(i).getCmIdx());
		        ArrayList<ReplyVO> childsReply = new ArrayList<>(); // 자식 댓글 리스트를 반복문 밖에서 초기화
	
		        for (ReplyVO k : parentsReply) {
		            int childReplyCount = communityDAO.getChildReplyCount(k.getReplyIdx());
		            k.setChildReplyCount(childReplyCount);
	
		            ArrayList<ReplyVO> childReplies = communityDAO.getCommunityChildReply(vos.get(i).getCmIdx(), k.getReplyIdx());
		            
		            // 자식 댓글을 추가
		            if (childReplies != null) {
		                childsReply.addAll(childReplies);
		            }
		        }
			        
				int replyCount = communityDAO.getReplyCount(vos.get(i).getCmIdx());
				vos.get(i).setParentsReply(parentsReply);
				vos.get(i).setChildReply(childsReply);
				vos.get(i).setReplyCount(replyCount);
				
				if(vos.get(i).getCmGameIdx() != 0) {
					GameVO vo = communityDAO.getGameIdx(vos.get(i).getCmGameIdx());
					vos.get(i).setGameImg(vo.getGameImg());
				}
				
				FollowVO fVO = communityDAO.getFollow(mid, vos.get(i).getMid());
				if(fVO == null) vos.get(i).setFollow(0);
				else vos.get(i).setFollow(1);
			}
			return vos;
		}
		return vos;
	}

	@Override
	public int getFollowTotRecCnt(String mid, String string) {
		List<String> mids = communityDAO.getFollowMids(mid);
		
		if(mids.size() > 0) {
			String midsStr = "";
			for(int i=0; i<mids.size(); i++) {
				midsStr += "'" + mids.get(i) + "', ";
			}
			midsStr = midsStr.substring(0, midsStr.length()-2);
			return communityDAO.getFollowTotRecCnt(midsStr);
		}
		return 0;
	}

}
