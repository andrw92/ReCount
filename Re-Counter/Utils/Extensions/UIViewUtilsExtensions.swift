//
//  UIViewUtilsExtensions.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 8/2/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func roundBorder(color: CGColor = UIColor.clear.cgColor, radius: CGFloat){
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func applyGradient(startColor: UIColor, endColor: UIColor) -> CAGradientLayer{
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
    
    func applySimpleShadow(){
        layer.masksToBounds = false
        layer.shadowRadius = 20
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = .zero
    }

}
