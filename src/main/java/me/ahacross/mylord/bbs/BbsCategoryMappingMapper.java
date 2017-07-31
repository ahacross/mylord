package me.ahacross.mylord.bbs;

import org.springframework.stereotype.Repository;

import me.ahacross.mylord.bbs.vo.BbsCategoryMapping;

@Repository(value="bbsCategoryMappingMapper")
public interface BbsCategoryMappingMapper {
	public int insert(BbsCategoryMapping bbsCategoryMapping); 
	public int delete(BbsCategoryMapping bbsCategoryMapping);
}
