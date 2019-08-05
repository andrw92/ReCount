//
//  CounterTableViewCell.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 8/2/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import UIKit

protocol CounterUpdateCountDelegate: class{
    func increment(from cell: UITableViewCell)
    func decrement(from cell: UITableViewCell)
}

class CounterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var counterName: UILabel!
    @IBOutlet weak var counterCount: UILabel!
    
    weak var delegate: CounterUpdateCountDelegate?
    
    private var currentId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateInfo(counter: Counter){
        currentId = counter.id
        counterName.text = counter.title
        counterCount.text = "\(counter.count)"
    }
    
    @IBAction func changeQuantity(_ sender: UICounter) {
        switch sender.value {
        case .increment:
            delegate?.increment(from: self)
        case .decrement:
            delegate?.decrement(from: self)
        }
    }

}
