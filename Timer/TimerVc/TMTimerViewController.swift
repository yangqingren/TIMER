//
//  TMTimerViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/2/29.
//

import UIKit

class TMTimerViewController: TMBaseViewController {

    lazy var contentView: TMTimerContentView = {
        let view = TMTimerContentView()
        return view
    }()
    
    lazy var titleLaebl: UILabel = {
        let label = UILabel()
        label.text = TMLocalizedString("计时器")
        label.font = .systemFont(ofSize: 17.sp, weight: .semibold)
        label.textColor = kBlockClockBlue
        return label
    }()
    
    lazy var startButton: LEGOHighlightButton = {
        let button = LEGOHighlightButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "mian_button_emtry"), for: .normal)
        button.setTitle(TMLocalizedString("开始"), for: .normal)
        button.setTitle(TMLocalizedString("暂停"), for: .selected)
        button.setTitleColor(kBlockClockBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.sp, weight: .regular)
        button.hotspot = 20.dp
        button.addTarget(self, action: #selector(startButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var backButton: LEGOHighlightButton = {
        let button = LEGOHighlightButton(type: .custom)
        button.setImage(UIImage(named: "mian_button_back"), for: .normal)
        button.setImage(UIImage(named: "mian_button_back"), for: .highlighted)
        button.hotspot = 20.dp
        button.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return button
    }()
    
    var date: Date?
    var total: TimeInterval = 0
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(r: 241, g: 245, b: 250, a: 1)

        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { make in
            make.size.equalTo(TMTimerContentView.viewSize())
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50.dp)
        }
        
        let size = CGSize(width: 80.dp, height: 80.dp)
        let spacing = 60.dp
        self.view.addSubview(self.startButton)
        self.startButton.snp.makeConstraints { make in
            make.size.equalTo(size)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.contentView.snp.bottom).offset(spacing)
        }
        
        self.view.addSubview(self.titleLaebl)
        self.titleLaebl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.contentView.snp.top).offset(-spacing - size.height / 4.0.dp)
        }
        
        self.view.addSubview(self.backButton)
        self.backButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 32.dp, height: 32.dp))
            make.left.equalToSuperview().offset(20.dp)
            make.top.equalToSuperview().offset(LEGONavMargan)
        }
        

        // Do any additional setup after loading the view.
    }
    
    @objc func backButtonClick() {
        self.dismiss(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = self.date {
            self.startTimer()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopTimer()
    }
    
    @objc func startButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            // 开始
            self.date = Date()
            self.startTimer()
        }
        else {
            // 暂停
            self.stopTimer()
            if let date = self.date {
                let timeInterval = Date().timeIntervalSince(date)
                self.total += timeInterval
                self.date = nil
            }
        }
    }
    
    @objc func timerRun() {
        if let date = self.date {
            let timeInterval = Date().timeIntervalSince(date)
            let allInterval = timeInterval + self.total
            let seconds = Int(allInterval) // 秒
            let milliseconds = Int((allInterval - Double(seconds)) * 100) // 毫秒x10
            if seconds < 10 {
                self.contentView.label1.text = "0\(seconds)"
            }
            else {
                if seconds >= 100 {
                    self.contentView.label1.attributedText = String.getExpansionString(text: "\(seconds)", expansion: -0.2)
                }
                else {
                    self.contentView.label1.text = "\(seconds)"
                }
            }
            if milliseconds < 10 {
                self.contentView.label2.text = "0\(milliseconds)"
            }
            else {
                self.contentView.label2.text = "\(milliseconds)"
            }
            
            self.contentView.setupProgressLayer(duration: 0.0, from: Float(self.interval) / 60.0, to: Float(allInterval) / 60.0)
            self.interval = allInterval
        }
    }
    
    var interval: TimeInterval = 0
    
    func startTimer() {
        self.stopTimer()
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerRun), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if let timer = self.timer {
            timer.invalidate()
        }
        self.timer = nil
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
