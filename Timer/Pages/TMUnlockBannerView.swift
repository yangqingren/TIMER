//
//  TMUnlockBannerView.swift
//  Timer
//
//  Created by yangqingren on 2024/3/3.
//

import UIKit

class TMUnlockBannerView: UIView {

    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "vip_unlock_icon")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 253, g: 253, b: 253, a: 1)
        label.font = .systemFont(ofSize: 15.sp, weight: .medium)
        label.text = TMLocalizedString("一次性买断全部")
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(r: 59, g: 59, b: 59, a: 1)
        self.layer.cornerRadius = 15.dp
        
        self.addSubview(self.icon)
        self.icon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 38.dp, height: 38.dp))
            make.left.equalToSuperview().offset(12.dp)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.icon.snp.right).offset(6.dp)
            make.centerY.equalToSuperview()
        }
    }
    
    static func viewSize() -> CGSize {
        return CGSize(width: LEGOScreenWidth - kMenuLeft * 2, height: 60.dp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
