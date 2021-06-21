//
//  ViewController.swift
//  FLO
//
//  Created by Dain Song on 2021/06/19.
//

import UIKit

class PlayerViewController: UIViewController {
    
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
    var viewModel: PlayerViewModel = PlayerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindViewModel()
    }
    
    // MARK: - Custom method
    func bindViewModel() {
        viewModel.music.bind({ (music) in
            self.initializeUI()
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
    
    // MARK: - IBAction
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func touchUpHeartButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
}

