package me.ahacross.mylord.bbs.category;

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

import me.ahacross.mylord.bbs.vo.BbsCategory;

/**
 * Handles requests for the application home page.
 */
@RestController
@RequestMapping("/bbs/category")
public class BbsCategoryController {	
	private static final Logger logger = LogManager.getLogger(BbsCategoryController.class);
	
	@Autowired
	BbsCategoryService bbsCategoryService;
		
	@ResponseBody
	@RequestMapping(method = RequestMethod.GET)	
	public Object getList(@ModelAttribute BbsCategory bbsCategory) {
		return bbsCategoryService.getList(bbsCategory);
	}
	
	
	@ResponseBody
	@RequestMapping(method = RequestMethod.POST)	
	public Map<String, Object> insert(@RequestBody BbsCategory bbsCategory) {
		System.out.println(bbsCategory.toString());
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "insert");
		resultMap.put("cnt", bbsCategoryService.insert(bbsCategory));
		return resultMap;
	}
	
	
	@ResponseBody
	@RequestMapping(method = RequestMethod.DELETE)	
	public Map<String, Object> delete(@RequestBody BbsCategory bbsCategory) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "delete");
		resultMap.put("cnt", bbsCategoryService.delete(bbsCategory));
		return resultMap;
	}

}
