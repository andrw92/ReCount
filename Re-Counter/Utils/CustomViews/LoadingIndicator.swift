//
//  LoadingIndicator.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 8/3/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation
import UIKit

class LoadingIndicator: UIVisualEffectView {
    
    var title: String? {
        didSet {
            titleLb.text = title
        }
    }
    
    let activityIndictor = UIActivityIndicatorView(style: .gray)
    let titleLb = UILabel()
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyView: UIVisualEffectView
    
    init(text: String) {
        self.title = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndictor)
        contentView.addSubview(titleLb)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superview = self.superview {
            let contentWidth = superview.frame.size.width / 2.3
            let contentHeight: CGFloat = 50.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - contentWidth / 2,
                                y: (superview.frame.height / 2 - contentHeight / 2) - 75,
                                width: contentWidth,
                                height: contentHeight)
            vibrancyView.frame = self.bounds
            
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 5,
                                            y: contentHeight / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            titleLb.text = title
            titleLb.textAlignment = NSTextAlignment.center
            titleLb.frame = CGRect(x: activityIndicatorSize + 5,
                                 y: 0,
                                 width: contentWidth - activityIndicatorSize - 15,
                                 height: contentHeight)
            
            titleLb.textColor = .darkGray
            titleLb.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
}
