//
//  TMWebViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/3/9.
//

import UIKit
import WebKit

class TMWebViewController: TMBaseViewController, WKNavigationDelegate {

    var url: URL?
    
    lazy var webView: WKWebView = {
        let view = WKWebView.init(frame: .zero, configuration: WKWebViewConfiguration())
        view.scrollView.contentInsetAdjustmentBehavior = .never
        view.navigationDelegate = self
        return view
    }()
    
    lazy var backButton: LEGOHighlightButton = {
        let button = LEGOHighlightButton(type: .custom)
        button.setImage(UIImage(named: "mian_button_back"), for: .normal)
        button.setImage(UIImage(named: "mian_button_back"), for: .highlighted)
        button.hotspot = 20.dp
        button.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(r: 241, g: 245, b: 250, a: 1)
        
        self.view.addSubview(self.webView)
        self.webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(self.backButton)
        self.backButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 32.dp, height: 32.dp))
            make.right.equalToSuperview().offset(-20.dp)
            make.top.equalToSuperview().offset(LEGONavMargan)
        }
        
        if let url = self.url {
            self.webView.load(URLRequest.init(url: url))
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func backButtonClick() {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
