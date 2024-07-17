package com.spring.javaclassS4.service;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS4.vo.GameVO;

public interface AdminService {

	public int getGameTotRecCnt();

	public ArrayList<GameVO> getGameList(int startIndexNo, int pageSize);

	public int gameInput(GameVO vo, MultipartFile fName, HttpServletRequest request);

	public GameVO gameTitleSearch(String gameTitle);

	public int gameInput2(GameVO vo);

}
