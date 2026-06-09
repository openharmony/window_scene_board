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

import Window from '@ohos.window';
import type Context from '@ohos.app.ability.common';
import { CommonUtils } from '@ohos/basicutils';
import { ArrayUtils } from '@ohos/basicutils';
import { EvtBus, HiSysEventUtil } from '@ohos/frameworkwrapper';
import { WindowEvent } from '@ohos/frameworkwrapper';
import { SingletonHelper } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { WindowConstants } from '@ohos/commonconstants';
import type { WindowAnimation } from '../animation/WindowAnimation';
import { CEManager } from '@ohos/frameworkwrapper';
import {SystemUIPanelConstants} from '@ohos/commonconstants';
import {
  ViewManagerPolicy,
  ViewController,
  viewMgrPolicy,
  ViewType } from '@ohos/frameworkwrapper';
import type { PluginInfo } from '@ohos/frameworkwrapper';
import { PluginSlot } from '@ohos/frameworkwrapper';
import type { SCBSessionRect } from '../scene/session/SCBSessionRect';
import { GlobalContext } from '@ohos/frameworkwrapper';
import systemDateTime from '@ohos.systemDateTime';
import { PluginClickInfo, PluginParseInfo } from '@ohos/frameworkwrapper';
import { performanceMonitor } from '@kit.ArkUI';

const TAG = 'SysUI-WindowManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 窗口获取type
 */
type WindowResolve = (window: Window.Window | PromiseLike<Window.Window>) => void;

/**
 * 窗口缓存信息
 */
class WindowCache {
  /**
   * 窗口名称，唯一标示
   */
  windowName: string;

  /**
   * 窗口实例
   */
  window: Window.Window;

  /**
   * 窗口等待集
   */
  windowResolves: Set<WindowResolve>;

  /**
   * 窗口是否正在显示
   */
  isWindowShowing: boolean;

  /**
   * 窗口是否正在创建
   */
  isWindowCreating: boolean;

  /**
   * 窗口是否已经创建
   */
  isWindowCreated: boolean;

  /**
   * 窗口位置
   */
  windowPosition: Window.Rect;

  /**
   * 窗口加载页面路径
   */
  contentUrl: string;

  /**
   * 背景色需要在loadContent之后
   */
  backgroundColor: string;

  /**
   * 窗口是否可以销毁重建
   */
  canDestroyWindow: boolean = true;

  /**
   * 窗口show/hide动画
   */
  windowAnim: WindowAnimation;

  /**
   * 状态栏图标锚点x坐标，用于二级菜单出入场动效，scale缩放中心
   */
  pivotX: number;

  /**
   * 状态栏图标锚点y坐标，用于二级菜单出入场动效，scale缩放中心
   */
  pivotY: number;

  /**
   * 设置窗口
   *
   * @param window 窗口
   */
  setWindow(window: Window.Window): void {
    this.window = window;
  }
}

/**
 * 窗口管理
 * TODO Window接口需要适配SCB方案、WindowAnimation
 *
 * @since 2022-10-22
 */
class WindowManagerProxy {
  /**
   * 窗口名称映射窗口类型
   * 窗口名 => 窗口类型
   */
  private static readonly WINDOW_NAME_TYPE: Map<string, Window.WindowType> = new Map([
    [WindowConstants.WINDOW_NAME_STATUS_BAR, Window.WindowType.TYPE_STATUS_BAR],
    [WindowConstants.WINDOW_NAME_BANNER, Window.WindowType.TYPE_FLOAT],
    [WindowConstants.WINDOW_NAME_DROPDOWN, Window.WindowType.TYPE_PANEL],
    [WindowConstants.WINDOW_NAME_VOLUME, Window.WindowType.TYPE_VOLUME_OVERLAY],
    [WindowConstants.WINDOW_NAME_LOCK_SCREEN, Window.WindowType.TYPE_KEYGUARD],
    [WindowConstants.WINDOW_NAME_PRIVACY_INDICATOR, Window.WindowType.TYPE_VOLUME_OVERLAY],
  ]);

