package com.spring.javaclassS4.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS4.vo.GameVO;

public interface AdminDAO {

	public int getGameTotRecCnt();

	public ArrayList<GameVO> getGameList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public int gameAdd();

}
