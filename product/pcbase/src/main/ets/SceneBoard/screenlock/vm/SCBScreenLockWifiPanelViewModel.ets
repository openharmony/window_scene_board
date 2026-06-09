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

import Curves from '@ohos.curves';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import window from '@ohos.window';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { WindowConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import {
  EventListener,
  PluginInfo,
  PluginSlot,
  viewMgrPolicy,
  ViewType,
  WindowPositionChangeEvent,
} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { StatusBarEventManager } from '@ohos/statusbarcomponent/src/main/ets/pc/manager/StatusBarEventManager';
import { StatusBarAnimConstants } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { SystemSceneOptions } from '@ohos/windowscene/Index';
import { ResUtils, windowMgr } from '@ohos/windowscene/src/main/ets/TsIndex';
import screenLockWifiEventMgr, {
  IScreenLockWifiIconClickParams,
  ScreenLockWifiListener,
} from '../common/ScreenLockWifiEventManager';
import { screenLockWifiIconSize } from '../component/ScreenLockWifiIcon';

const TAG: string = 'SCBScreenLockWifiPanelViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
// 锁屏 Wifi 二级面板的窗口标识符
const PANEL_NAME = WindowConstants.WINDOW_NAME_LOCK_SCREEN_WIFI_PANEL;

export const SCB_SCREEN_LOCK_WIFI_PANEL_COMP_ID = 'screen_lock_wifi_panel';

/**
 * 锁屏 Wifi 组件 SCBScreenLockWifiPanel 的 ViewModel 类
 */
export class SCBScreenLockWifiPanelViewModel {
  /**
   * 与 WifiWindowSettingsAbility 约定好的参数, 1 代表是从 PC 锁屏调用的
   * 被调用方会据此做适配, 包括禁止连接未保存的网络, 禁用 WLAN 设置入口
   */
  public readonly pluginParams: Record<string, Object> = {
    'wifiWindowSettingsMode': 1
  };
  // 窗口位置和尺寸
  public position: window.Rect = {
    left: 1200,
    top: 44,
    width: 360, // 同状态栏 Wifi 二级面板默认宽度
    height: 119, // 同状态栏 Wifi 二级面板默认高度
  };
  // SCBSystemScene 组件配置
  public systemSceneOptions: SystemSceneOptions = new SystemSceneOptions({
    focusable: true,
    blockingFocus: true,
    touchable: true,
    hitTestMode: HitTestMode.Default,
    rotatable: true,
  });
  // 锁屏 Wifi 图标事件监听器
  public wifiListener: ScreenLockWifiListener = {
    onReceiveEvent: (eventName: string, params: IScreenLockWifiIconClickParams) => {
      this.onReceiveEvent(eventName, params);
    },
  };
  // 窗口位置和尺寸变化事件监听器
  public positionListener: EventListener<WindowPositionChangeEvent> = (event: WindowPositionChangeEvent) => {
    this.onWindowPositionEvent(event);
  };

  /**
   * 组件 aboutToAppear 生命周期回调
   */
  public aboutToAppear(): void {
    log.info(`aboutToAppear`);
    screenLockWifiEventMgr.registerIconClick(this.wifiListener);
    StatusBarEventManager.getInstance().on(PANEL_NAME, WindowPositionChangeEvent, this.positionListener);
  }

  /**
   * 组件 aboutToDisappear 生命周期回调
   */
  public aboutToDisappear(): void {
    log.info('aboutToDisappear');
    screenLockWifiEventMgr.unregisterIconClick(this.wifiListener);
    StatusBarEventManager.getInstance().offAll(PANEL_NAME);
  }

  /**
   * 锁屏 Wifi 二级面板是否正展开
   *
   * @returns
   */
  public isPanelShowing(): boolean {
    const isShowing: boolean = viewMgrPolicy.isViewShowing(ViewType.LOCK_SCREEN_WIFI_PANEL);
    log.info(`isPanelShow ${isShowing}`);
    return isShowing;
  }

  /**
   * 接收到锁屏 Wifi 图标点击事件时的回调
   * @param eventName 事件名
   * @param params 事件传递的参数
   */
  public onReceiveEvent(eventName: string, params: IScreenLockWifiIconClickParams): void {
    if (eventName !== screenLockWifiEventMgr.iconClickEventName) {
      return;
    }
    try {
      if (this.isPanelShowing()) {
        log.info('will hide window');
        windowMgr.hideWindowWithAnim(PANEL_NAME); // 关闭 panel 窗口
      } else {
        log.info('will show window');
        // 1. 读取状态栏 Wifi 图标的二级面板配置
        // 2. 复用配置信息, 写入窗口管理器供 AbilityRootComponent 组件使用
        // 3. 打开二级面板
        // 4. 计算然后设置窗口的尺寸和锚点坐标
        const info = AppStorage.get<PluginInfo>(`${PluginSlot.SLOT_STATUS_WIFI_PANEL}_info`);
        windowMgr.setWindowData(PANEL_NAME, info);
        windowMgr.showWindowWithAnim(PANEL_NAME, true); // 打开 panel 窗口
        this.updateStartPosition(params.event);
        this.setPosition(this.position);
      }
    } catch (err) {
      log.error(`onReceiveEvent failed ${err?.code} ${err?.message}`);
    }
  }

  /**
   * 更新锁屏 Wifi 窗口的坐标
   * event 是点击锁屏 Wifi 图标时传递过来的 clickEvent 数据, 包含图标的位置、尺寸等信息
   * 因为窗口要沿着图标位置向左下角展开, 所以
   * x 坐标 (left) 为 图标右侧横坐标 - 窗口宽度
   * y 坐标 (top) 为 图标底部纵坐标
   *
   * @param event 锁屏 Wifi 图标点击事件数据
   */
  public updateStartPosition(event: ClickEvent): void {
    const iconWidth = ResUtils.getNumberFromLength(screenLockWifiIconSize.width);
    const iconHeight = ResUtils.getNumberFromLength(screenLockWifiIconSize.height);
    const marginTop = 4;
    const globalPos: Position = event.target.area.globalPosition;
    const globalX: number = ResUtils.getNumberFromLength(globalPos.x);
    const globalY: number = ResUtils.getNumberFromLength(globalPos.y);
    // 默认向左展开, 如果左侧没有展开没有足够空间, 需要向右展开; 主要出现在 LT 镜像语言环境下
    // 左展开 - 图标左侧 x + 图标宽度 - 窗口宽度
    let left: number = globalX + iconWidth - this.position.width;
    if (left < 0) {
      // 右展开 - 图标左侧 x
      left = globalX;
    }
    // 图标顶部 y + 图标高度 + 面板和图标间距
    const top: number = globalY + iconHeight + marginTop;
    this.position.left = left;
    this.position.top = top;
    log.info(`updateStartPosition left ${left} top ${top}`);
  }

  /**
   * 设置锁屏 Wifi 窗口的尺寸和坐标
   *
   * @param pos
   */
  public setPosition(pos: window.Rect): void {
    log.info(`setWindowPosition position left ${pos.left} top ${pos.top} width ${pos.width} height ${pos.height}`);
    try {
      const viewCtrl = viewMgrPolicy.getViewController(ViewType.LOCK_SCREEN_WIFI_PANEL);
      viewCtrl?.updateArea(pos);
      viewCtrl?.updateRect(pos);
    } catch (err) {
      log.error(`setWindowPosition failed ${err?.code} ${err?.message}`);
    }
  }

  /**
   * 处理窗口显隐事件
   *
   * @param event 事件
   */
  public onKeyEvent(event: KeyEvent): void {
    log.info('onKeyEvent');
    const isHideKey: boolean = [KeyCode.KEYCODE_BACK, KeyCode.KEYCODE_ESCAPE].includes(event.keyCode);
    const isKeyUp: boolean = event.type === KeyType.Up;
    if (isHideKey && isKeyUp) {
      log.info('onKeyEvent will hide window');
      windowMgr.hideWindowWithAnim(PANEL_NAME);
    }
  };

  /**
   * 处理窗口位置变更事件
   * Wifi 面板内容变化时会广播事件, 此处监听到事件后根据参数动态调整面板容器高度
   *
   * @param event 事件
   */
  public onWindowPositionEvent(event: WindowPositionChangeEvent): void {
    if (event.windowName === PluginSlot.SLOT_STATUS_WIFI_PANEL && this.isPanelShowing()) {
      log.info('onReceiveEvent windowName');
      this.position.height = px2vp(event.area.height);
      this.setPosition(this.position);
      focusControl.requestFocus(SCB_SCREEN_LOCK_WIFI_PANEL_COMP_ID);
    }
  };

  /**
   * 获取锁屏 Wifi 面板的完整过渡动效
   *
   * @returns 过渡动效
   */
  public getFullTransitionEffect(): TransitionEffect {
    const appearEffect: TransitionEffect =
      this.getScaleTransitionEffect(StatusBarAnimConstants.INSERT_OPACITY_DURATION);
    const disappearEffect: TransitionEffect =
      this.getScaleTransitionEffect(StatusBarAnimConstants.DEL_OPACITY_DURATION);
    return TransitionEffect.asymmetric(appearEffect, disappearEffect);
  };

  /**
   * 获取锁屏 Wifi 面板的缩放动效
   *
   * @param duration 持续时间
   * @returns
   */
  public getScaleTransitionEffect(duration: number): TransitionEffect {
    const pivotX: string = '100%';
    const pivotY: string = '0%';
    const scaleOptions: ScaleOptions = {
      x: StatusBarAnimConstants.SCALE,
      y: StatusBarAnimConstants.SCALE,
      centerX: pivotX,
      centerY: pivotY,
    };
    const scaleAnimateParam: AnimateParam = {
      curve: Curves.springMotion(StatusBarAnimConstants.SPRING_MOTION_RESPONSE,
        StatusBarAnimConstants.SPRING_MOTION_DAMP),
    };
    const opacityAnimateParam: AnimateParam = {
      duration: duration,
      curve: Curve.Friction,
    };
    return TransitionEffect.scale(scaleOptions)
      .animation(scaleAnimateParam)
      .combine(TransitionEffect.OPACITY.animation(opacityAnimateParam));
  }
}