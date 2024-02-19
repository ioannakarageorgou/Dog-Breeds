//
//  FavoriteBreedsViewModelTests.swift
//  Dog BreedsTests
//
//  Created by Ioanna Karageorgou on 21/1/24.
//

import XCTest

@testable import Dog_Breeds

class FavoriteBreedsViewModelTests: XCTestCase {
    var viewModel: FavoriteBreedsViewModel!
    var mockRepository: MockBreedsRepository!

    override func setUp() async throws {
        try await super.setUp()
        mockRepository = MockBreedsRepository()
        viewModel = await FavoriteBreedsViewModel(repository: mockRepository)
    }

    override func tearDown() async throws {
        mockRepository = nil
        viewModel = nil
        try await super.tearDown()
    }

    func testFetchLikedBreedImagesSuccess() async {
        let expectation = XCTestExpectation(description: "Fetch all liked dog images")
        let mockLikedBreedImages = [LikedBreed(imageURL: "image1", breedName: "Breed1")]
        mockRepository.mockLikedBreedImages = mockLikedBreedImages

        await viewModel.fetchLikedBreedImages()
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 3)

        let likedBreedImages = await viewModel.likedBreedImages
        XCTAssertNotNil(likedBreedImages)
        XCTAssertEqual(likedBreedImages?.count, mockLikedBreedImages.count)
    }

    func testFetchLikedBreedImagesEmptyList() async {
        let expectation = XCTestExpectation(description: "Fetch all liked dog images")
        mockRepository.mockLikedBreedImages = []

        await viewModel.fetchLikedBreedImages()
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 3)

        let likedBreedImages = await viewModel.likedBreedImages
        XCTAssertNotNil(likedBreedImages)
        XCTAssertTrue(likedBreedImages?.isEmpty ?? false)
    }

    func testFetchLikedBreedImagesFailure() async {
        let expectation = XCTestExpectation(description: "Fetch all liked dog images")
        mockRepository.mockLikedBreedImages = nil

        await viewModel.fetchLikedBreedImages()
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 3)

        let likedBreedImages = await viewModel.likedBreedImages
        XCTAssertNil(likedBreedImages)
    }
}
