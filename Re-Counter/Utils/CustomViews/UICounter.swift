//
//  CustomStepper.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 8/4/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UICounter: UIControl{
    
    enum Actions{
        case decrement
        case increment
    }
    
    private (set) var value: Actions = .increment
    var minusButton = UIButton()
    var plusButton = UIButton()
    
    @IBInspectable var buttonsBackground: UIColor = .lightGray{
        didSet{
            setupButtonsBackgroundColor()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        addSubview(minusButton)
        addSubview(plusButton)
        roundBorder(radius: 3.0)
        setupButtons()
        setupConstraints()
        setupButtonsBackgroundColor()
    }
    
    func setupButtons(){
        let plusImg = UIImage.init(named: "plus_ic")?.withRenderingMode(.alwaysTemplate)
        let minusImg = UIImage.init(named: "minus_ic")?.withRenderingMode(.alwaysTemplate)
        minusButton.setImage(minusImg, for: .normal)
        plusButton.setImage(plusImg, for: .normal)
        plusButton.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
    }
    
    func setupButtonsBackgroundColor(){
        minusButton.backgroundColor = buttonsBackground
        plusButton.backgroundColor = buttonsBackground
    }
    
    func setupConstraints(){
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        
        minusButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        minusButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        minusButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        minusButton.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -3).isActive = true
        minusButton.widthAnchor.constraint(equalTo: plusButton.widthAnchor, multiplier: 1.0).isActive = true
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        plusButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        plusButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        plusButton.leadingAnchor.constraint(equalTo: minusButton.trailingAnchor, constant: 3).isActive = true
        plusButton.widthAnchor.constraint(equalTo: minusButton.widthAnchor, multiplier: 1.0).isActive = true
    }
    
    
    @objc func clickAction(_ sender: UIButton){
        value = sender == plusButton ? .increment : .decrement
        sendActions(for: .valueChanged)
    }
    
}
