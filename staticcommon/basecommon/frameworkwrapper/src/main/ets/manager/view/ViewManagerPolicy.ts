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

import { SingletonHelper, LogDomain, Logger } from '@ohos/basicutils';
import { HiSysEventUtil } from '../../hisysevent/HiSysEventUtil';
import type { PluginInfo } from '../../plugin/PluginInfo';
import { DebugCommand, DebugCommandManager } from '../../recent/debug/DebugCommand';

const TAG = 'ViewManagerPolicy';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);

export enum ViewType {
  MATTES_PANEL,
  KEYGUARD,
  KEYGUARD_EXT,
  OOBE_EXT,
  WALLPAPER,
  WALLPAPER_EXT,
  WALLPAPER_SCREEN_LOCK,
  DESKTOP,
  DESKTOP_EXT,
  APP_CENTER,
  APP_CENTER_EXT,
  RECENT,
  SMART_DOCK,
  SMART_DOCK_MASK,
  CENTRAL_LOGO_MASK,
  SMART_DOCK_EXT_SCREEN,
  NOTIFICATION_BANNER,
  NOTIFICATION_CENTER,
  CALENDAR,
  CONTROL_CENTER,
  DROPDOWN,
  STATUS_BAR,
  GESTURE_TOP_BAR,
  VOLUME,
  SYSTEM_PANEL,
  SOUND_PANEL,
  MICROPHONE_PANEL,
  INPUT_METHOD_SUBTYPE_PANEL,
  INPUT_METHOD_PANEL,
  BATTERY_PANEL,
  PLUGIN_WIFI,
  PLUGIN_BLUETOOTH,
  PLUGIN_LOCATION,
  BRIGHTNESS_PANEL,
  NEGATIVE_SCREEN,
  GLOBAL_SEARCH,
  SYSTEM_ALERT,
  CAMERA_PANEL,
  META_BALL,
  MIC_REMINDER,
  SHORTCUT_KEY_PANEL,
  SHUTDOWN_VIEW,
  KEYGUARD_BOUNCER,
  NEW_PRIVACY_INDICATOR,
  DESKTOP_SWITCHER,
  DESKTOP_SWITCHER_EXT_SCREEN,
  ENTERPRISE_DISALLOW_DIALOG,
  DESKTOP_SWITCHER_SPACES,
  SIDE_EDGE_BAR,
  DESKTOP_EMERGENCY,
  OUTER_DESKTOP_EMERGENCY,
  NOTIFY_PC_MODE,
  SPACED_GESTURE,
  FORM_CENTER,
  TRAY_PANEL,
  ENTERPRISE_SPACE_PANEL,
  CTRL_ALT_DEL_PANEL,
  SLOT_CONTROL_PRIVACY_PANEL,
  EDIT_MODE_PANEL,
  FLASHLIGHT_TIPS,
  SIDE_EDGE_MANAGER,
  FORCE_EXIT_COMPONENT,
  C_SIDE_GUSTURE_TOP_BAR,
  POPUP_PANEL,
  POPUP_PANEL_EXT,
  SWITCH_MODE_PANEL,
  POWER_SAVING,
  CENTRAL_MASK,
  LOCK_SCREEN_WIFI_PANEL,
  DIALOG_VIEW,
  PLUGIN_USB,
  EXPAND_GUIDE_BOX,
  MEDIA_PLAY_PANEL,
  VIRTUAL_STATUS_BAR,
  PC_SUPER_PRIVACY_PANEL,
  PC_PADDLE_SUPER_PRIVACY_PANEL,
  SCREENLOCK_STATUS_BAR,
  VIRTUAL_NAV_BAR
}

