//
//  TMPageMenuView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/25.
//

import UIKit

protocol TMPageMenuViewDelegate {
    func pageMenuRoundViewCick(_ item: TMMainVcItem, _ navigation : UIPageViewController.NavigationDirection)
}

let kCollectViewLeft = 3.5.dp
let kCollectSectionLeft = 3.5.dp

class TMPageMenuFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        self.itemSize = TMPageMenuView.cellSize()
        self.minimumInteritemSpacing = 0.dp   // 横向间隔
        self.minimumLineSpacing = 0.dp  // 竖向间隔
        self.sectionInset = UIEdgeInsets.init(top: 0, left: kCollectSectionLeft, bottom: 0, right: kCollectSectionLeft)
        self.scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TMPageMenuView: UIView {
    
    var delegate: TMPageMenuViewDelegate?
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.init(r: 200, g: 200, b: 200, a: 1).cgColor, UIColor.init(r: 223, g: 223, b: 223, a: 1).cgColor, UIColor.init(r: 230, g: 230, b: 230, a: 1).cgColor]
        layer.locations = [0.0, 0.2, 1.0]
        layer.startPoint = CGPoint(x: 0.15, y: 0)
        layer.endPoint = CGPoint(x: 0.85, y: 1)
        layer.frame = CGRect(x: 0, y: 0, width: TMPageMenuView.viewSize().width, height: TMPageMenuView.viewSize().height)
        return layer
    }()

    lazy var dataArray: [TMMainVcItem] = {
        return TMMainViewController.getDataArray()
    }()
    
    lazy var collectionLayout: TMPageMenuFlowLayout = {
        let layout = TMPageMenuFlowLayout()
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionLayout)
        view.backgroundColor = .clear
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        view.register(TMPageMenuCell.self, forCellWithReuseIdentifier: "TMPageMenuCell")
        view.dataSource = self
        view.delegate = self
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.contentView.layer.addSublayer(self.gradientLayer)
        self.gradientLayer.cornerRadius = TMPageMenuView.viewSize().height / 2.0
        self.gradientLayer.borderColor = UIColor.white.cgColor
        self.gradientLayer.borderWidth = 2.dp
        self.gradientLayer.shadowColor = UIColor.init(r: 225, g: 230, b: 234, a: 1).cgColor
        self.gradientLayer.shadowOffset = CGSize(width: 0, height: 0)
        self.gradientLayer.shadowOpacity = 1.0
        self.gradientLayer.shadowRadius = 2.dp
        
        self.contentView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(kCollectViewLeft)
            make.right.equalToSuperview().offset(-kCollectViewLeft)
        }
        self.collectionView.layer.cornerRadius = TMPageMenuView.viewSize().height / 2.0
        self.collectionView.layer.masksToBounds = true
    }
                
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func cellSize() -> CGSize {
        let height = 35.dp
        return CGSize(width: height * 0.875, height: height)
    }
    
    static func viewSize() -> CGSize {
        return CGSize(width: TMPageMenuView.cellSize().width * 4.5 + kCollectSectionLeft + kCollectViewLeft + 4.dp, height: TMPageMenuView.cellSize().height)
    }
    
    var lastItem: TMMainVcItem?
    
    var impactX = 0.0
    
}

extension TMPageMenuView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if abs(self.impactX - scrollView.contentOffset.x) > 0.005 {
            self.impactX = scrollView.contentOffset.x
            TMImpactManager.share.impactOccurred(.rigid)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = self.dataArray[indexPath.row]
        let identity = "TMPageMenuCell"
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identity, for: indexPath) as? TMPageMenuCell {
            cell.item = item
            return cell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.dataArray[indexPath.row]
        if item.type == .bw {
            if item.subType == .black {
                item.subType = .white
            }
            else {
                item.subType = .black
            }
        }
        self.setupItem(item, true)
    }
    
    func setupItem(_ item: TMMainVcItem, _ animated: Bool) {
        var index = 0
        for (idx, obj) in self.dataArray.enumerated() {
            obj.isSelected = false
            if obj.type == item.type {
                obj.isSelected = true
                obj.subType = item.subType
                index = idx
            }
        }
        self.collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.scrollToItem(at: .init(row: index, section: 0), at: .left, animated: animated)
        }
        
        let navigation: UIPageViewController.NavigationDirection = self.lastItem?.type.rawValue ?? 0 > item.type.rawValue ? .reverse : .forward
        self.lastItem = item
        if item.type == .bw {
            UserDefaults.standard.set(item.subType?.rawValue ?? 0, forKey: kTMBwVcThemeColor)
        }
        UserDefaults.standard.set(item.type.rawValue, forKey: kUserDefaultsVcType)
        self.delegate?.pageMenuRoundViewCick(item, navigation)
    }
}

