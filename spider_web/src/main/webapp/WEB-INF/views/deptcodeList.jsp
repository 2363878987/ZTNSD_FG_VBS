<!DOCTYPE html>
<%--
  Created by IntelliJ IDEA.
  User: msi-
  Date: 2019/10/14
  Time: 11:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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

    <!-- Data Tables -->
    <link href="<%=basePath%>css/plugins/dataTables/dataTables.bootstrap.css" rel="stylesheet">

    <link href="<%=basePath%>css/animate.css" rel="stylesheet">
    <link href="<%=basePath%>css/style.css?v=2.2.0" rel="stylesheet">
    <link href="http://yanshi.sucaihuo.com/modals/40/4078/demo/css/plugins/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css" rel="stylesheet">
    <!-- layui -->
    <link href="<%=basePath%>js/plugins/layui/css/layui.css" rel="stylesheet">


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
                                <span class="clear">
                                    <span class="block m-t-xs"> <strong class="font-bold">${sessionScope.user.name}</strong></span>

                                </span>
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
                            <li><a href="<%=basePath%>/outSys">安全退出</a>
                            </li>
                        </ul>
                    </div>
                    <div class="logo-element">
                        H+
                    </div>

                </li>





                <li >
                    <a href="index.html#"><i class="fa fa-table"></i> <span class="nav-label">适配网站</span><span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">

                        <li><a href="<%=basePath%>websiteList">网站列表(中央)</a>
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
                <c:if test="${sessionScope.user.level < 0}">
                    <li>
                        <a href="index.html#"><i class="fa fa-desktop"></i> <span class="nav-label">网站适配分配管理</span><span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <!--                        <li><a href="table_basic.html">基本表格</a>
                                                    </li>-->
                            <li><a href="/task/list">网站分配列表(中央)</a>
                            <li><a href="/task/list_lar">网站分配列表(地方)</a>
                            </li>
                        </ul>
                    </li>
                </c:if>
                <c:if test="${sessionScope.user.level < 0}">
                    <li>
                        <a href="index.html#"><i class="fa fa fa-bar-chart-o"></i> <span class="nav-label">网站数据抓取监测</span><span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <!--                        <li><a href="table_basic.html">基本表格</a>
                                                    </li>-->
                            <li><a href="/monitor/list">网站抓取列表(中央)</a>
                            <li><a href="/monitor/list_lar">网站抓取列表(地方)</a>
                            </li>
                        </ul>
                    </li>
                </c:if>
                <li >
                    <a href="index.html#"><i class="fa fa fa-bar-chart-o"></i> <span class="nav-label">人工审核</span><span class="fa arrow"></span></a>
                    <ul class="nav nav-second-level">
                        <!--                        <li><a href="table_basic.html">基本表格</a>
                                                </li>-->
                        <li><a href="/manCheck/list">临时库列表(中央)</a>
                        <li><a href="/manCheck/list_lar">临时库列表(地方)</a>
                        </li>
                        <li><a href="/manCheck/markList">临时库列表(已标记/中央)</a></li>
                        <li><a href="/manCheck/markList_lar">临时库列表(已标记/地方)</a></li>
                    </ul>
                </li>
                <li class="active">
                    <a href="<%=basePath%>deptcode/index"><i class="fa fa-files-o"></i> <span class="nav-label">部门代码维护</span></a>
                </li>
                <li>
                    <a href="/search/goSearchPage"><i class="fa fa-files-o"></i> <span class="nav-label">搜索</span></a>

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
                    <a class="navbar-minimalize minimalize-styl-2 btn btn-primary " href="<%=basePath%>informationPipeline#"><i class="fa fa-bars"></i> </a>

                </div>
                <ul class="nav navbar-top-links navbar-right">
                    <li>
                        <span class="m-r-sm text-muted welcome-message"><a href="<%=basePath%>index" title="返回首页"><i class="fa fa-home"></i></a>欢迎使用爬虫规则适配系统</span>
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
                        <a href="<%=basePath%>/outSys">
                            <i class="fa fa-sign-out"></i> 退出
                        </a>
                    </li>
                </ul>

            </nav>
        </div>
        <div class="row wrapper border-bottom white-bg page-heading">


            <script type="text/javascript">

                function openTimer() {
                    $.ajax({ url: "<%=basePath%>openTimer", success: function(data){
                        alert(data)
                    }});
                }
                function closeTimer() {
                    $.ajax({ url: "<%=basePath%>closeTimer", success: function(data){
                        alert(data)
                    }});
                }

            </script>
            <div class="col-lg-10">
             <span style="float: right;margin-top: 30px;">


            </span>
                <h2>临时库列表（中央）</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="<%=basePath%>index">主页</a>
                    </li>
                    <li>
                        <a>人工审核</a>
                    </li>
                    <li>
                        <strong>临时库列表（中央）</strong>
                    </li>
                </ol>
            </div>
            <div class="col-lg-2">
                <div class="text-center" style="padding-top: 30px">
                    <a data-toggle="modal" class="btn btn-primary" href="form_basic.html#modal-form" onclick="test001()">添加</a>
                </div>
                <div id="modal-form" class="modal fade" aria-hidden="true">
                    <div class="modal-dialog" style="width: 60%">
                        <div class="modal-content">
                            <div class="modal-body" style="height: 200px;">
                                <div class="row">

                                    <form class="layui-form" action="" method="post">
                                        <div class="layui-form-item" style="margin-top: 50px">
                                            <label class="layui-form-label"></label>
                                            <div class="layui-input-inline">
                                                <select id="select1" name="modules1" lay-verify="required" lay-search="">
                                                    <option value="">-市-</option>

                                                </select>
                                            </div>
                                            <div class="layui-input-inline">
                                                <select id="select2" name="newDeptcode" lay-verify="required" lay-search="">
                                                    <option value="">-区-</option>
                                                </select>
                                            </div>
                                            <div class="layui-input-inline">
                                                <input type="text" id="newDeptName" name="newDeptName" class="layui-input">
                                            </div>
                                            <button style="margin-left: 50px;" class="layui-btn" onclick="insertDept()">立即提交</button>
                                            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
                                        </div>
                                    </form>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
        <div class="wrapper wrapper-content animated fadeInRight">
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">

                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                                <a class="dropdown-toggle" data-toggle="dropdown" href="table_data_tables.html#">
                                    <i class="fa fa-wrench"></i>
                                </a>
                                <ul class="dropdown-menu dropdown-user">
                                    <li><a href="#">选项</a>
                                    </li>
                                </ul>
                                <a class="close-link">
                                    <i class="fa fa-times"></i>
                                </a>
                            </div>
                        </div>
                        <div id="loading"></div>
                        <div class="ibox-content">
                            <input id="searchtest" type="search" class="form-control input-sm" style="width: 10%;float: right" placeholder="查询：" oninput="searchData(this)">

                            <table class="table table-bordered dataTables-example" id="dataTables-example"><!-- 无分页查询功能：table table-bordered -->
                                <thead>
                                <tr>

                                    <th>部门代码</th>
                                    <th>部门名称</th>
                                    <th>部门简称</th>
                                    <th>操作</th>


                                </tr>
                                </thead>

                            </table>

                        </div>
                    </div>
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

