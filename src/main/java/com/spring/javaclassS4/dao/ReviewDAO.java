package com.spring.javaclassS4.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.ReviewVO;

public interface ReviewDAO {

	public int getGameTotRecCnt(@Param("search") String search, @Param("mid") String mid);

	public ArrayList<CommunityVO> getGameList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("viewpart") String viewpart,
			@Param("search") String search, @Param("mid") String mid);

	public ReviewVO getMidAndIdx(@Param("gameIdx") int gameIdx, @Param("mid") String mid);

	public void setReviewEdit(@Param("mid") String mid, @Param("gameIdx") int gameIdx, @Param("rating") int rating, @Param("state") String state);

	public void setReviewInput(@Param("mid") String mid, @Param("gameIdx") int gameIdx, @Param("rating") int rating, @Param("state") String state);

	public void setReviewDelete(@Param("mid") String mid, @Param("gameIdx") int gameIdx);

	public CommunityVO getReviewMore(@Param("gameIdx") int gameIdx, @Param("mid") String mid);

	public void reviewMoreInput(@Param("vo") CommunityVO vo);

	public void reviewMoreEdit(@Param("vo") CommunityVO vo);

	public int getRatingCount(@Param("mid") String mid, @Param("cnt") int cnt);

	public int getGameReviewCount(@Param("gameIdx") int gameIdx);

	public List<Integer> getGameReviewTotal(@Param("gameIdx") int gameIdx);

	public void setInvenscore(@Param("invenscore") double invenscore, @Param("gameIdx") int gameIdx);

}
