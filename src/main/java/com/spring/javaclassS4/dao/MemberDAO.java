package com.spring.javaclassS4.dao;

import org.apache.ibatis.annotations.Param;

import com.spring.javaclassS4.vo.MemberVO;

public interface MemberDAO {

	public MemberVO getMemberEmailCheck(@Param("email") String email);

	public MemberVO getMemberIdCheck(@Param("mid") String mid);

	public int setMemberInput(@Param("vo") MemberVO vo);

}
