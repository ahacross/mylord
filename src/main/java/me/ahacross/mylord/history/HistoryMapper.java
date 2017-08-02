package me.ahacross.mylord.history;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value="historyMapper")
public interface HistoryMapper {
	public List<Map<String, Object>> getList(History history) ;
	public Map<String, Object> getOne(History history) ;
	public int insert(History history);
	public int update(History history);
	public int delete(History history);
}
