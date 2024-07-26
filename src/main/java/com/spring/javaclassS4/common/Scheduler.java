package com.spring.javaclassS4.common;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.spring.javaclassS4.dao.MemberDAO;

@Component
public class Scheduler {
	
	@Autowired
	MemberDAO memberDAO;
	
	@Scheduled(cron = "0 0 0/1 * * *")
	public void banScheduler() {
		memberDAO.unlockMember(3);
		memberDAO.unlockMember(7);
		memberDAO.unlockMember(30);
	}
}
