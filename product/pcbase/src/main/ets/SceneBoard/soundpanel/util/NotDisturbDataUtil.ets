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
/* instrument ignore file */

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DNDConstants } from '../common/Constants';
import SettingsUtil from './SettingsUtil';

const TAG = 'NotDisturbDataUtil';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class NotDisturbDataUtil {

  /**
   * 设置免打扰联系人豁免策略；目前pc无免打扰豁免联系人，适应畅联应用判断策略，默认禁止所有人打扰
   */
  public setCallMessagePolicyForbid(): void {
    log.info(`set call message policy forbid everyone`);
    SettingsUtil.setSystemValue(DNDConstants.FOCUS_MODE_CALL_MESSAGE_POLICY, DNDConstants.NOT_DISTURB_VALUE_ENABLE);
  }

  /**
   * 免打扰开关状态
   *
   * @returns
   */
  public async getDNDEnable(): Promise<boolean> {
    let isDNDEnable: boolean = await SettingsUtil.getSecureValue(DNDConstants.FOCUS_MODE_ENABLED,
      DNDConstants.NOT_DISTURB_VALUE_DISABLE) === DNDConstants.NOT_DISTURB_VALUE_ENABLE;
    log.info(`get DND enable: ${isDNDEnable}`);
    return isDNDEnable;
  }

  /**
   * 设置免打扰开关状态
   */
  public setDNDEnable(state: boolean): void {
    log.info(`set DND enable: ${state}`);
    SettingsUtil.setSecureValue(DNDConstants.FOCUS_MODE_ENABLED,
      state ? DNDConstants.NOT_DISTURB_VALUE_ENABLE : DNDConstants.NOT_DISTURB_VALUE_DISABLE);
  }

  /**
   * 设置，手动点击`立即打开`免打扰的状态，关联定时列表置灰
   *
   * @param state 状态值
   */
  public setDNDManualEnable(state: boolean): void {
    log.info(`set DND manual enable: ${state}`);
    SettingsUtil.setSystemValue(DNDConstants.FOCUS_MODE_MANUAL_ENABLE,
      state ? DNDConstants.NOT_DISTURB_VALUE_ENABLE : DNDConstants.NOT_DISTURB_VALUE_DISABLE);
  }

  /**
   * 手动点击`立即打开`免打扰的状态，关联定时列表置灰
   *
   * @returns 状态
   */
  public async getDNDManualEnable(): Promise<boolean> {
    let isDNDManualEnable: boolean = await SettingsUtil.getSystemValue(DNDConstants.FOCUS_MODE_MANUAL_ENABLE,
      DNDConstants.NOT_DISTURB_VALUE_DISABLE) === DNDConstants.NOT_DISTURB_VALUE_ENABLE;
    log.info(`get DND manual enable: ${isDNDManualEnable}`);
    return isDNDManualEnable;
  }

  /**
   * 设置免打扰定时时间段
   *
   * @param value 定时时间段
   */
  public setDNDTimers(value: string): void {
    SettingsUtil.setSystemValue(DNDConstants.FOCUS_MODE_TIMER, value);
  }

  /**
   * 获取免打扰定时时间段
   *
   * @returns
   */
  public async getDNDTimers(): Promise<string> {
    return await SettingsUtil.getSystemValue(DNDConstants.FOCUS_MODE_TIMER, DNDConstants.EMPTY_STRING);
  }

  /**
   * 获取免打扰已选择的豁免应用列表
   *
   * @returns
   */
  public async getTrustAppDataInfo(): Promise<string> {
    return await SettingsUtil.getSecureValue(DNDConstants.DO_NOT_DISTURB_APP_SELECTED_DATA, DNDConstants.EMPTY_STRING);
  }

  /**
   * 设置免打扰豁免应用
   *
   * @returns
   */
  public setDNDProfile(): void {
    SettingsUtil.setSecureValue(DNDConstants.FOCUS_MODE_PROFILE, DNDConstants.NOT_DISTURB_VALUE_ENABLE);
  }


  /**
   * 监听指定key字段的数据变化
   *
   * @param callback 回调
   * @returns 注册状态
   */
  registerDNDSettingsStatusChange(key: string, callback?: () => void): boolean {
    return SettingsUtil.registerKeyObserverSystem(key, () => {
      if (callback) {
        callback();
      }
    })
  }

  /**
   * 取消监听指定key字段的数据变化
   *
   * @returns 注册状态
   */
  unregisterDNDSettingsStatusChange(key: string): boolean {
    return SettingsUtil.unregisterKeyObserverSystem(key);
  }

}

let notDisturbDataUtil = new NotDisturbDataUtil();

export default notDisturbDataUtil as NotDisturbDataUtil;