//
//  TableTableViewController.swift
//  RotaryWheel
//
//  Created by Icaro Lavrador on 4/06/19.
//  Copyright © 2019 Icaro Lavrador. All rights reserved.
//

import UIKit

class TableTableViewController: UITableViewController {

    @IBOutlet var knobView: Knob!
    
    let listForTableView = ["Value 1","Value 2","Value 3","Value 4","Value 5","Value 6", "Value 7", "Value 8", "Value 9"]
    
    var previusView = 0
    var currentView = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.view.addSubview(knobView)
        knobView.frame = CGRect(x: self.view.bounds.size.width - knobView.bounds.size.width - 25,
                                y: self.view.bounds.size.height - knobView.bounds.size.height - (self.navigationController?.navigationBar.bounds.size.height)! - 40,
                                width: knobView.bounds.size.width,
                                height: knobView.bounds.size.height)
        
        if traitCollection.forceTouchCapability == .available{
            registerForPreviewing(with: self , sourceView: self.knobView)
        }
        
        setupRotaryWheel()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.knobView.isHidden = false
        changeActiveRow()
    }

    private func setupRotaryWheel(){
        knobView.maximumValue = Float(listForTableView.count)
        knobView.lineWidth = 6
        knobView.setValue(0)
        knobView.addTarget(self, action: #selector(handleValueChanged), for: .valueChanged)
    }
    
    @objc private func handleValueChanged(_ sender: Any) {
        currentView = Int(knobView.value)
        if currentView != previusView {
            previusView = currentView
            changeActiveRow()
        }
    }
    
    private func changeActiveRow() {
        let indexPath = IndexPath(row: currentView, section: 0);
        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listForTableView.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = String(listForTableView[indexPath.row])
        
        
        return cell
    }
}

extension TableTableViewController: UIViewControllerPreviewingDelegate{
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return nil }
        let currentCell = tableView.cellForRow(at: indexPath)
        previewingContext.sourceRect = currentCell?.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        if let finalView = storyboard?.instantiateViewController(withIdentifier: "Peak View") as? PeakViewController {
            finalView.loadView()
            finalView.valueLabel.text = currentCell?.textLabel?.text ?? "No Info"
            finalView.descriptionLabel.text = "Details for \(currentView + 1)"
            return finalView
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.knobView.isHidden = true
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    
}
