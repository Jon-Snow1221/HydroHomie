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
    @IBOutlet weak var currentDailyGoal: UILabel!
    @IBOutlet weak var ringBar: CircularProgressBar!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchEntries()
        WaterDataController.shared.loadFromPersistenceStore() //Loads up goal from previous day
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
        confirmCurrentDate()
    }
    
    // MARK: - Actions
    
    
    // MARK: - Helper Methods
    func updateViews() {
        let todaysGoal = WaterDataController.shared.dailyGoal
        currentDailyGoal.text = "\(todaysGoal) oz"
        
        guard let todaysEntry = WaterDataController.shared.dailyWaterEntry else { return }
        dailyVolumeLabel.text = "\(todaysEntry.volume) oz"
    }
    
    func progressBar() {
        let todaysGoal = WaterDataController.shared.dailyGoal
        guard let todaysEntry = WaterDataController.shared.dailyWaterEntry else { return }
        
//        let progress = todaysEntry / todaysGoal
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
    
    func confirmCurrentDate() {
        if let todaysEntry = WaterDataController.shared.dailyWaterEntry {
            if !Calendar.current.isDate(todaysEntry.date, inSameDayAs: Date()) {
                self.fetchEntries()
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
