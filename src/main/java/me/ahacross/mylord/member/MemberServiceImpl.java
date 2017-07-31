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
		 MemberMapper memberMapper = session.getMapper(MemberMapper.class);
		return memberMapper.getList(member);
	}

	@Override
	public Map<String, Object> getOne(Member member) {
		MemberMapper memberMapper = session.getMapper(MemberMapper.class);
		return memberMapper.getOne(member);
	}

	@Override
	public int insert(Member member) {
		MemberMapper memberMapper = session.getMapper(MemberMapper.class);
		return memberMapper.insert(member);
	}

	@Override
	public int update(Member member) {
		MemberMapper memberMapper = session.getMapper(MemberMapper.class);
		return memberMapper.update(member);
	}

	@Override
	public int delete(Member member) {
		MemberMapper memberMapper = session.getMapper(MemberMapper.class);
		return memberMapper.delete(member);
	}
	
	@Override
	public Map<String, Object> login(Member member) {
		MemberMapper memberMapper = session.getMapper(MemberMapper.class);
		return memberMapper.login(member);
	}
}
