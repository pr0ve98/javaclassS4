package com.spring.javaclassS4.service;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS4.vo.GameRequestVO;
import com.spring.javaclassS4.vo.GameVO;
import com.spring.javaclassS4.vo.ReplyVO;
import com.spring.javaclassS4.vo.SupportVO;

public interface AdminService {

	public int getGameTotRecCnt(String searchpart, String search);

	public ArrayList<GameVO> getGameList(int startIndexNo, int pageSize, String viewpart, String searchpart, String search);

	public int gameInput(GameVO vo, MultipartFile fName, HttpServletRequest request);

	public int gameInput2(GameVO vo);
	
	public int gameEdit(GameVO vo, MultipartFile fName, HttpServletRequest request);
	
	public int gameEdit2(GameVO vo);

	public GameVO gameTitleSearch(String gameTitle);

	public int gameDelete(int gameIdx, String gameImg, HttpServletRequest request);

	public int getAllUserTotRecCnt(String searchpart, String search);

	public ArrayList<GameVO> getAllUserList(int startIndexNo, int pageSize, String searchpart, String search);

	public int getLevelUserTotRecCnt(String viewpart, String searchpart, String search);

	public ArrayList<GameVO> getLevelUserList(int startIndexNo, int pageSize, String viewpart, String searchpart,
			String search);

	public int levelChange(int level, int idx, String nickname);

	public void banInput(String banMid, String reason);

	public int getStateUserTotRecCnt(String viewpart, String searchpart, String search);

	public ArrayList<GameVO> getStateUserList(int startIndexNo, int pageSize, String viewpart, String searchpart,
			String search);

	public int getKakaoUserTotRecCnt(String viewpart, String searchpart, String search);

	public ArrayList<GameVO> getKakaoUserList(int startIndexNo, int pageSize, String viewpart, String searchpart,
			String search);

	public void bannerChange(MultipartFile fName, HttpServletRequest request, HttpSession session);

	public void reportDown(String banMid);

	public int getReportTotRecCnt(String viewpart, String searchpart, String search);

	public ArrayList<GameVO> getReportList(int startIndexNo, int pageSize, String viewpart, String searchpart, String search);

	public ReplyVO getReplyIdx(int contentIdx);

	public void reportRead(int reIdx);

	public void reportAcquittal(int reIdx);

	public int supportInput(SupportVO vo, MultipartFile supImg, HttpServletRequest request);

	public int getSupportTotRecCnt(String viewpart, String search);

	public ArrayList<GameVO> getSupportList(int startIndexNo, int pageSize, String viewpart, String search);

	public void reSupport(SupportVO vo);

	public void gameRequestInput(GameRequestVO vo);

	public int getGameRequstTotRecCnt(String viewpart, String searchpart, String search);

	public ArrayList<GameRequestVO> getGameRequstList(int startIndexNo, int pageSize, String viewpart,
			String searchpart, String search);

	public void requestNo(int grIdx, String reason);

	public void requestYes(int grIdx);
}
