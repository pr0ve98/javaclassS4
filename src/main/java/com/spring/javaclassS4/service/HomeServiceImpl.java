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

}
