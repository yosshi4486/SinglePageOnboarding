//
//  SinglePageOnboardingController.swift
//  
//
//  Created by yosshi4486 on 2021/08/03.
//

import UIKit

/// A view controller that presents onboarding content in single page.
///
/// Use this class to configure single page onboarding content. After configuring the single page onboarding controller with the feature items and action,
/// present it using the `present(_:animated:completion:)` method. UIKit displays onboarding content modaly over your app's content.
///
///     let onboarding = SinglePageOnboardingController(
///         title: "Welcome to My App!",
///         featureItems: [
///             OnboadingFeatureItem(
///                 title: "More Personalized",
///                 description: "Top Stories picked for you and recommendations from Siri.",
///                 image: UIImage(systemName: "heart.fill")!
///             )
///         ],
///      )
///
///     onboarding.action = OnboardingAction(
///         title: "Agree and Continue",
///         handler: { action in
///             // Do something.
///             onboarding.dismiss(animated: true, completion: nil)
///         }
///     )
///
///     self.present(onboarding, animated: true, completion: nil)
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
    public override var title: String? {
        get {
            return onboardingView.title
        }

        set {
            onboardingView.title = newValue
        }
    }

    /// The items which convery about your app key features to the user. The count of items must be 3.
    ///
    /// This property is set to the value you specified in the init(onboardingTitle:onboardingItems:handler) method.
    public var featureItems: [OnboadingFeatureItem] {
        get {
            return onboardingView.featureItems
        }

        set {
            precondition(newValue.count == 3, "The count of items must be 3.")
            onboardingView.featureItems = newValue
        }
    }

    /// The action that is used in bottom button.
    ///
    /// This property is set to the value you specified in the init(onboardingTitle:onboardingItems:handler) method
    public var action: OnboardingAction? {
        get {
            return onboardingView.action
        }

        set {
            onboardingView.action = newValue
        }
    }

    /// The attributed string that will be set to footer text view. The default value is nil.
    public var footerAttributedString: NSAttributedString? {
        get {
            return onboardingView.footerAttributedString
        }

        set {
            onboardingView.footerAttributedString = newValue
        }
    }

    /// The text view delegate that will be set to footer text view. The default value is nil.
    public weak var footerTextViewDelegate: UITextViewDelegate? {
        get {
            return onboardingView.footerTextViewDelegate
        }

        set {
            onboardingView.footerTextViewDelegate = newValue
        }
    }

    /// The space between each feature item cell. The default value is 30pt.
    public var spacingBetweenEachFeatureItem: CGFloat {
        get {
            return onboardingView.spaceBetweenEachFeatureItem
        }

        set {
            onboardingView.spaceBetweenEachFeatureItem = newValue
        }
    }

    /// The tintColor that affects all descendant view.
    ///
    /// If you provide `imageColor` in featureItems, the tintColor is ignored in feature item cell.
    public var tintColor: UIColor! {
        get {
            return onboardingView.tintColor
        }

        set {
            onboardingView.tintColor = newValue
        }
    }

    /// The internal view that is loaded in `loadView()`.
    private var onboardingView: OnbarodingView!

    /// Creates *Single Page Onboarding Controller* instance by the given title and feature items.
    ///
    /// - Parameters:
    ///   - title: The title of the obnarding content.
    ///   - featureItems: The features of the onboarding experience. The count of items must be 3, if the count of items is bigger, or smaller than 3, a runtime crash will occur. (but it is ignored in production scheme.)
    public init(title: String?, featureItems: [OnboadingFeatureItem]) {
        precondition(featureItems.count <= 3, "The count of onboarding items must be smaller than 3.")

        self.onboardingView = OnbarodingView(
            title: title,
            featureItems: featureItems
        )

        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        view = onboardingView
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        onboardingView.switchToAppropriateFooterViewRespectingForContentSize()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            /*
             Force update onboardingview's layout just before using the scrollview contentsize.
             */
            onboardingView.setNeedsLayout()
            onboardingView.layoutIfNeeded()
            onboardingView.switchToAppropriateFooterViewRespectingForContentSize()
        }

    }

}

import SwiftUI

public struct SinglePageOnboardingView: UIViewControllerRepresentable {

    public typealias UIViewControllerType = SinglePageOnboardingController

    public let title: String?

    public let featureItems: [OnboadingFeatureItem]

    public let action: OnboardingAction?

    public let footerAttributedString: NSAttributedString?

    public weak var footerTextViewDelegate: UITextViewDelegate?

    public var tintColor: UIColor?

    public func makeUIViewController(context: Context) -> UIViewControllerType {

        let uiViewController = UIViewControllerType(
            title: self.title,
            featureItems: self.featureItems
        )

        return uiViewController
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.footerAttributedString = self.footerAttributedString
        uiViewController.tintColor = self.tintColor ?? .systemBlue
        uiViewController.footerTextViewDelegate = self.footerTextViewDelegate
        uiViewController.action = self.action
        uiViewController.spacingBetweenEachFeatureItem = 30
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
                    title: "What's New",
                    featureItems: [
                        OnboadingFeatureItem(title: "More Personalized", description: "Top Stories picked for you and recommendations from Siri.", image: UIImage(systemName: "heart.fill")!, imageColor: UIColor.systemPink),
                        OnboadingFeatureItem(title: "New Articles Tab", description: "Discover latest articles.", image: UIImage(systemName: "newspaper")!, imageColor: UIColor.systemRed),
                        OnboadingFeatureItem(title: "Watch Video News", description: "You can now watch video news in Video News Tab.", image: UIImage(systemName: "play.rectangle.fill")!.withTintColor(.systemBlue, renderingMode: .alwaysTemplate), imageColor: UIColor.blue),
                    ],
                    action: OnboardingAction(title: "Next", handler: { _ in }),
                    footerAttributedString: attributedString,
                    tintColor: .purple
                )
                /*
                 Please try to check differences when accessibility settings are changed by users.

                 Commend out here.
                 */
//                .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
            })
            .ignoresSafeArea()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
            .previewDisplayName("iPhone 12 Pro Max")

    }

}
