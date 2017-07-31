package me.ahacross.mylord.bbs.category;

import java.util.List;
import java.util.Map;

import me.ahacross.mylord.bbs.vo.BbsCategory;

public interface BbsCategoryService {
	public List<Map<String, Object>> getList(BbsCategory bbsCategory);
	public int insert(BbsCategory bbsCategory);
	public int delete(BbsCategory bbsCategory);
}
