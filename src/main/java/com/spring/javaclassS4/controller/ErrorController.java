package com.spring.javaclassS4.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/errorPage")
public class ErrorController {

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String error404Get() {
		return "errorPage/error";
	}

}