const VIEW_TAG: Map<ViewType, string> = new Map([
  [ViewType.MATTES_PANEL, 'SCBScreenMattesPanel'],
  [ViewType.KEYGUARD, 'SCBScreenLock'],
  [ViewType.KEYGUARD_EXT, 'SCBScreenMask'],
  [ViewType.OOBE_EXT, 'SCBScreenMaskOobe'],
  [ViewType.WALLPAPER, 'SCBWallpaper'],
  [ViewType.WALLPAPER_EXT, 'SCBWallpaper_Ext'],
  [ViewType.WALLPAPER_SCREEN_LOCK, 'SCBCloneWallpaper'],
  [ViewType.DESKTOP, 'SCBDesktop'],
  [ViewType.DESKTOP_EXT, 'SCBExtDesktop'],
  [ViewType.APP_CENTER, 'SCBAppCenterView'],
  [ViewType.APP_CENTER_EXT, 'SCBAppCenterView_Ext'],
  [ViewType.RECENT, 'recent'],
  [ViewType.SMART_DOCK, 'SCBSmartDock'],
  [ViewType.SMART_DOCK_MASK, 'SCBSmartDockMask'],
  [ViewType.CENTRAL_LOGO_MASK, 'SCBCentralLogoMask'],
  [ViewType.SMART_DOCK_EXT_SCREEN, 'SCBExtendScreenDock'],
  [ViewType.NOTIFICATION_BANNER, 'SCBBannerNotification'],
  [ViewType.NOTIFICATION_CENTER, 'SCBAssemblyPanel'],
  [ViewType.CALENDAR, 'calendar'],
  [ViewType.CONTROL_CENTER, 'SCBControlPanel'],
  [ViewType.DROPDOWN, 'DropdownPanelView'],
  [ViewType.STATUS_BAR, 'SCBStatusBar'],
  [ViewType.GESTURE_TOP_BAR, 'SCBGestureTopBar'],
  [ViewType.VOLUME, 'SCBVolumePanel'],
  [ViewType.SYSTEM_PANEL, 'SCBSystemPanel'],
  [ViewType.SOUND_PANEL, 'SCBSoundPanel'],
  [ViewType.MICROPHONE_PANEL, 'SCBMicrophonePanel'],
  [ViewType.INPUT_METHOD_SUBTYPE_PANEL, 'SCBInputMethodSubtypePanel'],
  [ViewType.INPUT_METHOD_PANEL, 'SCBInputMethodPanel'],
  [ViewType.BATTERY_PANEL, 'SCBBatteryPanel'],
  [ViewType.PLUGIN_WIFI, 'PluginWifiPanel'],
  [ViewType.PLUGIN_BLUETOOTH, 'PluginBluetoothPanel'],
  [ViewType.PLUGIN_LOCATION, 'PluginLocationPanel'],
  [ViewType.BRIGHTNESS_PANEL, 'SCBBrightnessPanel'],
  [ViewType.SYSTEM_ALERT, 'systemAlert'],
  [ViewType.CAMERA_PANEL, 'SCBCameraPanel'],
  [ViewType.MIC_REMINDER, 'SCBMicReminder'],
  [ViewType.SHORTCUT_KEY_PANEL, 'SCBShortcutkeyPanel'],
  [ViewType.SHUTDOWN_VIEW, 'ShutDownView'],
  [ViewType.KEYGUARD_BOUNCER, 'keyguardBouncer'],
  [ViewType.NEW_PRIVACY_INDICATOR, 'SCBPrivacyIndicator'],
  [ViewType.DESKTOP_SWITCHER, 'SCBMultiDesktopSwitcher'],
  [ViewType.ENTERPRISE_DISALLOW_DIALOG, 'SCBEnterpriseDisallowDialog'],
  [ViewType.DESKTOP_SWITCHER_SPACES, 'SCBMultiSpaceSwitchView'],
  [ViewType.SIDE_EDGE_BAR, 'SCBSideEdgeBar'],
  [ViewType.DESKTOP_EMERGENCY, 'SCBDesktopEmergency'],
  [ViewType.NOTIFY_PC_MODE, 'notifyPcMode'],
  [ViewType.FORM_CENTER, 'SCBFormCenter'],
  [ViewType.TRAY_PANEL, 'SCBTrayPanel'],
  [ViewType.ENTERPRISE_SPACE_PANEL, 'SCBEnterpriseSpacePanel'],
  [ViewType.CTRL_ALT_DEL_PANEL, 'SCBCtrlAltDelPanel'],
  [ViewType.SLOT_CONTROL_PRIVACY_PANEL, 'PrivacyPluginRootComponent'],
  [ViewType.EDIT_MODE_PANEL, 'SCBControlEditView'],
  [ViewType.FLASHLIGHT_TIPS, 'FlashlightTips'],
  [ViewType.SIDE_EDGE_MANAGER, 'SCBSideEdgeScenePanel'],
  [ViewType.FORCE_EXIT_COMPONENT, 'ForceExtensionComponent'],
  [ViewType.C_SIDE_GUSTURE_TOP_BAR, 'SCBCSideGestureBar'],
  [ViewType.POPUP_PANEL, 'FixedScrollerComponent'],
  [ViewType.POPUP_PANEL_EXT, 'FixedScrollerComponent_Ext'],
  [ViewType.SWITCH_MODE_PANEL, 'SCBSwitchModePanel'],
  [ViewType.POWER_SAVING, 'PowerSavingPanel'],
  [ViewType.CENTRAL_MASK, 'SCBCentralMask'],
  [ViewType.LOCK_SCREEN_WIFI_PANEL, 'SCBScreenLockWifiPanel'],
  [ViewType.DIALOG_VIEW, 'SCBDialogView'],
  [ViewType.PLUGIN_USB, 'USBPanel'],
  [ViewType.EXPAND_GUIDE_BOX, 'expandGuidBox'],
  [ViewType.MEDIA_PLAY_PANEL, 'SCBMediaPlayPanel'],
  [ViewType.VIRTUAL_STATUS_BAR, 'SCBVirtualStatusBar'],
  [ViewType.PC_SUPER_PRIVACY_PANEL, 'PCSuperPrivacyPanel'],
  [ViewType.PC_PADDLE_SUPER_PRIVACY_PANEL, 'PCPaddleSuperPrivacyPanel'],
  [ViewType.SCREENLOCK_STATUS_BAR, 'SCBScreenLockStatusBar'],
]);

