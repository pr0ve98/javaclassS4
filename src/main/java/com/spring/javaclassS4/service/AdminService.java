package com.spring.javaclassS4.service;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS4.vo.GameVO;

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
}
