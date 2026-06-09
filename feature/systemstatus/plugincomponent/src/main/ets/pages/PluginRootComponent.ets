/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  CommonUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  PluginClickType,
  PluginComponentInfo,
  PluginIconType,
  PluginInfo,
  PluginLocalInfo,
  PluginPosition,
  PluginRequestEvent,
  PluginSlot,
  PluginType,
  PluginUpdateEvent,
  DeviceHelper,
  EventManager,
  EvtBus,
  AbsResourceManager as ResourceManager,
} from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { PluginStyle } from '../style/PluginStyle';
import { PluginIconBgListener } from '../listener/PluginIconBgListener';
import { PluginListenerManager } from '../listener/PluginListenerManager';
import { PluginVM } from '../vm/PluginVM';
import { ComponentAnimState, PropertyType } from '@ohos/systemuicommon';
import { PluginRootController } from '../controller/PluginRootController';
import { LengthMetrics } from '@kit.ArkUI';
// instrument ignore file
const TAG = 'PluginRootComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export const getPluginRootId = (pluginName: string): string => {
  return `${TAG}_Stack_${pluginName}`
}

/**
 * 自定义touch事件
 */
type CustomTouch = (event?: TouchEvent) => void;

/**
 * 插件渲染前回调
 */
type BeforeShowIconEvent = (slot: string, priority: number) => void;

/**
 * 注册插件实例
 */
type RegisterPluginEvent = (slot: string, context: PluginRootCompContext) => void;

/**
 * plugin组件，处理本地、远程plugin
 *
 * @since 2022-10-18
 */
@Component
export struct PluginRootComponent {
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  private onAreaChangeEvent: (oldValue: Area, newValue: Area) => void = (oldValue: Area, newValue: Area): void => {}
  @Prop pluginScaleX: number;
  @Prop pluginScaleY: number;

  @Prop pluginOpacity: number = 1;
  @State delayShowOpacity: number = 1;
  @State pluginVisibility: Visibility = Visibility.Visible;
  @Prop pluginDisplayPriority: number;
  @State pluginComponentWidthZero: boolean = false;

  /**
   * plugin数据信息
   */
  @State pluginInfo: PluginInfo | null = null;

  /**
   * 动效状态管理
   */
  @ObjectLink animState: ComponentAnimState;

  /**
   * plugin图标资源样式
   */
  pluginStyle: PluginStyle = new PluginStyle();
  /**
   * 背景相关事件监听管理器
   */
  bgListenerManager: PluginListenerManager<PluginIconBgListener> | null = null;

  /**
   * 本地图标组件
   */
  @BuilderParam
  localIconComponent?: (info: PluginLocalInfo, resourceMgr: ResourceManager | null) => void;

  /**
   * 图标可见性
   */
  @State isIconVisible: boolean = true;
  @State isIconSettingVisible: boolean = true;
  @Consume @Watch('refreshControllerStatusBarType') statusBarType: number;

  /**
   * 不显示的图标集
   */
  @Consume @Watch('onExcludeSlotListChange') excludeSlotList: string[];

  /**
   * 判断设备是否为折叠态（直板机状态为非折叠态）
   */
  @Consume isFolded: boolean;

  /**
   * 跨孔前隐藏，避免闪动
   */
  @State hiddenBeforeCrossCutout: boolean = false;
  /**
   * plugin图标唯一标示
   */
  private pluginSlot: string = '';
  /**
   * 资源管理
   */
  private resourceMgr: ResourceManager | null = null;
  /**
   * 触摸事件
   */
  private touchEvent: CustomTouch = () => {
  };
  /**
   * 插件渲染前事件回调
   */
  private beforeShowIcon: BeforeShowIconEvent = ()=> {}
  /**
   * 注册插件实例
   */
  private registerPluginEvent: RegisterPluginEvent = ()=> {}
  /**
   * 数据处理
   */
  private pluginVM: PluginVM = new PluginVM();
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private pluginRootController: PluginRootController | null = null;

