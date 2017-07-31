package me.ahacross.mylord.query;

import java.util.List;
import java.util.Map;

public interface QueryService {
	public List<Map<String, Object>> getList(Query query) ;
}
