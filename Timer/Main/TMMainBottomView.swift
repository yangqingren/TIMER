//
//  TMMainBottomView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/26.
//

import UIKit

let kBottomCornerRadius = 40.dp
let kBottomSectionInset = 22.dp
let kBottomLineSpacing = 10.dp
let kBottomCollectionTop = 44.dp
let kBottomCollectionBottom = 32.dp

class TMMainCollectionLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        self.itemSize = TMMainBottomView.cellSize()
        self.minimumInteritemSpacing = kBottomLineSpacing   // 横向间隔
        self.minimumLineSpacing = kBottomLineSpacing  // 竖向间隔
        self.sectionInset = UIEdgeInsets.init(top: 0, left: kBottomSectionInset, bottom: 0, right: kBottomSectionInset)
        self.scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class TMMainBottomView: TMBaseView {
        
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 84, g: 87, b: 90, a: 1)
        return view
    }()
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 84, g: 87, b: 90, a: 1)
        view.layer.shadowOffset = CGSize(width: 0.dp, height: 20.dp)
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 20.dp
        view.clipsToBounds = false
        view.layer.masksToBounds = false
        view.layer.cornerRadius = kBottomCornerRadius
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 16.sp)
        label.textColor = UIColor.init(r: 222, g: 228, b: 234, a: 1)
        label.textAlignment = .center
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.init(r: 215, g: 225, b: 235, a: 1)
        shadow.shadowBlurRadius = 3.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        label.attributedText = String.getExpansionString(text: TMLocalizedString("探索所有可用主题"), expansion: 0.0, others: [NSAttributedString.Key.shadow: shadow])
        return label
    }()
    
    lazy var dataArray: [TMMainVcItem] = {
        return TMMainViewController.getDataArray(.bottom)
    }()
            
    lazy var collectionLayout: TMMainCollectionLayout = {
        let layout = TMMainCollectionLayout()
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionLayout)
        view.backgroundColor = .clear
        view.alwaysBounceHorizontal = true
        for item in self.dataArray {
            view.register(TMMainBottomCell.self, forCellWithReuseIdentifier: "TMMainBottomCell_\(item.type.rawValue)")
        }
        view.dataSource = self
        view.delegate = self
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()

    lazy var TiiMiiPorLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "Gill Sans", size: 16.sp)
        label.textColor = UIColor.init(r: 222, g: 228, b: 234, a: 1)
        label.textAlignment = .center
        label.isHidden = true
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.init(r: 215, g: 225, b: 235, a: 1)
        shadow.shadowBlurRadius = 3.dp
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        label.attributedText = String.getExpansionString(text: "TiiMii Pro", expansion: 0.0, others: [    NSAttributedString.Key.shadow: shadow])

        return label
    }()
    
    lazy var proView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "vip_small_icon")
        return view
    }()
    
    var didSelect: ((_ item: TMMainVcItem) -> Void)?

    var impactX = 0.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.bgView)
        self.bgView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(-kBottomCornerRadius)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22.dp)
            make.top.equalToSuperview().offset(22.dp)
        }
        
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kBottomCollectionTop)
        }
        
        self.addSubview(self.shadowView)
        self.shadowView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(kBottomCornerRadius * 2.0)
            make.bottom.equalTo(self.snp.top)
        }
        
        self.addSubview(self.TiiMiiPorLabel)
        self.TiiMiiPorLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-22.dp)
            make.centerY.equalTo(self.titleLabel.snp.centerY)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupTiiMiiPro), name: Notification.Name.kPurchseSuccess, object: nil)

        self.setupTiiMiiPro()
    }
    
    @objc func setupTiiMiiPro() {
        if TMStoreManager.share.isPro {
            self.TiiMiiPorLabel.isHidden = false
        }
        else {
            self.TiiMiiPorLabel.isHidden = true
        }
    }
             
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func cellSize() -> CGSize {
        let width = floor((LEGOScreenWidth - kBottomSectionInset * 2.0 - 15.dp * 2) / 3.0)
        return CGSize(width: width, height: width / LEGOScreenWidth * LEGOScreenHeight)
    }
    
    static func viewSize() -> CGSize {
        return CGSize(width: LEGOScreenWidth, height: TMMainBottomView.cellSize().height + kBottomCollectionTop + kBottomCollectionBottom)
    }
    
    override func motionUpdates(directin: TMMontionDirection, duration: TimeInterval) {
        super.motionUpdates(directin: directin, duration: duration)
        
        for cell in self.collectionView.visibleCells {
            if let bottomCell = cell as? TMMainBottomCell, let vc = bottomCell.vc {
                vc.motionUpdates(directin: directin, duration: duration)
            }
        }
    }
    
    override func timeUpdates() {
        super.timeUpdates()
        
        for cell in self.collectionView.visibleCells {
            if let bottomCell = cell as? TMMainBottomCell, let vc = bottomCell.vc {
                vc.timeUpdates()
            }
        }
    }
}

extension TMMainBottomView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.dataArray[indexPath.row]
        let identity = "TMMainBottomCell_\(item.type.rawValue)"
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identity, for: indexPath) as? TMMainBottomCell {
            cell.setupItem(item)
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.dataArray[indexPath.row]
        self.didSelect?(item)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

}
