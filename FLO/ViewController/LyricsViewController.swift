//
//  LyricsViewController.swift
//  FLO
//
//  Created by Dain Song on 2021/06/27.
//

import UIKit

class LyricsViewController: UIViewController {

    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func touchUptoggleButton(_ sender: UIButton) {
        toggleButton.isSelected.toggle()
    }
    @IBAction func touchUpCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
