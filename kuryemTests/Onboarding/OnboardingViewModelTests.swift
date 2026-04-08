//
//  OnboardingViewModelTests.swift
//  kuryemTests
//
//  Created by FFK on 8.04.2026.
//

import XCTest
@testable import kuryem

final class OnboardingViewModelTests: XCTestCase {
    
    var sut: OnboardingViewModel!
    var mockRepository: MockOnboardingRepository!
    var mockDelegate: MockOnboardingViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockOnboardingRepository()
        mockDelegate = MockOnboardingViewModelDelegate()
        
        let dummyPage1 = OnboardingPage(imageName: "test_image_1", title: "Test Başlık 1", description: "Test Açıklama 1")
        let dummyPage2 = OnboardingPage(imageName: "test_image_2", title: "Test Başlık 2", description: "Test Açıklama 2")
        mockRepository.mockPages = [dummyPage1, dummyPage2]
        
        sut = OnboardingViewModel(repository: mockRepository)
        sut.delegate = mockDelegate
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func test_init_shouldLoadPagesFromRepository() {
        // Arrange
        
        // Act
        
        // Assert (Doğrulama)
        XCTAssertEqual(mockRepository.getPagesCallCount, 1, "ViewModel başlatıldığında sayfaları çekmek için repository'yi tam 1 kez çağırmalı")
        XCTAssertEqual(sut.pages.count, 2, "Repository'den gelen 2 sayfa ViewModel'in dizisine atanmış olmalı")
        XCTAssertEqual(sut.pages.first?.title, "Test Başlık 1", "Veriler doğru sırayla ve doğru şekilde eşleşmeli")
    }
    
    func test_didTapNext_shouldCallDelegateComplete() {
        // Act
        sut.didTapNext()
        
        // Assert
        XCTAssertTrue(mockDelegate.didCompleteCalled, "İleri (Next) butonuna basıldığında Coordinator'a (Delegate) haber verilmeli")
    }
}
