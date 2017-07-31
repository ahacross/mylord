package me.ahacross.mylord.stats;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("statsService")
public class StatsServiceImpl implements StatsService{
	@Autowired 
	SqlSessionTemplate session; 
	 
	@Override
	public List<Map<String, Object>> getPart(Stats stats) {
		StatsMapper mapper = session.getMapper(StatsMapper.class);
		return mapper.getPart(stats);
	}

	@Override
	public List<Map<String, Object>> getOne(Stats stats) {
		StatsMapper mapper = session.getMapper(StatsMapper.class);
		return mapper.getOne(stats);
	}
}
