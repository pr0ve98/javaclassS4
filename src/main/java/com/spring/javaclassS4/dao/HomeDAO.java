package com.spring.javaclassS4.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.GameVO;

public interface HomeDAO {

	public ArrayList<GameVO> getNewGameList();

	public GameVO getGame(@Param("gameIdx") int gameIdx);

	public int getMyGameCount(@Param("mid") String mid);

	public int getMyGameStar(@Param("mid") String mid, @Param("rating") int rating);

	public int getMyGameState(@Param("mid") String mid, @Param("state") String state);

	public List<CommunityVO> reviewGameIdxAll(@Param("gameIdx") int gameIdx);

	public List<CommunityVO> reviewGameIdxN(@Param("gameIdx") int gameIdx);

	public int getRatingCount(@Param("gameIdx") int gameIdx, @Param("rating") int rating);
}
