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
///
/// - If there is enough space of the contents, layout the button pinned to bottom, otherwise the button become scrollable contents.
/// - The footer attributed string and the button are provided assuming situations for agreements to users, so avoiding a interaction without reading all contents  has benefits of some legal acpects.
/// - Adopt trait collection changes, such as content category.
/// - Avoid complex implementations whenever possible.
///
/// # Design of SinglePageOnboardingController
///
/// Following the key concepts, Single Page Onboarding Controller decide to use both collectionview and footerview to switch footer pinned behavior by content size.
///
/// When the actual content height is larger than view height, the  footer cell of the collectionview is shown, otherwise the footerview is shown.
///
/// # TO BE FIXED
///
/// - Refine english writings by getting review from other reviewers.
/// - The textview of FooterCell doesn't reflect prefered content category's change.
///
public class SinglePageOnboardingController: UIViewController {

    /// The title of onboarding view, suck as "Welcome to my app" or "What's New".
    ///
    /// This property is set to the value you specified in the init(onboardingTitle:onboardingItems:handler) method
    public let onboardingTitle: String

    /// The items which convery about your app key features to the user.
    ///
    /// This property is set to the value you specified in the init(onboardingTitle:onboardingItems:handler) method
    public let onboardingFeatureItems: [OnboadingFeatureItem]

    /// The action that is used in bottom button.
    ///
    /// This property is set to the value you specified in the init(onboardingTitle:onboardingItems:handler) method
    public let onboardingAction: OnboardingAction

    public var footerAttributedString: NSAttributedString? {
        didSet {
            singlePageOnboardingUIKitView.footerAttributedString = footerAttributedString
        }
    }

    public weak var footerTextViewDelegate: UITextViewDelegate? {
        didSet {

        }
    }

    public var tintColor: UIColor? {
        didSet {
            singlePageOnboardingUIKitView.tintColor = tintColor ?? .systemBlue
        }
    }

    private var singlePageOnboardingUIKitView: SinglePageOnbarodingUIKitView!

    public init(onboardingTitle: String, onboardingFeatureItems: [OnboadingFeatureItem], onboardingAction: OnboardingAction) {
        precondition(onboardingFeatureItems.count <= 3, "The count of onboarding items must be smaller than 3.")

        self.onboardingTitle = onboardingTitle
        self.onboardingFeatureItems = onboardingFeatureItems
        self.onboardingAction = onboardingAction

        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {

        singlePageOnboardingUIKitView = SinglePageOnbarodingUIKitView(
            onboardingTitle: onboardingTitle,
            onboardingFeatureItems: onboardingFeatureItems,
            onboardingAction: onboardingAction
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

    public let onboardingFeatureItems: [OnboadingFeatureItem]

    public let onboardingAction: OnboardingAction

    public let footerAttributedString: NSAttributedString?

    public let accentColor: UIColor?

    public func makeUIViewController(context: Context) -> UIViewControllerType {

        let uiViewController = UIViewControllerType(
            onboardingTitle: self.onboardingTitle,
            onboardingFeatureItems: self.onboardingFeatureItems,
            onboardingAction: self.onboardingAction
        )

        return uiViewController
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.footerAttributedString = self.footerAttributedString
        uiViewController.tintColor = self.accentColor
    }

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
                    onboardingFeatureItems: [
                        OnboadingFeatureItem(image: UIImage(systemName: "heart.fill")!, imageColor: UIColor.systemPink, title: "More Personalized", description: "Top Stories picked for you and recommendations from Siri."),
                        OnboadingFeatureItem(image: UIImage(systemName: "newspaper")!, imageColor: UIColor.systemRed, title: "New Articles Tab", description: "Discover latest articles."),
                        OnboadingFeatureItem(image: UIImage(systemName: "play.rectangle.fill")!.withTintColor(.systemBlue, renderingMode: .alwaysTemplate), imageColor: UIColor.blue, title: "Watch Video News", description: "You can now watch video news in Video News Tab."),
                    ],
                    onboardingAction: OnboardingAction(title: "Next", handler: { _ in }),
                    footerAttributedString: attributedString,
                    accentColor: UIColor.purple
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
