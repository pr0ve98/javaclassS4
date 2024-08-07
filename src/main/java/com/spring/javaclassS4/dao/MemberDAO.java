package com.spring.javaclassS4.dao;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS4.vo.FollowVO;
import com.spring.javaclassS4.vo.MemberVO;

public interface MemberDAO {

	public MemberVO getMemberEmailCheck(@Param("email") String email);

	public MemberVO getMemberIdCheck(@Param("mid") String mid);

	public int setMemberInput(@Param("vo") MemberVO vo);

	public int setMemberIdChange(@Param("mid") String mid, @Param("sMid") String sMid);

	public int setmemberPhotoChangePost(@Param("mid") String mid, @Param("sFileName") String sFileName);

	public int setmemberEdit(@Param("nickname") String nickname, @Param("memInfo") String memInfo, @Param("mid") String mid);

	public void setMemberBasicGameList(@Param("mid") String mid);

	public String getMemberGamelist(@Param("mid") String mid);

	public void unlockMember(@Param("day") int day);

	public void pwdResetOk(@Param("email") String email, @Param("pwdEncode") String pwdEncode);

	public void pwdChange(@Param("mid") String mid, @Param("pwd") String pwd);

	public int getFollowerAndFollowing(@Param("mid") String mid, @Param("part") String part);

	public FollowVO isMyFollower(@Param("sMid") String sMid, @Param("mid") String mid);

	public void setReviewDelete(@Param("mid") String mid);

	public void setGameListDelete(@Param("mid") String mid);

	public void setFollowDelete(@Param("mid") String mid);

	public void setLikeDelete(@Param("mid") String mid);

	public void setReplyDelete(@Param("mid") String mid);
	
	public void setCommunityDelete(@Param("mid") String mid);

	public void setMemberOut(@Param("mid") String mid);

}
