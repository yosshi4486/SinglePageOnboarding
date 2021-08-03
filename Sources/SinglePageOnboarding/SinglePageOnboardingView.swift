//
//  SwiftUIView.swift
//  
//
//  Created by yosshi4486 on 2021/08/02.
//

import SwiftUI

public struct SinglePageOnboardingView: View {

    public let title: String

    public let onboardingItems: [OnboadingItem]

    public let orderedFooterContents: [OnboardingFooterContent]?

    public let buttonTitle: String

    public let accentColor: UIColor = .systemBlue

    public let onCommit: () -> Void

    public var body: some View {

        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)

            ForEach(onboardingItems) { onboardingItem in
                HStack {
                    Image(uiImage: onboardingItem.image)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 35, height: 30)
                        .padding(.trailing)
                        .foregroundColor(onboardingItem.imageColor == nil ? nil : Color(onboardingItem.imageColor!))
                    

                    VStack(alignment: .leading, spacing: 3) {
                        Text(onboardingItem.title)
                            .font(.body)
                            .foregroundColor(.primary)
                            .bold()

                        Text(onboardingItem.description)
                            .font(.body)
                            .foregroundColor(.secondary)

                    }
                }
                .padding(.bottom)
            }

            Spacer()

            VStack {

                if let orderedFooterContents = self.orderedFooterContents {
                    FooterContentTextView(orderedFooterContents: orderedFooterContents)
                }

                Button(action: onCommit) {
                    Text(buttonTitle)
                        .foregroundColor(Color.white)
                        .bold()
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color(accentColor))
                .cornerRadius(10)

            }
            .padding(.bottom, 30)

        }
        .padding(.horizontal, 30)

    }

}

private struct FooterContentTextView: UIViewRepresentable {

    typealias UIViewType = UITextView

    let orderedFooterContents: [OnboardingFooterContent]

    func makeUIView(context: Context) -> UITextView {
        let uiView = UITextView()
        uiView.isEditable = false
        uiView.isSelectable = true
        uiView.isScrollEnabled = false
        uiView.isUserInteractionEnabled = true
        uiView.delegate = context.coordinator
        uiView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        uiView.setContentHuggingPriority(.required, for: .vertical)

        let baseFooterText = orderedFooterContents.map({ $0.textValue }).joined()
        let attributedString = NSMutableAttributedString(string: baseFooterText, attributes: [
            .foregroundColor: UIColor.label,
            .font: UIFont.preferredFont(forTextStyle: .callout)
        ])

        for orderedFooterContent in orderedFooterContents {
            if case .link(let text, let url) = orderedFooterContent {
                attributedString.addAttribute(.link,
                                              value: url.absoluteString,
                                              range: NSString(string: baseFooterText).range(of: text)
                )
            }
        }
        uiView.attributedText = attributedString

        return uiView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        // Static
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, UITextViewDelegate {

        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            UIApplication.shared.open(URL)
            return false
        }

    }

}

struct SinglePageOnboardingView_Previews: PreviewProvider {

    static var previews: some View {
        SinglePageOnboardingView(
            title: "What's New",
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
    }

}
