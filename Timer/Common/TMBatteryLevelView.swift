//
//  TMBatteryLevelView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/24.
//

import UIKit

class TMBatteryLevelView: UIView {

    lazy var battery: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.init(named: "common_battery_nomal")
        return view
    }()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = 2.dp
        return view
    }()

    lazy var battLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "GillSans-SemiBold", size: 12.sp)
        label.textColor = UIColor.init(r: 205, g: 214, b: 223, a: 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.battery)
        self.battery.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.addSubview(self.bgView)
        self.bgView.snp.makeConstraints { make in
            make.width.equalTo(14.dp)
            make.height.equalTo(18.5.dp)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4.dp)
        }
        
        self.addSubview(self.battLabel)
        self.battLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(2.dp)
        }
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        self.setupBatteryLevel()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func batteryLevelDidChange() {
        self.setupBatteryLevel()
    }
    
    func setupBatteryLevel() {
        let level = UIDevice.current.batteryLevel
        debugPrint("电池电量改变：\(level * 100)%")
        if level < 0 || self.bgView.superview == nil {
            return
        }
        self.battLabel.text = "\(Int(level * 100))"
        if level >= 0.5 {
            self.bgView.backgroundColor = .systemGreen
        }
        else if level >= 0.15 {
            self.bgView.backgroundColor = .systemOrange
        }
        else {
            self.bgView.backgroundColor = .systemRed
        }
        if level >= 1 {
            self.battLabel.font = .init(name: "GillSans-SemiBold", size: 8.5.sp)
        }
        else {
            self.battLabel.font = .init(name: "GillSans-SemiBold", size: 12.sp)
        }
        
        var ratio = 1.3 * level
        if ratio > 1.0 {
            ratio = 1.0
        }
        self.bgView.snp.updateConstraints { make in
            make.height.equalTo(18.5.dp * CGFloat(ratio))
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
