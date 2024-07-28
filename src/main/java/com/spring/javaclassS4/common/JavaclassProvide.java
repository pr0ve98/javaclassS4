package com.spring.javaclassS4.common;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Calendar;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

@Service
public class JavaclassProvide {
	
	@Autowired
	JavaMailSender mailSender;

	// urlPath에 파일 저장하는 메소드 : (업로드파일명, 저장할파일명, 저장할경로)
	public void writeFile(MultipartFile fName, String sFileName, String urlPath) throws IOException {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/"+urlPath+"/");
		
		FileOutputStream fos = new FileOutputStream(realPath + sFileName);
		
		if(fName.getBytes().length != -1) {
			fos.write(fName.getBytes());
		}
		fos.flush();
		fos.close();
	}
	
	public void deleteFile(String photo, String urlPath) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/"+urlPath+"/");
		
		File file = new File(realPath + photo);
		if(file.exists()) file.delete();
	}

	// 파일 이름 변경하기(중복 방지를 위한 작업)
	public String saveFileName(String oFileName) {
		String fileName = "";
		
		Calendar cal = Calendar.getInstance();
		fileName += cal.get(Calendar.YEAR);
		fileName += cal.get(Calendar.MONTH)+1;
		fileName += cal.get(Calendar.DATE);
		fileName += cal.get(Calendar.HOUR_OF_DAY);
		fileName += cal.get(Calendar.MINUTE);
		fileName += cal.get(Calendar.SECOND);
		fileName += cal.get(Calendar.MILLISECOND);
		fileName += "_" + oFileName;
		
		return fileName;
	}
	
	// 메일 전송
	public String mailSend(String email, String title, String subtitle, String text) throws MessagingException {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		String content = "";
		
		// 메일 전송을 위한 객체: MimeMessage(), MimeMessageHelper()
		MimeMessage message = mailSender.createMimeMessage();
		MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
		
		// 메일 보관함에 작성한 메세지들의 정보를 모두 저장시킨후 작업처리
		messageHelper.setTo(email); // 받는 사람 메일주소
		messageHelper.setSubject(title); // 메일 제목
		messageHelper.setText(content); // 메일 내용
		
		// 메세지 보관함의 내용(content)에, 발신자의 필요한 정보를 추가로 담아서 전송처리한다.
		content = content.replace("\n", "<br>");
        content += "<body style=\"margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #32373d; color: #b2bdce;\">"
                + "<table role=\"presentation\" style=\"width: 100%; max-width: 600px; margin: 0 auto; border-collapse: collapse; background-color: #32373d;\">"
                + "<tr>"
                + "<td style=\"padding: 20px;\">"
                + "<img src=\"cid:logo.png\" alt=\"로고\" style=\"height: 50px;\">"
                + "</td>"
                + "</tr>"
                + "<tr>"
                + "<td style=\"background-color: #3a3f45; padding: 50px 20px; text-align: center; color: #b2bdce;\">"
                + "<h2 style=\"color: #00c722; margin-top: 0;\">"+subtitle+"</h2>"
                + "<p style=\"margin: 0; margin-top: 10px;\">"+text+"</p>"
                + "</td>"
                + "</tr>"
                + "<tr>"
                + "<td style=\"background-color: #3a3f45; text-align: center; padding: 50px 20px; color: #b2bdce;\">"
                + "<p style=\"margin: 0;\"><a href=\"http://192.168.0.15:9090/javaclassS4/\" style=\"display: inline-block; border-radius: 15px; padding: 5px 10px; background-color: #00c722; color: #fff; border: 1px solid #00c722; min-width: 120px; text-align: center; text-decoration: none;\">인겜토리로 이동하기</a></p>"
                + "</td>"
                + "</tr>"
                + "</table>"
                + "</body>";
		messageHelper.setText(content, true); // 기존거 무시하고 새로 갈기
		
		// 본문에 기재될 그림파일의 경로를 별도로 표시시켜준다. 그런 후 다시 보관함에 저장한다.
		//FileSystemResource file = new FileSystemResource("D:\\javaclass\\springframework\\works\\javaclassS\\src\\main\\webapp\\resources\\images\\la.jpg");
		
		// cid:에 넣을 그림 생성
		//request.getSession().getServletContext().getRealPath("/resources/images/la.jpg");
		FileSystemResource file = new FileSystemResource(request.getSession().getServletContext().getRealPath("/resources/images/logo.png"));
		messageHelper.addInline("logo.png", file);
		
		// 메일 전송하기
		mailSender.send(message);
		
		return "1";
	}
}
