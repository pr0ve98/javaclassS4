package com.spring.javaclassS4.service;

import java.io.File;
import java.util.ArrayList;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS4.common.JavaclassProvide;
import com.spring.javaclassS4.dao.AdminDAO;
import com.spring.javaclassS4.vo.GameVO;

@Service
public class AdminServiceImpl implements AdminService {
	
	@Autowired
	AdminDAO adminDAO;
	
	@Autowired
	JavaclassProvide javaclassProvide;

	@Override
	public int getGameTotRecCnt() {
		return adminDAO.getGameTotRecCnt();
	}

	@Override
	public ArrayList<GameVO> getGameList(int startIndexNo, int pageSize) {
		return adminDAO.getGameList(startIndexNo, pageSize);
	}

	@Override
	public int gameAdd(String mid, MultipartFile fName, HttpServletRequest request) {
		UUID uid = UUID.randomUUID();
		String oFileName = fName.getOriginalFilename();
		String sFileName = mid + "_" + uid.toString().substring(0,8) + "_" + oFileName;
		
		// 서버에 파일 올리기
		try {
			javaclassProvide.writeFile(fName, sFileName, "member");
			String realPath = request.getSession().getServletContext().getRealPath("/resources/data/game/");
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return adminDAO.gameAdd();
	}

}
