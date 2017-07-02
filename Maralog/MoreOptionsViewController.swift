//
//  MoreOptionsViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 5/18/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class MoreOptionsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let name = UserController.sharedInstance.getName()

        nameChangeTextField.text = name
        self.changeDesignsFor(buttons: [saveNameButton])
        nameChangeTextField.layer.borderColor = Keys.sharedInstance.tabBarSelected.cgColor
        nameChangeTextField.delegate = self
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        descriptionTextView.text = "Tap the icons above for more information"
        nameChangeTextField.text = UserController.sharedInstance.getName()
    }
    
    
    
    // MARK: - Outlets
    
    
    
    @IBOutlet var yourNameLabel: UILabel!
    
    @IBOutlet var nameChangeTextField: UITextField!
    
    @IBOutlet var saveNameButton: UIButton!
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var descriptionTextView: UITextView!
    
    
    
    // MARK: - Actions
    @IBAction func saveNameButtonTapped(_ sender: Any) {
        let color = Keys.sharedInstance.tabBarSelected
        if let newName = nameChangeTextField.text, !newName.isEmpty {
            UserController.sharedInstance.saveUserName(name: nameChangeTextField.text)
            UIView.animate(withDuration: 1, animations: {
                self.saveNameButton.backgroundColor = color
                self.saveNameButton.setTitleColor(.white, for: .normal)
                self.saveNameButton.setTitle("Saved!", for: .normal)
            }) { (_) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.saveNameButton.backgroundColor = .clear
                    self.saveNameButton.setTitleColor(color, for: .normal)
                    self.saveNameButton.setTitle("Save", for: .normal)
                })
            }
        }
    }
}



extension MoreOptionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SettingsController.sharedInstance.settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingCell", for: indexPath) as? SettingsCollectionViewCell
        let setting = SettingsController.sharedInstance.settings[indexPath.row]
        cell?.setting = setting
        cell?.delegate = self
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = SettingsController.sharedInstance.settings[indexPath.row]
        descriptionTextView.text = setting.description
    }
    
}

extension MoreOptionsViewController: SwitchSettingsDelegate {
    func captureDefaultSettingFor(cell: SettingsCollectionViewCell, selected: Bool) {
        if let setting = cell.setting, let indexPath = collectionView.indexPath(for: cell) {
            setting.isOn = selected
            collectionView.reloadItems(at: [indexPath])
            SettingsController.sharedInstance.saveAsDefault(setting: setting, value: selected)
        }
    }
}

extension MoreOptionsViewController {
    func changeDesignsFor(buttons: [UIButton]) {
        for button in buttons {
            let color = Keys.sharedInstance.tabBarSelected
            button.backgroundColor = .clear
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 0.5
            button.layer.borderColor = color.cgColor
            button.setTitleColor(color, for: .normal)
        }
    }
}

extension MoreOptionsViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



