//
//  CounterListInteractor.swift
//  Re-Counter
//
//  Created by Andrés Alexis Rivas Solorzano on 7/31/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import Foundation

protocol CounterListActions{
    func loadCounters()
    func createCounter(title: String)
    func incrementCounter(id: String)
    func deleteCounter(id: String)
    func decrementCounter(id: String)
}

protocol CounterListBusinessLogic{
    func filterCounters(filterQuery: String)
    func endFiltering()
    func sortCounters(sortOption: SortOptionsForCounterList)
    func updateCounterList(newList: [Counter])
}

class CounterListInteractor: CounterListBusinessLogic, CounterListActions{
  
    var counterList: [Counter] = []
    var loader: CounterListLoader
    var presenter: CounterListPresentationLogic?
    var filterQuery: String?
    
    var isLoading: Bool = false{
        didSet{
            presenter?.showLoadingStatus(isLoading: isLoading)
        }
    }
    
    init(loader: CounterListLoader, presenter: CounterListPresentationLogic){
        self.loader = loader
        self.presenter = presenter
    }
    
    //MARK: - CounterCRUDLogic
    //No time for pretty callbacks
    func loadCounters() {
        isLoading = true
        loader.get { [weak self] (result) in
            self?.interpretResult(result, executeOnSucess: { (items) -> [Counter] in
                return self?.updateCounterListHandler(updatedList: items) ?? []
            })
        }
    }
    
    func createCounter(title: String) {
        guard title != "" else { return }
        isLoading = true
        loader.create(title: title) { [weak self] (result) in
            self?.interpretResult(result, executeOnSucess: { (items) -> [Counter] in
                return self?.createCounterHandler(updatedList: items) ?? []
            })
        }
    }
    
    func incrementCounter(id: String) {
        isLoading = true
        loader.increment(counterId: id) { [weak self] (result) in
            self?.interpretResult(result, executeOnSucess: { (items) -> [Counter] in
                return self?.updateCounterHandler(id: id, updatedList: items) ?? []
            })
        }
    }
    
    func deleteCounter(id: String) {
        isLoading = true
        loader.delete(counterId: id) { [weak self] (result) in
            self?.interpretResult(result, executeOnSucess: { (items) -> [Counter] in
                return self?.deleteCounterHandler(id: id, updatedList: items) ?? []
            })
        }
    }
    
    func decrementCounter(id: String) {
        isLoading = true
        loader.decrement(counterId: id) { [weak self] (result) in
            self?.interpretResult(result, executeOnSucess: { (items) -> [Counter] in
                return self?.updateCounterHandler(id: id, updatedList: items) ?? []
            })
        }
    }
    
   
    //MARK: - CounterListBusinessLogic
    func filterCounters(filterQuery: String) {
        self.filterQuery = filterQuery
        presenter?.presentCounters(counterList: getFilteredList())
    }
    
    func endFiltering() {
        filterQuery = nil
        presenter?.presentCounters(counterList: counterList)
    }
    
    func sortCounters(sortOption: SortOptionsForCounterList) {
        counterList = sorted(by: sortOption)
        presenter?.presentCounters(counterList: counterList)
    }
    
    func updateCounterList(newList: [Counter]) {
        counterList = newList
    }
    
    
    //MARK: - Private methods
    private func sorted(by sortType: SortOptionsForCounterList)->[Counter]{
        switch sortType {
        case .countAscending:
            return counterList.sorted(by: {$0.count < $1.count})
        case .countDescending:
            return counterList.sorted(by: {$0.count > $1.count})
        case .titleDescending:
            return counterList.sorted(by: {$0.title.lowercased() > $1.title.lowercased()})
        case .titleAscending:
            return counterList.sorted(by: {$0.title.lowercased() < $1.title.lowercased()})
        }
    }
    
    private func updateCounterListHandler(updatedList: [Counter])->[Counter]{
        counterList = updatedList
        return updatedList
    }
    
    private func getFilteredList()->[Counter]{
        guard let filterQuery = self.filterQuery, filterQuery != "" else {
            return counterList
        }
        let filteredList = counterList.filter{
            $0.title.lowercased().contains(filterQuery.lowercased())
        }
        
        return filteredList
    }
   
    //MARK: - Result handlers
    private func deleteCounterHandler(id: String, updatedList: [Counter])->[Counter]{
        if !updatedList.contains(where: {$0.id == id}), let oldIndex = self.counterList.firstIndex(where: {$0.id == id}){
            counterList.remove(at: oldIndex)
        }
        return counterList
    }
    
    private func createCounterHandler(updatedList: [Counter])->[Counter]{
        for counterItem in updatedList{
            if !(counterList.contains(counterItem)) {
                counterList.append(counterItem)
            }
        }
        return counterList
    }
    
    private func updateCounterHandler(id: String, updatedList: [Counter]) -> [Counter]{
        if let counter = updatedList.first(where: {$0.id == id}), let oldIndex = self.counterList.firstIndex(where: {$0.id == id}){
            counterList[oldIndex] = counter
        }
        return counterList
    }
    
    private func interpretResult(_ result: RemoteCounterListLoader.Result,
                                 executeOnSucess: (([Counter]) -> [Counter])) {
        
        switch result {
        case .success(let items):
            self.presenter?.presentCounters(counterList: executeOnSucess(items))
        case .failure(let error):
            self.presenter?.presentError(error)
        }
        isLoading = false
    }
    
}
