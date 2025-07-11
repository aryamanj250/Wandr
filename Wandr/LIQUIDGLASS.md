Here is the documentation, properly formatted and organized into a clear, hierarchical structure.

***

# Adopting Liquid Glass

Find out how to bring the new material to your app.

## Overview

If you have an existing app, adopting Liquid Glass doesn’t mean reinventing your app from the ground up. Start by building your app in the latest version of Xcode to see the changes. As you review your app, use the following sections to understand the scope of changes and learn how you can adopt these best practices in your interface.

[Image: A Mac, iPad, and iPhone showing the Mount Fuji landmark in the Landmarks app.]

### See your app with Liquid Glass

If your app uses standard components from SwiftUI, UIKit, or AppKit, your interface picks up the latest look and feel on the latest platform releases for iOS, iPadOS, macOS, tvOS, and watchOS. In Xcode, build your app with the latest SDKs, and run it on the latest platform releases to see the changes in your interface.

## Visual Refresh

Interfaces across Apple platforms feature a new dynamic material called Liquid Glass, which combines the optical properties of glass with a sense of fluidity. This material forms a distinct functional layer for controls and navigation elements. It affects how the interface looks, feels, and moves, adapting in response to a variety of factors to help bring focus to the underlying content.

*   **Leverage system frameworks to adopt Liquid Glass automatically.** In system frameworks, standard components like bars, sheets, popovers, and controls automatically adopt this material. System frameworks also dynamically adapt these components in response to factors like element overlap and focus state. Take advantage of this material with minimal code by using standard components from SwiftUI, UIKit, and AppKit.

*   **Reduce your use of custom backgrounds in controls and navigation elements.** Any custom backgrounds and appearances you use in these elements might overlay or interfere with Liquid Glass or other effects that the system provides, such as the scroll edge effect. Make sure to check any custom backgrounds in elements like split views, tab bars, and toolbars. Prefer to remove custom effects and let the system determine the background appearance, especially for the following elements:

| SwiftUI               | UIKit | AppKit    |
| --------------------- | ----- | --------- |
| `NavigationStack`     |       | `titleBar`|
| `NavigationSplitView` |       |           |
| `toolbar(content:)`   |       |           |

*   **Test your interface with accessibility settings.** Translucency and fluid morphing animations contribute to the look and feel of Liquid Glass, but can adapt to people’s needs. For example, people might turn on accessibility settings that reduce transparency or motion in the interface, which can remove or modify certain effects. If you use standard components from system frameworks, this experience adapts automatically. Ensure your custom elements and animations provide a good fallback experience when these settings are on as well.

