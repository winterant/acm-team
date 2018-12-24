package Tools;

import Mysql.SQL;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Paging {
    private int dataRowCount; //数据总条数
    private int pageSize;//每页显示数据条数
    private int nowPage;//当前页
    private final int indexPage=1;//首页
    private int endPage; //最大页码= (dataRow+pageSize-1)/pageSize;
    private int pageNumberCount=4; //当前页两侧分别显示的页码标签数

    private String dataTable; //数据表名
    private String orderCol; //排序依据列
    private int orderWay; //排序规则0升序1降序

    private Map<String,String> vague=new HashMap<>(); //设置模糊查询 列名->模糊查找的串
    private Map<String,String> exact=new HashMap<>(); //设置精确查找 列名->精确值
    private String sqlWhere=null; //外加限制条件查询 如: "where id='1'"

    private String sql=null; //整条完整查询语句

    public Paging(String dataTable){
        this.dataTable=dataTable;
        this.pageSize=50;  //默认每页50条记录!
        this.nowPage=1;
        this.orderCol=null;
        this.orderWay=0; //默认0升序
        //computePage();
    }

    public void computePage(){   //重新计算页码
        String str="select COUNT(*) from "+dataTable;
        if(sqlWhere!=null) {
            str += " " + sqlWhere;
        }
        if(!vague.isEmpty()){
            if(sqlWhere==null){
                str+=" where";
            }else{
                str+=" and";
            }
            str+=" (";
            int j=0;
            for(String key:vague.keySet()){
                if((++j)>1)str+=" or";
                str+=" "+key+" like '%"+vague.get(key)+"%'";
            }
            str+=")";
        }
        if(!exact.isEmpty()){
            if(sqlWhere==null&&vague.isEmpty()){
                str+=" where";
            }else{
                str+=" and";
            }
            str+=" (";
            int j=0;
            for(String key:exact.keySet()){
                if((++j)>1)str+=" and";
                str+=" "+key+"='"+exact.get(key)+"'";
            }
            str+=")";
        }

        SQL mysql=new SQL();
        ResultSet res = mysql.queryRS(str);
        try {
            if(res.next()) dataRowCount = res.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }finally {
            mysql.close();
        }
        endPage=(dataRowCount+pageSize-1)/pageSize;
        if(endPage<1)endPage=1;
    }

    //构造完整的sql语句
    public void constructSql(){
        sql="select * from "+dataTable;
        if(sqlWhere!=null) {
            sql += " " + sqlWhere;
        }
        if(!vague.isEmpty()){
            if(sqlWhere==null){
                sql+=" where";
            }else{
                sql+=" and";
            }
            sql+=" (";
            int j=0;
            for(String key:vague.keySet()){
                if((++j)>1)sql+=" or";
                sql+=" "+key+" like '%"+vague.get(key)+"%'";
            }
            sql+=")";
        }
        if(!exact.isEmpty()){
            if(sqlWhere==null&&vague.isEmpty()){
                sql+=" where";
            }else{
                sql+=" and";
            }
            sql+=" (";
            int j=0;
            for(String key:exact.keySet()){
                if((++j)>1)sql+=" and";
                sql+=" "+key+"='"+exact.get(key)+"'";
            }
            sql+=")";
        }

        if(orderCol!=null) {
            sql += " order by " + orderCol + (orderWay == 0 ? " ASC" : " DESC");
        }
        sql+=String .format(" limit %d,%d",(nowPage-1)*pageSize,pageSize);
    }

    public List<Map<String,Object>> getDataList(int nowPage){
        //获取当前页的所有行
        setNowPage(nowPage);
        computePage();
        constructSql();
        SQL mysql=new SQL();
        List<Map<String,Object>> list=mysql.queryList(sql);
        mysql.close();
        return list;
    }  //获取当前页所有内容

    public int getLeft(){
        if(nowPage-pageNumberCount<1)return 1;
        return nowPage-pageNumberCount;
    }
    public int getRight(){
        if(nowPage+pageNumberCount>endPage)return endPage;
        return nowPage+pageNumberCount;
    }

    public void addVague(String colName,String keyWords){
        //增加一个模糊查询的列
        if(keyWords!=null)
            vague.put(colName,keyWords);
    }
    public void addExact(String colName,String keyWords){
        //增加一个模糊查询的列
        if(keyWords!=null)
            exact.put(colName,keyWords);
    }

    public void setPageSize(int size){   //设置每页显示的条数
        this.pageSize=size;
        computePage();
    }
    public int getPageSize() {
        return pageSize;
    }  //获取每页条数
    public void setNowPage(int  now){    //设置当前为第几页
        computePage();
        if(now>endPage)now=endPage;
        if(now<1)now=1;
        this.nowPage=now;
    }
    public int getNowPage(){
        return nowPage;
    }  //获取当前所在页码
    public int getDataRowCount(){
        return dataRowCount;
    }  //获取数据总条数
    public int getEndPage(){
        return endPage;
    }   //获取最大页码
    public int getIndexPage(){return indexPage;}    //获取首页页码
    public void setOrder(String orderCol,int orderWay) {   //设置排序依据,根据orderCol列按orderWay=0升序，1降序
        this.orderCol=orderCol;
        this.orderWay=orderWay;
    }
    public String getSql(){
        constructSql();
        return sql; //调试阶段用,获取整句sql
    }
    public void setSqlWhere(String sqlWhere) {
        this.sqlWhere = sqlWhere;
        computePage(); //增加条件后从新计算总行数
    }

    //当前页两侧分别显示的页码标签数
    public void setPageNumberCount(int pageNumberCount) {   //设置页码条的当前页码两侧最多的页码标签数
        this.pageNumberCount = pageNumberCount;
    }


    /****
     * 以下是页面传参，下个页面继续使用的参数
     * ***/
    Map<String,String>nextArgs=new HashMap<>(); //存储通过页码标签传递的参数
    public void addNextArgs(String key,String val){
        if(val!=null&&val.length()>0)
            nextArgs.put(key,val);
    }
    public String getGotoPath(HttpServletRequest request,int gotoPage){
        //获取当前页面将继续去的路径，去第gotoPage页，并带好关键字
        try {
            request.setCharacterEncoding("UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        String path=request.getServletPath();
        path+="?";
        int j=0;
        for(String key:nextArgs.keySet()){
            if((++j)>1)path+="&";
            path+=key+"="+nextArgs.get(key);
        }
        if(j>0)path+="&";
        path+="nowPage="+gotoPage;
        return path;
    }
}
