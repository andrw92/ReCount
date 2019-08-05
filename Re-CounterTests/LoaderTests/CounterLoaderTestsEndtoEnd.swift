//
//  CounterLoaderTestsEndtoEnd.swift
//  Re-CounterTests
//
//  Created by Andrés Alexis Rivas Solorzano on 7/30/19.
//  Copyright © 2019 Andrés Alexis Rivas Solorzano. All rights reserved.
//

import XCTest
@testable import Re_Counter

//Pruebas end to end, es necesario coordinarlas con backend para poder revisar los posibles fails.
class CounterLoaderTestsEndtoEnd: XCTestCase {
    
    func test_endToEndGet_deliverData(){
        let sut = makeSUT()
        let exp = expectation(description: "wait for completion")
        sut.get { result in
            switch result{
            case .success(let items):
                //La lista puede venir vacia, lo importante es que entregue una respuesta
                XCTAssert(items.count >= 0)
            case .failure(let error):
                XCTFail("Error on get: \(error.localizedDescription)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
    }

    func test_endToEndCreate_deliverExpectedData(){
        let sut = makeSUT()
        let testTitle = "Pruebita"
        
        let exp = expectation(description: "wait for completion")
        
        sut.create(title: testTitle){ result in
            switch result{
            case .success(let items):
                print(items)
                XCTAssertTrue(items.contains(where: {$0.title == testTitle}))
            case .failure(let error):
                XCTFail("Error on create: \(error.localizedDescription)")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
    }
    
    
    //Las siguientes pruebas tienen algo que me molesta y es que al momento de crear un contador obtenemos la lista completa por lo que no sabemos el id asignado al contador creado, lo buscamos por el último en el array que tenga ese titulo, sin embargo es posibles que existan varios contadores con el mismo titulo y no hay que fiarse en el orden del array.
    
     //MARK: - DELETE
    
    //Se prueba que dado un contador existente en la lista de contadores se borre ese contador.
    func test_endToEndDelete_deliverExpectedData(){
        let sut = makeSUT()
        let exp = expectation(description: "wait for completion")
        createAndReturnCounter(sut: sut, counterTitle: "CounterToDelete") { counter in
            sut.delete(counterId: counter.id, completion: { result in
                switch result{
                case .success(let newItems):
                    XCTAssertFalse(newItems.contains(where: {$0.id == counter.id} ))
                case .failure(let error):
                    XCTFail("Error on delete: \(error.localizedDescription)")
                }
                exp.fulfill()
            })
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func test_endToEndIncrement_deliversExpectedData(){
        let sut = makeSUT()
        let exp = expectation(description: "wait for completion")
        createAndReturnCounter(sut: sut, counterTitle: "CounterToIncrement") { (counter) in
            let currentCount = counter.count
            sut.increment(counterId: counter.id, completion: { (result) in
                switch result{
                case .success(let receivedItems):
                    let updatedCounter = self.findCounter(in: receivedItems, findId: counter.id)
                    XCTAssert(updatedCounter.count > currentCount)
                case .failure(let error):
                    XCTFail("Error on increment: \(error.localizedDescription)")
                }
                exp.fulfill()
            })
            
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    func test_endToEndDecrement_deliversExpectedData(){
        let sut = makeSUT()
        let exp = expectation(description: "wait for completion")
        createAndReturnCounter(sut: sut, counterTitle: "CounterToDecrement") { (counter) in
            let currentCount = counter.count
            sut.decrement(counterId: counter.id, completion: { (result) in
                switch result{
                case .success(let receivedItems):
                    let updatedCounter = self.findCounter(in: receivedItems, findId: counter.id)
                    XCTAssert(updatedCounter.count < currentCount)
                case .failure(let error):
                    XCTFail("Error on increment: \(error.localizedDescription)")
                }
                exp.fulfill()
            })
            
        }
        wait(for: [exp], timeout: 10.0)
    }
    
    
    //MARK - Helpers
    
    private func makeSUT()->RemoteCounterListLoader{
        let enviroment = Enviroment.init(host: .localhost)
        let client = URLSessionHTTPClient()
        return RemoteCounterListLoader.init(enviroment: enviroment, client: client)
    }
    
    private func findCounter(in counterList: [Counter], findId: String)->Counter{
        guard let counter = counterList.last(where: {$0.id == findId}) else{
            fatalError("No existe item papa")
        }
        return counter
    }
    
    
    private func createAndReturnCounter(sut: RemoteCounterListLoader,
                                        counterTitle: String,
                                        completion: @escaping ((Counter) -> Void)){
        
        let exp = expectation(description: "wait for creation")
        sut.create(title: counterTitle) { result in
            switch result{
            case .success(let receivedItems):
                guard let counter = receivedItems.last(where: {$0.title == counterTitle}) else{
                    XCTFail("Failed to retrieve item")
                    return
                }
                completion(counter)
            case .failure(let error):
                XCTFail("Failed to create: \(error.localizedDescription)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
    }
}
