//
//  AreaViewController.swift
//  Local Labor Market Data
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
    
    var localAreaReportsDict = [ReportType: AreaReport]()
    var nationalAreaReportsDict = [ReportType: AreaReport]()
    lazy var dataUtil = DataUtil(managedContext: CoreDataManager.shared().viewManagedContext)
    lazy var nationalArea = dataUtil.nationalArea()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

//    override func viewDidAppear(_ animated: Bool) {        
//        super.viewDidAppear(animated)
//        UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: view)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() {
//        navigationItem.hidesBackButton = true
        let infoItem = UIBarButtonItem.infoButton(target: self, action: #selector(infoClicked(sender:)))
        navigationItem.rightBarButtonItems = [infoItem]
        
        if splitViewController?.isCollapsed ?? true {
            let homeItem = UIBarButtonItem(image: #imageLiteral(resourceName: "home"), style: .plain, target: self, action: #selector(homeClicked(sender:)))
            navigationItem.leftBarButtonItem = homeItem
        }
        
        seasonallyAdjustedSwitch.tintColor = UIColor(named: "AppBlue")
        seasonallyAdjustedSwitch.onTintColor = UIColor(named: "AppBlue")
        
        seasonallyAdjustedTitle.scaleFont(forDataType: .seasonallyAdjustedSwitch, for: traitCollection)
        leftSubArea.titleLabel?.scaleFont(forDataType: .reportSubAreaTitle, for: traitCollection)
        rightSubArea.titleLabel?.scaleFont(forDataType: .reportSubAreaTitle, for: traitCollection)
        areaTitleLabel.scaleFont(forDataType: .reportAreaTitle, for:traitCollection)
        
        areaTitleLabel.text = area?.title
        areaTitleLabel.accessibilityLabel = area.accessibilityStr
    }

    @objc func homeClicked(sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.displayHome()
    }
    
    @objc func infoClicked(sender: Any) {
        performSegue(withIdentifier: "showInfo", sender: nil)
    }
    
    func setupAccessbility() {
        seasonallyAdjustedSwitch.accessibilityLabel = "Seasonally Adjusted"
        seasonallyAdjustedTitle.isAccessibilityElement = false
        tableView.isAccessibilityElement = false
//        areaTitleLabel.accessibilityTraits |= UIAccessibilityTraits.header
        areaTitleLabel.accessibilityTraits = UIAccessibilityTraits.header
        
        NotificationCenter.default.addObserver(self, selector: #selector(voiceOverStatusChanged), name: UIAccessibility.voiceOverStatusDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func voiceOverStatusChanged() {
        tableView.reloadData()
    }
    
    func displayAreaViewController(vc: UIViewController) {
        vc.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        if !(splitViewController?.isCollapsed ?? false) {
            vc.navigationItem.leftItemsSupplementBackButton = true
        }
        navigationController?.replaceTopViewController(with: vc, animated: true)
    }
}
