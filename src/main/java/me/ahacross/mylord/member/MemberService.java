package me.ahacross.mylord.member;

import java.util.List;
import java.util.Map;

public interface MemberService {
	public List<Map<String, Object>> getList(Member member) throws Exception;
	public Map<String, Object> getOne(Member member) throws Exception;
	public int insert(Member member) throws Exception;
	public int update(Member member) throws Exception;
	public int delete(Member member) throws Exception;
}
