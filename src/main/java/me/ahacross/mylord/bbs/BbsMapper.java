package me.ahacross.mylord.bbs;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import me.ahacross.mylord.bbs.vo.Bbs;

@Repository(value="bbsMapper")
public interface BbsMapper { 
	public List<Map<String, Object>> getList(Bbs bbs) ;
	public Map<String, Object> getOne(Bbs bbs);
	public int insert(Bbs bbs);
	public int update(Bbs bbs);
	public int delete(Bbs bbs);
}
