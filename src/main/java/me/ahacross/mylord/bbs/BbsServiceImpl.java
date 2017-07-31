package me.ahacross.mylord.bbs;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import me.ahacross.mylord.bbs.reply.BbsReplyMapper;
import me.ahacross.mylord.bbs.vo.Bbs;
import me.ahacross.mylord.bbs.vo.BbsCategoryMapping;
import me.ahacross.mylord.bbs.vo.BbsFile;
import me.ahacross.mylord.bbs.vo.BbsReply;
import me.ahacross.mylord.bbs.vo.BbsTreepath;
import me.ahacross.mylord.file.FilePath;
import me.ahacross.mylord.util.MapToVo;

@Service("bbsService")
public class BbsServiceImpl implements BbsService{
	@Autowired 
	SqlSessionTemplate session; 
	 
	 @Override
	 public List<Map<String, Object>> getList(Bbs bbs){
		 BbsMapper mapper = session.getMapper(BbsMapper.class);
		return mapper.getList(bbs);
	}

	@Override
	public Map<String, Object> getOne(Bbs bbs) {
		BbsMapper mapper = session.getMapper(BbsMapper.class);
		return mapper.getOne(bbs);
	}

	private BbsTreepath setTreepath(String temp_p_bbs_id, Integer bbs_id) {
		BbsTreepath bbsTreepath = new BbsTreepath();
	    Integer p_bbs_id;
	    if (StringUtils.hasLength(temp_p_bbs_id)) {
	    	p_bbs_id = Integer.getInteger(temp_p_bbs_id);
	    } else {
	    	p_bbs_id = bbs_id;
	    }
	    bbsTreepath.setP_bbs_id(p_bbs_id);
	    bbsTreepath.setBbs_id(bbs_id);
	    return bbsTreepath;
	}
	  
	@Override
	@SuppressWarnings("unchecked")
	public int insert(Map<String, Object> paramMap) {
		int insertCnt = 0;
		BbsMapper bbsMapper = (BbsMapper)this.session.getMapper(BbsMapper.class);
	    Bbs bbs = (Bbs)new MapToVo().getObject(paramMap, Bbs.class);
	    System.out.println(bbs.toString());
	    insertCnt = bbsMapper.insert(bbs);
	    Integer bbs_id = bbs.getBbs_id();
	    
	    BbsTreepathMapper bbsTreepathMapper = (BbsTreepathMapper)this.session.getMapper(BbsTreepathMapper.class);
	    BbsTreepath bbsTreepath = setTreepath(bbs.getP_bbs_id(), bbs_id);
	    bbsTreepathMapper.insert(bbsTreepath);
	    
	    BbsFileMapper bbsFileMapper = this.session.getMapper(BbsFileMapper.class);
		List<BbsFile> bbsFileList = (List<BbsFile>)new MapToVo().getList(paramMap, BbsFile.class, "fileInfos");
	    if(bbsFileList.size() > 0){
	    	for(int i=0, n=bbsFileList.size(); i<n; i++){
	    		BbsFile tempBbsFile = bbsFileList.get(i);
	    		tempBbsFile.setBbs_id(bbs_id);
	    		bbsFileMapper.insert(tempBbsFile);
	    	}	    	
	    }
	    
	    BbsCategoryMappingMapper bbsCategoryMappingMapper = this.session.getMapper(BbsCategoryMappingMapper.class);
	    //BbsCategoryMapping bbsCategoryMapping = (BbsCategoryMapping)new MapToVo().getObject(paramMap, BbsCategoryMapping.class);
	    
	    List<BbsCategoryMapping> bbsCategoryMappingList = (List<BbsCategoryMapping>)new MapToVo().getList(paramMap, BbsCategoryMapping.class, "categorys");
	    
	    for(int i=0, n=bbsCategoryMappingList.size(); i<n; i++){
	    	BbsCategoryMapping tempBbsCategoryMapping = bbsCategoryMappingList.get(i); 
	    	tempBbsCategoryMapping.setBbs_id(bbs_id);
	    	bbsCategoryMappingMapper.insert(tempBbsCategoryMapping);
	    }
	    
	    return insertCnt;
	}
	
