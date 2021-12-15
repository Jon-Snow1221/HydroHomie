//
//  SettingsViewController.swift
//  HydroHomie
//
//  Created by Jonathan Llewellyn on 12/14/21.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var currentDailyGoal: UILabel!
    @IBOutlet weak var newDailyGoal: UITextField!
    
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        confirmCurrentDate()
    }
    
    // MARK: - Actions
    @IBAction func setGoalButtonTapped(_ sender: Any) {
        //Updates Current Daily goal on settings page and on home screen
        guard let dailyGoal = newDailyGoal.text, !dailyGoal.isEmpty else { return }
        
        currentDailyGoal.text = dailyGoal
        newDailyGoal.text = ""
        
        guard let goalAsInt = Int(dailyGoal) else { return }
        WaterDataController.shared.updateDailyGoal(with: goalAsInt)
        
        if let todaysEntry = WaterDataController.shared.dailyWaterEntry {
            WaterDataController.shared.updateGoalForEntry(with: goalAsInt, waterData: todaysEntry) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print(response)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    
                }
            }
        }
    }
    
    
    // MARK: - Helper Methods
    
    func updateViews() {
        let dailyGoal = WaterDataController.shared.dailyGoal
        currentDailyGoal.text = "\(dailyGoal)"
    }
    
    func setUpView() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
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
}
