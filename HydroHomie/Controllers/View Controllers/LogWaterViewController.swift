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
    @IBOutlet weak var waterVolTextField: UITextField!
    @IBOutlet weak var eightOZButton: UIButton!
    @IBOutlet weak var sixteenOZButton: UIButton!
    @IBOutlet weak var thirtyTwoOZButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: UpdateWaterDelegate?
    var buttons: [UIButton] {
        return [eightOZButton, sixteenOZButton, thirtyTwoOZButton]
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateWaterData()
    }
    
    // MARK: - Actions
    
    @IBAction func volTextFieldEditingDidEnd(_ sender: Any) {
        resetButtons()
    }
    
    @IBAction func eightOZButtonTapped(_ sender: Any) {
        waterVolTextField.text = "8"
        updateSelectedButton(eightOZButton)
    }
    @IBAction func sixteenOZButtonTapped(_ sender: Any) {
        waterVolTextField.text = "16"
        updateSelectedButton(sixteenOZButton)
    }
    @IBAction func thirtyTwoOZButtonTapped(_ sender: Any) {
        waterVolTextField.text = "32"
        updateSelectedButton(thirtyTwoOZButton)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logWaterButtonTapped(_ sender: Any) {
        guard let waterVolumeText = waterVolTextField.text,
              let waterVolume = Int(waterVolumeText) else { return }
        
        if let todaysEntry = WaterDataController.shared.dailyWaterEntry {
            WaterDataController.shared.updateEntry(for: todaysEntry, with: waterVolume) { result in
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
            WaterDataController.shared.saveEntry(with: waterVolume) { result in
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
    
    // MARK: - Helper Methods
    func updateSelectedButton(_ sender: UIButton) {
        resetButtons()
        sender.borderColor = #colorLiteral(red: 0, green: 0.4797315598, blue: 0.9985385537, alpha: 1)
        sender.borderWidth = 2
    }
    
    func resetButtons() {
        buttons.forEach({ $0.borderColor = .black; $0.borderWidth = 1 })
    }
    
    func setUpView() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
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
}// End of extension
