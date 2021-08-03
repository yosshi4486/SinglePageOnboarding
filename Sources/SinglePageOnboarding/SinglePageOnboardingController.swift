//
//  SinglePageOnboardingController.swift
//  
//
//  Created by yosshi4486 on 2021/08/03.
//

import UIKit

open class SinglePageOnboardingController: UIViewController {

    public let onboardingTitle: String

    public let onboardingItems: [OnboadingItem]

    public let orderedFooterContents: [OnboardingFooterContent]?

    public let buttonTitle: String

    public let accentColor: UIColor

    public let onCommit: () -> Void

    private var _view: _View!

    public init(onboardingTitle: String, onboardingItems: [OnboadingItem], orderedFooterContents: [OnboardingFooterContent]?, buttonTitle: String, accentColor: UIColor = .systemBlue, onCommit: @escaping () -> Void) {
        precondition(onboardingItems.count <= 3, "The count of onboarding items must be smaller than 3.")

        self.onboardingTitle = onboardingTitle
        self.onboardingItems = onboardingItems
        self.orderedFooterContents = orderedFooterContents
        self.buttonTitle = buttonTitle
        self.accentColor = accentColor
        self.onCommit = onCommit

        super.init(nibName: nil, bundle: nil)

    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func loadView() {

        _view = _View(
            onboardingTitle: onboardingTitle,
            onboardingItems: onboardingItems,
            orderedFooterContents: orderedFooterContents,
            buttonTitle: buttonTitle,
            accentColor: accentColor,
            onCommit: onCommit
        )

        view = _view
    }

    /// A internal view that manages onboarding.
    ///
    /// # The Reasons to Use UICollectionLayoutListConfiguration
    ///
    /// Onboarding View should adopt dynamic type and adaptive layout, but implementing them by UIStackView, or some plane views are very troublesome.
    /// UICollectionView with UICollectionLayoutListConfiguration make it easy to implement adaptive onboarding view.
    ///
    ///
    private class _View: UIView {

        final class HeaderView: UICollectionReusableView {

            let titleLabel: UILabel = {
                let label = UILabel()
                label.numberOfLines = 0
                label.adjustsFontForContentSizeCategory = true
                label.font = .preferredFont(forTextStyle: .largeTitle).bold()
                label.textAlignment = .center
                return label
            }()

            override init(frame: CGRect) {
                super.init(frame: frame)
                setup()
            }

            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }

            private func setup() {
                addSubview(titleLabel)
                titleLabel.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60),
                    titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
                    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                    titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
            }

        }

        final class FooterView: UICollectionReusableView {

            var topConstraint: NSLayoutConstraint!

            let button: UIButton = {
                let aButton = UIButton()
                aButton.backgroundColor = .systemBlue
                aButton.clipsToBounds = true
                aButton.layer.cornerRadius = 10
                aButton.titleLabel?.font = .preferredFont(forTextStyle: .body).bold()
                aButton.titleLabel?.adjustsFontForContentSizeCategory = true
                return aButton
            }()

            override init(frame: CGRect) {
                super.init(frame: frame)
                setup()
            }

            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }

