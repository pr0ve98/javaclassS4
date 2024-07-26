package com.spring.javaclassS4.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS4.vo.BanVO;
import com.spring.javaclassS4.vo.GameVO;

public interface AdminDAO {

	public int getGameTotRecCnt(@Param("searchpart") String searchpart, @Param("search") String search);

	public ArrayList<GameVO> getGameList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("viewpart") String viewpart, @Param("searchpart") String searchpart, @Param("search") String search);

	public int gameInput(@Param("vo") GameVO vo);

	public GameVO gameTitleSearch(@Param("gameTitle") String gameTitle);

	public int gameEdit(@Param("vo") GameVO vo, @Param("flag") String flag);

	public int gameDelete(@Param("gameIdx") int gameIdx);

	public int getAllUserTotRecCnt(@Param("searchpart") String searchpart, @Param("search") String search);

	public ArrayList<GameVO> getAllUserList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("searchpart") String searchpart, @Param("search") String search);

	public int getLevelUserTotRecCnt(@Param("viewpart") String viewpart, @Param("searchpart") String searchpart, @Param("search") String search);

	public ArrayList<GameVO> getLevelUserList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("viewpart") String viewpart, @Param("searchpart") String searchpart,
			@Param("search") String search);

	public int levelChange(@Param("level") int level, @Param("idx") int idx,  @Param("nickname") String nickname,  @Param("title") String title);

	public BanVO getBanMid(@Param("banMid") String banMid);

	public void setBanInput(@Param("banMid") String banMid, @Param("reason") String reason);
	
	public void setMemberLoginState(@Param("banMid") String banMid);

	public void setAlwaysBan(@Param("banMid") String banMid);

	public void setBanEdit(@Param("banMid") String banMid, @Param("day") int day, @Param("reason") String reason);

	public int getStateUserTotRecCnt(@Param("viewpart") String viewpart, @Param("searchpart") String searchpart, @Param("search") String search);

	public ArrayList<GameVO> getStateUserList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("viewpart") String viewpart, @Param("searchpart") String searchpart,
			@Param("search") String search);

	public int getKakaoUserTotRecCnt(@Param("viewpart") String viewpart, @Param("searchpart") String searchpart, @Param("search") String search);

	public ArrayList<GameVO> getKakaoUserList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("viewpart") String viewpart, @Param("searchpart") String searchpart,
			@Param("search") String search);

}
