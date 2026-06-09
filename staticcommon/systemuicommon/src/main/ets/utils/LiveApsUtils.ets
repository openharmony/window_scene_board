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

// import apsManager from '@hms.graphic.apsManager';
import deviceInfo from '@ohos.deviceInfo';
import { Logger, LogDomain } from '@ohos/basicutils';
import { ApsUtils } from '@ohos/frameworkwrapper';
import { SystemUICcmConfig, ScenePolicy } from './SystemUICcmConfig';

const TAG = 'LiveApsUtils';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

/**
 * 实况Aps控帧工具类
 */
export class LiveApsUtils {
  /**
   * 实况通知APS模块场景启动和结束
   * @param state 状态 1表示启动0表示结束
   */
  public static setLiveApsScene(state: number): void {
    // const deviceName = deviceInfo.productSeries;
    // let apsPolicy: apsManager.SceneAnimation | undefined;
    // const frameRateCtrlScene = SystemUICcmConfig.instance.liveConfig.frameRateCtrlScene;
    // if (frameRateCtrlScene !== undefined && frameRateCtrlScene.includes(ScenePolicy.BACK_DESKTOP)) {
    //   apsPolicy = apsManager.SceneAnimation.BACK_DESKTOP;
    // }
    // if (apsPolicy !== undefined) {
    //   log.showInfo(TAG, `setLiveApsScene deviceName [${deviceName}], apsPolicy [${apsPolicy}]`);
    //   ApsUtils.setApsScene(apsPolicy, state);
    // }
  }
}
