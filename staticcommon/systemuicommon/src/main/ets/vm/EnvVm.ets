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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AccountMgr, AccountSwitchEvent,
  GlobalContext,
  OobeActivatedEvent, ScreenLockEvent } from '@ohos/frameworkwrapper';
import { InnerEventUtil } from '../utils/InnerEventUtil';
import { Singleton } from '../utils/Singleton';
import { LiveViewHideContentEvent, NtfAutoScreenOnEvent } from '../datasharemanager/SysUIDataShareEvent';
import { baseStateMgr } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseStateManager';
import { DarkModeState, ImmersiveBaseState,
  IState,
  StateType } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import { OnStateChangeListener } from '@ohos/systemuiutils/src/main/ets/sysdialog/StateListenerRegister';
import { StatusBarShowHideChangeEvent } from '../event/StatusBarEvent';
import { ThreadSync } from '../messageChannel/ThreadSync';
import { StatusBarType } from '../plugin/info/StatusBarType';
import { SingleHandModeChangeEvent } from '../event/StatusBarEvent';
import { PowerStatusMonitorAdapter, PowerStatusEnum } from '../adapter/PowerStatusMonitorAdapter';
import { OobeAdapter } from '../adapter/OobeAdapter';
import lazy { OccludeKeygaurdScene, SCBKioskModeManager, SCBSceneSessionManager, ScenePanelState } from '@ohos/windowscene';
import { ScreenLockAdapter } from '../adapter/ScreenLockAdapter';
import { osAccount } from '@kit.BasicServicesKit';

const TAG = 'EnvVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ThreadSync.VmDecorator
@ObservedV2
export class EnvVm {
  @Singleton.decorate()
  public static get instance(): EnvVm { return new EnvVm(); }

  /**
   * 是否为OOBE模式
   */
  @Trace public isOobe: boolean = true;

  /**
   * 是否为沉浸态
   */
  @Trace public isImmersive: boolean = false;

  /**
   * 是否状态栏显示
   */
  @Trace public isStatusBarShow: boolean = true;

  /**
   * 是否为深色模式
   */
  @Trace public isDarkMode: boolean = false;
  /**
   * 是否为灭屏状态
   */
  @Trace public isScreenOff: boolean = false;
  /**
   * 是否为锁屏状态
   */
  @Trace public isScreenLock: boolean = false;
  /**
   * 是否为单手模式
   */
  @Trace public isSingleHandMode: boolean = false;
  /**
   * 是否为锁屏状态
   */
  @Trace public isLockEditor: boolean = false;
  /**
   * 是否锁屏锁定状态
   */
  @Trace public isSecureAndLocked: boolean = false;
  /**
   * 状态栏颜色
   */
  @Trace public statusBarColor: string = '#FFFFFFFF';
  /**
   * 状态栏类型
   */
  @Trace public statusBarType: number = StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;

  /**
   * 锁屏是否被覆盖
   */
  @Trace public isOccluded: boolean = false;

  /**
   * 是否使能控制中心
   */
  @Trace public enableControllerCenter: boolean = true;

  /**
   * 是否在锁定时隐藏实况窗内容
   */
  @Trace public isLiveViewHideContent: boolean = false;

  @Trace public scenePanelState: ScenePanelState = ScenePanelState.HOME;

  @Trace public pcModeScenePanelState: ScenePanelState = ScenePanelState.HOME;

  @Trace public onDeskTop: boolean = false;

  @Trace public isKioskMode: boolean = false;

  @Trace public isNtfAutoScreenOn: boolean = false;

  /**
   * 是否显示密码界面
   */
  @Trace public isPwdVisible: boolean = false;

  /**
   * 是否已设置人脸数据
   */
  @Trace public hasFaceData: boolean = false;
  /**
   * 当前活跃的用户id
   */
  public currentUserId: number = 100;

  public constructor() {
    try {
      this.currentUserId = osAccount.getAccountManager()
        .getOsAccountLocalIdForUidSync(GlobalContext.getContext().applicationInfo.uid);
    } catch (e) {
      log.error('getOsAccountLocalIdForUidSync error:', e);
    }
  }

  public init(): void {
    try {
      InnerEventUtil.on(OobeActivatedEvent, this.onOobeActiveEvent.bind(this));
      InnerEventUtil.on(ScreenLockEvent, this.onScreenLockEvent.bind(this));
      InnerEventUtil.on(StatusBarShowHideChangeEvent, this.onStatusBarShowHideChangeEvent.bind(this));
      InnerEventUtil.on(SingleHandModeChangeEvent, this.onSingleModeChangeEvent.bind(this));
      InnerEventUtil.on(LiveViewHideContentEvent, this.onLiveViewHideContentEvent.bind(this));
      InnerEventUtil.on(NtfAutoScreenOnEvent, this.onNtfAutoScreenOnEvent.bind(this));
      InnerEventUtil.on(AccountSwitchEvent, this.onAccountSwitchEvent.bind(this));
      baseStateMgr.registerStateChangeListener(StateType.TYPE_DARK_MODE, this.stateListener);
      baseStateMgr.registerStateChangeListener(StateType.TYPE_IMMERSIVE, this.stateListener);
      PowerStatusMonitorAdapter.subscribe({ stage: PowerStatusEnum.BEGIN_DISPLAY_ON, callback: this.displayOn.bind(this) },
        `${TAG}_BEGIN_DISPLAY_ON`);
      PowerStatusMonitorAdapter.subscribe({ stage: PowerStatusEnum.BEGIN_DISPLAY_OFF, callback: this.displayOff.bind(this) },
        `${TAG}_BEGIN_DISPLAY_OFF`);
      SCBSceneSessionManager.getInstance()
        .registerKeyguardOccludedChangeCallbacks(this.keyguardOccludedChangeCallback.bind(this));
      // 避免因时序问题导致未取得正确的深浅色模式
      this.isDarkMode = baseStateMgr.isDarkMode();
      SCBKioskModeManager.getInstance().registerKioskModeChangeEvent(TAG, this.kioskModeChangeCallback.bind(this));
    } catch (e) {
      log.error('Init env error:', e);
    }
  }

