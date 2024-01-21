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

    override func setUp() {
        super.setUp()
        mockRepository = MockBreedsRepository()
        viewModel = FavoriteBreedsViewModel(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        viewModel = nil
        super.tearDown()
    }

    func testFetchLikedBreedImagesSuccess() async {
        let likedBreedImages = [LikedBreed(imageURL: "image1", breedName: "Breed1")]
        mockRepository.mockLikedBreedImages = likedBreedImages
        await viewModel.fetchLikedBreedImages()

        XCTAssertNotNil(viewModel.likedBreedImages)
        XCTAssertEqual(viewModel.likedBreedImages?.count, likedBreedImages.count)
    }

    func testFetchLikedBreedImagesEmptyList() async {
        mockRepository.mockLikedBreedImages = []
        await viewModel.fetchLikedBreedImages()

        XCTAssertNotNil(viewModel.likedBreedImages)
        XCTAssertTrue(viewModel.likedBreedImages?.isEmpty ?? false)
    }

    func testFetchLikedBreedImagesFailure() async {
        mockRepository.mockLikedBreedImages = nil
        await viewModel.fetchLikedBreedImages()

        XCTAssertNil(viewModel.likedBreedImages)
    }
}
