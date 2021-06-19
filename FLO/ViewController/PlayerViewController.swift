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
        viewModel.info()
    }
    
    // MARK: - IBAction
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func touchUpHeartButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
}

