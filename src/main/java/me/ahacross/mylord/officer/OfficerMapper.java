package me.ahacross.mylord.officer;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

@Repository(value="officerMapper")
public interface OfficerMapper {
	public List<Map<String, Object>> getList(Officer officer) ;
	public Map<String, Object> getOne(Officer officer) ;
	public int insert(Officer officer);
	public int update(Officer officer);
	public int delete(Officer officer);
}
