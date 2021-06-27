//
//  LyricsViewController.swift
//  FLO
//
//  Created by Dain Song on 2021/06/27.
//

import UIKit

class LyricsViewController: UIViewController {
    
    // MARK: - Properties
    var player = MusicPlayer.shared
    var viewModel = PlayerViewModel.shared

    @IBOutlet weak var lyricsTableView: UITableView!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeUI()
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
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        currentTimeLabel.text = self.player.timeText(time: TimeInterval(sender.value))
        if sender.isTracking { return }
        
        player.setCurrentTime(TimeInterval(sender.value))
        let indexPath = IndexPath(row: viewModel.getCurrentLyricsIndex(), section: 0)
        lyricsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        lyricsTableView.cellForRow(at: indexPath)?.isSelected = true
    }
}

extension LyricsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lyricsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LyricsCell", for: indexPath) as? LyricsCell else {
            return UITableViewCell()
        }
        
        cell.lyricsLabel.text = viewModel.lyricsArray[indexPath.row]

        return cell
    }
   
}

extension LyricsViewController {
    
    // MARK: - Custom Function
    func initializeUI() {
        self.progressSlider.maximumValue = player.maximumValue
        self.progressSlider.minimumValue = 0
        self.progressSlider.value = player.currentValue
        self.totalTimeLabel.text = player.totalTime
        
        let indexPath = IndexPath(row: viewModel.getCurrentLyricsIndex(), section: 0)
        lyricsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
        lyricsTableView.cellForRow(at: indexPath)?.isSelected = true
    }
    
}
