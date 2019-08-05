//
//  UITableView.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 8/3/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation
import UIKit

extension UITableView{
    
    func updateBackgroundView(animated: Bool, newBackground: UIView?){
        guard animated else{
            backgroundView = newBackground
            return
        }
        let fromAlpha: CGFloat = newBackground == nil ? 1.0 : 0.0
        let toAlpha: CGFloat = newBackground == nil ? 0.0 : 1.0
        backgroundView?.alpha = fromAlpha
        UIView.animate(withDuration: 0.17, delay: 0.0, options: .curveEaseIn, animations: {
            self.backgroundView?.alpha = toAlpha
        }, completion: { completed in
            self.backgroundView = newBackground
        })
    }
    
    func setFooterViewWithMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 30))
        messageLabel.text = message
        messageLabel.font = .systemFont(ofSize: 17, weight: .regular)
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.tableFooterView = messageLabel
    }

}
