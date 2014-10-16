package org.joy.db;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.joy.config.TypeMapping;
import org.joy.db.model.Column;
import org.joy.db.model.Table;
import org.joy.db.model.util.JdbcTypeResolver;
import org.joy.util.StringUtil;

public class DefaultDatabase extends Database {

    public DefaultDatabase(Connection connection, TypeMapping typeMapping){
        super(connection, typeMapping);
    }

    @Override
    public Table getTable(String catalog, String schema, String tableName) {
        ResultSet rs = null;
        Table table = null;
        try {
            rs = connection.getMetaData().getTables(catalog, schema, tableName,
                                                    new String[] { "TABLE", "VIEW", "ALIAS", "SYNONYM" });
            if (rs.next()) {
                table = new Table();
                table.setCatalog(rs.getString("TABLE_CAT"));
                table.setSchema(schema);
                table.setTableName(tableName);
                table.setRemarks(rs.getString("REMARKS"));
                table.setTableType(rs.getString("TABLE_TYPE"));

                introspectPrimaryKeys(table);
                introspectColumns(table);
                introspectForeignKeys(table);
                introspectIndex(table);
            }
        } catch (SQLException e) {

        } finally {
            close(rs);
        }
        return table;
    }

    protected void introspectPrimaryKeys(Table table) {
        ResultSet rs = null;
        try {
            rs = connection.getMetaData().getPrimaryKeys(null, null, table.getTableName());
            while (rs.next()) {
                String columnName = rs.getString("COLUMN_NAME");
                Column column = table.getColumn(columnName);
                if (column == null) {
                    column = new Column(columnName);
                    table.addPrimaryKeyColumn(column);
                }
                column.setPrimaryKey(true);
            }
        } catch (SQLException e) {

        } finally {
            close(rs);
        }
    }

    protected void introspectColumns(Table table) {
        ResultSet rs = null;
        try {
            rs = connection.getMetaData().getColumns(null, null, table.getTableName(), "%");
            while (rs.next()) {
                String columnName = rs.getString("COLUMN_NAME");// 获得字段名称
                if (StringUtil.isEmpty(columnName)) {
                    continue;
                }

                Column column = table.getColumn(columnName);
                if (column == null) {
                    column = new Column(columnName);
                    table.addBaseColumn(column);
                }
                column.setJdbcType(rs.getInt("DATA_TYPE"));
                column.setSize(rs.getInt("COLUMN_SIZE"));
                column.setNullable(rs.getInt("NULLABLE") == 1);
                column.setDefaultValue(rs.getString("COLUMN_DEF"));
                column.setDecimalDigits(rs.getInt("DECIMAL_DIGITS"));
                column.setRemarks(rs.getString("REMARKS"));
                column.setJdbcTypeName(JdbcTypeResolver.getJdbcTypeName(column.getJdbcType()));
                column.setJavaType(typeMapping.calculateJavaType(column));
                column.setFullJavaType(typeMapping.calculateFullJavaType(column));
                column.setJavaProperty(StringUtil.getCamelCaseString(columnName, false));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(rs);
        }
    }

    // 获得外键的信息
    protected void introspectForeignKeys(Table table) {
        ResultSet rs = null;
        try {
            rs = connection.getMetaData().getImportedKeys(null, null, table.getTableName());
            while (rs.next()) {
                String columnName = rs.getString("FKCOLUMN_NAME");
                if (StringUtil.isEmpty(columnName)) {
                    continue;
                }
                String pkTableName = rs.getString("PKTABLE_NAME");
                String pkColumnName = rs.getString("PKCOLUMN_NAME");
                Column column = table.getColumn(columnName);
                if (column != null) {
                    column.setForeignKey(true);
                    column.setTargetTableName(pkTableName);
                    column.setTargetColumnName(pkColumnName);
                }
            }
        } catch (SQLException e) {

        } finally {
            close(rs);
        }
    }

    // 获得索引
    protected void introspectIndex(Table table) {
        ResultSet rs = null;
        try {
            rs = connection.getMetaData().getIndexInfo(null, null, table.getTableName(), true, true);
            while (rs.next()) {
                String columnName = rs.getString("COLUMN_NAME");
                if (StringUtil.isEmpty(columnName)) {
                    continue;
                }
                Column column = table.getColumn(columnName);
                if (column != null) {
                    column.setUnique(!rs.getBoolean("NON_UNIQUE"));
                }
            }
        } catch (SQLException e) {

        } finally {
            close(rs);
        }
    }
}