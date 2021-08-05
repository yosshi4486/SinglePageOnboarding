//
//  ViewController.swift
//  SampleOnboarding
//
//  Created by yosshi4486 on 2021/08/04.
//

import UIKit
import SinglePageOnboarding

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let onboarding = SinglePageOnboardingController(
            title: "Welcome to My App!",
            featureItems: [
                OnboadingFeatureItem(
                    title: "More Personalized",
                    description: "Top Stories picked for you and recommendations from Siri.",
                    image: UIImage(systemName: "heart.fill")!,
                    imageColor: UIColor.systemPink
                ),
                OnboadingFeatureItem(
                    title: "New Articles Tab",
                    description: "Discover latest articles.",
                    image: UIImage(systemName: "newspaper")!,
                    imageColor: UIColor.systemRed
                ),
                OnboadingFeatureItem(
                    title: "Watch Video News",
                    description: "You can now watch video news in Video News Tab.",
                    image: UIImage(systemName: "play.rectangle.fill")!,
                    imageColor: UIColor.blue
                ),
            ]
        )
        onboarding.action = OnboardingAction(
            title: "Agree and Continue",
            handler: { action in
                UserDefaults.standard.set(true, forKey: "agreeTermsOfUsesAndPrivacyPolicy")
                onboarding.dismiss(animated: true, completion: nil)
            }
        )

        let baseFooterText = NSLocalizedString("Please read and agree terms of use and privacy policy.", comment: "")
        let attributedString = NSMutableAttributedString(string: baseFooterText, attributes: [
            .foregroundColor: UIColor.label,
            .font: UIFont.preferredFont(forTextStyle: .body)
        ])

        attributedString.addAttribute(.link,
                                      value: "https://github.com/yosshi4486/SinglePageOnboarding",
                                      range: NSString(string: baseFooterText).range(of: NSLocalizedString("terms of use", comment: "")))
        attributedString.addAttribute(.link,
                                      value: "https://github.com/yosshi4486/SinglePageOnboarding",
                                      range: NSString(string: baseFooterText).range(of: NSLocalizedString("privacy policy", comment: "")))

        onboarding.footerAttributedString = attributedString
        onboarding.footerTextViewDelegate = self

        self.present(onboarding, animated: true, completion: nil)
    }

}

extension ViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }

}
