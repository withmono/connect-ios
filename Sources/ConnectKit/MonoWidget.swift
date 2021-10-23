//
//  MonoWidget.swift
//
//  Created by Tristan Tsvetanov on 02021-06-02.
//

import Foundation
import UIKit
import WebKit

public class MonoWidget: UIViewController, WKUIDelegate {

    // contants
    let DEPRECATED_EVENTS = ["mono.connect.widget.closed", "mono.connect.widget.account_linked", "mono.modal.closed", "mono.modal.linked"]

    // required
    var publicKey: String
    let successHandler: ((_ authCode: String) -> Void?)

    // optionals
    var reference: String?
    var code: String?
    var selectedInstitution: ConnectInstitution?

    // handlers
    let closeHandler: (() -> Void?)?
    let eventHandler: ((_ event: ConnectEvent) -> Void?)?

    // loading view
    var progressView: UIProgressView

    init(configuration: MonoConfiguration) {

        // required
        self.publicKey = configuration.publicKey
        self.successHandler = configuration.onSuccess

        // optionals
        if configuration.reauthCode != nil {
            self.code = configuration.reauthCode
        }else{
            self.code = nil
        }
        if configuration.reference != nil {
            self.reference = configuration.reference
        }else{
            self.reference = nil
        }
        if configuration.selectedInstitution != nil {
            self.selectedInstitution = configuration.selectedInstitution
        }else{
            self.selectedInstitution = nil
        }

        // handlers
        if(configuration.onClose != nil){
            self.closeHandler = configuration.onClose!
        }else{
            self.closeHandler = nil
        }

        if(configuration.onEvent != nil){
            self.eventHandler = configuration.onEvent!
        }else{
            self.eventHandler = nil
        }

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
        components.host="studio.connect.withmono.com"
        let queryItemKey = URLQueryItem(name: "key", value: publicKey)
        let queryItemVersion = URLQueryItem(name: "version", value: "2021-06-03")
        var qs = [queryItemKey, queryItemVersion]

        if(code != nil) {
          let queryItemCode = URLQueryItem(name: "reauth_token", value: code)
          qs.append(queryItemCode)
        }
        if(reference != nil) {
            let queryItemCode = URLQueryItem(name: "reference", value: reference)
            qs.append(queryItemCode)
        }
        if(selectedInstitution != nil){
            do {
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(selectedInstitution)
                let json = String(data: jsonData, encoding: String.Encoding.utf8)

                let queryItemCode = URLQueryItem(name: "selectedInstitution", value: json)
                qs.append(queryItemCode)
            }
            catch {
                print("error = \(error.localizedDescription)")
            }

        }

        components.queryItems = qs;

        let request = URLRequest(url: components.url!)
        webView.load(request)

        if self.eventHandler != nil{
            let connectEvent = ConnectEvent(eventName: "OPENED", type: "mono.connect.widget_opened", reference: self.reference, timestamp: Date())
            self.eventHandler!(connectEvent as! ConnectEvent)
        }

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

extension MonoWidget: WKScriptMessageHandler {
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

            // pass data on to onEvent
            if self.eventHandler != nil && !DEPRECATED_EVENTS.contains(type){
                let connectEvent = ConnectEventMapper.map(messageBody)
                self.eventHandler!(connectEvent!)
            }

            switch type {
            case "mono.connect.widget.account_linked":
                self.successHandler(data?["code"] as! String)
                self.dismiss(animated: true, completion: { [weak self] in
                    self?.removeScriptMessageHandler(for: userContentController)
                })
                break
            case "mono.connect.widget.closed":
                if closeHandler != nil {
                    closeHandler!()
                }
                self.dismiss(animated: true, completion: { [weak self] in
                    self?.removeScriptMessageHandler(for: userContentController)
                })
                break
            default:
//                self.dismiss(animated: true, completion: nil)
                break
            }
        }
    }
    
    private func removeScriptMessageHandler(for userContentController: WKUserContentController) {
        userContentController.removeScriptMessageHandler(forName: "mono")
    }
}

extension MonoWidget: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("window.MonoClientInterface = window.webkit.messageHandlers.mono;")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.progressView.isHidden = true;
        })
    }

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        self.dismiss(animated: true, completion: nil)
    }

    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.dismiss(animated: true, completion: nil)
    }
}
