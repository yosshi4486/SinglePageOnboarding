//
//  File.swift
//  
//
//  Created by yosshi4486 on 2021/08/02.
//

import UIKit

/// A item that represents an onboarding information about your app.
public struct OnboadingFeatureItem {

    /// The image that is positioned leading of the cell.
    public let image: UIImage

    /// The color of the image.
    public let imageColor: UIColor?

    /// The size of the image.
    public let imageSize: CGSize

    /// The trailing space of the image.
    public let spacingBetweenImageAndContentView: CGFloat

    /// The title of the onbarding information.
    public let title: String

    /// The description of the onboarding information
    public let description: String

    public init(title: String, description: String, image: UIImage, imageColor: UIColor? = nil, imageSize: CGSize = .init(width: 40, height: 35), spacingBetweenImageAndContentView: CGFloat = 15) {
        self.title = title
        self.description = description
        self.image = image
        self.imageSize = imageSize
        self.imageColor = imageColor
        self.spacingBetweenImageAndContentView = spacingBetweenImageAndContentView
    }

}

extension CGSize: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }

}

extension OnboadingFeatureItem: Hashable, Equatable { }

extension OnboadingFeatureItem: Identifiable {

    public var id: Int { hashValue }
    
}
