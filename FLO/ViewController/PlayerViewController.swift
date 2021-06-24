//
//  ViewController.swift
//  FLO
//
//  Created by Dain Song on 2021/06/19.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    // MARK: - Properties
    var player = MusicPlayer.shared
    
    // MARK: - IBOutlet
    @IBOutlet var thumbImage: UIImageView!
    @IBOutlet var albumLabel: UILabel!
    @IBOutlet var singerLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var progressSlider: UISlider!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!

    // MARK: View Model
    private var viewModel = PlayerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindViewModel()
    }
    
    // MARK: - Custom method
    func bindViewModel() {
        viewModel.music.bind({ (music) in
            self.initializeUI()
            self.initializePlayer()
        })
        viewModel.imageData.bind({ (image) in
            self.initializeImage()
        })
        viewModel.fetchMusic()
    }
    
    func initializeUI() {
        DispatchQueue.main.async {
            let music = self.viewModel.music.value
            self.albumLabel.text = music.album
            self.singerLabel.text = music.singer
            self.titleLabel.text = music.title
        }
    }
    
    func initializeImage() {
        DispatchQueue.main.async {
            let imageData = self.viewModel.imageData.value
            self.thumbImage.image = UIImage(data: imageData)
        }
    }
    
    func initializePlayer() {
        
        DispatchQueue.main.async {
            self.player.initPlayer(url: self.viewModel.music.value.file)
            //self.player.delegate = self
            //self.player.prepareToPlay()
            self.progressSlider.maximumValue = self.player.maximumValue
            self.progressSlider.minimumValue = 0
            self.progressSlider.value = self.player.currentValue
            self.totalTimeLabel.text = self.player.totalTime
        }
    }
    
    // MARK: - IBAction
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            self.player.play { Timer in
                if self.progressSlider.isTracking { return }
                self.currentTimeLabel.text = self.player.currentTime
                self.progressSlider.value = self.player.currentValue
            }
        } else {
            self.player.pause()
        }
    }
    
    @IBAction func touchUpHeartButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.currentTimeLabel.text = self.player.timeText(time: TimeInterval(sender.value))
        if sender.isTracking { return }
        self.player.setCurrentTime(TimeInterval(sender.value))
    }
}

extension PlayerViewController: AVAudioPlayerDelegate {
    
}
