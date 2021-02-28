//
//  GalleryViewSnapshotTests.swift
//  MobiquityTests
//
//  Created by Iuliia Korniichuk on 28.02.2021.
//

import XCTest
import FlickrKit
import FBSnapshotTestCase
@testable import Mobiquity

// Iuliia: Screenshots can be found in .../Mobiquity/MobiquityTests/ReferenceImages_64/

class GalleryViewControllerSnapshotTests: FBSnapshotTestCase {
    
    var sut: GalleryViewController!
    
    override func setUp() {
        super.setUp()
        
        recordMode = false
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testGalleryLoadedState() {
        let viewModel = GalleryViewModelMock(loaded: true)
        let controller = GalleryViewController()
        controller.viewModel = viewModel

        sut = controller
        
        FBSnapshotVerifyViewController(sut)
    }
    
    func testGalleryLoadingState() {
        let viewModel = GalleryViewModelMock(loaded: false)
        let controller = GalleryViewController()
        controller.viewModel = viewModel

        sut = controller
        
        FBSnapshotVerifyViewController(sut)
    }
    
}
