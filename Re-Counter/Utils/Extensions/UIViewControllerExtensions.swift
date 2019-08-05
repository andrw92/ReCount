//
//  UILoader.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 8/3/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{

    func presentLoader(isLoading: Bool){
        if isLoading{
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.view.addSubview(LoadingIndicator.init(text: "Loading..."))
        }else{
            UIApplication.shared.endIgnoringInteractionEvents()
            self.view.subviews.forEach({
                if $0 is LoadingIndicator {
                    $0.removeFromSuperview()
                }
            })
        }
        
    }
}
