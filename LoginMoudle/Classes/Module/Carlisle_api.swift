//
//  Carlisle_api.swift
//  Carlisle
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import Foundation
import BaseMoudle
import Alamofire
import NetworkMoudle


public enum Carlisle_api {
    
    /// 用户注册
    case register(phone: String, password: String,msgCode: String)
    ///登陆
    case login(phone: String, type: String,smsCode: String)
    ///发送验证码
    case sendmsgcode(phone: String, type: String)
    ///修改密码
    case updatepassword(phone: String, password: String,msgCode: String)
    ///退出登陆
    case logout(token: String)
    ///获取jwt Token
    case getJWTToken(token: String)
    ///登陆验证
    case checkLoginPhone(phone:String, type:String)
}

extension Carlisle_api: TargetType {
    
    //请求路径
    public var path: String {
        switch self {
        case .register:
            return "user/register"
        case .login:
            return "/fmsapi/user/login.json"
        case .sendmsgcode:
            return "/fmsapi/user/getSmsCode.json"
        case .updatepassword:
            return "user/updatepassword"
        case .logout:
            return "/fmsapi/user/logout.json"
        case .getJWTToken:
            return "/fmsapi/user/logout.json"
        case .checkLoginPhone:
            return "/fmsapi/user/logout.json"
        }
    }
    
    //设置请求方式 get post等
    public var method: HTTPMethod {
        switch self {
        default:
            return .post
        }
    }
    
    /// 设置请求参数
    public var parameters: Parameters? {
        switch self {
        case let .register(phone, password ,msgCode):
            return ["phone": phone, "password": password, "msgCode": msgCode]
        case let .login(phone, type, smsCode):
            return ["phone": phone, "type": type, "smsCode":smsCode]
        case let .sendmsgcode(phone, type):
            return ["phone": phone, "type": type]
        case let .updatepassword(phone, password ,msgCode):
            return ["phone": phone, "password": password, "msgCode": msgCode]
        case let .logout(token):
            return ["token": token]
        case let .getJWTToken(token):
            return ["token": token]
        case let .checkLoginPhone(phone,type):
            return ["phone": phone, "type": type]
        default:
            return nil
        }
    }
}
