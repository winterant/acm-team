package TEST;

import Mysql.SQL;

public class Main {

    public static void main(String[] args){
        System.out.println("Hello world!");
        String sql="insert into news(publishTime) values('2019-01-07 16:29:58')";
        int t=new SQL().update(sql);
        System.out.println(t);
    }
}
