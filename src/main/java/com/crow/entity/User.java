package com.crow.entity;

public class User {
    // 用户在应用内的唯一标识
    private String openid;
    // 用户的会话密钥
    private String session_key;
    // 用户在开放平台的唯一标识符，在满足 UnionID 下发条件的情况下会返回
    private String unionid;
    // 用户名
    private String username;

    public void setOpenid(String openid) {
        this.openid = openid;
    }

    public void setSession_key(String session_key) {
        this.session_key = session_key;
    }

    public void setUnionid(String unionid) {
        this.unionid = unionid;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getOpenid() {
        return openid;
    }

    public String getSession_key() {
        return session_key;
    }

    public String getUnionid() {
        return unionid;
    }

    public String getUsername() {
        return username;
    }
}
