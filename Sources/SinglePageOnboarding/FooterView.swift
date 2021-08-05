//
//  FooterView.swift
//  
//
//  Created by yosshi4486 on 2021/08/05.
//

import UIKit

final class FooterView: UIView {

    var textView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isSelectable = true
        view.isUserInteractionEnabled = true
        view.isScrollEnabled = false
        view.adjustsFontForContentSizeCategory = true
        return view
    }()

    var button: UIButton = {
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
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor)
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
