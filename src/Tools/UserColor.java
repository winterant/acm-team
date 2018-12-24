package Tools;

import Beans.User;

public class UserColor {
    public static int[] scoreLine=new int[]{1500,2000,2500,3000,3500,4000,4500};
    public static String[] scoreColorWords=new String[]{"灰色","黑色","土色","绿色","蓝色","紫色","橙色","红色"};

    public static String getUserColor(Integer rating){
        if(rating==null)rating=0;
        for(int i=0;i<UserColor.scoreLine.length;i++){
            if(rating<=UserColor.scoreLine[i])return "user-color"+i;
        }
        return "user-color"+UserColor.scoreLine.length;
    }//返回值是一个字符串，可以对应一个css类名
    public static String getUserColor(User user){
        return getUserColor(user.getInt("rating"));
    }
}
