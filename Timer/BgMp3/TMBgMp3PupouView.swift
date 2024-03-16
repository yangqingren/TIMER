//
//  TMBgMp3ViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/3/13.
//

import UIKit

class TMBgMp3PupouView: UIView {
    
    lazy var selectLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "ChalkboardSE-Regular", size: 17.sp)
        label.attributedText = String.getExpansionString(text: "Select", expansion: -0.2)
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "ChalkboardSE-Regular", size: 17.sp)
        label.attributedText = String.getExpansionString(text: TMLocalizedString("白噪音 - 背景音乐"), expansion: -0.2)
        return label
    }()
    
    lazy var playingLabel: UILabel = {
        let label = UILabel()
        label.font = .init(name: "ChalkboardSE-Regular", size: 11.sp)
        label.attributedText = String.getExpansionString(text: TMLocalizedString("正在播放"), expansion: -0.2)
        return label
    }()
            
    lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let spacingY = 25.dp
        let spacingX = (LEGOScreenWidth - TMBgMp3Cell.viewSize().width * 2.0) / 3.0
        layout.itemSize = TMBgMp3Cell.viewSize()
        layout.minimumInteritemSpacing = spacingX   // 横向间隔
        layout.minimumLineSpacing = spacingY  // 竖向间隔
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: spacingX, bottom: 0, right: spacingX)
        layout.scrollDirection = .vertical
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.collectionLayout)
        view.backgroundColor = .clear
        view.register(TMBgMp3Cell.self, forCellWithReuseIdentifier: "TMBgMp3Cell")
        view.dataSource = self
        view.delegate = self
        view.alwaysBounceVertical = true
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    lazy var backButton: LEGOHighlightButton = {
        let button = LEGOHighlightButton(type: .custom)
        button.setImage(UIImage(named: "mian_button_back"), for: .normal)
        button.setImage(UIImage(named: "mian_button_back"), for: .highlighted)
        button.hotspot = 20.dp
        button.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return button
    }()
    
    @objc func backButtonClick() {
        self.dismiss()
    }
    
    lazy var closeButton: LEGOHighlightButton = {
        let button = LEGOHighlightButton(type: .custom)
        button.setImage(UIImage.init(named: "music_close_nomal"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        return button
    }()
    
    @objc func closeButtonClick() {
        TMBgMp3Manager.share.start(item: nil)
        self.setupPlayingUI()
    }
    
    static var isShow = false
    
    static func show(inView: UIView) {
        let view = TMBgMp3PupouView(frame: .zero, inView: inView)
        view.show()
    }
    
    func show() {
        TMBgMp3PupouView.isShow = true
        self.collectionView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: LEGOScreenHeight)
        self.collectionView.alpha = 0
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = UIColor.init(r: 241, g: 245, b: 250, a: 0.5)
            self.collectionView.transform = CGAffineTransform.identity
            self.collectionView.alpha = 1
        } completion: { _ in

        }
    }
    
    func dismiss(durtion: TimeInterval = 0.1) {
        TMBgMp3Manager.share.musicButton2.removeTarget(self, action: #selector(musicButtonClick), for: .touchUpInside)
        TMBgMp3PupouView.isShow = false
        UIView.animate(withDuration: durtion) {
            self.backgroundColor = .clear
            self.collectionView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: LEGOScreenHeight)
            self.collectionView.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    init(frame: CGRect, inView: UIView) {
        super.init(frame: frame)
        
        inView.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.backgroundColor = .clear
        
        let gl = CAGradientLayer()
        gl.frame = CGRect(x: 0, y: 0, width: LEGOScreenWidth, height: LEGOScreenHeight)
        gl.startPoint = CGPoint(x: 0, y: 0)
        gl.endPoint = CGPoint(x: 0, y: 1)
        gl.colors = [UIColor.init(r: 228, g: 223, b: 222, a: 1).cgColor, UIColor.init(r: 228, g: 223, b: 222, a: 0).cgColor]
        gl.locations = [0.0, 1]
        self.layer.addSublayer(gl)

        let gl2 = CAGradientLayer()
        gl2.frame = CGRect(x: 0, y: 0, width: LEGOScreenWidth, height: LEGOScreenHeight)
        gl2.startPoint = CGPoint(x: 0, y: 1)
        gl2.endPoint = CGPoint(x: 0, y: 0)
        gl2.colors = [UIColor.init(r: 228, g: 223, b: 222, a: 1).cgColor, UIColor.init(r: 228, g: 223, b: 222, a: 0).cgColor]
        gl2.locations = [0.0, 1]
        self.layer.addSublayer(gl2)
        
        self.addSubview(self.selectLabel)
        self.selectLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LEGONavMargan + 20.dp)
            make.left.equalToSuperview().offset(40.dp)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self.selectLabel)
            make.top.equalTo(self.selectLabel.snp.bottom).offset(6.dp)
        }
        
        self.addSubview(self.playingLabel)
        self.playingLabel.snp.makeConstraints { make in
            make.left.equalTo(self.selectLabel)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8.dp)
        }
        self.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20.dp, height: 20.dp))
            make.centerY.equalTo(self.playingLabel)
            make.left.equalTo(self.playingLabel.snp.right)
        }
        
        self.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.playingLabel.snp.bottom).offset(54.dp)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.addSubview(self.backButton)
        self.backButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 32.dp, height: 32.dp))
            make.right.equalToSuperview().offset(-40.dp)
            make.top.equalTo(self.selectLabel)
        }
        
        self.addSubview(TMBgMp3Manager.share.musicButton2)
        TMBgMp3Manager.share.musicButton2.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 32.dp, height: 32.dp))
            make.right.equalTo(self.backButton.snp.left).offset(-20.dp)
            make.top.equalTo(self.selectLabel)
        }
        TMBgMp3Manager.share.musicButton2.addTarget(self, action: #selector(musicButtonClick), for: .touchUpInside)
        
        self.setupPlayingUI()
        TMBgMp3Manager.share.setupPlaying()
    }
        
    func setupPlayingUI() {
        let type = TMBgMp3Manager.share.palyingType
        for obj in TMBgMp3Manager.share.dataArray {
            if obj.type == type {
                obj.isSelected = true
            }
            else {
                obj.isSelected = false
            }
        }
        var item: TMBgMp3Item?
        for obj in TMBgMp3Manager.share.dataArray {
            if obj.isSelected {
                item = obj
                break
            }
        }
        if let item = item {
            self.playingLabel.attributedText = String.getExpansionString(text: "\(TMLocalizedString("正在播放"))「\(item.name)」")
            self.closeButton.isHidden = false
        }
        else {
            self.playingLabel.attributedText = String.getExpansionString(text: TMLocalizedString("未在播放"))
            self.closeButton.isHidden = true
        }
        self.collectionView.reloadData()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TMBgMp3PupouView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TMBgMp3Manager.share.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = TMBgMp3Manager.share.dataArray[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TMBgMp3Cell", for: indexPath) as? TMBgMp3Cell {
            cell.item = item
            return cell
        }
        else {
            let cell = TMBgMp3Cell()
            cell.item = item
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = TMBgMp3Manager.share.dataArray[indexPath.row]
        if item.isSelected {
            TMBgMp3Manager.share.start(item: nil)
        }
        else {
            TMBgMp3Manager.share.start(item: item)
        }
        self.setupPlayingUI()
    }
    
    @objc func musicButtonClick() {
        let type = TMBgMp3Manager.share.palyingType
        var item: TMBgMp3Item?
        for obj in TMBgMp3Manager.share.dataArray {
            if obj.type == type {
                item = obj
                break
            }
        }
        if let _ = item {
            TMBgMp3Manager.share.start(item: nil)
            self.setupPlayingUI()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentOffsetY = self.collectionView.contentOffset.y
        debugPrint("contentOffset=\(contentOffsetY)")
        if contentOffsetY < -10 {
            self.collectionView.transform = CGAffineTransform.identity.translatedBy(x: 0, y: abs(contentOffsetY))
            self.dismiss(durtion: 0.25)

        }
    }

}
