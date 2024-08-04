package com.spring.javaclassS4.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaclassS4.dao.CommunityDAO;
import com.spring.javaclassS4.dao.HomeDAO;
import com.spring.javaclassS4.vo.AlramVO;
import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.FollowVO;
import com.spring.javaclassS4.vo.GameVO;
import com.spring.javaclassS4.vo.ReplyVO;
import com.spring.javaclassS4.vo.ReviewVO;

@Service
public class HomeServiceImpl implements HomeService {

	@Autowired
	HomeDAO homeDAO;
	
	@Autowired
	CommunityDAO communityDAO;
	
	@Override
	public ArrayList<GameVO> getNewGameList() {
		return homeDAO.getNewGameList();
	}

	@Override
	public GameVO getGame(int gameIdx) {
		return homeDAO.getGame(gameIdx);
	}

	@Override
	public int getMyGameCount(String mid) {
		return homeDAO.getMyGameCount(mid);
	}

	@Override
	public int getMyGameStar(String mid, int rating) {
		return homeDAO.getMyGameStar(mid, rating);
	}

	@Override
	public int getMyGameState(String mid, String state) {
		return homeDAO.getMyGameState(mid, state);
	}

	@Override
	public Map<String, Integer> positiveMap(int gameIdx) {
		List<CommunityVO> vos = homeDAO.reviewGameIdxAll(gameIdx);
		String content = "";
		for(CommunityVO vo : vos) {
			Document doc = Jsoup.parse(vo.getCmContent());
			String textContent = doc.text();
			content += textContent + " ";
		}
		content = content.replace("하는", "").replace("는데", "").replace("고", "").replace("은", "").replace("는", "").replace("이", "").replace("이", "").replace("도", "");
		
		Map<String, Integer> positiveKeywords = new HashMap<String, Integer>();
		String[] words = content.split("\\s+"); // 스페이스바 최소 1개이상
		int wordFrequenciesToReturn = 15; // 빈도수
		int minWordLength = 2; // 최소 단어글자수
		
		for(String word : words) {
			if(word.length() >= minWordLength) {
				word = word.toLowerCase();
				positiveKeywords.put(word, positiveKeywords.getOrDefault(word, 0) + 1);
			}
		}
		
	   return positiveKeywords.entrySet().stream()
		          .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
		          .limit(wordFrequenciesToReturn)
		          .collect(HashMap::new, (m, e) -> m.put(e.getKey(), e.getValue()), HashMap::putAll);
	}

	@Override
	public int reviewGameIdxAll(int gameIdx) {
		return homeDAO.reviewGameIdxAll(gameIdx).size();
	}

	@Override
	public int reviewGameIdxN(int gameIdx) {
		return homeDAO.reviewGameIdxN(gameIdx).size();
	}

	@Override
	public Map<String, Integer> negativeMap(int gameIdx) {
		List<CommunityVO> vos = homeDAO.reviewGameIdxN(gameIdx);
		String content = "";
		for(CommunityVO vo : vos) {
			Document doc = Jsoup.parse(vo.getCmContent());
			String textContent = doc.text();
			content += textContent + " ";
		}
		content = content.replace("하는", "").replace("는데", "").replace("고", "").replace("은", "").replace("는", "").replace("이", "").replace("이", "").replace("도", "");
		
		Map<String, Integer> positiveKeywords = new HashMap<String, Integer>();
		String[] words = content.split("\\s+"); // 스페이스바 최소 1개이상
		int wordFrequenciesToReturn = 15; // 빈도수
		int minWordLength = 2; // 최소 단어글자수
		
		for(String word : words) {
			if(word.length() >= minWordLength) {
				word = word.toLowerCase();
				positiveKeywords.put(word, positiveKeywords.getOrDefault(word, 0) + 1);
			}
		}
		
	   return positiveKeywords.entrySet().stream()
		          .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
		          .limit(wordFrequenciesToReturn)
		          .collect(HashMap::new, (m, e) -> m.put(e.getKey(), e.getValue()), HashMap::putAll);
	}

	@Override
	public int getRatingCount(int gameIdx, int rating) {
		return homeDAO.getRatingCount(gameIdx, rating);
	}

	@Override
	public int allCount(int gameIdx) {
		return homeDAO.allCount(gameIdx);
	}

	@Override
	public CommunityVO getPosiBest(int gameIdx, HttpSession session) {
		String mid = session.getAttribute("sMid") == null ? "" : (String)session.getAttribute("sMid");
		CommunityVO vo = homeDAO.getPosiBest(gameIdx);
		if(vo != null) {
			vo = voReVO(vo, mid);
		}
		return vo;
	}

