//
//  Login_vm.swift
//  Carlisle
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import RxSwift
import NetworkMoudle
import SwiftyJSON
import BaseMoudle
import UserMoudle


class Login_vm : Base_Vm {
    
    let validatedPhone = Variable<ValidationResult>(.empty)
    let validatedMsgCode = Variable<ValidationResult>(.empty)
    
    let signupEnabled = Variable<Bool>(false)
    
    let loginSuccess = PublishSubject<User_Model>()
    let sendMsgSuccess = PublishSubject<JSON>()
    init(input: (
        phone: Observable<String>,
        msgCode: Observable<String>,
        loginTaps: Observable<Void>,
        msgCodeTaps: Observable<Void>
        ),
         validationService: RegisterValidationProtocol
        ) {
        
        super.init()
        
        input.loginTaps
            .withLatestFrom(Observable.combineLatest(input.phone, input.msgCode) { ($0, $1) })
            .map{Carlisle_api.login(phone: $0, type: "3", smsCode: $1)}
            .emeRequestApiForObj(User_Model.self)
            .subscribe(onNext: {[unowned self] (result) in
                switch result {
                case .success(let user):
                    //登陆成功就更新上下文中的登陆对象
                    Global.updateUserModel(user)
                    self.loginSuccess.onNext(user)
                case .failure(let error):
                    self.error.onNext(error)
                }
            })
            .disposed(by: disposeBag)
        
        input.msgCodeTaps
        .withLatestFrom(input.phone)
        .filter { (phone) -> Bool in
            let rel = validationService.validatePhone(phone)
            if rel.isValid == false{
                self.error.onNext(MikerError("获取短信验证码时需要验证手机号", code: 2202, message: rel.message))
            }
            return rel.isValid
        }
        .map{Carlisle_api.sendmsgcode(phone: $0, type: "3")}
        .emeRequestApiForRegJson()
        .subscribe(onNext: {[unowned self] (result) in
            switch result {
            case .success(let data):
                self.sendMsgSuccess.onNext(data)
            case .failure(let error):
                self.error.onNext(error)
            }
        })
        .disposed(by: disposeBag)
        
        input.phone
            .map{validationService.validateUsername($0)}
            .bind(to: validatedPhone)
            .disposed(by: disposeBag)
        input.msgCode
            .map{validationService.validateMsgCode($0)}
            .bind(to: validatedMsgCode)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                validatedPhone.asObservable(),
                validatedMsgCode.asObservable()
            ){$0.isValid && $1.isValid }
            .distinctUntilChanged()
            .bind(to: signupEnabled)
            .disposed(by: disposeBag)
    }
}
