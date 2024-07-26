package com.spring.javaclassS4.service;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS4.common.JavaclassProvide;
import com.spring.javaclassS4.dao.AdminDAO;
import com.spring.javaclassS4.dao.CommunityDAO;
import com.spring.javaclassS4.vo.BanVO;
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

	@Override
	public int getAllUserTotRecCnt(String searchpart, String search) {
		return adminDAO.getAllUserTotRecCnt(searchpart, search);
	}

	@Override
	public ArrayList<GameVO> getAllUserList(int startIndexNo, int pageSize, String searchpart,
			String search) {
		return adminDAO.getAllUserList(startIndexNo, pageSize, searchpart, search);
	}

	@Override
	public int getLevelUserTotRecCnt(String viewpart, String searchpart, String search) {
		return adminDAO.getLevelUserTotRecCnt(viewpart, searchpart, search);
	}

	@Override
	public ArrayList<GameVO> getLevelUserList(int startIndexNo, int pageSize, String viewpart, String searchpart,
			String search) {
		return adminDAO.getLevelUserList(startIndexNo, pageSize, viewpart, searchpart, search);
	}

	@Override
	public int levelChange(int level, int idx, String nickname) {
		String title = "없음";
		if(level == 0) {
			nickname = "GM "+nickname;
			title = "<span style=\"background: linear-gradient(to right, #ff0000, #ff9000, #fff100, #4dff00, #00a2ff, #384fff, #f140ff);color: transparent;-webkit-background-clip: text;font-weight: bolder;display: inline-block;\">[GM]</span>";
		}
		else if(level == 1){
		}
		else nickname = nickname.replace("GM ", "");
		return adminDAO.levelChange(level, idx, nickname, title);
	}

	@Transactional
	@Override
	public void banInput(String banMid, String reason) {
		BanVO vo = adminDAO.getBanMid(banMid);
		if(vo == null) {
			adminDAO.setBanInput(banMid, reason);
			adminDAO.setMemberLoginState(banMid);
		}
		else if(vo.getBanDay() == 3) {
			adminDAO.setBanEdit(banMid, 7, reason);
			adminDAO.setMemberLoginState(banMid);
		}
		else if(vo.getBanDay() == 7) {
			adminDAO.setBanEdit(banMid, 30, reason);
			adminDAO.setMemberLoginState(banMid);
		}
		else adminDAO.setAlwaysBan(banMid);
	}

	@Override
	public int getStateUserTotRecCnt(String viewpart, String searchpart, String search) {
		return adminDAO.getStateUserTotRecCnt(viewpart, searchpart, search);
	}

	@Override
	public ArrayList<GameVO> getStateUserList(int startIndexNo, int pageSize, String viewpart, String searchpart,
			String search) {
		return adminDAO.getStateUserList(startIndexNo, pageSize, viewpart, searchpart, search);
	}

	@Override
	public int getKakaoUserTotRecCnt(String viewpart, String searchpart, String search) {
		return adminDAO.getKakaoUserTotRecCnt(viewpart, searchpart, search);
	}

	@Override
	public ArrayList<GameVO> getKakaoUserList(int startIndexNo, int pageSize, String viewpart, String searchpart,
			String search) {
		return adminDAO.getKakaoUserList(startIndexNo, pageSize, viewpart, searchpart, search);
	}

	@Override
	public void bannerChange(MultipartFile fName, HttpServletRequest request, HttpSession session) {
		String sFileName = "banner1.jpg";
		
		// 서버에 파일 올리기
		try {
			String realPath = request.getSession().getServletContext().getRealPath("/resources/images/");
			File fileName = new File(realPath + sFileName);
				if(fileName.exists()) fileName.delete();
				
			FileOutputStream fos = new FileOutputStream(realPath + sFileName);
			if(fName.getBytes().length != -1) {
				fos.write(fName.getBytes());
			}
			fos.flush();
			fos.close();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}

}
