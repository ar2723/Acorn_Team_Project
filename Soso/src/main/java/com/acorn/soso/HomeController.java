package com.acorn.soso;

import jakarta.servlet.http.HttpServletRequest;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.acorn.soso.group.service.GroupService;

@Slf4j
@Controller
public class HomeController {
	@Autowired
	private GroupService service;	
	
	@GetMapping("/")
	public String home(HttpServletRequest request) {
		return "redirect:/main";
	}
	
	@GetMapping("/main")
	public String view(HttpServletRequest request, Model model) {
		log.info("view");
		service.getViewList(request, model);
		return "main";
	}
	
}
