//
//  HomeScreenViewController.swift
//  HydroHomie
//
//  Created by Jonathan Llewellyn on 12/8/21.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var dailyVolumeLabel: UILabel!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEntries()
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helper Methods
    func updateViews() {
        guard let todaysEntry = WaterDataController.shared.dailyWaterEntry else { return }
        dailyVolumeLabel.text = "\(todaysEntry.volume) oz"
    }
    
    func fetchEntries() {
        WaterDataController.shared.fetchEntries { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    self.updateViews()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLogWaterVC" {
            guard let destination = segue.destination as? LogWaterViewController else { return }
            destination.delegate = self
        }
    }
    
}// End of class

extension HomeScreenViewController: UpdateWaterDelegate {
    func updateWaterData() {
        updateViews()
    }

}// End of extension
