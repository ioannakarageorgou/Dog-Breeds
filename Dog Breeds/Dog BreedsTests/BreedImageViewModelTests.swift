//
//  BreedImageViewModelTests.swift
//  Dog BreedsTests
//
//  Created by Ioanna Karageorgou on 21/1/24.
//

import XCTest

@testable import Dog_Breeds

class BreedImageViewModelTests: XCTestCase {
    var viewModel: BreedImageViewModel!
    var mockRepository: MockBreedsRepository!

    override func setUp() async throws {
        try await super.setUp()
        mockRepository = MockBreedsRepository()
        viewModel = await BreedImageViewModel(repository: mockRepository)
    }

    override func tearDown() async throws {
        mockRepository = nil
        viewModel = nil
        try await super.tearDown()
    }

    func testFetchAllImagesSuccess() async {
        let expectation = XCTestExpectation(description: "Fetch all dog images")
        let selectedBreed = Breed(name: "Breed1")
        let serverImages = [BreedImage(image: URL(string: "image1")!), BreedImage(image: URL(string: "image2")!)]
        let likedImages = [LikedBreed(imageURL: "image1", breedName: "Breed1")]
        mockRepository.mockLikedBreedImages = likedImages
        mockRepository.mockBreedImages = serverImages

        await MainActor.run {
            viewModel.selectedBreed = selectedBreed
        }
        expectation.fulfill()
        await viewModel.fetchAllImages()
        await fulfillment(of: [expectation], timeout: 5)

        let breedImages = await viewModel.breedImages
        XCTAssertNotNil(breedImages)
        XCTAssertEqual(breedImages?.count, serverImages.count)
        XCTAssertTrue(breedImages?.first?.isLiked == true)
        XCTAssertTrue(breedImages?.last?.isLiked == false)
    }

    func testFetchAllImagesEmptyLists() async {
        let expectation = XCTestExpectation(description: "Fetch all dog images")
        let selectedBreed = Breed(name: "Breed1")
        mockRepository.mockLikedBreedImages = []
        mockRepository.mockBreedImages = []

        await MainActor.run {
            viewModel.selectedBreed = selectedBreed
        }
        expectation.fulfill()
        await viewModel.fetchAllImages()
        await fulfillment(of: [expectation], timeout: 5)

        let breedImages = await viewModel.breedImages
        XCTAssertNotNil(breedImages)
        XCTAssertTrue(breedImages?.isEmpty ?? false)
    }
}
