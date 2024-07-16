package com.spring.javaclassS4.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.GameVO;
import com.spring.javaclassS4.vo.ReplyVO;

public interface CommunityDAO {

	public GameVO getGameIdx(@Param("gameIdx") int gameIdx);

	public ArrayList<GameVO> gameSearch(@Param("game") String game);

	public int setMemGameListEdit(@Param("gamelist") String gamelist, @Param("mid") String mid);

	public int communityInput(@Param("vo") CommunityVO vo);

	public ArrayList<CommunityVO> getCommunityList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public CommunityVO showAllContent(@Param("cmIdx") int cmIdx);

	public List<String> getLikeMember(@Param("cmIdx") int cmIdx);

	public void setLikeAdd(@Param("mid") String mid, @Param("cmIdx") int cmIdx);

	public CommunityVO getCommunityIdx(@Param("cmIdx") int cmIdx);

	public void setlikeDelete(@Param("mid") String mid, @Param("cmIdx") int cmIdx);

	public int getTotRecCnt(@Param("part") String part);

	public ArrayList<CommunityVO> getCommunityPartList(@Param("mid") String mid, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("part") String part);

	public int getMyTotRecCnt(@Param("mid") String mid);

	public int communityEdit(@Param("vo") CommunityVO vo, @Param("sw") int sw);

	public int setCommunityDelete(@Param("cmIdx") int cmIdx);

	public ArrayList<ReplyVO> getCommunityReply(@Param("cmIdx") int cmIdx);

	public int replyInput(@Param("vo") ReplyVO vo);

	public int getReplyCount(@Param("cmIdx") int cmIdx);

	public int getChildReplyCount(@Param("replyIdx") int replyIdx);

	public int rreplyInput(@Param("vo") ReplyVO vo);

	public ArrayList<ReplyVO> getCommunityAllReply(@Param("replyCmIdx") int replyCmIdx, @Param("sw") int sw);

	public ArrayList<ReplyVO> getCommunityChildReply(@Param("replyCmIdx") int replyCmIdx, @Param("replyIdx") int replyIdx);

	public ArrayList<ReplyVO> getCommunityChildAllReply(@Param("replyCmIdx") int replyCmIdx, @Param("replyIdx") int replyIdx);

}
