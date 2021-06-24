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
    var viewModel = PlayerViewModel()
    
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

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        bindViewModel()
    }
    
    // MARK: - Custom method
    func bindViewModel() {
        viewModel.music.bind({ (music) in
            DispatchQueue.main.async {
                self.viewModel.configure(self)
            }
        })
        viewModel.fetchMusic()
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

