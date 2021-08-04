//
//  SinglePageOnboardingController.swift
//  
//
//  Created by yosshi4486 on 2021/08/03.
//

import UIKit

public class SinglePageOnboardingController: UIViewController {

    public let onboardingTitle: String

    public let onboardingItems: [OnboadingItem]

    public let footerAttributedString: NSAttributedString?

    public let buttonTitle: String

    public let accentColor: UIColor?

    public let onCommit: () -> Void

    private var _view: _View!

    private var executesInitialAdjustment: Bool = true

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

        _view = _View(
            onboardingTitle: onboardingTitle,
            onboardingItems: onboardingItems,
            footerAttributedString: footerAttributedString,
            buttonTitle: buttonTitle,
            accentColor: accentColor,
            onCommit: onCommit
        )

        view = _view
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Avoid infinite loop.
        if executesInitialAdjustment {
            _view.adjustSpacerToFit()
            executesInitialAdjustment = false
        }

    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        _view.adjustSpacerToFit()
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

        private enum Section: Int, CaseIterable {
            case header
            case main
            case spacer
            case footer
        }

        private enum Item: Hashable {
            case header
            case footer
            case spacer
            case onboarding(OnboadingItem)
        }

        final class HeaderView: UICollectionViewListCell {

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

        final class FooterView: UICollectionViewListCell {

            let textView: UITextView = {
                let view = UITextView()
                view.isEditable = false
                view.isSelectable = true
                view.isUserInteractionEnabled = true
                view.isScrollEnabled = false
                return view
            }()

            let button: UIButton = {
                let aButton = UIButton()
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
                addSubview(textView)
                addSubview(button)
                textView.translatesAutoresizingMaskIntoConstraints = false
                button.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    textView.topAnchor.constraint(equalTo: topAnchor),
                    textView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                    textView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
                ])

