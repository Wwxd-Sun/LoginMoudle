//
//  AgreementWeb_vc.swift
//  Alamofire
//
//  Created by sunbaocai on 2020/9/17.
//

import Foundation
import BaseMoudle
import WebKit
class AgreementWeb_vc: Base_Vc {
    var wkWebVIew: WKWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "用户协议"
        self.customLeftBarButtonItem()
        self.wkWebVIew = WKWebView(frame: CGRect(x: 0, y: 0, width: screen_Width, height: screen_Height))
//        self.wkWebVIew?.backgroundColor = UIColor(hex: "#f4f4f4")
        view.addSubview(wkWebVIew)
        //创建网址
        let webPath = CarlisleCore.bundle?.path(forResource: "FMSUserPrivacyPolicy", ofType: "doc")
        
        let url = URL(fileURLWithPath: webPath!)
//        let request = URLRequest(url: url!)
        //加载请求
        self.wkWebVIew!.loadFileURL(url, allowingReadAccessTo: url)

        // Do any additional setup after loading the view.
    }
    
    /**
     自定义leftBarButtonItem
     */
    override func customLeftBarButtonItem() {
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "iconfontback", in: CarlisleCore.bundle, compatibleWith: nil), style: .plain, target: self, action: #selector(backToView))
        
    }
}