            private func setup() {
                addSubview(button)
                button.translatesAutoresizingMaskIntoConstraints = false

                topConstraint = button.topAnchor.constraint(equalTo: topAnchor)

                NSLayoutConstraint.activate([
                    button.heightAnchor.constraint(equalToConstant: 50),
                    topConstraint,
                    button.bottomAnchor.constraint(equalTo: bottomAnchor),
                    button.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                    button.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
                ])
            }
        }

        final class Cell: UICollectionViewListCell {

            let containerStack: UIStackView = {
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.alignment = .center
                stackView.distribution = .fill
                stackView.spacing = 8
                return stackView
            }()

            let imageView: UIImageView = {
                let imageView = UIImageView()
                return imageView
            }()

            let trailingContentView: UIView = {
                let view = UIView()
                return view
            }()

            let titleLabel: UILabel = {
                let label = UILabel()
                label.numberOfLines = 0
                label.font = .preferredFont(forTextStyle: .headline)
                label.textColor = .label
                return label
            }()

            let descriptionLabel: UILabel = {
                let label = UILabel()
                label.numberOfLines = 0
                label.font = .preferredFont(forTextStyle: .body)
                label.textColor = .secondaryLabel
                return label
            }()

            private var bottomConstraint: NSLayoutConstraint!

            var spaceBetweenItem: CGFloat {
                get {
                    return bottomConstraint.constant * -1
                }

                set {
                    bottomConstraint.constant = newValue * -1
                }
            }

            override init(frame: CGRect) {
                super.init(frame: frame)
                setup()
            }

            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }

            private func setup() {
                addSubview(containerStack)
                containerStack.addArrangedSubview(imageView)
                containerStack.addArrangedSubview(trailingContentView)
                trailingContentView.addSubview(titleLabel)
                trailingContentView.addSubview(descriptionLabel)

                containerStack.translatesAutoresizingMaskIntoConstraints = false
                imageView.translatesAutoresizingMaskIntoConstraints = false
                trailingContentView.translatesAutoresizingMaskIntoConstraints = false
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

                bottomConstraint = containerStack.bottomAnchor.constraint(equalTo: bottomAnchor)
                NSLayoutConstraint.activate([
                    containerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
                    containerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
                    containerStack.topAnchor.constraint(equalTo: topAnchor),
                    bottomConstraint
                ])

                NSLayoutConstraint.activate([
                    imageView.heightAnchor.constraint(equalToConstant: 30),
                    imageView.widthAnchor.constraint(equalToConstant: 30)
                ])

                NSLayoutConstraint.activate([
                    titleLabel.topAnchor.constraint(equalTo: trailingContentView.topAnchor),
                    titleLabel.leadingAnchor.constraint(equalTo: trailingContentView.leadingAnchor),
                    titleLabel.trailingAnchor.constraint(equalTo: trailingContentView.trailingAnchor),
                    descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                    descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                    descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                    descriptionLabel.bottomAnchor.constraint(equalTo: trailingContentView.bottomAnchor)
                ])

            }

        }

        public let onboardingTitle: String

        public let onboardingItems: [OnboadingItem]

        public let orderedFooterContents: [OnboardingFooterContent]?

        public let buttonTitle: String

        public let accentColor: UIColor

        public let onCommit: () -> Void

        public init(onboardingTitle: String, onboardingItems: [OnboadingItem], orderedFooterContents: [OnboardingFooterContent]?, buttonTitle: String, accentColor: UIColor = .systemBlue, onCommit: @escaping () -> Void) {
            precondition(onboardingItems.count <= 3, "The count of onboarding items must be smaller than 3.")

            self.onboardingTitle = onboardingTitle
            self.onboardingItems = onboardingItems
            self.orderedFooterContents = orderedFooterContents
            self.buttonTitle = buttonTitle
            self.accentColor = accentColor
            self.onCommit = onCommit

            super.init(frame: .zero)

            setup()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        let containerCollectionView: UICollectionView = {
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.showsSeparators = false
            configuration.headerMode = .supplementary
            configuration.footerMode = .supplementary
            let layout = UICollectionViewCompositionalLayout.list(using: configuration)
            return UICollectionView(frame: .zero, collectionViewLayout: layout)
        }()

        private enum Section: Int {
            case main
        }

        private var dataSource: UICollectionViewDiffableDataSource<Section, OnboadingItem>!

        private func setup() {
            addSubview(containerCollectionView)
            containerCollectionView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                containerCollectionView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                containerCollectionView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                containerCollectionView.topAnchor.constraint(equalTo: topAnchor),
                containerCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])

            let cellRegistration = UICollectionView.CellRegistration<Cell, OnboadingItem> { cell, indexPath, item in
                cell.titleLabel.text = item.title
                cell.descriptionLabel.text = item.description
                cell.imageView.image = item.image
                cell.imageView.tintColor = item.imageColor
                cell.spaceBetweenItem = 50
            }

            let headerRegistration = UICollectionView.SupplementaryRegistration<HeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplymentaryView, elementKind, indexPath in
                supplymentaryView.titleLabel.text = self?.onboardingTitle
            }

            let footerRegistration = UICollectionView.SupplementaryRegistration<FooterView>(elementKind: UICollectionView.elementKindSectionFooter) { [weak self] supplymentaryView, elementKind, indexPath in
                supplymentaryView.button.setTitle(self?.buttonTitle, for: .normal)
                supplymentaryView.topConstraint.constant = 300
            }

            dataSource = UICollectionViewDiffableDataSource<Section, OnboadingItem>(collectionView: containerCollectionView, cellProvider: { collectionView, indexPath, item in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            })

            dataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) in
                if elementKind == UICollectionView.elementKindSectionHeader {
                    return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
                } else {
                    return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
                }
            }

            containerCollectionView.dataSource = dataSource
            containerCollectionView.translatesAutoresizingMaskIntoConstraints = false
            containerCollectionView.allowsSelection = false

            var snapshot = NSDiffableDataSourceSnapshot<Section, OnboadingItem>()
            snapshot.appendSections([Section.main])
            snapshot.appendItems(onboardingItems)
            dataSource.apply(snapshot, animatingDifferences: false)
        }

    }

}

import SwiftUI

public struct SinglePageOnboardingView: UIViewControllerRepresentable {

    public typealias UIViewControllerType = SinglePageOnboardingController

    public let onboardingTitle: String

    public let onboardingItems: [OnboadingItem]

    public let orderedFooterContents: [OnboardingFooterContent]?

    public let buttonTitle: String

    public let accentColor: UIColor = .systemBlue

    public let onCommit: () -> Void

    public func makeUIViewController(context: Context) -> UIViewControllerType {

        let uiViewController = UIViewControllerType(
            onboardingTitle: self.onboardingTitle,
            onboardingItems: self.onboardingItems,
            orderedFooterContents: self.orderedFooterContents,
            buttonTitle: self.buttonTitle,
            accentColor: self.accentColor,
            onCommit: self.onCommit
        )

        return uiViewController
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Static
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    public class Coordinator: NSObject {

    }

}

struct SinglePageOnboardingController_Previews: PreviewProvider {

    static var previews: some View {
        SinglePageOnboardingView(
            onboardingTitle: "What's New",
            onboardingItems: [

                OnboadingItem(image: UIImage(systemName: "heart.fill")!, imageColor: UIColor.systemPink, title: "More Personalized", description: "Top Stories picked for you and recommendations from Siri."),
                OnboadingItem(image: UIImage(systemName: "newspaper")!, imageColor: UIColor.systemRed, title: "New Articles Tab", description: "Discover latest articles."),
                OnboadingItem(image: UIImage(systemName: "play.rectangle.fill")!.withTintColor(.systemBlue, renderingMode: .alwaysTemplate), imageColor: UIColor.blue, title: "Watch Video News", description: "You can now watch video news in Video News Tab."),
            ],
            orderedFooterContents: [
                .text("Please read and agree "),
                .link(text: "terms of use", url: URL(string: "https://developer.apple.com/xcode/swiftui")!),
                .text(" and "),
                .link(text: "privacy policy.", url: URL(string: "https://developer.apple.com/xcode/swiftui")!),
                .text("Long Long Long Long Long time ago.")
            ],
            buttonTitle: "Next",
            onCommit: { }
        )
//        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
    }

}

private extension UIFont {

    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }

}
