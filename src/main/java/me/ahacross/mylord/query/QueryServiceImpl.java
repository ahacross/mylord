package me.ahacross.mylord.query;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("queryService")
public class QueryServiceImpl implements QueryService{
	@Autowired 
	SqlSessionTemplate session; 
	 
	 @Override
	 public List<Map<String, Object>> getList(Query query){
		 QueryMapper mapper = session.getMapper(QueryMapper.class);
		 return mapper.getList(query);
	}
}
