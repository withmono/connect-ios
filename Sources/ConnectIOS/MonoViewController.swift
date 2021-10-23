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
    var code: String?
    let closeHandler: (() -> Void?)
    let successHandler: ((_ authCode: String) -> Void?)
    var progressView: UIProgressView
    
    init(publicKey: String, reauth_code: String? = nil, onClose: @escaping (() -> Void?), onSuccess: @escaping ((_ authCode: String) -> Void?)) {
        self.publicKey = publicKey
        self.code = reauth_code
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
        contentController.add(self, name: "mono")

        var components = URLComponents()
        components.scheme="https"
        components.host="connect.withmono.com"
        let queryItemKey = URLQueryItem(name: "key", value: publicKey)
        let queryItemVersion = URLQueryItem(name: "version", value: "0.2.0")
        var qs = [queryItemKey, queryItemVersion]

        if(code != nil) {
          let queryItemCode = URLQueryItem(name: "code", value: code)
          qs.append(queryItemCode)
        }
        components.queryItems = qs;

        let request = URLRequest(url: components.url!)
        webView.load(request)
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
    public func parseJSON(str: String?) -> [String: AnyObject]? {
        if let data = str?.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                return json
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                return nil
            }
        }
        
        return nil
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "mono", let messageBody = parseJSON(str: (message.body as! String)){
            let data = messageBody["data"] as? [String: Any]
            let type = messageBody["type"] as! String

            switch type {
            case "mono.connect.widget.account_linked":
                self.successHandler(data?["code"] as! String)
                self.dismiss(animated: true, completion: { [weak self] in
                    self?.removeScriptMessageHandler(for: userContentController)
                })
                break
            case "mono.connect.widget.closed":
                self.closeHandler()
                self.dismiss(animated: true, completion: { [weak self] in
                    self?.removeScriptMessageHandler(for: userContentController)
                })
                break
            default:
                self.dismiss(animated: true, completion: nil)
                break
            }
        }
    }
    
    private func removeScriptMessageHandler(for userContentController: WKUserContentController) {
        userContentController.removeScriptMessageHandler(forName: "mono")
    }
}

extension MonoViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("window.MonoClientInterface = window.webkit.messageHandlers.mono;")
        
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
