package me.ahacross.mylord.bbs.reply;

import java.util.HashMap;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import me.ahacross.mylord.bbs.vo.BbsReply;

/**
 * Handles requests for the application home page.
 */
@RestController
@RequestMapping("/bbs/reply")
public class BbsReplyController {	
	private static final Logger logger = LogManager.getLogger(BbsReplyController.class);
	
	@Autowired
	BbsReplyService bbsReplyService;
		
	@ResponseBody
	@RequestMapping(method = RequestMethod.GET)	
	public Map<String, Object> getList(@ModelAttribute BbsReply bbsReply) {
		Map<String, Object> resultMap = new HashMap<String, Object>(); //
		resultMap.put("list", bbsReplyService.getList(bbsReply));
		return resultMap;
	}
	
	
	@ResponseBody
	@RequestMapping(method = RequestMethod.POST)	
	public Map<String, Object> insert(@RequestBody BbsReply bbsReply) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "insert");
		resultMap.put("cnt", bbsReplyService.insert(bbsReply));
		return resultMap;
	}
	
	@ResponseBody
	@RequestMapping(method = RequestMethod.PUT)	
	public Map<String, Object> update(@RequestBody BbsReply bbsReply) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "update");
		resultMap.put("cnt", bbsReplyService.update(bbsReply));
		return resultMap;
	}
	
	@ResponseBody
	@RequestMapping(method = RequestMethod.DELETE)	
	public Map<String, Object> delete(@RequestBody BbsReply bbsReply) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "delete");
		
		if(bbsReply.getSeq() == null){
			resultMap.put("cnt", bbsReplyService.deleteByBbsId(bbsReply));
		}else{
			resultMap.put("cnt", bbsReplyService.delete(bbsReply));	
		}
		
		return resultMap;
	}

}