  aboutToAppear(): void {
    this.pluginSlot = this.pluginInfo?.pluginParseInfo?.pluginSlot ?? '';
    log.showDebug(`aboutToAppear slot: ${this.pluginSlot} parsInfo click  ${this.pluginInfo?.pluginParseInfo?.clickInfo?.enableOperate}`);

    this.pluginRootController = new PluginRootController({
      slot: this.pluginSlot,
      statusBarType: this.statusBarType,
      callback: (isVisible) => {
        this.isIconSettingVisible = isVisible;
        if (this.isIconSettingVisible) {
          this.delayShowOpacity = 0;
          // 设置项改变，图标显示延迟、避免图标闪烁
          setTimeout(() => {
            this.delayShowOpacity = 1;
          }, 20)
        }
      }
    });

    this.pluginRootController.onStart();
    // 注册远程plugin push事件
    if (this.pluginInfo) {
      this.pluginVM.init(this.pluginInfo);
    }
    if (this.registerPluginEvent) {
      // 只有系统图标右侧区域和左侧区域涉及动态设置为隐藏状态
      if (this.pluginInfo?.pluginParseInfo.pluginPosition === PluginPosition.POSITION_RIGHT ||
        this.pluginInfo?.pluginParseInfo.pluginPosition === PluginPosition.POSITION_SYSTEM_LEFT) {
        this.registerPluginEvent(this.pluginSlot, this);
      }
    }
    // 注册plugin数据更新事件
    this.eventMgr.on(PluginUpdateEvent, this.onPluginUpdateEvent)
      // 注册plugin请求事件
      .on(PluginRequestEvent, this.onPluginRequestEvent, this.pluginSlot)
      // 注册远程plugin push事件
      .addOff(this.pluginVM.registerOnRemotePushListener(this.onRemotePushListener));
    this.onExcludeSlotListChange();
  }

  refreshControllerStatusBarType() {
    this.pluginRootController?.refreshWhenStatusBarChange(this.statusBarType);
  }

  aboutToDisappear(): void {
    log.showDebug(`aboutToDisappear slot: ${this.pluginSlot} parsInfo click  ${this.pluginInfo?.pluginParseInfo?.clickInfo?.enableOperate}`);
    // 注销背景监听
    if (this.bgListenerManager) {
      this.bgListenerManager.unregisterListener(this.pluginSlot);
    }
    this.pluginRootController?.onStop();
    // 注销事件
    this.eventMgr.offAll();
  }

