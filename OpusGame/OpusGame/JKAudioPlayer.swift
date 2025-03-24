//
//  JKAudioPlayer.swift
//  OpusTV
//
//  Created by Simone Boscaglia on 18/03/25.
//


import Foundation
import SpriteKit
import AVFoundation

/**Manages a shared instance of JKAudioPlayer.*/
private let JKAudioInstance = JKAudioPlayer()

/**Provides an easy way to play sounds and music. Use sharedInstance method to access
   a single object for the entire game to manage the sound and music.*/
open class JKAudioPlayer {

    /**Used to access music.*/
    var musicPlayer: AVAudioPlayer!
    var soundPlayer: AVAudioPlayer!

    /** Allows the audio to be shared with other music (such as music being played from your music app).
     If this setting is false, music you play from your music player will stop when this app's music starts.
     Default set by Apple is false. */
    static var canShareAudio = false {
        didSet {
            canShareAudio ? try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
            : try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.soloAmbient)
        }
    }

    /**Creates an instance of the JAAudio class so the user doesn't have to make
       their own instance and allows use of the functions. */
    open class func sharedInstance() -> JKAudioPlayer {
        return JKAudioInstance
    }

    /**Plays music. You can ignore the "type" property if you include the full name with extension
       in the "filename" property. Set "canShareAudio" to true if you want other music to be able
       to play at the same time (default by Apple is false).*/
    open func playMusic(_ fileName: String, withExtension type: String = ".mp3") {
        if let url = Bundle.main.url(forResource: fileName, withExtension: type) {
            musicPlayer = try? AVAudioPlayer(contentsOf: url)
            musicPlayer.numberOfLoops = -1
            musicPlayer.prepareToPlay()
            musicPlayer.play()
        }
    }

    /**Stops the music. Use the "resumeMusic" method to turn it back on. */
    open func stopMusic() {
        if musicPlayer != nil && musicPlayer!.isPlaying {
            musicPlayer.currentTime = 0
            musicPlayer.stop()
        }
    }

    /**Pauses the music. Use the "resumeMusic" method to turn it back on. */
    open func pauseMusic() {
        if musicPlayer != nil && musicPlayer!.isPlaying {
            musicPlayer.pause()
        }
    }

    /**Resumes the music after being stopped or paused. */
    open func resumeMusic() {
        if musicPlayer != nil && !musicPlayer!.isPlaying {
            musicPlayer.play()
        }
    }

    /**Plays a single sound.*/
    open func playSoundEffect(named fileName: String, withExtension type: String = ".mp3") {
        if let url = Bundle.main.url(forResource: fileName, withExtension: type) {
            soundPlayer = try? AVAudioPlayer(contentsOf: url)
            //soundPlayer.stop()
            soundPlayer.numberOfLoops = 1
            soundPlayer.prepareToPlay()
            soundPlayer.play()
        }
    }
}

let audio = JKAudioPlayer.sharedInstance()
