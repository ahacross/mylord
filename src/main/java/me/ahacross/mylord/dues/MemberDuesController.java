package me.ahacross.mylord.dues;

import java.util.ArrayList;
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

import me.ahacross.mylord.enrollment.MemberEnrollment;

/**
 * Handles requests for the application home page.
 */
@RestController
@RequestMapping("/dues")
public class MemberDuesController {	
	private static final Logger logger = LogManager.getLogger(MemberDuesController.class);
	
	@Autowired
	MemberDuesService memberDeusService;
		
	@ResponseBody
	@RequestMapping(method = RequestMethod.GET)	
	public Object getMembers(@ModelAttribute MemberDues memberDues) throws Exception{
		return memberDeusService.getList(memberDues);
	}
	
	@ResponseBody
	@RequestMapping(value="{id}", method = RequestMethod.GET)	
	public Object getMember(@PathVariable Integer id) throws Exception{
		MemberDues memberDues = new MemberDues();
		memberDues.setMember_id(id);
		return memberDeusService.getOne(memberDues);
	}
	
	@ResponseBody
	@RequestMapping(method = RequestMethod.POST)	
	public Object post(@RequestBody MemberDues memberDues) throws Exception{
		return memberDeusService.insert(memberDues);
	}
	
	@ResponseBody
	@RequestMapping(value="{id}", method = RequestMethod.DELETE)	
	public Map<String, Object> deleteMember(@PathVariable Integer id) throws Exception{
		MemberDues memberDues = new MemberDues();
		memberDues.setMember_id(id);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "delete");
		resultMap.put("cnt", memberDeusService.delete(memberDues));
		return resultMap;
	}
}
