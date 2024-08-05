package com.spring.javaclassS4.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS4.vo.FollowVO;
import com.spring.javaclassS4.vo.MemberVO;

public interface MemberService {

	public MemberVO getMemberEmailCheck(String email);

	public MemberVO getMemberIdCheck(String mid);

	public int setMemberInput(MemberVO vo);

	public int setMemberIdChange(String mid, String sMid);

	public int setmemberPhotoChangePost(String mid, MultipartFile fName, HttpServletRequest request,
			HttpSession session);

	public int setmemberEdit(String nickname, String memInfo, String mid);

	public void setMemberBasicGameList(String mid);

	public void pwdResetOk(String email, String pwd, String pwdEncode);

	public void pwdChange(String mid, String pwd);

	public int getFollowerAndFollowing(String mid, String part);

	public FollowVO isMyFollower(String sMid, String mid);

	public String allDelete(String mid);

}