*   **Avoid overusing Liquid Glass effects.** If you apply Liquid Glass effects to a custom control, do so sparingly. Liquid Glass seeks to bring attention to the underlying content, and overusing this material in multiple custom controls can provide a subpar user experience by distracting from that content. Limit these effects to the most important functional elements in your app. To learn more, read [Applying Liquid Glass to custom views](#applying-liquid-glass-to-custom-views).

| SwiftUI                          | UIKit | AppKit |
| -------------------------------- | ----- | ------ |
| `glassEffect(_:in:isEnabled:)`    |       |        |


## App Icons

App icons take on a design that’s dynamic and expressive. Updates to the icon grid result in a standardized iconography that’s visually consistent across devices and concentric with hardware and other elements across the system. App icons now contain layers, which dynamically respond to lighting and other visual effects the system provides. iOS, iPadOS, and macOS all now offer default (light), dark, clear, and tinted appearance variants, empowering people to personalize the look and feel of their Home Screen.

[Image: A grid showing the Podcasts app icon in the six style variants: default, dark, clear (light), clear (dark), tinted (light), and tinted (dark).]

### Reimagine your app icon for Liquid Glass
Apply key design principles to help your app icon shine:

*   Provide a visually consistent, optically balanced design across the platforms your app supports.
*   Consider a simplified design comprised of solid, filled, overlapping semi-transparent shapes.
*   Let the system handle applying masking, blurring, and other visual effects, rather than factoring them into your design.

| [Image: The Podcasts app icon in iOS 18 using the light style.]<br>_Podcasts icon in iOS 18_ | [Image: The Podcasts app icon in iOS using the default style, shown before applying system effects. The design of the icon uses solid filled shapes instead of outlines, and multiple layers of varying opacity.]<br>_Reimagined layered Podcasts icon_ | [Image: The Podcasts app icon in iOS using the default style, shown with system effects applied.]<br>_Reimagined layered Podcasts icon with system effects applied_ |
| :---: | :---: | :---: |

*   **Design using layers.** The system automatically applies effects like reflection, refraction, shadow, blur, and highlights to your icon layers. Determine which elements of your design make sense as foreground, middle, and background elements, then define separate layers for them. You can perform this task in the design app of your choice.

*   **Compose and preview in Icon Composer.** Drag and drop app icon layers that you export from your design app directly into the Icon Composer app. Icon Composer lets you add a background, create layer groupings, adjust layer attributes like opacity, and preview your design with system effects and appearances. Icon Composer is available in the latest version of Xcode and for download from Apple Design Resources. To learn more, read *Creating your app icon using Icon Composer*.

    [Image: A screenshot of the Icon Composer app showing the Podcasts app icon in the default style.]

*   **Preview against the updated grids.** The system applies masking to produce your final icon shape — rounded rectangle for iOS, iPadOS, and macOS, and circular for watchOS. Keep elements centered to avoid clipping. Irregularly shaped icons receive a system-provided background. See how your app icon looks with the updated grids to determine whether you need to make adjustments. Download these grids from Apple Design Resources.

## Controls

Controls have a refreshed look across platforms, and come to life when a person interacts with them. For controls like sliders and toggles, the knob transforms into Liquid Glass during interaction, and buttons fluidly morph into menus and popovers. The shape of the hardware informs the curvature of controls, so many controls adopt rounder forms to elegantly nestle into the corners of windows and displays. Controls also feature an option for an extra-large size, allowing more space for labels and accents.

| [Animation: A slider knob transforming into Liquid Glass during interaction.]<br>_Slider_ | [Animation: A segmented control morphing fluidly during interaction.]<br>_Segmented control_ |
| :---: | :---: |

*   **Review updates to control appearance and dimensions.** If you use standard controls from system frameworks, your app adopts changes to shapes and sizes automatically when you rebuild your app with the latest version of Xcode. Review changes to the following controls and any others and make sure they continue to look at home with the rest of your interface:

| SwiftUI     | UIKit | AppKit |
| ----------- | ----- | ------ |
| `Button`    |       |        |
| `Toggle`    |       |        |
| `Slider`    |       |        |
| `Stepper`   |       |        |
| `Picker`    |       |        |
| `TextField` |       |        |

*   **Review your use of color in controls.** Be judicious with your use of color in controls and navigation so they stay legible and keep the focus on your content. If you do apply color to these elements, leverage system colors to automatically adapt to light and dark contexts.
*   **Check for crowding or overlapping of controls.** Allow Liquid Glass room to move and breathe, and avoid overcrowding or layering elements on top of each other.

## Navigation

Liquid Glass applies to the topmost layer of the interface, where you define your navigation. Key navigation elements like tab bars and sidebars float in this Liquid Glass layer to help people focus on the underlying content.

| [Image: The bottom half of an iPhone showing a tab bar as it appears in iOS 18 and earlier.]<br>_Before_ | [Image: The bottom half of an iPhone showing a tab bar as it appears in the latest version of iOS. The search tab appears in its own section at the trailing end of the tab bar.]<br>_After_ |
| :---: | :---: |

*   **Establish a clear navigation hierarchy.** It’s more important than ever for your app to have a clear and consistent navigation structure that’s distinct from the content you provide. Ensure that you clearly separate your content from navigation elements, like tab bars and sidebars, to establish a distinct functional layer above the content layer.

*   **Consider adapting your tab bar into a sidebar automatically.** If your app uses a tab-based navigation, you can allow the tab bar to adapt into a sidebar depending on the context by using the following APIs:

| SwiftUI            | UIKit | AppKit |
| ------------------ | ----- | ------ |
| `sidebarAdaptable` |       |        |

*   **Consider using split views to build sidebar layouts with an inspector panel.** Split views are optimized to create a consistent and familiar experience for sidebar and inspector layouts across platforms. You can use the following standard system APIs for split views to build these types of layouts with minimal code:

| SwiftUI                           | UIKit | AppKit |
| --------------------------------- | ----- | ------ |
| `NavigationSplitView`             |       |        |
| `inspector(isPresented:content:)` |       |        |

*   **Check content safe areas for sidebars and inspectors.** If you have these types of components in your app’s navigation structure, audit the safe area compatibility of content next to the sidebar and inspector to help make sure underlying content is peeking through appropriately.

*   **Extend content beneath sidebars and inspectors.** A background extension effect creates a sense of extending a background under a sidebar or inspector, without actually scrolling or placing content under it. This effect mirrors the adjacent content to give the impression of stretching it under the sidebar, and applies a blur to maintain legibility. This effect is perfect for creating a full, edge-to-edge content experience in apps that use split views.

| [Image: The Landmarks app showing the sidebar. The image next to the sidebar doesn't extend beneath it.]<br>_Without background extension effect_ | [Image: The Landmarks app showing the sidebar. The image next to the sidebar gives the impression of extending beneath it.]<br>_With background extension effect_ |
| :---: | :---: |

| SwiftUI                       | UIKit | AppKit |
| ----------------------------- | ----- | ------ |
| `backgroundExtensionEffect()` |       |        |

*   **Choose whether to automatically minimize your tab bar in iOS.** Tab bars can help elevate the underlying content by receding when a person scrolls. You can opt into this behavior and configure the tab bar to minimize when a person scrolls down or up.
    ```swift
    TabView {
        // ...
    }
    .tabBarMinimizeBehavior(.onScrollDown)
    ```

## Menus and Toolbars

Menus have a refreshed look, adopting Liquid Glass and using icons for common actions to help people scan them quickly. New to iPadOS, apps also have a menu bar for faster access to common commands.

*   **Adopt standard icons in menu items.** For menu items that perform standard actions like Cut, Copy, and Paste, the system uses the menu item’s selector to determine which icon to apply. To adopt icons in those menu items with minimal code, make sure to use standard selectors.
*   **Match top menu actions to swipe actions.** For consistency and predictability, make sure the actions you surface at the top of your contextual menu match the swipe actions you provide for the same item.

Toolbars take on a Liquid Glass appearance and provide a grouping mechanism for toolbar items, letting you choose which actions to display together.

| [Image: The bottom half of an iPhone showing a toolbar as it appears in iOS 18 and earlier.]<br>_Before_ | [Image: The bottom half of an iPhone showing a toolbar as it appears in the latest version of iOS.]<br>_After_ |
| :---: | :---: |

*   **Determine which toolbar items to group together.** Group items that perform similar actions or affect the same part of the interface, and maintain consistent groupings and placement across platforms.

| [Image: A toolbar with four buttons that all share a background: Undo, Redo, Markup, and More.]<br>_Incorrect_ | [Image: A toolbar with the four buttons split into two groupings. The Undo and Redo buttons share a background, and the Markup and More buttons share a background.]<br>_Correct_ |
| :---: | :---: |

You can create a fixed spacer to separate items that share a background using these APIs:

| SwiftUI         | UIKit           | AppKit |
| --------------- | --------------- | ------ |
| `ToolbarSpacer` | `.fixed`        |        |

*   **Find icons to represent common actions.** Consider representing common actions in toolbars with standard icons instead of text. For consistency, don’t mix text and icons across items that share a background.
*   **Provide an accessibility label for every icon.** Always specify an accessibility label for each icon so that people who prefer text can enable it with features like VoiceOver.
*   **Audit toolbar customizations.** Review custom implementations in your toolbars, like your use of fixed spacers or custom items, as these can appear inconsistent with system behavior.
*   **Check how you hide toolbar items.** If you see an empty toolbar item, your app might be hiding the view inside the item instead of the item itself. Instead, hide the entire toolbar item using these APIs:

| SwiftUI     | UIKit | AppKit |
| ----------- | ----- | ------ |
| `hidden(_:)`|       |        |

## Windows and Modals

Windows adopt rounder corners to fit controls and navigation elements. In iPadOS, apps show window controls and support continuous window resizing down to a minimum size.

*   **Support arbitrary window sizes.** Allow people to resize their window to the width and height that works for them, and adjust your content accordingly.
*   **Use split views to allow fluid resizing of columns.** To support continuous window resizing, split views automatically reflow content for every size using fluid transitions. Use standard system APIs for split views to get these animations automatically:

| SwiftUI               | UIKit | AppKit |
| --------------------- | ----- | ------ |
| `NavigationSplitView` |       |        |

*   **Use layout guides and safe areas.** Specify safe areas for your content so the system can automatically adjust the window controls and title bar in relation to your content.

Modal views like sheets and action sheets adopt Liquid Glass. Sheets feature an increased corner radius, and half sheets are inset from the edge of the display to allow content to peek through from beneath. An action sheet now originates from the element that initiates it.

*   **Check the content around the edges of sheets.** Inside the sheet, check for content that might appear too close to the rounder corners. Outside the sheet, check that any peeking content looks as you expect.
*   **Audit the backgrounds of sheets and popovers.** Remove any custom visual effect views you've added to popover content views to provide a consistent experience.
*   **Specify the source of an action sheet.** Position an action sheet’s anchor next to the control it originates from to create the inline appearance.

| SwiftUI                                                               | UIKit | AppKit |
| --------------------------------------------------------------------- | ----- | ------ |
| `confirmationDialog(_:isPresented:titleVisibility:presenting:actions:)`|       |        |

## Organization and Layout

Style updates to list-based layouts help you organize and showcase your content. To give content room to breathe, organizational components like lists, tables, and forms have a larger row height and padding. Sections have an increased corner radius to match the curvature of controls.

| [Image: An iPhone showing a grouped list layout as it appears in iOS 18 and earlier.]<br>_Before_ | [Image: An iPhone showing a grouped list layout as it appears in the latest version of iOS.]<br>_After_ |
| :---: | :---: |

*   **Check capitalization in section headers.** Lists, tables, and forms now use title-style capitalization for section headers. Update your section headers to match this systemwide convention.
*   **Adopt forms to take advantage of layout metrics across platforms.** Use SwiftUI forms with the `grouped` form style to automatically update your form layouts.

## Search

Platform conventions for the location and behavior of search are optimized for each device. Review these conventions to provide an engaging search experience.

| [Image: An iPad showing search in a toolbar in the upper trailing corner.]<br>_Search in a toolbar on iPad_ | [Image: An iPhone showing search in a toolbar at the bottom of the screen.]<br>_Search in a toolbar on iPhone_ |
| :---: | :---: |

*   **Check the keyboard layout when activating your search interface.** In iOS, when a person taps a search field, it slides upwards as the keyboard appears. Test this experience in your app for consistency.
*   **Use semantic search tabs.** If your app’s search appears as part of a tab bar, use the standard system APIs for indicating the search tab. The system automatically separates it and places it at the trailing end.

| SwiftUI                   | UIKit | AppKit |
| ------------------------- | ----- | ------ |
| `Tab(role: .search)`      |       |        |

## Platform Considerations

Liquid Glass can have a distinct appearance and behavior across different platforms, contexts, and input methods.

*   **Test your app across devices** to understand how the material looks and feels across platforms.
*   **In watchOS, adopt standard button styles and toolbar APIs.** Liquid Glass changes are minimal in watchOS and appear automatically on the latest release. However, to ensure your app picks up this appearance, adopt standard toolbar APIs and button styles from watchOS 10.
*   **Combine custom Liquid Glass effects to improve rendering performance.** If you apply these effects to custom elements, combine them using a `GlassEffectContainer` to optimize performance while fluidly morphing shapes.
*   **Performance test your app across platforms.** Building with the latest SDKs is a good opportunity to profile your app and find opportunities for improvement. To learn more, read *Improving your app’s performance*.
*   To update and ship your app with the latest SDKs while keeping its existing appearance, you can add the `UIDesignRequiresCompatibility` key to your information property list.

***

# Applying Liquid Glass to Custom Views

Configure, combine, and morph views using Liquid Glass effects.

### Overview

Interfaces across Apple platforms feature a new dynamic material called Liquid Glass. It blurs content behind it, reflects the color and light of surrounding content, and reacts to interactions in real time. While standard SwiftUI components use Liquid Glass automatically, you can adopt it on custom components to move, combine, and morph them with unique animations and transitions.

[Image: The Landmarks sample code on iPad, showing the Mount Fuji landmark.]

To learn more, see *Landmarks: Building an app with Liquid Glass*.

### Apply and configure Liquid Glass effects

Use the `glassEffect(_:in:isEnabled:)` modifier to add Liquid Glass effects to a view. You can configure the effect with different shapes, tint colors, and interactivity.

[Animation: Three examples of "Hello, World!" text with different glass effects applied.]

```swift
// Default capsule shape
Text("Hello, World!")
    .font(.title)
    .padding()
    .glassEffect()

// Custom rounded rectangle shape
Text("Hello, World!")
    .font(.title)
    .padding()
    .glassEffect(in: .rect(cornerRadius: 16.0))

// Tinted and interactive
Text("Hello, World!")
    .font(.title)
    .padding()
    .glassEffect(.regular.tint(.orange).interactive())
```

### Combine multiple views with Liquid Glass containers

Use `GlassEffectContainer` when applying Liquid Glass effects on multiple views to achieve the best rendering performance and to allow the views to blend their shapes together.

In the example below, the Liquid Glass effects of the two images begin to blend as they are placed close to each other.

[Image: A scribble symbol and an eraser symbol with their Liquid Glass effects merging.]

```swift
GlassEffectContainer(spacing: 40.0) {
    HStack(spacing: 40.0) {
        Image(systemName: "scribble.variable")
            .frame(width: 80.0, height: 80.0)
            .font(.system(size: 36))
            .glassEffect()

        Image(systemName: "eraser.fill")
            .frame(width: 80.0, height: 80.0)
            .font(.system(size: 36))
            .glassEffect()
            // An `offset` shows how effects react to each other
            .offset(x: -40.0, y: 0.0)
    }
}
```

To contribute multiple views to a single effect capsule, use the `glassEffectUnion(id:namespace:)` modifier.

[Image: Four symbols grouped into two pairs, with each pair encapsulated in a single Liquid Glass effect.]

```swift
let symbolSet: [String] = ["cloud.bolt.rain.fill", "sun.rain.fill", "moon.stars.fill", "moon.fill"]
@Namespace private var namespace

GlassEffectContainer(spacing: 20.0) {
    HStack(spacing: 20.0) {
        ForEach(symbolSet.indices, id: \.self) { item in
            Image(systemName: symbolSet[item])
                .frame(width: 80.0, height: 80.0)
                .font(.system(size: 36))
                .glassEffect()
                .glassEffectUnion(id: item < 2 ? "1" : "2", namespace: namespace)
        }
    }
}
```

### Morph Liquid Glass effects during transitions

Morphing effects occur during transitions between views inside a `GlassEffectContainer`. Use the `glassEffectID(_:in:)` modifier to associate each effect with a unique identifier.

[Animation: An eraser image morphs into a pencil image as a toggle is pressed.]

```swift
@State private var isExpanded: Bool = false
@Namespace private var namespace

var body: some View {
    VStack {
        GlassEffectContainer(spacing: 40.0) {
            HStack(spacing: 40.0) {
                Image(systemName: "scribble.variable")
                    .frame(width: 80.0, height: 80.0)
                    .font(.system(size: 36))
                    .glassEffect()
                    .glassEffectID("pencil", in: namespace)

                if isExpanded {
                    Image(systemName: "eraser.fill")
                        .frame(width: 80.0, height: 80.0)
                        .font(.system(size: 36))
                        .glassEffect()
                        .glassEffectID("eraser", in: namespace)
                }
            }
        }

        Button("Toggle") {
            withAnimation {
                isExpanded.toggle()
            }
        }
        .buttonStyle(.glass)
    }
}
```

***

# API Reference

> **Beta Software**
>
> This documentation contains preliminary information about an API or technology in development. This information is subject to change, and software implemented according to this documentation should be tested with final operating system software.

### `glassEffect(_:in:isEnabled:)`
Applies the Liquid Glass effect to a view.

**Declaration**
```swift
func glassEffect(
    _ glass: Glass = .regular,
    in shape: some Shape = .capsule,
    isEnabled: Bool = true
) -> some View
```

**Availability**
*   iOS 26.0+ Beta
*   iPadOS 26.0+ Beta
*   macOS 26.0+ Beta
*   tvOS 26.0+ Beta
*   watchOS 26.0+ Beta
*   Mac Catalyst 26.0+ Beta

**Discussion**
When you use this effect, the system renders a shape with the Liquid Glass material anchored behind a view and applies its foreground effects over the view.

```swift
Text("Hello, World!")
    .font(.title)
    .padding()
    .glassEffect()
```

### `interactive(_:)`
Returns a copy of the structure configured to be interactive.

**Declaration**
```swift
func interactive(_ isEnabled: Bool = true) -> Glass
```

**Availability**
*   iOS 26.0+ Beta
*   iPadOS 26.0+ Beta
*   macOS 26.0+ Beta
*   tvOS 26.0+ Beta
*   watchOS 26.0+ Beta
*   visionOS 26.0+ Beta
*   Mac Catalyst 26.0+ Beta

### `GlassEffectContainer`
A view that combines multiple Liquid Glass shapes into a single shape that can morph individual shapes into one another.

**Declaration**
```swift
@MainActor @preconcurrency
struct GlassEffectContainer<Content> where Content : View
```

**Availability**
*   iOS 26.0+ Beta
*   iPadOS 26.0+ Beta
*   macOS 26.0+ Beta
*   tvOS 26.0+ Beta
*   watchOS 26.0+ Beta
*   Mac Catalyst 26.0+ Beta

**Overview**
Use a container with the `glassEffect(_:in:isEnabled:)` modifier. Each view with a Liquid Glass effect contributes a shape to a set. SwiftUI renders the effects together, improving performance and allowing them to interact.

### `GlassEffectTransition`
A structure that describes changes to apply when a glass effect is added or removed from the view hierarchy.

**Declaration**
```swift
struct GlassEffectTransition
```

**Availability**
*   iOS 26.0+ Beta
*   iPadOS 26.0+ Beta
*   macOS 26.0+ Beta
*   tvOS 26.0+ Beta
*   watchOS 26.0+ Beta
*   visionOS 26.0+ Beta
*   Mac Catalyst 26.0+ Beta

### `GlassButtonStyle`
A button style that applies glass border artwork based on the button’s context.

**Declaration**
```swift
struct GlassButtonStyle
```

**Availability**
*   iOS 26.0+ Beta
*   iPadOS 26.0+ Beta
*   macOS 26.0+ Beta
*   tvOS 26.0+ Beta
*   watchOS 26.0+ Beta
*   visionOS 26.0+ Beta
*   Mac Catalyst 26.0+ Beta
