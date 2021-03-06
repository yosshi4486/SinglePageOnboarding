# SinglePageOnboarding

This package provides single page onboarding view controller that it is easy to provide onboarding experience.

<p align="center">
  <img width="400" height="757" src="./Resources/ScreenShot.png">
</p>

## Usage

Use *Single Page Onboarding View Controller* to configure single page onboarding content. After configuring the single page onboarding controller with the feature items and action, present it using the `present(_:animated:completion:)` method. UIKit displays onboarding content modaly over your app's content.

```swift
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
        )
    ]
)

onboarding.action = OnboardingAction(
    title: "Agree and Continue",
    handler: { action in
        onboarding.dismiss(animated: true, completion: nil)
    }
)

self.present(onboarding, animated: true, completion: nil)
```


Also, please check sample project that is located here:
https://github.com/yosshi4486/SinglePageOnboarding/blob/05d3847e26b54de15b3edb591df130268178724a/Samples/SampleOnboarding/SampleOnboarding/ViewController.swift#L19-L69


## Installation

Install this package from url(https://github.com/yosshi4486/SinglePageOnboarding) via swift package manager.

## Contribution

I'm looking forward for your issues or pull requests???? 

Specifically...

### Word corrections
I'm not native english language speaker, some sentences may have miss.
