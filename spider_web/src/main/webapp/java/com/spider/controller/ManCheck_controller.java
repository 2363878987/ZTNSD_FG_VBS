package com.spider.controller;

import cn.hutool.core.io.FileUtil;
import cn.hutool.core.io.IORuntimeException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ifeng.auto.we_provider.common.db.DynamicDataSourceHolder;
import com.spider.bean.*;
import com.spider.elemente.TimerParm;
import com.spider.service.*;
import com.spider.utils.DataTablePageUtil;
import com.spider.utils.NioFileUtil;
import com.spider.utils.StringUtil;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * <p>
 * ManCheck_controller
 * </p>
 *
 * @author msi-
 * @package: com.spider.controller
 * @description: 人工审查模块
 * @date: Created in 2020-07-30 9:14
 * @copyright: Copyright (c) 2020
 * @version: V1.0
 * @modified: msi-
 */
@Controller
@RequestMapping("manCheck")
public class ManCheck_controller {

    @Autowired
    private Main_service main_service;

    @Autowired
    private MainCHLandLAR_service mainCHLandLAR_service;

    @Autowired
    private TXwInformation_service information_service;

    @Autowired
    private ErrorLog_service errorLog_service;


    //展示所有 zyzd
    @RequestMapping("markList")
    public String getInformationPipelinemarkList(@RequestParam(required = false,value = "column")String column,HttpServletRequest request,Model model){
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);

        //获取地方库新闻数据
        List<MarkdetailMainWithBLOBs> mainList = main_service.getMarkList("zyzd",column);

        //获取不同分类的统计数据
        String data = main_service.groupColumnStatus("zyzd");

        model.addAttribute("mainList",mainList);
        model.addAttribute("data",data);

