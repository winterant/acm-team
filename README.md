# acm-team
ACM程序设计实验室管理网站（jsp）<br>
参观一下网站：http://* <br>
服务器搭建参照：https://blog.csdn.net/winter2121/article/details/83308354 <br>


# 主要模块
    新闻。编辑使用富文本编辑器wangeditor，git：https://github.com/wangfupeng1988/wangEditor
    竞赛。初始版本管理员可以人工添加竞赛。
    排名。根据用户的codeforces、atcoder、牛客用户名，使用htmlunit网络爬虫获取积分进行排名。
    成员。收集团队成员信息进行展示。

# 以下先不要看，未纠正
# 部署到windows10 IDEA
  ## 文件上传问题
  文件上传默认上传到项目的父目录(webapps)下的upload文件夹，这样的话前台访问不到，因此做一个映射。

  ## 数据库MySql5默认配置
  （可在/src/Mysql/SQL.java中修改）一定要给数据库用户增删查改权限！
  
    数据库名称：winter
    数据库用户（localhost）：winter
    数据库用户密码：iloveyou
  ## 数据库创建脚本
    /extends/mysql/winter.sql
    
  ## /web/template文件夹说明
  此文件夹存放其他页面所有的公共成分。重要的有：
  
    headTag.jsp       所有页面所需的h5头部配置，以及所有页面公用的变量等。
    header.jsp        页面头部主菜单
    footer.jsp        页脚
    homeLeftPage.jsp  主页左侧div
    pagingDiv.jsp     翻页div
    vagueSearch.jsp   模糊搜索div
    
  ## 项目所需的jar包
  全部在/extends/jar/* 备份
  
  ## htmlunit爬虫
  java代码位于/src/Reptile/*，主类HtmlunitURL.java使用htmlunit，其他类继承自HtmlunitURL
  
# 部署到远程tomcat服务器
  * 将本地打好的war包(ROOT.war)，上传至tomcat/webapps/下
  * 配置虚拟路径为根目录
  * 配置文件上传虚拟路径，同win10 IDEA配置中的‘文件上传问题’
