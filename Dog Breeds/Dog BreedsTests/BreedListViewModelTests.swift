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

    override func setUp() {
        super.setUp()
        mockRepository = MockBreedsRepository()
        viewModel = BreedListViewModel(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        viewModel = nil
        super.tearDown()
    }

    func testFetchAllDogBreedsSuccess() async {
        mockRepository.mockDogBreeds = [Breed(name: "Breed1"), Breed(name: "Breed2")]
        await viewModel.fetchAllDogBreeds()

        XCTAssertNotNil(viewModel.breeds)
        XCTAssertEqual(viewModel.breeds?.count, mockRepository.mockDogBreeds?.count)
    }

    func testFetchAllDogBreedsEmptyList() async {
        mockRepository.mockDogBreeds = []
        await viewModel.fetchAllDogBreeds()

        XCTAssertNotNil(viewModel.breeds)
        XCTAssertTrue(viewModel.breeds?.isEmpty ?? false)
    }
}
