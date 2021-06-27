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
    var viewModel = PlayerViewModel.shared
    
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
    @IBOutlet weak var lyricsView: UIView!
    @IBOutlet weak var lyricsLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addGestureLyricsView()
        bindViewModel()
    }
    
    // MARK: - IBAction
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            self.player.play { Timer in
                if self.progressSlider.isTracking { return }
                self.currentTimeLabel.text = self.player.currentTime
                self.progressSlider.value = self.player.currentValue
                self.viewModel.getCurrentLyrics { lyrics in
                    self.lyricsLabel.text = lyrics
                }
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
        self.viewModel.getCurrentLyrics { lyrics in
            self.lyricsLabel.text = lyrics
        }
    }
    
    @IBAction func tappedLyricsView(_ sender: UIView) {
        if #available(iOS 13.0, *) {
            let lyricsVC = storyboard!.instantiateViewController(identifier: "LyricsViewController")
            lyricsVC.modalPresentationStyle = .fullScreen
            self.present(lyricsVC, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            let lyricsVC = storyboard!.instantiateViewController(withIdentifier: "LyricsViewController")
            self.present(lyricsVC, animated: true, completion: nil)
        }
    }
}

extension PlayerViewController {
    
    // MARK: - Custom method
    func addGestureLyricsView() {
        let tapGasture = UITapGestureRecognizer(target: self, action: #selector(tappedLyricsView(_:)))
        self.lyricsView.addGestureRecognizer(tapGasture)
    }
    
    func bindViewModel() {
        viewModel.music.bind({ (music) in
            DispatchQueue.main.async {
                self.initializeUI()
                self.initializePlayer()
            }
        })
        viewModel.fetchMusic()
    }
    
    func initializeUI() {
        self.albumLabel.text = viewModel.album
        self.singerLabel.text = viewModel.singer
        self.titleLabel.text = viewModel.title
        self.thumbImage.image = UIImage(data: viewModel.imageData)
    }
    
    func initializePlayer() {
        self.player.initPlayer(url: viewModel.musicFileUrl)
        self.progressSlider.maximumValue = player.maximumValue
        self.progressSlider.minimumValue = 0
        self.progressSlider.value = player.currentValue
        self.totalTimeLabel.text = player.totalTime
    }
}

