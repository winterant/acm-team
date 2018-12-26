package Reptile;

import Beans.User;
import Mysql.SQL;
import Tools.Changing;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Codeforces extends HtmlunitURL{
    public Codeforces(){super();}
    public int updateUser(User user){
        String userName=user.getString("userName");
        String cfName=user.getString("codeforcesid");
        if(cfName==null||cfName.length()<1)return 0;
        String html=super.getHtml("http://Codeforces.com/profile/"+cfName); //获取html

        //正则表达式匹配分数
        Pattern pattern=Pattern.compile("<span style=\"font-weight:bold;\" class=\"user-\\S*\">[0-9]+");
        Matcher matcher=pattern.matcher(html);
        String score="*";
        if(matcher.find()){
            int s=matcher.group().indexOf(">");
            score=matcher.group().substring(s+1);
        }
        System.out.println("codeforeces rating of "+cfName+":"+score);
        if(score.equals("*"))return 0;


        //更新数据库
        String sql="update users set codeforcesRating="+score+" where userName='"+userName+"'";
        SQL mysql=new SQL();
        int ret1=mysql.update(sql);

        //下面把总rating更新一下
        sql="update users set rating="+User.computeRating(userName)+" where userName='"+userName+"'";
        int ret2=mysql.update(sql);
        mysql.close();
        System.out.println("codeforces更新成功");
        return ret1+ret2;
    }
    //爬虫获取用户userName的cf 分数
    public int getRating(String cfName){
        String html=super.getHtml("http://Codeforces.com/profile/"+cfName); //获取html
        Pattern pattern=Pattern.compile("<span style=\"font-weight:bold;\" class=\"user-\\S*\">[0-9]+");
        Matcher matcher=pattern.matcher(html);
        String score="0";
        if(matcher.find()){
            //只取第一个就行了，第二个是maxscore
            int s=matcher.group().indexOf(">");
            score=matcher.group().substring(s+1);
        }
        System.out.println("codeforeces rating of "+cfName+":"+score);
        return Changing.strToNumber(score);
    }
}
