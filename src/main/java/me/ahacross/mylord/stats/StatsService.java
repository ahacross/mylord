package me.ahacross.mylord.stats;

import java.util.List;
import java.util.Map;

public interface StatsService {
	public List<Map<String, Object>> getPart(Stats stats) ;
	public List<Map<String, Object>> getOne(Stats stats) ;	
}