class TMPageMenuCell: UICollectionViewCell {
    
    lazy var round: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var bwRound: TMPageBWRoundView = {
        let view = TMPageBWRoundView()
        return view
    }()
        
    lazy var selectRound: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.init(r: 51, g: 51, b: 51, a: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.selectRound)
        self.selectRound.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 25.dp, height: 25.dp))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.selectRound.layer.cornerRadius = 25.dp / 2.0
        self.selectRound.layer.masksToBounds = true
        
        self.addSubview(self.round)
        self.round.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 18.dp, height: 18.dp))
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.round.layer.cornerRadius = 18.dp / 2.0
        self.round.layer.shadowOffset = CGSize(width: 1.dp, height: 1.dp)
        self.round.layer.shadowColor = UIColor.lightGray.cgColor
        self.round.layer.shadowOpacity = 1.0
        self.round.layer.shadowRadius = 1.dp
        
        self.round.addSubview(self.bwRound)
        self.bwRound.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.bwRound.layer.cornerRadius = 18.dp / 2.0
        self.bwRound.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var item: TMMainVcItem? {
        didSet {
            guard let item = item else { return }
            switch item.type {
            case .bw:
                self.round.backgroundColor = UIColor.init(r: 242, g: 242, b: 242, a: 0)
                self.bwRound.isHidden = false
                let subType = TMBwVcTheme.init(rawValue: UserDefaults.standard.integer(forKey: kTMBwVcThemeColor)) ?? .white
                if subType == .black {
                    self.bwRound.transform = CGAffineTransform.identity.rotated(by: .pi / 180 * 45.0 + .pi)
                }
                else {
                    self.bwRound.transform = CGAffineTransform.identity.rotated(by: .pi / 180 * 45.0)
                }
            case .shadow:
                self.round.backgroundColor = UIColor.init(r: 116, g: 188, b: 136, a: 1)
                self.bwRound.isHidden = true
            case .block:
                self.round.backgroundColor = kBlockClockBlue
                self.bwRound.isHidden = true
            case .heart:
                self.round.backgroundColor = UIColor.init(r: 225, g: 152, b: 165, a: 1)
                self.bwRound.isHidden = true
            case .clock:
                self.round.backgroundColor = UIColor.init(r: 231, g: 215, b: 207, a: 1)
                self.bwRound.isHidden = true
            case .clock2:
                self.round.backgroundColor = UIColor.init(r: 226, g: 235, b: 245, a: 1)
                self.bwRound.isHidden = true
            case .electron:
                self.round.backgroundColor = UIColor.init(r: 186, g: 186, b: 186, a: 1)
                self.bwRound.isHidden = true
            case .neon:
                self.round.backgroundColor = .black
                self.bwRound.isHidden = true
            }
            if item.isSelected {
                self.selectRound.backgroundColor = UIColor.init(r: 58, g: 58, b: 58, a: 1)
                self.round.layer.masksToBounds = true
            }
            else {
                self.selectRound.backgroundColor = UIColor.init(r: 234, g: 240, b: 246, a: 1)
                self.round.layer.masksToBounds = false
            }
            
            if item.subType == .black {
                self.bwRound.transform = CGAffineTransform.identity.rotated(by: .pi / 180 * 45.0 + .pi)
            }
            else {
                self.bwRound.transform = CGAffineTransform.identity.rotated(by: .pi / 180 * 45.0)
            }
        }
    }
}

class TMPageBWRoundView: UIView {
    
    lazy var round1: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.init(r: 242, g: 242, b: 242, a: 1)
        return view
    }()
    
    lazy var round2: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.round1)
        self.round1.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(self.snp.centerX)
        }
        
        self.addSubview(self.round2)
        self.round2.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(self.snp.centerX)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

