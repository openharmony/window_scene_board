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
import taskpool from '@ohos.taskpool';
// import { manager } from '@kit.NearLinkKit';

const TAG = 'Ctrl.NearLinkManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

const STATE_TURNING_ON: number = 0;
const STATE_ON: number = 1;

/**
 * 星闪管理模块
 */
export default class NearLinkManager {
  private static instance?: NearLinkManager = undefined;

  /**
   * Get the instance of NearLinkManager
   */
  static getInstance(): NearLinkManager {
    if (!NearLinkManager.instance) {
      log.showInfo('createInstance');
      NearLinkManager.instance = new NearLinkManager();
    }
    return NearLinkManager.instance;
  };

  /**
   * 初始化星闪状态
   */
  public getNearLinkState(): boolean {
    try {
      // let nearLinkState: manager.NearlinkState = manager.getState();
      // log.showInfo(`init near link state : ${nearLinkState}`);
      // return nearLinkState as number === STATE_ON || nearLinkState as number === STATE_TURNING_ON;
    } catch (error) {
      log.showError('initNearLinkState error', error);
    }
    return false;
  }

  /**
   * 注册监听
   */
  public subscribeNearLinkState(onNearLinkStateChange: Function): void {
    try {
      // manager.on('stateChange', (nearLinkState) => {
      //   log.showInfo(`stateChange : ${nearLinkState}`);
      //   let status = nearLinkState as number === STATE_ON || nearLinkState as number === STATE_TURNING_ON;
      //   onNearLinkStateChange(status);
      // });
    } catch (error) {
      log.showError('subscribe near link state error', error);
    }
  }

  /**
   * 销毁监听
   */
  public unSubscribeNearLinkState(): void {
    try {
      // manager.off('stateChange');
    } catch (error) {
      log.showError('unsubscribe near link state error', error);
    }
  }

  /**
   * 并发执行星闪开关切换
   * @param isOn 是否打开星闪
   */
  public changeNearLinkStateConcurrent(isOn: boolean): void {
    try {
      taskpool.execute(changeNearLinkState, isOn).then((result: Object) => {
        log.showDebug(`switchNearLink to ${isOn}, result:${result}`);
      }).catch((error: Error) => {
        log.showError(`changeNearLinkState failed. Error message: ${error.message}`);
      });
    } catch (error) {
      log.showError('switchNearLinkState error', error);
    }
  }
}

/**
 * 调用星闪接口，切换星闪状态
 */
async function changeNearLinkState(isOn: boolean): Promise<number> {
  'use concurrent';
  try {
    if (isOn) {
      // manager.enable();
    } else {
      // manager.disable();
    }
    return 0;
  } catch (err) {
    let log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, 'Ctrl.NearLinkManager');
    log.error('change near link state error', err);
    return err?.code;
  }
}
