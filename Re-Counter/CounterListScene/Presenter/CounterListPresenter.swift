//
//  CounterListPresenter.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 7/31/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation

protocol CounterListPresentationLogic: class{
    func presentCounters(counterList: [Counter])
    func showLoadingStatus(isLoading: Bool)
    func presentError(_ error: Error)
}

protocol CounterListDisplayLogic: class {
    var isSearching: Bool{ get }
    var selectedSortOption: SortOptionsForCounterList? { get }
    func displayCounters(with viewModel: CounterListViewModel?)
    func displayError(error viewModel: ErrorViewModel)
    func displayLoadingStatus(isLoading: Bool)
}

class CounterListPresenter: CounterListPresentationLogic {
    weak var view: CounterListDisplayLogic?
    
    init(viewController: CounterListDisplayLogic){
        self.view = viewController
    }
    
    func presentCounters(counterList: [Counter]) {
        self.view?.displayCounters(with: self.getViewModel(for: counterList))
    }
    
    func presentError(_ error: Error) {
        let title = "Counter Error"
        let message = "We have find some error. \(error.localizedDescription)"
        let viewModel = ErrorViewModel(title: title, message: message)
       
        self.view?.displayError(error: viewModel)
    }
    
    func showLoadingStatus(isLoading: Bool) {
        self.view?.displayLoadingStatus(isLoading: isLoading)
    }
    
    
    private func getViewModel(for counterList: [Counter])->CounterListViewModel{

        let total = "Total count: \(getTotalCountersValue(for: counterList))"
        let average = "Average count: \(getAverage(for: counterList))"
        let tableViewMessage = getTableViewMessage(for: counterList)
        let viewModel = CounterListViewModel(counterList: counterList,
                                             countTotal: total,
                                             countAverage: average,
                                             messageForFooter: tableViewMessage)
        return viewModel
    }
    
    
    private func getTotalCountersValue(for list: [Counter])->Int{
        return list.map{ $0.count }.reduce(0, +)
    }
    
    private func getAverage(for list: [Counter])->String{
        
        let countSum = getTotalCountersValue(for: list)
        let rawAverage = Double(countSum) / Double(list.count)
      
        return String(format: "%.2f", rawAverage)
    }
    
    private func getTableViewMessage(for list: [Counter])->String{
        return list.count > 0 ? "Swipe left to delete \n Tap edit to reorder the counters \n Tap on the (-|+) in the counter to increment or decrement its value." : ""
    }
}
