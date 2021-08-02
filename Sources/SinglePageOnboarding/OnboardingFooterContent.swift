//
//  OnboardingFooterContent.swift
//  
//
//  Created by yosshi4486 on 2021/08/02.
//

import Foundation

/// A **Onboarding Footer Content** exist by limitation of SwiftUI attributed string, but `AttributedText` type will be introduced in iOS15. This class must be replaced with that.
public enum OnboardingFooterContent {
    case text(String)
    case link(text: String, url: URL)

    var textValue: String {
        switch self {
        case .text(let value):
            return value

        case .link(text: let value, url: _):
            return value
        }
    }
}

extension OnboardingFooterContent: Hashable, Equatable {}

extension OnboardingFooterContent: Identifiable {

    public var id: Int { hashValue }
    
}
