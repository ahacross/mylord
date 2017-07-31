package me.ahacross.mylord.bbs.category;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import me.ahacross.mylord.bbs.vo.BbsCategory;

@Service("bbsCategoryService")
public class BbsCategoryServiceImpl implements BbsCategoryService{
	@Autowired 
	SqlSessionTemplate session; 
	 
	 @Override
	 public List<Map<String, Object>> getList(BbsCategory bbsCategory){
		 BbsCategoryMapper mapper = session.getMapper(BbsCategoryMapper.class);
		 return mapper.getList(bbsCategory);
	}

	@Override
	public int insert(BbsCategory bbsCategory) {
		BbsCategoryMapper mapper = session.getMapper(BbsCategoryMapper.class);
		return mapper.insert(bbsCategory);
	}

	@Override
	public int delete(BbsCategory bbsCategory) {
		BbsCategoryMapper mapper = session.getMapper(BbsCategoryMapper.class);
		return mapper.delete(bbsCategory);
	}

}
