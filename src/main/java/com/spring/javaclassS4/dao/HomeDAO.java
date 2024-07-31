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

	public int allCount(@Param("gameIdx") int gameIdx);

	public CommunityVO getPosiBest(@Param("gameIdx") int gameIdx);

	public CommunityVO getNegaBest(@Param("gameIdx") int gameIdx);

	public CommunityVO getMyReview(@Param("gameIdx") int gameIdx, @Param("mid") String mid);

	public CommunityVO showAllContent(@Param("cmIdx") int cmIdx);

	public ArrayList<CommunityVO> getIlgiList(@Param("gameIdx") int gameIdx);

	public int ilgiCnt(@Param("gameIdx") int gameIdx);
	
	public ArrayList<CommunityVO> getInfolist(@Param("gameIdx") int gameIdx);
	
	public int infoCnt(@Param("gameIdx") int gameIdx);

	public int getGameViewRCTotRecCnt(@Param("gameIdx") int gameIdx, @Param("part") String part);

	public ArrayList<CommunityVO> getGameViewRCList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize,
			@Param("gameIdx") int gameIdx, @Param("part") String part);
}
