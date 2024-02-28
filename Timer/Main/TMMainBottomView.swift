//
//  TMMainBottomView.swift
//  Timer
//
//  Created by yangqingren on 2024/2/26.
//

import UIKit

let kBottomCornerRadius = 40.dp
let kBottomCellSize = CGSize(width: LEGOScreenWidth * 0.2, height: LEGOScreenHeight * 0.2)

class TMMainCollectionLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        self.itemSize = kBottomCellSize
        self.minimumInteritemSpacing = 10.dp
        self.sectionInset = UIEdgeInsets.init(top: 0, left: 22.dp, bottom: 0, right: 22.dp)
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
        label.attributedText = String.getExpansionString(text: TMLocalizedString("探索所有可用主题"))
        label.textColor = .white
        label.font = .systemFont(ofSize: 18.sp, weight: .medium)
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
    
    var didSelect: ((_ item: TMMainVcItem) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.bgView)
        self.bgView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(-kBottomCornerRadius)
        }
        
        self.addSubview(self.shadowView)
        self.shadowView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(kBottomCornerRadius * 2.0)
            make.bottom.equalTo(self.snp.top)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22.dp)
            make.top.equalToSuperview().offset(19.dp)
        }
        
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(-8.dp)
        }
    }
             
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func viewSize() -> CGSize {
        return CGSize(width: LEGOScreenWidth, height: LEGOScreenHeight * 0.3)
    }
    
    override func motionUpdates(directin: TMMontionDirection) {
        super.motionUpdates(directin: directin)
        
        for cell in self.collectionView.visibleCells {
            if let bottomCell = cell as? TMMainBottomCell, let vc = bottomCell.vc {
                vc.motionUpdates(directin: directin)
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
