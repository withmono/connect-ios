//
//  MonoViewController.swift
//  
//
//  Created by Umar Abdullahi on 28/09/2020.
//

import Foundation
import UIKit
import WebKit

public class MonoViewController: UIViewController, WKUIDelegate {
    var publicKey: String
    let closeHandler: (() -> Void?)
    let successHandler: ((_ authCode: String) -> Void?)
    var progressView: UIProgressView
    
    init(publicKey: String, onClose: @escaping (() -> Void?), onSuccess: @escaping ((_ authCode: String) -> Void?)) {
        self.publicKey = publicKey
        self.successHandler = onSuccess
        self.closeHandler = onClose
        
        self.progressView = UIProgressView(progressViewStyle: .bar)
        self.progressView.sizeToFit()
        super.init(nibName: nil, bundle: nil)
        
        self.progressView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 2, height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
       webView.removeObserver(self, forKeyPath: "estimatedProgress")
       progressView.removeFromSuperview()
    }

    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        return webView
    }()
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "estimatedProgress" {
            let progressFloat = Float(webView.estimatedProgress)
            self.progressView.setProgress(progressFloat, animated: true)
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let contentController = self.webView.configuration.userContentController
        contentController.add(self, name: "done")
        contentController.add(self, name: "closed")
        
        let html = MonoHtmlSource(publicKey: publicKey).GetString()
        webView.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(webView)
        self.view.addSubview(progressView)
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                webView.topAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                webView.leftAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
                webView.bottomAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                webView.rightAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
            ])
        } else {
            // Fallback on earlier versions
        }
    }
}

extension MonoViewController: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "done", let messageBody = message.body as? [String: Any]{
            let data = messageBody["data"] as? [String: Any]
            self.successHandler(data?["code"] as! String)
            self.dismiss(animated: true, completion: nil)
        }
        
        if message.name == "closed" {
            self.closeHandler()
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension MonoViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.progressView.isHidden = true;
        })
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }
    
    public func webView(_ webView: WKWebView,didFail navigation: WKNavigation!, withError error: Error){
        self.dismiss(animated: true, completion: nil)
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.dismiss(animated: true, completion: nil)
    }
}
