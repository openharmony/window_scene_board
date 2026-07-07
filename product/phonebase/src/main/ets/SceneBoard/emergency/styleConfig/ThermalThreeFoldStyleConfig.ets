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
import { CommonStyle } from '@ohos/emergencymode/src/main/ets/common/CommonStyle';

const TAG = 'ThermalThreeFoldStyleConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 三折叠热安全样式配置
 */
export class ThermalThreeFoldStyleConfig extends CommonStyle {
  private static instance: ThermalThreeFoldStyleConfig;

  private constructor() {
    super();
    // 三折叠三种形态的图标大小是固定的，无变化
    this.appItemWidth = 52;
    this.appItemHeight = 72;
    this.marginTopOfTopText = 104;
    this.marginBottomOfTopText = 18.5;
    this.widthOfClock = 220;
    this.heightOfClock = 107;
    this.marginBottomOfBottomText = 56;
  }

  public static getInstance(): ThermalThreeFoldStyleConfig {
    if (!ThermalThreeFoldStyleConfig.instance) {
      ThermalThreeFoldStyleConfig.instance = new ThermalThreeFoldStyleConfig();
    }
    return ThermalThreeFoldStyleConfig.instance;
  }
}