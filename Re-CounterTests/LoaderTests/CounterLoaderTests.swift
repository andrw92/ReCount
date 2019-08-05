//
//  CounterLoaderTests.swift
//  Re-CounterTests
//
//  Created by Andrés Alexis Rivas Solorzano on 7/30/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import XCTest
@testable import Re_Counter

//ISOLATED UNIT TEST NO EXTERNAL SERVER
class CounterLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.receivedRequests.isEmpty)
    }
    
    // MARK - get
    
    func test_get_requestIsCalled(){
        let (sut, client) = makeSUT()
        let expectedURLRequest = makeURLRequest(service: .get)
        sut.get{ _ in }
        XCTAssertEqual(client.receivedRequests, [expectedURLRequest])
    }
    
    func test_get_deliversErrorOnError(){
        
        let (sut, client) = makeSUT()
        
        let expectWait = expectation(description: "Wait for completion")
        let expectedResult = failureCompletion(.noInternet)
        sut.get { receivedResult in
            self.assertCompletion(receivedResult: receivedResult, expectedResult: expectedResult)
            expectWait.fulfill()
        }
        client.completeWithError(error: NetworkError.noInternet)
        wait(for: [expectWait], timeout: 30.0)
    }
    
    func test_get_onNon200HTTPResponse_deliversError(){
       
        let (sut, client) = makeSUT()
        let sampleCodes = [400, 403, 404, 502]
        let expResult = failureCompletion(.invalidData)
        sampleCodes.enumerated().forEach{ index, code in
            
            let exp = expectation(description: "Wait for completion")
            sut.get { receivedResult in
                self.assertCompletion(receivedResult: receivedResult, expectedResult: expResult)
                exp.fulfill()
            }
            let json = makeItemsJSON([])
            client.completeWithSucess(statusCode: code, data: json, atIndex: index)
            
            wait(for: [exp], timeout: 2.0)
        }
    }
    
    func test_get_returnError_on200HTTPResponse_withInvalidJSON(){
       
        let (sut, client) = makeSUT()
        let expectResult = failureCompletion(.invalidData)
        let invalidJSON = Data("json error".utf8)
        
        let exp = expectation(description: "Wait for completion")
        sut.get{ receivedResult in
            self.assertCompletion(receivedResult: receivedResult, expectedResult: expectResult)
            exp.fulfill()
        }
        client.completeWithSucess(statusCode: 200, data: invalidJSON)
        wait(for: [exp], timeout: 2.0)
        
    }
    
    func test_get_deliverNoItems_OnEmptyJSON(){
        let (sut, client) = makeSUT()
        let expectedResult: RemoteCounterListLoader.Result = .success([])
        let emptyJSON = makeItemsJSON([])
        
        let exp = expectation(description: "Wait for completion")
        sut.get { receivedResult in
            self.assertCompletion(receivedResult: receivedResult, expectedResult: expectedResult)
            exp.fulfill()
        }
        client.completeWithSucess(statusCode: 200, data: emptyJSON)
        wait(for: [exp], timeout: 2.0)
    }
    
    func test_get_deliverError_on200HTTPResponse_WithNilItems(){
        let (sut, client) = makeSUT()
        let itemOne = makeItem(id: "1", title: "Test", count: 2)
        let itemTwo = makeItem(id: nil, title: nil, count: 2)
        let itemThree = makeItem(id: nil, title: nil, count: nil)

        let itemsJSON = makeItemsJSON([itemOne.json, nil, itemTwo.json, itemThree.json])
        
        let exp = expectation(description: "Wait for completion")
        let expectedResult = failureCompletion(.invalidData)
        sut.get { receivedResult in
            self.assertCompletion(receivedResult: receivedResult, expectedResult: expectedResult)
            exp.fulfill()
        }
        client.completeWithSucess(statusCode: 200, data: itemsJSON)
        wait(for: [exp], timeout: 2.0)
    }
    
    func test_get_deliversItems_on200HTTPResult_withValidJSON(){
        let (sut, client) = makeSUT()
        let itemOne = makeItem(id: "1", title: "Test", count: 2)
        let itemTwo = makeItem(id: "2", title: "TestTwo", count: 3)
        let remoteItems = [itemOne.model, itemTwo.model]
        let mappedItems = remoteItems.map({Counter(id: $0.id!, title: $0.title!, count: $0.count!)})
        let itemsJSON = makeItemsJSON([itemOne.json, itemTwo.json])
        
        let exp = expectation(description: "Wait for completion")
        let expectedResult: RemoteCounterListLoader.Result = .success(mappedItems)
        sut.get { receivedResult in
            self.assertCompletion(receivedResult: receivedResult, expectedResult: expectedResult)
            exp.fulfill()
        }
        client.completeWithSucess(statusCode: 200, data: itemsJSON)
        wait(for: [exp], timeout: 2.0)
    }
    
    //Basicamente habría que replicar las pruebas
    func test_create_requestIsCalled(){
        let (sut, client) = makeSUT()
        let expectedURLRequest = makeURLRequest(service: .create(title: ""))
        sut.create(title: ""){ _ in }
        XCTAssertEqual(client.receivedRequests, [expectedURLRequest])
    }
    
    func test_delete_requestIsCalled(){
        let (sut, client) = makeSUT()
        let expectedURLRequest = makeURLRequest(service: .delete(id: ""))
        sut.delete(counterId: ""){ _ in }
        XCTAssertEqual(client.receivedRequests, [expectedURLRequest])
    }
    
    func test_increment_requestIsCalled(){
        let (sut, client) = makeSUT()
        let expectedURLRequest = makeURLRequest(service: .increment(id: ""))
        sut.increment(counterId: ""){ _ in }
        XCTAssertEqual(client.receivedRequests, [expectedURLRequest])
    }
    
    func test_decrement_requestIsCalled(){
        let (sut, client) = makeSUT()
        let expectedURLRequest = makeURLRequest(service: .decrement(id: ""))
        sut.decrement(counterId: ""){ _ in }
        XCTAssertEqual(client.receivedRequests, [expectedURLRequest])
    }
    
    
    
    
    //MARK: - Helpers
    private func makeSUT(enviroment: Enviroment = Enviroment.init(host: .localhost)) ->(sut: RemoteCounterListLoader, client: HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = RemoteCounterListLoader.init(enviroment: enviroment, client: client)
        
        return (sut, client)
    }
    
    private func assertCompletion(receivedResult: RemoteCounterListLoader.Result, expectedResult: RemoteCounterListLoader.Result){
        switch (receivedResult, expectedResult) {
        case let (.success(receivedItems), .success(expectedItems)):
            XCTAssertEqual(receivedItems, expectedItems)
        case let (.failure(receivedError as NetworkError), .failure(expectedError as NetworkError)):
            XCTAssertEqual(receivedError, expectedError)
        default:
            XCTFail("Expected result \(expectedResult) got \(receivedResult) instead")
        }
        
    }
    
    private func makeURLRequest(enviroment: Enviroment = Enviroment.init(host: .localhost), service: CounterListServices)->URLRequest{
        return URLRequest.init(service: service, enviroment: enviroment)
    }
    
    private func successCompletion(_ items: [Counter])->RemoteCounterListLoader.Result{
        return .success(items)
    }
    
    private func failureCompletion(_ error: NetworkError) -> RemoteCounterListLoader.Result{
        return .failure(error)
    }
    
    private func makeItem(id: String? = nil, title: String? = nil, count: Int? = nil) -> (model: RemoteCounter, json: [String: Any]) {

        let item = RemoteCounter.init(id: id, title: title, count: count)
        
        let json = [ "id": id as Any,
                     "title": title as Any,
                     "count": count as Any
            ].compactMapValues { $0 }
        
        return (item, json)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]?]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
    
}
