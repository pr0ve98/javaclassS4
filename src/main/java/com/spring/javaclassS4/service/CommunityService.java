package com.spring.javaclassS4.service;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javaclassS4.vo.GameVO;

public interface CommunityService {

	public String imageUpload(MultipartFile fName, HttpServletRequest request);

	public void deleteImage(String src, HttpServletRequest request);

	public String getMemberGamelist(String mid);

	public GameVO getGameIdx(int gameIdx);

	public String gameSearch(String game);

	public int setMemGameListEdit(String gamelist, String mid);

}