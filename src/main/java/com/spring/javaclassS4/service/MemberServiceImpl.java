package com.spring.javaclassS4.service;

import java.io.File;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS4.common.JavaclassProvide;
import com.spring.javaclassS4.dao.MemberDAO;
import com.spring.javaclassS4.vo.MemberVO;

@Service
public class MemberServiceImpl implements MemberService {
	
	@Autowired
	MemberDAO memberDAO;
	
	@Autowired
	JavaclassProvide javaclassProvide;

	@Override
	public MemberVO getMemberEmailCheck(String email) {
		return memberDAO.getMemberEmailCheck(email);
	}

	@Override
	public MemberVO getMemberIdCheck(String mid) {
		return memberDAO.getMemberIdCheck(mid);
	}

	@Override
	public int setMemberInput(MemberVO vo) {
		return memberDAO.setMemberInput(vo);
		
	}

	@Override
	public int setMemberIdChange(String mid, String sMid) {
		return memberDAO.setMemberIdChange(mid, sMid);
	}

	@Override
	public int setmemberPhotoChangePost(String mid, MultipartFile fName, HttpServletRequest request,
			HttpSession session) {
		UUID uid = UUID.randomUUID();
		String oFileName = fName.getOriginalFilename();
		String sFileName = mid + "_" + uid.toString().substring(0,8) + "_" + oFileName;
		
		MemberVO vo = memberDAO.getMemberIdCheck(mid);
		
		// 서버에 파일 올리기
		try {
			javaclassProvide.writeFile(fName, sFileName, "member");
			String realPath = request.getSession().getServletContext().getRealPath("/resources/data/member/");
			File fileName = new File(realPath + vo.getMemImg());
			if(!vo.getMemImg().equals("noimage.jpg")) {
				if(fileName.exists()) fileName.delete();
			}
			session.setAttribute("sMemImg", sFileName);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return memberDAO.setmemberPhotoChangePost(mid, sFileName);
	}

	@Override
	public int setmemberEdit(String nickname, String memInfo, String mid) {
		return memberDAO.setmemberEdit(nickname, memInfo, mid);
	}

	@Override
	public void setMemberBasicGameList(String mid) {
		memberDAO.setMemberBasicGameList(mid);
	}
}