  /**
   * TODO 暂时将窗口名映射到ViewType，后面应该将调用WindowManager的代码替换为调用ViewManagerPolicy接口
   */
  private static readonly WINDOW_NAME_VIEW_TYPE: Map<string, ViewType> = new Map([
    [WindowConstants.WINDOW_NAME_STATUS_BAR, ViewType.STATUS_BAR],
    [WindowConstants.WINDOW_NAME_GESTURE_TOP_BAR, ViewType.GESTURE_TOP_BAR],
    [WindowConstants.WINDOW_NAME_BANNER, ViewType.NOTIFICATION_BANNER],
    [WindowConstants.WINDOW_NAME_DROPDOWN, ViewType.DROPDOWN],
    [WindowConstants.WINDOW_NAME_VOLUME, ViewType.VOLUME],
    [WindowConstants.WINDOW_NAME_DOCK_POPUP_PANEL, ViewType.POPUP_PANEL],
    [WindowConstants.WINDOW_NAME_DOCK_EXT_POPUP_PANEL, ViewType.POPUP_PANEL_EXT],
    [WindowConstants.WINDOW_NAME_LOCK_SCREEN, ViewType.KEYGUARD],
    [PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL, ViewType.NOTIFICATION_CENTER],
    [PluginSlot.SLOT_STATUS_CONTROL_CENTER, ViewType.CONTROL_CENTER],
    [PluginSlot.SLOT_STATUS_EDIT_MODE_PANEL, ViewType.EDIT_MODE_PANEL],
    [PluginSlot.SLOT_STATUS_CLOCK_PANEL, ViewType.CALENDAR],
    [PluginSlot.SLOT_STATUS_PERSONAL, ViewType.SYSTEM_PANEL],
    [PluginSlot.SLOT_STATUS_SOUND_PANEL, ViewType.SOUND_PANEL],
    [PluginSlot.SLOT_STATUS_INPUT_PANEL, ViewType.INPUT_METHOD_SUBTYPE_PANEL],
    [PluginSlot.SLOT_STATUS_INPUT_METHOD, ViewType.INPUT_METHOD_PANEL],
    [PluginSlot.SLOT_STATUS_BATTERY_PANEL, ViewType.BATTERY_PANEL],
    [PluginSlot.SLOT_STATUS_WIFI_PANEL, ViewType.PLUGIN_WIFI],
    [PluginSlot.SLOT_STATUS_LOCATION, ViewType.PLUGIN_LOCATION],
    [PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL, ViewType.PLUGIN_BLUETOOTH],
    [PluginSlot.SLOT_STATUS_MICROPHONE_PANEL, ViewType.MICROPHONE_PANEL],
    [PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT, ViewType.PC_SUPER_PRIVACY_PANEL],
    [PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE, ViewType.PC_PADDLE_SUPER_PRIVACY_PANEL],
    [PluginSlot.SLOT_STATUS_TRAY_PANEL, ViewType.TRAY_PANEL],
    [PluginSlot.SLOT_STATUS_ENTERPRISE_SPACE, ViewType.ENTERPRISE_SPACE_PANEL],
    [PluginSlot.SLOT_CONTROL_PRIVACY_PANEL, ViewType.SLOT_CONTROL_PRIVACY_PANEL],
    [PluginSlot.SLOT_STATUS_POWER_SAVING, ViewType.POWER_SAVING],
    [PluginSlot.SLOT_CONTROL_MEDIA_PLAY_PANEL, ViewType.MEDIA_PLAY_PANEL],
    [WindowConstants.WINDOW_NAME_LOCK_SCREEN_WIFI_PANEL, ViewType.LOCK_SCREEN_WIFI_PANEL],
    [PluginSlot.SLOT_STATUS_USB, ViewType.PLUGIN_USB],
  ]);

  /**
   * 默认窗口类型
   */
  private static readonly DEFAULT_WINDOW_TYPE = Window.WindowType.TYPE_FLOAT;
  private static readonly SUBPAGE_WINDOW_TYPE = Window.WindowType.TYPE_VOLUME_OVERLAY;

  /**
   * 窗口缓存
   * 窗口名 => 窗口缓存信息
   */
  private windowCaches: Map<string, WindowCache> = new Map();

  private isStatusBarShowByAnimation: boolean = true;

  private statusIconCaches: Map<string, Area> = new Map();

  private inputMethodActiveCache: Map<number, boolean> = new Map();

  private inputMethodRectCache: Map<number, SCBSessionRect> = new Map();

  private windowDestroyCallBacks: Map<string, Function> = new Map();

  public setStatusIconCaches(name: string, area: Area): void {
    this.statusIconCaches.set(name, area);
  }

  public getStatusIconCache(name: string): Area {
    return this.statusIconCaches.get(name);
  }

  public getAllStatusIconCaches(): Map<string, Area> {
    return this.statusIconCaches;
  }

