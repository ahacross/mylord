package me.ahacross.mylord.history;

import java.util.List;
import java.util.Map;

public interface HistoryService {
	public List<Map<String, Object>> getList(History history);
	public Map<String, Object> getOne(History history) ;
	public int insert(History history);
	public int update(History history);
	public int delete(History history);
}
