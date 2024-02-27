//
//  LaunchViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/2/27.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
   
        let shaow = UIImageView()
        shaow.image = UIImage.init(named: "launch_white")
        shaow.layer.shadowOffset = CGSize(width: 100.dp, height: 100.dp)
        shaow.layer.shadowRadius = 100.dp
        shaow.layer.shadowColor = UIColor.init(r: 42, g: 95, b: 215, a: 1).cgColor
        shaow.layer.shadowOpacity = 1.0
        self.view.addSubview(shaow)
        shaow.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: LEGOScreenWidth, height: LEGOScreenWidth))
            make.right.equalTo(self.view.snp.left)
            make.bottom.equalTo(self.view.snp.centerY).offset(-LEGOScreenWidth / 2.0)
        }
        
        let shaow2 = UIImageView()
        shaow2.image = UIImage.init(named: "launch_white")
        shaow2.layer.shadowOffset = CGSize(width: -100.dp, height: -100.dp)
        shaow2.layer.shadowRadius = 100.dp
        shaow2.layer.shadowColor = UIColor.init(r: 42, g: 95, b: 215, a: 1).cgColor
        shaow2.layer.shadowOpacity = 1.0
        self.view.addSubview(shaow2)
        shaow2.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: LEGOScreenWidth, height: LEGOScreenWidth))
            make.left.equalTo(self.view.snp.right)
            make.top.equalTo(self.view.snp.centerY).offset(LEGOScreenWidth / 2.0)
        }
        
        let imageview = UIImageView()
        imageview.image = UIImage.init(named: "launch_icon")
        self.view.addSubview(imageview)
        imageview.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: LEGOScreenWidth * 0.9, height: LEGOScreenWidth * 0.9))
            make.centerX.equalToSuperview().offset(0.dp)
            make.centerY.equalToSuperview()
        }
        imageview.transform = CGAffineTransform.identity.rotated(by: .pi / 180.0 * 10.0)
        

        
        // Do any additional setup after loading the view.
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
