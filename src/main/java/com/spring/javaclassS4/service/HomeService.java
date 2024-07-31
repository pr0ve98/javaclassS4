package com.spring.javaclassS4.service;

import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.GameVO;

public interface HomeService {

	public ArrayList<GameVO> getNewGameList();

	public GameVO getGame(int gameIdx);

	public int getMyGameCount(String mid);

	public int getMyGameStar(String mid, int rating);

	public int getMyGameState(String mid, String state);

	public Map<String, Integer> positiveMap(int gameIdx);

	public int reviewGameIdxAll(int gameIdx);

	public int reviewGameIdxN(int gameIdx);

	public Map<String, Integer> negativeMap(int gameIdx);

	public int getRatingCount(int gameIdx, int rating);

	public int allCount(int gameIdx);

	public CommunityVO getPosiBest(int gameIdx, HttpSession session);

	public CommunityVO getNegaBest(int gameIdx, HttpSession session);

	public CommunityVO getMyReview(int gameIdx, HttpSession session);

	public CommunityVO gameViewCommunityView(int cmIdx, HttpSession session);

	public ArrayList<CommunityVO> getIlgiList(int gameIdx, HttpSession session);

	public int ilgiCnt(int gameIdx);
	
	public ArrayList<CommunityVO> getInfolist(int gameIdx, HttpSession session);
	
	public int infoCnt(int gameIdx);

	public int getGameViewRCTotRecCnt(String flag, int gameIdx);

	public ArrayList<CommunityVO> getGameViewRCList(String mid, int startIndexNo, int pageSize, String flag, int gameIdx);

}