                NSLayoutConstraint.activate([
                    button.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
                    button.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: layoutMargins.top),
                    button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
                    button.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
                    button.trailingAnchor.constraint(equalTo: textView.trailingAnchor)
                ])

            }
        }

        final class Spacer: UICollectionViewListCell {

            var heightConstraint: NSLayoutConstraint!

            let label: UILabel = {
                return UILabel()
            }()

            override init(frame: CGRect) {
                super.init(frame: frame)
                setup()
            }

            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }

            private func setup() {
                addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false

                heightConstraint = label.heightAnchor.constraint(equalToConstant: 0)

                NSLayoutConstraint.activate([
                    heightConstraint,
                    label.topAnchor.constraint(equalTo: topAnchor),
                    label.bottomAnchor.constraint(equalTo: bottomAnchor),
                    label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                    label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
                ])
            }

        }

        final class Cell: UICollectionViewListCell {

            let containerStack: UIStackView = {
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.alignment = .center
                stackView.distribution = .fill
                stackView.spacing = 15
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
                label.adjustsFontForContentSizeCategory = true
                return label
            }()

            let descriptionLabel: UILabel = {
                let label = UILabel()
                label.numberOfLines = 0
                label.font = .preferredFont(forTextStyle: .body)
                label.textColor = .secondaryLabel
                label.adjustsFontForContentSizeCategory = true
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

            private var imageWidthConstaint: NSLayoutConstraint!
            private var imageHeightConstraint: NSLayoutConstraint!

            var imageSize: CGSize {
                get {
                    return .init(width: imageWidthConstaint.constant, height: imageHeightConstraint.constant)
                }

                set {
                    imageWidthConstaint.constant = newValue.width
                    imageHeightConstraint.constant = newValue.height
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
                    containerStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                    containerStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                    containerStack.topAnchor.constraint(equalTo: topAnchor),
                    bottomConstraint
                ])

                imageWidthConstaint = imageView.widthAnchor.constraint(equalToConstant: 50)
                imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 50)

                NSLayoutConstraint.activate([
                    imageWidthConstaint,
                    imageHeightConstraint
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

                if traitCollection.preferredContentSizeCategory >= .accessibilityMedium {
                    containerStack.axis = .vertical
                    containerStack.alignment = .leading
                } else {
                    containerStack.axis = .horizontal
                    containerStack.alignment = .center
                }

            }

            override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
                super.traitCollectionDidChange(previousTraitCollection)

                /*
                 Best practice for adapting dynamic type by using UIStackView.
                 */
                if traitCollection.preferredContentSizeCategory >= .accessibilityMedium {
                    containerStack.axis = .vertical
                    containerStack.alignment = .leading
                } else {
                    containerStack.axis = .horizontal
                    containerStack.alignment = .center
                }
            }

        }

        public let onboardingTitle: String

        public let onboardingItems: [OnboadingItem]

        public let footerAttributedString: NSAttributedString?

        public let buttonTitle: String

        public let accentColor: UIColor?

        public let onCommit: () -> Void

        private let containerCollectionView: UICollectionView = {
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.showsSeparators = false
            let layout = UICollectionViewCompositionalLayout.list(using: configuration)
            return UICollectionView(frame: .zero, collectionViewLayout: layout)
        }()

        private var spacerHeight: CGFloat = 0

        private weak var footer: FooterView?

        private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!


        public init(onboardingTitle: String, onboardingItems: [OnboadingItem], footerAttributedString: NSAttributedString?, buttonTitle: String, accentColor: UIColor?, onCommit: @escaping () -> Void) {
            self.onboardingTitle = onboardingTitle
            self.onboardingItems = onboardingItems
            self.footerAttributedString = footerAttributedString
            self.buttonTitle = buttonTitle
            self.accentColor = accentColor
            self.onCommit = onCommit

            super.init(frame: .zero)

            setup()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setup() {
            layoutMargins.left = 50
            layoutMargins.right = 50
            containerCollectionView.preservesSuperviewLayoutMargins = true

            addSubview(containerCollectionView)
            containerCollectionView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                containerCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                containerCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                containerCollectionView.topAnchor.constraint(equalTo: topAnchor),
                containerCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])

            let cellRegistration = UICollectionView.CellRegistration<Cell, Item> { [weak self] cell, indexPath, item in
                if case .onboarding(let onboardingItem) = item {
                    cell.titleLabel.text = onboardingItem.title
                    cell.descriptionLabel.text = onboardingItem.description
                    cell.imageView.image = onboardingItem.image
                    cell.imageView.tintColor = onboardingItem.imageColor ?? self?.accentColor
                    cell.imageSize = onboardingItem.imageSize
                    cell.spaceBetweenItem = 50
                    cell.containerStack.spacing = onboardingItem.spacingBetweenImageAndContentView
                }
            }

            let headerRegistration = UICollectionView.CellRegistration<HeaderView, Item> { [weak self] cell, indexPath, item in
                cell.titleLabel.text = self?.onboardingTitle
            }

            let footerRegistration = UICollectionView.CellRegistration<FooterView, Item> { [weak self] cell, indexPath, item in
                cell.textView.attributedText = self?.footerAttributedString
                cell.button.setTitle(self?.buttonTitle, for: .normal)
                cell.button.backgroundColor = self?.accentColor ?? .systemBlue
                self?.footer = cell
            }

            let spacerRegistration = UICollectionView.CellRegistration<Spacer, Item> { [weak self] cell, indexPath, item in
                cell.heightConstraint.constant = self?.spacerHeight ?? 0
            }

            dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: containerCollectionView, cellProvider: { collectionView, indexPath, item in
                switch item {
                case .header:
                    return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
                case .footer:
                    return collectionView.dequeueConfiguredReusableCell(using: footerRegistration, for: indexPath, item: item)
                case .onboarding(_):
                    return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
                case .spacer:
                    return collectionView.dequeueConfiguredReusableCell(using: spacerRegistration, for: indexPath, item: item)
                }

            })

            containerCollectionView.dataSource = dataSource
            containerCollectionView.translatesAutoresizingMaskIntoConstraints = false
            containerCollectionView.allowsSelection = false

            var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems([.header], toSection: .header)
            snapshot.appendItems(onboardingItems.map({ Item.onboarding($0) }), toSection: .main)
            snapshot.appendItems([.spacer], toSection: .spacer)
            snapshot.appendItems([.footer], toSection: .footer)
            dataSource.apply(snapshot, animatingDifferences: false)
        }

        func adjustSpacerToFit() {

            let footerHeight: CGFloat = footer?.bounds.size.height ?? 0

            let actualContentHeight = containerCollectionView.contentSize.height - spacerHeight
            if actualContentHeight >= bounds.size.height {
                spacerHeight = 0
            } else {
                let remainingSpaceHeight = bounds.size.height - actualContentHeight
                spacerHeight = remainingSpaceHeight - footerHeight
            }

            containerCollectionView.reloadData()

            let adjustedActualContentHeight = containerCollectionView.contentSize.height - spacerHeight
            containerCollectionView.isScrollEnabled = adjustedActualContentHeight >= bounds.size.height
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
            .font: UIFont.preferredFont(forTextStyle: .callout)
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
//                .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)

            })
            .ignoresSafeArea()
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
