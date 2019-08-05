//
//  CounterListInteractorTests.swift
//  Re-CounterTests
//
//  Created by Andrés Alexis Rivas Solorzano on 7/31/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import XCTest
@testable import Re_Counter
class CounterListInteractorTests: XCTestCase {
    
    func test_get_deliversDataOnSucess(){
        let (sut, loader, presenter) = makeSUT()
        sut.loadCounters()
        loader.completeWithSuccess(arrayToDeliver: [])
        XCTAssert(presenter.receivedList == [])
        XCTAssertNil(presenter.receivedError)
    }
    
    func test_get_deliversErrorOnError(){
        let (sut, loader, presenter) = makeSUT()
        sut.loadCounters()
        loader.completeWithError(error: someError())
        XCTAssertNotNil(presenter.receivedError)
    }
    
    func test_create_deliverDataOnSuccess(){
        let (sut, loader, presenter) = makeSUT()
        let mockCounter = Counter(id: "mock", title: "someTitle", count: 0)
        sut.createCounter(title: mockCounter.title)
        loader.completeWithSuccess(arrayToDeliver: [mockCounter])
        XCTAssertEqual(presenter.receivedList, [mockCounter])
        XCTAssertNil(presenter.receivedError)
    }
    
    func test_create_deliverErrorOnError(){
        let (sut, loader, presenter) = makeSUT()
        let mockCounter = Counter(id: "mock", title: "someTitle", count: 0)
        sut.createCounter(title: mockCounter.title)
        loader.completeWithError(error: someError())
        XCTAssertNotNil(presenter.receivedError)
    }
    
    func test_filter_deliversExpectedData(){
        
        let (sut, loader, presenter) = makeSUT()
        let mockCounter = Counter(id: "mock", title: "visitas", count: 1)
        let mockCounterTwo = Counter(id: "kcom", title: "hamburguesas", count: 3)
        let givenMocklist = [mockCounter, mockCounterTwo]
        
        sut.loadCounters()
        loader.completeWithSuccess(arrayToDeliver: givenMocklist)
        XCTAssertEqual(presenter.receivedList, givenMocklist)
        
        let expectedList = [mockCounter]
        let filterQuery = "visi"
        sut.filterCounters(filterQuery: filterQuery)
        XCTAssertEqual(presenter.receivedList, expectedList)
        
        let filterQueryTwo = ""
        sut.filterCounters(filterQuery: filterQueryTwo)
        XCTAssertEqual(presenter.receivedList, givenMocklist)
        
        let filterQueryThree = "guesas"
        sut.filterCounters(filterQuery: filterQueryThree)
        XCTAssertEqual(presenter.receivedList, [mockCounterTwo])
    }
    
    //MARK: - Helpers
    private func makeSUT()->(sut: CounterListInteractor, loader: LoaderSpy, presenter: PresentationSpy){
        let loaderSpy = LoaderSpy.init()
        let presentationSpy = PresentationSpy()
        let interactor = CounterListInteractor.init(loader: loaderSpy, presenter: presentationSpy)
        return  (interactor, loaderSpy, presentationSpy)
    }
    
    private func assertSortList(presenter: PresentationSpy, givenList: [Counter]){
        XCTAssertEqual(presenter.receivedList, givenList)
    }
    
    private func someError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    private class LoaderSpy: CounterListLoader{
        typealias Result = LoaderSpy.Result
        typealias spyMessage = (Result) -> Void
        
        private var messages: [spyMessage] = []
        
        func get(completion: @escaping (Result) -> Void) {
            messages.append(completion)
        }
        
        func create(title: String, completion: @escaping (Result) -> Void) {
            messages.append(completion)
        }
        
        func delete(counterId: String, completion: @escaping (Result) -> Void) {
            messages.append(completion)
        }
        
        func increment(counterId: String, completion: @escaping (Result) -> Void) {
            messages.append(completion)
        }
        
        func decrement(counterId: String, completion: @escaping (Result) -> Void) {
            messages.append(completion)
        }
        
        func completeWithError(error: Error, atIndex: Int = 0){
            messages[atIndex](.failure(error))
        }
        
        func completeWithSuccess(arrayToDeliver: [Counter], atIndex: Int = 0){
            messages[atIndex](.success(arrayToDeliver))
        }
    }
    
    private class PresentationSpy: CounterListPresentationLogic{
        
        var receivedList: [Counter] = []
        var receivedError: String?
        
        func presentCounters(counterList: [Counter]) {
            receivedList = counterList
        }
        
        func presentError(_ error: Error) {
            receivedError = error.localizedDescription
        }
        
        func showLoadingStatus(isLoading: Bool) {
            
        }
        
        
    }
   
}
