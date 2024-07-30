package com.spring.javaclassS4.service;

import java.util.ArrayList;
import java.util.Map;

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

}
