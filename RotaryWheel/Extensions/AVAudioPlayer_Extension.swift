//
//  AVAudioPlayer.swift
//  RotaryWheel
//
//  Created by Icaro Lavrador on 3/06/19.
//  Copyright © 2019 Icaro Lavrador. All rights reserved.
//

import AVFoundation

extension AVAudioPlayer {
    convenience init(fileName: String){
        let url = Bundle.main.url(forResource: fileName, withExtension: "mp3")!
        try! self.init(contentsOf: url)
        prepareToPlay()
    }
}
