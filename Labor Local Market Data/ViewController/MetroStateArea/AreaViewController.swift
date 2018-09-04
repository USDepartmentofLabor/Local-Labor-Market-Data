//
//  AreaViewController.swift
//  Labor Local Data
//
//  Created by Nidhi Chawla on 8/2/18.
//  Copyright © 2018 Department of Labor. All rights reserved.
//

import UIKit

class AreaViewController: UIViewController {

    var area: Area!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var seasonallyAdjustedTitle: UILabel!
    @IBOutlet weak var seasonallyAdjustedSwitch: UISwitch!

    @IBOutlet weak var leftSubArea: UIButton!
    @IBOutlet weak var rightSubArea: UIButton!
    @IBOutlet weak var areaTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
        navigationItem.hidesBackButton = true
        let searchItem = UIBarButtonItem(barButtonSystemItem: .search, target: self,
                                         action: #selector(searchClicked(sender:)))
        let infoItem = UIBarButtonItem.infoButton(target: self, action: #selector(infoClicked(sender:)))
        navigationItem.rightBarButtonItems = [searchItem, infoItem]
        
        seasonallyAdjustedSwitch.tintColor = UIColor(hex: 0x293683)
        seasonallyAdjustedSwitch.onTintColor = UIColor(hex: 0x293683)
        
        seasonallyAdjustedTitle.scaleFont(forDataType: .seasonallyAdjustedSwitch, for: traitCollection)
        leftSubArea.titleLabel?.scaleFont(forDataType: .reportSubAreaTitle, for: traitCollection)
        rightSubArea.titleLabel?.scaleFont(forDataType: .reportSubAreaTitle, for: traitCollection)
        areaTitleLabel.scaleFont(forDataType: .reportAreaTitle, for:traitCollection)
    }

    @objc func searchClicked(sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.displaySearch()
    }
    
    @objc func infoClicked(sender: Any) {
        performSegue(withIdentifier: "showInfo", sender: nil)
    }
    
    func setupAccessbility() {
        seasonallyAdjustedSwitch.accessibilityLabel = "Seasonally Adjusted"
        seasonallyAdjustedTitle.isAccessibilityElement = false
        tableView.isAccessibilityElement = false
        areaTitleLabel.accessibilityTraits |= UIAccessibilityTraitHeader
        
        NotificationCenter.default.addObserver(self, selector: #selector(voiceOverStatusChanged), name: NSNotification.Name.UIAccessibilityVoiceOverStatusDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func voiceOverStatusChanged() {
        tableView.reloadData()
    }
}