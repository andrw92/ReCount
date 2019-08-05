//
//  RoundContainerView.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 8/4/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import UIKit

class RoundContainerView: UIView {
    
    var gradientLayer: CAGradientLayer?
    
    override var bounds: CGRect{
        didSet{
            setGradientIfNeeded()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        roundBorder(radius: 5)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    private func setGradientIfNeeded(){
        if gradientLayer == nil {
            gradientLayer = applyGradient(startColor: UIColor.grayAlabaster.withAlphaComponent(0.82),
                                          endColor: UIColor.grayAlabaster.withAlphaComponent(0.8))
        }else{
            gradientLayer?.frame = bounds
        }
    }
    
}
