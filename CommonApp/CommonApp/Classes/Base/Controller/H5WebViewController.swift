//
//  H5WebViewController.swift
//  Mall
//
//  Created by AaronLee0619 on 2019/11/7.
//  Copyright © 2019 budian. All rights reserved.
//

import UIKit
import WebKit

class H5WebViewController: BaseViewController {
    var url : String!
    var isPresent = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.progressView.isHidden = false
        UIView.animate(withDuration: 1.0) {
            self.progressView.progress = 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBackBtns()
        self.view.addSubview(webView)
        view.addSubview(self.progressView)
        loadData()
//        initRightBtn()
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }
        
    func initBackBtns() {
        let backImage = UtilTools.imageWithImageName(name: "back_icon")
        let backItem = UIBarButtonItem.init(image: backImage, style: .plain, target: self, action: #selector(backClick))
        self.navigationItem.leftBarButtonItems = [backItem]
        self.navigationController?.interactivePopGestureRecognizer?.delegate = (self as UIGestureRecognizerDelegate)
    }
    
    func loadData() {
           /// 设置访问的URL
           if self.url != nil {
               let url = NSURL(string: self.url)
               /// 根据URL创建请求
               let request = NSURLRequest(url: url! as URL)
               /// WKWebView加载请求
               webView.load(request as URLRequest)
           }
    }
    
    // 进度条
    lazy var progressView:UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = kThemeColor()
        progress.frame = CGRect(x:0,y:0,width:self.view.frame.size.width,height:2)
        progress.trackTintColor = .clear
        return progress
    }()
    
    func initRightBtn() {
        let rightItem = UIBarButtonItem.init(image: UtilTools.imageWithImageName(name: "h5Refresh"), style: .plain, target: self, action: #selector(refresh))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func refresh(){
        loadData()
    }
    
    @objc func backClick() {
        if webView.canGoBack {
            webView.goBack()
        }else{
            if isPresent {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            // 获取网页title
            self.title = self.webView.title
        }
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "title", context: nil)
    }
    
    lazy var webView : WKWebView = {
        /// 自定义配置
        let conf = WKWebViewConfiguration()
        conf.userContentController = WKUserContentController()
        conf.preferences.javaScriptEnabled = true
        conf.selectionGranularity = WKSelectionGranularity.character
        let web = WKWebView(frame: CGRect(x: 0, y: 0, width: kScreenWIDTH, height: kScreenHEIGHT-kNavigationHeight()), configuration: conf)
        /// 设置访问的URL
        let url = NSURL(string: self.url)
        /// 根据URL创建请求
        let requst = NSURLRequest(url: url! as URL)
        web.allowsBackForwardNavigationGestures = true   //允许右滑一步步返回
        /// 设置代理
        web.uiDelegate = self
        web.navigationDelegate = self
        /// WKWebView加载请求
        return web
    }()
    
}

extension H5WebViewController:WKNavigationDelegate,WKUIDelegate{
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        self.navigationItem.title = "加载中..."
        /// 获取网页的progress
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let url = navigationAction.request.url
        if (url != nil) {
            let absoluteString = url?.absoluteString
            if ((absoluteString?.contains("open_new_page"))!) {
                let h5VC = H5WebViewController.init()
                h5VC.url = absoluteString
                self.navigationController?.pushViewController(h5VC, animated: false)
            }
        }
        return nil
    }
    
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){

    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 1.0
            self.progressView.isHidden = true
        }
    }
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){

        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 0.0
            self.progressView.isHidden = true
        }

    }

}
