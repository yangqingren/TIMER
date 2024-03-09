//
//  TMMainBottomCell.swift
//  Timer
//
//  Created by yangqingren on 2024/2/27.
//

import UIKit

class TMMainBottomCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    var currItem: TMMainVcItem?
    
    var vc: TMBasePageViewController?
    
    lazy var titleLaebl: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 14.sp)
        label.textColor = UIColor.init(r: 222, g: 228, b: 234, a: 1)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    func setupItem(_ item: TMMainVcItem) {
        if let currItem = self.currItem, currItem.type == item.type {
            return
        }
        self.currItem = item
        let ratio = TMMainBottomView.cellSize().width / LEGOScreenWidth
        let vc = TMMainViewController.getPageVc(item, .bottom)
        if let bwVc = vc as? TMBWClockViewController {
            bwVc.item = item
        }
        self.contentView.addSubview(vc.view)
        vc.view.snp.makeConstraints { make in
            make.width.equalTo(LEGOScreenWidth)
            make.height.equalTo(LEGOScreenHeight)
            make.centerX.equalTo(self.snp.left).offset(LEGOScreenWidth / 2.0 * ratio)
            make.centerY.equalTo(self.snp.top).offset(LEGOScreenHeight / 2.0 * ratio)
        }
        vc.view.isUserInteractionEnabled = false
        vc.view.layer.cornerRadius = kBottomCornerRadius
        vc.view.layer.masksToBounds = true
        vc.view.transform = CGAffineTransform.identity.scaledBy(x: ratio, y: ratio)
        self.vc = vc
        
        self.contentView.addSubview(self.titleLaebl)
        self.titleLaebl.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.init(r: 215, g: 225, b: 235, a: 1)
        shadow.shadowBlurRadius = 3.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.titleLaebl.attributedText = String.getExpansionString(text: item.name, expansion: 0.0, others: [NSAttributedString.Key.shadow: shadow])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
