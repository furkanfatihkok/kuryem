//
//  AppLayout.swift
//  kuryem
//
//  Created by FFK on 19.02.2026.
//
import Foundation

enum AppLayout {
    
    // MARK: - Spacing
    enum Spacing {
        static let xxSmall: CGFloat = 4
        static let xSmall: CGFloat = 8
        static let small: CGFloat = 12
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let xLarge: CGFloat = 32
        static let xxLarge: CGFloat = 48
    }
    
    // MARK: - Radius
    enum Radius {
        static let xxSmall: CGFloat = 4
        static let xSmall: CGFloat = 6
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let circular: CGFloat = 999
    }
    
    // MARK: - Border
    enum Border {
        static let thin: CGFloat = 1
        static let regular: CGFloat = 2
    }
    
    // MARK: - TextField
    enum TextField {
        static let height: CGFloat = 40
        static let width: CGFloat = 350
    }
    
    // MARK: - Button
    enum PrimaryButton {
        static let height: CGFloat = 50
        static let width: CGFloat = 350
        static let radius: CGFloat = 5
    }
    
    // MARK: - Role Card
    enum roleCardContainer {
        static let height: CGFloat = 150
        static let width: CGFloat = 350
    }
    
    // MARK: - IconContainer
    enum iconContainer {
        static let height: CGFloat = 40
        static let width: CGFloat = 40
        static let radius: CGFloat = 20
    }
    // MARK: - Icon Banner Container
    enum iconPersonelContainer {
        static let height: CGFloat = 48
        static let width: CGFloat = 48
    }
    
    // MARK: - Screen Margins
    static let screenHorizontalMargin: CGFloat = 20
}

/*
import UIKit

enum AppLayout {
    // MARK: - Spacing
    static let spacingXXSmall: CGFloat = 2
    static let spacingXSmall: CGFloat = 4
    static let spacingSmall: CGFloat = 8
    static let spacingMedium: CGFloat = 16
    static let spacingLarge: CGFloat = 24
    static let spacingXLarge: CGFloat = 32
    static let spacingXXLarge: CGFloat = 48
    
    // MARK: - Padding
    static let paddingHorizontal: CGFloat = 24
    static let paddingVertical: CGFloat = 16
    
    // MARK: - Corner Radius
    static let cornerRadiusXSmall: CGFloat = 6
    static let cornerRadiusSmall: CGFloat = 8
    static let cornerRadiusMiddle: CGFloat = 16
    static let cornerRadiusMedium: CGFloat = 20
    static let cornerRadiusLarge: CGFloat = 23.5
    static let cornerRadiusXLarge: CGFloat = 24
    
    // MARK: - Button
    static let buttonHeight: CGFloat = 50
    static let buttonHeightPopup: CGFloat = 37
    static let buttonCornerRadius: CGFloat = 5
    
    // MARK: - TextField
    static let textFieldHeight: CGFloat = 40
    static let textFieldWidth: CGFloat = 82
    static let textFieldCornerRadius: CGFloat = 8
    static let textFieldBorderWidth: CGFloat = 1
    
    // MARK: - Icon Sizes
    static let iconSizeMedium: CGFloat = 24.0
    static let iconSizeLarge: CGFloat = 30.0
    
    // MARK: - Container Sizes
    static let iconContainerSizeSmall: CGFloat = 40.0
    static let iconContainerSizeLarge: CGFloat = 50.0
    
    // MARK: - Component Specific Sizes
    static let roleCardHeight: CGFloat = 148.0
    
    // MARK: - Onboarding
    static let onboardingImageAspectRatio: CGFloat = 250 / 375
    static let onboardingImageWidthMultiplier: CGFloat = 0.9
    static let onboardingIndicatorWidth: CGFloat = 20
    static let onboardingIndicatorHeight: CGFloat = 4 
    static let onboardingIndicatorSpacing: CGFloat = 8
    
    // MARK: - Code Input
    static let codeInputBoxSize: CGFloat = 48
    static let codeInputSpacing: CGFloat = 12
    
    // MARK: - Font Sizes
    static let fontSizeXSmall: CGFloat = 10
    static let fontSizeSmall: CGFloat = 12
    static let fontSizeMedium: CGFloat = 14
    static let fontSizeLarge: CGFloat = 20
    static let fontSizeXLarge: CGFloat = 24
    static let fontSizeXXLarge: CGFloat = 28
} */

