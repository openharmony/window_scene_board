# scene_board

- [scene\_board]
    - [Description](#Description)
    - [目录](#目录)
    - [约束](#约束)
    - [相关仓](#相关仓)

## Description
**SceneBoard** is one part of the window subsystem. It is a collection of a window management framework and desktop environment built based on the unified architecture, and it serves as the entry point for users to interact with the system. It includes:
1. Desktop related system APPs implemented through system window scenes, such as wallpapers, desktops, multitasking, application center, and lock screen, etc.
2. A window management framework based on screen and window components, providing `ScreenScene` and `ScreenSession`, `WindowScene` and `SceneSession` controls to manage screen scene and screen sessions, window scene and window sessions.

### SceneBoard
![部件关系](./docs/figures/SceneBoard.png)

SceneBoard is a three-layer architecture, which consists of the following:
- `common`：Infrastructure, such as log systems, equipment tools, and cross-product common dependency modules.

- `feature`：The feature module contains reusable features across different products, such as multitasking, application center, lock screen, heterogeneous virtual screens, etc.

- `product`：The product layer is the upper-level module that integrates `common` and `feature`. It includes the `ServiceExtensionAbility` entry point and arranges the hierarchical arrangement rules for the entire product entry and system window.

Ultimately, SceneBoard will package these modules into a **.hap** package.

## Directory

```
scene_board
├─AppScope
│  └─resources        # resources
├─docs                # documents for scene_board
├─features            # feature layer
│  ├─appcenter        # app center 
│  ├─appinstall       # app install guidance 
│  ├─commonscbscreen  # common virtual screen 
│  └─pcmode           # window pc mode
├─product             # product layer
│  ├─pad              # Tablet product integration
│  ├─pc               # PC product integration
│  ├─pcbase           # product infrastructure for PC
│  ├─phone            # Phone product integration
│  └─phone            # product infrastructure for phones and tablets
├─hvigor              # hivigor build scripts
├─signature           # signature
└─staticcommon        # common layer
```

## Build
`SceneBoard` is a component of window system. There are two optional ways to build:
1. only build `SceneBoard` component:
```
./build.sh --product-name {product_name} --build-target SceneBoard --ccache 
```

2. build product：
```
./build.sh --product-name {product_name} --ccache
```

## Constraints
- language
    - ArkTS

## Repositories Involved
- [window_manager](https://gitcode.com/openharmony/window_window_manager)
- [window_scene](https://gitcode.com/openharmony/window_scene)
- [arkui_ace_engine](https://gitcode.com/openharmony/arkui_ace_engine)