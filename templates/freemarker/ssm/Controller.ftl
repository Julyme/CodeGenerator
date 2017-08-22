<#include "author.ftl"/>
package ${basePackage}.${moduleName}.controller

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import ${basePackage}.${moduleName}.entity.${table.className};
import ${basePackage}.${moduleName}.service.${table.className}Service;
import com.github.pagehelper.PageHelper;

@Controller
@RequestMapping("/${table.className}")
public class ${table.className}Controller {
	@Autowired
	private ${table.className}Service objService;
	
	//查询所有${table.className}
	@RequestMapping("/query${table.className}.action")
	public @ResponseBody Map<String, Object> findAll${table.className}(int page,int rows) throws Exception {

		PageHelper.startPage(page, rows);
		List<${table.className}> objList = objService.findAll${table.className}();

		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("total", objService.totalSize());
		map.put("rows", objList);
		return map;
	}
	
	//增加${table.className} 
	@RequestMapping("/add${table.className}.action")
	public void add${table.className}(${table.className} obj) throws Exception {
		objService.add${table.className}(obj);
	}
	
	//修改${table.className}
	@RequestMapping("/update${table.className}.action")
	public void update${table.className}(${table.className} obj) throws Exception {
		objService.update${table.className}(obj);
	}
	
	//删除${table.className}
	@RequestMapping("/delete${table.className}.action")
	public void delete${table.className}(int id) throws Exception {
			objService.delete${table.className}(id);
	}
}
