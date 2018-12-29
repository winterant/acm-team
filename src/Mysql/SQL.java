package Mysql;

import java.sql.*;
import java.util.*;

public class SQL {
    private static String serverIP="localhost";
    private static String serverPort="3306";
    private static String dataName="winter"; //数据库名称
    private static String user="winter";
    private static String password="iloveyou";

    private static String url="jdbc:mysql://"+serverIP+":"+serverPort+"/"+dataName+"?useUnicode=true&characterEncoding=UTF-8";
    private static String driverName="com.mysql.jdbc.Driver";

    private Connection con=null;
    private Statement stmt=null;

    public SQL(){linkSql();}
    public void linkSql() {
        try {
            Class.forName(driverName).newInstance();
            con = DriverManager.getConnection(url, user, password);
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public ResultSet queryRS(String sql) {  //查询结束后，不能关闭stmt,否则会导致ResultSet关闭
        try {
            if(con==null)linkSql();
            if(stmt!=null)stmt.close();
            stmt=con.createStatement();
            return stmt.executeQuery(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Map<String,Object>> queryList(String sql){
        List<Map<String,Object>> list=new ArrayList<>();
        try {
            ResultSet res=queryRS(sql);
            if(res==null)return list;
            ResultSetMetaData md = res.getMetaData();
            int columnCount=md.getColumnCount();
            while(res!=null&&res.next())
            {
                Map<String,Object> rowData=new HashMap<>();
                for(int i=1;i<=columnCount;i++){
                    rowData.put(md.getColumnName(i),res.getObject(i));
                }
                list.add(rowData);
            }
            if(stmt!=null)stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String,Object> queryFirst(String sql){
        List<Map<String,Object>> list=queryList(sql);
        if(list.size()>0)return list.get(0);
        return new HashMap<>();
    }

    public int update(String sql){
        int ret=0;
        try {
            if(con==null)linkSql();
            if(stmt!=null)stmt.close();
            stmt=con.createStatement();
            ret=stmt.executeUpdate(sql);
            if(stmt!=null)stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ret;
    }

    public void close(){
        try {
            if(stmt!=null)stmt.close();
            if(con!=null)con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}