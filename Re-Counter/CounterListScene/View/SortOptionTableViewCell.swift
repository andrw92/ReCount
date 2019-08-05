//
//  SortOptionTableViewCell.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 8/3/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import UIKit

//Se usa una custom cell porque se pueden setear las constraints más facilemente desde el storyboard, esta cell en particular adaptara su altura de acuerdo al tamaño del texto
class SortOptionTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLb: UILabel!

}
