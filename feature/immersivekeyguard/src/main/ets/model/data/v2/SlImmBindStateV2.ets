/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { AppLockManager, AppLockStatusEnum } from '@ohos/launchercommon';
import { BaseState, SlImmBindStPt, SlStateId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { SlViewBindState } from '@ohos/screenlockcommon/Index';
import { SysTypeCode } from '@ohos/systemuicommon/newTsIndex';
import { ImmPrivacyType } from '../../../common/ImmersiveConstants';

const TAG = 'SlImmBindStateV2';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 隐私类型参数
export interface PrivacyParam {
  // 应用包名
  bundleName: string;
  // 应用分身ID
  appIndex: number;
  // 是否实况通知
  isLiveNt: boolean;
  // 系统实况类型
  sysTypeCode: SysTypeCode;
}

/**
 * 沉浸模块整体UI绑定数据管理器
 */
@ObservedV2
export class SlImmBindStateV2 extends SlViewBindState<SlImmBindStPt> {
  // 通用隐藏通知内容是否开启
  @Trace private _isHideNtfContentEnable: boolean = false;

  // 实况隐藏通知内容是否开启
  @Trace private _isHideLiveContentEnable: boolean = false;

  // 锁屏是否上锁锁定状态
  @Trace private _isSecureAndLocked: boolean = false;

  // 开启应用锁应用key集
  @Trace private readonly _appLockSet: Set<string> = new Set();

  // 应用锁白名单集，应用包名
  @Trace private readonly _appLockExemptedSet: Set<string> = new Set();

  // 应用锁通用通知白名单配置
  @Trace private readonly _appLockComConfig: Set<string> = new Set();

  // 应用锁实况通知白名单配置
  @Trace private readonly _appLockLiveConfig: Set<string> = new Set();

  // 所有进沉浸态数据标识集
  @Trace private readonly _allImmHashcode: Set<string> = new Set();

  // AOD是否开启
  @Trace private _isAodMode: boolean = false;

  // 来通知自动亮屏开关
  @Trace private _isNtfAutoScreenOne: boolean = false;

  // 当前是否屏幕亮屏
  @Trace private _isCurScreenOn: boolean = false;

  protected constructor() {
    super(SlStateId.SL_IMMERSIVE_STATE);
  }

  protected initGetMethods(): void {
    super.initGetMethods();
    this.addGetMethod(SlImmBindStPt.PT_PRIVACY_TYPE, this.getPrivacyType);
    this.addGetMethod(SlImmBindStPt.PT_AOD_MODE, this.isAodMode);
    this.addGetMethod(SlImmBindStPt.PT_CUR_SCREEN_ON, this.isCurScreenOn);
  }

  /**
   * 通用隐藏通知内容开关
   *
   * @param isEnable true开启
   */
  public setHideNtfContentEnable(isEnable: boolean): void {
    let result = isEnable ?? false;
    if (this._isHideNtfContentEnable !== result) {
      this._isHideNtfContentEnable = result;
    }
  }

  /**
   * 实况隐藏通知内容开关
   *
   * @param isEnable true开启
   */
  public setHideLiveContentEnable(isEnable: boolean): void {
    let result = isEnable ?? false;
    if (this._isHideLiveContentEnable !== result) {
      this._isHideLiveContentEnable = result;
    }
  }

  /**
   * 锁屏锁定状态
   *
   * @param isLock true上锁
   */
  public setSecureAndLocked(isLock: boolean): void {
    let result = isLock ?? false;
    if (this._isSecureAndLocked !== result) {
      this._isSecureAndLocked = result;
      this.notifyStateChange(SlImmBindStPt.PT_SECURE_LOCKED);
    }
  }

  /**
   * 获取锁屏上锁状态
   *
   * @returns true 上锁
   */
  public isSecureAndLocked(): boolean {
    return this._isSecureAndLocked;
  }

  /**
   * 赋值所有开启应用锁应用集
   *
   * @param allAppLock 所有开启应用集
   */
  public setAppLockMap(allAppLock: Map<string, boolean>): void {
    this._appLockSet.clear();
    allAppLock?.forEach((isLock, appKey) => {
      if (isLock) {
        this._appLockSet.add(appKey);
      }
    });
  }

  /**
   * 赋值单个应用是否开启应用锁
   *
   * @param appKey 应用标识
   * @param isLock true开启应用锁
   */
  public setSingleAppLock(appKey: string, isLock: boolean): void {
    if (isLock) {
      this._appLockSet.add(appKey);
    } else {
      this._appLockSet.delete(appKey);
    }
  }

  /**
   * 赋值应用锁白名单集
   *
   * @param exemptedSet 白名单集
   */
  public setAppLockExempted(exemptedSet: Set<string>): void {
    this._appLockExemptedSet.clear();
    exemptedSet?.forEach((bundle) => this._appLockExemptedSet.add(bundle));
  }

  /**
   * 赋值应用锁通用通知白名单配置
   *
   * @param config 配置
   */
  public setAppLockComConfig(config: Set<string>): void {
    this._appLockComConfig.clear();
    config?.forEach((bundle) => this._appLockComConfig.add(bundle));
  }

  /**
   * 赋值应用锁实况通知白名单配置
   *
   * @param config 配置
   */
  public setAppLockLiveConfig(config: Set<string>): void {
    this._appLockLiveConfig.clear();
    config?.forEach((liveKey) => this._appLockLiveConfig.add(liveKey));
  }

  /**
   * 取值隐私类型
   *
   * @param param 隐私参数
   * @returns 隐私类型
   */
  public getPrivacyType(param?: PrivacyParam): ImmPrivacyType {
    // 应用锁开启，应用锁优先级高
    if (this.isAppLockEnable(param)) {
      log.showInfo(`getPrivacyType app lock enable: ${param?.bundleName}, ${param?.isLiveNt}`);
      return ImmPrivacyType.PRIVACY_APP_LOCK;
    }
    // 隐藏通知内容开启 && 锁屏锁定
    if (!this._isSecureAndLocked) {
      return ImmPrivacyType.PRIVACY_NONE;
    }
    if (param?.isLiveNt) {
      return this._isHideLiveContentEnable ? ImmPrivacyType.PRIVACY_HIDE_CONTENT : ImmPrivacyType.PRIVACY_NONE;
    }
    return this._isHideNtfContentEnable ? ImmPrivacyType.PRIVACY_HIDE_CONTENT : ImmPrivacyType.PRIVACY_NONE;
  }

  /**
   * 目标应用是否开启应用锁
   *
   * @param param 隐私参数
   * @returns true开启应用锁
   */
  private isAppLockEnable(param?: PrivacyParam): boolean {
    let bundleName = param?.bundleName ?? '';
    let appIndex = param?.appIndex ?? 0;
    // 应用锁白名单
    if (this._appLockExemptedSet.has(bundleName)) {
      return false;
    }
    // 应用锁开关未开启
    let appLockMgr = AppLockManager.getInstance();
    let key = appLockMgr?.getAppKey(bundleName, appIndex);
    if (!this._appLockSet.has(key) && appLockMgr?.getAppLockStatus(bundleName, appIndex) !== AppLockStatusEnum.LOCK) {
      return false;
    }
    // 实况通知应用锁：非白名单 && 锁屏锁定
    if (param?.isLiveNt) {
      let liveKey = `${param.bundleName}_${param.sysTypeCode}`;
      return this._isSecureAndLocked && !this._appLockLiveConfig.has(liveKey);
    }
    // 普通通知应用锁： 非白名单
    return !this._appLockComConfig.has(param?.bundleName ?? '');
  }

  /**
   * 设置AOD开启状态
   *
   * @param isAod true开启AOD
   */
  public setAodMode(isAod?: boolean): void {
    let result = isAod ?? false;
    if (this._isAodMode !== result) {
      this._isAodMode = result;
      this.notifyStateChange(SlImmBindStPt.PT_AOD_MODE);
    }
  }

  /**
   * 当前AOD开启状态
   *
   * @returns true AOD开启
   */
  public isAodMode(): boolean {
    return this._isAodMode;
  }

  /**
   * 来通知自动亮屏开关
   *
   * @param isAutoScreenOn true自动亮屏
   */
  public setNtfAutoScreenOn(isAutoScreenOn?: boolean): void {
    let result = isAutoScreenOn ?? false;
    if (this._isNtfAutoScreenOne !== result) {
      this._isNtfAutoScreenOne = result;
      this.notifyStateChange(SlImmBindStPt.PT_NTF_AUTO_SCREEN_ON);
    }
  }

  /**
   * 来通知自动亮屏
   *
   * @returns true 来通知自动亮屏
   */
  public isNtfAutoScreenOn(): boolean {
    return this._isNtfAutoScreenOne;
  }

  /**
   * 当前屏幕是否亮屏状态
   *
   * @param isScreenOn true 屏幕亮屏
   */
  public setCurScreenOn(isScreenOn?: boolean): void {
    let result = isScreenOn ?? false;
    if (this._isCurScreenOn !== result) {
      this._isCurScreenOn = result;
      this.notifyStateChange(SlImmBindStPt.PT_CUR_SCREEN_ON);
    }
  }

  /**
   * 当前屏幕是否亮屏状态
   *
   * @returns true 屏幕亮屏
   */
  public isCurScreenOn(): boolean {
    return this._isCurScreenOn;
  }

  /**
   * 可进沉浸态数据标识全集
   *
   * @returns 标识集
   */
  public getAllImmHashcode(): Set<string> {
    return this._allImmHashcode;
  }
}

// 保持单例
export const slImmBindSt: SlImmBindStateV2 = BaseState.wrap(SlImmBindStateV2);