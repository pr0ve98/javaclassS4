package com.spring.javaclassS4.service;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS4.vo.GameVO;

public interface AdminService {

	public int getGameTotRecCnt();

	public ArrayList<GameVO> getGameList(int startIndexNo, int pageSize);

	public int gameAdd(String mid, MultipartFile fName, HttpServletRequest request);

}
