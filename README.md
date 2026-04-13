# scene_board

- [scene\_board]
    - [简介](#简介)
    - [目录](#目录)
    - [约束](#约束)
    - [相关仓](#相关仓)

## 简介
**SceneBoard** 是窗口子系统的部件之一，是基于窗口合一架构构建的窗口管理框架和桌面环境的集合，也是用户与系统交互的入口。包含了：
1. 通过系统窗口控件实现的桌面相关的系统应用，例如：壁纸、桌面、多任务、应用中心、锁屏等。
2. 基于屏幕控件和窗口控件的窗口管理框架，提供了 `ScreenScene` 和 `ScreenSession`、 `WindowScene` 和 `SceneSession` 控件来管理屏幕控件和屏幕会话、窗口控件和窗口会话。

### SceneBoard
![部件关系](./docs/figures/SceneBoard.png)

SceneBoard是一个三层架构，分别是：
- `common`：基础设施，例如日志系统、设备工具以及跨产品公共依赖模块。

- `feature`：特性模块，包含了跨产品可复用的特性，例如多任务、应用中心、锁屏、异源虚拟屏等。

- `product`：产品层，是将 `common` 和 `feature` 打包集成的上层模块，包含了`ServiceExtensionAbility`入口，编排整个产品入口和系统窗口的层级排列规则。

最终，SceneBoard会将这些模块打包成一个**hap**包。

## 目录
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

## 编译
`SceneBoard` 是窗口子系统的部件之一，有以下两种方式进行编译：
1. 仅编译`SceneBoard`:
```
./build.sh --product-name {product_name} --build-target SceneBoard --ccache 
```

2. 编译全部系统组件：
```
./build.sh --product-name {product_name} --ccache
```

## 约束
- 语言版本
    - ArkTS

## 相关仓
- [window_manager](https://gitcode.com/openharmony/window_window_manager)
- [window_scene](https://gitcode.com/openharmony/window_scene)
- [arkui_ace_engine](https://gitcode.com/openharmony/arkui_ace_engine)