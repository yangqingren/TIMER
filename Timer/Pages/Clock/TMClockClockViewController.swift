//
//  TMClockClockViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/2/24.
//

import UIKit

class TMClockClockViewController: TMBasePageViewController {

    lazy var shadowLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 16.sp)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.gray
        shadow.shadowBlurRadius = 3.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        label.attributedText = String.getExpansionString(text: TIIMII, expansion: 0.3, others: [    NSAttributedString.Key.shadow: shadow])
        return label
    }()
    
    lazy var topDateLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 18.sp)
        label.textColor = UIColor.gray.withAlphaComponent(1)
        label.textAlignment = .center
        return label
    }()
    
    lazy var topDateLabel2: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 18.sp)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    lazy var clockClockView: TMClockClockView = {
        let view = TMClockClockView(frame: CGRect(x: 0, y: 0, width: TMClockClockView.viewSize().width, height: TMClockClockView.viewSize().height), vcType: self.vcType)
        return view
    }()
    
    lazy var clockTimeView: TMClockTimeView = {
        let view = TMClockTimeView(frame: .zero)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(r: 231, g: 215, b: 207, a: 1)
        
        self.view.addSubview(self.shadowLabel)
        self.shadowLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.dp)
            make.top.equalTo(self.view.safeAreaInsets.top).offset(55.dp)
        }
        
        self.view.insertSubview(self.topDateLabel2, belowSubview: self.topDateLabel)
        self.topDateLabel2.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(1.dp)
            make.centerY.equalTo(self.shadowLabel.snp.centerY)
        }
        
        self.view.addSubview(self.topDateLabel)
        self.topDateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.shadowLabel.snp.centerY)
        }
        
        self.view.addSubview(self.clockClockView)
        self.clockClockView.snp.makeConstraints { make in
            make.size.equalTo(TMClockClockView.viewSize())
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.snp.centerY).offset(-30.dp)
        }
        
        self.view.addSubview(self.clockTimeView)
        self.clockTimeView.snp.makeConstraints { make in
            make.size.equalTo(TMClockClockView.viewSize())
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.snp.centerY).offset(30.dp)
        }
        
        self.setupBatteryView()

        // Do any additional setup after loading the view.
    }
    
    override func timeUpdates() {
        super.timeUpdates()
        let text = Date().getDateStringEn(format: "MM dd EEEE")
        self.topDateLabel.attributedText = String.getExpansionString(text: text, expansion: 0.3)
        self.topDateLabel2.attributedText = String.getExpansionString(text: text, expansion: 0.3)
    }
    
    override func motionUpdates(directin: TMMontionDirection, duration: TimeInterval) {
        super.motionUpdates(directin: directin, duration: duration)
        
        var transform = CGAffineTransform.identity
        switch directin {
        case .original:
            transform = CGAffineTransform.identity
        case .left:
            transform = CGAffineTransform.identity.rotated(by: .pi / -2.0)
        case .right:
            transform = CGAffineTransform.identity.rotated(by: .pi / 2.0)
        case .down:
            transform = CGAffineTransform.identity.rotated(by: .pi)
        }
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            self.clockClockView.transform = transform
            self.clockTimeView.transform = transform
        }
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
