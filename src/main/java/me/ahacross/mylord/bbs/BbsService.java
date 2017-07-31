package me.ahacross.mylord.bbs;

import java.util.List;
import java.util.Map;

import me.ahacross.mylord.bbs.vo.Bbs;
import me.ahacross.mylord.bbs.vo.BbsFile;

public interface BbsService {
	public List<Map<String, Object>> getList(Bbs bbs) ;
	public Map<String, Object> getOne(Bbs bbs);
	public int insert(Map<String, Object> paramMap);
	public int update(Bbs bbs);
	public int update(Map<String, Object> paramMap);
	public int delete(Bbs bbs);
	public List<Map<String, Object>> getFileList(BbsFile bbsFile) ;
}
