<#include "author.ftl"/>
package ${basePackage}.${moduleName}.serviceImpl

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ${basePackage}.${moduleName}.entity.${table.className};
import ${basePackage}.${moduleName}.mapper.${table.className}Mapper;
import ${basePackage}.${moduleName}.service.${table.className}Service;

@Service
public class ${table.className}ServiceImpl implements ${table.className}Service {
	@Autowired
	private ${table.className}Mapper objMapper;
	
	@Override
	public List<${table.className}> findAll${table.className}() throws Exception {
		return objMapper.findAll${table.className}();
	}

	@Override
	public void add${table.className}(${table.className} obj) throws Exception {
		objMapper.add${table.className}(obj);
	}

	@Override
	public void update${table.className}(${table.className} obj) throws Exception {
		objMapper.update${table.className}(obj);
	}

	@Override
	public void delete${table.className}(int id) throws Exception {
		objMapper.delete${table.className}(id);
	}

	@Override
	public int totalSize() throws Exception {
		return objMapper.totalSize();
	}

}