/**
 * View Area.unit vp
 */
export interface ViewArea {
  left: number;
  top: number;
  width: number;
  height: number;
}

/**
 * 内存回收接口定义, 从 MemoryManager 中迁移过来的
 */
export interface Recyclable {
  /**
   * 执行内存回收接口调用
   *
   * @param level 内存回收级别
   * @param reason 内存回收原因
   */
  onTrimMemory(level: TrimLevel, reason: string): void;
}

/**
 * 内存回收级别， 从 MemoryManager 中迁移过来的
 */
export enum TrimLevel {
  /**
   * 轻度回收,回收一些后台场景用不到的临时资源
   */
  LIGHT = 0,

  /** 重度回收,整机内存低,回收大部分可回收的临时资源 */
  COMPLETE = 1,

  /** 彻底回收,整机内存极低,回收所有可回收资源,避免进程查杀 */
  CRITICAL = 2,
}

/**
 * 组件控制器
 */
export interface ViewController extends Recyclable {
  show(isFocusableOnShow?: boolean): void;
  hide(): void;
  updateOpacity(opacity: number) : void;
  setZIndex(zIndex: number, updateKeyguardOccludeState: boolean): void;
  destroy;
  isShowing(): boolean;
  updateId(persistentId: number): void;
  updateArea(area: ViewArea): void;
  updateRect(area: ViewArea): void;
  getId(): number;
  getArea(): ViewArea;
  setViewData(data: PluginInfo): void;
  getViewData(): PluginInfo;
  setTranslate(x: number, y: number, z: number): void;
  setOpacity(blur: number): void;
  setZIndex(zIndex: number): void;
  getZIndex(): number | undefined;
  registerCallback(viewCallback:ViewCallback): void;
  unRegisterCallback(viewCallback: ViewCallback): void;
  getPersistentId(): number;
  getScreenId(): number | undefined;
  dealTouchOutSide(): boolean;
}

/**
 * 0级控件通知机制显隐管理
 */
