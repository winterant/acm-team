# acm-team
ACM程序设计实验室管理网站（jsp）<br>
参观一下网站：http://ldu.winter2121.top <br>
服务器搭建参照：https://blog.csdn.net/winter2121/article/details/83308354 <br>

# 主要模块
    新闻。编辑使用富文本编辑器wangeditor，git：https://github.com/wangfupeng1988/wangEditor
    竞赛。初始版本管理员可以人工添加竞赛。
    排名。根据用户的codeforces、atcoder、牛客用户名，使用htmlunit网络爬虫获取积分进行排名。
    成员。收集团队成员信息进行展示。

# 主要配置
  ## 数据库MySql5默认配置
  （可在/src/Mysql/SQL.java中修改）
  
    数据库名称：winter
    数据库用户（localhost）：root
    数据库用户密码：iloveyou
  ## 数据库创建
    /extends/mysql/winter.sql
    
  ## tomcat8.5默认配置
   请在**服务器**端tomcat/conf/server.xml中修改默认应用路径为本项目，否则项目中路径跳转出错。
   必须配置虚拟路径，upload用于文件上传：
  
  ## 项目所需的jar包
  全部在/extends/jar/* 备份
  
  ## htmlunit爬虫
  java代码位于/src/Reptile/*，主类HtmlunitURL.java使用htmlunit，其他类继承自HtmlunitURL
  
  ## /web/template文件夹说明
  此文件夹存放其他页面所有的公共成分。重要的有：
  
    headTag.jsp       所有页面所需的h5头部配置，以及所有页面公用的变量等。
    header.jsp        页面头部主菜单
    footer.jsp        页脚
    homeLeftPage.jsp  主页左侧div
    pagingDiv.jsp     翻页div
    vagueSearch.jsp   模糊搜索div
    
  ## 文件上传
    使用外部jar：/src/jar/files/*
    servlet：/src/Servlet/ServletUpload
    文件上传位置：自动创建与项目根目录同级的目录upload/（注意此目录不在web内，而是同级，因此tomcat必须配置虚拟路径才能在前端访问到）
  
  
