package me.ahacross.mylord.json;

import java.io.File;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.charset.CharacterCodingException;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map;

import me.ahacross.mylord.file.FilePath;

import javax.servlet.ServletException;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/json")
public class JSONController {
	private static final Logger logger = LogManager.getLogger(JSONController.class);
	
	@ResponseBody
	@RequestMapping(method=RequestMethod.GET)
    public Map<String, Object> readJson(@ModelAttribute JSON json) throws IOException, ServletException {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		MappedByteBuffer buffer = null;
		Path path = Paths.get(new FilePath().getJSONFile()+json.getName());
		try(FileChannel fileChannel = (FileChannel.open(path, StandardOpenOption.READ))){
			buffer = fileChannel.map(FileChannel.MapMode.READ_ONLY, 0, fileChannel.size());
		} catch (IOException e) {
			e.printStackTrace();
		}
		String data = null;
		if(buffer != null){
			try{
	            Charset charset = Charset.defaultCharset();
	            CharsetDecoder decoder = charset.newDecoder();
	            CharBuffer charBuffer = decoder.decode(buffer);
	            data = charBuffer.toString();
	            buffer.clear();
			} catch (CharacterCodingException e) {
				e.printStackTrace();
			}
		}

		System.out.println("file :"+ data);
		resultMap.put("string", data);
        return resultMap;
    }
	
	private void fileDelete (JSON json) throws Exception {
		File file = new File(new FilePath().getJSONFile()+json.getName());
        if(file.exists()){
        	file.delete();
        }
	};
	
	private void fileCreate (JSON json) throws Exception {
		Path path = Paths.get(new FilePath().getJSONFile()+json.getName());
    	System.out.println(json.toString());
    	
         ByteBuffer buffer = ByteBuffer.wrap(json.getJson().getBytes());
         try(FileChannel fileChannel = (FileChannel.open(path, StandardOpenOption.CREATE_NEW, StandardOpenOption.WRITE))){
             fileChannel.position(0);
             fileChannel.write(buffer);
         } catch (IOException e) {
             e.printStackTrace();
         }
	}
	
	
	@ResponseBody
	@RequestMapping(method=RequestMethod.POST)
    public Map<String, Object> insertJson(@RequestBody JSON json) throws IOException, ServletException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		fileCreate(json);
    	resultMap.put("insert", "Y");
        return resultMap;
    }
	
	@ResponseBody
	@RequestMapping(method=RequestMethod.PUT)
    public Map<String, Object> updateJson(@RequestBody JSON json) throws IOException, ServletException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		fileDelete(json);
		fileCreate(json);
    	resultMap.put("update", "Y");
        return resultMap;
    }
	
	@ResponseBody
	@RequestMapping(method=RequestMethod.DELETE)
    public Map<String, Object> deleteJson(@RequestBody JSON json) throws IOException, ServletException, Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		fileDelete(json);
    	resultMap.put("delete", "Y");
        return resultMap;
    }
}
