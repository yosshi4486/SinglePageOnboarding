# SinglePageOnboarding

This package provides single page onboarding view controller that it is easy to provide onboarding experience.

## Usage

Use *Single Page Onboarding View Controller* to configure single page onboarding content. After configuring the single page onboarding controller with the feature items and action, present it using the `present(_:animated:completion:)` method. UIKit displays onboarding content modaly over your app's content.

```swift
let onboarding = SinglePageOnboardingController(
    title: "Welcome to My App!",
    featureItems: [
        OnboadingFeatureItem(
            title: "More Personalized",
            description: "Top Stories picked for you and recommendations from Siri.",
            image: UIImage(systemName: "heart.fill")!
        )
    ],
    action: OnboardingAction(
        title: "Agree and Continue",
        handler: { action in
            // Do something, such as storing flag in `UserDefaults`.
        }
    )
)

self.present(onboarding, animated: true, completion: nil)
```


Also, please check sample project that is located here:
https://github.com/yosshi4486/SinglePageOnboarding/blob/05d3847e26b54de15b3edb591df130268178724a/Samples/SampleOnboarding/SampleOnboarding/ViewController.swift#L19-L69


## Installation

Install this package from url(https://github.com/yosshi4486/SinglePageOnboarding) via swift package manager.

## Contribution

I'm looking forward for your issues or pull requests😊 

Specifically...

### Word corrections
I'm not native english language speaker, some sentences may have miss.

### Better implementation
Since the internal implementations of this package is quite tricky, I want to refine them.