  build() {
    // 图标不可见
    if (this.isShowIcon() && this.pluginInfo && this.localIconComponent) {
      Row() {
        this.localIconComponent(this.pluginInfo, this.resourceMgr)
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(this.isWidthAutoType() ? FlexAlign.Start : FlexAlign.Center)
      .key(this.pluginSlot)
      .id(getPluginRootId(this.pluginSlot))
      .width(this.getIconWidth())
      .height(this.pluginStyle?.iconHeight)
      .borderRadius(this.pluginStyle?.iconContainerRadius)
      // 动效期间不切割
      .clip(this.isClip())
      // 屏蔽事件，防止消费touch事件,状态胶囊自定义点击事件放开；enable为false时会影响屏幕朗读，所以在开启屏幕朗读时放开
      .enabled(this.pluginStyle?.iconEnable || this.checkEnabled() || this.isAccessibilityMode)
      .visibility(this.getIconVisibility())
      .margin({
        start: LengthMetrics.vp(0),
        end: LengthMetrics.px(Math.floor(vp2px(this.pluginStyle?.iconContainerRightMargin as number)))
      })
      .onTouch(this.touchEvent)
      // 胶囊出现、隐藏动效时，图标跟随位移
      .translate({
        x: this.getRootTranX()
      })
      .displayPriority(this.pluginDisplayPriority)
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.onAreaChangeEvent(oldValue, newValue);
        this.pluginComponentWidthZero = newValue.width <= 0;
      })
      .scale({ x: this.pluginScaleX, y: this.pluginScaleY } )
      .opacity(this.pluginOpacity * this.delayShowOpacity)
      .zIndex(this.getIconZIndex())
    }
  }

  private isShowIcon(): boolean {
    return !CommonUtils.isInvalid(this.pluginInfo) && this.getIconVisible() && this.getIconBuildVisible();
  }

  /**
   * 获取图标可见性标记，定位图标这里均设置为可见，通过getIconVisibility中Visible.None进行隐藏，提升创建性能。
   *
   * @returns 返回当前图标是否可见
   */
  private getIconVisible(): boolean {
    if (this.pluginSlot === PluginSlot.SLOT_STATUS_LOCATION) {
      return true;
    }
    return this.isIconVisible;
  }

  /**
   * 非通知图标使用if隐藏，通知图标使用Visible.hidden隐藏，避免重新渲染
   * @returns
   */
  private getIconBuildVisible() {
    if (this.pluginSlot === PluginSlot.SLOT_STATUS_NOTIFICATION) {
      return true;
    }
    return this.isIconSettingVisible;
  }

  private getIconZIndex(): number {
    if (this.pluginSlot === PluginSlot.LIVE_VIEW_CAPSULE) {
      return 1;
    }
    return 0;
  }

  /**
   * 图标是否显示
   */
  private onExcludeSlotListChange(): void {
    this.pluginVisibility = this.excludeSlotList.includes(this.pluginSlot) ? Visibility.None : Visibility.Visible;
  }

  private getIconVisibility() {
    let visibleState = Visibility.Visible;
    let visibleReason: string = 'default';
    if (this.pluginVisibility != Visibility.Visible) {
      visibleState = this.pluginVisibility;
      visibleReason = 'pluginVisibility';
    } else if (this.pluginSlot === PluginSlot.SLOT_STATUS_LOCATION && !this.isIconVisible) {
      visibleState = Visibility.None;
      visibleReason = 'pluginLocationVisibilityNone';
    } else if (this.pluginComponentWidthZero) {
      visibleState = Visibility.Hidden;
      visibleReason = 'pluginComponentWidthZero';
    } else if (this.pluginSlot === PluginSlot.SLOT_STATUS_NOTIFICATION) {
      visibleState = this.isIconSettingVisible ? Visibility.Visible : Visibility.Hidden;
      visibleReason = 'notification';
    } else if (this.hiddenBeforeCrossCutout) {
      // 跨孔渲染前先设置为不展示，避免图标跨孔闪动
      visibleState = Visibility.Hidden;
      visibleReason = 'hiddenBeforeCrossCutout';
    }
    return visibleState;
  }

  /**
   * 是否切割组件
   *
   * @returns true切割
   */
  private isClip(): boolean {
    // 默认切割
    if (CommonUtils.isInvalid(this.animState)) {
      return true;
    }
    return this.animState.isClipComponent();
  }

  /**
   * 获取横向位移偏量
   *
   * @returns 位移偏量
   */
  private getRootTranX(): number {
    return this.animState?.getPropertyValue(PropertyType.TRAN_X) ?? 0;
  }

  /**
   * 远程push事件回调
   *
   * @param info 数据
   */
  private onRemotePushListener = (info: PluginComponentInfo): void => {
    log.showInfo(`onRemotePushListener ${info}`);
    // 图标可见性控制
    if (this.isIconVisible != info?.requestVisible) {
      this.isIconVisible = info?.requestVisible;
    }
  }

  /**
   * plugin图标请求事件回调
   *
   * @param event 事件
   */
  private onPluginRequestEvent = (event: PluginRequestEvent): void => {
    if (event.pluginSlot != this.pluginSlot) {
      return;
    }
    // 图标可见性事件
    if (event.requestType == PluginRequestEvent.REQUEST_TYPE_VISIBILITY) {
      // 更新可见性
      if (this.isIconVisible != event.isVisible()) {
        log.showWarn('onPluginRequestEvent slot: ' + event.pluginSlot + ', visible: ' + event.isVisible());
        if (event.isVisible()) {
          // 图标渲染前计算系统图标区域是否可以放的下，如果放不下，提前把最后的图标移入左侧区域，避免闪动
          if (this.pluginInfo?.pluginParseInfo.pluginPosition === PluginPosition.POSITION_RIGHT) {
            this.beforeShowIcon(this.pluginSlot, this.pluginInfo.pluginParseInfo.pluginPriority)
          }
        }
        this.isIconVisible = event.isVisible();
      }
    }
  }

  /**
   * 更新plugin数据事件回调
   *
   * @param event 事件
   */
  private onPluginUpdateEvent = (event: PluginUpdateEvent): void => {
    log.showInfo('onPluginUpdateEvent slot: ' + event.newInfo?.pluginParseInfo?.pluginSlot + ', ori: ' + this.pluginSlot);
    // 更新数据
    if (this.pluginInfo && event.newInfo?.equals(this.pluginInfo)) {
      this.pluginInfo = event.newInfo;
      // 刷新VM数据
      this.pluginVM?.init(event.newInfo);
      log.showInfo(`onPluginUpdateEvent: ${this.statusBarType}`);
    }
  }

  /**
   * 获取图标宽度
   *
   * @return 图标宽度
   */
  private getIconWidth(): Length | undefined {
    // 非自适应宽度图标，直接取固定值
    if (!this.isWidthAutoType()) {
      return ResUtils.getNumberFromLength(this.pluginStyle?.iconWidth);
    }

    // 手机图标宽度自适应
    return undefined;
  }

  /**
   * 是否为宽度自适应
   *
   * @return 是否宽度自适应
   */
  private isWidthAutoType(): boolean {
    let iconType = this.pluginInfo?.pluginParseInfo?.pluginIconType;
    return iconType == PluginIconType.TYPE_AUTO_ICON;
  }

  private checkEnabled(): boolean {
    if (!this.pluginInfo) {
      log.showError('checkEnabled pluginInfo is invalid');
      return false;
    }
    const parseInfo = this.pluginInfo?.pluginParseInfo;
    return PluginType.isPluginType(parseInfo?.pluginType) &&
      (parseInfo?.clickInfo?.clickType === PluginClickType.TYPE_CUSTOM ||
      parseInfo?.rightClickInfo?.clickType === PluginClickType.TYPE_CUSTOM) ||
      parseInfo?.clickInfo?.enableOperate === 'true';
  }
}

export interface PluginRootCompContext {
  hiddenBeforeCrossCutout: boolean
}