  public setInputMethodActiveCache(persistentId: number, isActive: boolean): void {
    this.inputMethodActiveCache.set(persistentId, isActive);
  }

  public setInputMethodRectCache(persistentId: number, rect: SCBSessionRect): void {
    this.inputMethodRectCache.set(persistentId, rect);
  }

  public delInputMethodCache(persistentId: number): void {
    this.inputMethodActiveCache.delete(persistentId);
    this.inputMethodRectCache.delete(persistentId);
  }

  public getActiveInputMethodRect(): SCBSessionRect {
    log.showInfo(`length:${this.inputMethodActiveCache.size}   ${this.inputMethodRectCache.size}`);
    let activePersistentId: number = undefined;
    for (let item of this.inputMethodActiveCache) {
      if (item[1]) {
        activePersistentId = item[0];
        break;
      }
    }
    if (CommonUtils.isInvalid(activePersistentId)) {
      return undefined;
    }
    return this.inputMethodRectCache.get(activePersistentId);
  }

  public registerWindowDestroyCallBack(pluginSlot: string, callback: Function): void {
    log.showInfo(`registerWindowDestroyCallBack ${pluginSlot}`);
    this.windowDestroyCallBacks.set(pluginSlot, callback);
  }

  public unregisterWindowDestroyCallBack(pluginSlot: string): void {
    log.showInfo(`unregisterWindowDestroyCallBack ${pluginSlot}`);
    this.windowDestroyCallBacks.delete(pluginSlot);
  }



  /**
   * 创建窗口
   *
   * @param windowName 窗口名称
   * @param context 环境
   * @param position 窗口位置大小
   * @param loadContent 窗口加载page页路径
   */
  async createWindow(
    windowName: string,
    context: Context.BaseContext,
    position: Window.Rect,
    loadContent: string,
    storage?: LocalStorage): Promise<Window.Window> {
    return null;
  }

  /**
   * 销毁窗口
   *
   * @param windowName 窗口名
   */
  destroyWindow(windowName: string): void {
    this.getWindow(windowName).then((window: Window.Window) => {
      // 移除监听
      this.offTouchOutside(windowName);
      log.showInfo(`destroyWindow over ${windowName}`);
      // 清除缓存
      this.windowCaches.delete(windowName);
    });
  }

  /**
   * 更新窗口位置、尺寸
   *
   * @param windowName 窗口名
   * @param position 位置
   */
  updateWindowPosition(windowName: string, position: Window.Rect): void {
    if (this.checkPositionChange(windowName, position)) {
      this.setWindowPosition(windowName, position);
    }
  }

  /**
   * 获取目标窗口当前的位置
   *
   * @param windowName 窗口名
   */
  getWindowPosition(windowName: string): Window.Rect {
    let position = this.windowCaches.get(windowName)?.windowPosition;
    if (CommonUtils.isInvalid(position)) {
      let viewRect = ViewManagerPolicy.getArea(this.getViewType(windowName));
      return {
        left: viewRect ? vp2px(viewRect.left) : 0,
        top: viewRect ? vp2px(viewRect.top) : 0,
        width: viewRect ? vp2px(viewRect.width) : 0,
        height: viewRect ? vp2px(viewRect.height) : 0
      };
    }
    return {
      left: position.left,
      top: position.top,
      width: position.width,
      height: position.height
    };
  }

  /**
   * 设置窗口圆角
   *
   * @param windowName 窗口名
   * @param radius 窗口圆角
   */
  updateWindowRadius(windowName: string, radius: number): void {
    this.getWindow(windowName).then((window: Window.Window) => {
    });
  }

  /**
   * 设置窗口背景颜色
   *
   * @param windowName 窗口名
   * @param bgColor 背景颜色
   */
  setWindowBgColor(windowName: string, bgColor: string): void {
    this.getWindow(windowName).then((window: Window.Window) => {
      let cache = this.getOrCreateCache(windowName);
      // 已加载content，直接设置背景色，未加载则缓存
      if (CommonUtils.isEmpty(cache.contentUrl)) {
      } else {
        cache.backgroundColor = bgColor;
      }
    });
  }

  /**
   * 设置窗口背景模糊效果
   *
   * @param windowName 窗口名
   * @param background 背景色
   * @param radius 模糊半径，默认4.0
   */
  setWindowBackBlur(windowName: string, background: string, radius?: number): void {
    this.getWindow(windowName).then((window: Window.Window) => {
      this.setWindowBgColor(windowName, background);
    });
  }

