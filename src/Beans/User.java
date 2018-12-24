package Beans;
import Mysql.SQL;
import sun.misc.BASE64Encoder;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;

public class User {
    private Integer id;  //若用户构造失败，则id=0
    private Map<String,Object> userMap;

    public User(int id){
        //若用户不存在，info将被赋值为 new HashMap<>(),id=0;
        String sql="select * from users where id="+id;
        SQL mysql=new SQL();
        userMap =mysql.queryFirst(sql);
        mysql.close();
        this.id= userMap.containsKey("id") ? (Integer) userMap.get("id") : 0;
    }
    public User(String userName){
        //若用户不存在，info将被赋值为 new HashMap<>();id=0
        String sql="select * from users where userName='"+userName+"'";
        SQL mysql=new SQL();
        userMap =mysql.queryFirst(sql);
        mysql.close();
        this.id= userMap.containsKey("id") ? (Integer) userMap.get("id") : 0;
    }

    public static boolean isLegal(String userName,String password){
        //给出用户名和密码，判断该用户名和密码是否合法
        User user=new User(userName);
        password=User.encode(password);
        return user.getInt("id")!=0 &&
                password!=null &&
                password.equals(user.getString("password"));
    }
    public static String encode(String password) //获取密码的密文
    {
        String enPassword = null;
        try {
            MessageDigest md5 = MessageDigest.getInstance("MD5");
            BASE64Encoder base64en = new BASE64Encoder();

            byte[] pwd=password.getBytes("UTF-8");
            enPassword = base64en.encode(md5.digest(pwd));
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return enPassword;
    }

    public boolean isExist(){
        return id!=null && id>0;
    } //判断当前用户是否存在数据库

    public Map<String,Object> getUserMap(){ return userMap; }
    public Object get(String key){return userMap.get(key);}
    public String getString(String columnName){
        Object ret= userMap.get(columnName);
        return ret==null ? "" : ret.toString();
    }
    public int getInt(String columnName,int defaultNumber){
        Object ret= userMap.get(columnName);
        return ret==null ? defaultNumber : (Integer) ret;
    }
    public int getInt(String columnName){   //使得返回失败时，默认取0
        return getInt(columnName,0);
    }


    public static int computeRating(String userName){
        User user=new User(userName);
        int rating=user.getInt("codeforcesRating")
                +user.getInt("newcoderRating")
                +user.getInt("atcoderRating");
        int score=0; //其他计算规则
        return rating+score;
    }
}
