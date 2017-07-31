package me.ahacross.mylord.bbs;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import me.ahacross.mylord.bbs.vo.BbsFile;

@Repository(value="bbsFileMapper")
public interface BbsFileMapper {
	public List<Map<String, Object>> getList(BbsFile bbsFile);
	public int insert(BbsFile bbsFile);
	public int delete(BbsFile bbsFile);
}
