//
//  ViewController.swift
//  Project31
//
//  Created by Bogdan Pralea on 23.05.2022.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, WKNavigationDelegate {

    @IBOutlet weak var addressBar: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    weak var activeWebView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setDefaultTitle()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [delete, add]
    }

    func setDefaultTitle() {
        title = "Multibrowser"
    }
    
    @objc func addWebView() {
        let webView = WKWebView()
        webView.navigationDelegate = self
        
        stackView.addArrangedSubview(webView)
        
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        
        webView.layer.borderColor = UIColor.blue.cgColor
        selectWebView(webView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
    }
    
    @objc func deleteWebView() {
        if let webView = activeWebView {
            if let index = stackView.arrangedSubviews.firstIndex(of: webView) {
                stackView.removeArrangedSubview(webView)
                webView.removeFromSuperview()
                
                if stackView.arrangedSubviews.count == 0 {
                    setDefaultTitle()
                } else {
                    var currentIndex = Int(index)
                    
                    if currentIndex == stackView.arrangedSubviews.count {
                        currentIndex = stackView.arrangedSubviews.count - 1
                    }
                    
                    if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? WKWebView {
                        selectWebView(newSelectedWebView)
                    }
                }
            }
        }
    }

    @objc func webViewTapped(_ recognizer: UITapGestureRecognizer) {
        if let selectedWebView = recognizer.view as? WKWebView {
            selectWebView(selectedWebView)
        }
        
    }
    
    func selectWebView(_ webView: WKWebView) {
        for view in stackView.arrangedSubviews {
            view.layer.borderWidth = 0
        }
        
        activeWebView = webView
        webView.layer.borderWidth = 3
        
        updateUI(for: webView)
    }
    
    func updateUI(for webView: WKWebView) {
        title = webView.title
        addressBar.text = webView.url?.absoluteString ?? ""
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let webView = activeWebView, let address = addressBar.text {
            if let url = URL(string: address) {
                webView.load(URLRequest(url: url))
            }
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView == activeWebView {
            updateUI(for: webView)
        }
    }
}

