package me.ahacross.mylord.officer;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("officerService")
public class OfficerServiceImpl implements OfficerService{
	@Autowired 
	SqlSessionTemplate session; 
	 
	 @Override
	 public List<Map<String, Object>> getList(Officer officer){
		 OfficerMapper mapper = session.getMapper(OfficerMapper.class);
		return mapper.getList(officer);
	}

	@Override
	public Map<String, Object> getOne(Officer officer) {
		OfficerMapper mapper = session.getMapper(OfficerMapper.class);
		return mapper.getOne(officer);
	}

	@Override
	public int insert(Officer officer) {
		OfficerMapper mapper = session.getMapper(OfficerMapper.class);
		return mapper.insert(officer);
	}

	@Override
	public int update(Officer officer) {
		OfficerMapper mapper = session.getMapper(OfficerMapper.class);
		return mapper.update(officer);
	}

	@Override
	public int delete(Officer officer) {
		OfficerMapper mapper = session.getMapper(OfficerMapper.class);
		return mapper.delete(officer);
	}
}
