package com.spring.javaclassS4.service;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.GameVO;
import com.spring.javaclassS4.vo.ReplyVO;
import com.spring.javaclassS4.vo.ReportVO;
import com.spring.javaclassS4.vo.ReviewVO;

public interface CommunityService {

	public String imageUpload(MultipartFile fName, HttpServletRequest request);

	public void deleteImage(String src, HttpServletRequest request);

	public String getMemberGamelist(String mid);

	public GameVO getGameIdx(int gameIdx);

	public String gameSearch(String game);

	public int setMemGameListEdit(String gamelist, String mid);

	public int communityInput(CommunityVO vo);

	public ArrayList<CommunityVO> getCommunityList(String mid, int startIndexNo, int pageSize);

	public CommunityVO showAllContent(int cmIdx);

	public void setLikeAdd(String mid, int cmIdx);

	public void setlikeDelete(String mid, int cmIdx);

	public CommunityVO getCommunityIdx(int cmIdx);

	public int getTotRecCnt(String part);

	public ArrayList<CommunityVO> getCommunityPartList(String mid, int startIndexNo, int pageSize, String part);

	public int getMyTotRecCnt(String mid);

	public int communityEdit(CommunityVO vo, int sw);

	public int setCommunityDelete(int cmIdx, HttpServletRequest request);

	public String replyInput(ReplyVO vo, HttpServletRequest request, HttpSession session);

	public String rreplyInput(ReplyVO vo, HttpServletRequest request, HttpSession session);

	public String parentReplyMore(int replyCmIdx, HttpServletRequest request, HttpSession session);

	public String childReplyMore(int replyCmIdx, int replyParentIdx, HttpServletRequest request, HttpSession session);

	public int getChildReplyCount(int replyIdx);

	public ArrayList<ReplyVO> getCommunityChildReply(int cmIdx, int replyIdx);

	public String replyEdit(String replyContent, int replyIdx, String replyMid, HttpServletRequest request, HttpSession session);

	public int replyDelete(int replyIdx);

	public void setReviewDelete(String mid, int cmGameIdx);

	public void followInput(String myMid, String youMid);

	public void followDelete(String myMid, String youMid);

	public void reportInput(ReportVO vo);

	public ArrayList<CommunityVO> getCommunityFollowList(String mid, int startIndexNo, int pageSize);

	public int getFollowTotRecCnt(String mid, String string);

	public String reviewGameSearch(String game);

	public int getNewsCnt(String string);

	public ArrayList<CommunityVO> getNewsList(int startIndexNo, int pageSize, String part);

	public CommunityVO getNewsContentCmIdx(int cmIdx, String mid);

	public int getMygameAndPart(String mid, String string);

	public ArrayList<ReviewVO> getRecentMyGame(String mid);

	public ArrayList<CommunityVO> getMyReview(String mid);

	public ArrayList<CommunityVO> getMyReviewList(String mid, String userMid, int startIndexNo, int pageSize);
	
	public ArrayList<CommunityVO> getMyRecordList(String mid, String userMid, int startIndexNo, int pageSize);

	public ArrayList<CommunityVO> getMyGameList(String mid, int startIndexNo, int pageSize);

}
