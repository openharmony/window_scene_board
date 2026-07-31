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

import { OutdoorConfig, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DeviceHelper, GlobalContext, WallpaperColorManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { BusinessError, settings } from '@kit.BasicServicesKit';
import rpc from '@ohos.rpc';
import { bundleManager, common } from '@kit.AbilityKit';
import { IdlCode } from './SCBNaviBarProxyManager';
import { NaviBarSettingsDataMgr } from '../settings/preference/NaviBarSettingsDataMgr';
import { SwitchType } from '../settings/preference/PreferenceType';
import { DesktopModeEnum, SystemBarChangeType } from '@ohos/launchercommon';
import { SCBSceneSessionManager, SCBScreenSessionManager, ScenePanelState, sSCBOobeManager } from '@ohos/windowscene';
import { SCBNaviBarConstants } from '../SCBNaviBarConstants';

const TAG: string = 'FloatingNavigationManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);
const FLOATING_COMMUNICATION = 'FloatingNavigation';
let want: Want = {
  'bundleName': 'com.ohos.floatingnavigation',
  'abilityName': 'FloatingNavServiceExtAbility',
  parameters: {
    degree: 0,
    isInApp: false,
    isShow: false,
    isShowFloatingBall: false
  }
};

/**
 * 悬浮导航拉起、显隐相关管理类
 */
export class FloatingNavigationManager {
  private proxy?: rpc.IRemoteObject;
  private retryCount: number = 0;
  private isShowFloatingNav: boolean = false;
  private switchStatus: boolean = false;
  private exchangeBtnStatus: string = SCBNaviBarConstants.BUTTON_POSITION_STYLE_INVALID;
  private hideFloatingNavTimer: number = 0;
  private isTimerRunning: boolean = false;
  private switchChangeCallBack?: Function;
  private isConnecting: boolean = false;
  private isHiddenScene: boolean = false;
  private desktopMode: DesktopModeEnum = DesktopModeEnum.BASE_MODE;
  private scenePanelState: ScenePanelState = ScenePanelState.HOME;
  private isInMultiWindowMode: boolean = false;
  private isInApp: boolean = false;
  private isScreenLock: boolean = SCBSceneSessionManager.getInstance().isScreenLocked();
  private isGestureEnable: boolean = !sSCBOobeManager.isEnable();
  private wallpaperDegree: number = SCBNaviBarConstants.EXTREMELY_FLOWERY_PICTURE;
  private isImmersiveState: boolean = false;
  private floatingBallSwitchStatus: boolean = false;

  public static getInstance(): FloatingNavigationManager {
    return SingletonHelper.getInstance(FloatingNavigationManager, TAG);
  }

  public setSwitchStatus(switchStatus: boolean): void {
    log.showInfo(`setSwitchStatus ${switchStatus}`);
    this.switchChangeCallBack?.(switchStatus);
    this.switchStatus = switchStatus;
  }

  /**
   * 设置悬浮球开关状态
   * @param switchStatus
   */
  public setFloatingBallStatus(switchStatus: boolean): void {
    this.floatingBallSwitchStatus = switchStatus;
  }

  /**
   * 获取悬浮球开关状态
   * @param switchStatus
   */
  public getFloatingBallStatus(): boolean {
    return this.floatingBallSwitchStatus;
  }

  private checkSwitchStatus(callName: string): boolean {
    if (FloatingNavigationManager.getInstance().switchStatus ||
      FloatingNavigationManager.getInstance().floatingBallSwitchStatus) {
      return true;
    }
    log.showInfo(`${callName} swich is closed`);
    return false;
  }

  /**
   * 设置三键位置互换的样式状态
   *
   * @param exchangeBtnStatus 样式状态
   */
  public setExchangeBtnStatus(exchangeBtnStatus: string): void {
    log.showInfo(`setExchangeBtnStatus ${exchangeBtnStatus}`);
    if (!this.switchStatus) {
      this.exchangeBtnStatus = SCBNaviBarConstants.BUTTON_POSITION_STYLE_INVALID;
      return;
    }
    this.exchangeBtnStatus = exchangeBtnStatus;
  }

  /**
   * 获取三键位置互换的样式状态
   *
   * @returns 样式状态
   */
  public getExchangeBtnStatus(): string {
    return this.exchangeBtnStatus;
  }

  /**
   * 设置是否是需要异常三键导航的场景，如：语音助手半模态
   * @param isHiddenScene 是否是需要异常三键导航的场景 true:是 false:否
   */
  public setIsHiddenScene(isHiddenScene: boolean): void {
    if (!FloatingNavigationManager.getInstance().checkSwitchStatus('setIsHiddenScene')) {
      return;
    }

    log.showInfo(`isHiddenScene: ${isHiddenScene}`);
    this.isHiddenScene = isHiddenScene;
  }

  public getSwitchStatus(): boolean {
    return this.switchStatus;
  }

  public setDesktopMode(desktopMode: DesktopModeEnum): void {
    log.showInfo(`setDesktopMode: ${desktopMode}`);
    this.desktopMode = desktopMode;
  }

  /**
   * 注册开关变化通知导航条回调
   * @param callBack
   */
  public registersSwitchChangeCallBack(callBack: Function): void {
    log.showInfo('registersSwitchChangeCallBack');
    this.switchChangeCallBack = callBack;
  }

  /**
   * 解注册回调
   */
  public unregistersSwitchChangeCallBack(): void {
    log.showInfo('unregistersSwitchChangeCallBack');
    this.switchChangeCallBack = undefined;
  }

  /**
   * 连接并拉起悬浮导航服务
   */
  public connectFloatingNavAbility(isShowFloatingBall: boolean = false): void {
    // 云端模式禁止拉起三键导航
    if (OutdoorConfig.getInstance().isInOutdoorMode()) {
      log.showInfo(`connectFloatingNavAbility isInOutdoorMode`);
      return;
    }
    // 1、检查开关状态
    if (!FloatingNavigationManager.getInstance().checkSwitchStatus('connectFloatingNavAbility')) {
      return;
    }

    // 2、检查连接状态
    if (FloatingNavigationManager.getInstance().proxy) {
      log.showInfo('has connected FloatingNavigation');
      return;
    }

    // 正在连接时不重复发起连接
    if (FloatingNavigationManager.getInstance().isConnecting) {
      log.showInfo('isConnecting');
      return;
    }

    FloatingNavigationManager.getInstance().isConnecting = true;
    let commRemote: rpc.IRemoteObject;
    let connectOptions: common.ConnectOptions = {
      onConnect(elementName: bundleManager.ElementName, remote: rpc.IRemoteObject) {
        log.showInfo('onConnect FloatingNavigation');
        FloatingNavigationManager.getInstance().isShowFloatingNav =
          FloatingNavigationManager.getInstance().isFloNavNeedShow() &&
            !FloatingNavigationManager.getInstance().isHiddenScene;
        FloatingNavigationManager.getInstance().proxy = remote;
        FloatingNavigationManager.getInstance().retryCount = 0;
        FloatingNavigationManager.getInstance().isConnecting = false;
        FloatingNavigationManager.getInstance().sendFloatingNavIsInApp(FloatingNavigationManager.getInstance().isInApp);
        // 防止设置显隐时Hap未拉起，连接成功后重新设置一遍
        FloatingNavigationManager.getInstance().setFloatingNavStatus(
          FloatingNavigationManager.getInstance().isShowFloatingNav, false);
      },
      onDisconnect(elementName: bundleManager.ElementName) {
        log.showInfo('onDisconnect FloatingNavigation');
        FloatingNavigationManager.getInstance().isShowFloatingNav = false;
        FloatingNavigationManager.getInstance().proxy = undefined;
        FloatingNavigationManager.getInstance().reConnectFloatingNavAbility();
        FloatingNavigationManager.getInstance().isConnecting = false;
      },
      onFailed(code: number) {
        log.showInfo(`onFailed FloatingNavigation ${code}`);
        FloatingNavigationManager.getInstance().isShowFloatingNav = false;
        FloatingNavigationManager.getInstance().proxy = undefined;
        FloatingNavigationManager.getInstance().reConnectFloatingNavAbility();
        FloatingNavigationManager.getInstance().isConnecting = false;
      }
    };
    let connection: number;

    // 3、拉起悬浮导航
    try {
      want.parameters = {
        degree: FloatingNavigationManager.getInstance().wallpaperDegree,
        isInApp: FloatingNavigationManager.getInstance().isInApp,
        isShow: FloatingNavigationManager.getInstance().isFloNavNeedShow() &&
          !FloatingNavigationManager.getInstance().isHiddenScene,
        isShowFloatingBall: FloatingNavigationManager.getInstance().floatingBallSwitchStatus
      };
      log.showInfo(`isInApp ${want?.parameters?.isInApp} isShow: ${want?.parameters?.isShow}`);
      connection = GlobalContext.getContext().connectServiceExtensionAbility(want, connectOptions);
    } catch (err) {
      // 处理入参错误异常
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      log.showInfo(`connectServiceExtensionAbility failed, code is ${code}, message is ${message}`);
      FloatingNavigationManager.getInstance().isShowFloatingNav = false;
      FloatingNavigationManager.getInstance().proxy = undefined;
      FloatingNavigationManager.getInstance().reConnectFloatingNavAbility();
      FloatingNavigationManager.getInstance().isConnecting = false;
    }
  }

  private isFloNavNeedShow(): boolean {
    return (!FloatingNavigationManager.getInstance().isImmersiveState ||
      FloatingNavigationManager.getInstance().scenePanelState !== ScenePanelState.FULLSCENE) &&
      FloatingNavigationManager.getInstance().isGestureEnable;
  }

  /**
   * 断联或者拉起悬浮导航失败时重新拉起
   * @param maxRetries
   */
  private reConnectFloatingNavAbility(maxRetries: number = 10): void {
    // 检查开关状态
    if (!FloatingNavigationManager.getInstance().checkSwitchStatus('reConnectFloatingNavAbility')) {
      return;
    }

    if (FloatingNavigationManager.getInstance().desktopMode !== DesktopModeEnum.BASE_MODE) {
      log.showInfo('not BASE_MODE');
      return;
    }

    if (FloatingNavigationManager.getInstance().retryCount >= maxRetries) {
      log.showInfo('retry over maxRetries');
      // 拉起失败关闭开关
      NaviBarSettingsDataMgr.getInstance().putValue(SwitchType.FLOATING_NAV_STATUS, '1',
        settings.domainName.USER_PROPERTY);
      return;
    }
    ++FloatingNavigationManager.getInstance().retryCount;
    log.showInfo(`retry connect ${this.retryCount}`);
    // 计算重试间隔时间
    const retryInterval = this.retryCount * 1000;
    setTimeout(FloatingNavigationManager.getInstance().connectFloatingNavAbility, retryInterval);
  }

  /**
   * 设置悬浮导航显示或隐藏
   * @param isShow
   * @param isReset
   */
  public setFloatingNavStatus(isShow: boolean, isReset: boolean): void {
    // 检查开关状态
    if (!FloatingNavigationManager.getInstance().checkSwitchStatus('setFloatingNavStatus')) {
      return;
    }

    this.isShowFloatingNav = isShow;
    this.setFloatingNavVisibleOrHidden(isShow && !this.isHiddenScene, isReset);
  }

  /**
   * 根据沉浸式状态设置悬浮导航显示
   * @param isReset 无障碍开启是否重置位置
   */
  public setShowVerifyImmersiveState(isReset: boolean = false): void {
    this.setFloatingNavStatus(this.isFloNavNeedShow(), isReset);
  }

  /**
   * 进程通信发送显隐标记信息
   * @param isShow 是否显示
   * @param isReset 是否重置位置信息
   * @returns
   */
  private async setFloatingNavVisibleOrHidden(isShow: boolean, isReset: boolean): Promise<void> {
    log.showInfo(`setFloatingNavVisibleOrHidden ${isShow} ${isReset}`);
    if (!FloatingNavigationManager.getInstance().proxy) {
      log.showInfo('FloatingNav proxy is undefined');
      return;
    }

    if (!FloatingNavigationManager.getInstance().isGestureEnable && isShow) {
      log.showInfo('not show');
      return;
    }

    let msgOption = new rpc.MessageOption();
    let msgData = rpc.MessageSequence.create();
    let msgReply = rpc.MessageSequence.create();
    let sendCode = isShow ? IdlCode.SEND_FLOATING_NAV_SHOW : IdlCode.SEND_FLOATING_NAV_HIDE;
    let resetFlag = isReset ? 1 : 0;
    msgData.writeInterfaceToken(FLOATING_COMMUNICATION);
    msgData.writeInt(resetFlag);
    msgData.writeInt(this.wallpaperDegree);
    msgData.writeBoolean(FloatingNavigationManager.getInstance().isInApp);
    msgData.readInterfaceToken();
    log.info(`msgData: ${msgData.readInt()} ${msgData.readInt()} ${msgData.readBoolean()}`);
    msgOption.setAsync(true);
    await FloatingNavigationManager.getInstance().proxy?.sendMessageRequest(sendCode, msgData, msgReply, msgOption);
    msgData.reclaim();
    msgReply.reclaim();
  }

  /**
   * 通知悬浮导航当前是否位于应用内
   * @param isInApp
   * @returns
   */
  private async sendFloatingNavIsInApp(isInApp: boolean): Promise<void> {
    log.showInfo(`sendFloatingIsInApp ${isInApp}`);
    FloatingNavigationManager.getInstance().isInApp = isInApp;
    // 检查开关状态
    if (!FloatingNavigationManager.getInstance().checkSwitchStatus('sendFloatingNavIsInApp')) {
      return;
    }
    if (!FloatingNavigationManager.getInstance().proxy) {
      log.showInfo('FloatingNav proxy is undefined');
      return;
    }

    let msgOption = new rpc.MessageOption();
    let msgData = rpc.MessageSequence.create();
    msgData.writeInterfaceToken(FLOATING_COMMUNICATION);
    msgData.writeInt(this.wallpaperDegree);
    msgData.writeInt(this.scenePanelState);
    msgData.readInterfaceToken();
    log.info(`msgData: ${msgData.readInt()} ${msgData.readInt()}`);
    let msgReply = rpc.MessageSequence.create();
    let sendCode = isInApp ? IdlCode.SEND_FLOATING_NAV_IS_IN_APP : IdlCode.SEND_FLOATING_NAV_IS_DESKTOP;
    msgOption.setAsync(true);
    await FloatingNavigationManager.getInstance().proxy?.sendMessageRequest(sendCode, msgData, msgReply, msgOption);
    msgData.reclaim();
    msgReply.reclaim();
  }

  /**
   * 通知悬浮导航当前锁屏状态
   * @param isInApp
   * @returns
   */
  private async sendFloatingNavLockStatus(): Promise<void> {
    log.showInfo(`sendFloatingNavLockStatus ${this.isScreenLock}`);

    // 检查开关状态
    if (!FloatingNavigationManager.getInstance().checkSwitchStatus('sendFloatingNavLockStatus')) {
      return;
    }
    if (!FloatingNavigationManager.getInstance().proxy) {
      log.showInfo('FloatingNav proxy is undefined');
      return;
    }

    let msgOption = new rpc.MessageOption();
    let msgData = rpc.MessageSequence.create();
    msgData.writeInterfaceToken(FLOATING_COMMUNICATION);
    msgData.writeBoolean(this.isScreenLock);
    msgData.writeBoolean(this.isGestureEnable);
    msgData.readInterfaceToken();
    log.info(`msgData: ${msgData.readBoolean()} ${msgData.readBoolean()}`);
    let msgReply = rpc.MessageSequence.create();
    let sendCode = IdlCode.SEND_FLOATING_NAV_IS_LOCK;
    msgOption.setAsync(true);
    await FloatingNavigationManager.getInstance().proxy?.sendMessageRequest(sendCode, msgData, msgReply, msgOption);
    msgData.reclaim();
    msgReply.reclaim();
  }

  /**
   * 沉浸式状态下悬浮导航显隐设置
   * @param isShow 是否显示
   */
  public checkShowFloatingNavigation(isShow: boolean, isGame: boolean = false): void {
    if (!FloatingNavigationManager.getInstance().checkSwitchStatus('checkShowFloatingNavigation')) {
      return;
    }
    if (isGame && this.scenePanelState !== ScenePanelState.FULLSCENE) {
      log.showInfo('exit game');
      return;
    }
    this.isImmersiveState = !isShow;
    log.showInfo(`checkShowFloatingNavigation: ${isShow} ${this.isTimerRunning}`);
    if (!isShow) {
      if (this.isShowFloatingNav !== isShow && !this.isTimerRunning) {
        this.isTimerRunning = true;
        this.hideFloatingNavTimer = setTimeout(() => {
          this.isShowFloatingNav = isShow;
          this.setFloatingNavStatus(isShow, false);
          this.isTimerRunning = false;
        }, this.floatingBallSwitchStatus ? 0 : 2000);
      }
    } else {
      if (!this.isTimerRunning && this.isShowFloatingNav === isShow) {
        return;
      }
      clearTimeout(this.hideFloatingNavTimer);
      this.isTimerRunning = false;
      this.isShowFloatingNav = isShow;
      this.setFloatingNavStatus(isShow, false);
    }
  }

  /**
   * 沉浸式状态下拉或者游戏防误触场景上划显示状态栏悬浮导航显隐设置
   * @param delayTime 延迟消失时间
   */
  public slideShowFloatingNavigation(delayTime: number = 2000): void {
    if (!FloatingNavigationManager.getInstance().checkSwitchStatus('slideShowFloatingNavigation')) {
      return;
    }

    log.showInfo('slideShowFloatingNavigation');
    clearTimeout(this.hideFloatingNavTimer);
    this.isTimerRunning = true;
    this.setFloatingNavStatus(true, false);
    this.hideFloatingNavTimer = setTimeout(() => {
      this.isTimerRunning = false;
      this.setFloatingNavStatus(false, false);
    }, delayTime);
  }

  /**
   * 沉浸式状态变化悬浮导航显隐处理
   * @param type 沉浸类型
   */
  public notifyFloatingNavImmerseStatus(status: number | boolean): void {
    if (!FloatingNavigationManager.getInstance().proxy) {
      log.showInfo('proxy is undefined');
      return;
    }

    log.showInfo(`notifyFloatingNavImmerseStatus ${status}`);

    if (status === SystemBarChangeType.NAVI_BAR_IMMERSE_TASK && (!this.isShowFloatingNav || this.isTimerRunning)) {
      log.showInfo('slide and show FloatingNav');
      this.slideShowFloatingNavigation(4250);
    }

    if (status === SystemBarChangeType.SHOW_BAR && (!this.isShowFloatingNav || this.isTimerRunning)) {
      this.slideShowFloatingNavigation();
    }
  }

  /**
   * scenePanelState状态变化回调
   * @param scenePanelState
   */
  public setScenePanelState(scenePanelState: ScenePanelState): void {
    log.showInfo(`setScenePanelState ${scenePanelState}`);
    this.scenePanelState = scenePanelState;
    this.sendFloatingNavIsInApp(this.isInAppStatus());
    if (this.scenePanelState === ScenePanelState.RECENT) {
      log.showInfo('recent state');
      clearTimeout(this.hideFloatingNavTimer);
      this.isTimerRunning = false;
      this.setFloatingNavStatus(true, false);
    }
  }

  private isInAppStatus(): boolean {
    return this.scenePanelState === ScenePanelState.FULLSCENE ||
      this.scenePanelState === ScenePanelState.QUICK_SWITCH || this.isInMultiWindowMode;
  }

  /**
   * 设置是否自由多窗状态
   * @param isInMultiWindowMode
   */
  public setIsInMultiWindowMode(isInMultiWindowMode: boolean): void {
    log.showInfo(`setIsInMultiWindowMode ${isInMultiWindowMode}`);
    this.isInMultiWindowMode = isInMultiWindowMode;
    this.sendFloatingNavIsInApp(this.isInAppStatus());
  }

  /**
   * 是否手势禁用场景
   * @param isEnable
   */
  public setIsGestureEnable(isEnable: boolean, caller: string): void {
    log.showInfo(`setIsGestureEnable: ${caller} ${isEnable}`);
    if (this.isGestureEnable === isEnable) {
      log.showInfo('value is same');
      return;
    }
    this.isGestureEnable = isEnable;
    if (isEnable) {
      if (!this.isImmersiveState || this.scenePanelState !== ScenePanelState.FULLSCENE) {
        this.setFloatingNavStatus(true, false);
      }
    } else {
      this.setFloatingNavStatus(false, false);
    }
  }

  /**
   * 设置壁纸色阶
   * @param degree
   */
  public setWallpaperDegree(degree: number): void {
    log.showInfo(`setWallpaperDegree: ${degree}`);
    this.wallpaperDegree = degree;
    this.sendFloatingNavIsInApp(this.isInApp);
  }

  /**
   * 设置是否锁屏状态
   * @param isScreenLock 是否锁屏
   */
  public setIsScreenLock(isScreenLock: boolean): void {
    log.showInfo(`setIsScreenLock: ${isScreenLock}`);
    this.isScreenLock = isScreenLock;
    this.sendFloatingNavLockStatus();
  }
}