export interface ViewCallback {
  onShow?: Function;
  onHide?: Function;
  onGainFocus?: Function;
  onLoseFocus?: Function;

  // 轻度内存回收回调接口:回收一些后台场景用不到的临时资源
  onTrimMemory? : (level: TrimLevel) => void;


  onHeightChange?: Function;
}

/**
 * 组件控制管理
 */
class ViewManagerPolicy {
  /**
   * 组件控制器
   * 组件名 => 组件控制器
   */
  private viewControllers: Map<ViewType | string, ViewController> = new Map();
  private viewCallbackMap: Map<ViewType | string, Array<ViewCallback>> = new Map();
  private gestureCallBackMap: Map<number, Map<number, Function>> = new Map();

  public constructor() {
    this.registerDebug();
  }

  private registerDebug(): void {
    const debugCommand: DebugCommand[] = [
      {
        cmdName: 'isViewShowing',
        callback: (args: Array<string>): string => {
          try {
            let params: number[] = args.map(Number);
            let isShowing: boolean = this.isViewShowing(params[0]);
            let name: string = VIEW_TAG.get(params[0]) ?? `unknwnType ${params[0]}`;
            return `view ${name} is ` + (isShowing ? 'showing' : 'not showing');
          } catch (error) {
            log.showWarn(TAG, `isViewShowing failed, code:${error?.code} msg:${error?.message}`);
            return 'failed';
          }
        }
      },
      {
        cmdName: 'reportSystemSceneState',
        callback: (args: Array<string>): string => {
          this.reportSystemSceneState();
          return 'report finish';
        }
      },
    ];
    DebugCommandManager.getInstance().register(TAG, debugCommand);
  }

  registerViewController(viewType: ViewType | string, controller: ViewController): void {
    this.viewControllers.set(viewType, controller);
    this.viewCallbackMap.get(viewType)?.forEach((item: ViewCallback) => {
      controller.registerCallback(item);
    });
    log.showInfo(TAG, `registerViewController ${this.readableViewType(viewType)}`);
  }

  unregisterViewController(viewType: ViewType | string): void {
    this.viewControllers.delete(viewType);
    if (!this.viewCallbackMap.has(viewType)) {
      return;
    }
    this.viewCallbackMap.delete(viewType);
    log.showInfo(TAG, `unregisterViewController ${this.readableViewType(viewType)}`);
  }

  public gestureCallback(eventId: number, persistentId: number): void {
    log.showDebug(TAG, `gestureCallback...eventId = ${eventId} presistentId = ${persistentId}`);
    if (!this.gestureCallBackMap.has(eventId)) {
      log.showError(TAG, `No scene func: ${eventId} has registered!`);
      return;
    }
    let eventFuncMap = this.gestureCallBackMap.get(eventId);
    if (!eventFuncMap?.get(persistentId)) {
      log.showError(TAG, `No scene func: ${persistentId} has registered!`);
      return;
    }
    let eventFun = eventFuncMap.get(persistentId);
    eventFun && eventFun();
  }

  public onGestureCallback(eventId: number, persistentId: number, callback: Function): void {
    log.showDebug(TAG, `onGestureCallback...eventId = ${eventId} presistentId = ${persistentId}`);
    if (!this.gestureCallBackMap.has(eventId)) {
      log.showWarn(TAG, `callbackType: ${eventId} not exists!`);
      this.gestureCallBackMap.set(eventId, new Map());
    }
    let eventFuncMap = this.gestureCallBackMap.get(eventId);
    if (eventFuncMap?.get(persistentId)) {
      log.showError(TAG, `${eventId} with callbackType: ${persistentId} alreay exists.`);
      return;
    }
    log.showInfo(TAG, `Register func type:${eventId} with screenId: ${persistentId} success.`);
    eventFuncMap?.set(persistentId, callback);
  }

  public offGestureCallback(eventId: number, persistentId: number): void {
    log.showDebug(TAG, `offGestureCallback...eventId = ${eventId} presistentId = ${persistentId}`);
    let eventFuncMap = this.gestureCallBackMap.get(eventId);
    if (!eventFuncMap?.get(persistentId)) {
      log.showError(TAG, `${eventId} with callbackType: ${persistentId} not exists.`);
      return;
    }
    log.showInfo(TAG, `UnRegister func type:${eventId} with persistentId: ${persistentId} success.`);
    eventFuncMap?.delete(persistentId);
  }

