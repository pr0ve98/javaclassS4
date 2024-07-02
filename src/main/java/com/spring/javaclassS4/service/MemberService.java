package com.spring.javaclassS4.service;

import com.spring.javaclassS4.vo.MemberVO;

public interface MemberService {

	public MemberVO getMemberEmailCheck(String email);

	public MemberVO getMemberIdCheck(String mid);

	public int setMemberInput(MemberVO vo);

}
