# SETUP

Install needed dependencies

```console
flutter pug get
```

## IOS

### health

#### Enable HealthKit Capability in Xcode

```console
open ios/Runner.xcworkspace
```

- Select the Runner project in the Navigator (left sidebar).
- Under Signing & Capabilities, click on the + Capability button.
- Search for HealthKit and add it to your project.

#### Modify Info.plist for permissions for HealthKit

```xml
<key>NSHealthUpdateUsageDescription</key>
<string>Your app needs health update permissions to work.</string>
<key>NSHealthShareUsageDescription</key>
<string>Your app needs health sharing permissions to work.</string>
```
