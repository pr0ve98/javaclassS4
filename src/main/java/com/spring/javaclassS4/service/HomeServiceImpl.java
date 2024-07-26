package com.spring.javaclassS4.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaclassS4.dao.HomeDAO;
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

}
