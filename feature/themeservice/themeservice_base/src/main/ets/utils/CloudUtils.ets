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
import { TsLog } from '../log/TsLog';
import { power, systemParameterEnhance } from '@kit.BasicServicesKit';

const TAG: string = 'CloudUtils';
const OUTDOOR_MODE: string = '64'; // 户外模式

/**
 * 云端模式工具类
 */
export class CloudUtils {
  /**
   * 判断是否处于云端模式
   */
  public static isInCloudMode(): boolean {
    let mode: string = systemParameterEnhance.getSync('ohos.boot.minisys.mode', '');
    let cloudMode: string = systemParameterEnhance.getSync('persist.phone_focus.advance.mode.status', '');
    TsLog.info(TAG, `mode = ${mode}, cloudMode = ${cloudMode}`);
    return mode === `cloud` || cloudMode === OUTDOOR_MODE;
  }
}