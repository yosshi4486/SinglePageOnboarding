//
//  File.swift
//  
//
//  Created by yosshi4486 on 2021/08/02.
//

import UIKit

/// A item that represents an onboarding information about your app.
public struct OnboadingItem {

    /// The image that is positioned leading of the cell.
    public let image: UIImage

    /// The color of the image property.
    public let imageColor: UIColor?

    /// The title of the onbarding information.
    public let title: String

    /// The description of the onboarding information
    public let description: String

}

extension OnboadingItem: Hashable, Equatable { }

extension OnboadingItem: Identifiable {

    public var id: Int { hashValue }
    
}
