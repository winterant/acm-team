package TEST;


import Reptile.Upc;

public class Main {

    public static void main(String[] args){
        new Thread(()->{
            Upc upc=new Upc();
            upc.login();
            upc.updateContest();
        }).start();

    }
}
