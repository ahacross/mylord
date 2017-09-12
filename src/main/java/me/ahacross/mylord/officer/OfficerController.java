package me.ahacross.mylord.officer;

import java.util.HashMap;
import java.util.List;
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
@RequestMapping("/officer")
public class OfficerController {	
	private static final Logger logger = LogManager.getLogger(OfficerController.class);
	
	@Autowired
	OfficerService officerService;
	
	@ResponseBody
	@RequestMapping(method = RequestMethod.GET)	
	public Object getMembers(@ModelAttribute Officer member) {
		List<Map<String, Object>> members = officerService.getList(member);
		return members;
	}
	
	@ResponseBody
	@RequestMapping(value="{id}", method = RequestMethod.GET)	
	public Object getMember(@PathVariable Integer id) {
		Officer member = new Officer();
		member.setMember_id(id);
		return officerService.getOne(member);
	}
	
	@ResponseBody
	@RequestMapping(method = RequestMethod.POST)	
	public Map<String, Object> postMember(@RequestBody Officer member) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "insert");
		resultMap.put("cnt", officerService.insert(member));
		return resultMap;
	}
	
	
	@ResponseBody
	@RequestMapping(value="{id}", method = RequestMethod.PUT)	
	public Map<String, Object> putMember(@PathVariable Integer id, @RequestBody Officer member) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "update");
		resultMap.put("cnt", officerService.update(member));
		return resultMap;
	}
	
	@ResponseBody
	@RequestMapping(value="{id}", method = RequestMethod.DELETE)	
	public Map<String, Object> deleteMember(@PathVariable Integer id, @RequestBody Officer member) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "delete");
		resultMap.put("cnt", officerService.delete(member));
		return resultMap;
	}
}
