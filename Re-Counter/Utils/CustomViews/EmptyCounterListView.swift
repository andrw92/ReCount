//
//  EmptyCounterListView.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 8/3/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation
import UIKit

class EmptyBackgroundView: UIView{
    
    private lazy var title = UILabel()
    private lazy var message = UILabel()
    
    init(title: String, info: String){
        super.init(frame: .zero)
        setupSubviews()
        setupLabels(titleText: title, messageText: info)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupConstraints()
    }
    
    func setupLabels(titleText: String, messageText: String){
        title.text = titleText
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 19)
        title.textColor = .darkGray
        
        message.text = messageText
        message.textColor = .gray
        message.textAlignment = .center
        message.font = UIFont.systemFont(ofSize: 17)
        message.numberOfLines = 0
    }
    
    func setupConstraints(){
        guard let superView = superview else{ return }
        
        
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: -50.0).isActive = true
        title.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
        title.leadingAnchor.constraint(greaterThanOrEqualTo: superView.leadingAnchor, constant: 12.0).isActive = true
        title.trailingAnchor.constraint(greaterThanOrEqualTo: superView.trailingAnchor, constant: -12.0).isActive = true
        
        message.translatesAutoresizingMaskIntoConstraints = false
        message.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5.0).isActive = true
        message.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
        message.leadingAnchor.constraint(greaterThanOrEqualTo: superView.leadingAnchor, constant: 7.0).isActive = true
        message.trailingAnchor.constraint(greaterThanOrEqualTo: superView.trailingAnchor, constant: -7.0).isActive = true
    }
    
    private func setupSubviews(){
        addSubview(title)
        addSubview(message)
    }
    
}
