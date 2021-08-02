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

    public let buttonTitle: String

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

            Button(action: onCommit) {
                Text(buttonTitle)
                    .foregroundColor(.white)
                    .bold()
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(Color.blue)
            .cornerRadius(10)

        }
        .padding(.horizontal, 30)

    }

}

struct SinglePageOnboardingView_Previews: PreviewProvider {

    static var previews: some View {
        SinglePageOnboardingView(title: "What's New", onboardingItems: [
            
            OnboadingItem(image: UIImage(systemName: "heart.fill")!, imageColor: UIColor.systemPink, title: "More Personalized", description: "Top Stories picked for you and recommendations from Siri."),
            OnboadingItem(image: UIImage(systemName: "newspaper")!, imageColor: UIColor.systemRed, title: "New Articles Tab", description: "Discover latest articles."),
            OnboadingItem(image: UIImage(systemName: "play.rectangle.fill")!.withTintColor(.systemBlue, renderingMode: .alwaysTemplate), imageColor: UIColor.blue, title: "Watch Video News", description: "You can now watch video news in Video News Tab."),
        ],
        buttonTitle: "Next", onCommit: { })
    }
    
}
