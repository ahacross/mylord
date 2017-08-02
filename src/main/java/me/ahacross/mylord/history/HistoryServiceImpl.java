package me.ahacross.mylord.history;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("historyService")
public class HistoryServiceImpl implements HistoryService{
	@Autowired 
	SqlSessionTemplate session; 
	 
	 @Override
	 public List<Map<String, Object>> getList(History history){
		 HistoryMapper mapper = session.getMapper(HistoryMapper.class);
		return mapper.getList(history);
	}

	@Override
	public Map<String, Object> getOne(History history) {
		HistoryMapper mapper = session.getMapper(HistoryMapper.class);
		return mapper.getOne(history);
	}

	@Override
	public int insert(History history) {
		HistoryMapper mapper = session.getMapper(HistoryMapper.class);
		return mapper.insert(history);
	}

	@Override
	public int update(History history) {
		HistoryMapper mapper = session.getMapper(HistoryMapper.class);
		return mapper.update(history);
	}

	@Override
	public int delete(History history) {
		HistoryMapper mapper = session.getMapper(HistoryMapper.class);
		return mapper.delete(history);
	}
}