<script src="<%=basePath%>js/plugins/jeditable/jquery.jeditable.js"></script>

<!-- Data Tables -->
<script src="<%=basePath%>js/plugins/dataTables/jquery.dataTables.js"></script>
<script src="<%=basePath%>js/plugins/dataTables/dataTables.bootstrap.js"></script>

<!-- Custom and plugin javascript -->
<script src="<%=basePath%>js/hplus.js?v=2.2.0"></script>
<script src="<%=basePath%>js/plugins/pace/pace.min.js"></script>


<!-- Page-Level Scripts -->
<script>
    $(document).ready(function () {

        $('.dataTables-example').DataTable({//绑定要遍历数据的 table 的 id

            pageLength : 25,/* 页大小，同时当前页每次加 10，不明白为什么每次增加 10 */

            serverSide : true,/* 启用服务端分页，如果前端分页，这里为 false */
            searching : false,
            ajax : {
                url : "<%=basePath%>deptcodeList",
                type : "post",
                data : {},
                dataFilter : function(json){
                    return json;
                }
            },

            /* 中间遍历的数据 */
            columns : [
                {data:"depNumber",render:function(data){return ("<input type='text' style=\"border: none;width: 100%;\" value='"+data+"'>");}},//0 这里可以 {title:"Id编码",data:"id"} //title 列头标题，则可以省略前面 html 代码里面 <table></table> 内的 <tr></tr> 标签！
                {data:"depName",render:function(data){return ("<input type='text' style=\"border: none;width: 100%;\" value='"+data+"'>");}},//1 这里的 header_title 对应后台返回的 bean 的属性值即可自动赋值显示
                {data:"alisName",render:function(data){return ("<input type='text' style=\"border: none;width: 100%;\" value='"+data+"'>");}},
                {defaultContent:"<button type=\"button\" class=\"btn btn-warning btn-sm\" onclick=\"updateConfirm(this)\">修改</button>&nbsp;&nbsp;<button type=\"button\" class=\"btn btn-warning btn-sm\" onclick=\"deleteConfirm(this)\">删除</button>"}
            ]
        });

    });

