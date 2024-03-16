//
//  TMBgMp3Cell.swift
//  Timer
//
//  Created by yangqingren on 2024/3/13.
//

import UIKit

class TMBgMp3Item: NSObject {
    var isSelected = false
    let type: TMBgMusicType
    let name: String
    let file: String
    let icon: UIImage?
    
    init(type: TMBgMusicType) {
        self.type = type
        self.name = TMBgMp3Manager.getMusicName(type) ?? ""
        self.file = TMBgMp3Manager.getMusicFile(type) ?? ""
        self.icon = TMBgMp3Manager.getMusicIcon(type)

    }
}

class TMBgMp3Cell: UICollectionViewCell {
    
    lazy var iconBgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "mian_button_emtry")
        return view
    }()
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    lazy var selectButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    lazy var titltLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "ChalkboardSE-Bold", size: 9.dp)
        label.textColor = .white.withAlphaComponent(0.55)
        label.textAlignment = .right
        label.attributedText = String.getExpansionString(text: "music pick")
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "ChalkboardSE-Bold", size: 11.5.dp)
        label.textColor = .white
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.init(r: 26, g: 24, b: 28, a: 1)
        self.contentView.layer.cornerRadius = TMBgMp3Cell.viewSize().height / 2.0
        self.contentView.layer.masksToBounds = true
        
        self.addSubview(self.iconBgView)
        self.iconBgView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 36.dp, height: 36.dp))
            make.left.equalToSuperview().offset(15.dp)
            make.centerY.equalToSuperview()
        }
        
        self.iconBgView.addSubview(self.icon)
        self.icon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        self.addSubview(self.selectButton)
        let width = 32.dp
        self.selectButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: width, height: width))
            make.right.equalToSuperview().offset(-15.dp)
            make.centerY.equalToSuperview()
        }
        self.selectButton.layer.cornerRadius = width / 2.0
        self.selectButton.layer.masksToBounds = true
        
        
        let spacing = 8.dp
        self.addSubview(self.titltLabel)
        self.titltLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.centerY).offset(-spacing)
            make.right.equalTo(self.selectButton.snp.left).offset(-spacing)
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.centerY)
            make.right.equalTo(self.selectButton.snp.left).offset(-spacing)
            make.left.equalTo(self.iconBgView.snp.right).offset(spacing)
        }
    }
    
    var item: TMBgMp3Item? {
        didSet {
            if let item = item, item.isSelected {
                self.selectButton.setImage(UIImage.init(named: "common_bingo_white"), for: .normal)
                self.selectButton.backgroundColor = UIColor.init(r: 181, g: 152, b: 101, a: 1)
            }
            else {
                self.selectButton.setImage(UIImage.init(named: "common_add_white"), for: .normal)
                self.selectButton.backgroundColor = UIColor.init(r: 201, g: 83, b: 60, a: 1)
            }
            self.nameLabel.attributedText = String.getExpansionString(text: item?.name ?? "")
            self.icon.image = item?.icon
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewSize() -> CGSize {
        let spacingX = 15.dp
        let width = (LEGOScreenWidth - spacingX * 3.0) / 2.0
        let height = 64.dp
        return CGSize(width: width, height: height)
    }
}
