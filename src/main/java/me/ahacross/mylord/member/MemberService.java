package me.ahacross.mylord.member;

import java.util.List;
import java.util.Map;

public interface MemberService {
	public List<Map<String, Object>> getList(Member member);
	public Map<String, Object> getOne(Member member) ;
	public int insert(Member member);
	public int update(Member member);
	public int delete(Member member);
}
