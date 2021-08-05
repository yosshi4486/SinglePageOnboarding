//
//  SinglePageOnbarodingUIKitView.swift
//  
//
//  Created by yosshi4486 on 2021/08/05.
//

import UIKit

/// A internal view that manages onboarding.
///
/// # The Reasons to Use UICollectionLayoutListConfiguration
///
/// Onboarding View should adopt dynamic type and adaptive layout, but implementing them by UIStackView, or some plane views are very troublesome.
/// UICollectionView with UICollectionLayoutListConfiguration make it easy to implement adaptive onboarding view.
///
///
class SinglePageOnbarodingUIKitView: UIView {

    private enum Section: Int, CaseIterable {
        case header
        case main
        case footer
    }

    private enum Item: Hashable {
        case header
        case footer
        case onboarding(OnboadingItem)
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

    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    private let footerView: FooterView = FooterView(frame: .zero)

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
        footerView.preservesSuperviewLayoutMargins = true

        addSubview(containerCollectionView)
        containerCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerCollectionView.topAnchor.constraint(equalTo: topAnchor),
            containerCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        let cellRegistration = UICollectionView.CellRegistration<OnboardingCell, Item> { [weak self] cell, indexPath, item in
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

        let headerRegistration = UICollectionView.CellRegistration<HeaderCell, Item> { [weak self] cell, indexPath, item in
            cell.titleLabel.text = self?.onboardingTitle
        }

        let footerRegistration = UICollectionView.CellRegistration<FooterCell, Item> { [weak self] cell, indexPath, item in
            cell.textView.attributedText = self?.footerAttributedString
            cell.button.setTitle(self?.buttonTitle, for: .normal)
            cell.button.backgroundColor = self?.accentColor ?? .systemBlue
            cell.button.addAction(UIAction(handler: { _ in
                self?.onCommit()
            }), for: .touchUpInside)
        }

        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: containerCollectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .header:
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: item)
            case .footer:
                return collectionView.dequeueConfiguredReusableCell(using: footerRegistration, for: indexPath, item: item)
            case .onboarding(_):
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }

        })

        containerCollectionView.dataSource = dataSource
        containerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        containerCollectionView.allowsSelection = false

        addSubview(footerView)
        footerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0),
            footerView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        footerView.textView.attributedText = footerAttributedString
        footerView.button.setTitle(buttonTitle, for: .normal)
        footerView.button.backgroundColor = accentColor ?? .systemBlue
        footerView.button.addAction(UIAction(handler: { [weak self] _ in
            self?.onCommit()
        }), for: .touchUpInside)

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([.header], toSection: .header)
        snapshot.appendItems(onboardingItems.map({ Item.onboarding($0) }), toSection: .main)
        snapshot.appendItems([.footer], toSection: .footer)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        /*
         This call may cause recursive call of `layoutSubviews()`, but only once.
         Once the appropriate footer is determined, the method will not make any changes, so the recursive call will stop.
         */
        useAppropriateFooterRespectingForActualContentSize()
    }

    func useAppropriateFooterRespectingForActualContentSize() {
        let footerHeight = footerView.bounds.size.height
        var actualContentHeight = containerCollectionView.contentSize.height
        var currentSnapshot = dataSource.snapshot(for: .footer)

        if currentSnapshot.visibleItems.count == 0 {
            actualContentHeight += footerHeight
        }

        if actualContentHeight >= bounds.size.height {
            footerView.isHidden = true

            if currentSnapshot.visibleItems.count == 0 {
                currentSnapshot.append([.footer])
            }

            containerCollectionView.isScrollEnabled = true

        } else {
            footerView.isHidden = false

            if currentSnapshot.visibleItems.count > 0 {
                currentSnapshot.delete([.footer])
            }

            containerCollectionView.isScrollEnabled = false
        }

        // Apply changes only if some differences are recognized.
        if currentSnapshot.visibleItems != dataSource.snapshot(for: .footer).visibleItems {
            dataSource.apply(currentSnapshot, to: .footer, animatingDifferences: false)
        }

    }

}
