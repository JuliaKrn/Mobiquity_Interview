//
//  MobiquityTests.swift
//  MobiquityTests
//
//  Created by Iuliia Korniichuk on 25.02.2021.
//

import XCTest
@testable import Mobiquity

class GalleryViewModelTests: XCTestCase {

    var sut: GalleryViewModel!
    
    override func setUp() {
        super.setUp()
        
        let controller = GalleryViewController()
        let apiManager = APIManagerMock()
        let viewModel = GalleryViewModel(view: controller, apiManager: apiManager)
        controller.viewModel = viewModel

        sut = viewModel
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testLoadDefaultPhoto() {
        XCTAssertEqual(sut.viewValues.photosToShow.count, 4)
    }
    
    func testDidChoseTheme() {
        sut.didChoseTheme("Cats")
        
        XCTAssertEqual(sut.viewValues.photosToShow.count, 2)
    }
    
    func testLoadMorePhoto() {
        sut.loadMorePhotos()
        
        XCTAssertEqual(sut.viewValues.photosToShow.count, 4)
    }
    
}
