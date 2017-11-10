package me.ahacross.mylord.dues;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value="memberDuesMapper")
public interface MemberDuesMapper {
	public List<Map<String, Object>> getList(MemberDues memberDues) throws Exception;
	public Map<String, Object> getOne(MemberDues memberDues) throws Exception;
	public int insert(MemberDues memberDues) throws Exception;
	public int delete(MemberDues memberDues) throws Exception;
}
