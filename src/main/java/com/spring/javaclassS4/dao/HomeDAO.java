package com.spring.javaclassS4.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS4.vo.GameVO;

public interface HomeDAO {

	public ArrayList<GameVO> getNewGameList();

	public GameVO getGame(@Param("gameIdx") int gameIdx);
}