  /**
   * 设置窗口边缘阴影
   *
   * @param windowName 窗口名
   * @param radius 模糊半径
   * @param color 阴影颜色
   * @param offsetX 阴影X偏移
   * @param offsetY 阴影Y偏移
   */
  setWindowShadow(windowName: string, radius: number, color?: string, offsetX?: number, offsetY?: number): void {
    this.getWindow(windowName).then((window: Window.Window) => {
    });
  }

  /**
   * 设置窗口全屏，占用状态栏位置
   *
   * @param windowName 窗口名
   */
  setWindowFullScreen(windowName: string): void {
    this.getWindow(windowName).then((window: Window.Window) => {
    });
  }

  /**
   * 设置窗口背景模糊半径
   *
   * @param windowName 窗口名
   * @param radius 模糊半径
   */
  setWindowBgBlurRadius(windowName: string, radius: number): void {
    this.getWindow(windowName).then((window: Window.Window) => {
    });
  }

  /**
   * 设置窗口背景模糊半径
   *
   * @param windowName 串口名
   * @param style 模糊类型
   */
  setWindowBgBlurStyle(windowName: string, style: Window.BlurStyle): void {
    this.getWindow(windowName).then((window: Window.Window) => {
    });
  }

  /**
   * 设置窗口隐私模式
   * 隐私模式不允许截屏
   *
   * @param windowName 窗口名
   * @param isPrivacy true隐私模式
   */
  setWindowPrivacyMode(windowName: string, isPrivacy: boolean): void {
    this.getWindow(windowName).then((window: Window.Window) => {
    });
  }

  /**
   * 设置窗口旋转模式
   *
   * @param windowName 窗口名
   * @param orientation 旋转模式
   */
  setWindowOrientation(windowName: string, orientation: Window.Orientation): void {
    this.getWindow(windowName).then((window: Window.Window) => {
    });
  }

  /**
   * 设置窗口show/hide动画
   *
   * @param windowName 窗口名
   * @param windowAnim 窗口动画
   */
  setWindowAnim(windowName: string, windowAnim: WindowAnimation): void {
    let cache = this.windowCaches.get(windowName);
    // 尚未开始创建窗口
    if (CommonUtils.isInvalid(cache) || CommonUtils.isInvalid(windowAnim)) {
      return;
    }
    cache.windowAnim = windowAnim;
  }

  /**
   * 更新窗口动画锚点
   *
   * @param windowName 窗口名
   * @param pivotX 锚点X
   * @param pivotY 锚点Y
   */
  updateWindowAnimPivot(windowName: string, pivotX: number, pivotY: number): void {
    let cache: WindowCache = this.getOrCreateCache(windowName);
    cache.pivotX = pivotX;
    cache.pivotY = pivotY;
  }

  /**
   * 获取窗口动效锚点（状态栏二级菜单动效scale缩放中心使用）
   *
   * @param windowName
   */
  getWindowAnimPivot(windowName: string): Array<number> {
    let pivotX = this.windowCaches.get(windowName)?.pivotX;
    let pivotY = this.windowCaches.get(windowName)?.pivotY;
    return [pivotX, pivotY];
  }

  /**
   * 开始绑定窗口动画的onFrame回调
   * 动画的onFrame回调依赖component，否则会crash
   *
   * @param windowName 窗口名
   */
  startBindWinAnimOnFrame(windowName: string): void {
    this.windowCaches.get(windowName)?.windowAnim?.startBindOnFrame();
  }

  /**
   * 注册外部touch事件回调
   *
   * @param windowName 窗口名
   * @param callback 窗口点击外部回调
   */
  onTouchOutside(windowName: string, callback: () => void): void {
    this.getWindow(windowName).then((window: Window.Window) => {
    });
  }

  /**
   * 注销外部touch事件回调
   *
   * @param windowName 窗口名
   */
  offTouchOutside(windowName: string): void {
    this.getWindow(windowName).then((window: Window.Window) => {
    });
  }

  /**
   * 当前窗口是否显示
   *
   * @param windowName 窗口名
   */
  isShowing(windowName: string): boolean {
    let isShowing = this.windowCaches.get(windowName)?.isWindowShowing;
    if (CommonUtils.isInvalid(isShowing)) {
      return ViewManagerPolicy.isViewShowing(this.getViewType(windowName));
    }
    return isShowing || ViewManagerPolicy.isViewShowing(this.getViewType(windowName));
  }

