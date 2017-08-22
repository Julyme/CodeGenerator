<#include "author.ftl"/>
package ${basePackage}.${moduleName}.mapper

import java.util.List;
import ${basePackage}.${moduleName}.entity.${table.className};

public interface ${table.className}Mapper {
	//查询所有${table.className}
	public List<${table.className}> findAll${table.className}() throws Exception;
	//增加${table.className}
	public void add${table.className}(${table.className} obj) throws Exception;
	//修改${table.className}信息
	public void update${table.className}(${table.className} obj) throws Exception;
	//删除${table.className}
	public void delete${table.className}(int id) throws Exception;
	//总记录数
	public int totalSize() throws Exception;
}