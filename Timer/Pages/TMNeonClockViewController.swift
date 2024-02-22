//
//  TMNeonClockViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import UIKit

class TMNeonClockViewController: TMBasePageViewController, UITextFieldDelegate {
    
    lazy var shadowLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 18.sp)
        label.textColor = UIColor.black
        label.textAlignment = .center
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.init(r: 148, g: 226, b: 250, a: 1)
        shadow.shadowBlurRadius = 3.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        label.attributedText = String.getExpansionString(text: "TIIMII", expansion: 0.3, others: [    NSAttributedString.Key.shadow: shadow])
        return label
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20.dp
        view.layer.borderWidth = 4.dp
        view.layer.borderColor = UIColor.init(r: 148, g: 226, b: 250, a: 1).cgColor
        view.layer.shadowRadius = 5.dp
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowColor = UIColor.init(r: 148, g: 226, b: 250, a: 1).cgColor
        view.layer.shadowOpacity = 1.0
        
        let line = UIView()
        line.layer.cornerRadius = 2.dp
        line.backgroundColor = UIColor.init(r: 148, g: 226, b: 250, a: 1)
        
        line.layer.shadowRadius = 5.dp
        line.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        line.layer.shadowColor = UIColor.init(r: 148, g: 226, b: 250, a: 1).cgColor
        line.layer.shadowOpacity = 0.3
        
        view.addSubview(line)
        line.snp.makeConstraints { make in
            make.width.equalTo(LEGOScreenWidth * 0.6)
            make.height.equalTo(4.dp)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.centerY).offset(13.dp)
        }
        
        return view
    }()
    
    lazy var weekLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 249, g: 231, b: 158, a: 1)
        label.font = .init(name: "Copperplate-Bold", size: 18.sp)
        return label
    }()
    
    func setupWeekLabel() {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.init(r: 249, g: 231, b: 158, a: 1)
        shadow.shadowBlurRadius = 7.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        let text = Date().getDateString(format: "EEE")
        self.weekLabel.attributedText = String.getExpansionString(text: text, expansion: 0.5, others: [    NSAttributedString.Key.shadow: shadow])
    }
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 255, g: 154, b: 195, a: 1)
        label.font = .init(name: "Copperplate-Bold", size: 40.sp)
        return label
    }()
    
    func setupTimeLabel() {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.init(r: 255, g: 154, b: 195, a: 1)
        shadow.shadowBlurRadius = 10.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        let text = Date().getDateStringEn(format: "HH : mm : ss")
        self.timeLabel.attributedText = String.getExpansionString(text: text, expansion: 0.3, others: [    NSAttributedString.Key.shadow: shadow])
    }
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(r: 249, g: 231, b: 158, a: 1)
        label.font = .init(name: "Copperplate-Bold", size: 26.sp)
        return label
    }()
    
    func setupDateLabel() {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.init(r: 249, g: 231, b: 158, a: 1)
        shadow.shadowBlurRadius = 7.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        let text = Date().getDateStringEn(format: "MMM dd")
        self.dateLabel.attributedText = String.getExpansionString(text: text, expansion: 0.3, others: [    NSAttributedString.Key.shadow: shadow])
    }

    lazy var textField: UITextField = {
        let field = UITextField()
        field.textColor = .clear
        field.backgroundColor = .clear
        field.tintColor = .clear
        field.returnKeyType = .done
        field.delegate = self
        field.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        return field
    }()
    
    lazy var textLabel: UILabel = {
        let field = UILabel()
        field.textAlignment = .center
        field.numberOfLines = 0
        field.textColor = UIColor.init(r: 148, g: 226, b: 250, a: 1)
        field.font = .systemFont(ofSize: 26.sp, weight: .semibold)
        return field
    }()
    
    func setupTextLabel() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        if hour >= 0 && hour < 6 {
            print("现在是凌晨")
        } else if hour >= 6 && hour < 9 {
            print("现在是早上")
        } else if hour >= 9 && hour < 12 {
            print("现在是上午")
        } else if hour >= 12 && hour < 13 {
            print("现在是中午")
        } else if hour >= 13 && hour < 18 {
            print("现在是下午")
        } else if hour >= 18 && hour < 20 {
            print("现在是傍晚")
        } else {
            print("现在是晚上")
        }
    }
    
    @objc func textFieldChanged(_ sender: UITextField) {
        self.setupTextFieldChanged(text: sender.text ?? "")
    }
    
    func setupTextFieldChanged(text: String) {
        let shadow = NSShadow()
        shadow.shadowColor = self.textLabel.textColor
        shadow.shadowBlurRadius = 10.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        let attributedString = String.getExpansionString(text: text, expansion: -0.2, others: [NSAttributedString.Key.shadow: shadow])
        self.textLabel.attributedText = attributedString
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        self.view.addSubview(self.shadowLabel)
        self.shadowLabel.snp.makeConstraints { make in
            make.left.equalTo(self.view.safeAreaInsets.left).offset(20.dp)
            make.top.equalTo(self.view.safeAreaInsets.top).offset(55.dp)
        }
        
        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: LEGOScreenWidth * 0.9, height: LEGOScreenWidth * 0.4))
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.snp.centerY)
        }
        
        self.view.addSubview(self.timeLabel)
        self.timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.contentView.snp.centerY)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-18.dp)
            make.centerX.equalTo(self.contentView.snp.centerX)
        }
        
//        self.view.addSubview(self.weekLabel)
//        self.weekLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(self.dateLabel.snp.centerY).offset(0.dp)
//            make.left.equalTo(self.contentView.snp.centerX)
//        }
        
        self.view.addSubview(self.textLabel)
        self.textLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView.snp.top).offset(-20.dp)
        }
        
        self.view.insertSubview(self.textField, belowSubview: self.textLabel)
        self.textField.snp.makeConstraints { make in
            make.left.right.equalTo(self.contentView)
            make.bottom.top.equalTo(self.textLabel)
            make.height.greaterThanOrEqualTo(40.dp)
        }
        
        self.setupTextFieldChanged(text: "午 安 好 心 情  ⏎")
        self.setupTextLabel()
        self.setupTimeLabel()
        self.setupDateLabel()
        self.setupWeekLabel()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TMDelegateManager.share.neon = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TMDelegateManager.share.neon = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func motionUpdates(directin: TMMontionDirection) {
        switch directin {
        case .original:
            self.view.transform = CGAffineTransform.identity
        case .left:
            self.view.transform = CGAffineTransform.identity.rotated(by: .pi / -2.0)
        case .right:
            self.view.transform = CGAffineTransform.identity.rotated(by: .pi / 2.0)
        case .down:
            self.view.transform = CGAffineTransform.identity
        }
    }

    override func timeUpdates() {
        self.setupTimeLabel()
        self.setupDateLabel()
        self.setupTextLabel()
        self.setupWeekLabel()
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