	@Override
	public CommunityVO getNegaBest(int gameIdx, HttpSession session) {
		String mid = session.getAttribute("sMid") == null ? "" : (String)session.getAttribute("sMid");
		CommunityVO vo = homeDAO.getNegaBest(gameIdx);
		if(vo != null) {
			vo = voReVO(vo, mid);
		}
		return vo;
	}

	@Override
	public CommunityVO getMyReview(int gameIdx, HttpSession session) {
		String mid = session.getAttribute("sMid") == null ? "" : (String)session.getAttribute("sMid");
		CommunityVO vo = homeDAO.getMyReview(gameIdx, mid);
		if(vo != null) {
			vo = voReVO(vo, mid);
		}
		return vo;
	}
	
	public CommunityVO voReVO(CommunityVO vo, String mid) {
		Document doc = Jsoup.parse(vo.getCmContent());
		Elements ptag = doc.select("p");
		Elements img = doc.select("img");
		
		StringBuilder reContent = new StringBuilder();
		
		if(!img.isEmpty()) {
			Element firstImg = img.first();
			for (Element e : ptag) {
				reContent.append(e.outerHtml());
				if(e.equals(firstImg.parent())) {
					vo.setLongContent(1);
					break;
				}
			}
		}
		else {
			if(ptag.size() < 7) {
				ptag.forEach(p -> reContent.append(p.outerHtml()));
				vo.setLongContent(0);
			}
			else {
				ptag.stream().limit(7).forEach(p -> reContent.append(p.outerHtml()));
				vo.setLongContent(1);
			}
		}
		vo.setCmContent(reContent.toString());
		List<String> likeMember = communityDAO.getLikeMember(vo.getCmIdx());
		if(mid != null && likeMember.size() > 0) {
			for(int j=0; j<likeMember.size(); j++) {
				if(mid.equals(likeMember.get(j))) {
					vo.setLikeSW(1);
					break;
				}
				else vo.setLikeSW(0);
			}
		}
		vo.setLikeMember(likeMember);
		vo.setLikeCnt(likeMember.size());
		
        ArrayList<ReplyVO> parentsReply = communityDAO.getCommunityReply(vo.getCmIdx());
        ArrayList<ReplyVO> childsReply = new ArrayList<>(); // 자식 댓글 리스트를 반복문 밖에서 초기화

		for (ReplyVO k : parentsReply) {
        	k.setReplyContent(k.getReplyContent().replace("\n", "<br/>"));
            int childReplyCount = communityDAO.getChildReplyCount(k.getReplyIdx());
            k.setChildReplyCount(childReplyCount);

            ArrayList<ReplyVO> childReplies = communityDAO.getCommunityChildReply(vo.getCmIdx(), k.getReplyIdx());
            
            // 자식 댓글을 추가
            if (childReplies != null) {
            	for (ReplyVO c : childReplies) {
            		c.setReplyContent(c.getReplyContent().replace("\n", "<br/>"));
            	}
                childsReply.addAll(childReplies);
            }
        }
	        
		int replyCount = communityDAO.getReplyCount(vo.getCmIdx());
		vo.setParentsReply(parentsReply);
		vo.setChildReply(childsReply);
		vo.setReplyCount(replyCount);
		
		if(vo.getCmGameIdx() != 0) {
			GameVO vo2 = communityDAO.getGameIdx(vo.getCmGameIdx());
			vo.setGameImg(vo2.getGameImg());
		}
		
		FollowVO fVO = communityDAO.getFollow(mid, vo.getMid());
		if(fVO == null) vo.setFollow(0);
		else vo.setFollow(1);
		return vo;
	}

