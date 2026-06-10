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
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { BitUtil } from '../utils/BitUtil';

const TAG = 'SysUI_NtfRemindFlags';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export enum NtfRemindFlagIdxEnum {
  SOUND = 0,
  LOCK_SCREEN = 1,
  BANNER = 2,
  ON_SCREEN = 3,
  VIBRATION = 4,
  STATUS_BAR_ICON = 5,
  CAPSULE_FLIP = 6
}

export enum SoundMode {
  JUST_RING = 0,
  SILENCE = 1,
  VIBRATION = 2,
  RING_AND_VIBRATION = 3
}

/**
 * 通知提醒Flag工具类
 */
export class NtfRemindFlags {
  /* 解析flags */
  public static parse(flags: number, idx: NtfRemindFlagIdxEnum): boolean {
    return BitUtil.getStateByIdx(flags, idx);
  }
}

export class NtfReminderConfig {
  public flags: number;

  constructor(flags: number) {
    this.flags = flags;
  }

  public isSoundEnable(): boolean {
    return this.getState('SOUND', NtfRemindFlagIdxEnum.SOUND);
  }

  public isLockScreenEnable(): boolean {
    return this.getState('LOCK_SCREEN', NtfRemindFlagIdxEnum.LOCK_SCREEN);
  }

  public isBannerEnable(): boolean {
    return this.getState('BANNER', NtfRemindFlagIdxEnum.BANNER);
  }

  public isOnScreenEnable(): boolean {
    return this.getState('ON_SCREEN', NtfRemindFlagIdxEnum.ON_SCREEN);
  }

  public isVibrationEnable(): boolean {
    return this.getState('VIBRATION', NtfRemindFlagIdxEnum.VIBRATION);
  }

  public isStatusBarIconEnable(): boolean {
    return this.getState('STATUS_BAR_ICON', NtfRemindFlagIdxEnum.STATUS_BAR_ICON);
  }

  public isCapsuleFlip(): boolean {
    return this.getState('CAPSULE_FLIP', NtfRemindFlagIdxEnum.CAPSULE_FLIP);
  }

  public setSound(isEnable: boolean | undefined): void {
    this.setState('SOUND', NtfRemindFlagIdxEnum.SOUND, isEnable);
  }

  public setLockScreen(isEnable: boolean | undefined): void {
    this.setState('LOCK_SCREEN', NtfRemindFlagIdxEnum.LOCK_SCREEN, isEnable);
  }

  public setBanner(isEnable: boolean | undefined): void {
    this.setState('BANNER', NtfRemindFlagIdxEnum.BANNER, isEnable);
  }

  public setOnScreen(isEnable: boolean | undefined): void {
    this.setState('ON_SCREEN', NtfRemindFlagIdxEnum.ON_SCREEN, isEnable);
  }

  public setVibration(isEnable: boolean | undefined): void {
    this.setState('VIBRATION', NtfRemindFlagIdxEnum.VIBRATION, isEnable);
  }

  public setStatusBarIcon(isEnable: boolean | undefined): void {
    this.setState('STATUS_BAR_ICON', NtfRemindFlagIdxEnum.STATUS_BAR_ICON, isEnable);
  }

  public setCapsuleFlip(isEnable: boolean | undefined): void {
    this.setState('CAPSULE_FLIP', NtfRemindFlagIdxEnum.CAPSULE_FLIP, isEnable);
  }

  private getState(tag: string, idx: NtfRemindFlagIdxEnum): boolean {
    const ret = BitUtil.getStateByIdx(this.flags, idx);
    return ret;
  }

  private setState(tag: string, idx: NtfRemindFlagIdxEnum, isOn: boolean | undefined): void {
    if (CommonUtils.isInvalid(isOn)) {
      log.showWarn('SetState ReminderFlags Failed. %{public}s.SetState. idx:%{public}d, oldFlags:%{public}d, isOn:%{public}s', tag, idx, this.flags, isOn);
      return;
    }
    log.showInfo('SetState %{public}s. idx:%{public}d, oldFlags:%{public}d, isOn:%{public}s', tag, idx, this.flags, isOn);
    this.flags = BitUtil.changeByIdx(this.flags, idx, isOn);
  }
}