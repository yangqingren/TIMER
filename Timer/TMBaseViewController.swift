//
//  TMBaseViewController.swift
//  Timer
//
//  Created by yangqingren on 2024/2/21.
//

import UIKit

protocol TMTimeUpdatesProtocol {
    func motionUpdates(directin: TMMontionDirection)
    func timeUpdates()
}

class TMBaseViewController: UIViewController {

    lazy var batteryView: TMBatteryLevelView = {
        let view = TMBatteryLevelView()
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.isKind(of: TMBlockClockViewController.self) {
            self.batteryView.battery.image = UIImage.init(named: "common_battery_white")
            self.batteryView.battery.alpha = 0.7
        }
        else {
            self.batteryView.battery.image = UIImage.init(named: "common_battery_nomal")
            self.batteryView.battery.alpha = 1.0
        }
        self.batteryView.setupBatteryLevel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view.
    }
    
    func setupBatteryView() {
        self.view.addSubview(self.batteryView)
        self.batteryView.snp.makeConstraints { make in
            make.right.equalTo(self.view.safeAreaInsets.left).offset(-20.dp)
            make.centerY.equalTo(self.view.safeAreaInsets.top).offset(55.dp + 10.dp)
            make.size.equalTo(CGSize(width: 30.dp, height: 30.dp))
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    func motionUpdates(directin: TMMontionDirection) {
        for subView in self.view.subviews {
            if let view = subView as? TMBaseView {
                view.motionUpdates(directin: directin)
            }
            for subsubView in subView.subviews {
                if let view = subsubView as? TMBaseView {
                    view.motionUpdates(directin: directin)
                }
            }
        }
    }
    
    func timeUpdates() {
        for subView in self.view.subviews {
            if let view = subView as? TMBaseView {
                view.timeUpdates()
            }
            for subsubView in subView.subviews {
                if let view = subsubView as? TMBaseView {
                    view.timeUpdates()
                }
            }
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