  /**
   * 当前窗口是否创建
   *
   * @param windowName 窗口名
   */
  isCreated(windowName: string): boolean {
    let isCreated = this.windowCaches.get(windowName)?.isWindowCreated;
    if (CommonUtils.isInvalid(isCreated)) {
      return false;
    }
    return isCreated;
  }

  /**
   * 显示窗口，有回调
   *
   * @return windowName 窗口名
   */
  async showWindowCallback(windowName: string): Promise<void> {
    return new Promise((resolve) => {
      if (this.isShowing(windowName)) {
        resolve();
        return;
      }
      // 记录正在显示
      let cache = this.getOrCreateCache(windowName);
      cache.isWindowShowing = true;
      // 发送开始显示窗口事件
      this.postWindowEvent(windowName, WindowEvent.EVENT_TYPE_SHOW, WindowEvent.EVENT_STATE_START);
      log.showInfo('showWindowCallback start show window: ' + windowName);
      ViewManagerPolicy.showView(this.getViewType(windowName));
      resolve();
      // 窗口显示完成，发送窗口显示结束事件
      this.postWindowEvent(windowName, WindowEvent.EVENT_TYPE_SHOW, WindowEvent.EVENT_STATE_END);
      this.checkDropWindowStatus(windowName, true);
    });
  }

  /**
   * 隐藏窗口，有回调
   *
   * @return windowName 窗口名
   */
  async hideWindowCallback(windowName: string): Promise<void> {
    return new Promise((resolve) => {
      if (!this.isShowing(windowName)) {
        resolve();
        return;
      }
      // 记录隐藏
      this.getOrCreateCache(windowName).isWindowShowing = null;
      // 发送开始隐藏窗口事件
      this.postWindowEvent(windowName, WindowEvent.EVENT_TYPE_HIDE, WindowEvent.EVENT_STATE_START);
      log.showInfo('hideWindowCallback start hide window: ' + windowName);
      ViewManagerPolicy.hideView(this.getViewType(windowName));
      resolve();
      // 窗口隐藏完成，发送窗口显示结束事件
      this.postWindowEvent(windowName, WindowEvent.EVENT_TYPE_HIDE, WindowEvent.EVENT_STATE_END);
      this.checkDropWindowStatus(windowName, false);
    });
  }

  /**
   * 立即显示窗口
   *
   * @param windowName 窗口名
   */
  showWindowImmediately(windowName: string): void {
    this.showWindow(windowName, false);
  }

  /**
   * 动画显示窗口
   *
   * @param windowName 窗口名
   */
  showWindowWithAnim(windowName: string, needMoreHilog?: boolean): void {
    this.performanceforShowAniStart(windowName);
    this.showWindow(windowName, true, needMoreHilog);
  }

  /**
   * 设置窗口数据
   */
  setWindowData(windowName: string, viewData: PluginInfo): void {
    ViewManagerPolicy.setViewData(this.getViewType(windowName), viewData);
  }

  /**
   * 立即隐藏窗口
   *
   * @param windowName 窗口名
   */
  hideWindowImmediately(windowName: string): void {
    this.hideWindow(windowName, false);
  }

  /**
   * 动画隐藏窗口
   *
   * @param windowName 窗口名
   */
  hideWindowWithAnim(windowName: string): void {
    this.performanceforHideAniStart(windowName);
    this.hideWindow(windowName, true);
  }

  /**
   * 动效维测打点
   *
   * @param string
   */
  private performanceforShowAniStart(slotStr: string): void {
    if (slotStr === PluginSlot.SLOT_STATUS_CONTROL_CENTER) {
      performanceMonitor.begin(HiSysEventUtil.INTO_CC_ANI, performanceMonitor.ActionType.LAST_UP);
    } else if (slotStr === PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL) {
      performanceMonitor.begin(HiSysEventUtil.INTO_NC_ANI, performanceMonitor.ActionType.LAST_UP);
    }
  }

  private performanceforShowAniEnd(slotStr: string): void {
    if (slotStr === PluginSlot.SLOT_STATUS_CONTROL_CENTER) {
      performanceMonitor.end(HiSysEventUtil.INTO_CC_ANI);
    } else if (slotStr === PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL) {
      performanceMonitor.end(HiSysEventUtil.INTO_NC_ANI);
    }
  }

