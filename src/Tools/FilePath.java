package Tools;

import Mysql.SQL;
import java.util.Map;

public class FilePath {
    public static String getPhotoPath(String userName){
        SQL mysql=new SQL();
        String sql= String.format("select path from files where id in" +
                " (select max(fileid) from photoes where userName='%s')", userName);

        Map res=mysql.queryFirst(sql);
        if(res.isEmpty())return "/images/smallPic/defaultphoto.jpg";//默认照片
        return res.get("path").toString();
    }
    public static String getFilePath(int fileid,String defaultPath){
        SQL mysql=new SQL();
            //按文件编号读取
        String sql= String.format("select path from files where id=%d", fileid);
        System.out.println(sql);
        Map res=mysql.queryFirst(sql);
        if(res.isEmpty())return defaultPath; //默认路径
        return res.get("path").toString();
    }
    public static String getFilePath(int fileid){
        return getFilePath(fileid,"");
    }
}
