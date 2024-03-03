//
//  TMBlockClockView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/23.
//

import UIKit

class TMBlockClockView: TMBaseView {
    
    lazy var topDateLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 18.sp)
        label.textColor = UIColor.init(r: 205, g: 214, b: 223, a: 1)
        label.textAlignment = .center
        return label
    }()
    
    lazy var timeHHView: TMBlockBaseView = {
        let view = TMBlockBaseView()
        return view
    }()
    
    lazy var timeMmView: TMBlockBaseView = {
        let view = TMBlockBaseView()
        return view
    }()
    
    lazy var timeSsView: TMBlockBaseView = {
        let view = TMBlockBaseView()
        return view
    }()
    
    lazy var dian1: TMBlockDianView = {
        let view = TMBlockDianView()
        view.dian.image = UIImage(named: "block_num_block0")
        return view
    }()
    
    lazy var dian2: TMBlockDianView = {
        let view = TMBlockDianView()
        view.dian.image = UIImage(named: "block_num_block0")
        return view
    }()
    
    lazy var dian3: TMBlockDianView = {
        let view = TMBlockDianView()
        view.dian.image = UIImage(named: "block_num_block0")
        return view
    }()
    
    lazy var dian4: TMBlockDianView = {
        let view = TMBlockDianView()
        view.dian.image = UIImage(named: "block_num_block0")
        return view
    }()
    
    lazy var dian5: TMBlockDianView = {
        let view = TMBlockDianView()
        view.dian.image = UIImage(named: "block_num_block0")
        return view
    }()
    
    lazy var dian6: TMBlockDianView = {
        let view = TMBlockDianView()
        view.dian.image = UIImage(named: "block_num_block0")
        return view
    }()
    
    lazy var dian7: TMBlockDianView = {
        let view = TMBlockDianView()
        view.dian.image = UIImage(named: "block_num_block0")
        return view
    }()
    
    lazy var dian8: TMBlockDianView = {
        let view = TMBlockDianView()
        view.dian.image = UIImage(named: "block_num_block0")
        return view
    }()

    lazy var dian9: TMBlockDianView = {
        let view = TMBlockDianView()
        view.dian.image = UIImage(named: "block_num_block0")
        return view
    }()
    
    lazy var dian10: TMBlockDianView = {
        let view = TMBlockDianView()
        view.dian.image = UIImage(named: "block_num_block0")
        return view
    }()
    
    override init(frame: CGRect, vcType: TMMainVcType) {
        super.init(frame: frame, vcType: vcType)
        
        self.addSubview(self.timeMmView)
        self.timeMmView.snp.makeConstraints { make in
            make.size.equalTo(TMBlockBaseView.viewSize())
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(7.dp)
        }
                
        let size = CGSize(width: 26.dp, height: 26.dp)
        let spacingX = 28.dp
        let spacingY = 40.7.dp
        self.addSubview(self.dian1)
        self.dian1.snp.makeConstraints { make in
            make.size.equalTo(size)
            make.right.equalTo(self.snp.centerX).offset(-spacingX)
            make.bottom.equalTo(self.timeMmView.snp.top).offset(-spacingY)
        }
        
        self.addSubview(self.dian2)
        self.dian2.snp.makeConstraints { make in
            make.size.equalTo(size)
            make.left.equalTo(self.snp.centerX).offset(spacingX)
            make.bottom.equalTo(self.timeMmView.snp.top).offset(-spacingY)
        }
        
        self.addSubview(self.dian3)
        self.dian3.snp.makeConstraints { make in
            make.size.equalTo(size)
            make.right.equalTo(self.snp.centerX).offset(-spacingX)
            make.top.equalTo(self.timeMmView.snp.bottom).offset(spacingY)
        }
        
        self.addSubview(self.dian4)
        self.dian4.snp.makeConstraints { make in
            make.size.equalTo(size)
            make.left.equalTo(self.snp.centerX).offset(spacingX)
            make.top.equalTo(self.timeMmView.snp.bottom).offset(spacingY)
        }
        
        self.addSubview(self.timeHHView)
        self.timeHHView.snp.makeConstraints { make in
            make.size.equalTo(TMBlockBaseView.viewSize())
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.dian1.snp.top).offset(-spacingY)
        }
        
        self.addSubview(self.timeSsView)
        self.timeSsView.snp.makeConstraints { make in
            make.size.equalTo(TMBlockBaseView.viewSize())
            make.centerX.equalToSuperview()
            make.top.equalTo(self.dian3.snp.bottom).offset(spacingY)
        }
        
        self.addSubview(self.dian5)
        self.dian5.snp.makeConstraints { make in
            make.size.equalTo(size)
            make.left.equalTo(self.snp.left).offset(spacingY * 2.0)
            make.centerY.equalTo(self.timeMmView.snp.centerY).offset(0)
        }
        
        self.addSubview(self.dian6)
        self.dian6.snp.makeConstraints { make in
            make.size.equalTo(size)
            make.left.equalTo(self.snp.left).offset(spacingY * 2.0)
            make.centerY.equalTo(self.timeHHView.snp.centerY).offset(0)
        }
        
        self.addSubview(self.dian7)
        self.dian7.snp.makeConstraints { make in
            make.size.equalTo(size)
            make.left.equalTo(self.snp.left).offset(spacingY * 2.0)
            make.centerY.equalTo(self.timeSsView.snp.centerY).offset(0)
        }
        
        self.addSubview(self.dian8)
        self.dian8.snp.makeConstraints { make in
            make.size.equalTo(size)
            make.right.equalTo(self.snp.right).offset(-spacingY * 2.0)
            make.centerY.equalTo(self.timeMmView.snp.centerY).offset(0)
        }
        
        self.addSubview(self.dian9)
        self.dian9.snp.makeConstraints { make in
            make.size.equalTo(size)
            make.right.equalTo(self.snp.right).offset(-spacingY * 2.0)
            make.centerY.equalTo(self.timeHHView.snp.centerY).offset(0)
        }
        
        self.addSubview(self.dian10)
        self.dian10.snp.makeConstraints { make in
            make.size.equalTo(size)
            make.right.equalTo(self.snp.right).offset(-spacingY * 2.0)
            make.centerY.equalTo(self.timeSsView.snp.centerY).offset(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var ss = ""
    override func timeUpdates() {
        super.timeUpdates()
        
        let hh = Date().getDateStringEn(format: self.hhFormat)
        self.timeHHView.setupTextIcon(String(hh.prefix(1)), String(hh.suffix(1)))
        let mm = Date().getDateStringEn(format: "mm")
        self.timeMmView.setupTextIcon(String(mm.prefix(1)), String(mm.suffix(1)))
        let ss = Date().getDateStringEn(format: "ss")
        self.timeSsView.setupTextIcon(String(ss.prefix(1)), String(ss.suffix(1)))
        if self.ss != ss {
            self.ss = ss
            if self.vcType == .main {
                TMSoundManager.playSound("digit")
            }
        }
    }
    
    override func motionUpdates(directin: TMMontionDirection, duration: TimeInterval) {
        super.motionUpdates(directin: directin, duration: duration)
        
        if directin == .original || directin == .down {
            self.dian1.isHidden = false
            self.dian2.isHidden = false
            self.dian3.isHidden = false
            self.dian4.isHidden = false
        }
        else {
            self.dian1.isHidden = true
            self.dian2.isHidden = true
            self.dian3.isHidden = true
            self.dian4.isHidden = true
        }
        
        if directin == .left {
            self.dian5.isHidden = false
            self.dian6.isHidden = false
            self.dian7.isHidden = false
            self.dian8.isHidden = true
            self.dian9.isHidden = true
            self.dian10.isHidden = true
        }
        else if directin == .right {
            self.dian5.isHidden = true
            self.dian6.isHidden = true
            self.dian7.isHidden = true
            self.dian8.isHidden = false
            self.dian9.isHidden = false
            self.dian10.isHidden = false
        }
        else {
            self.dian5.isHidden = true
            self.dian6.isHidden = true
            self.dian7.isHidden = true
            self.dian8.isHidden = true
            self.dian9.isHidden = true
            self.dian10.isHidden = true
        }
        
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
            self.timeHHView.transform = transform
            self.timeMmView.transform = transform
            self.timeSsView.transform = transform
        }
    }
}

