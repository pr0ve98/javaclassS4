package com.spring.javaclassS4.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.GameVO;

public interface CommunityDAO {

	public GameVO getGameIdx(@Param("gameIdx") int gameIdx);

	public ArrayList<GameVO> gameSearch(@Param("game") String game);

	public int setMemGameListEdit(@Param("gamelist") String gamelist, @Param("mid") String mid);

	public int communityInput(@Param("vo") CommunityVO vo);

	public ArrayList<CommunityVO> getCommunityList();

	public CommunityVO showAllContent(@Param("cmIdx") int cmIdx);

}
