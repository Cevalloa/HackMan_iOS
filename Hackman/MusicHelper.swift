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
    var audioPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        //let soundTrack = NSURL(fileURLWithPath: Bundle.main.path(forResource: "pacmanSoundtrack", ofType: "m4a")!)
        do {
            let audioPath = Bundle.main.path(forResource: "pacmanTheme", ofType: "mp3")
            audioPlayer = try AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch {
            print("Cannot play the file")
        }
    }
}
