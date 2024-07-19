package com.spring.javaclassS4.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS4.vo.GameVO;

public interface AdminDAO {

	public int getGameTotRecCnt(@Param("searchpart") String searchpart, @Param("search") String search);

	public ArrayList<GameVO> getGameList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("viewpart") String viewpart, @Param("searchpart") String searchpart, @Param("search") String search);

	public int gameInput(@Param("vo") GameVO vo);

	public GameVO gameTitleSearch(@Param("gameTitle") String gameTitle);

	public int gameEdit(@Param("vo") GameVO vo, @Param("flag") String flag);

	public int gameDelete(@Param("gameIdx") int gameIdx);

}
