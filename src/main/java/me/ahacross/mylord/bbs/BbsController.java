package me.ahacross.mylord.bbs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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

import me.ahacross.mylord.bbs.vo.Bbs;
import me.ahacross.mylord.bbs.vo.BbsFile;

/**
 * Handles requests for the application home page.
 */
@RestController
@RequestMapping("/bbs")
public class BbsController {	
	private static final Logger logger = LogManager.getLogger(BbsController.class);
	
	@Autowired
	BbsService bbsService;
		
	
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
	public Object getList(@ModelAttribute Bbs bbs) {
		return bbsService.getList(bbs);
	}
	
	
	@ResponseBody
	@RequestMapping(value="{id}", method = RequestMethod.GET)	
	public Object getOne(@ModelAttribute Bbs bbs) {
		return bbsService.getOne(bbs);
	}
	
	@ResponseBody
	@RequestMapping(method = RequestMethod.POST)	
	public Map<String, Object> post(@RequestBody Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "insert");
		resultMap.put("cnt", bbsService.insert(paramMap));
		return resultMap;
	}
	
	@ResponseBody
	@RequestMapping(value="{id}/count", method = RequestMethod.PUT)	
	public Map<String, Object> put(@RequestBody Bbs bbs) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "update");
		resultMap.put("cnt", bbsService.update(bbs));
		return resultMap;
	}
	
	
	@ResponseBody
	@RequestMapping(value="{id}", method = RequestMethod.PUT)	
	public Map<String, Object> put(@RequestBody Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "update");
		resultMap.put("cnt", bbsService.update(paramMap));
		return resultMap;
	}
	
	@ResponseBody
	@RequestMapping(value="{id}", method = RequestMethod.DELETE)	
	public Map<String, Object> delete(@RequestBody Bbs bbs) { 
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("type", "delete");
		resultMap.put("cnt", bbsService.delete(bbs));
		return resultMap;
	}

	@ResponseBody
	@RequestMapping(value="files", method = RequestMethod.GET)	
	public Map<String, Object> getFileList(@ModelAttribute BbsFile bbsFile) {		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("list", bbsService.getFileList(bbsFile));
		return resultMap;
	}
}
