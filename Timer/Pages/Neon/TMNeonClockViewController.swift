//
//  TMNeonClockViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import UIKit

let TMNeonPink = UIColor.init(r: 255, g: 154, b: 195, a: 1)
let TMNeonBlue =  UIColor.init(r: 148, g: 226, b: 250, a: 1)
let TMNeonYellow = UIColor.init(r: 249, g: 231, b: 158, a: 1)
let TMNeonGreen = UIColor.init(r: 151, g: 247, b: 195, a: 1)

enum TMNeonClockNight {
    case unknow
    case day
    case night
}

class TMNeonClockViewController: TMBasePageViewController {
            
    lazy var shadowLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 18.sp)
        label.textColor = UIColor.black
        label.textAlignment = .center
        let shadow = NSShadow()
        shadow.shadowColor = TMNeonBlue
        shadow.shadowBlurRadius = 3.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        label.attributedText = String.getExpansionString(text: TIIMII, expansion: 0.3, others: [    NSAttributedString.Key.shadow: shadow])
        return label
    }()
        
    lazy var neonIconView: TMNeonIconView = {
        let view = TMNeonIconView()
        return view
    }()
    
    lazy var neonClockView: TMNeonClockView = {
        let view = TMNeonClockView(frame: .zero, vcType: self.vcType)
        return view
    }()
    
    lazy var neonTextView: TMNeonTextFieldView = {
        let view = TMNeonTextFieldView()
        return view
    }()
    
    lazy var bottomIconView: UIImageView = {
        let view = UIImageView()
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        self.view.addSubview(self.shadowLabel)
        self.shadowLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20.dp)
            make.top.equalTo(self.view.safeAreaInsets.top).offset(55.dp)
        }
                
        self.transformView.addSubview(self.neonClockView)
        self.neonClockView.snp.makeConstraints { make in
            make.size.equalTo(TMNeonClockView.viewSize())
            make.centerX.equalToSuperview()
            make.top.equalTo(self.transformView.snp.centerY)
        }
        
        self.transformView.addSubview(self.neonTextView)
        self.neonTextView.snp.makeConstraints { make in
            make.bottom.equalTo(self.neonClockView.snp.top)
            make.left.right.equalTo(self.neonClockView)
        }
        
        self.transformView.addSubview(self.neonIconView)
        self.neonIconView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: LEGOScreenWidth * 0.5, height: LEGOScreenWidth * 0.5))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.neonTextView.snp.top).offset(0)
        }
        
        self.transformView.addSubview(self.bottomIconView)
        self.bottomIconView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 150.dp, height: 150.dp))
            make.centerX.equalToSuperview()
            make.top.equalTo(self.neonClockView.snp.bottom).offset(20.dp)
        }

        self.timeUpdates()
        
        // Do any additional setup after loading the view.
    }
            
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.vcType == .main {
            TMDelegateManager.share.neon = self
            NotificationCenter.default.post(name: NSNotification.Name.kNotifiMainBrightness, object: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.vcType == .main {
            NotificationCenter.default.post(name: NSNotification.Name.kNotifiMainBrightness, object: false)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.vcType == .main {
            TMDelegateManager.share.neon = nil
            NotificationCenter.default.post(name: NSNotification.Name.kNotifiMainBrightness, object: false)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func setupSystemTimeChanged() {
        super.setupSystemTimeChanged()
        
        let format = Date.getHhFormatter()
        self.neonClockView.format = format
        self.neonClockView.timeUpdates()
    }
    
    var nightType: TMNeonClockNight = .unknow
    
    override func timeUpdates() {
        super.timeUpdates()
     
        var nightType: TMNeonClockNight = .unknow
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        if hour >= 6 && hour < 18 {
            nightType = .day
        }
        else {
            nightType = .night
        }
        if self.nightType != nightType {
            self.nightType = nightType
            if nightType == .day {
                self.neonIconView.legoImageView.image = UIImage.init(named: "neon_coke_nomal")
                self.bottomIconView.image = UIImage.init(named: "neon_beauty_nomal")
                self.bottomIconView.alpha = 0.8
            }
            else {
                self.neonIconView.legoImageView.image = UIImage.init(named: "neon_cat_nomal")
                self.bottomIconView.image = UIImage.init(named: "neon_cat_nomal2")
                self.bottomIconView.alpha = 1
            }
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
