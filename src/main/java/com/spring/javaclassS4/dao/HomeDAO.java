package com.spring.javaclassS4.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.GameVO;

public interface HomeDAO {

	public ArrayList<GameVO> getNewGameList();

	public GameVO getGame(@Param("gameIdx") int gameIdx);

	public int getGameTotRecCnt(@Param("searchpart") String searchpart, @Param("search") String search, @Param("mid") String mid);

	public ArrayList<CommunityVO> getGameList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("viewpart") String viewpart, @Param("searchpart") String searchpart,
			@Param("search") String search, @Param("mid") String mid);

}
