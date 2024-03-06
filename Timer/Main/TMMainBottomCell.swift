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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