        return "_informationTmpManCheck/_informationTmpManCheckListMark";
    }


    //展示所有 dfzd
    @RequestMapping("markList_lar")
    public String getInformationPipelinemarkList_lar(@RequestParam(required = false,value = "column")String column,HttpServletRequest request,Model model){
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);

        //获取地方库新闻数据
        List<MarkdetailMainWithBLOBs> mainList = main_service.getMarkList("dfzd",column);

        //获取不同分类的统计数据
        String data = main_service.groupColumnStatus("dfzd");

        model.addAttribute("mainList",mainList);
        model.addAttribute("data",data);

        return "_informationTmpManCheck/_informationTmpManCheckListMark_lar";
    }

    //标记
    @RequestMapping("mark")
    @ResponseBody
    public boolean mark(@RequestParam("number")long number,@RequestParam("markcolumn")String markcolumn){
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);

        MainWithBLOBs main = new MainWithBLOBs();
        main.setNumber(number);
        main.setAnyou("mark");//标记为删除状态
        main_service.markUpdate(main,markcolumn);

        //将附件 复制到history 目录下
        MainWithBLOBs mainByNumber = main_service.getMainByNumber(number);
        String attachmentpath = TimerParm.fjPath5 + File.separator + mainByNumber.getRjs8().substring(0,mainByNumber.getRjs8().indexOf(".")) ;

        try {
            FileUtil.copy(attachmentpath,TimerParm.fjPath5_history,true);
        }catch (IORuntimeException e){
            e.printStackTrace();
        }

        //将txt 复制到history 目录下
        String filepath = TimerParm.txtPath5 + File.separator + mainByNumber.getAppuser()+File.separator+mainByNumber.getRjs8() ;
        String targetpath = TimerParm.txtPath5_history+ File.separator + mainByNumber.getAppuser();

        File file = new File(targetpath);
        if (!file.exists()){
            file.mkdirs();
        }

        try {
            FileUtil.copy(filepath,targetpath,true);
        }catch (IORuntimeException e){
            e.printStackTrace();
        }

        return true;

    }


    //逻辑删除
    @RequestMapping("virtualDelete")
    @ResponseBody
    public boolean virtualDelete(@RequestParam("number")long number){
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);

        MainWithBLOBs main = new MainWithBLOBs();
        main.setNumber(number);
        main.setTruetag1(1);//标记为删除状态
        if(main_service.update(main)){
            return true;
        }else {
            return false;
        }
    }

    //重命名附件
    @RequestMapping("resetFileName")
    @ResponseBody
    public boolean resetFileName(@RequestParam(value = "filename")String filename,@RequestParam(value = "oldname")String oldname,@RequestParam(value = "number")long number) throws UnsupportedEncodingException {
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);
        MainWithBLOBs mainByNumber = main_service.getMainByNumber(number);

        //附件重命名
        String attachmentPATH = TimerParm.fjPath5 + File.separator + mainByNumber.getRjs8().substring(0,mainByNumber.getRjs8().indexOf("."))+ File.separator + URLDecoder.decode(URLDecoder.decode(oldname,"UTF-8"),"UTF-8");
        FileUtil.rename(new File(attachmentPATH),URLDecoder.decode(URLDecoder.decode(filename,"UTF-8"),"UTF-8"),true);

        //数据库字段回填
        MainWithBLOBs main = new MainWithBLOBs();
        main.setFjian(mainByNumber.getFjian().replace(URLDecoder.decode(URLDecoder.decode(oldname,"UTF-8"),"UTF-8"),URLDecoder.decode(URLDecoder.decode(filename,"UTF-8"),"UTF-8")));
        main.setNumber(mainByNumber.getNumber());

        return main_service.update(main);

    }


    //上传附件 (加锁  避免数据库维护失败)
    @RequestMapping("upload")
    @ResponseBody
    public synchronized boolean upload(
            @RequestParam("file") MultipartFile file,
            @RequestParam("number") long number,
            HttpServletRequest request) {

        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);
        MainWithBLOBs mainByNumber = main_service.getMainByNumber(number);
        String path = TimerParm.fjPath5 + File.separator + mainByNumber.getRjs8().substring(0,mainByNumber.getRjs8().indexOf(".")) ;

        //判断file数组不能为空并且长度大于0
        if(file!=null){
            MultipartFile files = file;
            //保存文件
            saveFile(files, path);

            //维护数据库
            String fjian = "";
            if (StringUtils.isNotBlank(mainByNumber.getFjian())) {
                //已有附件  拼接在已有字符串后面
                fjian = mainByNumber.getFjian() + "|" + files.getOriginalFilename();


            } else {
                //没有附件  直接set
                fjian = files.getOriginalFilename();
            }
            MainWithBLOBs main = new MainWithBLOBs();
            main.setFjian(fjian);
            main.setNumber(mainByNumber.getNumber());
            main_service.update(main);


        }
        // 重定向
        return true;
    }

    private boolean saveFile(MultipartFile file, String path) {
        // 判断文件是否为空
        if (!file.isEmpty()) {
            try {
                File filepath = new File(path);
                if (!filepath.exists())
                    filepath.mkdirs();
                // 文件保存路径
                String savePath = path +File.separator+ file.getOriginalFilename();
                // 转存文件
                file.transferTo(new File(savePath));
                return true;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    //删除附件
    @RequestMapping("delAttachment")
    @ResponseBody
    public boolean delAttachment(@RequestParam(value = "filename")String filename,@RequestParam(value = "number")long number) throws UnsupportedEncodingException {
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);
        //删除附件
        MainWithBLOBs mainByNumber = main_service.getMainByNumber(number);
        String attachmentPATH = TimerParm.fjPath5 + File.separator + mainByNumber.getRjs8().substring(0,mainByNumber.getRjs8().indexOf("."))+ File.separator + URLDecoder.decode(URLDecoder.decode(filename,"UTF-8"),"UTF-8");
        FileUtil.del(attachmentPATH);
        //维护数据库信息
        String newsfjian = "";
        String[] attachments = mainByNumber.getFjian().split("\\|");
        for (String attachment : attachments) {
            if (attachment.equals(URLDecoder.decode(URLDecoder.decode(filename,"UTF-8"),"UTF-8"))){
                continue;
            }
            newsfjian+=attachment+"|";
        }

        MainWithBLOBs main = new MainWithBLOBs();
        main.setFjian(newsfjian.substring(0,newsfjian.length()-1));
        main.setNumber(mainByNumber.getNumber());





        return main_service.update(main);

    }

    //修改
    @RequestMapping("update")
    @ResponseBody
    public Boolean update(InformationPipelineWithBLOBs information, HttpServletResponse response,Model model) throws IOException {
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);

        //为了获取正文不得不通过  informationPipeline 转换一下

        MainWithBLOBs main = new MainWithBLOBs(Long.parseLong(information.getExtend2()),information.getNewstitle(),information.getDeptcode(),information.getReleasetime(),information.getImptime(),information.getDeptname(),information.getFilenum(),information.getRjs1(),information.getKeyword());
        if (main_service.update(main)){
            //正文按照页面上 的数据写回到txt中
            String contextPath = TimerParm.txtPath5 + File.separator + information.getExtend3() + File.separator +information.getFilename();
            //FileUtil.writeString(information.getNewscontent(),contextPath,"GBK");
            writeTxt(contextPath,information.getNewscontent().replaceAll("\n", "\r\n"));

            //正文按照页面上 的数据写回到 hting/txt中(兼容旧法规工具)
            String contextCopyPath = TimerParm.txtCopyPath5 + File.separator +information.getFilename();
            //FileUtil.writeString(information.getNewscontent(),contextCopyPath,"GBK");
            writeTxt(contextCopyPath,information.getNewscontent().replaceAll("\n", "\r\n"));
            return Boolean.TRUE;
        }else {
            return Boolean.FALSE;
        }
    }

    //修改
    @RequestMapping("markUpdate")

    public void markUpdate(InformationPipelineWithBLOBs information, HttpServletResponse response,Model model) throws IOException {
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);

        //为了获取正文不得不通过  informationPipeline 转换一下

        MainWithBLOBs main = new MainWithBLOBs(Long.parseLong(information.getExtend2()),information.getNewstitle(),information.getDeptcode(),information.getReleasetime(),information.getImptime(),information.getDeptname(),information.getFilenum(),information.getRjs1(),information.getKeyword());
        if (main_service.update(main)){
            //正文按照页面上 的数据写回到txt中
            String contextPath = TimerParm.txtPath5 + File.separator + information.getExtend3() + File.separator +information.getFilename();
            FileUtil.writeString(information.getNewscontent(),contextPath,"GBK");
            //正文按照页面上 的数据写回到 hting/txt中(兼容旧法规工具)
            String contextCopyPath = TimerParm.txtCopyPath5 + File.separator +information.getFilename();
            FileUtil.writeString(information.getNewscontent(),contextCopyPath,"GBK");

            response.sendRedirect("markDetail/"+information.getExtend2());

        }

    }

    //附件下载
    @RequestMapping("downLoadAttachment/{id}/{fjName}")
    @ResponseBody
    public String downLoadAttachment(@PathVariable("id")long id,@PathVariable("fjName")String fjName, HttpServletRequest request, HttpServletResponse response){
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);
        MainWithBLOBs mainByNumber = main_service.getMainByNumber(id);


        String attachmentPATH = TimerParm.fjPath5 + File.separator + mainByNumber.getRjs8().substring(0,mainByNumber.getRjs8().indexOf("."));

        String[] split = mainByNumber.getFjian().split("\\|");

        // 下载本地文件
        fjName = fjName.replaceAll("-",".");
        String fileName = attachmentPATH+File.separator+fjName; // 文件的默认保存名
        // 读到流中
        InputStream inStream = null;// 文件的存放路径
        try {
            inStream = new FileInputStream(fileName);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        // 设置输出的格式
        response.reset();
        response.setContentType("bin");

        try {



            //response.addHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(fjName, "utf-8") + "\"");

            response.setHeader("Content-Disposition", "inline; filename=" + URLEncoder.encode(fjName, "utf-8"));
            response.setContentType(getContentType(fjName));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        // 循环取出流中的数据
        byte[] b = new byte[1024];
        int len;
        try {
            while ((len = inStream.read(b)) > 0)
                response.getOutputStream().write(b, 0, len);
            inStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }

    //返回附件下载地址
    @RequestMapping("downloadFJ")
    @ResponseBody
    public String downloadFJ(@RequestParam(value = "id")long id,HttpServletRequest request){
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);
        MainWithBLOBs mainByNumber = main_service.getMainByNumber(id);

        StringBuilder resu = new StringBuilder();
        //link
        String link = TimerParm.fjPath5 + File.separator + mainByNumber.getRjs8().substring(0,mainByNumber.getRjs8().indexOf("."));
        //name
        String fjian = mainByNumber.getFjian();
        String[] split = fjian.split("\\|");
        int count = 0;
        for (String fjName:split
                ) {
            resu.append("<p><a id=\"fjian"+count+"\" href=\"javascript:void(0);\" onclick=\"downLoadAttachment('"+id+"','"+count+"')\">"+fjName+"</a></p>");
            count++;
        }

        return resu.toString();


    }
    //人工审查的新闻可以从 tmp临时库  导入到  chl正式库
    @RequestMapping("output")
    @ResponseBody
    public String output(@RequestParam("ids")String ids,HttpServletRequest request){


        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);
        String[] id = ids.trim().split(" ");
        //获取临时库新闻数据
        List<MainWithBLOBs> tmpMainList = main_service.getMainByNumbers(id);

        //导出到chl
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_CHL);

        boolean flag = true;
        Map<String, Integer> maxRjs8 = getMaxRjs8ForMain("chl");//本次导出起始位置
        for (MainWithBLOBs mainWithBLOBs : tmpMainList) {
            //if (StringUtils.isBlank(mainWithBLOBs.getAnyou())) {

                int beginNum = maxRjs8.get("beginNum");
                int endNum = maxRjs8.get("endNum");
                if(endNum<999) {
                    endNum = ++endNum;
                }else {
                    beginNum = ++beginNum;
                    endNum=1;
                }

                maxRjs8.put("beginNum",beginNum);
                maxRjs8.put("endNum",endNum);
                if (intoCHL(mainWithBLOBs, request,maxRjs8)) {

                    String[] numbers = {mainWithBLOBs.getNumber() + ""};
                    DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
                    DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);
                    flag = main_service.deleteByNumbers(numbers);
                    //此处需要换回正式库数据源 后期考虑 添加和删除分开处理

                    DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
                    DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_CHL);
                } else {
                    flag = false;
                }