  getViewController(viewType: ViewType | string): ViewController | undefined {
    return this.viewControllers.get(viewType);
  }

  registerViewCallback(viewType: ViewType | string, callback: ViewCallback): void {
    log.showInfo(TAG, 'registerViewCallback');
    let viewCallbackArray = this.viewCallbackMap.get(viewType);
    if (!viewCallbackArray) {
      viewCallbackArray = new Array<ViewCallback>();
    }
    viewCallbackArray.push(callback);
    this.viewCallbackMap.set(viewType, viewCallbackArray);
    let controller = this.getViewController(viewType);
    if (controller !== null && controller !== undefined) {
      controller.registerCallback(callback);
    }
  }

  unRegisterViewCallback(viewType: ViewType | string, callback: ViewCallback): void {
    log.showDebug(TAG, 'unRegisterViewCallback');
    let controller = this.getViewController(viewType);
    if (controller !== null && controller !== undefined ) {
      controller.unRegisterCallback(callback);
    }
    let viewCallbackArray = this.viewCallbackMap.get(viewType);
    if (!viewCallbackArray) {
      return;
    }
    let index = viewCallbackArray.indexOf(callback);
    if (index === -1) {
      return;
    } else {
      viewCallbackArray.splice(index, 1);
    }
    this.viewCallbackMap.set(viewType, viewCallbackArray);
  }

  notifyViewGainFocus(id: number): void {
    let viewCallbackArray = this.viewCallbackMap.get(this.getViewTypeById(id));
    if (!viewCallbackArray) {
      return;
    }
    log.showInfo(TAG, `${id} notifyViewGainFocus`);
    viewCallbackArray.forEach((item: ViewCallback) => {
      item?.onGainFocus?.();
    });
  }

  notifyViewLoseFocus(id: number): void {
    let viewCallbackArray = this.viewCallbackMap.get(this.getViewTypeById(id));
    if (!viewCallbackArray) {
      return;
    }
    log.showInfo(TAG, `${id} notifyViewLoseFocus`);
    viewCallbackArray.forEach((item: ViewCallback) => {
      item?.onLoseFocus?.();
    });
  }

  public getViewTypeById(id: number): ViewType | string {
    let viewType: ViewType | string = '';
    this.viewControllers.forEach((item, key) => {
      if (item.getId() === id) {
        viewType = key;
      }
    });
    return viewType;
  }

  showView(viewType: ViewType | string, isFocusableOnShow = true): void {
    if (!this.viewControllers.has(viewType)) {
      log.showInfo(TAG, `View ${this.readableViewType(viewType)} not registerController`);
    }
    this.viewControllers.get(viewType)?.show(isFocusableOnShow);
    log.showDebug(TAG, `showView ${this.readableViewType(viewType)}`);
  }

  dealTouchOutSide(viewType: ViewType | string): boolean {
    let controller = this.viewControllers.get(viewType);
    if (controller === null || controller === undefined) {
      log.showInfo(TAG, `View ${this.readableViewType(viewType)} not registerController`);
      return false;
    }
    return controller.dealTouchOutSide();
  }

  hideView(viewType: ViewType | string): void {
    this.viewControllers.get(viewType)?.hide();
    log.showDebug(TAG, `hideView ${this.readableViewType(viewType)}`);
  }

  destroyView(viewType: ViewType | string): void {
    this.viewControllers.get(viewType)?.destroy();
    log.showInfo(TAG, `destroyView ${this.readableViewType(viewType)}`);
  }

  isViewShowing(viewType: ViewType | string): boolean {
    let controller = this.viewControllers.get(viewType);
    if (controller === null || controller === undefined) {
      log.showInfo(TAG, `View ${this.readableViewType(viewType)} not registerController`);
      return false;
    }
    return controller.isShowing();
  }

