//
//  TMBgMp3Manager.swift
//  Timer
//
//  Created by yangqingren on 2024/3/13.
//

import UIKit
import AVFoundation
import MediaPlayer

enum TMBgMusicType: String {
    case none = ""
    case light_rain = "light_rain"
    case heavy_rain = "heavy_rain"
    case summer_cicadas = "summer_cicadas"
    case summer_bird = "summer_bird"
    case light_night = "light_night"
    case heavy_night = "heavy_night"
    case fire = "fire"
    case snow = "snow"
    
    func next() -> TMBgMusicType {
        let allCases: [TMBgMusicType] = [
            .light_rain, .heavy_rain,
            .summer_cicadas, .summer_bird,
            .light_night, .heavy_night,
            .fire, .snow]
        guard let currentIndex = allCases.firstIndex(of: self) else {
            return .none // 如果当前 case 不在列表中，则返回默认值
        }
        let nextIndex = (currentIndex + 1) % allCases.count
        return allCases[nextIndex]
    }
    
    func previous() -> TMBgMusicType {
        let allCases: [TMBgMusicType] = [
            .light_rain, .heavy_rain,
            .summer_cicadas, .summer_bird,
            .light_night, .heavy_night,
            .fire, .snow]
        guard let currentIndex = allCases.firstIndex(of: self) else {
            return .none
        }
        let previousIndex = (currentIndex - 1 + allCases.count) % allCases.count
        return allCases[previousIndex]
    }
}

let kTMBgMusicSaved = "kTMBgMusicSaved"

class TMBgMp3Manager: NSObject {

    static let share = TMBgMp3Manager()
    
    var audioPlayer: AVAudioPlayer?
    
    lazy var musicButton: TMBgMusicButton = {
        let button = TMBgMusicButton()
        button.addTarget(self, action: #selector(musicButtonClick), for: .touchUpInside)
        return button
    }()
    
    @objc func musicButtonClick() {
        if let view = TMGetTopController()?.view {
            TMBgMp3PupouView.show(inView: view)
        }
    }
    
    lazy var musicButton2: TMBgMusicButton = {
        let button = TMBgMusicButton()
        return button
    }()
    
    lazy var dataArray: [TMBgMp3Item] = {
        return [
            TMBgMp3Item.init(type: .light_rain),
            TMBgMp3Item.init(type: .heavy_rain),
            TMBgMp3Item.init(type: .summer_cicadas),
            TMBgMp3Item.init(type: .summer_bird),
            TMBgMp3Item.init(type: .light_night),
            TMBgMp3Item.init(type: .heavy_night),
            TMBgMp3Item.init(type: .fire),
            TMBgMp3Item.init(type: .snow)
        ]
    }()
    
    var palyingType: TMBgMusicType {
        get {
            let string = UserDefaults.standard.string(forKey: kTMBgMusicSaved) ?? ""
            let type = TMBgMusicType.init(rawValue: string) ?? .none
            return type
        }
    }
    
    static func getMusicName(_ type: TMBgMusicType) -> String {
        var name: String?
        switch type {
        case .none:
            name = ""
        case .light_rain:
            name = TMLocalizedString("轻雨")
        case .heavy_rain:
            name = TMLocalizedString("沥雨")
        case .summer_cicadas:
            name = TMLocalizedString("夏日蝉鸣")
        case .summer_bird:
            name = TMLocalizedString("夏日鸟语")
        case .light_night:
            name = TMLocalizedString("入夜")
        case .heavy_night:
            name = TMLocalizedString("深夜")
        case .fire:
            name = TMLocalizedString("火🔥")
        case .snow:
            name = TMLocalizedString("雪❄️")
        }
        return name ?? ""
    }
    
    static func getMusicFile(_ type: TMBgMusicType) -> String? {
        return type.rawValue
    }
    
    static func getMusicIcon(_ type: TMBgMusicType) -> UIImage {
        return UIImage(named: type.rawValue) ?? UIImage(named: "mian_button_emtry")!
    }

    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.current) { [weak self] (notification) in
            guard let `self` = self else { return }
            if let audioPlayer = self.audioPlayer, audioPlayer.isPlaying {
                self.startAnimation()
            }
            else {
                self.stopAnimation()
            }
        }
                

//        MPRemoteCommandCenter.shared().playCommand.addTarget {[weak self] _ in
//            guard let `self` = self else { return .success}
//            if let audioPlayer = self.audioPlayer, audioPlayer.isPlaying {
//                self.stop()
//            }
//            else {
//                self.start(item: TMBgMp3Item.init(type: self.palyingType))
//            }
//            return .success
//        }
//        
//        MPRemoteCommandCenter.shared().pauseCommand.addTarget {[weak self] _ in
//            guard let `self` = self else { return .success}
//            if let audioPlayer = self.audioPlayer, audioPlayer.isPlaying {
//                self.stop()
//            }
//            else {
//                self.start(item: TMBgMp3Item.init(type: self.palyingType))
//            }
//            return .success
//        }
//        
//        MPRemoteCommandCenter.shared().togglePlayPauseCommand.addTarget {[weak self] _ in
//            guard let `self` = self else { return .success}
//            if let audioPlayer = self.audioPlayer, audioPlayer.isPlaying {
//                self.stop()
//            }
//            else {
//                self.start(item: TMBgMp3Item.init(type: self.palyingType))
//            }
//            return .success
//        }
//        
//        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget {[weak self] _ in
//            guard let `self` = self else { return .success}
//            let next = self.palyingType.next()
//            self.start(item: TMBgMp3Item.init(type: next))
//            return .success
//        }
//         
//        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget {[weak self] _ in
//            guard let `self` = self else { return .success}
//            let previous = self.palyingType.previous()
//            self.start(item: TMBgMp3Item.init(type: previous))
//            return .success
//        }
        
