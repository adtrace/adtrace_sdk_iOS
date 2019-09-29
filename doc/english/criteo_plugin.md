## Criteo plugin

Integrate adjust with Criteo events by following one of these methods:

### CocoaPods

If you're using [CocoaPods](http://cocoapods.org/), you can add the following line to your Podfile:

```ruby
pod 'Adjust/Criteo'
```

### Carthage

If you're using [Carthage](https://github.com/Carthage/Carthage), you can add following line to your Cartfile:

```ruby
github "adjust/ios_sdk" "criteo"
```

### Source

You can also integrate adjust with Criteo events by following these steps:

1. Locate the `plugin/Criteo` folder inside the downloaded archive from our [releases page](https://github.com/adjust/ios_sdk/releases).

2. Drag the `ADJCriteo.h` and `ADJCriteo.m` files into the `Adjust` folder inside your project.

3. In the dialog `Choose options for adding these files` make sure to check the checkbox
to `Copy items if needed` and select the radio button to `Create groups`.

### Criteo events
Now you can integrate each of the different Criteo events, like in the following examples:

#### View Listing

```objc
#import "ADJCriteo.h"

ADJEvent *event = [ADJEvent eventWithEventToken:@"{viewListingEventToken}"];

NSArray *productIds = @[@"productId1", @"productId2", @"product3"];

[ADJCriteo injectViewListingIntoEvent:event productIds:productIds];

[Adjust trackEvent:event];
```

#### View Product

```objc
#import "ADJCriteo.h"

ADJEvent *event = [ADJEvent eventWithEventToken:@"{viewProductEventToken}"];

[ADJCriteo injectViewProductIntoEvent:event productId:@"productId1"];

[Adjust trackEvent:event];
```

#### Cart

```objc
#import "ADJCriteo.h"

ADJEvent *event = [ADJEvent eventWithEventToken:@"{cartEventToken}"];

ADJCriteoProduct *product1 = [ADJCriteoProduct productWithId:@"productId1" price:100.0 quantity:1];
ADJCriteoProduct *product2 = [ADJCriteoProduct productWithId:@"productId2" price:77.7 quantity:3];
ADJCriteoProduct *product3 = [ADJCriteoProduct productWithId:@"productId3" price:50 quantity:2];
NSArray *products = @[product1, product2, product3];

[ADJCriteo injectCartIntoEvent:event products:products];

[Adjust trackEvent:event];
```

#### Transaction confirmation

```objc
#import "ADJCriteo.h"

ADJEvent *event = [ADJEvent eventWithEventToken:@"{transactionConfirmedEventToken}"];

ADJCriteoProduct *product1 = [ADJCriteoProduct productWithId:@"productId1" price:100.0 quantity:1];
ADJCriteoProduct *product2 = [ADJCriteoProduct productWithId:@"productId2" price:77.7 quantity:3];
ADJCriteoProduct *product3 = [ADJCriteoProduct productWithId:@"productId3" price:50 quantity:2];
NSArray *products = @[product1, product2, product3];

[ADJCriteo injectTransactionConfirmedIntoEvent:event products:products 
  transactionId:@"transactionId1" newCustomer:@"newCustomerId"];

[Adjust trackEvent:event];
```

#### User Level

```objc
#import "ADJCriteo.h"

ADJEvent *event = [ADJEvent eventWithEventToken:@"{userLevelEventToken}"];

[ADJCriteo injectUserLevelIntoEvent:event uiLevel:1];

[Adjust trackEvent:event];
```

#### User Status

```objc
#import "ADJCriteo.h"

ADJEvent *event = [ADJEvent eventWithEventToken:@"{userStatusEventToken}"];

[ADJCriteo injectUserStatusIntoEvent:event uiStatus:@"uiStatusValue"];

[Adjust trackEvent:event];
```

#### Achievement Unlocked

```objc
#import "ADJCriteo.h"

ADJEvent *event = [ADJEvent eventWithEventToken:@"{achievementUnlockedEventToken}"];

[ADJCriteo injectAchievementUnlockedIntoEvent:event uiAchievement:@"uiAchievementValue"];

[Adjust trackEvent:event];
```

#### Custom Event

```objc
#import "ADJCriteo.h"

ADJEvent *event = [ADJEvent eventWithEventToken:@"{customEventEventToken}"];

[ADJCriteo injectCustomEventIntoEvent:event uiData:@"uiDataValue"];

[Adjust trackEvent:event];
```

#### Custom Event 2

```objc
#import "ADJCriteo.h"

ADJEvent *event = [ADJEvent eventWithEventToken:@"{customEvent2EventToken}"];

[ADJCriteo injectCustomEvent2IntoEvent:event uiData2:@"uiDataValue2" uiData3:3];

[Adjust trackEvent:event];
```

#### Hashed Email

It's possible to attach an hashed email in every Criteo event with the `injectHashedEmailIntoCriteoEvents` method.
The hashed email will be sent with every Criteo event for the duration of the application lifecycle,
so it must be set again when the app is re-lauched.
The hashed email can be removed by setting the `injectHashedEmailIntoCriteoEvents` value with `nil`.

```objc
#import "ADJCriteo.h"

[ADJCriteo injectHashedEmailIntoCriteoEvents:@"8455938a1db5c475a87d76edacb6284e"];
```

#### Search dates

It's possible to attach a check-in and check-out date to every Criteo event with the `injectViewSearchDatesIntoCriteoEvent` method. The dates will be sent with every Criteo event for the duration of the application lifecycle, so it must be set again when the app is re-lauched.

The search dates can be removed by setting the `injectViewSearchDatesIntoCriteoEvents` values with `nil`.

```objc
#import "ADJCriteo.h"

[ADJCriteo injectViewSearchDatesIntoCriteoEvents:@"2015-01-01" checkOutDate:@"2015-01-07"];
```

#### Partner id

It's possible to attach a partner id to every Criteo event with the `injectPartnerIdIntoCriteoEvent` method. The partner id will be sent with every Criteo event for the duration of the application lifecycle, so it must be set again when the app is re-lauched.

The search dates can be removed by setting the `injectPartnerIdIntoCriteoEvent` value with `nil`.

```objc
#import "ADJCriteo.h"

[ADJCriteo injectPartnerIdIntoCriteoEvents:@"{criteoPartnerId}"];
```

#### Send deeplink

In the Project Navigator open the source file your Application Delegate. Find or add the method openURL and add the following call to adjust:

```objc
#import "ADJCriteo.h"

- (BOOL)  application:(UIApplication *)application openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    ADJEvent *event = [ADJEvent eventWithEventToken:@"{deeplinkEventToken}"];
    
    [ADJCriteo injectDeeplinkIntoEvent:event url:url];
    
    [Adjust trackEvent:event];

    //...
}
```

#### Customer ID

It's possible to attach the customer ID to every Criteo event with the `injectCustomerIdIntoCriteoEvents` method. The customer ID will be sent with every Criteo event for the duration of the application life cycle, so it must be set again when the app is re-launched.

The customer ID can be removed by setting the `injectCustomerIdIntoCriteoEvents` value to `nil`.

```objc
#import "ADJCriteo.h"

[ADJCriteo injectCustomerIdIntoCriteoEvents:@"{CriteoCustomerId}"];

```

#### User Segment

It's possible to attach the user segment to every Criteo event with the `injectUserSegmentIntoCriteoEvents` method. The user segment will be sent with every Criteo event for the duration of the application life cycle, so it must be set again when the app is re-launched.

The user segment can be removed by setting the `injectUserSegmentIntoCriteoEvents` value to `nil`.

```objc
#import "ADJCriteo.h"

[ADJCriteo injectUserSegmentIntoCriteoEvents:@"{CriteoUserSegment}"];
```
