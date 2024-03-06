//
//  TMLoading.swift
//  Timer
//
//  Created by yangqingren on 2024/3/4.
//

import UIKit

class TMLoading: UIView {
    
    static let share = TMLoading()
    
    lazy var activity: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10.sp, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.activity)
        self.activity.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-5.dp)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.centerY).offset(5.dp)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func showInView(_ inView: UIView?) {
        DispatchQueue.main.async {
            
            let loading = TMLoading.share
            loading.backgroundColor = UIColor.init(r: 0, g: 0, b: 0, a: 0.85)
            loading.isUserInteractionEnabled = true
            if let inView = inView {
                inView.addSubview(loading)
                loading.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
            loading.activity.startAnimating()
            loading.titleLabel.text = TMLocalizedString("加载中...")
        }
    }
    
    static func dismiss() {
        DispatchQueue.main.async {
            
            let loading = TMLoading.share
            if let _ = loading.superview {
                loading.removeFromSuperview()
            }
        }
    }
    
}
