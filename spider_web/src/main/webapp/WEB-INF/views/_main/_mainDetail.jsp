<%--
  Created by IntelliJ IDEA.
  User: msi-
  Date: 2020/12/4
  Time: 15:09
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
<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">


    <title>正式库数据编辑 - 数据详情</title>
    <link rel="shortcut icon" href="<%=basePath%>favicon.ico">
    <link href="<%=basePath%>h+_ui/css/bootstrap.min.css?v=3.3.5" rel="stylesheet">
    <link href="<%=basePath%>h+_ui/css/font-awesome.min.css?v=4.4.0" rel="stylesheet">

    <!-- Morris -->
    <link href="<%=basePath%>h+_ui/css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">

    <!-- Gritter -->
    <link href="<%=basePath%>h+_ui/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">

    <link href="<%=basePath%>h+_ui/css/animate.min.css" rel="stylesheet">
    <link href="<%=basePath%>h+_ui/css/style.min.css?v=4.0.0" rel="stylesheet"><base target="_blank">

    <!-- 自由添加 -->
    <link href="<%=basePath%>css/plugins/dataTables/dataTables.bootstrap.css" rel="stylesheet">
    <link href="<%=basePath%>css/animate.css" rel="stylesheet">
    <link href="<%=basePath%>css/style.css?v=2.2.0" rel="stylesheet">
    <link href="<%=basePath%>js/plugins/layui/css/layui.css" rel="stylesheet">
    <link href="<%=basePath%>css/plugins/iCheck/custom.css" rel="stylesheet">

</head>

<body class="gray-bg">
<div class="row wrapper border-bottom white-bg page-heading">
    <div class="col-lg-10">

        <h2>数据详情</h2>
        <ol class="breadcrumb">
            <li>
                <a>正式库数据列表</a>
            </li>
            <li>
                <strong>数据详情</strong>
            </li>
        </ol>
    </div>
    <div class="col-lg-2">
             <span style="float: right;margin-top: 30px;">
                    <a href="${main.linksource}" target="_blank" class="btn btn-primary">来源</a>
            </span>
    </div>

