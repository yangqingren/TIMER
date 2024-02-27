//
//  TMClockTimeView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/25.
//

import UIKit

class TMClockTimeView: TMBaseView {

    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "DevanagariSangamMN-Bold", size: 32.sp)
        label.textColor = .black
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "DevanagariSangamMN-Bold", size: 22.sp)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY).offset(-4.dp)
        }
        self.addSubview(self.timeLabel)
        self.timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.centerY).offset(4.dp)
        }
        
        self.timeUpdates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func timeUpdates() {
        super.timeUpdates()
        
        self.dateLabel.text = Date().getDateString(format: "MM-dd EE")
        self.timeLabel.text = Date().getDateString(format: "HH : mm : ss")
    }
    
}
