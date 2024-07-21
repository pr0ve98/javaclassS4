package com.spring.javaclassS4.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaclassS4.dao.HomeDAO;
import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.GameVO;

@Service
public class HomeServiceImpl implements HomeService {

	@Autowired
	HomeDAO homeDAO;
	
	@Override
	public ArrayList<GameVO> getNewGameList() {
		return homeDAO.getNewGameList();
	}

	@Override
	public GameVO getGame(int gameIdx) {
		return homeDAO.getGame(gameIdx);
	}

	@Override
	public int getGameTotRecCnt(String searchpart, String search, String mid) {
		return homeDAO.getGameTotRecCnt(searchpart, search, mid);
	}

	@Override
	public ArrayList<CommunityVO> getGameList(int startIndexNo, int pageSize, String viewpart, String searchpart,
			String search, String mid) {
		return homeDAO.getGameList(startIndexNo, pageSize, viewpart, searchpart, search, mid);
	}

}