</div>
<div class="wrapper wrapper-content">
    <div class="row">
        <div class="col-lg-12">
            <%--                <div class="wrapper wrapper-content">
                                <div class=" animated fadeInRightBig">

                                    <p>    标题：${main.rjs0}</p>
                                    <p>    文号：${main.rjs12}</p>
                                    <p>    发布日期：${main.rjs5}</p>
                                    <p>    正文：</p>

                                </div>
                                <textarea autoHeight="true" readonly="readonly" style="width:100%">${content}</textarea>
                            </div>--%>
            <div class="ibox float-e-margins" style="padding-top: 10px;margin-bottom: 50px;">

                <div class="ibox-content">
                    <form id="signupForm" class="form-horizontal m-t" onsubmit="return PostData()">
                        <input id="extend2" name="extend2" value="${main.rid}" type="hidden">
                        <input id="filename" name="filename" value="${main.rjs8}" type="hidden">
                        <input id="extend3" name="extend3" value="${main.appuser}" type="hidden">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">标题：</label>
                            <div class="col-sm-8">

                                <input  id="newstitle" name="newstitle" value="${main.rjs0}" type="text" class="form-control">

                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">文号：</label>
                            <div class="col-sm-8">

                                <input id="filenum" name="filenum"  value="${main.rjs12}" type="text" class="form-control">

                            </div>
                        </div>


                        <div class="form-group">
                            <label class="col-sm-3 control-label">部门代码：</label>
                            <div class="col-sm-8">

                                <input id="deptcode" name="deptcode"  value="${main.rjs4}" type="text" class="form-control">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">部门名称：</label>
                            <div class="col-sm-8">

                                <input id="deptname" name="deptname"  value="${main.rjs10}" type="text" class="form-control">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">实时日期：</label>
                            <div class="col-sm-8">

                                <input id="imptime" name="imptime"  value="${main.rjs6}" type="text" class="form-control">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">发布日期：</label>
                            <div class="col-sm-8">

                                <input id="releasetime" name="releasetime"  value="${main.rjs5}" type="text" class="form-control">
                            </div>
                        </div>


                        <div class="form-group">
                            <label class="col-sm-3 control-label">所属分类：</label>
                            <div class="col-sm-8">

                                <input id="rjs1" name="rjs1"  value="${main.rjs1}" type="text" class="form-control">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">关键字：</label>
                            <div class="col-sm-8">

                                <input id="keyword" name="keyword"  value="${main.kword}" type="text" class="form-control">
                            </div>

                        </div>



                        <div class="form-group">
                            <label class="col-sm-3 control-label">附件：</label>
                            <div class="col-sm-8">
                                <%-- <input type="file" multiple="multiple">--%>


                                <div class="layui-upload">
                                    <button type="button" class="layui-btn layui-btn-normal" id="testList">选择多文件</button>
                                    <div class="layui-upload-list">
                                        <table class="layui-table">
                                            <thead>
                                            <tr><th>文件名</th>
                                                <th>大小</th>
                                                <th>状态</th>
                                                <th>操作</th>
                                            </tr></thead>
                                            <tbody id="demoList"></tbody>
                                            <c:forEach items="${attachmentList}" var="attachment" varStatus="xb">
                                                <tr>
                                                    <td><input type="text" style="border: none;overflow: hidden;height: 100%;width: 100%;" value="${attachment.filename}"  onBlur="resetFileName('${attachment.filename}',this)"></td>
                                                    <td>${attachment.size}</td>
                                                    <td>${attachment.status}</td>
                                                    <td>
                                                        <button type="button" class="layui-btn layui-btn-xs layui-btn-danger my-delete" onclick="myDelButten('${main.rid}',this)">删除</button>
                                                        <button type="button" class="layui-btn layui-btn-xs layui-btn-danger my-download" onclick="myDownloadButten('${main.rid}',this)">下载</button>
                                                    </td>
                                                </tr>

                                            </c:forEach>
                                        </table>
                                    </div>
                                    <button type="button" class="layui-btn" id="testListAction">开始上传</button>
                                </div>

                            </div>
                        </div>

                        <div class="form-group" >
                            <label class="col-sm-3 control-label"></label>
                            <div class="col-sm-8">
                                <div class="checkbox">
                                    <label style="margin-left: -20px;"><input type="radio" name="myradio" id="myradio0" value="0" onclick="javascript:checkMo(0);">排版模式</label>
                                    <label style="margin-left: 10px;"> <input type="radio" name="myradio" id="myradio1" value="1" onclick="javascript:checkMo(1);">编辑模式</label>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-sm-3 control-label">正文：</label>

                            <div class="col-sm-8" id="newscontent22">
                                ${contentBuffer}
                            </div>

                            <div class="col-sm-8" id="newscontent11">

                                <textarea  id="newscontent"   name="newscontent"  style="height: 1000px" class="form-control" required="" aria-required="true">${content}</textarea>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-sm-4 col-sm-offset-3">
                                <button class="btn btn-primary" type="submit" style="float: right;">保存</button>
                            </div>

                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>

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



<!-- 文件上传插件 -->
<script src="http://yanshi.sucaihuo.com/modals/40/4078/demo/js/plugins/prettyfile/bootstrap-prettyfile.js"></script>
<!-- 文本对比插件 -->
<script src="http://yanshi.sucaihuo.com/modals/40/4078/demo/js/plugins/diff_match_patch/diff_match_patch.js"></script>
<script src="<%=basePath%>js/jquery.pretty-text-diff.min.js"></script>




<script>
    $('input[type="file"]').prettyFile();
</script>
<!-- layui -->
<script src="<%=basePath%>js/plugins/layui/layui.js" charset="utf-8"></script>

