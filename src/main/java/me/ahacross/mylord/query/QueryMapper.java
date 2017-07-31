package me.ahacross.mylord.query;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value="queryMapper")
public interface QueryMapper {
	public List<Map<String, Object>> getList(Query query) ;	
}
