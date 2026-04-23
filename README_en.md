# scene_board

- [scene_board](#scene_board)
  - [Introduction](#introduction)
  - [Architecture Overview](#architecture-overview)
  - [Module Breakdown](#module-breakdown)
  - [Development Steps](#development-steps)
  - [Directory](#directory)
  - [Build](#build)
  - [Constraints](#constraints)
  - [Related Repositories](#related-repositories)

## Introduction
**SceneBoard** is the desktop and window component management in the OpenHarmony window subsystem. It not only carries desktop-related system applications, but also serves as the integration entry point for window management and screen management capabilities on different products.

In terms of responsibilities, SceneBoard provides capabilities for three types of consumers:
1. It provides a unified SceneBoard integration entry for product modules. Different products can assemble differentiated capabilities through the `ServiceExtensionAbility`, page entry, and product base modules in the `product` layer.
2. It provides a unified system window host container for desktop-related system applications, enabling integration of desktop features such as wallpaper, desktop, status bar, lock screen, app center, and recent tasks.
3. It provides screen and window orchestration for upper-layer logic in the window subsystem. Based on session objects such as `ScreenSession`, `SceneSession`, and `SystemSceneSession`, it manages instances, lifecycles, hierarchy, and event dispatching.

### Core Capabilities
1. Window management
  - Manages application main windows, subwindows, system windows, and their container relationships.
  - Maintains window hierarchy, focus, rotation, animation, restoration, drag behavior, and layout orchestration.
  - Supports scenarios such as normal window mode, freeform window mode, and split screen.
2. Screen management
  - Manages screen instances such as the primary screen, extended screens, and virtual screens, as well as their lifecycles.
  - Detects changes to screen size, rotation, mode switching, connection and disconnection, and synchronizes them to window panels.
  - Mounts the corresponding system scenes and window containers for different screens.
3. System window management
  - Hosts system UI such as wallpaper, desktop, status bar, lock screen, notifications, and Dock as system windows.
  - Uses unified window session management to bring system UI and application windows into the same window-control management framework.
4. Product integration
  - Provides entry capabilities in product modules such as `phone`, `pad`, and `pc`.

## Architecture Overview
SceneBoard is a layered framework that spans foundational session management to product integration. It connects screen management, window management for both system windows and application windows, and product-level entry points, and is ultimately packaged as a deployable HAP program for product-side use.
![Component Relationship](./docs/figures/SceneBoard.png)

SceneBoard adopts a three-layer architecture: common capability layer, feature layer, and product layer.

1. Common capability layer
  - Provides foundational capabilities such as logging, constants, utilities, framework wrappers, and window session management.
  - Among them, `staticcommon/basecommon/windowscene` is the core common module for window and screen management. It exposes capabilities such as `SCBSceneSessionManager`, `SCBScreenSessionManager`, `SCBSceneSession`, `SCBScreenSession`, `SCBSystemSceneSession`, and `StartAbilityUtil`.

2. Feature layer
  - Centered on `feature`, encapsulating reusable capabilities across products, including desktop and window-related features.

3. Product layer
  - Centered on `product`, currently supporting the three product types `phone`, `pad`, and `pc`.
  - Assembles the common layer and feature layer into concrete product forms, with `ServiceExtensionAbility` as the entry point.

Collaboration flow:

```text
Product entry (ServiceExtensionAbility)
  -> Load the SceneBoard page and context
  -> Initialize SCBSceneSessionManager / SCBScreenSessionManager
  -> Build the primary-screen SCBScreen control and load other screens such as extended screens and virtual screens as needed
  -> Load the application window panel (SCBScenePanel), and mount different desktop-related system window controls (SCBSystemScene) on demand
  -> Uniformly handle screen changes, window scheduling, hierarchy management, and product-specific logic
```

In implementation, SceneBoard is organized around the session model of the window subsystem:
1. `SCBScreenSession` manages screen instances and properties.
2. `SCBSceneSession` manages the lifecycle of a single application window instance.
3. `SCBSystemSceneSession` manages system windows such as wallpaper, status bar, and lock screen.
4. `SCBSceneSessionManager` is responsible for global window events, hierarchy, containers, and callback dispatching.
5. `SCBScreenSessionManager` is responsible for screen property changes, screen rotation, and panel synchronization.

For more details about the relationship between window and screen sessions, see [docs/SceneBoard中的窗口.md](./docs/SceneBoard中的窗口.md).

## Module Breakdown
The table below lists the core modules in this repository that are directly related to SceneBoard and their responsibilities.

| Module | Main Responsibility |
| --- | --- |
| `AppScope` | Manages application-level resources, configuration, and multilingual resources. |
| `basecommon` | Base common package that exposes shared capability entry points. |
| `staticcommon/basecommon/basicutils` | Basic capabilities such as logging, tasks, and utility classes. |
| `staticcommon/basecommon/commonconstants` | Shared constants and system constraint definitions. |
| `staticcommon/basecommon/windowscene` | Core foundational capabilities such as window/screen sessions, system scenes, containers, and launch helpers. |
| `feature/commonscbscreen` | Common heterogeneous virtual-screen management, providing a general application window panel. |
| `feature/pcmode` | Freeform windows, layout policies, window animations, and panel management for PC mode. |
| `product/phone` | Integration entry for phone products. |
| `product/pad` | Integration entry for tablet products. |
| `product/pc` | Integration entry for PC products. |
| `scripts` / `hvigor` | Build, synchronization, and engineering scripts. |

### Module Collaboration
1. `windowscene` provides foundational abstractions and global managers, serving as the capability base for all upper-layer modules.
2. `commonscbscreen` builds on `windowscene` to encapsulate a general heterogeneous virtual-screen management framework and provides plug-and-play screen containers for products.
3. `pcmode` extends `windowscene` with capabilities such as freeform windows, split screen, and PC mode, and provides advanced window management policies for the product layer.
4. `phonebase` and `pcbase` define their respective `SCBScreen` implementations, system windows, hierarchy rules, and interaction logic on top of the common capabilities.
5. `phone`, `pad`, and `pc` are the final integration layer. They launch SceneBoard through `ServiceExtensionAbility` and connect the base screen implementation.

## Development Steps

### Add a New Product
Applicable scenario: a new custom product needs to be added with differentiated capabilities.

Implementation approach:
1. Add a new product HAP module under `product` and implement the `ServiceExtensionAbility` entry.
2. Integrate the required feature modules and common modules in `oh-package.json5` as needed.
3. Mount `SCBScreen` through `RootScene` on the `ServiceExtensionAbility` ArkUI page.

The current `phone`, `pad`, and `pc` products all use this entry pattern.

### Customize the SCBScreen Control
Applicable scenario: product-specific system windows, hierarchy rules, gesture handling, or animation logic need to be added.

Implementation approach:
1. Extend from [product/phonebase/src/main/ets/SceneBoard/scenemanager/SCBScreen.ets](product/phonebase/src/main/ets/SceneBoard/scenemanager/SCBScreen.ets) or [product/pcbase/src/main/ets/SceneBoard/scenemanager/SCBScreen.ets](product/pcbase/src/main/ets/SceneBoard/scenemanager/SCBScreen.ets) as the baseline.
2. In the custom `SCBScreen`, maintain the product's own `SCBScreenProperty`, screen rotation handling, system scene builders, and panel mount order.
3. Register system windows such as wallpaper, desktop, status bar, Dock, notifications, and lock screen according to product needs.
4. Define the collaboration rules between system windows and application windows by setting panel z-index values, callbacks, and the `ScenePanel` list.

```ts
@Component
export struct SCBScreen {
  build() {
    // Mount level-0 system windows under the SCBScreen screen space in hierarchy order.
    Screen(this.screenSession.session.screenId) {
      // Customize different system windows on demand to provide UI.
      SCBWallpaper()

      // ScenePanel
      SCBScenePanel({ screenProperty: $scbScreenProperty })

      // ...
    }
  }
}
```

### Development Recommendations
1. When customizing, prefer reusing existing capabilities such as `SCBSceneSessionManager`, `SCBScreenSessionManager`, and common panels instead of bypassing the global session managers to maintain window state independently.
2. `SCBScenePanel` and `SCBSpecificScenePanel` are mandatory application window container panels that must be implemented in screen controls; otherwise the APIs cannot respond correctly.

## Directory
```text
scene_board
├─AppScope                           # Resources, multilingual assets, and application-level configuration
├─basecommon                         # Base common package entry
├─feature                            # Cross-product reusable feature layer
│  ├─commonscbscreen                 # Common screen and window panel template
│  └─pcmode                          # PC mode, freeform windows, and split-screen capabilities
├─product                            # Product integration layer
│  ├─pad                             # Tablet product module
│  ├─pc                              # PC product module
│  ├─pcbase                          # PC product base capabilities
│  ├─phone                           # Phone product module
│  └─phonebase                       # Base capabilities for phone/tablet products
├─scripts                            # Build and helper scripts
├─staticcommon                       # Static common capability layer
│  └─basecommon                      # Shared library collection related to window scenes
└─hvigor                             # Project build scripts
```

## Build
`SceneBoard` is one of the components in the window subsystem. It can be built in the following two ways:

1. Build only `SceneBoard`

```bash
./build.sh --product-name {product_name} --build-target SceneBoard --ccache
```

2. Build all system components

```bash
./build.sh --product-name {product_name} --ccache
```

## Constraints
- Language version: ArkTS
- Build dependencies:
  - The `window_use_scene_board` feature switch must be `true`, which means the unified window-and-scene architecture is enabled.
  - `scene_board_core` is a build-time component dependency.

## Related Repositories
- [window_manager](https://gitcode.com/openharmony/window_window_manager)
- [scene_board_core](https://gitcode.com/openharmony/scene_board_core)
- [arkui_ace_engine](https://gitcode.com/openharmony/arkui_ace_engine)