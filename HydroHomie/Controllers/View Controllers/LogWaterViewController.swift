//
//  LogWaterViewController.swift
//  HydroHomie
//
//  Created by Jonathan Llewellyn on 12/8/21.
//

import UIKit

protocol UpdateWaterDelegate: AnyObject {
    func updateWaterData()
}

class LogWaterViewController: UIViewController {
    
    // MARK: - Outlets
    
    // MARK: - Properties
    weak var delegate: UpdateWaterDelegate?
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateWaterData()
    }
    
    // MARK: - Actions
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logWaterButtonTapped(_ sender: Any) {
        //Need to add water amount to database
        
        if let todaysEntry = WaterDataController.shared.dailyWaterEntry {
            WaterDataController.shared.updateEntry(for: todaysEntry, with: 8) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print(response)
                        self.dismiss(animated: true, completion: nil)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            WaterDataController.shared.saveEntry(with: 8) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print(response)
                        self.dismiss(animated: true, completion: nil)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        
    }
    
    
}// End of class

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
