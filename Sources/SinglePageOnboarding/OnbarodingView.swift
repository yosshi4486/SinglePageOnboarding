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

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var featureItems: [OnboadingFeatureItem] {
        didSet {

        }
    }

    var action: OnboardingAction? {
        didSet {
            scrollableFooterView.button.setTitle(action?.title, for: .normal)
            scrollableFooterView.button.backgroundColor = tintColor
            scrollableFooterView.button.addAction(UIAction(handler: { [weak self] _ in
                guard let onboardingAction = self?.action else {
                    return
                }

                onboardingAction.handler(onboardingAction)
            }), for: .touchUpInside)

            containerChildFooterView.button.setTitle(action?.title, for: .normal)
            containerChildFooterView.button.backgroundColor = tintColor
            containerChildFooterView.button.addAction(UIAction(handler: { [weak self] _ in
                guard let onboardingAction = self?.action else {
                    return
                }

                onboardingAction.handler(onboardingAction)
            }), for: .touchUpInside)

        }
    }

    var footerAttributedString: NSAttributedString? {
        didSet {
            scrollableFooterView.textView.attributedText = footerAttributedString
            containerChildFooterView.textView.attributedText = footerAttributedString
        }
    }

    weak var footerTextViewDelegate: UITextViewDelegate? {
        didSet {
            scrollableFooterView.textView.delegate = footerTextViewDelegate
            containerChildFooterView.textView.delegate = footerTextViewDelegate
        }
    }

    var spaceBetweenEachFeatureItem: CGFloat = 30

    private let scrollView: UIScrollView = .init()

    private let contentView: UIView = .init()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .largeTitle).bold()
        label.textAlignment = .center
        return label
    }()

    let topFeature: FeatureView = .init()

    let midFeature: FeatureView = .init()

    let bottomFeature: FeatureView = .init()

    let scrollableFooterView = FooterView()

    let containerChildFooterView = FooterView()

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
        applyInitialData()
    }

    private func setupConstraints() {

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topFeature.translatesAutoresizingMaskIntoConstraints = false
        midFeature.translatesAutoresizingMaskIntoConstraints = false
        bottomFeature.translatesAutoresizingMaskIntoConstraints = false
        scrollableFooterView.translatesAutoresizingMaskIntoConstraints = false
        containerChildFooterView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)
        addSubview(containerChildFooterView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(topFeature)
        contentView.addSubview(midFeature)
        contentView.addSubview(bottomFeature)
        contentView.addSubview(scrollableFooterView)

        NSLayoutConstraint.activate([
            /*
             ScrollVIew
             */
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            /*
             ContentView
             */
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            /*
             Views
             */
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            topFeature.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            topFeature.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            topFeature.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            midFeature.topAnchor.constraint(equalTo: topFeature.bottomAnchor, constant: 30),
            midFeature.leadingAnchor.constraint(equalTo: topFeature.leadingAnchor),
            midFeature.trailingAnchor.constraint(equalTo: topFeature.trailingAnchor),
            bottomFeature.topAnchor.constraint(equalTo: midFeature.bottomAnchor, constant: 30),
            bottomFeature.leadingAnchor.constraint(equalTo: midFeature.leadingAnchor),
            bottomFeature.trailingAnchor.constraint(equalTo: midFeature.trailingAnchor),
            scrollableFooterView.topAnchor.constraint(greaterThanOrEqualTo: bottomFeature.bottomAnchor, constant: 30),
            scrollableFooterView.leadingAnchor.constraint(equalTo: bottomFeature.leadingAnchor),
            scrollableFooterView.trailingAnchor.constraint(equalTo: bottomFeature.trailingAnchor),
            scrollableFooterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            /*
             Container Child Footer View
             */
            containerChildFooterView.leadingAnchor.constraint(equalTo: bottomFeature.leadingAnchor),
            containerChildFooterView.trailingAnchor.constraint(equalTo: bottomFeature.trailingAnchor),
            containerChildFooterView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])

    }

    private func applyInitialData() {
        backgroundColor = .systemBackground

        titleLabel.text = title

        topFeature.item = featureItems[0]
        midFeature.item = featureItems[1]
        bottomFeature.item = featureItems[2]

    }

    func switchToAppropriateFooterViewRespectingForContentSize() {
        if scrollView.contentSize.height >= bounds.height {
            containerChildFooterView.isHidden = true
            scrollableFooterView.isHidden = false
        } else {
            containerChildFooterView.isHidden = false
            scrollableFooterView.isHidden = true
        }
    }

}
