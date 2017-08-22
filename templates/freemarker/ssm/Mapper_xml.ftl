<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${basePackage}.${moduleName}.mapper.${table.className}Mapper">

	<!-- 查询所有${table.className}信息 -->
	<select id="findAll${table.className}" resultType="${table.className}">
		select * from ${table.className}
	</select>

	<!-- 添加${table.className} -->
	<insert id="add${table.className}" parameterType="${table.className}">
		<selectKey keyProperty="dept_Id" order="AFTER" resultType="java.lang.Integer">
			select
			LAST_INSERT_ID()
		</selectKey>
		insert into
		${table.className}(obj_Id,objName)
		values(${r'#{dept_Id}'},${r'#{deptName})'}
	</insert>

<#list table.primaryKeys as key>

	<!-- 删除${table.className} -->
	<delete id="delete${table.className}" parameterType="${key.javaType}">
		delete from ${table.className}
		where ${key.javaProperty}=${r'#{id}'}
	</delete>
</#list>

	<!-- 更新${table.className} -->
	<update id="update${table.className}" parameterType="${table.className}">
		update ${table.className} set
		deptName=${r'#{deptName}'}
		where dept_Id=${r'#{dept_Id}'}
	</update>
	<!-- 总条数 -->
	<select id="totalSize" resultType="int">
		select count(*) from ${table.className}
	</select>
</mapper>