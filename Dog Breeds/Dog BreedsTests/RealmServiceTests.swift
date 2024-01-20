//
//  RealmServiceTests.swift
//  Dog BreedsTests
//
//  Created by Ioanna Karageorgou on 20/1/24.
//

import XCTest
import RealmSwift

@testable import Dog_Breeds

class RealmServiceTests: XCTestCase {
    var mockRealmService: MockRealmService!
    var realmService: RealmServiceProtocol!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRealmService = MockRealmService()
        realmService = mockRealmService
    }

    override func tearDownWithError() throws {
        mockRealmService = nil
        realmService = nil
        try super.tearDownWithError()
    }

    func testSaveLikedBreedImage() async {
        let likedBreedImage = LikedBreed(imageURL: "testURL", breedName: "testBreed")
        do {
            try await realmService.saveLikedBreedImage(likedBreedImage)
            let fetchedLikedBreedImages = try await realmService.fetchAllLikedBreedImages()
            XCTAssertEqual(fetchedLikedBreedImages?.count, 1)
            XCTAssertEqual(fetchedLikedBreedImages?.first, likedBreedImage)
        } catch {
            XCTFail("Error saving liked breed image: \(error)")
        }
    }

    func testRemoveLikedBreedImage() async {
        let breed = Breed(name: "testBreed")
        let breedImage = BreedImage(image: URL(string: "testURL")!)
        mockRealmService.addLikedBreedImage(imageURL: breedImage.image.absoluteString, breedName: breed.name)
        do {
            try await realmService.removeLikedBreedImage(for: breed, and: breedImage)
            let fetchedLikedBreedImages = try await realmService.fetchAllLikedBreedImages()
            XCTAssertTrue(fetchedLikedBreedImages?.isEmpty ?? true)
        } catch {
            XCTFail("Error removing liked breed image: \(error)")
        }
    }

    func testFetchAllLikedBreedImages() async {
        mockRealmService.addLikedBreedImage(imageURL: "testURL1", breedName: "testBreed")
        mockRealmService.addLikedBreedImage(imageURL: "testURL2", breedName: "testBreed")
        do {
            let fetchedLikedBreedImages = try await realmService.fetchAllLikedBreedImages()
            XCTAssertEqual(fetchedLikedBreedImages?.count, 2)
        } catch {
            XCTFail("Error fetching all liked breed images: \(error)")
        }
    }

    func testFetchLikedBreedImagesForBreed() async {
        let breed1 = Breed(name: "testBreed1")
        let breed2 = Breed(name: "testBreed2")
        mockRealmService.addLikedBreedImage(imageURL: "testURL1", breedName: breed1.name)
        mockRealmService.addLikedBreedImage(imageURL: "testURL2", breedName: breed2.name)
        mockRealmService.addLikedBreedImage(imageURL: "testURL3", breedName: breed1.name)
        do {
            let fetchedLikedBreedImagesForBreed1 = try await realmService.fetchLikedBreedImages(for: breed1)
            XCTAssertEqual(fetchedLikedBreedImagesForBreed1?.count, 2)

            let fetchedLikedBreedImagesForBreed2 = try await realmService.fetchLikedBreedImages(for: breed2)
            XCTAssertEqual(fetchedLikedBreedImagesForBreed2?.count, 1)
        } catch {
            XCTFail("Error fetching liked breed images for a specific breed: \(error)")
        }
    }
}
