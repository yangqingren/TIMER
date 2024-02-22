//
//  TMBasePageViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import UIKit

class TMBasePageViewController: TMBaseViewController {

    lazy var transformView: UIView = {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.transformView)
        self.transformView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name.kBackgroundColor, object: self.view.backgroundColor)
    }
    
    override func motionUpdates(directin: TMMontionDirection) {
        super.motionUpdates(directin: directin)
        
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
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.transformView.transform = transform
        }
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
