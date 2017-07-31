package me.ahacross.mylord.bbs.category;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import me.ahacross.mylord.bbs.vo.BbsCategory;

@Repository(value="bbsCategoryMapper")
public interface BbsCategoryMapper {
	public List<Map<String, Object>> getList(BbsCategory bbsCategory);
	public int insert(BbsCategory bbsCategory);
	public int delete(BbsCategory bbsCategory);
}
