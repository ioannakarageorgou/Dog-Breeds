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

    override func setUp() {
        super.setUp()
        mockRepository = MockBreedsRepository()
        viewModel = BreedImageViewModel(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        viewModel = nil
        super.tearDown()
    }

    func testFetchAllImagesSuccess() async {
        let selectedBreed = Breed(name: "Breed1")
        let serverImages = [BreedImage(image: URL(string: "image1")!), BreedImage(image: URL(string: "image2")!)]
        let likedImages = [LikedBreed(imageURL: "image1", breedName: "Breed1")]
        mockRepository.mockLikedBreedImages = likedImages
        mockRepository.mockBreedImages = serverImages

        viewModel.selectedBreed = selectedBreed
        await viewModel.fetchAllImages()

        XCTAssertNotNil(viewModel.breedImages)
        XCTAssertEqual(viewModel.breedImages?.count, serverImages.count)
        XCTAssertTrue(viewModel.breedImages?.first?.isLiked == true)
        XCTAssertTrue(viewModel.breedImages?.last?.isLiked == false)
    }

    func testFetchAllImagesEmptyLists() async {
        let selectedBreed = Breed(name: "Breed1")
        mockRepository.mockLikedBreedImages = []
        mockRepository.mockBreedImages = []

        viewModel.selectedBreed = selectedBreed
        await viewModel.fetchAllImages()

        XCTAssertNotNil(viewModel.breedImages)
        XCTAssertTrue(viewModel.breedImages?.isEmpty ?? false)
    }
}
