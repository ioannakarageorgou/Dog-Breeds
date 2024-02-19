//
//  BreedListViewModelTests.swift
//  Dog BreedsTests
//
//  Created by Ioanna Karageorgou on 21/1/24.
//

import XCTest

@testable import Dog_Breeds

class BreedListViewModelTests: XCTestCase {
    var viewModel: BreedListViewModel!
    var mockRepository: MockBreedsRepository!

    override func setUp() async throws {
        try await super.setUp()
        mockRepository = MockBreedsRepository()
        viewModel = await BreedListViewModel(repository: mockRepository)
    }

    override func tearDown() async throws {
        mockRepository = nil
        viewModel = nil
        try await super.tearDown()
    }

    func testFetchAllDogBreedsSuccess() async {
        let expectation = XCTestExpectation(description: "Fetch all dog breeds")
        mockRepository.mockDogBreeds = [Breed(name: "Breed1"), Breed(name: "Breed2")]

        await viewModel.fetchAllDogBreeds()
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 3)

        let breeds = await viewModel.breeds
        XCTAssertNotNil(breeds)
        XCTAssertEqual(breeds?.count, mockRepository.mockDogBreeds?.count)
    }

    func testFetchAllDogBreedsEmptyList() async {
        let expectation = XCTestExpectation(description: "Fetch all dog breeds")
        mockRepository.mockDogBreeds = []

        await viewModel.fetchAllDogBreeds()
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 3)

        let breeds = await viewModel.breeds
        XCTAssertNotNil(breeds)
        XCTAssertTrue(breeds?.isEmpty ?? false)
    }
}
