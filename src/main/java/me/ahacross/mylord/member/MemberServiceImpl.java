package me.ahacross.mylord.member;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("memberService")
public class MemberServiceImpl implements MemberService{
	@Autowired 
	SqlSessionTemplate session; 
	 
	 @Override
	 public List<Map<String, Object>> getList(Member member){
		 MemberMapper mapper = session.getMapper(MemberMapper.class);
		return mapper.getList(member);
	}

	@Override
	public Map<String, Object> getOne(Member member) {
		MemberMapper mapper = session.getMapper(MemberMapper.class);
		return mapper.getOne(member);
	}

	@Override
	public int insert(Member member) {
		MemberMapper mapper = session.getMapper(MemberMapper.class);
		return mapper.insert(member);
	}

	@Override
	public int update(Member member) {
		MemberMapper mapper = session.getMapper(MemberMapper.class);
		return mapper.update(member);
	}

	@Override
	public int delete(Member member) {
		MemberMapper mapper = session.getMapper(MemberMapper.class);
		return mapper.delete(member);
	}
}
