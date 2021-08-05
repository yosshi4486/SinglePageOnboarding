//
//  OnboardingAction.swift
//  
//
//  Created by yosshi4486 on 2021/08/05.
//

import Foundation

/// An action that can be taken when the user taps a bottom button in an onboarding view.
public struct OnboardingAction {

    /// The title of action that will be set to `button.setTitle(:for:)`.
    public var title: String

    /// The handler of action, which wil be performed when a button tapped.
    var handler: (OnboardingAction) -> Void

    /// Creates **Onboarding Action** with the given title and handler.
    ///
    /// - Parameters:
    ///   - title: The title of action.
    ///   - handler: The handler of action, which wil be performed when a button tapped.
    public init(title: String, handler: @escaping (OnboardingAction) -> Void) {
        self.title = title
        self.handler = handler
    }

}
