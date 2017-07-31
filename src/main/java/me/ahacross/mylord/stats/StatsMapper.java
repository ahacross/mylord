package me.ahacross.mylord.stats;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value="queryMapper")
public interface StatsMapper {
	public List<Map<String, Object>> getPart(Stats stats) ;
	public List<Map<String, Object>> getOne(Stats stats) ;	
}
