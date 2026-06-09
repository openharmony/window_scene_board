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
import { BitUtil } from '../utils/BitUtil';

const TAG = 'NtfControlFlags';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export enum NtfControlFlagIdxEnum {
  EXTRA_SCREEN_ON = 21,
  CUSTOM_VIBRATION = 22,
  // 用增消息-置顶 控制位 1是，0否
  CAMPAIGN_NTF_DISPLAY_TOP_BIT = 16,
  // 用增消息-上分区 控制位 0是，1否
  CAMPAIGN_NTF_DISPLAY_MAIN_BIT = 18,
  // 用增消息-是否是用增消息 控制位
  CAMPAIGN_NTF_BIT = 25,
}

/**
 * 通知控制Flag工具类
 */
export class NtfControlFlags {
  /* 解析flags */
  public static parse(flags: number, idx: NtfControlFlagIdxEnum): boolean {
    return BitUtil.getStateByIdx(flags, idx);
  }
}

export class NtfControlConfig {
  public flags: number;

  constructor(flags: number) {
    this.flags = flags;
  }

  public isExtraScreenOn(): boolean {
    return this.getState(NtfControlFlagIdxEnum.EXTRA_SCREEN_ON);
  }

  public isCustomVibration(): boolean {
    return this.getState(NtfControlFlagIdxEnum.CUSTOM_VIBRATION);
  }


  /**
   * 判断ntf是否是用增非置顶的通知消息
   *
   * @returns true:是; false:否
   */
  public isNoTopCampaignNtf(): boolean {
    return (this.getState(NtfControlFlagIdxEnum.CAMPAIGN_NTF_BIT) &&
      !this.getState(NtfControlFlagIdxEnum.CAMPAIGN_NTF_DISPLAY_TOP_BIT));
  }

  /**
   * 判断ntf是否是用增、上半区置顶的通知消息
   *
   * @returns true:是; false:否
   */
  public isMainTopCampaignNtf(): boolean {
    return this.getState(NtfControlFlagIdxEnum.CAMPAIGN_NTF_BIT) &&
    this.getState(NtfControlFlagIdxEnum.CAMPAIGN_NTF_DISPLAY_TOP_BIT) &&
      !this.getState(NtfControlFlagIdxEnum.CAMPAIGN_NTF_DISPLAY_MAIN_BIT);
  }

  /**
   * 判断ntf是否是用增、下半区置顶的通知消息
   *
   * @returns true:是; false:否
   */
  public isMoreTopCampaignNtf(): boolean {
    return this.getState(NtfControlFlagIdxEnum.CAMPAIGN_NTF_BIT) &&
    this.getState(NtfControlFlagIdxEnum.CAMPAIGN_NTF_DISPLAY_TOP_BIT) &&
    this.getState(NtfControlFlagIdxEnum.CAMPAIGN_NTF_DISPLAY_MAIN_BIT);
  }

  private getState(idx: NtfControlFlagIdxEnum): boolean {
    const ret = BitUtil.getStateByIdx(this.flags, idx);
    return ret;
  }
}