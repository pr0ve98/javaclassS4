package com.spring.javaclassS4.service;

import java.util.ArrayList;

import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.GameVO;

public interface HomeService {

	public ArrayList<GameVO> getNewGameList();

	public GameVO getGame(int gameIdx);

	public int getGameTotRecCnt(String searchpart, String search, String mid);

	public ArrayList<CommunityVO> getGameList(int startIndexNo, int pageSize, String viewpart, String searchpart,
			String search, String mid);

}
