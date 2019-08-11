package com.crow.controller;

import com.alibaba.fastjson.JSONObject;
import com.crow.service.UserActionSerivce;
import com.crow.utils.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * Created By wangyq1
 * 用于用户个人相关的响应控制
 * */
@RestController
public class UserActionController {

    @Autowired
    UserActionSerivce userActionSerivce;



    /**添加用户个人评论**/
    @PostMapping(value = "/wsnews/news/news_add_comment",consumes = "application/json",produces = "application/json;charset=UTF-8")
    public String addUserComment(
            @RequestHeader(value = "Authorization",required = false) String token,
            @RequestBody(required=false) Map<String,Object> map){
        // TODO: 根据接口文档修改返回类型 和 newsId的获取
        String openId= JwtUtil.getOpenid(token);
        String comment="评论内容";
        Integer newsId=1;
        if(openId!=null && newsId!=null){
            userActionSerivce.addNewUserComment(openId,comment,newsId);
            JSONObject response=new JSONObject();
            response.put("success",true);
            return response.toJSONString();
        }else{
            JSONObject response=new JSONObject();
            response.put("success",false);
            return response.toJSONString();
        }
    }

    /**更新单个新闻列表的收藏状态**/
    @PostMapping(value = "/wsnews/news/news_favor",consumes = "application/json",produces = "application/json;charset=UTF-8")
    public String updateNewsCollectedStatus(
            @RequestHeader(value = "Authorization",required = false) String token,
            @RequestBody(required=false) Map<String,Object> map){
        Integer newsId=(Integer)map.get("newsId");
        Boolean hasCollect=(Boolean)map.get("hasCollect");
        String openId= JwtUtil.getOpenid(token);

        if(openId!=null && hasCollect!=null && newsId!=null){
            userActionSerivce.updateNewsCollectedStatus(newsId,hasCollect,openId);
            JSONObject response=new JSONObject();
            // TODO: 根据接口文档修改
            response.put("success",true);
            return response.toJSONString();
        }else{
            JSONObject response=new JSONObject();
            // TODO: 根据接口文档修改
            response.put("success",false);
            return response.toJSONString();
        }
    }


    /**更新单个新闻列表的点赞状态**/
    @PostMapping(value = "/wsnews/news/news_praise",consumes = "application/json",produces = "application/json;charset=UTF-8")
    public String updateNewsThumbsUpedStatus(
            @RequestHeader(value = "Authorization",required = false) String token,
            @RequestBody(required=false) Map<String,Object> map){
        Integer newsId=(Integer)map.get("newsId");
        Boolean hasThumbUp=(Boolean)map.get("hasThumbUp");
        String openId= JwtUtil.getOpenid(token);

        if(openId!=null && hasThumbUp!=null && newsId!=null){
            userActionSerivce.updateNewsThumbsUpStatus(newsId,hasThumbUp,openId);
            JSONObject response=new JSONObject();
            // TODO: 根据接口文档修改
            response.put("success",true);
            return response.toJSONString();
        }else{
            JSONObject response=new JSONObject();
            // TODO: 根据接口文档修改
            response.put("success",false);
            return response.toJSONString();
        }
    }
}