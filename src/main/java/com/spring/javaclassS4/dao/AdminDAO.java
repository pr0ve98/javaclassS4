package com.spring.javaclassS4.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS4.vo.BanVO;
import com.spring.javaclassS4.vo.GameVO;
import com.spring.javaclassS4.vo.ReplyVO;

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

	public void setBanDelete(@Param("banMid") String banMid);

	public void setAlwaysBanDelete(@Param("banMid") String banMid);

	public int getReportTotRecCnt(@Param("viewpart") String viewpart, @Param("searchpart") String searchpart, @Param("search") String search);

	public ArrayList<GameVO> getReportList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, 
			@Param("viewpart") String viewpart, @Param("searchpart") String searchpart,
			@Param("search") String search);

	public ReplyVO getReplyIdx(@Param("contentIdx") int contentIdx);

	public void reportRead(@Param("reIdx") int reIdx);

	public void reportAcquittal(@Param("reIdx") int reIdx);

}
