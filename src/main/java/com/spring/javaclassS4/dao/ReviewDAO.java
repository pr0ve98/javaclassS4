package com.spring.javaclassS4.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.ReviewVO;

public interface ReviewDAO {

	public int getGameTotRecCnt(@Param("searchpart") String searchpart, @Param("search") String search, @Param("mid") String mid);

	public ArrayList<CommunityVO> getGameList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("viewpart") String viewpart, @Param("searchpart") String searchpart,
			@Param("search") String search, @Param("mid") String mid);

	public ReviewVO getMidAndIdx(@Param("gameIdx") int gameIdx, @Param("mid") String mid);

	public void setReviewEdit(@Param("mid") String mid, @Param("gameIdx") int gameIdx, @Param("rating") int rating, @Param("state") String state);

	public void setReviewInput(@Param("mid") String mid, @Param("gameIdx") int gameIdx, @Param("rating") int rating, @Param("state") String state);

	public void setReviewDelete(@Param("mid") String mid, @Param("gameIdx") int gameIdx);

}