        self.setupPlaying()
    }
        
    var file: String?

}

extension TMBgMp3Manager {
    
    func start(item: TMBgMp3Item?) {
        if let item = item {
            UserDefaults.standard.set(item.type.rawValue, forKey: kTMBgMusicSaved)
        }
        else {
            UserDefaults.standard.set(TMBgMusicType.none.rawValue, forKey: kTMBgMusicSaved)
        }
        self.setupPlaying()
    }
    
    func setupPlaying() {
        let type = self.palyingType
        var item: TMBgMp3Item?
        for obj in self.dataArray {
            if obj.type == type {
                item = obj
                break
            }
        }
        if let item = item {
            self.play(file: item.file)
        }
        else {
            self.stop()
        }
        // self.setupMpInfoCenter(type: type)
        if let audioPlayer = self.audioPlayer, audioPlayer.isPlaying {
            self.startAnimation()
        }
        else {
            self.stopAnimation()
        }
    }
    
    func play(file: String) {
        if let audioPlayer = self.audioPlayer, audioPlayer.isPlaying, file == self.file {
            return
        }
        self.stop()
        self.file = file
        if file.count > 0, let sound = Bundle.main.path(forResource: file, ofType: "mp3") {
            let url = URL(fileURLWithPath: sound)
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                self.audioPlayer?.numberOfLoops = -1
                self.audioPlayer?.play()
                self.startAnimation()
            }
            catch {
                debugPrint("播放音频文件时出现错误: \(error)")
            }
        }
    }
    
    func setupMpInfoCenter(type: TMBgMusicType) {
        if type == .none {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
        }
        else {
            let now: [String: Any] = [
                MPMediaItemPropertyTitle: TMBgMp3Manager.getMusicName(type),
//                MPMediaItemPropertyArtwork: MPMediaItemArtwork(boundsSize: CGSize(width: 100.dp, height: 100.dp), requestHandler: { _ in
//                    return TMBgMp3Manager.getMusicIcon(type)
//                })
            ]
            MPNowPlayingInfoCenter.default().nowPlayingInfo = now
        }
    }
    
    func stop() {
        if let audioPlayer = self.audioPlayer {
            audioPlayer.stop()
        }
        self.audioPlayer = nil
        self.stopAnimation()
    }
}

extension TMBgMp3Manager {
    
    func startAnimation() {
        self.musicButton.startAnimation()
        self.musicButton2.startAnimation()
    }
    
    func stopAnimation() {
        self.musicButton.stopAnimation()
        self.musicButton2.stopAnimation()
    }
}
