package me.ahacross.mylord.dues;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("memberDuesService")
public class MemberDuesServiceImpl implements MemberDuesService{
	@Autowired 
	SqlSessionTemplate session; 
	 
	 @Override
	 public List<Map<String, Object>> getList(MemberDues memberDues) throws Exception{
		 MemberDuesMapper mapper = session.getMapper(MemberDuesMapper.class);
		return mapper.getList(memberDues);
	}

	@Override
	public Map<String, Object> getOne(MemberDues memberDues) throws Exception{
		MemberDuesMapper mapper = session.getMapper(MemberDuesMapper.class);
		return mapper.getOne(memberDues);
	}

	@Override
	public int insert(MemberDues memberDues) throws Exception{
		MemberDuesMapper mapper = session.getMapper(MemberDuesMapper.class);
		return mapper.insert(memberDues);
	}

	@Override
	public int delete(MemberDues memberDues) throws Exception{
		MemberDuesMapper mapper = session.getMapper(MemberDuesMapper.class);
		return mapper.delete(memberDues);
	}
}
