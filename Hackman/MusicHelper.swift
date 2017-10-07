//
//  MusicHelper.swift
//  Hackman
//
//  Created by Keegan Campbell on 10/7/17.
//  Copyright © 2017 Alex Cevallos. All rights reserved.
//

import AVFoundation

class MusicHelper {
    static let shared = MusicHelper()
    var backgroundPlayer: AVAudioPlayer?
    var noisePlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        do {
            let audioPath = Bundle.main.path(forResource: "pacmanTheme", ofType: "mp3")
            backgroundPlayer = try AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            backgroundPlayer!.numberOfLoops = -1
            backgroundPlayer!.prepareToPlay()
            backgroundPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
    }
    
    func playEatingNoise() {
        do {
            let audioPath = Bundle.main.path(forResource: "pacmanEating", ofType: "m4a")
            noisePlayer = try AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            noisePlayer!.numberOfLoops = 1
            noisePlayer!.prepareToPlay()
            noisePlayer!.play()
        } catch {
            print("Cannot play the file")
        }
    }
}
