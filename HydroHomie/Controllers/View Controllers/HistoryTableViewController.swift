//
//  HistoryTableViewController.swift
//  HydroHomie
//
//  Created by Jonathan Llewellyn on 12/8/21.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        confirmCurrentDate()
    }
    
    // MARK: - Helper Methods
    func confirmCurrentDate() {
        if let todaysEntry = WaterDataController.shared.dailyWaterEntry {
            if !Calendar.current.isDate(todaysEntry.date, inSameDayAs: Date()) {
                self.fetchEntries()
            }
        }
    }
    
    func fetchEntries() {
        WaterDataController.shared.fetchEntries { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return WaterDataController.shared.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "waterHistory", for: indexPath) as? HistoryTableViewCell else { return UITableViewCell() }

        let myData = WaterDataController.shared.entries[indexPath.row]
        cell.waterDataHistory = myData
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }


}
