//
//  MTLiveWidgetBundle.swift
//  MTLiveWidget
//
//  Created by yangqingren on 2024/1/3.
//

import WidgetKit
import SwiftUI

@main
struct MTLiveWidgetBundle: WidgetBundle {
    var body: some Widget {
        MTLiveAndLockWidget()
        MTUniversalWidget()
    }
}
