package com.spring.javaclassS4.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaclassS4.dao.HomeDAO;
import com.spring.javaclassS4.vo.CommunityVO;
import com.spring.javaclassS4.vo.GameVO;

@Service
public class HomeServiceImpl implements HomeService {

	@Autowired
	HomeDAO homeDAO;
	
	@Override
	public ArrayList<GameVO> getNewGameList() {
		return homeDAO.getNewGameList();
	}

	@Override
	public GameVO getGame(int gameIdx) {
		return homeDAO.getGame(gameIdx);
	}

	@Override
	public int getMyGameCount(String mid) {
		return homeDAO.getMyGameCount(mid);
	}

	@Override
	public int getMyGameStar(String mid, int rating) {
		return homeDAO.getMyGameStar(mid, rating);
	}

	@Override
	public int getMyGameState(String mid, String state) {
		return homeDAO.getMyGameState(mid, state);
	}

	@Override
	public Map<String, Integer> positiveMap(int gameIdx) {
		List<CommunityVO> vos = homeDAO.reviewGameIdxAll(gameIdx);
		String content = "";
		for(CommunityVO vo : vos) {
			Document doc = Jsoup.parse(vo.getCmContent());
			String textContent = doc.text();
			content += textContent + " ";
		}
		content = content.replace("고", "").replace("은", "").replace("는", "").replace("이", "").replace("이", "").replace("도", "");
		
		Map<String, Integer> positiveKeywords = new HashMap<String, Integer>();
		String[] words = content.split("\\s+"); // 스페이스바 최소 1개이상
		int wordFrequenciesToReturn = 15; // 빈도수
		int minWordLength = 2; // 최소 단어글자수
		
		for(String word : words) {
			if(word.length() >= minWordLength) {
				word = word.toLowerCase();
				positiveKeywords.put(word, positiveKeywords.getOrDefault(word, 0) + 1);
			}
		}
		
	   return positiveKeywords.entrySet().stream()
		          .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
		          .limit(wordFrequenciesToReturn)
		          .collect(HashMap::new, (m, e) -> m.put(e.getKey(), e.getValue()), HashMap::putAll);
	}

	@Override
	public int reviewGameIdxAll(int gameIdx) {
		return homeDAO.reviewGameIdxAll(gameIdx).size();
	}

	@Override
	public int reviewGameIdxN(int gameIdx) {
		return homeDAO.reviewGameIdxN(gameIdx).size();
	}

	@Override
	public Map<String, Integer> negativeMap(int gameIdx) {
		List<CommunityVO> vos = homeDAO.reviewGameIdxN(gameIdx);
		String content = "";
		for(CommunityVO vo : vos) {
			Document doc = Jsoup.parse(vo.getCmContent());
			String textContent = doc.text();
			content += textContent + " ";
		}
		content = content.replace("고", "").replace("은", "").replace("는", "").replace("이", "").replace("이", "").replace("도", "");
		
		Map<String, Integer> positiveKeywords = new HashMap<String, Integer>();
		String[] words = content.split("\\s+"); // 스페이스바 최소 1개이상
		int wordFrequenciesToReturn = 15; // 빈도수
		int minWordLength = 2; // 최소 단어글자수
		
		for(String word : words) {
			if(word.length() >= minWordLength) {
				word = word.toLowerCase();
				positiveKeywords.put(word, positiveKeywords.getOrDefault(word, 0) + 1);
			}
		}
		
	   return positiveKeywords.entrySet().stream()
		          .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
		          .limit(wordFrequenciesToReturn)
		          .collect(HashMap::new, (m, e) -> m.put(e.getKey(), e.getValue()), HashMap::putAll);
	}

	@Override
	public int getRatingCount(int gameIdx, int rating) {
		return homeDAO.getRatingCount(gameIdx, rating);
	}

}
