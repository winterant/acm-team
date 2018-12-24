package Reptile;

import Beans.User;
import Mysql.SQL;
import Tools.Changing;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Atcoder extends HtmlunitURL{
    public Atcoder(){super();}
    public int updateUser(User user){
        String userName=user.getString("userName");
        String atName=user.getString("atcoderid");
        if(atName==null||atName.length()<1)return 0;
        String html=super.getHtml("https://atcoder.jp/users/"+atName);

        //正则表达式匹配分数
        Pattern pattern=Pattern.compile("Rating</th><td><span class='user-\\S*'>[0-9]+");
        Matcher matcher=pattern.matcher(html);
        String score="0";
        if(matcher.find()){
            int s=matcher.group().lastIndexOf(">");
            score=matcher.group().substring(s+1);
        }
        System.out.println("atcoder rating of "+atName+":"+score);
        if(score.equals("0"))return 0;

        String sql="update users set atcoderRating="+score+" where userName='"+userName+"'";
        SQL mysql=new SQL();
        int ret1=mysql.update(sql);

        //下面把总rating更新一下
        sql="update users set rating="+User.computeRating(userName)+" where userName='"+userName+"'";
        int ret2=mysql.update(sql);
        mysql.close();
        System.out.println("Atcoder更新成功");
        return ret1+ret2;
    }

    //爬虫获取用户userName的Atcoder分数
    public int getRating(String atName){
        String html=super.getHtml("https://atcoder.jp/users/"+atName);
        if(atName==null||atName.length()<1)return 0;
        Pattern pattern=Pattern.compile("Rating</th><td><span class='user-\\S*'>[0-9]+");
        Matcher matcher=pattern.matcher(html);
        String score="0";
        if(matcher.find()){
            int s=matcher.group().lastIndexOf(">");
            score=matcher.group().substring(s+1);
        }
        System.out.println("atcoder rating of "+atName+":"+score);
        return Changing.strToNumber(score);
    }
}
