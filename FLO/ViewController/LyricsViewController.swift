//
//  LyricsViewController.swift
//  FLO
//
//  Created by Dain Song on 2021/06/27.
//

import UIKit
import AVFoundation

class LyricsViewController: UIViewController {
    
    // MARK: - Properties
    var player = MusicPlayer.shared
    var viewModel = PlayerViewModel.shared
    var timeObserver: Any?
    var isScrolling = false

    // MARK: - IBOutlets
    @IBOutlet weak var lyricsTableView: UITableView!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        addObserverToPlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removePeriodicTimeObserver()
    }

    // MARK: - IBActions
    @IBAction func touchUptoggleButton(_ sender: UIButton) {
        toggleButton.isSelected.toggle()
    }
    @IBAction func touchUpCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let seconds = Double(sender.value)
        currentTimeLabel.text = player.timeText(time: seconds)
        if sender.isTracking == false {
            player.seek(CMTime(seconds: seconds, preferredTimescale: 100))
        }
    }
    
    @IBAction func touchUpPlayPauseButton(_ sender: UIButton) {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        sender.isSelected = player.isPlaying
    }
}

extension LyricsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lyricsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LyricsCell", for: indexPath) as? LyricsCell else {
            return UITableViewCell()
        }
        cell.setLyrics(text: viewModel.lyricsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lyricsTableView.reloadData()
        if toggleButton.isSelected {
            let seconds = viewModel.lyricsDict.sorted { $0.key < $1.key }[indexPath.row].key
            let time = CMTime(seconds: Double(seconds), preferredTimescale: 100)
            player.seek(time)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isScrolling = false
    }
}

extension LyricsViewController {
    
    // MARK: - Custom method
    func initializeUI() {
        totalTimeLabel.text = player.timeText(time: Double(viewModel.duration))
        progressSlider.maximumValue = Float(player.duration)
        playPauseButton.isSelected = player.isPlaying
        lyricsTableView.reloadData()
        updateTime(player.currentTime)
    }
    
    func addObserverToPlayer() {
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 10), queue: DispatchQueue.main) { time in
            guard self.isScrolling == false else { return }
            self.updateTime(time)
        }
    }
    
    func removePeriodicTimeObserver() {
        if let token = timeObserver {
            player.removeTimeObserver(token: token)
            timeObserver = nil
        }
    }
    
    func updateTime(_ time: CMTime) {
        currentTimeLabel.text = player.currentTimeText
        progressSlider.value = Float(player.currentValue)
        let index = viewModel.getCurrentLyricsIndex()
        guard viewModel.prevIndex != index else { return }
        updateLyricsTableViewCell(prev: viewModel.prevIndex, index: index)
        viewModel.prevIndex = index
    }
    
    func updateLyricsTableViewCell(prev: Int, index: Int) {
        lyricsTableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .middle, animated: true)
        
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = lyricsTableView.cellForRow(at: indexPath) as? LyricsCell {
            cell.setNowLyrics()
        }

        guard prev >= 0 else { return }
        let prevIndexPath = IndexPath(row: prev, section: 0)
        if let prevCell = lyricsTableView.cellForRow(at: prevIndexPath) as? LyricsCell {
            prevCell.desetPrevLyrics()
        }
    }
}
