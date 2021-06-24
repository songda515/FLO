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
    var player: AVAudioPlayer!
    var timer: Timer!
    
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
            guard let url = URL(string: self.viewModel.music.value.file) else {
                print("wrong url")
                return
            }
            do {
                let soundData = try Data(contentsOf: url)
                self.player = try AVAudioPlayer(data: soundData)
                self.player.delegate = self
                self.player.prepareToPlay()
                self.progressSlider.maximumValue = Float(self.player.duration)
                self.progressSlider.minimumValue = 0
                self.progressSlider.value = Float(self.player.currentTime)
                self.totalTimeLabel.text = self.getTimeLabelText(time: self.player.duration)
            } catch let error as NSError {
                print("플레이어 초기화 실패")
                print("코드: \(error.code), 메세지 : \(error.localizedDescription)")
            }
        }
    }
    
    func makeAndFireTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block:  { [unowned self] (timer: Timer) in
            if self.progressSlider.isTracking { return }
            self.currentTimeLabel.text = getTimeLabelText(time: self.player.currentTime)
            self.progressSlider.value = Float(self.player.currentTime)
        })
        self.timer.fire()
    }
    
    func getTimeLabelText(time: TimeInterval) -> String {
        let minute: Int = Int(time / 60)
        let second: Int = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format: "%02ld:%02ld", minute, second)
    }
    
    func invalidateTimer() {
        self.timer.invalidate()
        self.timer = nil
    }
    
    // MARK: - IBAction
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            self.player.play()
            self.makeAndFireTimer()
        } else {
            self.player.pause()
            self.invalidateTimer()
        }
    }
    
    @IBAction func touchUpHeartButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.currentTimeLabel.text = getTimeLabelText(time: TimeInterval(sender.value))
        if sender.isTracking { return }
        self.player.currentTime = TimeInterval(sender.value)
    }
}

extension PlayerViewController: AVAudioPlayerDelegate {
    
}
