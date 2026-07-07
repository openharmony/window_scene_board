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

import { LengthMetrics } from '@ohos.arkui.node';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { WindowConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { HiSysEventUtil, PluginSlot, WindowEvent } from '@ohos/frameworkwrapper';
import { AnimManager, AnimProperty } from '@ohos/statusbarcomponent/src/main/ets/pc/manager/AnimManager';
import { StatusBarEventManager } from '@ohos/statusbarcomponent/src/main/ets/pc/manager/StatusBarEventManager';
import lazy StatusBarManager from '@ohos/statusbarcomponent/src/main/ets/pc/manager/StatusBarManager';
import { SCBStatusBarType } from '@ohos/statusbarcomponent/src/main/ets/pc/utils/enum';
import WifiIconPC from '@ohos/wificomponent/src/main/ets/default/pages/wifiIconPC';
import { windowMgr } from '@ohos/windowscene/src/main/ets/TsIndex';
import screenLockWifiEventMgr from '../common/ScreenLockWifiEventManager';

const TAG = 'ScreenLock-WifiIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
// 锁屏 Wifi 图标组件 id
const COMPONENT_ID = 'screen_lock_wifi_icon';
// 锁屏 Wifi 二级面板的窗口标识符
const PANEL_NAME = WindowConstants.WINDOW_NAME_LOCK_SCREEN_WIFI_PANEL;
// 设备设置包名 - 此包提供了 Wifi 元能力
const SETTINGS_BUNDLE_NAME = 'com.ohos.settings';

// 锁屏 Wifi 图标尺寸, 与桌面内状态栏 Wifi 图标一致
export const screenLockWifiIconSize: SizeOptions = {
  height: '32vp',
  width: '32vp',
};

/**
 * 设备制式枚举
 * @readonly
 * @enum
 */
enum CustPathEnum {
  /** 缺省值 */
  DEFAULT = 'empty',
  /** toB 版本 */
  TO_BASIC = 'tobbasic',
  /** hwit 版本 */
  HWIT = 'hwit',
}

/**
 * 锁屏 Wifi 图标组件
 */
@Component
export struct ScreenLockWifiIcon {
  // 图标 slot 标识符
  slot: string = 'screen_lock_wifi_icon';
  getIcon: Function = StatusBarManager.getInstance().getRemotePluginIconCallback?.();
  getActiveIcon: Function = StatusBarManager.getInstance().getActiveWifiIcon?.();
  onIconClick: (ev: ClickEvent) => void = () => {
  };
  @StorageLink('isScreenLockWallpaperBrightOrDark') isBrightOrDark: boolean = true;
  @StorageProp('isEndScreenOn') @Watch('onEndScreenChange') isEndScreenOn: boolean = false;
  // 动画属性, 可以用于控制图标缩放 scale 值
  @State animProperty: AnimProperty = AnimManager.getInstance().getAnim(PluginSlot.SLOT_STATUS_WIFI);
  @State isClicked: boolean = false;
  @State isHover: boolean = false;
  @State isIconVisible: boolean = false;
  @State isPanelShow: boolean = false;
  // 处理窗口事件的回调, 获取 Wifi 面板的开关状态
  handleWindowEvent = (event: WindowEvent): void => {
    if (event.windowName !== PANEL_NAME) {
      return;
    }
    log.info(`handleWindowEvent eventType ${event.eventType} eventState ${event.eventState}`);
    if (event.eventType === WindowEvent.EVENT_TYPE_SHOW && event.eventState === WindowEvent.EVENT_STATE_START) {
      this.isPanelShow = true;
    } else if (event.eventType === WindowEvent.EVENT_TYPE_HIDE && event.eventState === WindowEvent.EVENT_STATE_END) {
      this.isPanelShow = false;
    }
  };

  /**
   * 响应熄/亮屏变化, 熄屏时关闭锁屏 Wifi 二级面板
   */
  onEndScreenChange(): void {
    log.info(`onEndScreenChange isEndScreenOn ${this.isEndScreenOn}`);
    if (!this.isEndScreenOn) {
      windowMgr.hideWindowImmediately(PANEL_NAME);
    }
  }

  /**
   * 图标 Click 事件回调
   *
   * @param event Click 事件信息
   */
  handleClick(event: ClickEvent): void {
    log.info('handleClick');
    this.onIconClick(event);
    // 锁屏 Wifi 图标点击行为的大数据打点
    HiSysEventUtil.hiSysOnIconItemsClick(SETTINGS_BUNDLE_NAME, PluginSlot.SLOT_SCREEN_LOCK_WIFI,
      SCBStatusBarType.WINDOW_STATUS_BAR);
    screenLockWifiEventMgr.postIconClick(event);
  }

  /**
   * 图标 Hover 事件回调
   *
   * @param event Hover 事件信息
   */
  handleHover(isHover: boolean, event: HoverEvent): void {
    log.info(`handleHover isHover ${isHover}`);
    this.isHover = isHover;
  }

  /**
   * 图标 Touch 事件回调, 阻止冒泡
   *
   * @param event Touch 事件信息
   */
  handleTouch(event: TouchEvent): void {
    log.info('handleTouch');
    event.stopPropagation();
  }

  /**
   * 获取图标框的背景色
   *
   * @returns 电源背景色
   */
  getCurrentBgColor(): ResourceColor {
    if (this.isPanelShow) {
      return $r('app.color.plugin_icon_color_bg_selected'); // 锁屏 Wifi 面板展开时的背景色
    }
    if (this.isHover) {
      return this.isBrightOrDark ? $r('app.color.plugin_icon_color_bg_hovered') :
      $r('app.color.screen_lock_hover_dark_bg_color'); // Hover 态背景色
    }
    return $r('app.color.plugin_icon_color_bg_none'); // 默认背景色
  }

  shouldShowIcon(): boolean {
    log.info('shouldShowIcon');
    try {
      // 查询设备制式, tobasic/hwit 设备上显示锁屏 wifi 图标
      const param: string = systemParameterEnhance.getSync('const.cust.custPath', CustPathEnum.DEFAULT);
      const isHwItDevice: boolean = param.includes(CustPathEnum.HWIT);
      const isToBasicDevice: boolean = param.includes(CustPathEnum.TO_BASIC);
      log.info(`isHwitDevice ${isHwItDevice} isToBasicDevice ${isToBasicDevice}`);
      return isHwItDevice || isToBasicDevice;
    } catch (err) {
      log.error(`shouldShowIcon failed ${err?.code} ${err?.message}`);
      return false;
    }
  }

  aboutToAppear(): void {
    log.info('aboutToAppear');
    StatusBarEventManager.getInstance().on(TAG, WindowEvent, this.handleWindowEvent);
    this.isIconVisible = this.shouldShowIcon();
  }

  aboutToDisappear(): void {
    log.info('aboutToDisappear');
    StatusBarEventManager.getInstance().offAll(TAG);
    this.onIconClick = () => {};
  }

  build() {
    Row() {
      WifiIconPC({
        getIcon: this.getIcon,
        getActiveWifiIcon: this.getActiveIcon,
        animProperty: this.animProperty,
        iconWidth: screenLockWifiIconSize.width,
        iconHeight: screenLockWifiIconSize.height,
      });
    }
    .id(COMPONENT_ID)
    .backgroundColor(this.getCurrentBgColor())
    .borderRadius($r('sys.float.corner_radius_level4'))
    .focusBox({ margin: LengthMetrics.px(0) })
    .hoverEffect(HoverEffect.None)
    .margin({ left: '2vp', right: '2vp' })
    .visibility(this.isIconVisible ? Visibility.Visible : Visibility.None)
    .onClick((ev: ClickEvent) => this.handleClick(ev))
    .onHover((isHover: boolean, ev: HoverEvent) => this.handleHover(isHover, ev))
    .onTouch((ev: TouchEvent) => this.handleTouch(ev));
  }
}