/*            }else {
                copyCHL(mainWithBLOBs, request);
            }*/
        }


        return flag == true?"导出成功":"导出失败";
    }

    //人工审查的新闻可以从 tmp临时库  导入到  lar正式库
    @RequestMapping("output_lar")
    @ResponseBody
    public String output_lar(@RequestParam("ids")String ids,HttpServletRequest request){
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);
        String[] id = ids.trim().split(" ");
        //获取地方库新闻数据
        List<MainWithBLOBs> tmpMainList = main_service.getMainByNumbers(id);

        //导出到lar
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_LAR);

        boolean flag = true;
        Map<String, Integer> maxRjs8 = getMaxRjs8ForMain("lar");//本次导出起始位置
        for (MainWithBLOBs mainWithBLOBs : tmpMainList) {
            //if (mainWithBLOBs.getAnyou()==null) { //为了标记模块对比使用

                int beginNum = maxRjs8.get("beginNum");
                int endNum = maxRjs8.get("endNum");
                if(endNum<999) {
                    endNum = ++endNum;
                }else {
                    beginNum = ++beginNum;
                    endNum=1;
                }

                maxRjs8.put("beginNum",beginNum);
                maxRjs8.put("endNum",endNum);

                if (intoCHL(mainWithBLOBs, request,maxRjs8)) {

                    DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
                    DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);
                    flag = main_service.deleteNumber(mainWithBLOBs.getNumber().toString());

                    //此处需要换回正式库数据源 后期考虑 添加和删除分开处理
                    DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
                    DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_LAR);
                } else {
                    flag = false;
                }
/*            }else {
                copyCHL(mainWithBLOBs, request);
            }*/
        }

        return flag == true?"导出成功":"导出失败";
    }

    //标记后的详情页面
    @RequestMapping("markDetail/{number}")
    public String markDetail(@PathVariable(value = "number")String number,Model model){
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);

        //获取地方库新闻数据
        MarkdetailMainWithBLOBs main = main_service.getMainMarkByNumber(Long.parseLong(number));

        String contentHistory = readHistoryTxt(main.getAppuser(),main.getRjs8());
        StringBuffer contentbuffer = new StringBuffer(contentHistory);
        StringBuffer contentBuffer=StringUtil.txtFormat(contentbuffer);

