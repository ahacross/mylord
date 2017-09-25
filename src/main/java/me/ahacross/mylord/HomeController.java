package me.ahacross.mylord;

import java.util.Locale;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	private static final Logger logger = LogManager.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)	
	public String home(Locale locale, Model model) {
		return "home";
	}
	
	@RequestMapping(value = "/file", method = RequestMethod.GET)	
	public String file() {
		return "file";
	}
	
	@RequestMapping(value = "/query", method=RequestMethod.GET)	
	public String query() {
		return "query";
	}
	
	@RequestMapping(value = "/shopping", method=RequestMethod.GET)	
	public String shopping() {
		return "shopping";
	}
}