  private performanceforHideAniStart(slotStr: string): void {
    if (slotStr === PluginSlot.SLOT_STATUS_CONTROL_CENTER) {
      performanceMonitor.begin(HiSysEventUtil.EXIT_CC_ANI, performanceMonitor.ActionType.LAST_UP);
    } else if (slotStr === PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL) {
      performanceMonitor.begin(HiSysEventUtil.EXIT_NC_ANI, performanceMonitor.ActionType.LAST_UP);
    }
  }

  private performanceforHideAniEnd(slotStr: string): void {
    if (slotStr === PluginSlot.SLOT_STATUS_CONTROL_CENTER) {
      performanceMonitor.end(HiSysEventUtil.EXIT_CC_ANI);
    } else if (slotStr === PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL) {
      performanceMonitor.end(HiSysEventUtil.EXIT_NC_ANI);
    }
  }

  /**
   * 通过persistentId带动画隐藏窗口
   *
   * @param persistentId 窗口persistentId
   */
  hideWindowWithAnimByPersistentId(persistentId: number): void {
    const viewType = ViewManagerPolicy.getViewTypeById(persistentId);
    let windowName: string;
    if (typeof viewType === 'string') {
      windowName = viewType;
    } else {
      windowName = windowMgr.getWindowNameByViewType(viewType);
      if (!windowName) {
        log.error('windowName null, fail to  hide window');
        return;
      }
    }
    this.hideWindow(windowName, true);
  }

  /**
   * 设置窗口是否可触摸
   *
   * @param windowName 窗口名
   * @param touchable 是否可触摸
   */
  setWindowTouchable(windowName: string, touchable: boolean): void {
    this.getWindow(windowName).then((window: Window.Window) => {
    });
  }

  /**
   * 更新是否可销毁window标记
   *
   * @param windowName 窗口名
   * @param flag 是否可销毁window标记
   */
  updateDestroyWindowFlag(windowName: string, flag: boolean): void {
    // 记录隐藏
    this.getOrCreateCache(windowName).canDestroyWindow = flag;
    let callback = this.windowDestroyCallBacks.get(windowName);
    if (callback) {
      callback(flag);
    }
  }

  /**
   * 是否可以销毁window
   *
   * @param windowName 窗口名
   */
  canDestroyWindow(windowName: string): boolean {
    return this.getOrCreateCache(windowName).canDestroyWindow;
  }

  /**
   * 记录窗口显示完成的时间戳
   */
  recordTimestampsOfWindowShowed(): void {
    try {
      const clickBluetoothAndWiFiTime = systemDateTime.getTime(false);
      GlobalContext.getInstance().setObject('clickBluetoothAndWiFiTime', clickBluetoothAndWiFiTime);
    } catch (error) {
      log.showError(`Failed to get time. message: ${error.message}`);
    }
  }

  /**
   * 显示窗口
   *
   * @param windowName 窗口名
   */
  private showWindow(windowName: string, isUseAnim: boolean, needMoreHilog?: boolean): void {
    if (this.isShowing(windowName)) {
      log.showDebug('showWindow window is showing: ' + windowName);
      return;
    }
    // 记录正在显示
    let cache = this.getOrCreateCache(windowName);
    cache.isWindowShowing = true;
    // 发送开始显示窗口事件
    this.postWindowEvent(windowName, WindowEvent.EVENT_TYPE_SHOW, WindowEvent.EVENT_STATE_START);
    if (needMoreHilog) {
      log.showInfo('getWindow start --zpan-- ' + windowName + ' ' + Array.from(this.windowCaches.keys()).join('、'));
    }
    // show完成回调
    let showFinish: () => void = () => {
      // 窗口显示完成，发送窗口显示结束事件
      this.postWindowEvent(windowName, WindowEvent.EVENT_TYPE_SHOW, WindowEvent.EVENT_STATE_END);
      this.checkDropWindowStatus(windowName, true);
    };
    if (needMoreHilog) {
      log.showInfo('showWindow start --zpan-- ' + windowName);
    }
    // show出窗口
    ViewManagerPolicy.showView(this.getViewType(windowName));
    // 判断是否有动画
    if (isUseAnim && !CommonUtils.isInvalid(cache.windowAnim)) {
      cache.windowAnim.showAnim((isCancel) => {
        showFinish();
      }, this.getInterrupt(true, windowName));
      this.performanceforShowAniEnd(windowName);
    } else {
      showFinish();
    }
    // 记录showFinish完成时的时间戳，蓝牙WiFi单独处理问题
    if (PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL === windowName || PluginSlot.SLOT_STATUS_WIFI_PANEL === windowName) {
      this.recordTimestampsOfWindowShowed();
    }
    if (needMoreHilog) {
      log.showInfo('showWindow over --zpan-- ' + windowName);
    }
  }

