//
//  TMNeonIconView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/22.
//

import UIKit

class TMNeonIconView: TMBaseView {

    lazy var legoImageView: UIImageView = {
        let view = UIImageView()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        if hour >= 6 && hour < 18 {
            view.image = UIImage.init(named: "neon_coke_nomal")
        }
        else {
            view.image = UIImage.init(named: "neon_cat_nomal")
        }
        view.alpha = 0.85
        return view
    }()
    
    override func timeUpdates() {
        super.timeUpdates()

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.legoImageView)
        self.legoImageView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        let size = CGSize(width: 3.dp, height: 7.dp)

        let dian1 = UIView()
        dian1.backgroundColor = TMNeonBlue
        
        let dian2 = UIView()
        dian2.backgroundColor = TMNeonGreen
        
        let dian3 = UIView()
        dian3.layer.borderWidth = size.width * 0.8
        dian3.layer.cornerRadius = 4.5.dp
        dian3.layer.borderColor = TMNeonBlue.cgColor
        
        let dian4 = UIView()
        dian4.backgroundColor = TMNeonPink
        
        let dian5 = UIView()
        dian5.backgroundColor = TMNeonBlue
        
        let dian6 = UIView()
        dian6.layer.borderWidth = size.width
        dian6.layer.cornerRadius = 4.5.dp
        dian6.layer.borderColor = TMNeonYellow.cgColor
        
        let dian7 = UIView()
        dian7.backgroundColor = TMNeonBlue

        
        let array = [dian1, dian2, dian3, dian4, dian5, dian6, dian7]
        let width = LEGOScreenWidth * 0.5 / 6.0
        for (index, item) in array.enumerated() {
            self.addSubview(item)
            
            item.layer.shadowRadius = 3.dp
            item.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            item.layer.shadowColor = (item.backgroundColor ?? TMNeonBlue).cgColor
            item.layer.shadowOpacity = 1.0
            
            switch (index + 1) {
            case 1:
                item.snp.makeConstraints { make in
                    make.size.equalTo(size)
                    make.centerX.equalTo(self.snp.left).offset(0)
                    make.top.equalToSuperview().offset(58.dp)
                }
                item.transform = CGAffineTransform.identity.rotated(by: -.pi / 180.0 * 60.0)
                item.layer.cornerRadius = size.width / 2.0
                
            case 7:
                item.snp.makeConstraints { make in
                    make.size.equalTo(size)
                    make.centerX.equalTo(self.snp.right).offset(0)
                    make.top.equalToSuperview().offset(58.dp)
                }
                item.transform = CGAffineTransform.identity.rotated(by: .pi / 180.0 * 80.0)
                item.layer.cornerRadius = size.width / 2.0

            case 2:
                item.snp.makeConstraints { make in
                    make.size.equalTo(size)
                    make.centerX.equalTo(self.snp.centerX).offset(0 - width * 1.2 * 2)
                    make.top.equalToSuperview().offset(28.dp)
                }
                item.transform = CGAffineTransform.identity.rotated(by: -.pi / 180.0 * 45.0)
                item.layer.cornerRadius = size.width / 2.0

            case 6:
                item.snp.makeConstraints { make in
                    make.size.equalTo(CGSize(width: 9.dp, height: 9.dp))
                    make.centerX.equalTo(self.snp.centerX).offset(width * 1.3 * 2)
                    make.top.equalToSuperview().offset(25.dp)
                }
                item.transform = CGAffineTransform.identity.rotated(by: .pi / 180.0 * 50.0)

            case 3:
                item.snp.makeConstraints { make in
                    make.size.equalTo(CGSize(width: 9.dp, height: 9.dp))
                    make.centerX.equalTo(self.snp.centerX).offset(0 - width * 1.3)
                    make.top.equalToSuperview().offset(8.dp)
                }
                item.transform = CGAffineTransform.identity.rotated(by: -.pi / 180.0 * 15.0)

            case 5:
                item.snp.makeConstraints { make in
                    make.size.equalTo(size)
                    make.centerX.equalTo(self.snp.centerX).offset(width * 1.3)
                    make.top.equalToSuperview().offset(8.dp)
                }
                item.transform = CGAffineTransform.identity.rotated(by: .pi / 180.0 * 10.0)
                item.layer.cornerRadius = size.width / 2.0

            case 4:
                item.snp.makeConstraints { make in
                    make.size.equalTo(size)
                    make.centerX.equalTo(self.snp.centerX).offset(0)
                    make.top.equalToSuperview().offset(0)
                }
                item.layer.cornerRadius = size.width / 2.0

            default:
                break
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
