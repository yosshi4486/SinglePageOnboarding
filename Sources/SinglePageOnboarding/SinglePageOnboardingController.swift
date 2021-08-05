//
//  SinglePageOnboardingController.swift
//  
//
//  Created by yosshi4486 on 2021/08/03.
//

import UIKit

/// A view controller that presents onboarding content in single page.
///
/// # Key Concepts of This View Controller
///
/// This view controller follows several key concepts as followings:
/// 1. If there is enough space of the contents, layout the button pinned to bottom, otherwise the button become scrollable contents.
/// 2. The footer attributed string and the button are provided assuming situations for agreements to users, so avoiding a interaction without reading all contents  has benefits of some legal acpects.
/// 3. Avoid complex implementations whenever possible.
///
/// # Design of SinglePageOnboardingController
///
/// Following the key concepts, Single Page Onboarding Controller decide to use both collectionview and footerview to switch footer pinned behavior by content size.
///
/// When the actual content height is larger than view height, the  footer cell of the collectionview is shown, otherwise the footerview is shown.
///
/// # TO BE FIXED
///
/// - API design are not good. I'd like to imitate `UIAleretController` design.
/// - Refine englishs by getting review from other reviewers.
/// - The textview of FooterCell doesn't reflect prefered content category's change.
///
public class SinglePageOnboardingController: UIViewController {

    public let onboardingTitle: String

    public let onboardingItems: [OnboadingItem]

    public let footerAttributedString: NSAttributedString?

    public let buttonTitle: String

    public let accentColor: UIColor?

    public let onCommit: () -> Void

    private var singlePageOnboardingUIKitView: SinglePageOnbarodingUIKitView!

    public init(onboardingTitle: String, onboardingItems: [OnboadingItem], footerAttributedString: NSAttributedString?, buttonTitle: String, accentColor: UIColor?, onCommit: @escaping () -> Void) {
        precondition(onboardingItems.count <= 3, "The count of onboarding items must be smaller than 3.")

        self.onboardingTitle = onboardingTitle
        self.onboardingItems = onboardingItems
        self.footerAttributedString = footerAttributedString
        self.buttonTitle = buttonTitle
        self.accentColor = accentColor
        self.onCommit = onCommit

        super.init(nibName: nil, bundle: nil)

    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {

        singlePageOnboardingUIKitView = SinglePageOnbarodingUIKitView(
            onboardingTitle: onboardingTitle,
            onboardingItems: onboardingItems,
            footerAttributedString: footerAttributedString,
            buttonTitle: buttonTitle,
            accentColor: accentColor,
            onCommit: onCommit
        )

        view = singlePageOnboardingUIKitView
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            singlePageOnboardingUIKitView.useAppropriateFooterRespectingForActualContentSize()
        }
    }    

}

import SwiftUI

public struct SinglePageOnboardingView: UIViewControllerRepresentable {

    public typealias UIViewControllerType = SinglePageOnboardingController

    public let onboardingTitle: String

    public let onboardingItems: [OnboadingItem]

    public let footerAttributedString: NSAttributedString?

    public let buttonTitle: String

    public let accentColor: UIColor?

    public let onCommit: () -> Void

    public func makeUIViewController(context: Context) -> UIViewControllerType {

        let uiViewController = UIViewControllerType(
            onboardingTitle: self.onboardingTitle,
            onboardingItems: self.onboardingItems,
            footerAttributedString: self.footerAttributedString,
            buttonTitle: self.buttonTitle,
            accentColor: self.accentColor,
            onCommit: self.onCommit
        )

        return uiViewController
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }

    public func makeCoordinator() -> Coordinator { Coordinator() }

    public class Coordinator: NSObject {}

}

struct SinglePageOnboardingController_Previews: PreviewProvider {

    @State static var isPresentated: Bool = true

    static var attributedString: NSAttributedString {
        let baseFooterText = NSLocalizedString("Please read and agree terms of use and privacy policy.", comment: "")
        let attributedString = NSMutableAttributedString(string: baseFooterText, attributes: [
            .foregroundColor: UIColor.label,
            .font: UIFont.preferredFont(forTextStyle: .headline)
        ])

        attributedString.addAttribute(.link,
                                      value: "https://developer.apple.com",
                                      range: NSString(string: baseFooterText).range(of: NSLocalizedString("terms of use", comment: "")))
        attributedString.addAttribute(.link,
                                      value: "https://developer.apple.com",
                                      range: NSString(string: baseFooterText).range(of: NSLocalizedString("privacy policy", comment: "")))
        return attributedString
    }

    static var previews: some View {
        Color.gray
            .sheet(isPresented: $isPresentated, content: {
                SinglePageOnboardingView(
                    onboardingTitle: "What's New",
                    onboardingItems: [
                        OnboadingItem(image: UIImage(systemName: "heart.fill")!, imageColor: UIColor.systemPink, title: "More Personalized", description: "Top Stories picked for you and recommendations from Siri."),
                        OnboadingItem(image: UIImage(systemName: "newspaper")!, imageColor: UIColor.systemRed, title: "New Articles Tab", description: "Discover latest articles."),
                        OnboadingItem(image: UIImage(systemName: "play.rectangle.fill")!.withTintColor(.systemBlue, renderingMode: .alwaysTemplate), imageColor: UIColor.blue, title: "Watch Video News", description: "You can now watch video news in Video News Tab."),
                    ],
                    footerAttributedString: attributedString,
                    buttonTitle: "Next",
                    accentColor: UIColor.purple,
                    onCommit: { }
                )
                /*
                 Please try to check differences when accessibility settings are changed by users.

                 Commend out here.
                 */
                .environment(\.sizeCategory, .accessibilityExtraExtraLarge)

            })
            .ignoresSafeArea()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .previewDisplayName("iPhone 12 Pro Max")

    }

}