</script>
<style>

    .current {
        color: #b34927;
    }

    a:FOCUS{

        color: #b34927;

    }

</style>







<script type="text/javascript">

    $(function () {

        window.onload = function()
        {

            var $a = $('.gradeX td a');       //找到你的a标签在哪一个元素下面
            $a.click(function(){         //给a标签添加点击事件
                var $this = $(this);
                $a.removeClass();
                $this.addClass('current');
            });

        }
    });

</script>


<script>
    function insertDept() {
        var newDeptCode = $("#select2").val();
        var newDeptName = $("#newDeptName").val();

        $.ajax('<%=basePath%>deptcode/insert', {
            data: {
                newDeptcode:newDeptCode,
                newDeptName:newDeptName

            },
            success: function(data)
            {
                if (data==true)
                {
                    alert('添加成功!');
                    window.location.reload();

                }
                else
                {
                    alert('添加发生错误，请联系管理员!');
                }
            },
            error: function()
            {
                alert('服务器无响应，请联系管理员!');
            }
        });
    }

    function deleteConfirm(_this)
    {
        var number = $(_this).parent().prev().prev().prev().find('input').val();
        $.ajax('<%=basePath%>deptcode/delete', {
            dataType : 'json',
            data: {
                ids:number
            },
            success: function(data)
            {
                if (data==true)
                {
                    alert('删除成功!');
                    window.location.reload();

                }
                else
                {
                    alert('删除发生错误，请联系管理员!');
                }
            },
            error: function()
            {
                alert('服务器无响应，请联系管理员!');
            }
        });


    }
    function updateConfirm(_this)
    {
        var name1 = $(_this).parent().prev().prev().find('input').val();
        var name2 = $(_this).parent().prev().find('input').val();
        var number = $(_this).parent().prev().prev().prev().find('input').val();
        $.ajax('<%=basePath%>deptcode/update', {
            dataType : 'json',
            data: {
                name1:name1,
                name2:name2,
                number:number

            },
            success: function(data)
            {
                if (data==true)
                {
                    alert('修改成功!');
                    start = $('.dataTables-example').dataTable().fnSettings()._iDisplayStart;
                    total = $('.dataTables-example').dataTable().fnSettings().fnRecordsDisplay();
                    window.location.reload();
                    if((total-start)==1){
                        if (start > 0) {
                            $('.dataTables-example').dataTable().fnPageChange( 'previous', true );
                        }
                    }
                }
                else
                {
                    alert('修改发生错误，请联系管理员!');
                }
            },
            error: function()
            {
                alert('服务器无响应，请联系管理员!');
            }
        });


    }

    //debugger;
    $("#checkbox").click(function () {
        if(this.checked){
            $('input[name="mycheckbox"]').each(function () {
                this.checked = true;
            });
        }else {
            $('input[name="mycheckbox"]').each(function () {
                this.checked = false;
            });
        }

    })

</script>
<!-- 隐藏url列 -->
<style>
    .hide_column{
        display: none;
    }
