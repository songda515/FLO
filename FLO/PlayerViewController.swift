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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

