package com.crow.controller;

import com.crow.result.*;
import com.crow.service.NewsService;
import com.crow.service.UserCommentService;
import com.crow.utils.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Created by wangyq1
 * Last Modified By wangyq1 2019.8.8
 */
@RestController
public class NewsController {

    @Autowired
    private NewsService newsService;
    @Autowired
    UserCommentService userCommentService;

    /**查询用户个人栏目列表**/
    @GetMapping(value = "/wsnews/query_private_column")
    public ColumnsInfoResult getPersonalColumn(
            @RequestHeader(value = "Authorization",required = false) String token){
        String openid= JwtUtil.getOpenid(token);
        return newsService.getPersonalColums(openid);
    }

    /**获取所有的栏目列表**/
    @GetMapping(value = "/wsnews/query_common_column")
    public ColumnsInfoResult getAllColumns(
            @RequestHeader(value = "Authorization",required = false) String token){
        return newsService.getAllColumns();
    }

    /**(上拉)获取目标栏目下的（含推荐栏目）的新闻列表**/
    @GetMapping(value = "/wsnews/query_news/{columnId}/{page}/{pagesize}")
    public CommonResult<List<NewsListResult>> getNewsListInColumn(
            @RequestHeader(value = "Authorization",required = false) String token,
            @PathVariable(value = "columnId",required = false) Integer columnId,
            @PathVariable(value = "page",required = false) Integer page,
            @PathVariable(value = "pagesize",required = false) Integer pageSize){
        return newsService.getNewsListByColumn(columnId,page,pageSize);
    }

    /**下拉获取推荐新闻**/
    @GetMapping(value = "/wsnews/news_recommend/{columnId}")
    public CommonResult<List<NewsListResult>> getRecommendedNewsList(
            @RequestHeader(value = "Authorization",required = false) String token,
            @PathVariable(value = "columnId",required = false) Integer columnId){
        String openId=JwtUtil.getOpenid(token);
        return newsService.getRecommendedNewsListByColumnId(columnId,openId);
    }

    /**新闻搜索**/
    @GetMapping(value = "/wsnews/news_search/{keyword}/{page}/{pagesize}")
    public CommonResult<List<NewsListResult>> searchNews(
            @RequestHeader(value = "Authorization",required = false) String token,
            @PathVariable("keyword") String keyword,
            @PathVariable("page") Integer page,
            @PathVariable("pagesize") Integer pageSize){
        return newsService.vagueSearch(keyword,page,pageSize);
    }

    /**单个新闻信息页**/
    @GetMapping(value = "/wsnews/news/news_info/{newsId}")
    public CommonResult<NewsDetailResult> getSingleNew(
            @RequestHeader(value = "Authorization",required = false) String token,
            @PathVariable("newsId") Integer newsId){
        newsService.addNewClickRecord(token,newsId);
        return newsService.getSingleNewsContentById(newsId,token);
    }


    /**获取与单个新闻列表相关评论**/
    @GetMapping(value = "/wsnews/news/news_comments/{newsId}")
    public CommonResult<List<NewsCommentResult>> getNewsCommentsByNewsId(
            @PathVariable("newsId") Integer newsId){
        return userCommentService.getLatestCommentsByNewsId(newsId);
    }

}