	@Override
	public int update(Bbs bbs){
		BbsMapper bbsMapper = (BbsMapper)this.session.getMapper(BbsMapper.class);
		return bbsMapper.update(bbs);
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public int update(Map<String, Object> paramMap) {
		int updateCnt = 0;
		BbsMapper bbsMapper = (BbsMapper)this.session.getMapper(BbsMapper.class);
	    Bbs bbs = (Bbs)new MapToVo().getObject(paramMap, Bbs.class);
	    updateCnt = bbsMapper.update(bbs);	    
	    
	    
	    Integer bbs_id = bbs.getBbs_id();
	    BbsFileMapper bbsFileMapper = this.session.getMapper(BbsFileMapper.class);
	    BbsFile bbsFile = new BbsFile();
	    bbsFile.setBbs_id(bbs_id);;
	    bbsFileMapper.delete(bbsFile);
	    
		List<BbsFile> bbsFileList = (List<BbsFile>)new MapToVo().getList(paramMap, BbsFile.class, "fileInfos");
	    if(bbsFileList.size() > 0){
	    	for(int i=0, n=bbsFileList.size(); i<n; i++){
	    		BbsFile tempBbsFile = bbsFileList.get(i);
	    		tempBbsFile.setBbs_id(bbs_id);
	    		bbsFileMapper.insert(tempBbsFile);
	    	}	    	
	    }
	    
	    BbsCategoryMappingMapper bbsCategoryMappingMapper = this.session.getMapper(BbsCategoryMappingMapper.class);
	    BbsCategoryMapping bbsCategoryMapping = new BbsCategoryMapping();
	    bbsCategoryMapping.setBbs_id(bbs_id);
	    bbsCategoryMappingMapper.delete(bbsCategoryMapping);
	    
	    List<BbsCategoryMapping> bbsCategoryMappingList = (List<BbsCategoryMapping>)new MapToVo().getList(paramMap, BbsCategoryMapping.class, "categorys");
	    for(int i=0, n=bbsCategoryMappingList.size(); i<n; i++){
	    	BbsCategoryMapping tempBbsCategoryMapping = bbsCategoryMappingList.get(i); 
	    	tempBbsCategoryMapping.setBbs_id(bbs_id);
	    	bbsCategoryMappingMapper.insert(tempBbsCategoryMapping);
	    }
	    
	    return updateCnt;
	}

	@Override
	public int delete(Bbs bbs) {
		//리플삭제.
		BbsReplyMapper bbsReplyMapper = this.session.getMapper(BbsReplyMapper.class);
		BbsReply bbsReply = new BbsReply();
		bbsReply.setBbs_id(bbs.getBbs_id());
		bbsReplyMapper.deleteByBbsId(bbsReply);
		
		// 카테고리 매핑정보 삭제
		BbsCategoryMappingMapper bbsCategoryMappingMapper = this.session.getMapper(BbsCategoryMappingMapper.class);
		BbsCategoryMapping bbsCategoryMapping = new BbsCategoryMapping();
		bbsCategoryMapping.setBbs_id(bbs.getBbs_id());		
		bbsCategoryMappingMapper.delete(bbsCategoryMapping);
		
		// 게시글 매핑정보 삭제
		BbsTreepathMapper bbsTreepathMapper = (BbsTreepathMapper)this.session.getMapper(BbsTreepathMapper.class);
		BbsTreepath bbsTreepath = new BbsTreepath();
		bbsTreepath.setBbs_id(bbs.getBbs_id());
		bbsTreepathMapper.delete(bbsTreepath);
		
		// 게시글 파일 삭제
		String uploadLocation = new FilePath().getUploadLocation();
		BbsFileMapper bbsFileMapper = this.session.getMapper(BbsFileMapper.class);
		BbsFile bbsFile = new BbsFile();
		bbsFile.setBbs_id(bbs.getBbs_id());
		
		List<Map<String, Object>> fileList= bbsFileMapper.getList(bbsFile);
		if(fileList.size() > 0){
			fileList.forEach(map -> new File(uploadLocation+map.get("mask_name")).delete());
			bbsFileMapper.delete(bbsFile);	
		}
		
		// 게시글 삭제
		BbsMapper mapper = session.getMapper(BbsMapper.class);		
		return mapper.delete(bbs);
	}
	
	@Override
	public List<Map<String, Object>> getFileList(BbsFile bbsFile) {
		BbsFileMapper mapper = session.getMapper(BbsFileMapper.class);
		return mapper.getList(bbsFile);
	}
	
}
