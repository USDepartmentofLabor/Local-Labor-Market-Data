//
//  ItemViewController.swift
//  Local Labor Market Data
//
//  Created by Nidhi Chawla on 11/26/18.
//  Copyright © 2018 Department of Labor. All rights reserved.
//

import UIKit

struct ReportItem<T> {
    var item: T
    var reportTypes: [ReportType]?
}

class ItemViewController: UIViewController {
    var viewModel: ItemViewModel!
    
    @IBOutlet weak var areaTitleLabel: UILabel!
    @IBOutlet weak var seasonallyAdjustedSwitch: UICustomSwitch!
    @IBOutlet weak var seasonallyAdjustedTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var reportResultsdict: [ReportType : AreaReport]?
    
    var seasonalAdjustment: SeasonalAdjustment {
        get {
            return ReportManager.seasonalAdjustment
        }
        set(newValue) {
            ReportManager.seasonalAdjustment = newValue
//            localAreaReportsDict?.removeAll()
            tableView.reloadData()
            
//            loadReports()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(displaySearchBar(sender:)))
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60

        areaTitleLabel.scaleFont(forDataType: .reportAreaTitle, for:traitCollection)
        seasonallyAdjustedSwitch.tintColor = #colorLiteral(red: 0.1607843137, green: 0.2117647059, blue: 0.5137254902, alpha: 1)
        seasonallyAdjustedSwitch.onTintColor = #colorLiteral(red: 0.1607843137, green: 0.2117647059, blue: 0.5137254902, alpha: 1)
        seasonallyAdjustedTitle.scaleFont(forDataType: .seasonallyAdjustedSwitch, for: traitCollection)

        areaTitleLabel.text = viewModel.area.title
        seasonallyAdjustedSwitch.isOn = (seasonalAdjustment == .adjusted) ? true:false
        setupAccessbility()

        tableView.contentOffset = CGPoint(x: 0, y: searchBar.frame.height)
//        tableView.scrollToRow(at: IndexPath(row: 1, section: 0), at: .top, animated: false)
        

        loadReports()
    }
    
    func setupAccessbility() {
        seasonallyAdjustedSwitch.accessibilityLabel = "Seasonally Adjusted"
        seasonallyAdjustedTitle.isAccessibilityElement = false
        tableView.isAccessibilityElement = false
        areaTitleLabel.accessibilityTraits = UIAccessibilityTraits.header
        areaTitleLabel.accessibilityLabel = viewModel.area.accessibilityStr
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showIndustries",
            let destVC = segue.destination as? ItemViewController {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow,
                let selectedItem = viewModel.items?[selectedIndexPath.row] {
            
                let vm = ItemViewModel(area: viewModel.area, parent: selectedItem, itemType: type(of: selectedItem))
                destVC.viewModel = vm
                destVC.title = selectedItem.title
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showIndustries" {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow,
                let selectedItem = viewModel.items?[selectedIndexPath.row],
                selectedItem.children?.count ?? 0 > 0 {
                return true
            }
            return false
        }
        
        return true
    }
    
    @IBAction func seasonallyAdjustClick(_ sender: Any) {
        seasonalAdjustment = seasonallyAdjustedSwitch.isOn ? .adjusted : .notAdjusted
    }
    
    @objc func displaySearchBar(sender: Any) {
        tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        searchBar.becomeFirstResponder()
    }
}

// MARK: TableView DataSource
extension ItemViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCellId") as! ItemTableViewCell

        if let reportItem = viewModel.items?[indexPath.row] {
            cell.titleLabel?.text = reportItem.title
        
            if (reportItem.children?.count ?? 0) > 0 {
                cell.detailImageView.image = #imageLiteral(resourceName: "place")
                cell.selectionStyle = .default
            }
            else {
                cell.detailImageView.image = nil
                cell.selectionStyle = .none
            }
        }
        return cell
    }
}

extension ItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: SeriesId
extension ItemViewController {
    func loadReports() {
        let reportItems = viewModel.items?.compactMap({ (item) -> ReportItem<Item> in
            let reportTypes: [ReportType]?
            if let code = item.code {
                if item is OE_Occupation {
                    reportTypes = [ReportType.occupationEmployment(occupationalCode: code, OESReport.DataTypeCode.annualMeanWage),                    ReportType.occupationEmployment(occupationalCode: code, OESReport.DataTypeCode.employment)]
                }
                else if item is CE_Industry {
                    reportTypes = [ReportType.industryEmployment(industryCode: code, CESReport.DataTypeCode.allEmployees)]
                }
                else if item is SM_Industry {
                    reportTypes = [ReportType.industryEmployment(industryCode: code, CESReport.DataTypeCode.allEmployees)]
                }
                else {
                    reportTypes = nil
                }
            }
            else {
                reportTypes = nil
            }
            
            return ReportItem<Item>(item: item, reportTypes: reportTypes)
        })

/*
        if let reportTypes = viewModel?.items?.compactMap({$0.reportTypes}).flatMap({$0}) {
            ReportManager.getReports(forArea: viewModel?.area, reportTypes: reportTypes,
                                 seasonalAdjustment: SeasonalAdjustment.adjusted) {
                [weak self] (apiResult) in
                guard let strongSelf = self else {return}
                
                switch apiResult {
                case .success(let areaReportsDict):
                    strongSelf.displayReportResults(areaReportsDict: areaReportsDict)
                case .failure(let error):
                    strongSelf.handleError(error: error)
                }
            }
        }
 */
    }
    
    func displayReportResults(areaReportsDict: ([ReportType : AreaReport])) {
        print("Reports")
        reportResultsdict = areaReportsDict
        tableView.reloadData()
    }
}