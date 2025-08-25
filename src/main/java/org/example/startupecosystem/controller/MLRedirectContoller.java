package org.example.startupecosystem.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MLRedirectContoller {

	  @GetMapping("/ml")
	    public String redirectML() {
	        return "redirect:http://localhost:5000/app"; 
	    }
}
