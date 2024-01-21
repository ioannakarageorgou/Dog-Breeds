//
//  BreedsRepositoryTests.swift
//  Dog BreedsTests
//
//  Created by Ioanna Karageorgou on 21/1/24.
//

import XCTest

@testable import Dog_Breeds

class BreedsRepositoryTests: XCTestCase {
    var repository: BreedsRepository!
    var mockNetworkManager: MockNetworkManager!
    var mockRealmService: MockRealmService!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockRealmService = MockRealmService()
        repository = BreedsRepository(networkManager: mockNetworkManager, realmService: mockRealmService)
    }

    override func tearDown() {
        repository = nil
        mockNetworkManager = nil
        mockRealmService = nil
        super.tearDown()
    }

    func testFetchAllDogBreedsFromServer_Success() async {
        let mockBreedData = ["Breed1", "Breed2"]
        let mockResponse = BreedsListResponse(message: Dictionary(uniqueKeysWithValues: mockBreedData.map { ($0, [""]) }), status: AppConstants.success)
        mockNetworkManager.mockResult = .success(mockResponse)

        do {
            let result = try await repository.fetchAllDogBreedsFromServer()

            XCTAssertEqual(result.count, 2)
            XCTAssertEqual(result[0].name, "Breed1")
            XCTAssertEqual(result[1].name, "Breed2")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchAllImagesFromServer_Success() async {
        let mockImageURLs = ["Image1", "Image2"]
        let mockResponse = BreedImagesResponse(message: mockImageURLs, status: AppConstants.success)
        mockNetworkManager.mockResult = .success(mockResponse)

        do {
            let result = try await repository.fetchAllImagesFromServer(for: "Breed1")

            XCTAssertEqual(result.count, 2)
            XCTAssertEqual(result[0].image.absoluteString, "Image1")
            XCTAssertEqual(result[1].image.absoluteString, "Image2")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testSaveLikedBreedImageToRealm_Success() async {
        do {
            await repository.saveLikedBreedImageToRealm(LikedBreed(imageURL: "Image1", breedName: "Breed1"))
            let likedBreedImages = try await mockRealmService.fetchAllLikedBreedImages()

            XCTAssertEqual(likedBreedImages?.count, 1)
            XCTAssertEqual(likedBreedImages?.first?.imageURL, "Image1")
            XCTAssertEqual(likedBreedImages?.first?.breedName, "Breed1")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testRemoveLikedBreedImageFromRealm_Success() async {
        let breed = Breed(name: "Breed1")
        let breedImage = BreedImage(image: URL(string: "Image1")!)
        try? await mockRealmService.saveLikedBreedImage(LikedBreed(imageURL: "Image1", breedName: "Breed1"))

        do {
            await repository.removeLikedBreedImageFromRealm(for: breed, and: breedImage)
            let likedBreedImages = try await mockRealmService.fetchAllLikedBreedImages()
            XCTAssertTrue(likedBreedImages?.isEmpty ?? true)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    class MockBreedsRepository: BreedsRepository {
        override func fetchAllDogBreedsFromServer() async throws -> [Breed] {
            return [Breed(name: "MockBreed1"), Breed(name: "MockBreed2")]
        }
    }
}
