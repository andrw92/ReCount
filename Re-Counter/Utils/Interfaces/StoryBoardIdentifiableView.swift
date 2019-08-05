//
//  StoryBoardIdentifiableView.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 8/4/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation
import UIKit

protocol StoryBoardIdentifiableView: class {
    static var storyboardIdentifier: String {get}
}

extension StoryBoardIdentifiableView {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
extension UITableViewCell: StoryBoardIdentifiableView{}
extension UIViewController: StoryBoardIdentifiableView{}