	@Override
	public CommunityVO gameViewCommunityView(int cmIdx, HttpSession session) {
		String mid = session.getAttribute("sMid") == null ? "" : (String)session.getAttribute("sMid");
		CommunityVO vo = homeDAO.showAllContent(cmIdx);
		
		List<String> likeMember = communityDAO.getLikeMember(vo.getCmIdx());
		if(mid != null && likeMember.size() > 0) {
			for(int j=0; j<likeMember.size(); j++) {
				if(mid.equals(likeMember.get(j))) {
					vo.setLikeSW(1);
					break;
				}
				else vo.setLikeSW(0);
			}
		}
		vo.setLikeMember(likeMember);
		vo.setLikeCnt(likeMember.size());
		
        ArrayList<ReplyVO> parentsReply = communityDAO.getCommunityReply(vo.getCmIdx());
        ArrayList<ReplyVO> childsReply = new ArrayList<>(); // 자식 댓글 리스트를 반복문 밖에서 초기화

        for (ReplyVO k : parentsReply) {
            int childReplyCount = communityDAO.getChildReplyCount(k.getReplyIdx());
            k.setChildReplyCount(childReplyCount);

            ArrayList<ReplyVO> childReplies = communityDAO.getCommunityChildReply(vo.getCmIdx(), k.getReplyIdx());
            
            // 자식 댓글을 추가
            if (childReplies != null) {
                childsReply.addAll(childReplies);
            }
        }
	        
		int replyCount = communityDAO.getReplyCount(vo.getCmIdx());
		vo.setParentsReply(parentsReply);
		vo.setChildReply(childsReply);
		vo.setReplyCount(replyCount);
		
		if(vo.getCmGameIdx() != 0) {
			GameVO vo2 = communityDAO.getGameIdx(vo.getCmGameIdx());
			vo.setGameImg(vo2.getGameImg());
		}
		
		FollowVO fVO = communityDAO.getFollow(mid, vo.getMid());
		if(fVO == null) vo.setFollow(0);
		else vo.setFollow(1);
		return vo;
	}

	@Override
	public ArrayList<CommunityVO> getIlgiList(int gameIdx, HttpSession session) {
		String mid = session.getAttribute("sMid") == null ? "" : (String)session.getAttribute("sMid");
		ArrayList<CommunityVO> vos = homeDAO.getIlgiList(gameIdx);
		for(CommunityVO vo : vos) {
			vo = voReVO(vo, mid);
		}
		return vos;
	}

	@Override
	public int ilgiCnt(int gameIdx) {
		return homeDAO.ilgiCnt(gameIdx);
	}
	
	@Override
	public ArrayList<CommunityVO> getInfolist(int gameIdx, HttpSession session) {
		String mid = session.getAttribute("sMid") == null ? "" : (String)session.getAttribute("sMid");
		ArrayList<CommunityVO> vos = homeDAO.getInfolist(gameIdx);
		for(CommunityVO vo : vos) {
			vo = voReVO(vo, mid);
		}
		return vos;
	}
	
	@Override
	public int infoCnt(int gameIdx) {
		return homeDAO.infoCnt(gameIdx);
	}

	@Override
	public int getGameViewRCTotRecCnt(int gameIdx, String part) {
		return homeDAO.getGameViewRCTotRecCnt(gameIdx, part);
	}

	@Override
	public ArrayList<CommunityVO> getGameViewRCList(String mid, int startIndexNo, int pageSize,
			int gameIdx, String part) {
		ArrayList<CommunityVO> vos = homeDAO.getGameViewRCList(startIndexNo, pageSize, gameIdx, part);
		for(CommunityVO vo : vos) {
			vo = voReVO(vo, mid);
		}
		return vos;
	}

	@Override
	public ArrayList<ReviewVO> getMyGameList(String mid, String part) {
		return homeDAO.getMyGameList(mid, part);
	}

	@Override
	public ArrayList<CommunityVO> bestReviews(HttpSession session) {
		String mid = session.getAttribute("sMid") == null ? "" : (String)session.getAttribute("sMid");
		ArrayList<CommunityVO> vos = homeDAO.bestReviews();
		for(CommunityVO vo:vos) {
			// 텍스트만 뽑아내기
	        Document doc = Jsoup.parse(vo.getCmContent());
	        String ctPreview = doc.text();
	        if(ctPreview.length() > 200) {
	        	ctPreview = ctPreview.substring(0, 200);
	        }
	        vo.setOnlyText(ctPreview);
	        
	        List<String> likeMember = communityDAO.getLikeMember(vo.getCmIdx());
			if(mid != null && likeMember.size() > 0) {
				for(int j=0; j<likeMember.size(); j++) {
					if(mid.equals(likeMember.get(j))) {
						vo.setLikeSW(1);
						break;
					}
					else vo.setLikeSW(0);
				}
			}
			vo.setLikeMember(likeMember);
			vo.setLikeCnt(likeMember.size());
			
	        ArrayList<ReplyVO> parentsReply = communityDAO.getCommunityReply(vo.getCmIdx());
	        ArrayList<ReplyVO> childsReply = new ArrayList<>(); // 자식 댓글 리스트를 반복문 밖에서 초기화

			for (ReplyVO k : parentsReply) {
	        	k.setReplyContent(k.getReplyContent().replace("\n", "<br/>"));
	            int childReplyCount = communityDAO.getChildReplyCount(k.getReplyIdx());
	            k.setChildReplyCount(childReplyCount);

	            ArrayList<ReplyVO> childReplies = communityDAO.getCommunityChildReply(vo.getCmIdx(), k.getReplyIdx());
	            
	            // 자식 댓글을 추가
	            if (childReplies != null) {
	            	for (ReplyVO c : childReplies) {
	            		c.setReplyContent(c.getReplyContent().replace("\n", "<br/>"));
	            	}
	                childsReply.addAll(childReplies);
	            }
	        }
		        
			int replyCount = communityDAO.getReplyCount(vo.getCmIdx());
			vo.setParentsReply(parentsReply);
			vo.setChildReply(childsReply);
			vo.setReplyCount(replyCount);
			
			if(vo.getCmGameIdx() != 0) {
				GameVO vo2 = communityDAO.getGameIdx(vo.getCmGameIdx());
				vo.setGameImg(vo2.getGameImg());
			}
			
			FollowVO fVO = communityDAO.getFollow(mid, vo.getMid());
			if(fVO == null) vo.setFollow(0);
			else vo.setFollow(1);
		}
		return vos;
	}