//-------------------------------------------------------------------------------------attachment
        //附件集合返回对象

        ArrayList<HashMap> attachmentList = new ArrayList<HashMap>();


        //获取附件信息

        String attachmentPath = TimerParm.fjPath5+File.separator+(main.getRjs8().substring(0,main.getRjs8().indexOf(".")));

        //文件路径
        List<File> files = FileUtil.loopFiles(attachmentPath);
        if (files.size()>0){
            for (File file : files) {
                if (file.getName().indexOf(".db")>-1){
                    continue;
                }else {
                    HashMap attachment = new HashMap();
                    attachment.put("filename", file.getName());
                    attachment.put("size", (file.length() / 1024) + "kb");
                    attachment.put("status", "原始文件");

                    attachmentList.add(attachment);
                }
            }
        }
//-------------------------------------------------------------------------------------attachment

        model.addAttribute("contentHistory",contentHistory);
        model.addAttribute("contentBuffer",contentBuffer);
        model.addAttribute("attachmentList",attachmentList);
        model.addAttribute("mainMark",main);

        return "_informationTmpManCheck/_informationTmpManCheckDetail_mark";
    }

    //详情
    @RequestMapping("detail/{number}")
    public String detail(@PathVariable(value = "number")String number,Model model){
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);

        //获取地方库新闻数据
        MainWithBLOBs main = main_service.getMainByNumber(Long.parseLong(number));
        String content = readTxt(main.getAppuser(),main.getRjs8());
        StringBuffer contentbuffer = new StringBuffer(content);
        StringBuffer contentBuffer=StringUtil.txtFormat(contentbuffer);

//-------------------------------------------------------------------------------------attachment
        //附件集合返回对象

        ArrayList<HashMap> attachmentList = new ArrayList<HashMap>();


        //获取附件信息

        String attachmentPath = TimerParm.fjPath5+File.separator+(main.getRjs8().substring(0,main.getRjs8().indexOf(".")));

        //文件路径
        List<File> files = FileUtil.loopFiles(attachmentPath);
        if (files.size()>0){
            for (File file : files) {
                if (file.getName().indexOf(".db")>-1){
                    continue;
                }else {
                HashMap attachment = new HashMap();
                attachment.put("filename",file.getName());
                attachment.put("size",(file.length()/1024)+"kb");
                attachment.put("status","原始文件");

                attachmentList.add(attachment);
                }
            }
        }
