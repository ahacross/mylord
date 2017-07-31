package me.ahacross.mylord.bbs;

import org.springframework.stereotype.Repository;

import me.ahacross.mylord.bbs.vo.BbsTreepath;

@Repository(value="bbsTreepathMapper")
public interface BbsTreepathMapper {
	public int insert(BbsTreepath bbsTreepath);
	public int delete(BbsTreepath bbsTreepath); 
}
