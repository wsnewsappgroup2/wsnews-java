package com.crow.controller;

import com.crow.webmagic.downloader.CrowProxyProvider;
import com.crow.webmagic.pageprocessor.HupuNBAPageProcessor;
import com.crow.webmagic.pipeline.HupuSpiderPipeline;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import us.codecraft.webmagic.Spider;
import us.codecraft.webmagic.downloader.HttpClientDownloader;
import us.codecraft.webmagic.proxy.Proxy;

/**
 * Created by CrowHawk on 17/10/8.
 */
@RestController
public class StartSpiderController {

    @Autowired
    HupuSpiderPipeline hupuSpiderPipeline;
    /*
    @Autowired
    ProxyIpMapper proxyIpMapper;
    */
    @GetMapping("/")
    public String index() {

        /*
        List<ProxyIp> proxyList = proxyIpMapper.findAllProxies();
        proxyList = proxyList.subList(0,10);
        List<Proxy> proxies = new ArrayList<>(proxyList.size());
        for(ProxyIp proxyIp : proxyList) {
            proxies.add(new Proxy(proxyIp.getIp(), proxyIp.getPort()));
        }
        */
        HttpClientDownloader httpClientDownloader = new HttpClientDownloader();
        //设置动态转发代理，使用定制的ProxyProvider
        httpClientDownloader.setProxyProvider(CrowProxyProvider.from(new Proxy("forward.xdaili.cn", 80)));

        Spider.create(new HupuNBAPageProcessor())
                //new PostInfoPageProcessor())
                //.setDownloader(httpClientDownloader)
                .addUrl("https://voice.hupu.com/nba/1")
                //.addUrl("http://blog.sina.com.cn/s/articlelist_1487828712_0_1.html")
                .addPipeline(hupuSpiderPipeline)
                .thread(4)
                .run();
        return "爬虫开启";
    }
}