	@Override
	public ArrayList<CommunityVO> homeCommunity(HttpSession session, String part) {
		String mid = session.getAttribute("sMid") == null ? "" : (String)session.getAttribute("sMid");
		ArrayList<CommunityVO> vos = homeDAO.homeCommunity(part);
		for(CommunityVO vo:vos) {
			Document doc = Jsoup.parse(vo.getCmContent());
			// 텍스트만 뽑아내기
	        String ctPreview = doc.text();
	        if(ctPreview.length() > 200) {
	        	ctPreview = ctPreview.substring(0, 200);
	        }
	        vo.setOnlyText(ctPreview);
			
	        Elements img = doc.select("img");
			if(!img.isEmpty()) {
				Element firstImg = img.first();
			    String imgSrc = firstImg.attr("src");

			    String imgName;

			    if (imgSrc.startsWith("http")) {
			        imgName = imgSrc;
			    } else {
			        imgName = imgSrc.substring(imgSrc.lastIndexOf('/') + 1);
			    }

			    vo.setNewsThumnail(imgName);
			}
			else {
				if(part.equals("인기")) vo.setNewsThumnail("thumnailNot.jpg");
				else vo.setNewsThumnail("sale_thumbnail.png");
			}
	        
	        List<String> likeMember = communityDAO.getLikeMember(vo.getCmIdx());
			if(mid != null && likeMember.size() > 0) {
				for(int j=0; j<likeMember.size(); j++) {
					if(mid.equals(likeMember.get(j))) {
						vo.setLikeSW(1);
						break;
					}
					else vo.setLikeSW(0);
				}
			}
			vo.setLikeMember(likeMember);
			vo.setLikeCnt(likeMember.size());
			
	        ArrayList<ReplyVO> parentsReply = communityDAO.getCommunityReply(vo.getCmIdx());
	        ArrayList<ReplyVO> childsReply = new ArrayList<>(); // 자식 댓글 리스트를 반복문 밖에서 초기화

	        for (ReplyVO k : parentsReply) {
	            int childReplyCount = communityDAO.getChildReplyCount(k.getReplyIdx());
	            k.setChildReplyCount(childReplyCount);

	            ArrayList<ReplyVO> childReplies = communityDAO.getCommunityChildReply(vo.getCmIdx(), k.getReplyIdx());
	            
	            // 자식 댓글을 추가
	            if (childReplies != null) {
	                childsReply.addAll(childReplies);
	            }
	        }
		        
			int replyCount = communityDAO.getReplyCount(vo.getCmIdx());
			vo.setParentsReply(parentsReply);
			vo.setChildReply(childsReply);
			vo.setReplyCount(replyCount);
			
			if(vo.getCmGameIdx() != 0) {
				GameVO vo2 = communityDAO.getGameIdx(vo.getCmGameIdx());
				vo.setGameImg(vo2.getGameImg());
			}
			
			FollowVO fVO = communityDAO.getFollow(mid, vo.getMid());
			if(fVO == null) vo.setFollow(0);
			else vo.setFollow(1);
		}
		return vos;
	}

	@Override
	public ArrayList<AlramVO> getAlram(String mid, int level) {
		return homeDAO.getAlram(mid, level);
	}


}
