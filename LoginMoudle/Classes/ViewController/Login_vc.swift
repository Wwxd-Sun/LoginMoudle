//
//  Login_vc.swift
//  Carlisle
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import RxSwift
import BaseMoudle
//import EmptyDataView
import MJRefresh
import ConfigMoudle
import UserMoudle
import SwiftyUserDefaults

class Login_vc: Base_Vc {
    
    /****************************Storyboard UI设置区域****************************/
    @IBOutlet weak var username_tf: UITextField!
    @IBOutlet weak var password_tf: UITextField!
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var forget_btn: UIButton!
    
    @IBOutlet weak var rember_btn: UIButton!
    @IBOutlet weak var register_btn: UIButton!
    @IBOutlet weak var indicator_v: UIActivityIndicatorView!
    /*----------------------------   自定义属性区域
     ----------------------------*/
    
    /*----------------------------   自定义属性区域    ----------------------------*/
    /// 计时器
    var countdownTimer: Timer?
    
    var remainingSeconds: Int = 0 {
        willSet {
            forget_btn.setTitle("\(newValue)秒", for: .normal)
            if newValue <= 0 {
                forget_btn.setTitle("获取验证码", for: .normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Login_vc.updateTime(_:)), userInfo: nil, repeats: true)
                remainingSeconds = 60
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
            }
            forget_btn.isEnabled = !newValue
        }
    }
    
    
    var manageVm: Login_vm?
    var present:Bool = false
    
    /****************************Storyboard 绑定方法区域****************************/
    
    /// 表示是否是present出来的 如果是的话导航栏需要显示关闭按钮 否则不显示
    
    /**************************** 以下是方法区域 ****************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    let validatedUsername = PublishSubject<ValidationResult>()
    /**
     界面基础设置
     */
    override func setupUI() {
//        login_btn.loginTheme()
        /**
         *  自定义 导航栏左侧 返回按钮
         */
//        self.customLeftBarButtonItem()
        
        if Global.isRember() {
            self.password_tf.text = Global.password()
        }
        self.username_tf.text = Global.userName()
//        self.rember_btn.isSelected = Global.isRember()
    }
    /**
     app 主题 设置
     */
    override func setViewTheme() {
        
    }
    /**
     绑定到viewmodel 设置
     */
    override func bindToViewModel() {
        
        self.register_btn.rx.tap
            .subscribe(onNext: {
                let webView = AgreementWeb_vc()
                self.navigationController?.pushViewController(webView, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        
        
        self.forget_btn.rx.tap
            .subscribe(onNext: { [unowned self] ( _ ) in
                self.forget_btn.isEnabled = false
                self.forget_btn.alpha = 0.2;
            })
            .disposed(by: disposeBag)
        
        /**
         *  初始化viewmodel
         */
        
        self.manageVm = Login_vm(
            input: (
                phone: Observable.of(
                Observable.just( username_tf.text ?? ""),
                username_tf.rx.text.orEmpty.asObservable()
                )
                .merge(),
                msgCode: Observable.of(
                Observable.just( password_tf.text ?? ""),
                password_tf.rx.text.orEmpty.asObservable()
                )
                .merge(),
                loginTaps: login_btn.rx.tap.asObservable(),
                msgCodeTaps: forget_btn.rx.tap.asObservable()),
            validationService: RegisterImplementations())
        self.manageVm?.signupEnabled.asObservable()
            .subscribe(onNext: { [weak self] valid  in
                self?.login_btn.isEnabled = valid
                self?.login_btn.alpha = valid ? 1 : 0.2
            })
            .disposed(by: disposeBag)
        
        self.manageVm?.validatedPhone
        .asObservable()
        .subscribe(onNext: {[unowned self] (result) in
            if result.isValid && self.remainingSeconds == 0{
                self.forget_btn.isEnabled = true
                self.forget_btn.alpha = 1;
            }else{
                self.forget_btn.alpha = 0.2;
                self.forget_btn.isEnabled = false
            }
        })
        .disposed(by: disposeBag)
        
        self.manageVm?.loginSuccess
            .subscribe(onNext: { [unowned self] (result) in
//                Global.updateIsRember(self.rember_btn.isSelected)
                Global.updateUserName(self.username_tf.text ?? "")
//                if self.rember_btn.isSelected {
//                    Global.updatePassword(self.password_tf.text ?? "")
//                }
                self.view.toastCompletion("登陆成功", completion: { _ in
                    self.closeVc()
                })
            })
            .disposed(by: disposeBag)
        
        self.manageVm?.sendMsgSuccess
        .subscribe(onNext: {[unowned self] (json) in
            if UtilCore.sharedInstance.isDebug{
                self.view.toast("已发送")
            }
            self.isCounting = true
        })
        .disposed(by: disposeBag)
        
        self.manageVm?
        .error
        .asObserver()
        .subscribe(onNext: { [unowned self] (_) in
            self.remainingSeconds = 0
            self.isCounting = false
        })
        .disposed(by: disposeBag)
        
        self.manageVm?
            .error
            .asObserver()
            .bind(to: self.view.rx_error)
            .disposed(by: disposeBag)
        
    }
    
    /**
     自定义leftBarButtonItem
     */
    override func customLeftBarButtonItem() {
        
        if self.present {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "iconclose", in: CarlisleCore.bundle, compatibleWith: nil), style: .plain, target: self, action: #selector(closeVc))
        }
    }
    
    @objc func closeVc() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - 自定义方法
extension  Login_vc {
    
    @objc func updateTime( _ timer: Timer) {
        remainingSeconds -= 1
    }
}
