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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { messageChannel } from '@ohos/systemuicommon/src/main/ets/messageChannel/MessageChannel';
import { sEventManager } from '@ohos/frameworkwrapper/src/main/ets/utils/EventManager';
import Constants from '../Util/Constants';

const TAG = 'CastDeviceControlDc';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

export class CastDeviceControlDc {
  private static controller: CastDeviceControlDc | undefined = undefined;

  public static getInstance(): CastDeviceControlDc {
    if (!CastDeviceControlDc.controller) {
      CastDeviceControlDc.controller = new CastDeviceControlDc();
      CastDeviceControlDc.controller.init();
    }
    return CastDeviceControlDc.controller;
  }

  /**
   * 初始化
   */
  init() {
    // 监听设备切换
    sEventManager.subscribe('outOutDeviceChangeEvent', this.deviceChangeCallback);
  }

  public deviceChangeCallback = () => {
    messageChannel.sendMessage(Constants.ASYNC_CAST_DEVICE_CONTROL, {type: 'outOutDeviceChangeEvent'});
  }

  /**
   * 投播初始化
   * @param sessionId
   * @param bundleName
   */
  startControl(sessionId: string, bundleName?: string) {
    messageChannel.sendMessage(Constants.ASYNC_CARD_MEDIA_CONTROLLER, {
      type: 'startCastControl', sessionId, bundleName,
    });
  }

  /**
   * 释放castDeviceControl
   */
  release() {
    // 解注册设备切换
    sEventManager.off('outOutDeviceChangeEvent', this.deviceChangeCallback);
    CastDeviceControlDc.controller = undefined;
    messageChannel.sendMessage(Constants.ASYNC_CAST_DEVICE_CONTROL, {type: 'release'});
  }

  /**
   * 选择设备
   * @param selectDevId
   * @param sessionId
   * @param isCall
   */
  selectDevice(selectDevId: number | string, sessionId: string, isCall: boolean) {
    messageChannel.sendMessage(Constants.ASYNC_CAST_DEVICE_CONTROL, {
      type: 'selectDevice', sessionId, selectDevId, isCall,
    });
  }
}