  public unInit(): void {
    SCBSceneSessionManager.getInstance().unRegisterKeyguardOccludedChangeCallbacks(this.keyguardOccludedChangeCallback);
  }

  private onOobeActiveEvent(event: OobeActivatedEvent): void {
    log.showInfo(`onOobeActiveEvent: ${event.isActivated}`);
    this.isOobe = event.isActivated;
  };

  /**
   * 收到通知自动亮屏开关事件
   *
   * @param event 事件
   */
  private onNtfAutoScreenOnEvent = (event: NtfAutoScreenOnEvent): void => {
    this.isNtfAutoScreenOn = event.isNtfAutoScreenOnEnable();
  };

  private onAccountSwitchEvent(event: AccountSwitchEvent): void {
    if (event.currentUserId) {
      log.showInfo(`Account switch, current user id is ${event.currentUserId}`);
      this.currentUserId = event.currentUserId;
    } else {
      // 获取当前用户ID
      AccountMgr.getCurrentAccountId()
        .then((currentUserId) => {
          this.currentUserId = currentUserId;
          log.showWarn(`Account switch, get current user id ${this.currentUserId}`);
        });
    }
  }

  private stateListener: OnStateChangeListener = {
    onStateChange(state: IState): void {
      log.showInfo(`onStateChange, type: ${state.getStateType()}`);
      if (state instanceof DarkModeState) {
        EnvVm.instance.isDarkMode = state.isDarkMode;
        log.showInfo(`onStateChange, isDarkMode: ${EnvVm.instance.isDarkMode}`);
      } else if (state instanceof ImmersiveBaseState) {
        EnvVm.instance.isImmersive = state.isImmersive;
        log.showInfo(`onStateChange, isImmersive: ${EnvVm.instance.isImmersive}`);
      }
    },
  };

  private onScreenLockEvent(event: ScreenLockEvent): void {
    log.showInfo(`onScreenLockEvent, isScreenLock: ${event.isLockScreen}`);
    this.isScreenLock = event?.isLockScreen;
    if (!this.isScreenLock) {
      this.isScreenOff = false;
    }
  }

  private onStatusBarShowHideChangeEvent(event: StatusBarShowHideChangeEvent): void {
    log.showInfo(`onStatusBarShowHideChange, status show hide status change from ${this.isStatusBarShow} to ${event.isShow}.`);
    this.isStatusBarShow = event.isShow!;
  }

  private onSingleModeChangeEvent(event: SingleHandModeChangeEvent): void {
    log.showInfo(`on singleMode ChangeEvent, mode is: ${event.isSingleHandMode}`);
    this.isSingleHandMode = event?.isSingleHandMode;
  }

  private onLiveViewHideContentEvent = (event: LiveViewHideContentEvent): void => {
    this.isLiveViewHideContent = event.isLiveViewHideContentEnable();
    log.showInfo(`onLiveViewHideContentEvent: ${this.isLiveViewHideContent}`);
  }

  private displayOn(): void {
    log.showInfo('onScreenOnOffEvent ScreenOn');
    this.isScreenOff = false;
  }

  private displayOff(): void {
    log.showInfo('onScreenOnOffEvent ScreenOff');
    this.isScreenOff = true;
  }

  @Computed
  public get onOobeChange(): void {
    OobeAdapter.isOobe = this.isOobe;

    return;
  }

  @Computed
  public get onScreenLockChange(): void {
    ScreenLockAdapter.isScreenLock = this.isScreenLock;

    return;
  }

  private keyguardOccludedChangeCallback(occludedState: number): void {
    this.isOccluded = (occludedState & OccludeKeygaurdScene.SPECIAL) === OccludeKeygaurdScene.SPECIAL;
    log.showInfo(`keyguardOccludedChangeCallback occludedState ${occludedState} this.isOccluded ${this.isOccluded}`);
  };

  public clear(): void {
    this.statusBarType = StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;
  }

  public isLockAndNotEditor(): boolean {
    return this.isScreenLock && !this.isLockEditor;
  }

  public isShowFaceUnLockIcon(): boolean {
    return this.isScreenLock && this.hasFaceData;
  }

  private kioskModeChangeCallback(isKioskMode: boolean): void {
    log.showInfo(`Kiosk mode changed, isKioskMode:${isKioskMode}`);
    this.isKioskMode = isKioskMode;
  }
}