package me.ahacross.mylord.query;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

/**
 * Handles requests for the application home page.
 */
@RestController
public class QueryController {	
	private static final Logger logger = LogManager.getLogger(QueryController.class);
	
	@Autowired
	QueryService queryService;
		
	@ResponseBody
	@RequestMapping(value="query", method = RequestMethod.POST)	
	public Object postQuery(@RequestBody Query query) {
		return queryService.getList(query);
	}
	

}
