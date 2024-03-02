//
//  TMNeonTextFieldView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/22.
//

import UIKit

private let kUserDefaultsTextSave = "kUserDefaultsTextSave"

class TMNeonTextFieldView: TMBaseView, UITextFieldDelegate {

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
    
    var text: String? = UserDefaults.standard.string(forKey: kUserDefaultsTextSave) {
        didSet {
            UserDefaults.standard.setValue(text, forKey: kUserDefaultsTextSave)
        }
    }
    
    lazy var textLabel: UILabel = {
        let field = UILabel()
        field.textAlignment = .center
        field.numberOfLines = 0
        field.textColor = TMNeonBlue
        field.font = .systemFont(ofSize: 26.sp, weight: .semibold)
        return field
    }()
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name.kNotifiMainBrightness, object: false)
        textField.text = self.text
        textField.selectedTextRange = textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
    }
    
    @objc func textFieldChanged(_ sender: UITextField) {
        self.text = sender.text
        self.timeUpdates()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name.kNotifiMainBrightness, object: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.textLabel)
        self.textLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20.dp)
            make.height.greaterThanOrEqualTo(40.dp)
        }
        
        self.insertSubview(self.textField, belowSubview: self.textLabel)
        self.textField.snp.makeConstraints { make in
            make.edges.equalTo(self.textLabel)
        }
        
        self.textLabel.setContentHuggingPriority(.required, for: .vertical)
        self.textLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func timeUpdates() {
        super.timeUpdates()
        
        if let text = self.text, text.count > 0 {
            self.setupTextChanged(text)
        }
        else {
            let text = "\(TMLocalizedString("编 辑")) \(self.getDateText()) \(TMLocalizedString("好 心 情  ⏎"))"
            self.setupTextChanged(text)
        }
    }

    func setupTextChanged(_ text: String) {
        let shadow = NSShadow()
        shadow.shadowColor = self.textLabel.textColor
        shadow.shadowBlurRadius = 10.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        let attributedString = String.getExpansionString(text: text, expansion: -0.2, others: [NSAttributedString.Key.shadow: shadow])
        self.textLabel.attributedText = attributedString
    }
    
    func getDateText() -> String {
        var text = ""
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        if hour >= 5 && hour < 6 {
            text = TMLocalizedString("凌 晨")
        } 
        else if hour >= 6 && hour < 11 {
            text = TMLocalizedString("早 安")
        } 
        else if hour >= 11 && hour < 13 {
            text = TMLocalizedString("午 安")
        }
        else if hour >= 13 && hour < 18 {
            text = TMLocalizedString("下 午")
        } 
        else if hour >= 18 && hour < 20 {
            text = TMLocalizedString("傍 晚")
        } 
        else {
            text = TMLocalizedString("晚 安")
        }
        return text
    }
    

}