class TMBlockBaseView: UIView {
    
    lazy var label1: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var label2: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                                
        self.addSubview(self.label1)
        self.label1.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(self.snp.centerX)
        }
        
        self.addSubview(self.label2)
        self.label2.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(self.snp.centerX)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewSize() -> CGSize {
        let width = LEGOScreenWidth * 0.575
        return CGSize(width: width, height: width / 2.0)
    }
    
    var text1: String = "-1"
    var text2: String = "-1"
    func setupTextIcon(_ text1: String, _ text2: String) {
        if self.text1 != text1 {
            self.text1 = text1
            self.label1.image = UIImage(named: "block_num_\(text1)")
        }
        if self.text2 != text2 {
            self.text2 = text2
            self.label2.image = UIImage(named: "block_num_\(text2)")
        }
    }
}


class TMBlockDianView: UIView {
    
    lazy var dian: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.dian)
        self.dian.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
    }
    
    var flag: Int = 0
    func addTransform() {
        self.flag += 1
        switch (self.flag / 2) % 4 + 1 {
        case 1:
            self.transform = CGAffineTransform.identity
        case 2:
            self.transform = CGAffineTransform.identity.rotated(by: .pi / 2.0)
        case 3:
            self.transform = CGAffineTransform.identity.rotated(by: .pi)
        case 4:
            self.transform = CGAffineTransform.identity.rotated(by: .pi / 2.0 * 3.0)
        default:
            self.transform = CGAffineTransform.identity
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
