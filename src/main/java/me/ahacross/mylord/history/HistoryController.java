package me.ahacross.mylord.history;

import java.util.HashMap;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

/**
 * Handles requests for the application home page.
 */
@RestController
@RequestMapping("/history")
public class HistoryController {	
	private static final Logger logger = LogManager.getLogger(HistoryController.class);
	
	@Autowired
	HistoryService historyService;
		
	
	
	@ResponseBody
	@RequestMapping(method = RequestMethod.GET)	
	public Object getMembers(@ModelAttribute History history) {
		return historyService.getList(history);
	}
	
	@ResponseBody
	@RequestMapping(method = RequestMethod.POST)	
	public Map<String, Object> postMember(@RequestBody History history) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "insert");
		resultMap.put("cnt", historyService.insert(history));
		return resultMap;
	}
	
	
	@ResponseBody
	@RequestMapping(value="{id}", method = RequestMethod.PUT)	
	public Map<String, Object> putMember(@PathVariable Integer id, @RequestBody History history) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "update");
		resultMap.put("cnt", historyService.update(history));
		return resultMap;
	}
	
	@ResponseBody
	@RequestMapping(value="{id}", method = RequestMethod.DELETE)	
	public Map<String, Object> deleteMember(@RequestBody History history) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "delete");
		resultMap.put("cnt", historyService.delete(history));
		return resultMap;
	}
}