<script>
    $(function(){
        $.fn.autoHeight = function(){
            function autoHeight(elem){
                elem.style.height = 'auto';
                elem.scrollTop = 0; //防抖动
                elem.style.height = elem.scrollHeight + 'px';
            }
            this.each(function(){
                autoHeight(this);
                $(this).on('keyup', function(){
                    autoHeight(this);
                });
            });
        }
        $('textarea[autoHeight]').autoHeight();
    })
</script>
<!-- jQuery Validation plugin javascript-->
<%--<script src="<%=basePath%>js/plugins/validate/jquery.validate.min.js"></script>
<script src="<%=basePath%>js/plugins/validate/messages_zh.min.js"></script>--%>
<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.3/dist/jquery.validate.js"></script>
<script>


    //以下为官方示例
    $().ready(function () {
        checkMo(0);

        // validate signup form on keyup and submit
        var validator = $("#signupForm").validate({
            rules: {
                newstitle:{
                    required:true
                },
                deptcode:{
                    required:true
                },
                deptname:{
                    required:true
                },
                rjs1:{
                    required:true
                },
                keyword:{
                    required:true
                },
                imptime: {
                    required:true,
                    regDate:true
                },
                releasetime: {
                    required:true,
                    regDate:true
                }
            },
            messages:
                {
                    newstitle:{
                        required:"标题不能为空"
                    },

                    deptcode:{
                        required:"部门代码不能为空"
                    },
                    deptname:{
                        required:"部门名称不能为空"
                    },
                    rjs1:{
                        required:"所属分类不能为空"
                    },
                    keyword:{
                        required:"关键字不能为空"
                    },
                    imptime:
                        {
                            required: "实施日期不能为空"
                        },
                    releasetime:
                        {
                            required: "发布日期不能为空"
                        }
                }
        });

        jQuery.validator.addMethod("regDate", function (value,element) {
            var postcode=/^[0-9]{4}|[0-9]{8}$/;
            return this.optional(element)||(postcode.test(value));
        },"日期格式不规范！（请至少输入4位确定一个年份）");

    });
</script>


<!-- layui -->
<script>
    layui.use('upload', function(){
        var $ = layui.jquery
            ,upload = layui.upload;


        //多文件列表示例
        var demoListView = $('#demoList')
            ,uploadListIns = upload.render({
            elem: '#testList'
            ,url: '<%=basePath%>main/upload' //改成您自己的上传接口
            ,data: {'number':'${main.rid}'}
            ,accept: 'file'
            ,multiple: true
            ,auto: false
            ,bindAction: '#testListAction'
            ,choose: function(obj){
                var files = this.files = obj.pushFile(); //将每次选择的文件追加到文件队列
                //读取本地文件
                obj.preview(function(index, file, result){
                    var tr = $(['<tr id="upload-'+ index +'">'
                        ,'<td>'+ '<input type=\"text\" style=\"border: none;overflow: hidden;height: 100%;width: 100%;\" value=\"'+file.name+'\"  onBlur=\"resetFileName(\''+file.name+'\',this)\">' +'</td>'
                        ,'<td>'+ (file.size/1024).toFixed(1) +'kb</td>'
                        ,'<td>等待上传</td>'
                        ,'<td>'
                        ,'<button class="layui-btn layui-btn-xs demo-reload layui-hide">重传</button>'
                        ,'<button class="layui-btn layui-btn-xs layui-btn-danger demo-delete">删除</button>'
                        ,'</td>'
                        ,'</tr>'].join(''));

                    //单个重传
                    tr.find('.demo-reload').on('click', function(){
                        obj.upload(index, file);
                    });

                    //删除
                    tr.find('.demo-delete').on('click', function(){
                        delete files[index]; //删除对应的文件
                        tr.remove();
                        uploadListIns.config.elem.next()[0].value = ''; //清空 input file 值，以免删除后出现同名文件不可选
                    });

                    demoListView.append(tr);
                });
            }
            ,done: function(res, index, upload){
                if(res){ //上传成功
                    var tr = demoListView.find('tr#upload-'+ index)
                        ,tds = tr.children();
                    tds.eq(2).html('<span style="color: #5FB878;">上传成功</span>');
                    tds.eq(3).html('<button class="layui-btn layui-btn-xs layui-btn-danger my-delete" onclick="myDelButten(\'${main.rid}\',this)">删除</button> <button type="button" class="layui-btn layui-btn-xs layui-btn-danger my-download" onclick="myDownloadButten(\'${main.rid}\',this)">下载</button>'); //如果还想删除则调用删除接口
                    return delete this.files[index]; //删除文件队列已经上传成功的文件
                }
                this.error(index, upload);
            }
            ,error: function(index, upload){
                var tr = demoListView.find('tr#upload-'+ index)
                    ,tds = tr.children();
                tds.eq(2).html('<span style="color: #FF5722;">上传失败</span>');
                tds.eq(3).find('.demo-reload').removeClass('layui-hide'); //显示重传
            }
        });

    });


    //自定义  删除按钮操作
    function myDelButten(number,_this) {
        //调用ajax删除磁盘文件
        console.log(number)
        var filename = $(_this).parent().prev().prev().prev().find('input').val();
        $.ajax({
            url: "<%=basePath%>main/delAttachment",
            data:{"filename":encodeURI(filename),"number":number},
            success: function(){
                //删除成功删除掉对应行
                var $trNode = $(_this).parent().parent();//对应的tr
                $trNode.remove();//删除
            }
        });


    }

    function checkMo(flag) {
        //	alert(123);
        var s=flag;
        $("#myradio"+flag).attr("checked",true)
        if(s==1){
            $("#newscontent11").show();
            $("#newscontent22").hide();
        }else{
            $("#newscontent11").hide();
            $("#newscontent22").show(); //文本
        }
        // return reg.test(htmlStr);

    }
