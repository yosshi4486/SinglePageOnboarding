//
//  OnbarodingView.swift
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
class OnbarodingView: UIView {

    enum Section: Int, CaseIterable {
        case header
        case main
        case footer
    }

    enum Item: Hashable {
        case header
        case footer
        case onboarding(OnboadingFeatureItem)
    }

    var title: String?

    var featureItems: [OnboadingFeatureItem]

    var action: OnboardingAction? {
        didSet {
            footerView.button.setTitle(action?.title, for: .normal)
            footerView.button.backgroundColor = tintColor
            footerView.button.addAction(UIAction(handler: { [weak self] _ in
                guard let onboardingAction = self?.action else {
                    return
                }

                onboardingAction.handler(onboardingAction)
            }), for: .touchUpInside)
        }
    }

    var footerAttributedString: NSAttributedString? {
        didSet {
            footerView.textView.attributedText = footerAttributedString
        }
    }

    weak var footerTextViewDelegate: UITextViewDelegate? {
        didSet {
            footerView.textView.delegate = footerTextViewDelegate
        }
    }

    var spaceBetweenEachFeatureItem: CGFloat = 30

    private let containerCollectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    private let footerView: FooterView = FooterView(frame: .zero)

    public init(title: String?, featureItems: [OnboadingFeatureItem]) {
        self.title = title
        self.featureItems = featureItems

        super.init(frame: .zero)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupConstraints()
        setupDiffableDataSource()
        applyInitialData()
    }

    private func setupConstraints() {
        layoutMargins.left = 50
        layoutMargins.right = 50

        containerCollectionView.preservesSuperviewLayoutMargins = true
        footerView.preservesSuperviewLayoutMargins = true

        addSubview(containerCollectionView)
        addSubview(footerView)

        footerView.translatesAutoresizingMaskIntoConstraints = false
        containerCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerCollectionView.topAnchor.constraint(equalTo: topAnchor),
            containerCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 0),
            footerView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupDiffableDataSource() {

        let cellRegistration = UICollectionView.CellRegistration<FeatureCell, Item> { [weak self] cell, indexPath, item in
            if case .onboarding(let onboardingItem) = item {
                cell.titleLabel.text = onboardingItem.title
                cell.descriptionLabel.text = onboardingItem.description
                cell.imageView.image = onboardingItem.image
                cell.imageView.tintColor = onboardingItem.imageColor ?? self?.tintColor
                cell.imageSize = onboardingItem.imageSize
                cell.spaceBetweenItem = self?.spaceBetweenEachFeatureItem ?? 30
                cell.containerStack.spacing = onboardingItem.spacingBetweenImageAndContentView
            }
        }

        let headerRegistration = UICollectionView.CellRegistration<HeaderCell, Item> { [weak self] cell, indexPath, item in
            cell.titleLabel.text = self?.title
        }

        let footerRegistration = UICollectionView.CellRegistration<FooterCell, Item> { [weak self] cell, indexPath, item in
            cell.textView.attributedText = self?.footerAttributedString
            cell.textView.delegate = self?.footerTextViewDelegate
            cell.button.setTitle(self?.action?.title, for: .normal)
            cell.button.backgroundColor = self?.tintColor
            cell.button.addAction(UIAction(handler: { _ in
                guard let onboardingAction = self?.action else {
                    return
                }

                onboardingAction.handler(onboardingAction)
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
        containerCollectionView.allowsSelection = false
    }

    private func applyInitialData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([.header], toSection: .header)
        snapshot.appendItems(featureItems.map({ Item.onboarding($0) }), toSection: .main)
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

        /*
         To stabilize behavior, adding a stabilizer height to actual content height.

         Use footer view if the space is larger than double footer height, otherwise use collectionview's footer cell.
         */
        let stabilizer = footerHeight
        actualContentHeight += stabilizer

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
