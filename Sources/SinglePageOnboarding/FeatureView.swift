//
//  FeatureView.swift
//  
//
//  Created by yosshi4486 on 2021/08/06.
//

import UIKit

final class FeatureView: UIView {

    var item: OnboadingFeatureItem? {
        didSet {
            titleLabel.text = item?.title
            descriptionLabel.text = item?.description
            imageView.image = item?.image
            imageView.tintColor = item?.imageColor
            imageSize = item?.imageSize ?? .init(width: 30, height: 30)
            containerStack.spacing = item?.spacingBetweenImageAndContentView ?? 8
        }
    }

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
