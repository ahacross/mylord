package me.ahacross.mylord.stats;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

/**
 * Handles requests for the application home page.
 */
@RequestMapping("/stats")
@RestController
public class StatsController {	
	private static final Logger logger = LogManager.getLogger(StatsController.class);
	
	@Autowired
	StatsService statsService;
		
	@ResponseBody
	@RequestMapping(method = RequestMethod.GET)	
	public Object getList(@ModelAttribute Stats stats) {
		Object returnObj = null;
		
		int checkDate = 20161225;
		if(stats.getStartDate() != null && stats.getStartDate().equals("") && stats.getEndDate() != null && stats.getEndDate().equals("")) {
			if(Integer.parseInt(stats.getStartDate()) <= checkDate && Integer.parseInt(stats.getEndDate()) >= checkDate) {
				String tempCond = stats.getAfterCheckCond();
				tempCond = "|| (before_check='Y' and attendance_date='20161225') " + tempCond;
				stats.setAfterCheckCond(tempCond);
			}	
		}
		
		if(stats.getType().equals("part")){
			returnObj = statsService.getPart(stats);
		}else {
			returnObj = statsService.getOne(stats);
		}
		
		return returnObj;
	}
}