package com.spring.javaclassS4.service;

import java.util.ArrayList;

import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.GameVO;

public interface HomeService {

	public ArrayList<GameVO> getNewGameList();

	public GameVO getGame(int gameIdx);

}
