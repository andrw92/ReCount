//
//  SortPopOverViewController.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 8/2/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import UIKit

protocol SortDelegate: class {
    func selectedSortOption(_ option: SortOptionsForCounterList)
}

class SortPopOverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var sortOptions: [SortOptionsForCounterList] = SortOptionsForCounterList.allCases
    var selectedOption: SortOptionsForCounterList?
    weak var delegate: SortDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sort options"
        tableView.rowHeight = 42
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sortOption = sortOptions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SortOptionTableViewCell.storyboardIdentifier, for: indexPath)
        
        if let cell = cell as? SortOptionTableViewCell{
            cell.titleLb.text = sortOption.rawValue
            cell.accessoryType = sortOption == selectedOption ? .checkmark : .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedSortOption(sortOptions[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
    

}
