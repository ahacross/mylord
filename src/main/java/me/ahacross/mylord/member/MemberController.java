package me.ahacross.mylord.member;

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

/**
 * Handles requests for the application home page.
 */
@RestController
@RequestMapping("/member")
public class MemberController {	
	private static final Logger logger = LogManager.getLogger(MemberController.class);
	
	@Autowired
	MemberService memberService;
		
	
	@FunctionalInterface
	public interface Predicate<T> {
		boolean test(T t);
	}
	
	public <T> List<T> filter(List<T> list, Predicate<T> p){
		List<T> results = new ArrayList<>();
		for(T s : list){
			if(p.test(s)){
				results.add(s);	
			}
		}
		return results;
	}
	
	@FunctionalInterface
	public interface Cunsumer<T> {
		void accept(T t);
	}
	
	public <T> void forEach(List<T> list, Cunsumer<T> c) {
		for(T i : list) {
			c.accept(i);
		}
	}
	
	@ResponseBody
	@RequestMapping(method = RequestMethod.GET)	
	public Object getMembers(@ModelAttribute Member member) throws Exception{
		List<Map<String, Object>> members = memberService.getList(member);
		Object returnValue = null;
		
		if(member.getType() == null && member.getPart() != null && !member.getPart().equals("all")){
			if(member.getPart().equals("e")){
				returnValue = filter(members, (Map<String, Object> m) ->  !(m.get("part").equals("s") || m.get("part").equals("a") || m.get("part").equals("t") || m.get("part").equals("b")));
			}else{
				returnValue = filter(members, (Map<String, Object> m) -> m.get("part").equals(member.getPart()));	
			}
		}else{
			returnValue = members;
		}
		
		return returnValue;
	}
	
	@ResponseBody
	@RequestMapping(value="{id}", method = RequestMethod.GET)	
	public Object getMember(@PathVariable Integer id) throws Exception{
		Member member = new Member();
		member.setMember_id(id);
		return memberService.getOne(member);
	}
	
	@ResponseBody
	@RequestMapping(method = RequestMethod.POST)	
	public Map<String, Object> postMember(@RequestBody Member member) throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "insert");
		resultMap.put("cnt", memberService.insert(member));
		return resultMap;
	}
	
	
	@ResponseBody
	@RequestMapping(value="{id}", method = RequestMethod.PUT)	
	public Map<String, Object> putMember(@PathVariable Integer id, @RequestBody Member member) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "update");
		resultMap.put("cnt", memberService.update(member));
		return resultMap;
	}
	
	@ResponseBody
	@RequestMapping(value="{id}", method = RequestMethod.DELETE)	
	public Map<String, Object> deleteMember(@PathVariable Integer id) throws Exception{
		Member member = new Member();
		member.setMember_id(id);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "delete");
		resultMap.put("cnt", memberService.delete(member));
		return resultMap;
	}
}
