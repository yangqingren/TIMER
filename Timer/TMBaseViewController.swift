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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
