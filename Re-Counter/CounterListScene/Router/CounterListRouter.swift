//
//  CounterListRouter.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 8/2/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation
import UIKit

protocol CounterListRoutingLogic {
    func presentSortPopOver(_ sender: Any)
    func presentAddCounterAlert()
    func presentErrorAlert(title: String, message: String)
    func presentDeleteCounterConfirmation(counter: Counter, confirmedAction: @escaping ()->() )
}

class CounterListRouter: CounterListRoutingLogic{
    
    weak var viewController: CounterListViewController?
    
    init(viewController: CounterListViewController) {
        self.viewController = viewController
    }
    
    func presentSortPopOver(_ sender: Any) {
        
        guard let vc = viewController?.storyboard?.instantiateViewController(withIdentifier: SortPopOverViewController.storyboardIdentifier) as? SortPopOverViewController else{
            return
        }
        
        vc.preferredContentSize = CGSize.init(width: 200, height: 175)
        vc.delegate = viewController
        vc.selectedOption = viewController?.selectedSortOption
        
        let navController = UINavigationController.init(rootViewController: vc)
        navController.modalPresentationStyle = .popover
        
        let popOver = navController.popoverPresentationController
        popOver?.delegate = viewController
        popOver?.backgroundColor = navController.navigationBar.backgroundColor
        popOver?.barButtonItem = sender as? UIBarButtonItem
        viewController?.present(navController, animated: true, completion: nil)
        
    }
    
    func presentAddCounterAlert(){
        
        let alert = UIAlertController.init(title: "New Counter", message: "Add a name for this counter", preferredStyle: .alert)
       
        let saveAction = UIAlertAction.init(title: "Save", style: .default) { [weak alert] _ in
            if let tf = alert?.textFields?.first, let title = tf.text, title != ""{
                self.viewController?.createCounter(title: title)
            }
        }
        
        alert.addTextField { textfield in
            textfield.placeholder = "Counter title"
            //Going to hell for this observer
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textfield, queue: OperationQueue.main, using:
                {_ in
                    let textCount = textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    saveAction.isEnabled = textIsNotEmpty
            })
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
       
        saveAction.isEnabled = false
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func presentDeleteCounterConfirmation(counter: Counter, confirmedAction: @escaping () -> ()) {
        let alert = UIAlertController.init(title: "Delete counter", message: "Are you sure you want to delete \(counter.title)? This action cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction.init(title: "Confirm", style: .destructive, handler: { (action) in
           confirmedAction()
        }))
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func presentErrorAlert(title: String, message: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
    
}
