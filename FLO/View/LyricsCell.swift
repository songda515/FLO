//
//  LyricsCell.swift
//  FLO
//
//  Created by Dain Song on 2021/06/27.
//

import UIKit

class LyricsCell: UITableViewCell {
    
    @IBOutlet weak var lyricsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        desetPrevLyrics()
    }
    
    func setLyrics(text: String) {
        lyricsLabel.text = text
    }
    
    func setNowLyrics() {
        if #available(iOS 13.0, *) {
            self.backgroundColor = .systemGray5
        } else {
            // Fallback on earlier versions
            backgroundColor = .lightGray
        }
        lyricsLabel.textColor = .systemPink
        lyricsLabel.font = UIFont.boldSystemFont(ofSize: lyricsLabel.font.pointSize)
    }
    
    func desetPrevLyrics() {
        self.backgroundColor = .clear
        lyricsLabel.textColor = .black
        lyricsLabel.font = UIFont.systemFont(ofSize: lyricsLabel.font.pointSize)
    }

}
