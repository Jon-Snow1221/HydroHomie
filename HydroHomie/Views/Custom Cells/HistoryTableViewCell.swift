//
//  HistoryTableViewCell.swift
//  HydroHomie
//
//  Created by Jonathan Llewellyn on 12/14/21.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    // MARK: - Outlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalSuccessOrFailImageView: UIImageView!
    
    // MARK: - Properties
    var waterDataHistory: WaterData? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Helper Methods
    func updateViews() {
        guard let waterDataHistory = waterDataHistory else { return }
        volumeLabel.text = String(waterDataHistory.volume) + " oz"
        dateLabel.text = waterDataHistory.date.formatDate()
        goalLabel.text = String(waterDataHistory.goal) + " oz"
        
//        If volume is less than goal, image = xmark.circle.fill, system red
        if waterDataHistory.volume < waterDataHistory.goal {
            goalSuccessOrFailImageView.image = UIImage(systemName: "xmark.circle.fill")
            goalSuccessOrFailImageView.tintColor = .systemRed
        } else {
            goalSuccessOrFailImageView.image = UIImage(systemName: "checkmark.circle.fill")
            goalSuccessOrFailImageView.tintColor = .systemGreen
        }
    }

}
