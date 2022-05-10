//
//  CustomTVC.swift
//  VideoPlayer
//
//  Created by Shivaditya Kumar on 09/05/22.
//

import UIKit

class CustomTVC: UITableViewCell {

    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var thumbNailImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setData(imageURL: UIImage, title: String, subtitle: String) {
        self.videoTitleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.thumbNailImageView.image = imageURL
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
