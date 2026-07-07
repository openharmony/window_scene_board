/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import InputConsumer from '@ohos.multimodalInput.inputConsumer';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { KeyCodeConstants } from '@ohos/commonconstants';
import { CEManager, DeviceHelper, NavBarEventType, ViewArea, ViewCallback, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { commonEventManager } from '@kit.BasicServicesKit';
import { SCBKioskModeManager } from '../scene/kiosk/SCBKioskModeManager';

const TAG = 'SCBGestureManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);
const GESTURE_NAVIGATION_ENABLED_CHANGE = 'gestureNavigationEnabledChange';
const COMMAND_ITEM_LENGTH = 30;
const COMMAND_LINE_LENGTH = 150;

export enum GestureNavigationState {
  START,
  UPDATE,
  END,
  CANCEL
}

export enum GestureType {
  BACK = 'BACK',
  NAVIGATION = 'NAVIGATION',
  PC_BACK = 'PC_BACK',
  PC_BACK_FLOAT = 'PC_BACK_FLOAT'
}

export enum PcKeyType {
  HOME,
  RECENT,
  BACK,
  BACK_FLOAT,
  ESC
}

export enum GestureEnableCaller {
  WATCH_SCENE_PANEL = 'WATCH_SCENE_PANEL',
  OOBE = 'OOBE',
  SYSTEM_DIALOG = 'SYSTEM_DIALOG',
  SCREEN_LOCK = 'SCREEN_LOCK',
  KIOSK_MODE = 'KIOSK_MODE',
  SAMPLE_MANAGEMENT = 'com.ohos.samplemanagement',
  PROJECT_MENU = 'com.ohos.projectmenu',
  MMI_TEST = 'com.ohos.mmitest',
  MMI_AUTOTEST = 'com.ohos.mmiautotest',
  RUNNING_TEST = 'com.ohos.runningtest',
  HI_VIEW = 'hiview',
  VISION_GLASS = 'com.ohos.visionglass',
  CAST_UI = 'com.ohos.hwprojectionclient',
  ADMIN_PROVISIONING = 'com.ohos.adminprovisioning'
}

export enum GestureEnableType {
  BACK,
  NAVIGATION,
  ALL
}

/**
 * 手势事件发送的事件参数
 */
class GestureEventParam {

  /*
   * 是否锁屏状态
   */
  public isScreenLock: boolean = false;

}
/**
 * Manager for Gesture Navigation Status
 */
class SCBGestureManager {

  private isEnable: boolean = true;
  private isBackEnable: boolean = true;
  private isNavBarEnable: boolean = true;
  private isEnableCallBackMap: Map<GestureType, Function> = new Map();
  private gestureEnableMap: Map<string, [boolean, boolean, boolean, string]> = new Map();
  // 底部手势区域使能键值对
  private gestureNavBarEnableMap: Map<string, boolean> = new Map();
  // 侧边手势区域使能键值对
  private gestureBackEnableMap: Map<string, boolean> = new Map();
  private gestureEventCallBack: Map<GestureType, Map<string, Function>> = new Map();
  private touchEventCallBack: Map<GestureType, Map<string, Function>> = new Map();
  // 手势Home、Recent、Back事件键值对
  private gestureCallBackMap: Map<number, Map<number, Function>> = new Map();
  private aiBarRect: ViewArea = { left: 0, top: 0, width: 0, height: 0 };
  private pcKeyEventCallBack: Map<string, Function> = new Map();
  private aiBarChangeAnimCallBack: Function;
  private enableStateChangeCallBack: Function;

  // win + backspace, eg KEYCODE_BACK
  private winBackspaceOption = {
    preKeys: [KeyCodeConstants.KEYCODE_WIN],
    finalKey: KeyCode.KEYCODE_DEL,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  private winBackOption = {
    preKeys: [],
    finalKey: KeyCodeConstants.KEYCODE_BACK,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  private winFloatBackOption = {
    preKeys: [],
    finalKey: KeyCodeConstants.KEYCODE_BACK_FLOAT,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  private winRecentOption = {
    preKeys: [],
    finalKey: KeyCodeConstants.KEYCODE_RECENT,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };


  // win + D, home gesture
  private winDOption = {
    preKeys: [KeyCodeConstants.KEYCODE_WIN],
    finalKey: KeyCodeConstants.KEYCODE_D,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  // win + tab DOWN, recent gesture
  private winTabOption = {
    preKeys: [KeyCodeConstants.KEYCODE_WIN],
    finalKey: KeyCodeConstants.KEYCODE_TAB,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  // fn + 0 DOWN, recent gesture
  private fn0Option = {
    preKeys: [],
    finalKey: KeyCodeConstants.KEYCODE_FN_0,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  // WIN + DPAD_UP Down, recent gesture
  private winDpapUPOption = {
    preKeys: [KeyCodeConstants.KEYCODE_WIN],
    finalKey: KeyCodeConstants.KEYCODE_DPAD_UP,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  private escOption = {
    preKeys: [],
    finalKey: KeyCode.KEYCODE_ESCAPE,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0,
    isRepeat: false
  };

  /**
   * get GestureNavManager instance
   *
   * @return GestureNavManager singleton
   */
  static getInstance(): SCBGestureManager {
    if (globalThis.SCBGestureManager == null) {
      globalThis.SCBGestureManager = new SCBGestureManager();
    }
    return globalThis.SCBGestureManager;
  }

  /**
   * registerGestureNavigationEnabledChange from c++
   */
  public initGestureNavigationManager(): void {
    log.showInfo('initGestureNavigationManager');
    this.registerGestureNavigationEnabledChange();
    this.registerPCKey();
    this.registerDesktopFocusListener();
    this.registerKioskModeChangeCallback();
    this.registerDebugCommands();
  }

  public destroyGestureNavigationManager(): void {
    log.showInfo('destroyGestureNavigationManager');
    InputConsumer.off('key', this.winBackOption);
    InputConsumer.off('key', this.winFloatBackOption);
    InputConsumer.off('key', this.winBackspaceOption);
    this.unRegisterPublicPcKey();
    this.unRegisterKioskModeChangeCallback();
  }

  public registerPcKeyCallback(sceneType: string, callback: Function): void {
    log.showInfo(`${sceneType} registerPcKeyCallback`);
    this.pcKeyEventCallBack.set(sceneType, callback);
  }

  public unregisterPcKeyCallback(sceneType: string): void {
    if (this.pcKeyEventCallBack.has(sceneType)) {
      this.pcKeyEventCallBack.delete(sceneType);
    } else {
      log.showInfo(`${sceneType} has not unregisterPcKeyCallback`);
    }
  }

  /**
   * registerGestureNavigationEnabledChange from c++
   */
  public registerGestureNavigationEnabledChange(): void {
    log.showInfo('registerGestureNavigationEnabledChange');
    sceneSessionManager.on(GESTURE_NAVIGATION_ENABLED_CHANGE, this.onGestureNavigationEnabledChange.bind(this));
  }

  /**
   * register GestureEnable Callback
   * @param type
   * @param callback
   */
  public registerGestureEnabledCallback(type: GestureType, callback: Function): void {
    log.showInfo(`${type} registerGestureEnabledCallback`);
    this.isEnableCallBackMap.set(type, callback);
    switch (type) {
      case GestureType.BACK:
        callback?.(this.isBackEnable);
        break;
      case GestureType.NAVIGATION:
        callback?.(this.isNavBarEnable);
        break;
      default:
        break;
    }
  }

  /**
   *  unregister GestureEnable Callback
   * @param type
   */
  public unRegisterGestureEnabledCallback(type: GestureType): void {
    if (this.isEnableCallBackMap.has(type)) {
      this.isEnableCallBackMap.delete(type);
    } else {
      log.showInfo(`${type} has not registerGestureEnabledCallback`);
    }
  }

  /**
   * 注册应用信息更新监听器
   */
  public registerDesktopFocusListener(): void {
    viewMgrPolicy.registerViewCallback(ViewType.DESKTOP, this.desktopFocusCallback);
  }

  /**
   * 注册Kiosk模式变化
   */
  public registerKioskModeChangeCallback(): void {
    SCBKioskModeManager.getInstance().registerKioskModeChangeEvent(TAG, (isKioskMode: boolean) => {
      log.showInfo(`Kiosk mode changed, isKioskMode:${isKioskMode}`);
      this.setGestureNavigationEnable(GestureEnableCaller.KIOSK_MODE, true, !isKioskMode);
    });
  }

  /**
   * 反注册Kiosk模式变化
   */
  public unRegisterKioskModeChangeCallback(): void {
    SCBKioskModeManager.getInstance().unregisterKioskModeChangeEvent(TAG);
  }

  private desktopFocusCallback: ViewCallback = {
    onGainFocus: ():void => {
      log.showInfo('onGainFocus');
      this.resetThirdAppEnable();
    },
    onLoseFocus: ():void => {
      log.showInfo('onLoseFocus');
    },
  };

  /**
   * isGestureNavigationEnable
   *
   * @return false or true
   */
  public isGestureBackEnable(): boolean {
    return this.isBackEnable;
  }

  /**
   * 底部手势导航是否可用
   *
   * @returns false or true
   */
  public isGestureNavBarEnable(): boolean {
    return this.isNavBarEnable;
  }

  /**
   * 底部手势导航和back手势整体是否可用
   *
   * @returns false or true
   */
  public isGestureEnable(): boolean {
    return this.isEnable;
  }

  /**
   * SceneBoard内部使能手势接口
   *
   * @param caller 调用方识别
   * @param isGestureBackEnable 侧边手势区域使能
   * @param isGestureNavbarEnable 底部手势区域使能
   */
  public setGestureNavigationEnable(caller: GestureEnableCaller, isGestureBackEnable: boolean,
                                    isGestureNavbarEnable: boolean): void {
    log.showInfo('setGestureNavigationEnable, caller=%{public}s, isBackEnable=%{public}s, ' +
      'isBottomEnable=%{public}s', caller, isGestureBackEnable, isGestureNavbarEnable);
    this.processGestureEnable(caller, isGestureBackEnable, isGestureNavbarEnable, false);
  }

  /**
   * SceneBoard内部使能手势高优先级接口, 仅锁屏场景使用，防止滥用
   *
   * @param caller 调用方识别
   * @param isGestureBackEnable 侧边手势区域使能
   * @param isGestureNavbarEnable 底部手势区域使能
   */
  public setGestureNavigationEnablePriority(caller: GestureEnableCaller, isGestureBackEnable: boolean,
                                            isGestureNavbarEnable: boolean): void {
    log.showInfo('setGestureNavEnablePriority, caller=%{public}s, isBackEnable=%{public}s, ' +
      'isBottomEnable=%{public}s', caller, isGestureBackEnable, isGestureNavbarEnable);
    this.processGestureEnable(caller, isGestureBackEnable, isGestureNavbarEnable, true);
  }

  /**
   * SceneBoard外部应用（如：样机管理）通过窗口接口使能手势接口
   *
   * @param enable 手势是否使能 （当前只能同时禁用/解禁back手势和底部上滑）
   * @param type 对外开放：  0：使能back 1：使能底部导航(暂不支持)
   *             对内部开放： 2：使能全部(只对独立系统应用)
   */
  private onGestureNavigationEnabledChange(enable: boolean, caller: string, type: number): void {
    log.showInfo(`onGestureNavigationEnabledChange. caller=${caller}, enable=${enable}, type=${type}`);
    switch (type) {
      case GestureEnableType.BACK:
        // 0：使能back 不做白名单校验
        this.processGestureEnable(caller, enable, true, false);
        break;
      case GestureEnableType.ALL:
        // 2: 使能全部 进行白名单校验
        if (this.isSystemAppCaller(caller)) {
          this.processGestureEnable(caller, enable, enable, false);
        } else {
          log.showWarn(`onGestureNavigationEnabledChange. caller=${caller} is invalid`);
        }
        break;
      default:
        log.showWarn(`onGestureNavigationEnabledChange. type is invalid`);
        break;
    }
  }

  /**
   * 重置三方应用的使能（非独立系统应用），当前只重置Back使能部分
   */
  private resetThirdAppEnable(): void {
    log.showInfo(`resetThirdAppEnable.`);
    this.gestureBackEnableMap.forEach((enbale: boolean, caller: string) => {
      // 如果是三方应用禁用back手势，则恢复back手势
      if (this.isThirdAppCaller(caller) && !enbale) {
        log.showInfo(`resetThirdAppEnable. caller is ${caller}`);
        this.processGestureEnable(caller, true, true, false);
      }
    });
  }

  /**
   * 手势使能
   *
   * @param caller
   * @param isGestureBackEnable
   * @param isGestureNavbarEnable
   * @param isPriority
   */
  private processGestureEnable(caller: string, isGestureBackEnable: boolean, isGestureNavbarEnable: boolean, isPriority: boolean): void {
    let backEnable = isGestureBackEnable;
    let navBarEnable = isGestureNavbarEnable;
    this.gestureEnableMap.set(caller, [backEnable, navBarEnable, isPriority, this.getTime()]);
    this.gestureBackEnableMap.set(caller, backEnable);
    this.gestureNavBarEnableMap.set(caller, navBarEnable);
    if (!isPriority) {
      backEnable = this.checkGestureEnable(GestureType.BACK, this.gestureBackEnableMap);
      navBarEnable = this.checkGestureEnable(GestureType.NAVIGATION, this.gestureNavBarEnableMap);
    }
    // 当前手势是否可用信息，对外不区分底部或者back
    this.isBackEnable = backEnable;
    this.isNavBarEnable = navBarEnable;
    this.isEnable = backEnable || navBarEnable;
    if (this.enableStateChangeCallBack) {
      this.enableStateChangeCallBack(this.isNavBarEnable, caller);
    }
    log.showInfo('processGestureEnable caller %{public}s, isBackEnable %{public}s, isBottomEnable %{public}s,' +
      'result:backEnable %{public}s bottomEnable %{public}s', caller, isGestureBackEnable, isGestureNavbarEnable, backEnable,
      navBarEnable);
    this.isEnableCallBackMap?.get(GestureType.BACK)?.(backEnable);
    this.isEnableCallBackMap?.get(GestureType.NAVIGATION)?.(navBarEnable);
  }

  private checkGestureEnable(gestureType: GestureType, callerEnableMap: Map<string, boolean>): boolean {
    // 只要有一个应用在禁用手势，则手势禁用
    let isGestureEnable: boolean = true;
    callerEnableMap.forEach((value: boolean, key: string) => {
      if (!value) {
        log.showInfo(`${key} set ${gestureType} ${value}.`);
        isGestureEnable = false;
      }
    });
    // 所有调用方都解禁手势后，则手势使能
    return isGestureEnable;
  }

  /**
   * 是否是三方应用
   *
   * @param caller
   * @returns
   */
  private isThirdAppCaller(caller: string): boolean {
    if (this.isSystemAppCaller(caller)) {
      log.showWarn(`caller is system app caller.`);
      return false;
    }
    if (this.getSceneBoardCallerByString(caller) !== undefined) {
      log.showWarn(`caller is SceneBoard caller.`);
      return false;
    }
    return true;
  }

  /**
   * 是否是独立系统应用
   *
   * @param caller
   * @returns
   */
  private isSystemAppCaller(caller: string): boolean {
    switch (caller) {
      case GestureEnableCaller.SAMPLE_MANAGEMENT:
      case GestureEnableCaller.MMI_TEST:
      case GestureEnableCaller.PROJECT_MENU:
      case GestureEnableCaller.MMI_AUTOTEST:
      case GestureEnableCaller.RUNNING_TEST:
      case GestureEnableCaller.CAST_UI:
      case GestureEnableCaller.HI_VIEW:
      case GestureEnableCaller.VISION_GLASS:
      case GestureEnableCaller.ADMIN_PROVISIONING:
        return true;
      default:
        return false;
    }
  }

  /**
   * 获取SceneBoard内调用的模块Caller
   *
   * @param caller
   * @returns
   */
  private getSceneBoardCallerByString(caller: string): GestureEnableCaller | undefined {
    switch (caller) {
      case GestureEnableCaller.WATCH_SCENE_PANEL:
        return GestureEnableCaller.WATCH_SCENE_PANEL;
      case GestureEnableCaller.OOBE:
        return GestureEnableCaller.OOBE;
      case GestureEnableCaller.SYSTEM_DIALOG:
        return GestureEnableCaller.SYSTEM_DIALOG;
      case GestureEnableCaller.SCREEN_LOCK:
        return GestureEnableCaller.SCREEN_LOCK;
      case GestureEnableCaller.KIOSK_MODE:
        return GestureEnableCaller.KIOSK_MODE;
      default:
        return undefined;
    }
  }

  /**
   * registerGestureEvent
   * @param gestureType
   * @param sceneType
   * @param callBack
   */
  public registerGestureEvent(gestureType: GestureType, sceneType: string, callBack: Function): void {
    if (!this.gestureEventCallBack.has(gestureType)) {
      this.gestureEventCallBack.set(gestureType, new Map());
    }
    let sceneTypeCallBackMap = this.gestureEventCallBack.get(gestureType);
    if (sceneTypeCallBackMap.get(sceneType)) {
      log.showError(`sceneType=${sceneType} alreay exists`);
      return;
    }
    log.showInfo(`register gestureType=${gestureType} with sceneType=${sceneType} success`);
    sceneTypeCallBackMap.set(sceneType, callBack);
  }

  public unRegisterGestureEvent(gestureType: GestureType, sceneType: string): void {
    if (!this.gestureEventCallBack.has(gestureType)) {
      log.showInfo(`unRegister gestureType=${gestureType} error, no such gestureType`);
      return;
    }
    let sceneTypeCallBackMap = this.gestureEventCallBack.get(gestureType);
    if (sceneTypeCallBackMap.get(sceneType)) {
      sceneTypeCallBackMap.delete(sceneType);
      log.showInfo(`unRegister gestureType=${gestureType} with sceneType=${sceneType} success`);
    }
  }

  public registerTouchEvent(gestureType: GestureType, sceneType: string, callBack: Function): void {
    if (!this.touchEventCallBack.has(gestureType)) {
      this.touchEventCallBack.set(gestureType, new Map());
    }
    let sceneTypeCallBackMap = this.touchEventCallBack.get(gestureType);
    if (sceneTypeCallBackMap.get(sceneType)) {
      log.showError(`sceneType=${sceneType} alreay exists`);
      return;
    }
    log.showInfo(`register gestureType=${gestureType} with sceneType=${sceneType} success`);
    sceneTypeCallBackMap.set(sceneType, callBack);
  }

  public unRegisterTouchEvent(gestureType: GestureType, sceneType: string): void {
    if (!this.touchEventCallBack.has(gestureType)) {
      log.showInfo(`unRegister gestureType=${gestureType} error, no such gestureType`);
      return;
    }
    let sceneTypeCallBackMap = this.touchEventCallBack.get(gestureType);
    if (sceneTypeCallBackMap.get(sceneType)) {
      sceneTypeCallBackMap.delete(sceneType);
      log.showInfo(`unRegister gestureType=${gestureType} with sceneType=${sceneType} success`);
    }
  }

  public onTouchEvent(gestureType: GestureType, sceneType: string, event?: TouchEvent): void {
    let callback = this.touchEventCallBack.get(gestureType)?.get(sceneType);
    callback?.(event);
  }

  /**
   * notify gesture event
   * @param gestureType
   * @param sceneType
   * @param navigationState for navigationbar state
   * @param event navigationbar gesture event
   */
  public onGestureEvent(gestureType: GestureType, sceneType: string, navigationState?: number, event?: GestureEvent): void {
    let callback = this.gestureEventCallBack.get(gestureType)?.get(sceneType);
    callback?.(navigationState, event);
  }

  public gestureEventCallback(eventId: number): void {
    log.showInfo(`gestureEventCallback...eventId = ${eventId}`);
    if (!this.gestureCallBackMap.has(eventId)) {
      log.showError(`No scene func: ${eventId} has registered!`);
      return;
    }
    let eventFuncMap = this.gestureCallBackMap.get(eventId);

    let gestureEventParams = new GestureEventParam();
    gestureEventParams.isScreenLock = viewMgrPolicy.isViewShowing(ViewType.KEYGUARD);
    log.showInfo(`gestureEventCallback...params: isScreenLock = ${gestureEventParams.isScreenLock}`);
    eventFuncMap?.forEach((value: Function, key: number) => {
      value?.(gestureEventParams);
    });
  }

  public onGestureEventCallback(eventId: number, persistentId: number, callback: Function): void {
    log.showInfo(`onGestureEventCallback...eventId = ${eventId} presistentId = ${persistentId}`);
    if (!this.gestureCallBackMap.has(eventId)) {
      log.showWarn(`callbackType: ${eventId} not exists!`);
      this.gestureCallBackMap.set(eventId, new Map());
    }
    let eventFuncMap = this.gestureCallBackMap.get(eventId);
    if (eventFuncMap?.get(persistentId)) {
      log.showError(`${eventId} with callbackType: ${persistentId} alreay exists.`);
      return;
    }
    log.showInfo(`Register func type:${eventId} with screenId: ${persistentId} success.`);
    eventFuncMap?.set(persistentId, callback);
  }

  public setAiBarRect(areaRect: ViewArea): void {
    this.aiBarRect = areaRect;
  }

  /**
   * get ai bar rect in vp
   *
   * @return rect
   */
  public getAiBarRect(): ViewArea {
    return this.aiBarRect;
  }

  /**
   * unRegister AiBarChangeAnim Callback
   *
   * @param callback
   */
  public unRegisterAiBarChangeAnim(): void {
    this.aiBarChangeAnimCallBack = null;
  }

  public registerAiBarChangeAnim(callback: Function): void {
    this.aiBarChangeAnimCallBack = callback;
  }

  public registerGestureEnableStateChange(callback: Function): void {
    this.enableStateChangeCallBack = callback;
  }

  public unRegisterGestureEnableStateChange(): void {
    this.enableStateChangeCallBack = null;
  }

  public aiBarChange(type: number): void {
    if (this.aiBarChangeAnimCallBack) {
      this.aiBarChangeAnimCallBack(type);
    }
  }

  private registerPCKey(): void {
    InputConsumer.on('key', this.winBackOption, (data) => {
      this.pcKeyEventCallBack?.forEach((item: Function) => {
        item(PcKeyType.BACK);
      });
    });

    InputConsumer.on('key', this.winFloatBackOption, (data) => {
      this.pcKeyEventCallBack?.forEach((item: Function) => {
        item(PcKeyType.BACK_FLOAT);
      });
    });

    InputConsumer.on('key', this.winBackspaceOption, (data) => {
      HiSysEventUtil.reportKey('usual.event.EVENT_WIN_BACKSPACE');
      this.pcKeyEventCallBack?.forEach((item: Function) => {
        item(PcKeyType.BACK);
      });
    });

    InputConsumer.on('key', this.winRecentOption, (data) => {
      this.publishScenePanelEventMsg(CEManager.CUSTOM_NAVBAR_EVENT, NavBarEventType.EXECUTE_RECENT);
      this.pcKeyEventCallBack?.forEach((item: Function) => {
        item(PcKeyType.RECENT);
      });
    });

    this.registerPublicKey();
  }

  public registerPublicKey(): void {
    this.registerWinDEvent();
    this.registerWinTabEvent();
    this.registerWinDpapUPEvent();
    this.registerEscEvent();
    if (DeviceHelper.isPhone()) {
      this.registerFn0Event();
    }
  }

  public unRegisterPublicPcKey(): void {
    InputConsumer.off('key', this.winDOption);
    InputConsumer.off('key', this.winTabOption);
    InputConsumer.off('key', this.winDpapUPOption);
    InputConsumer.off('key', this.escOption);
    if (DeviceHelper.isPhone()) {
      InputConsumer.off('key', this.fn0Option);
    }
  }

  private registerWinDEvent(): void {
    InputConsumer.on('key', this.winDOption, (data) => {
      HiSysEventUtil.reportKey('usual.event.EVENT_WIN_D');
      this.pcKeyEventCallBack?.forEach((item: Function) => {
        item(PcKeyType.HOME);
      });
    });
  }

  private registerWinTabEvent(): void {
    InputConsumer.on('key', this.winTabOption, (data) => {
      HiSysEventUtil.reportKey('usual.event.WIN_TAB');
      this.pcKeyEventCallBack?.forEach((item: Function) => {
        item(PcKeyType.RECENT);
      });
    });
  }

  private registerFn0Event(): void {
    InputConsumer.on('key', this.fn0Option, (data) => {
      HiSysEventUtil.reportKey('usual.event.FN_0');
      this.pcKeyEventCallBack?.forEach((item: Function) => {
        item(PcKeyType.RECENT);
      });
    });
  }

  private registerWinDpapUPEvent(): void {
    InputConsumer.on('key', this.winDpapUPOption, (data) => {
      HiSysEventUtil.reportKey('usual.event.WIN_DPAD_UP');
    });
  }

  private registerEscEvent(): void {
    InputConsumer.on('key', this.escOption, (data) => {
      this.pcKeyEventCallBack?.forEach((item: Function) => {
        item(PcKeyType.ESC);
      });
    });
  }

  private registerDebugCommands(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'getAllGestureEnableCaller',
        callback: (args: Array<string>): string => {
          return this.debugGestureEnableCaller();
        }
      },
      {
        cmdName: 'setGestureNavigationEnable',
        callback: (args: Array<string>): string => {
          return this.debugSetGestureNavigationEnable(args);
        }
      },
    ];
    DebugCommandManager.getInstance().register(TAG, cmds);
  }

  private debugGestureEnableCaller(): string {
    let allGestureEnableCaller = `\nThere are ${this.gestureEnableMap.size} callers:\
    GestureBack is ${this.isBackEnable}, GestureNavBar is ${this.isNavBarEnable} \n\n` +
    `Caller`.padEnd(COMMAND_ITEM_LENGTH, ' ') +
    `isPriority`.padEnd(COMMAND_ITEM_LENGTH, ' ') +
    `GestureBack`.padEnd(COMMAND_ITEM_LENGTH, ' ') +
    `GestureNavBar`.padEnd(COMMAND_ITEM_LENGTH, ' ') +
    `Time`.padEnd(COMMAND_ITEM_LENGTH, ' ') + `\n` +
    `-`.padEnd(COMMAND_LINE_LENGTH, '-') + `\n`;

    this.gestureEnableMap.forEach((value: [boolean, boolean, boolean, string], key: string) => {
      allGestureEnableCaller +=
      `${key}`.padEnd(COMMAND_ITEM_LENGTH, ' ') +
      `${value[2]}`.padEnd(COMMAND_ITEM_LENGTH, ' ') +
      `${value[0]}`.padEnd(COMMAND_ITEM_LENGTH, ' ') +
      `${value[1]}`.padEnd(COMMAND_ITEM_LENGTH, ' ') +
      `${value[3]}`.padEnd(COMMAND_ITEM_LENGTH, ' ') + `\n`;
    });

    return allGestureEnableCaller;
  }

  private debugSetGestureNavigationEnable(args: Array<string>): string {
    if (args.length > 5) {
      return 'args is invalid.';
    }
    let caller = args[0];
    let isBackEnable = this.getBooleanByString(args[1]);
    let isNavBarEnable = this.getBooleanByString(args[2]);
    let isPrority = this.getBooleanByString(args[3]);

    if (isBackEnable === undefined) {
      return 'isBackEnable is invalid.';
    }
    if (isNavBarEnable === undefined) {
      return 'isNavBarEnable is invalid.';
    }
    if (isPrority === undefined) {
      return 'isPrority is undefined.';
    }
    let sceneBoardCaller = this.getSceneBoardCallerByString(caller);
    if (sceneBoardCaller !== undefined) {
      if (isPrority) {
        this.setGestureNavigationEnablePriority(sceneBoardCaller, isBackEnable, isNavBarEnable);
        return `${sceneBoardCaller} setGestureNavigationEnablePriority ${isBackEnable} ${isNavBarEnable} success.`;
      } else {
        this.setGestureNavigationEnable(sceneBoardCaller, isBackEnable, isNavBarEnable);
        return `${sceneBoardCaller} setGestureNavigationEnable ${isBackEnable} ${isNavBarEnable} success.`;
      }
    } else {
      let type = this.getNumberByString(args[4]);
      if (type === undefined) {
        return 'type is undefined.';
      }
      this.onGestureNavigationEnabledChange(isBackEnable || isNavBarEnable, caller, type);
      return `${caller} onGestureNavigationEnabledChange ${isBackEnable} ${isNavBarEnable} ${type} success.`;
    }
  }

  private getBooleanByString(arg: string): boolean | undefined {
    if (arg === 'true') {
      return true;
    }
    if (arg === 'false') {
      return false;
    }
    return undefined;
  }

  private getNumberByString(arg: string): number | undefined {
    if (arg === '0') {
      return GestureEnableType.BACK;
    }
    if (arg === '2') {
      return GestureEnableType.ALL;
    }
    return undefined;
  }

  private getTime(): string {
    let date = new Date();
    let time = String(date.getFullYear()).padStart(2, '0') + '/' +
    String(date.getMonth() + 1).padStart(2, '0') + '/' +
    String(date.getDate()).padStart(2, '0') + ' ' +
    String(date.getHours()).padStart(2, '0') + ':' +
    String(date.getMinutes()).padStart(2, '0') + ':' +
    String(date.getSeconds()).padStart(2, '0') + '.' +
    String(date.getMilliseconds()).padStart(2, '0');
    return time;
  }

  /**
   * 广播手势滑动或三键导航的home及recent事件
   * @param eventNAME 事件名称
   * @param eventType 事件类型
   * @param parameters 事件相关参数
   */
  public publishScenePanelEventMsg(eventNAME: string, eventType: string, parameters?: Record<string, Object>): void {
    let options: commonEventManager.CommonEventPublishData = {
      data: eventType
    };
    if (parameters !== undefined) {
      options.parameters = parameters;
    }
    try {
      commonEventManager.publish(eventNAME, options, () => {
        log.showDebug(`publish ${eventNAME} ${eventType} success`);
      });
    } catch (error) {
      log.showError(`publish error：${error.code}, ${error.message}`);
    }
  }

}

export const scbGestureManager = SCBGestureManager.getInstance();