</style>
<script src="<%=basePath%>js/plugins/layui/layui.js" charset="utf-8"></script>
<!-- 注意：如果你直接复制所有代码到本地，上述js路径需要改成你本地的 -->
<script>
    layui.use(['form', 'layedit', 'laydate'], function(){
        var form = layui.form;

        form.on('select()', function(data){
            if (data.elem.id == 'select1'){
                var code = data.value;
                $.ajax({
                    url: "<%=basePath%>deptcode/deptTwoLevel",
                    data: {
                        "deptcode":code
                    },
                    success: function(data){

                        //区
                        var deptOneLevel = data.deptOneLevel;
                        $("#select2").empty();
                        $("#select2").append(new Option('--',code+'00'));
                        jQuery.each(deptOneLevel, function(i,item){
                            var option = new Option(item.depName, item.depNumber);
                            $("#select2").append(option);

                        });

                        layui.form.render("select");
                    }
                });
            }
        });
    });

function test001() {
    $.ajax({
        url: "<%=basePath%>deptcode/deptOneLevel",
        success: function(data){

            jQuery.each(data, function(i,item){
                var option = new Option(item.depName, item.depNumber);
                $("#select1").append(option);

            });
            layui.form.render("select");
/*            $("#select1").append("<option value='"+value+"'>"+text+"</option>");


            console.log($("#select1")[1]);*/
        }
    });
}
</script>

<script>
    function searchData(_this) {
        //try
        $('#dataTables-example').dataTable().fnDestroy();

        var keyword = $('#searchtest').val();
        console.log(keyword);

        $('.dataTables-example').DataTable({//绑定要遍历数据的 table 的 id

            pageLength : 25,/* 页大小，同时当前页每次加 10，不明白为什么每次增加 10 */

            serverSide : true,/* 启用服务端分页，如果前端分页，这里为 false */
            searching : false,
            ajax : {
                url : "<%=basePath%>deptcodeList",
                type : "post",
                data : {"keyword":keyword},
                dataFilter : function(json){
                    return json;
                }
            },

            /* 中间遍历的数据 */
            columns : [
                {data:"depNumber",render:function(data){return ("<input type='text' style=\"border: none;width: 100%;\" value='"+data+"'>");}},//0 这里可以 {title:"Id编码",data:"id"} //title 列头标题，则可以省略前面 html 代码里面 <table></table> 内的 <tr></tr> 标签！
                {data:"depName",render:function(data){return ("<input type='text' style=\"border: none;width: 100%;\" value='"+data+"'>");}},//1 这里的 header_title 对应后台返回的 bean 的属性值即可自动赋值显示
                {data:"alisName",render:function(data){return ("<input type='text' style=\"border: none;width: 100%;\" value='"+data+"'>");}},
                {defaultContent:"<button type=\"button\" class=\"btn btn-warning btn-sm\" onclick=\"updateConfirm(this)\">修改</button>&nbsp;&nbsp;<button type=\"button\" class=\"btn btn-warning btn-sm\" onclick=\"deleteConfirm(this)\">删除</button>"}
            ]
        });


/*
        $('.dataTables-example').DataTable({//绑定要遍历数据的 table 的 id

            pageLength : 25,/!* 页大小，同时当前页每次加 10，不明白为什么每次增加 10 *!/

            serverSide : true,/!* 启用服务端分页，如果前端分页，这里为 false *!/
            searching : false,
            ajax : {
                url : "<%=basePath%>deptcodeList",
                type : "post",
                data : {"keyword":_this.value},
                dataFilter : function(json){
                    return json;
                }
            },

            /!* 中间遍历的数据 *!/
            columns : [
                {data:"depNumber",render:function(data){return ("<input type='text' style=\"border: none;width: 100%;\" value='"+data+"'>");}},//0 这里可以 {title:"Id编码",data:"id"} //title 列头标题，则可以省略前面 html 代码里面 <table></table> 内的 <tr></tr> 标签！
                {data:"depName",render:function(data){return ("<input type='text' style=\"border: none;width: 100%;\" value='"+data+"'>");}},//1 这里的 header_title 对应后台返回的 bean 的属性值即可自动赋值显示
                {data:"alisName",render:function(data){return ("<input type='text' style=\"border: none;width: 100%;\" value='"+data+"'>");}},
                {defaultContent:"<button type=\"button\" class=\"btn btn-warning btn-sm\" onclick=\"updateConfirm(this)\">修改</button>&nbsp;&nbsp;<button type=\"button\" class=\"btn btn-warning btn-sm\" onclick=\"deleteConfirm(this)\">删除</button>"}
            ]
        });

        $('.dataTables-example').dataTable();*/

    }
</script>

</body>

</html>