//
//  ThemeManager.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 8/4/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation
import UIKit

class ThemeManager{
    
    static var instance = ThemeManager()
    private init(){}
    
    func setTheme(){
        setupNavigationBar()
        setupCustomViews()
        setupTableViewCell()
    }
    
    private func setupNavigationBar(){
        UINavigationBar.appearance().barTintColor = .warmGray
        UINavigationBar.appearance().tintColor = .darkCelurean
    }
    
    private func setupTableViewCell(){
        UITableViewCell.appearance().contentView.backgroundColor = .pastelWhite
    }
    
    private func setupCustomViews(){
        UIViewControllerBackgroundView.appearance().backgroundColor = .warmGray
        StadisticsView.appearance().backgroundColor = .warmGray
        UICounter.appearance().tintColor = .darkCelurean
    }
}
