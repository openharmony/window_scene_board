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

import { LogDomain, Logger } from '@ohos/basicutils';
import { ScreenLockEvent, ScreenOnOffEvent } from '@ohos/frameworkwrapper';
import { AppLockChangeListener, AppLockManager } from '@ohos/launchercommon';
import {
  SlMainStateType,
  SlSubStateType,
  StateChange,
  WProperty,
  AppLockConfigListener,
  CcmConfigHelper,
  OneMirrorStaticStateType,
  ISlState,
  VerifyDataManager,
  VerifyInfo
} from '@ohos/screenlockcommon';
import { SlStateProperty, V2StateChange } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { ImmersiveType,
  LiveViewHideContentEvent,
  NtfAutoScreenOnEvent,
  NtfHideContentEvent } from '@ohos/systemuicommon';
import {
  NotificationEvent,
  NotificationEventForBridge
} from '@ohos/systemuicommon/src/main/ets/event/NotificationEvent';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { slImmBindSt, SlImmBindStateV2 } from '../../../model/data/v2/SlImmBindStateV2';
import { BaseVmStyleMgr, V2StateUnique } from './BaseVmStyleMgr';

const TAG = 'ImmComVmStyleMgr';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

// 应用锁监听
class ImmAppLockListener implements AppLockChangeListener, AppLockConfigListener {
  // 状态管理
  private readonly styleMgr: ImmComVmStyleMgr;

  constructor(styleMgr: ImmComVmStyleMgr) {
    this.styleMgr = styleMgr;
  }

  onAppLockComConfigChange(comConfig: Set<string>): void {
    this.styleMgr?.getRootBindSt().setAppLockComConfig(comConfig);
  }

  onAppLockLiveConfigChange(liveConfig: Set<string>): void {
    this.styleMgr?.getRootBindSt().setAppLockLiveConfig(liveConfig);
  }

  onExemptedBundleChange(exemptedSet: Set<string>): void {
    this.styleMgr?.getRootBindSt().setAppLockExempted(exemptedSet);
  }

  onAllAppLockStatusChange(appLockMap: Map<string, boolean>): void {
    this.styleMgr?.getRootBindSt().setAppLockMap(appLockMap);
  }

  onSingleAppLockStatusChange(appKey: string, isAppLockOn: boolean): void {
    this.styleMgr?.getRootBindSt().setSingleAppLock(appKey, isAppLockOn);
  }
}

/**
 * 列表业务样式管理器
 */
export class ImmComVmStyleMgr extends BaseVmStyleMgr {
  /**
   * 应用锁状态监听器
   */
  private readonly immAppLockListener: ImmAppLockListener = new ImmAppLockListener(this);

  /**
   * V1状态属性监听集
   */
  private readonly v1StateChange: Map<SlMainStateType, Map<SlSubStateType, StateChange>> = new Map();

  /**
   * V2状态属性监听集
   */
  private readonly v2StateChange: Map<string, Map<SlStateProperty | WProperty, V2StateChange>> = new Map();

  /**
   * 锁定状态事件
   *
   * @param event 事件
   */
  private onScreenLockEvent = (event: ScreenLockEvent): void => {
    // 锁屏锁定状态
    let isLocked = event?.isSecureAndLocked() ?? false;
    log.showInfo(TAG, `onScreenLockEvent: ${isLocked}`);
    this.getRootBindSt().setSecureAndLocked(isLocked);
  };

  /**
   * 锁屏通用隐藏通知内容开关事件
   *
   * @param event 事件
   */
  private onNtfHideContentEvent = (event: NtfHideContentEvent): void => {
    // 通用隐藏通知内容状态
    let isHideContent = event?.isNtfHideContentEnable() ?? false;
    log.showInfo(TAG, `onNtfHideContentEvent: ${isHideContent}`);
    this.getRootBindSt().setHideNtfContentEnable(isHideContent);
  };

  /**
   * 锁屏实况隐藏通知内容开关事件
   *
   * @param event 事件
   */
  private onLiveHideContentEvent = (event: LiveViewHideContentEvent): void => {
    // 实况隐藏通知内容状态
    let isHideContent = event?.isLiveViewHideContentEnable() ?? false;
    log.showInfo(TAG, `onLiveHideContentEvent: ${isHideContent}`);
    this.getRootBindSt().setHideLiveContentEnable(isHideContent);
  };

  /**
   * 收到通知自动亮屏开关事件
   *
   * @param event 事件
   */
  private onNtfAutoScreenOnEvent = (event: NtfAutoScreenOnEvent): void => {
    let isNtfAutoScreenOn = event.isNtfAutoScreenOnEnable();
    this.getRootBindSt()?.setNtfAutoScreenOn(isNtfAutoScreenOn);
    log.showInfo(TAG, `onNtfAutoScreenOnEvent isNtfAutoScreenOn: ${isNtfAutoScreenOn}`);
  }

