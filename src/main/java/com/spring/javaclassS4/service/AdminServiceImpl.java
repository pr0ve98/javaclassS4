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
import com.spring.javaclassS4.dao.CommunityDAO;
import com.spring.javaclassS4.vo.GameVO;

@Service
public class AdminServiceImpl implements AdminService {
	
	@Autowired
	AdminDAO adminDAO;
	
	@Autowired
	CommunityDAO communityDAO;
	
	@Autowired
	JavaclassProvide javaclassProvide;

	@Override
	public int getGameTotRecCnt(String searchpart, String search) {
		return adminDAO.getGameTotRecCnt(searchpart, search);
	}

	@Override
	public ArrayList<GameVO> getGameList(int startIndexNo, int pageSize, String viewpart, String searchpart, String search) {
		return adminDAO.getGameList(startIndexNo, pageSize, viewpart, searchpart, search);
	}

	@Override
	public int gameInput(GameVO vo, MultipartFile fName, HttpServletRequest request) {
		if(fName != null) {
			UUID uid = UUID.randomUUID();
			String oFileName = fName.getOriginalFilename();
			String sFileName = vo.getGameTitle() + "_" + uid.toString().substring(0,4) + "_" + oFileName;
			
			// 서버에 파일 올리기
			try {
				javaclassProvide.writeFile(fName, sFileName, "game");
				vo.setGameImg(sFileName);
			}
			catch (Exception e) {
				e.printStackTrace();
			}
			return adminDAO.gameInput(vo);
		}
		else return adminDAO.gameInput(vo);
	}
	
	@Override
	public int gameInput2(GameVO vo) {
		return adminDAO.gameInput(vo);
	}
	
	@Override
	public int gameEdit(GameVO vo, MultipartFile fName, HttpServletRequest request) {
		GameVO game = communityDAO.getGameIdx(vo.getGameIdx());
		GameVO testvo = adminDAO.gameTitleSearch(vo.getGameTitle());
		
		if(testvo != null) {
			 if((game.getGameIdx() != testvo.getGameIdx())) return 2;
			 else adminDAO.gameEdit(vo, "nameno");
		}
		
		if(fName != null) {
			UUID uid = UUID.randomUUID();
			String oFileName = fName.getOriginalFilename();
			String sFileName = vo.getGameTitle() + "_" + uid.toString().substring(0,4) + "_" + oFileName;
			
			// 서버에 파일 올리기
			try {
				javaclassProvide.writeFile(fName, sFileName, "game");
				vo.setGameImg(sFileName);
				String realPath = request.getSession().getServletContext().getRealPath("/resources/data/game/");
				File fileName = new File(realPath + game.getGameImg());
				if(fileName.exists()) fileName.delete();
			}
			catch (Exception e) {
				e.printStackTrace();
			}
			if(game.getGameTitle().equals(vo.getGameTitle())) return adminDAO.gameEdit(vo, "ok");
			else return adminDAO.gameEdit(vo, "nameok");
		}
		else {
			if(game.getGameTitle().equals(vo.getGameTitle())) {
				if(game.getGameImg() == null) game.setGameImg("noimage");
				if(game.getGameImg().equals(vo.getGameImg())) return adminDAO.gameEdit(vo, "no");
				else return adminDAO.gameEdit(vo, "ok");
			}
			else {
				if(game.getGameImg() == null) game.setGameImg("noimage");
				if(game.getGameImg().equals(vo.getGameImg())) return adminDAO.gameEdit(vo, "nameno");
				else return adminDAO.gameEdit(vo, "nameok");
			}
			
		}
	}
	
	@Override
	public int gameEdit2(GameVO vo) {
		GameVO game = communityDAO.getGameIdx(vo.getGameIdx());
		GameVO testvo = adminDAO.gameTitleSearch(vo.getGameTitle());
		
		if(testvo != null) {
			 if((game.getGameIdx() != testvo.getGameIdx())) return 2;
		}
		
		if(game.getGameTitle().equals(vo.getGameTitle())) {
			if(game.getGameImg() == null) game.setGameImg("noimage");
			if(game.getGameImg().equals(vo.getGameImg())) return adminDAO.gameEdit(vo, "no");
			else return adminDAO.gameEdit(vo, "ok");
		}
		else {
			if(game.getGameImg() == null) game.setGameImg("noimage");
			if(game.getGameImg().equals(vo.getGameImg())) return adminDAO.gameEdit(vo, "nameno");
			else return adminDAO.gameEdit(vo, "nameok");
		}
	}

	@Override
	public GameVO gameTitleSearch(String gameTitle) {
		return adminDAO.gameTitleSearch(gameTitle);
	}

	@Override
	public int gameDelete(int gameIdx, String gameImg, HttpServletRequest request) {
		if(gameImg.indexOf("http") == -1) {
			String realPath = request.getSession().getServletContext().getRealPath("/resources/data/game/");
			File fileName = new File(realPath + gameImg);
			if(fileName.exists()) fileName.delete();
		}
		return adminDAO.gameDelete(gameIdx);
	}

}
