<!DOCTYPE html>
<%--
  Created by IntelliJ IDEA.
  User: msi-
  Date: 2019/10/16
  Time: 16:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<html>

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"><meta name="renderer" content="webkit">

    <title>爬虫规则适配系统</title>
    <meta name="keywords" content="H+后台主题,后台bootstrap框架,会员中心主题,后台HTML,响应式后台">
    <meta name="description" content="H+是一个完全响应式，基于Bootstrap3最新版本开发的扁平化主题，她采用了主流的左右两栏式布局，使用了Html5+CSS3等现代技术">

    <link href="<%=basePath%>css/bootstrap.min.css?v=3.4.0" rel="stylesheet">
    <link href="<%=basePath%>font-awesome/css/font-awesome.css?v=4.3.0" rel="stylesheet">

    <link href="<%=basePath%>css/animate.css" rel="stylesheet">
    <link href="<%=basePath%>css/style.css?v=2.2.0" rel="stylesheet">

</head>

<body>
<div id="wrapper">
    <nav class="navbar-default navbar-static-side" role="navigation">
        <div class="sidebar-collapse">
            <ul class="nav" id="side-menu">
                <li class="nav-header">

                    <div class="dropdown profile-element"> <span>
                            <img alt="image" class="img-circle" src="img/profile_small.jpg" />
                             </span>
                        <a data-toggle="dropdown" class="dropdown-toggle" href="index.html#">
                                <span class="clear"> <span class="block m-t-xs"> <strong class="font-bold">Beaut-zihan</strong>
                             </span>  <span class="text-muted text-xs block">超级管理员 <b class="caret"></b></span> </span>
                        </a>
                        <ul class="dropdown-menu animated fadeInRight m-t-xs">
                            <li><a href="form_avatar.html">修改头像</a>
                            </li>
                            <li><a href="profile.html">个人资料</a>
                            </li>
                            <li><a href="contacts.html">联系我们</a>
                            </li>
                            <li><a href="mailbox.html">信箱</a>
                            </li>
                            <li class="divider"></li>
                            <li><a href="login.html">安全退出</a>
                            </li>
                        </ul>
                    </div>
                    <div class="logo-element">
                        H+
                    </div>

                </li>





                <li class="active">
                    <a href="index.html#"><i class="fa fa-table"></i> <span class="nav-label">适配网站</span><span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">
                        <li class="active"><a href="<%=basePath%>websiteList">网站列表(中央)</a>
                        </li>
                        <li><a href="<%=basePath%>websiteList_lar">网站列表(地方)</a>
                        </li>
                    </ul>
                </li>
                <li>
                    <a href="index.html#"><i class="fa fa-sitemap"></i> <span class="nav-label">已适配/未适配 </span><span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">
                        <li><a href="javascript:void(0);" onclick="isApaterWebsiteList()">已适配</a>
                        </li>
                        <li>
                            <a href="javascript:void(0);" onclick="isNotApaterWebsiteList()">未适配</a>
                        </li>
                    </ul>
                </li>
                <script type="text/javascript">
                    function isApaterWebsiteList() {
                        window.location.href="/isApaterWebsiteList";
                    }
                    function isNotApaterWebsiteList() {
                        window.location.href="/isNotApaterWebsiteList";
                    }
                </script>
                <li>
                    <a href="index.html#"><i class="fa fa-magic"></i> <span class="nav-label">通用脚本修改 </span><span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">
                        <li>
                            <a href="javascript:void(0);" onclick="lawstar_title_update()">标题</a>
                        </li>
                        <li>
                            <a href="javascript:void(0);" onclick="lawstar_content_update()">正文</a>
                        </li>
                        <li>
                            <a href="javascript:void(0);" onclick="lawstar_implmentdate_update()">实施日期</a>
                        </li>
                        <li>
                            <a href="javascript:void(0);" onclick="lawstar_appdate_update()">发布日期</a>
                        </li>
                        <li>
                            <a href="javascript:void(0);" onclick="lawstar_wenhao_update()">文号</a>
                        </li>
                        <li>
                            <a href="javascript:void(0);" onclick="lawstar_attments_update()">附件</a>
                        </li>
                    </ul>
                </li>
                <li>
                    <a href="index.html#"><i class="fa fa-desktop"></i> <span class="nav-label">法规预处理</span><span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">
                        <!--                        <li><a href="table_basic.html">基本表格</a>
                                                </li>-->
                        <li><a href="/informationPipeline">中央法规</a>
                        <li><a href="/informationPipelinelar">地方法规</a>
                        </li>
                    </ul>
                </li>
                <script type="text/javascript">
                    function lawstar_title_update() {
                        window.location.href="/lawstar_title_update";
                    }
                    function lawstar_content_update() {
                        window.location.href="/lawstar_content_update";
                    }
                    function lawstar_implmentdate_update() {
                        window.location.href="/lawstar_implmentdate_update";
                    }
                    function lawstar_appdate_update() {
                        window.location.href="/lawstar_appdate_update";
                    }
                    function lawstar_wenhao_update() {
                        window.location.href="/lawstar_wenhao_update";
                    }

                    function lawstar_attments_update() {
                        window.location.href="/lawstar_attments_update";
                    }
                </script>
            </ul>

        </div>
    </nav>

    <div id="page-wrapper" class="gray-bg dashbard-1">
        <div class="row border-bottom">
            <nav class="navbar navbar-static-top" role="navigation" style="margin-bottom: 0">
                <div class="navbar-header">
                    <a class="navbar-minimalize minimalize-styl-2 btn btn-primary " href="code_editor.html#"><i class="fa fa-bars"></i> </a>
                    <form role="search" class="navbar-form-custom" method="post" action="search_results.html">
                        <div class="form-group">
                            <input type="text" placeholder="请输入您需要查找的内容 …" class="form-control" name="top-search" id="top-search">
                        </div>
                    </form>
                </div>
                <ul class="nav navbar-top-links navbar-right">
                    <li>
                        <span class="m-r-sm text-muted welcome-message"><a href="index.html" title="返回首页"><i class="fa fa-home"></i></a>欢迎使用H+后台主题</span>
                    </li>
                    <li class="dropdown">
                        <a class="dropdown-toggle count-info" data-toggle="dropdown" href="index.html#">
                            <i class="fa fa-envelope"></i>  <span class="label label-warning">16</span>
                        </a>
                        <ul class="dropdown-menu dropdown-messages">
                            <li>
                                <div class="dropdown-messages-box">
                                    <a href="profile.html" class="pull-left">
                                        <img alt="image" class="img-circle" src="img/a7.jpg">
                                    </a>
                                    <div class="media-body">
                                        <small class="pull-right">46小时前</small>
                                        <strong>小四</strong> 项目已处理完结
                                        <br>
                                        <small class="text-muted">3天前 2014.11.8</small>
                                    </div>
                                </div>
                            </li>
                            <li class="divider"></li>
                            <li>
                                <div class="dropdown-messages-box">
                                    <a href="profile.html" class="pull-left">
                                        <img alt="image" class="img-circle" src="img/a4.jpg">
                                    </a>
                                    <div class="media-body ">
                                        <small class="pull-right text-navy">25小时前</small>
                                        <strong>国民岳父</strong> 这是一条测试信息
                                        <br>
                                        <small class="text-muted">昨天</small>
                                    </div>
                                </div>
                            </li>
                            <li class="divider"></li>
                            <li>
                                <div class="text-center link-block">
                                    <a href="mailbox.html">
                                        <i class="fa fa-envelope"></i>  <strong> 查看所有消息</strong>
                                    </a>
                                </div>
                            </li>
                        </ul>
                    </li>
                    <li class="dropdown">
                        <a class="dropdown-toggle count-info" data-toggle="dropdown" href="index.html#">
                            <i class="fa fa-bell"></i>  <span class="label label-primary">8</span>
                        </a>
                        <ul class="dropdown-menu dropdown-alerts">
                            <li>
                                <a href="mailbox.html">
                                    <div>
                                        <i class="fa fa-envelope fa-fw"></i> 您有16条未读消息
                                        <span class="pull-right text-muted small">4分钟前</span>
                                    </div>
                                </a>
                            </li>
                            <li class="divider"></li>
                            <li>
                                <a href="profile.html">
                                    <div>
                                        <i class="fa fa-qq fa-fw"></i> 3条新回复
                                        <span class="pull-right text-muted small">12分钟钱</span>
                                    </div>
                                </a>
                            </li>
                            <li class="divider"></li>
                            <li>
                                <div class="text-center link-block">
                                    <a href="notifications.html">
                                        <strong>查看所有 </strong>
                                        <i class="fa fa-angle-right"></i>
                                    </a>
                                </div>
                            </li>
                        </ul>
                    </li>


                    <li>
                        <a href="login.html">
                            <i class="fa fa-sign-out"></i> 退出
                        </a>
                    </li>
                </ul>

            </nav>
        </div>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="btn-group">
                <button data-toggle="dropdown" class="btn btn-warning dropdown-toggle">继续验证十篇 <span class="caret"></span>
                </button>
                <ul class="dropdown-menu">
                    <c:forEach items="${websiteList}" var="websiteList">
                        <li><a href="<%=basePath%>regten/${websiteList.id}/${websiteList.userid}">${websiteList.websiteaddress}</a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
            <button type="button" class="btn btn-primary btn-sm" onclick="nextPage(7)">完成</button>


            <div class="col-lg-9">
                <h2>Pin Board</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="index.html">主页</a>
                    </li>
                    <li>
                        附加页面
                    </li>
                    <li>
                        <strong>标签墙</strong>
                    </li>
                </ol>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="wrapper wrapper-content animated fadeInUp">
                    <ul class="notes">
                        <c:forEach items="${resultList}" var="resultList">
                            <li>
                                <div>

                                    <p>
                                            ${resultList}
                                    </p>

                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
        </div>
        <div class="footer">
            <div class="pull-right">
                By：<a href="http://www.zi-han.net" target="_blank">zihan's blog</a>
            </div>
            <div>
                <strong>Copyright</strong> H+ &copy; 2014
            </div>
        </div>

    </div>
</div>
</div>

<!-- Mainly scripts -->
<script src="<%=basePath%>js/jquery-2.1.1.min.js"></script>
<script src="<%=basePath%>js/bootstrap.min.js?v=3.4.0"></script>
<script src="<%=basePath%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="<%=basePath%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

<!-- Custom and plugin javascript -->
<script src="<%=basePath%>js/hplus.js?v=2.2.0"></script>
<script src="<%=basePath%>js/plugins/pace/pace.min.js"></script>
<script type="text/javascript">

    function nextPage(page) {
        window.location.href = "<%=basePath%>/isNotApaterWebsiteList";
    }

</script>

</body>

</html>