  private getInterrupt(isShow: boolean, windowName: string): boolean {
    if (!CommonUtils.equals(windowName, WindowConstants.WINDOW_NAME_STATUS_BAR)) {
      return true;
    }
    let result: boolean = this.isInterrupt(isShow, windowName);
    log.showInfo('isShow : ' + isShow + ' windowName ： ' + windowName + ' result : ' + result);
    return result;
  }

  private isInterrupt(isShow: boolean, windowName: string): boolean {
    let cache: WindowCache = this.windowCaches.get(windowName);
    if (cache === null) {
      return true;
    }
    if (isShow && cache.isWindowShowing === null) {
      return false;
    }
    if (!isShow && cache.isWindowShowing === true) {
      return false;
    }
    return true;
  }

  private checkDropWindowStatus(windowName: string, isShow: boolean): void {
    if (!CommonUtils.equals(windowName, WindowConstants.WINDOW_NAME_DROPDOWN)) {
      return;
    }
    log.showInfo(`window  ${windowName} status change, isShow : ${isShow}`);
    CEManager.publishCommentEvent(SystemUIPanelConstants.SYSTEMUI_PANEL_STATUS, {
      data: isShow ? SystemUIPanelConstants.SYSTEMUI_PANEL_SHOW : SystemUIPanelConstants.SYSTEMUI_PANEL_HIDE
    });
  }

  /**
   * 隐藏窗口
   *
   * @param windowName 窗口名
   */
  private hideWindow(windowName: string, isUseAnim: boolean): void {
    if (!this.isShowing(windowName)) {
      log.showDebug('hideWindow window is hide: ' + windowName);
      return;
    }
    // 记录隐藏
    let cache = this.getOrCreateCache(windowName);

    cache.isWindowShowing = null;
    // 发送开始隐藏窗口事件
    this.postWindowEvent(windowName, WindowEvent.EVENT_TYPE_HIDE, WindowEvent.EVENT_STATE_START);
    // hide完成回调
    let hideFinish: () => void = () => {
      // 窗口隐藏完成，发送窗口显示结束事件
      this.postWindowEvent(windowName, WindowEvent.EVENT_TYPE_HIDE, WindowEvent.EVENT_STATE_END);
      this.checkDropWindowStatus(windowName, false);
    };
    log.showInfo('hideWindow start hide window: ' + windowName);
    // 动画hide
    if (isUseAnim && !CommonUtils.isInvalid(cache.windowAnim)) {
      cache.windowAnim.hideAnim((isCancel) => {
        log.showInfo('hideWindow isCancel: ' + isCancel);
        // 中断动画，接续show的场景不隐藏窗口
        if (isCancel) {
          hideFinish();
        } else {
          ViewManagerPolicy.hideView(this.getViewType(windowName));
          hideFinish();
        }
      }, this.getInterrupt(false, windowName));
      this.performanceforHideAniEnd(windowName);
      return;
    }
    // 直接hide
    ViewManagerPolicy.hideView(this.getViewType(windowName));
    hideFinish();
  }

  /**
   * 检测窗口位置是否发生变化
   *
   * @param windowName 窗口名
   * @param position 窗口位置
   * @return true位置变化
   */
  private checkPositionChange(windowName: string, position: Window.Rect): boolean {
    let oldPosition = this.windowCaches.get(windowName)?.windowPosition;
    if (CommonUtils.isInvalid(oldPosition)) {
      return true;
    }
    return (
      oldPosition.left !== position.left ||
        oldPosition.top !== position.top ||
        oldPosition.width !== position.width ||
        oldPosition.height !== position.height
    );
  }

  /**
   * 设置窗口位置
   *
   * @param windowName 窗口名
   * @param window 窗口
   * @param position 位置
   */
  private setWindowPosition(windowName: string, position: Window.Rect): void {
    if (CommonUtils.isInvalid(position)) {
      return;
    }
    // 缓存位置
    let cache = this.getOrCreateCache(windowName);
    cache.windowPosition = position;
    ViewManagerPolicy.getViewController(this.getViewType(windowName))?.updateArea({
      left: px2vp(position.left),
      top: px2vp(position.top),
      width: px2vp(position.width),
      height: px2vp(position.height)
    });
    ViewManagerPolicy.getViewController(this.getViewType(windowName))?.updateRect({
      left: px2vp(position.left),
      top: px2vp(position.top),
      width: px2vp(position.width),
      height: px2vp(position.height)
    });
    log.showInfo(`setWindowPosition name: ${windowName}, position: ${position?.left}-${position?.top}-${position?.width}-${position?.height}`);
  }

