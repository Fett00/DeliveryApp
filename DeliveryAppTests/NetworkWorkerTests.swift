//
//  NetworkWorkerTests.swift
//  DeliveryAppTests
//
//  Created by Садык Мусаев on 21.03.2022.
//

import XCTest
@testable import DeliveryApp

class NetworkWorkerTests: XCTestCase {
    
    var networkWorker: NetworkWorker!

    override func setUpWithError() throws {
        
        try super.setUpWithError()
        networkWorker = NetworkWorker()
    }

    override func tearDownWithError() throws {
        
        try super.tearDownWithError()
        networkWorker = nil
    }

    func testExample() throws {
        
        networkWorker.getData(from: URLs.mealsURL) { result in
            
            switch result{
                
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTAssert(false)
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            networkWorker.getData(from: URLs.mealsURL) { _ in }
        }
    }

}