  /**
   * 亮灭屏事件
   *
   * @param event 事件
   */
  private onScreenOnOffEvent = (event: ScreenOnOffEvent): void => {
    let isScreenOn = event.isScreenOn();
    this.getRootBindSt()?.setCurScreenOn(isScreenOn);
    log.showInfo(TAG, `onScreenOnOffEvent isScreenOn: ${isScreenOn}`);
  }

  /**
   * 简化版通知数据事件
   *
   * @param event 事件
   */
  private onSimpleNtfEvent = (event: NotificationEventForBridge): void => {
    this.refreshNtfData(event);
  }

  /**
   * V1状态，一镜到底动效进度变化
   */
  private readonly onOneMirrorAnimProgressChange = (state?: ISlState): void => {
    // 记录AOD状态
    this.getRootBindSt()?.setAodMode(this.isAOD());
  };

  /**
   * V1状态属性监听初始化
   */
  private initV1StateChange(): void {
    // 一镜到底状态
    this.v1StateChange.set(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE, new Map([
      [OneMirrorStaticStateType.PT_AOD_STATE, this.onOneMirrorAnimProgressChange], // 一镜到底状态变化
    ]));
  }

  constructor(vmInjector: IImmersiveNtfVmInjector) {
    super(vmInjector);
    this.initV1StateChange();
  }

  /**
   * V1状态监听类型集
   *
   * @returns 状态集
   */
  protected getV1StateListenerTypes(): SlMainStateType[] {
    return [SlMainStateType.SL_ONE_MIRROR_STATIC_STATE];
  }

  /**
   * V1状态属性监听集
   *
   * @param mainType 主类型
   * @returns 属性监听集
   */
  protected getV1StateChange(mainType: SlMainStateType): Map<SlSubStateType, StateChange> | undefined {
    return this.v1StateChange.get(mainType);
  }

  /**
   * V2状态监听类型集
   *
   * @returns 状态集
   */
  protected getV2StateListenerTypes(): V2StateUnique[] {
    return [];
  }

  /**
   * V2状态属性监听集
   *
   * @param unique 状态标识
   * @returns 属性监听集
   */
  protected getV2StateChange(unique: V2StateUnique): Map<SlStateProperty | WProperty, V2StateChange> | undefined {
    return this.v2StateChange.get(this.getV2Key(unique.stateType, unique.stateId));
  }

  /**
   * 沉浸状态切换回调
   *
   * @param immType 当前沉浸状态
   */
  protected onImmersiveTypeChange(immType: ImmersiveType): void {
  }

  init(): void {
    super.init();
    AppLockManager.getInstance().registerStatusListener(this.immAppLockListener);
    CcmConfigHelper.getInstance().registerAppLockListener(this.immAppLockListener);
    this.eventMgr.on(ScreenLockEvent, this.onScreenLockEvent)
      .on(NtfAutoScreenOnEvent, this.onNtfAutoScreenOnEvent)
      .on(ScreenOnOffEvent, this.onScreenOnOffEvent)
      .on(NotificationEventForBridge, this.onSimpleNtfEvent)
      .on(NtfHideContentEvent, this.onNtfHideContentEvent)
      .on(LiveViewHideContentEvent, this.onLiveHideContentEvent);
  }

  destroy(): void {
    super.destroy();
    AppLockManager.getInstance().unregisterStatusListener(this.immAppLockListener);
    CcmConfigHelper.getInstance().unregisterAppLockListener(this.immAppLockListener);
  }

  /**
   * 及时刷新锁定状态，默认是锁屏时调用
   */
  public refreshLockVerify(): void {
    // 默认锁屏时调用，只要存在解锁验证方式则认为锁定
    let verifyInfo: VerifyInfo = VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN);
    let isLocked = verifyInfo.isSupportUnlock;
    this.getRootBindSt().setSecureAndLocked(isLocked);
    log.showInfo(TAG, `refreshLockVerify isLocked: ${isLocked}`);
  }

  /**
   * UI状态管理器
   *
   * @returns UI状态
   */
  public getRootBindSt(): SlImmBindStateV2 {
    return slImmBindSt;
  }

  private refreshNtfData(event: NotificationEventForBridge): void {
    let allImmSet = this.getRootBindSt()?.getAllImmHashcode();
    let preSize = allImmSet?.size ?? 0;
    // 移除数据
    if (event.eventType === NotificationEvent.EVENT_TYPE_REMOVE) {
      event.notificationList?.forEach((ntf) => {
        allImmSet?.delete(ntf?.hashCode);
      });
    } else {
      event.notificationList?.forEach((ntf) => {
        if (ntf?.liveViewData?.isSupportImm) {
          allImmSet?.add(ntf?.hashCode);
        }
      });
    }
    // 对比沉浸态数据是否变化
    let curSize = allImmSet?.size ?? 0;
    if (preSize === curSize) {
      return;
    }
    // 当无沉浸态数据时，小外屏恢复默认进沉浸态
    if (curSize === 0) {
      this.setOuterDefaultEnterImm(true);
    }
  }
}