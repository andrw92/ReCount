//
//  CounterListPresenterTests.swift
//  Re-CounterTests
//
//  Created by Andrés Alexis Rivas Solorzano on 8/1/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import XCTest
@testable import Re_Counter

class CounterListPresenterTests: XCTestCase {

    func test_presentCounter_deliversData(){
        let (sut, displayer) = makeSUT()
        sut.presentCounters(counterList: getTestArray())
        XCTAssertNotNil(displayer.receivedViewModel)
    }
    
    func test_presentError_deliversData(){
        let (sut, displayer) = makeSUT()
        sut.presentError(someError())
        XCTAssertNotNil(displayer.receivedError)
    }
    
    func test_presentCounter_deliversCorrectStadistics_Data(){
        let (sut, displayer) = makeSUT()
        let expectedCount = "Total count: \(9)"
        let expectedAverage = "Average count: 1.80"
        sut.presentCounters(counterList: getTestArray())
        XCTAssertNil(displayer.receivedError)
        XCTAssertNotNil(displayer.receivedViewModel)
        XCTAssertEqual(displayer.receivedViewModel?.countAverage, expectedAverage)
        XCTAssertEqual(displayer.receivedViewModel?.countTotal, expectedCount)
    }
    
    
    
    
    //MARK: - Helpers
    private func makeSUT()->(presenter: CounterListPresenter, viewController: DisplaySpy){
        let spy = DisplaySpy()
        let presenter = CounterListPresenter.init(viewController: spy)
        return (presenter, spy)
    }
    private func someError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
   
    
    private func getTestArray()->[Counter]{
        return [Counter.init(id: "test1", title: "someTest", count: 2),
                Counter(id: "test2", title: "anotherTest", count: 4),
                Counter(id: "test3", title: "maybeTest", count: -3),
                Counter(id: "test4", title: "thisIsTest", count: 1),
                Counter(id: "test5", title: "greatTest", count: 5)]
    }
    
    private class DisplaySpy: CounterListDisplayLogic{
        
        var receivedViewModel: CounterListViewModel?
        var receivedError: ErrorViewModel?
        var selectedSortOption: SortOptionsForCounterList? = .countAscending
        
        func displayCounters(with viewModel: CounterListViewModel?) {
            receivedViewModel = viewModel
        }
        
        func displayError(error viewModel: ErrorViewModel) {
            receivedError = viewModel
        }
        
        var isSearching: Bool = false
        
        
        func displayLoadingStatus(isLoading: Bool) {
            
        }
        
    }
}