</script>
<script type="text/javascript">
    function resetFileName(oldname,_this) {
        var filename  =  _this.value;
        var oldname  =  oldname;
        var num = $('#extend2').val();
        console.log("num="+num);
        console.log("filename="+filename);
        console.log("oldname="+oldname);
        $.ajax({
            async:false,
            url: "<%=basePath%>main/resetFileName",
            data:{"filename":encodeURI(filename),"number":num,"oldname":encodeURI(oldname)},
            success: function(){

            }
        });
    }
</script>
<script type="text/javascript">
    //自定义  下载按钮操作
    function myDownloadButten(number,_this) {
        var filename = $(_this).parent().prev().prev().prev().find('input').val();
        filename = filename.replace(new RegExp("\\.","gm"),"-");
        window.location.href="<%=basePath%>main/downLoadAttachment/"+number+"/"+filename;
    }
</script>
<script type="text/javascript">

    function PostData() {

        var extend2 = $('#extend2').val();
        var filename = $('#filename').val();
        var extend3 = $('#extend3').val();
        var newstitle = $('#newstitle').val();
        var filenum = $('#filenum').val();
        var deptcode = $('#deptcode').val();
        var deptname = $('#deptname').val();
        var imptime = $('#imptime').val();
        var releasetime = $('#releasetime').val();
        var rjs1 = $('#rjs1').val();
        var keyword = $('#keyword').val();
        var newscontent = $('#newscontent').val();



        if($("#signupForm").valid()) {
            $.ajax({
                type: "POST",
                url: "<%=basePath%>main/update",
                data: {
                    extend2: extend2,
                    filename: filename,
                    extend3: extend3,
                    newstitle: newstitle,
                    filenum: filenum,
                    deptcode: deptcode,
                    deptname: deptname,
                    imptime: imptime,
                    releasetime: releasetime,
                    rjs1: rjs1,
                    keyword: keyword,
                    newscontent: newscontent
                },
                success: function (msg) {
                    alert("保存成功！")
                }
            });
        }
        return false;
    }
</script>

</html>
