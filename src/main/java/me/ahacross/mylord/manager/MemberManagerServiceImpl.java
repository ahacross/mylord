package me.ahacross.mylord.manager;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("memberManagerService")
public class MemberManagerServiceImpl implements MemberManagerService{
	@Autowired 
	SqlSessionTemplate session;
	
	@Override
	public int insert(MemberManager memberManager) {
		MemberManagerMapper mapper = session.getMapper(MemberManagerMapper.class);
		return mapper.insert(memberManager);
	}
}