//-------------------------------------------------------------------------------------attachment
        model.addAttribute("main",main);
        model.addAttribute("content",content);
        model.addAttribute("contentBuffer",contentBuffer);
        model.addAttribute("attachmentList",attachmentList);

        return "_informationTmpManCheck/_informationTmpManCheckDetail";
    }

    private String readTxt(String appuser,String filename) {
        String contextPath = TimerParm.txtPath5 + File.separator + appuser + File.separator +filename;
        try {
            String resu = FileUtil.readString(contextPath,"GBK");
            return resu;
        }catch (Exception e){
            System.out.println("本次随机抽取存在无正文新闻！");
            return "";
        }

    }

    private String readHistoryTxt(String appuser,String filename) {
        String contextPath = TimerParm.txtPath5_history + File.separator + appuser + File.separator +filename;
        try {
            String resu = FileUtil.readString(contextPath,"GBK");
            return resu;
        }catch (Exception e){
            e.printStackTrace();
            return "";
        }

    }

    //展示随机二十五篇新闻 中央
    @RequestMapping("randomTwentyFive")
    public String randomTwentyFive(@RequestParam(value = "informationIds")String informationIds, Model model){
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);

        //获取中央库新闻数据
        List<MainWithBLOBs> mainList = main_service.getListByAppuser("zyzd",null,null);

        for (MainWithBLOBs mainWithBLOBs : mainList) {
            mainWithBLOBs.setContentSize(readTxt(mainWithBLOBs.getAppuser(),mainWithBLOBs.getRjs8()).length());
        }

        mainList = priorityRex(mainList,informationIds);



        for (MainWithBLOBs mainWithBLOBs : mainList) {
            if (StringUtils.isNotBlank(mainWithBLOBs.getFjian())) {
                String[] fj = mainWithBLOBs.getFjian().split("\\|");
                mainWithBLOBs.setFj_count(fj.length);
            }else {
                mainWithBLOBs.setFj_count(0);
            }
        }
        model.addAttribute("mainList",mainList);

        return "_informationTmpManCheck/_informationTmpManCheckRandomList";
    }



    //展示随机二十五篇新闻 地方
    @RequestMapping("randomTwentyFive_lar")
    public String randomTwentyFive_lar(@RequestParam(value = "informationIds")String informationIds,Model model){
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);

        //获取地方库新闻数据
        List<MainWithBLOBs> mainList = main_service.getListByAppuser("dfzd",null,null);

        for (MainWithBLOBs mainWithBLOBs : mainList) {
            mainWithBLOBs.setContentSize(readTxt(mainWithBLOBs.getAppuser(),mainWithBLOBs.getRjs8()).length());
        }

        mainList = priorityRex(mainList,informationIds);



        for (MainWithBLOBs mainWithBLOBs : mainList) {
            if (StringUtils.isNotBlank(mainWithBLOBs.getFjian())) {
                String[] fj = mainWithBLOBs.getFjian().split("\\|");
                mainWithBLOBs.setFj_count(fj.length);
            }else {
                mainWithBLOBs.setFj_count(0);
            }
        }
        model.addAttribute("mainList",mainList);


        return "_informationTmpManCheck/_informationTmpManCheckRandomList_lar";
    }
    //删除
    @RequestMapping("delete")
    @ResponseBody
    public boolean delete(@RequestParam("ids")String ids){
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);

        String[] id = ids.trim().split(" ");
        List<MainWithBLOBs> mainByNumbers = main_service.getMainByNumbers(id);
        if(main_service.deleteByNumbers(id)){


            for (MainWithBLOBs mainByNumber : mainByNumbers) {


                try {

                    //删除txt
                    NioFileUtil.deleteIfExists(Paths.get(TimerParm.txtPath5 + File.separator +mainByNumber.getAppuser()+ File.separator +mainByNumber.getRjs8()));
                    //删除hting/txt
                    NioFileUtil.deleteIfExists(Paths.get(TimerParm.txtCopyPath5 + File.separator + mainByNumber.getRjs8()));
                    //删除附件
                    NioFileUtil.deleteIfExists(Paths.get(TimerParm.fjPath5 + File.separator + mainByNumber.getRjs8().substring(0,mainByNumber.getRjs8().indexOf("."))));


                } catch (IOException e) {
                    e.printStackTrace();
                }

            }
            return true;
        }else {

            return false;
        }

    }

    //展示所有 zyzd
    @RequestMapping("list")
    @ResponseBody
    public Object getInformationPipelineList(@RequestParam(required = false)String keyword,HttpServletRequest request,Model model){
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);

        DataTablePageUtil dataTablePageUtil = new DataTablePageUtil();
        Integer draw = Integer.parseInt(request.getParameter("draw"));//该参数取出来，不做任何操作，再传回去即可
        Integer start = Integer.parseInt(request.getParameter("start"));//配合求当前页，第一次传进来是 0，然后 10，20，30 ……
        Integer pageSize = Integer.parseInt(request.getParameter("length"));//【页大小】


        Map resu = main_service.getLimitListByAppuser(start,pageSize,"zyzd",keyword);

        List<MainWithBLOBs> mainList = (List<MainWithBLOBs>) resu.get("mainList");
        int total = (int) resu.get("total");

        for (MainWithBLOBs mainWithBLOBs : mainList) {

            DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
            DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_DEFAULT);
            TXwInformation information =  information_service.findWebsiteBySource(mainWithBLOBs.getLinksource());
            if (information!=null){
                mainWithBLOBs.setAppuser(information.getId().toString());
                DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
                DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);
                List<TblErrorLog> errorLogListByInformationID = errorLog_service.getErrorLogListByInformationID(information.getId(), 100002);
                if (errorLogListByInformationID!=null){
                    mainWithBLOBs.setTruetag1(errorLogListByInformationID.size());
                }
            }



            if (StringUtils.isNotBlank(mainWithBLOBs.getFjian())) {
                String[] fj = mainWithBLOBs.getFjian().split("\\|");
                mainWithBLOBs.setFj_count(fj.length);
            }else {
                mainWithBLOBs.setFj_count(0);
            }

            mainWithBLOBs.setNunbers(mainWithBLOBs.getNumber().toString());
        }
        Object stringToValue = dataTablePageUtil.parseDataTableValue(draw, mainList, total);


        return stringToValue;
    }




    //展示所有 dfzd
    @RequestMapping("list_lar")
    @ResponseBody
    public Object getInformationPipelineListlar(@RequestParam(required = false)String keyword,HttpServletRequest request,Model model){
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);

        DataTablePageUtil dataTablePageUtil = new DataTablePageUtil();
        Integer draw = Integer.parseInt(request.getParameter("draw"));//该参数取出来，不做任何操作，再传回去即可
        Integer start = Integer.parseInt(request.getParameter("start"));//配合求当前页，第一次传进来是 0，然后 10，20，30 ……
        Integer pageSize = Integer.parseInt(request.getParameter("length"));//【页大小】

        //获取地方库新闻数据
        Map resu = main_service.getLimitListByAppuser(start,pageSize,"dfzd",keyword);

        List<MainWithBLOBs> mainList = (List<MainWithBLOBs>) resu.get("mainList");
        int total = (int) resu.get("total");
        for (MainWithBLOBs mainWithBLOBs : mainList) {

            DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
            DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_DEFAULT_LAR);
            TXwInformation information =  information_service.findWebsiteBySource(mainWithBLOBs.getLinksource());
            if (information!=null){
                mainWithBLOBs.setAppuser(information.getId().toString());
                DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
                DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_B);
                List<TblErrorLog> errorLogListByInformationID = errorLog_service.getErrorLogListByInformationID(information.getId(), 100003);
                if (errorLogListByInformationID!=null){
                    mainWithBLOBs.setTruetag1(errorLogListByInformationID.size());
                }
            }


            if (StringUtils.isNotBlank(mainWithBLOBs.getFjian())) {
                String[] fj = mainWithBLOBs.getFjian().split("\\|");
                mainWithBLOBs.setFj_count(fj.length);
            }else {
                mainWithBLOBs.setFj_count(0);
            }
            mainWithBLOBs.setNunbers(mainWithBLOBs.getNumber().toString());
        }

        Object stringToValue = dataTablePageUtil.parseDataTableValue(draw, mainList, total);


        return stringToValue;
    }

    public boolean copyCHL(MainWithBLOBs tmpmain,HttpServletRequest request){
        //--------------------------------------------------------------------------参数


        DecimalFormat df = new DecimalFormat("000");

        //文件移动工具
        NioFileUtil fileUtil = new NioFileUtil();


        String txtPath = tmpmain.getRjs8();
        String dirPath = txtPath.substring(0,txtPath.indexOf("."));// E:\\target\\tmptxt\\zyzd005s074
        String oldFileName = tmpmain.getRjs8();

        String chlFileNamePrefix = tmpmain.getAppuser().equals("zyzd")?"chl":"lar";


        Map<String, Integer> maxRjs8 = getMaxRjs8ForMain(chlFileNamePrefix);//统一导出到aaa 账户
        int beginNum = maxRjs8.get("beginNum");
        int endNum = maxRjs8.get("endNum");
        if(endNum<999) {
            endNum++;
        }else {
            beginNum++;
            endNum=1;
        }

        String dirname = df.format(beginNum);

        String chlFileName = chlFileNamePrefix+df.format(beginNum)+"s"+df.format(endNum)+".txt";
        String chlFileDir = chlFileNamePrefix+df.format(beginNum)+"s"+df.format(endNum);

        Main_CHLandLAR main = new Main_CHLandLAR();
        main.setRjs0(tmpmain.getRjs0());
        main.setRjs4(tmpmain.getRjs4());
        main.setRjs5(tmpmain.getRjs5());
        main.setRjs6(tmpmain.getRjs6());
        main.setRjs7(tmpmain.getRjs7());
        main.setRjs8(chlFileNamePrefix+df.format(beginNum)+"s"+df.format(endNum)+".txt"); //filename 保存文件的文件名
        main.setRjs9((short)1);
        main.setRjs10(tmpmain.getRjs10());
        main.setRjs12(tmpmain.getRjs12());
        main.setAppuser(tmpmain.getTruetag1()==null?tmpmain.getAppuser()+"1":tmpmain.getTruetag1()==9?tmpmain.getAppuser()+"9":tmpmain.getAppuser()+"1");
        main.setLinksource(tmpmain.getLinksource());
        main.setFjian(tmpmain.getFjian()); //附件名

        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");
        main.setUpdatetime(Integer.parseInt(simpleDateFormat.format(new Date())));//当前日期
        main.setAppdate(new Date());

        main.setRjs1(tmpmain.getRjs1());
        main.setKword(tmpmain.getKword());
        main.setLawlevel(5);
        main.setTruetag(1);
        main.setRjs14(tmpmain.getRjs14());
        main.setRjs15(tmpmain.getRjs15());
        mainCHLandLAR_service.insert(main);


        try {

            //先重命名文件夹
            //NioFileUtil.reNameFile(TimerParm.fjPath5 + File.separator + dirPath, chlFileDir);//zyzd001s001 == > zyzd

            FileUtil.rename(new File(TimerParm.fjPath5 + File.separator + dirPath),chlFileDir,true);
            //附件文件夹移动到。5挂载文件夹下
            //Path start = Paths.get(TimerParm.fjPath5 + File.separator + chlFileDir);
            //Path target = Paths.get(TimerParm.fjPath5_chl+ File.separator +chlFileNamePrefix);
            String start = TimerParm.fjPath5 + File.separator + chlFileDir;
            String target = TimerParm.fjPath5_chl+ File.separator +chlFileNamePrefix;
            //移动附件之前先判断目标地址中是否存在重名文件夹 如果存在则先删除掉目标文件夹
            //NioFileUtil.deleteIfExists(Paths.get(TimerParm.fjPath5_chl + File.separator + chlFileNamePrefix + File.separator +chlFileDir));
            FileUtil.del(Paths.get(TimerParm.fjPath5_chl + File.separator + chlFileNamePrefix + File.separator +chlFileDir));
            //在移动
            FileUtil.copy(start, target,true);


            //txt移动到  正式 文件夹下
            //重命名文件

            //NioFileUtil.reNameFile(TimerParm.txtPath5 + File.separator + tmpmain.getAppuser() + File.separator +oldFileName), chlFileName);

            FileUtil.rename(new File(TimerParm.txtPath5 + File.separator + tmpmain.getAppuser() + File.separator +oldFileName),chlFileName,true);

            File start1 = new File(TimerParm.txtPath5 + File.separator + tmpmain.getAppuser() + File.separator +chlFileName);
            File target2 = new File(TimerParm.txt_chlPath+ File.separator + chlFileNamePrefix+File.separator +dirname);
            //移动之前先判断目标地址中是否存在重名文件 如果存在则先删除掉目标文件
            //NioFileUtil.deleteIfExists(Paths.get(TimerParm.txt_chlPath + File.separator + chlFileNamePrefix + File.separator +dirname+File.separator +chlFileName));

            FileUtil.del(TimerParm.txt_chlPath + File.separator + chlFileNamePrefix + File.separator +dirname+File.separator +chlFileName);
            //生成文件夹
            File chlTxtDir = new File(TimerParm.txt_chlPath + File.separator + chlFileNamePrefix + File.separator +dirname);
            if (!chlTxtDir.exists()){
                chlTxtDir.mkdir();
            }
            //移动
            //FileUtil.move(start1,target2,true);
            FileUtil.copy(start1,target2,true);

            //删除 hting 的txt

            //NioFileUtil.deleteIfExists(Paths.get(TimerParm.txtCopyPath5 + File.separator + oldFileName));
            FileUtil.del(TimerParm.txtCopyPath5 + File.separator + oldFileName);

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean intoCHL(MainWithBLOBs tmpmain,HttpServletRequest request,Map<String, Integer> maxRjs8){
        //--------------------------------------------------------------------------参数

        DecimalFormat df = new DecimalFormat("000");

        //文件移动工具
        NioFileUtil fileUtil = new NioFileUtil();


        String txtPath = tmpmain.getRjs8();
        String dirPath = txtPath.substring(0,txtPath.indexOf("."));// E:\\target\\tmptxt\\zyzd005s074
        String oldFileName = tmpmain.getRjs8();

        String chlFileNamePrefix = tmpmain.getAppuser().equals("zyzd")?"chl":"lar";


        //Map<String, Integer> maxRjs8 = getMaxRjs8ForMain(chlFileNamePrefix);//统一导出到aaa 账户

        int beginNum = maxRjs8.get("beginNum");
        int endNum = maxRjs8.get("endNum");
/*        if(endNum<999) {
            endNum++;
        }else {
            beginNum++;
            endNum=1;
        }*/

        String dirname = df.format(beginNum);

        String chlFileName = chlFileNamePrefix+df.format(beginNum)+"s"+df.format(endNum)+".txt";
        String chlFileDir = chlFileNamePrefix+df.format(beginNum)+"s"+df.format(endNum);

        Main_CHLandLAR main = new Main_CHLandLAR();
        main.setRjs0(tmpmain.getRjs0());
        main.setRjs4(tmpmain.getRjs4());
        main.setRjs5(tmpmain.getRjs5());
        main.setRjs6(tmpmain.getRjs6());
        main.setRjs7(tmpmain.getRjs7());
        main.setRjs8(chlFileNamePrefix+df.format(beginNum)+"s"+df.format(endNum)+".txt"); //filename 保存文件的文件名
        main.setRjs9((short)1);
        main.setRjs10(tmpmain.getRjs10());
        main.setRjs11("");
        main.setRjs12(tmpmain.getRjs12());
        main.setAppuser(tmpmain.getTruetag1()==null?tmpmain.getAppuser()+"1":tmpmain.getTruetag1()==9?tmpmain.getAppuser()+"9":tmpmain.getAppuser()+"1");
        main.setLinksource(tmpmain.getLinksource());
        main.setFjian(tmpmain.getFjian()); //附件名

        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");
        main.setUpdatetime(Integer.parseInt(simpleDateFormat.format(new Date())));//当前日期
        main.setAppdate(new Date());

        main.setRjs1(tmpmain.getRjs1());
        main.setKword(tmpmain.getKword());
        main.setLawlevel(5);
        main.setTruetag(1);
        main.setRjs14(tmpmain.getRjs14());
        main.setRjs15(tmpmain.getRjs15());

        mainCHLandLAR_service.insert(main);

        //errorLogIntoChl(main,cloumn); 推送到正式库的数据需要把错误日志记录到error_log表（杨老师设计）


        try {

            //先重命名文件夹
            //NioFileUtil.reNameFile(TimerParm.fjPath5 + File.separator + dirPath, chlFileDir);//zyzd001s001 == > zyzd

            FileUtil.rename(new File(TimerParm.fjPath5 + File.separator + dirPath),chlFileDir,true);
            //附件文件夹移动到。5挂载文件夹下
            //Path start = Paths.get(TimerParm.fjPath5 + File.separator + chlFileDir);
            //Path target = Paths.get(TimerParm.fjPath5_chl+ File.separator +chlFileNamePrefix);
            String start = TimerParm.fjPath5 + File.separator + chlFileDir;
            String target = TimerParm.fjPath5_chl+ File.separator +chlFileNamePrefix;
            //移动附件之前先判断目标地址中是否存在重名文件夹 如果存在则先删除掉目标文件夹
            //NioFileUtil.deleteIfExists(Paths.get(TimerParm.fjPath5_chl + File.separator + chlFileNamePrefix + File.separator +chlFileDir));
            FileUtil.del(Paths.get(TimerParm.fjPath5_chl + File.separator + chlFileNamePrefix + File.separator +chlFileDir));
            //在移动
            FileUtil.copy(start, target,true);


            //txt移动到  正式 文件夹下
            //重命名文件

            //NioFileUtil.reNameFile(TimerParm.txtPath5 + File.separator + tmpmain.getAppuser() + File.separator +oldFileName), chlFileName);

            FileUtil.rename(new File(TimerParm.txtPath5 + File.separator + tmpmain.getAppuser() + File.separator +oldFileName),chlFileName,true);

            File start1 = new File(TimerParm.txtPath5 + File.separator + tmpmain.getAppuser() + File.separator +chlFileName);
            File target2 = new File(TimerParm.txt_chlPath+ File.separator + chlFileNamePrefix+File.separator +dirname);
            //移动之前先判断目标地址中是否存在重名文件 如果存在则先删除掉目标文件
            //NioFileUtil.deleteIfExists(Paths.get(TimerParm.txt_chlPath + File.separator + chlFileNamePrefix + File.separator +dirname+File.separator +chlFileName));

            FileUtil.del(TimerParm.txt_chlPath + File.separator + chlFileNamePrefix + File.separator +dirname+File.separator +chlFileName);
            //生成文件夹
            File chlTxtDir = new File(TimerParm.txt_chlPath + File.separator + chlFileNamePrefix + File.separator +dirname);
            if (!chlTxtDir.exists()){
                chlTxtDir.mkdir();
            }
            //移动
            //FileUtil.move(start1,target2,true);
            FileUtil.copy(start1,target2,true);

            //删除 hting 的txt

            //NioFileUtil.deleteIfExists(Paths.get(TimerParm.txtCopyPath5 + File.separator + oldFileName));
            FileUtil.del(TimerParm.txtCopyPath5 + File.separator + oldFileName);


            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    //查询已导出的法规数据txt文件的最大值 main表
    public Map<String,Integer> getMaxRjs8ForMain(String username) {
        Map<String,Integer> resu = new HashMap<String,Integer>();

        long startTime = System.currentTimeMillis();
        String rjs8 = main_service.getMaxRjs8(username);
        System.out.println("获取最大值用时："+(System.currentTimeMillis()-startTime));
        //String rjs8 = informationPipeline_service.getMaxRjs8(username);
        int beginNum = 1;
        int endNum = 0;
        if (rjs8!=null) {
            String maxTxtName = rjs8;
            if (maxTxtName != null) {
                maxTxtName = maxTxtName.replaceAll(username, "");
                maxTxtName = maxTxtName.replaceAll(".txt", "");
                if (maxTxtName.matches("\\d+s\\d+")) {
                    String[] arr = maxTxtName.split("s");

                    beginNum = Integer.valueOf(arr[0]);
                    endNum = Integer.valueOf(arr[1]);
                }
            }
        }
        resu.put("beginNum",beginNum);
        resu.put("endNum",endNum);
        return resu;
    }

    private List<MainWithBLOBs> priorityRex(List<MainWithBLOBs> mainList,String informationIds) {

        //选中得新闻
        String[] _informationIds = {};
        if (StringUtils.isNotBlank(informationIds)) {
            _informationIds = informationIds.split(" ");
        }
        //初始化得分


        String[] deptCodes = {"/1","/2","/3", "/6", "/7"};
        for (MainWithBLOBs mainWithBLOB : mainList) {
            int score = 0;
            //1、优先抽查以下部门代码/1 /2 /3 /6 /7 ;
            for (String deptCode : deptCodes) {
                if (StringUtils.isNotBlank(mainWithBLOB.getRjs4())){
                    if (mainWithBLOB.getRjs4().equals(deptCode)){
                        score += 1;
                    }
                }else {
                    break;
                }
            }
            //2、没有附件的数据。

            if (mainWithBLOB.getFjian()==null){
                score += 1;
            }

            //3、优先抽查文字小于100个

            if (mainWithBLOB.getContentSize()<100){
                score += 1;
            }
            //4、步骤一页面 选中得新闻
            for (String number : _informationIds) {
                if (mainWithBLOB.getNumber().equals(Long.parseLong(number))){
                    score += 1;
                }
            }
            mainWithBLOB.setCompare_score(score);
        }

        Collections.sort(mainList, Main.MAIN_BY_SCORE);

        return mainList;


    }


    private void errorLogIntoChl(Main_CHLandLAR main, String cloumn) {
        //此处需要换回正式库数据源 后期考虑 添加和删除分开处理
        DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
        DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_DEFAULT);
        HashMap<String,String> map = new HashMap<String,String>();
        TXwInformation information =  information_service.findWebsiteBySource(main.getLinksource());
        if (information!=null){
            map.put("websiteid",information.getWebsiteid().toString());
            map.put("informationid",information.getId().toString());
            map.put("rjs8",main.getRjs8());
            if (cloumn.equals("chl")){
                //此处需要换回正式库数据源 后期考虑 添加和删除分开处理
                DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
                DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_CHL);
            }else {
                //此处需要换回正式库数据源 后期考虑 添加和删除分开处理
                DynamicDataSourceHolder.clearCustomerType();//重点： 实际操作证明，切换的时候最好清空一下
                DynamicDataSourceHolder.setCustomerType(DynamicDataSourceHolder.DATA_SOURCE_LAR);
            }
            errorLog_service.insertByTmpErrorLog(map);

        }

    }
    
    //写出txt文件
    public void writeTxt(String filePath,String executString){


        BufferedWriter writer = null;
        try {
            writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(filePath),"GBK"));
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        try {
            writer.write(executString);
            writer.flush();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    public  String getContentType(String fileName){
        //文件名后缀
        String fileExtension = fileName.substring(fileName.lastIndexOf("."));
        if(".bmp".equalsIgnoreCase(fileExtension)) {
            return "image/bmp";
        }
        if(".gif".equalsIgnoreCase(fileExtension)) {
            return "image/gif";
        }
        if(".jpeg".equalsIgnoreCase(fileExtension) || ".jpg".equalsIgnoreCase(fileExtension)  || ".png".equalsIgnoreCase(fileExtension) ){
            return "image/jpeg";
        }
        if(".html".equalsIgnoreCase(fileExtension)){
            return "text/html";
        }
        if(".txt".equalsIgnoreCase(fileExtension)){
            return "text/plain";
        }
        if(".vsd".equalsIgnoreCase(fileExtension)){
            return "application/vnd.visio";
        }
        if(".ppt".equalsIgnoreCase(fileExtension) || "pptx".equalsIgnoreCase(fileExtension)) {
            return "application/vnd.ms-powerpoint";
        }
        if(".doc".equalsIgnoreCase(fileExtension) || "docx".equalsIgnoreCase(fileExtension)) {
            return "application/msword";
        }
        if(".xml".equalsIgnoreCase(fileExtension)) {
            return "text/xml";
        }
        return "image/jpeg";
    }

}