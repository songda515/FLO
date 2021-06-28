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
    var timeObserver: Any?
    
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
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureLyricsView()
        bindViewModel()
        addObserverToPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playPauseButton.isSelected = player.isPlaying
    }
    
    // MARK: - IBAction
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        sender.isSelected = player.isPlaying
    }
    
    @IBAction func touchUpHeartButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let seconds = Double(sender.value)
        currentTimeLabel.text = player.timeText(time: seconds)
        if sender.isTracking == false {
            player.seek(CMTime(seconds: seconds, preferredTimescale: 100))
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
        albumLabel.text = viewModel.album
        singerLabel.text = viewModel.singer
        titleLabel.text = viewModel.title
        thumbImage.image = UIImage(data: viewModel.imageData)
        progressSlider.maximumValue = Float(viewModel.duration)
        totalTimeLabel.text = player.timeText(time: Double(viewModel.duration))
        stackView.isHidden = false
        indicatorView.isHidden = true
        updateTime(time: CMTime.zero)
    }
    
    func initializePlayer() {
        player.initPlayer(url: viewModel.musicFileUrl)
    }
    
    func addObserverToPlayer() {
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main) { time in
            self.updateTime(time: time)
        }
    }
    
    func updateTime(time: CMTime) {
        currentTimeLabel.text = player.currentTimeText
        progressSlider.value = Float(player.currentValue)
        let index = viewModel.getCurrentLyricsIndex()
        lyricsLabel.text = viewModel.lyricsArray[index]
    }
}