  /**
   * 获取窗口by窗口名
   *
   * @return 窗口
   */
  private async getWindow(windowName: string): Promise<Window.Window> {
    let window = this.windowCaches.get(windowName)?.window;
    if (!CommonUtils.isInvalid(window)) {
      return window;
    }
    return new Promise((resolve) => {
      // 没有创建窗口
      if (CommonUtils.isInvalid(this.windowCaches.get(windowName)?.isWindowCreating)) {
        return;
      }
      // 等待窗口创建完成
      this.putWindowResolve(windowName, resolve);
    });
  }

  /**
   * 分发窗口等待事件
   *
   * @param windowName 窗口名
   * @param window 窗口
   */
  private dispatchWindowResolve(windowName: string, window: Window.Window): void {
    let cache = this.windowCaches.get(windowName);
    let resolves = cache?.windowResolves;
    if (ArrayUtils.isEmpty(resolves)) {
      return;
    }
    // 遍历等待，回调
    if (!CommonUtils.isInvalid(window)) {
      resolves.forEach((resolve) => {
        resolve(window);
      });
    }
    // 清空等待
    resolves.clear();
    cache.windowResolves = null;
  }

  /**
   * 获取窗口缓存器
   *
   * @param windowName 窗口名
   * @return 缓存器
   */
  private getOrCreateCache(windowName: string): WindowCache {
    let cache = this.windowCaches.get(windowName);
    if (CommonUtils.isInvalid(cache)) {
      cache = new WindowCache();
      this.windowCaches.set(windowName, cache);
    }
    return cache;
  }

  /**
   * 缓存窗口等待事件
   *
   * @param windowName 窗口名
   * @param resolve 等待事件
   */
  private putWindowResolve(windowName: string, resolve: WindowResolve): void {
    let cache = this.getOrCreateCache(windowName);
    let resolves = cache.windowResolves;
    if (CommonUtils.isInvalid(resolves)) {
      resolves = new Set();
      cache.windowResolves = resolves;
    }
    resolves.add(resolve);
  }

  /**
   * 获取窗口类型by窗口名称
   *
   * @param windowName 窗口名称
   * @return 窗口类型
   */
  private getWindowType(windowName: string): Window.WindowType {
    // 优先对应类型
    let type: Window.WindowType = WindowManagerProxy.WINDOW_NAME_TYPE.get(windowName);
    if (!CommonUtils.isInvalid(type)) {
      return type;
    }
    // 其次默认类型
    return WindowManagerProxy.DEFAULT_WINDOW_TYPE;
  }

  public getViewType(windowName: string): ViewType | string {
    return WindowManagerProxy.WINDOW_NAME_VIEW_TYPE.get(windowName) ?? windowName;
  }

  private getWindowNameByViewType(viewType?: ViewType): string | undefined {
    if (!viewType) {
      log.error('getWindowNameByViewType viewType null');
      return undefined;
    }
    let windowName: string | undefined = undefined;
    for (const keyValuePair of WindowManagerProxy.WINDOW_NAME_VIEW_TYPE.entries()) {
      if (keyValuePair[1] === viewType) {
        windowName = keyValuePair[0];
        break;
      }
    }
    return windowName;
  }

  /**
   * 发送窗口显示/隐藏事件
   *
   * @param windowName 窗口名
   * @param eventType 事件类型，显示/隐藏
   * @param eventState 事件状态，开始/结束
   */
  private postWindowEvent(windowName: string, eventType: number, eventState: number): void {
    let event = new WindowEvent();
    event.windowName = windowName;
    event.eventType = eventType;
    event.eventState = eventState;
    EvtBus.post(WindowEvent, event);
  }

    /**
   * 清除窗口缓存
   *
   * @param windowName 窗口名
   */
  public clearWindowCache(windowName: string): void {
    // 清除缓存
    log.showDebug(`clearWindowCache window: : ${windowName}`);
    this.windowCaches?.delete(windowName);
  }
}

// 单例
export let windowMgr = SingletonHelper.getInstance(WindowManagerProxy, TAG);