  getArea(viewType: ViewType | string): ViewArea {
    let controller = this.viewControllers.get(viewType);
    if (controller === null || controller === undefined) {
      log.showInfo(TAG, `View ${this.readableViewType(viewType)} not registerController`);
      let defaultViewArea: ViewArea = {
        left: 0,
        top: 0,
        width: 0,
        height: 0
      };
      return defaultViewArea;
    }
    return controller.getArea();
  }

  setViewData(viewType: ViewType | string, data: PluginInfo): void {
    this.viewControllers.get(viewType)?.setViewData(data);
  }

  getViewData(viewType: ViewType | string): PluginInfo | undefined {
    return this.viewControllers.get(viewType)?.getViewData();
  }

  readableViewType(viewType: ViewType | string): string {
    return ViewType[viewType] ?? viewType;
  }

  updateOpacity(viewType: ViewType | string, opacity: number): void {
    log.showInfo(TAG, `updateOpacity opacity: ${opacity}`);
    let controller = this.getViewController(viewType);
    if (controller === null || controller === undefined) {
      log.showWarn(TAG, 'updateOpacity find controller not exists!');
      return;
    }
    controller.updateOpacity(opacity);
  }

  setZIndex(viewType: ViewType | string, zIndex: number): void {
    this.viewControllers.get(viewType)?.setZIndex(zIndex);
  }

  getZIndex(viewType: ViewType | string): number | undefined {
    return this.viewControllers.get(viewType)?.getZIndex();
  }

  /**
   * 获取所有0级控件显隐状态。
   */
  getSystemSceneState(): void {
    let systemSceneMap = new Map<ViewType, string>();
    systemSceneMap.set(ViewType.DESKTOP, 'hide');
    systemSceneMap.set(ViewType.SYSTEM_PANEL, 'hide');
    systemSceneMap.set(ViewType.NOTIFICATION_CENTER, 'hide');
    systemSceneMap.set(ViewType.CONTROL_CENTER, 'hide');
    systemSceneMap.set(ViewType.KEYGUARD, 'hide');
    systemSceneMap.set(ViewType.NEGATIVE_SCREEN, 'hide');
    systemSceneMap.set(ViewType.GLOBAL_SEARCH, 'hide');

    systemSceneMap.forEach((value, key) => {
      if (this.viewControllers.get(key)?.isShowing()) {
        systemSceneMap.set(key, 'show');
      } else {
        systemSceneMap.set(key, 'hide');
      }
    });
    log.showInfo(TAG, `Home:${systemSceneMap.get(ViewType.DESKTOP)}, SysUI:${systemSceneMap.get(ViewType.SYSTEM_PANEL)},` +
      `NC:${systemSceneMap.get(ViewType.NOTIFICATION_CENTER)},CC:${systemSceneMap.get(ViewType.CONTROL_CENTER)},` +
      `KG:${systemSceneMap.get(ViewType.KEYGUARD)},AA:${systemSceneMap.get(ViewType.NEGATIVE_SCREEN)},` +
      `Search:${systemSceneMap.get(ViewType.GLOBAL_SEARCH)}`);
  }

  /**
   * 0级控件显隐状态打点
   */
  public reportSystemSceneState(): void {
    let systemSceneState: string = '';
    this.viewControllers.forEach((value: ViewController, key: ViewType | string) => {
      let isShowing: boolean = value.isShowing() ?? false;
      if (typeof key === 'string') {
        systemSceneState += `${key}:${isShowing}, `;
      } else if (VIEW_TAG.has(key)) {
        systemSceneState += `${VIEW_TAG.get(key)}:${isShowing}, `;
      } else {
        systemSceneState += `unknownType${key}:${isShowing}, `;
      }
    });
    log.showInfo(TAG, `report system scene state: ${systemSceneState}`);
    HiSysEventUtil.reportSystemSceneStateEvent(systemSceneState);
  }
}

// 单例
export const viewMgrPolicy = SingletonHelper.getInstance(ViewManagerPolicy, TAG);
export default viewMgrPolicy;