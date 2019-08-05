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
        loader.get(completion: executeTask(updateListTask()))
    }
    
    func createCounter(title: String) {
        guard title != "" else { return }
        loader.create(title: title, completion: executeTask(createCounterTask()))
    }
    
    func incrementCounter(id: String) {
        loader.increment(counterId: id, completion: executeTask(updateCountTask(with: id)))
    }
    
    func deleteCounter(id: String) {
        loader.delete(counterId: id, completion: executeTask(deleteTask(with: id)))
    }
    
    func decrementCounter(id: String) {
        loader.decrement(counterId: id, completion: executeTask(updateCountTask(with: id)))
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
    
    private func getFilteredList()->[Counter]{
        guard let filterQuery = self.filterQuery, filterQuery != "" else {
            return counterList
        }
        let filteredList = counterList.filter{
            $0.title.lowercased().contains(filterQuery.lowercased())
        }
        
        return filteredList
    }
    
    //MARK: - Tasks
    private func executeTask(_ executeOnSuccess: @escaping ([Counter]) -> [Counter])->(RemoteCounterListLoader.Result)-> Void{
        isLoading = true
        let task: (RemoteCounterListLoader.Result) -> Void = { [weak self] result in
            self?.isLoading = false
            self?.interpretResult(result, executeOnSucess: executeOnSuccess)
        }
        return task
    }
    
    private func updateListTask()-> (([Counter]) -> [Counter]){
        let task: ([Counter]) -> [Counter] = { items in
            return self.updateListHandler(items)
        }
        return task
    }
    private func createCounterTask()-> (([Counter]) -> [Counter]){
        let task: ([Counter]) -> [Counter] = { items in
            return self.createCounterHandler(items)
        }
        return task
    }
    private func deleteTask(with id: String)-> ([Counter]) -> [Counter]{
        let task: ([Counter]) -> [Counter] = { items in
            self.deleteCounterHandler(id: id, updatedList: items)
        }
        return task
    }
    
    private func updateCountTask(with id: String)-> ([Counter]) -> [Counter]{
        let task: ([Counter]) -> [Counter] = { items in
            self.updateCounterHandler(id: id, updatedList: items)
        }
        return task
    }
   
    //MARK: - Result handlers
    private func updateListHandler(_ updatedList: [Counter])->[Counter]{
        counterList = updatedList
        return updatedList
    }
    private func createCounterHandler(_ updatedList: [Counter])->[Counter]{
        for counterItem in updatedList{
            if !(counterList.contains(counterItem)) {
                counterList.append(counterItem)
            }
        }
        return counterList
    }
    
    private func deleteCounterHandler(id: String, updatedList: [Counter])->[Counter]{
        if !updatedList.contains(where: {$0.id == id}), let oldIndex = counterList.firstIndex(where: {$0.id == id}){
            counterList.remove(at: oldIndex)
        }
        return counterList
    }
    
    private func updateCounterHandler(id: String, updatedList: [Counter]) -> [Counter]{
        if let counter = updatedList.first(where: {$0.id == id}), let oldIndex = counterList.firstIndex(where: {$0.id == id}){
            counterList[oldIndex] = counter
        }
        return counterList
    }
    
    private func interpretResult(_ result: RemoteCounterListLoader.Result, executeOnSucess: (([Counter]) -> [Counter])) {
        switch result {
        case .success(let items):
            self.presenter?.presentCounters(counterList: executeOnSucess(items))
        case .failure(let error):
            self.presenter?.presentError(error)
        }
    }
    
}
