package com.spring.javaclassS4.service;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS4.common.JavaclassProvide;
import com.spring.javaclassS4.dao.CommunityDAO;
import com.spring.javaclassS4.dao.MemberDAO;
import com.spring.javaclassS4.vo.GameVO;

@Service
public class CommunityServiceImpl implements CommunityService {
	
	@Autowired
	JavaclassProvide javaclassProvide;
	
	@Autowired
	MemberDAO memberDAO;
	
	@Autowired
	CommunityDAO communityDAO;

	@Override
	public String imageUpload(MultipartFile fName, HttpServletRequest request) {
		String uid = UUID.randomUUID().toString().substring(0,8);
		String sFileName = uid + "_" + fName.getOriginalFilename();
		
		try {
			javaclassProvide.writeFile(fName, sFileName, "community");
			return request.getContextPath()+"/community/"+sFileName;
		} catch (IOException e) {
			e.printStackTrace();
			return "";
		}
	}

	@Override
	public void deleteImage(String src, HttpServletRequest request) {
		String fName = src.substring(src.lastIndexOf("/")+1);
		if(fName != null) {
			String realPath = request.getSession().getServletContext().getRealPath("/resources/data/community/");
			
			File file = new File(realPath + fName);
			if(file.exists() && file.isFile()) {
				file.delete();
			}
		}
	}

	@Override
	public String getMemberGamelist(String mid) {
		return memberDAO.getMemberGamelist(mid);
	}

	@Override
	public GameVO getGameIdx(int gameIdx) {
		return communityDAO.getGameIdx(gameIdx);
	}

	@Override
	public String gameSearch(String game) {
		String str = "";
		ArrayList<GameVO> vos = communityDAO.gameSearch(game);
		if(vos.isEmpty()) return str = "검색한 게임이 없습니다";
		for(GameVO vo : vos) {
			String gamename = vo.getGameTitle() + " ("+vo.getShowDate().split("-")[0]+")";
			str += "<div class=\"result-item\" data-gamesearchidx=\""+vo.getGameIdx()+"\" onclick=\"gamelistAdd("+vo.getGameIdx()+")\">"
				+ "<img src=\""+vo.getGameImg()+"\" alt=\""+gamename+"\">"
				+ "<span>"+gamename+"</span></div>";
		}
		return str;
	}

	@Override
	public int setMemGameListEdit(String gamelist, String mid) {
		return communityDAO.setMemGameListEdit(gamelist, mid);
	}

}
