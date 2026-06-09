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

import { VerifyInfo, VerifyState, HasCredential} from '@ohos/screenlockcommon';
import { FingerprintData } from '@ohos/screenlockcommon/src/main/ets/manager/VerifyDataManager';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';

/**
 * 模拟的验证数据
 */
export class MockVerifyInfo extends VerifyInfo {
  public get isSupportUnlock(): boolean {
    return super.isSupportUnlock;
  }

  public get hasCredential(): boolean {
    return this._hasCredential !== HasCredential.NO_CREDENTIAL;
  }

  public set hasCredential(hasCredential: boolean) {
    this._hasCredential = hasCredential ? HasCredential.HAS_CREDENTIAL : HasCredential.NO_CREDENTIAL;
  }

  public get isSwitchOpen(): boolean {
    return this._isSwitchOpen;
  }

  public set isSwitchOpen(isSwitchOpen: boolean) {
    this._isSwitchOpen = isSwitchOpen;
  }

  public get strongAuthReason(): number {
    return this._strongAuthReason;
  }

  public set strongAuthReason(strongAuthReason: number) {
    if (this.authType === AuthType.PIN) {
      // PIN场景无须设置
      return;
    }
    if (this._strongAuthReason !== strongAuthReason) {
      this._strongAuthReason = strongAuthReason;
    }
  }

  public get authSubType(): number {
    return this._authSubType;
  }

  public set authSubType(authSubType: number) {
    this._authSubType = authSubType;
  }

  public get verifyState(): VerifyState {
    return this._verifyState;
  }

  public set verifyState(verifyState: VerifyState) {
    this._verifyState = verifyState;
  }

  public get verifyResult(): number {
    return this._verifyResult;
  }

  public set verifyResult(verifyResult: number) {
    this._verifyResult = verifyResult;
  }

  public get remainTimes(): number {
    return this._remainTimes;
  }

  public set remainTimes(remainTimes: number) {
    this._remainTimes = remainTimes;
  }

  public get freezingTime(): number {
    return this._freezingTime;
  }

  public set freezingTime(freezingTime: number) {
    this._freezingTime = freezingTime;
  }

  public get nextPhaseFreezingTime(): number {
    return this._nextPhaseFreezingTime;
  }

  public set nextPhaseFreezingTime(nextPhaseFreezingTime: number) {
    this._nextPhaseFreezingTime = nextPhaseFreezingTime;
  }

  public get hasSyncSensorInfo(): boolean {
    return this._hasSyncSensorInfo;
  }

  public set hasSyncSensorInfo(hasSyncSensorInfo: boolean) {
    this._hasSyncSensorInfo = hasSyncSensorInfo;
  }

  public set sensorInfo(sensorInfo: FingerprintData) {
    this._sensorInfo = sensorInfo;
  }

  public set isDirectUnlock(isDirectUnlock: boolean) {
    this._isDirectUnlock = isDirectUnlock;
  }

  public get isDirectUnlock(): boolean {
    return this._isDirectUnlock;
  }
}