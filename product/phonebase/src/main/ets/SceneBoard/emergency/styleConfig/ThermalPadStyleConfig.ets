/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { EmergencyUtils } from '@ohos/emergencymode/src/main/ets/common/EmergencyUtils';
import { CommonStyle } from '@ohos/emergencymode/src/main/ets/common/CommonStyle';

const TAG = 'ThermalPadStyleConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class ThermalPadStyleConfig extends CommonStyle {
  private static instance: ThermalPadStyleConfig;

  public constructor() {
    super();
    this.marginTopOfTopText = 104;
    this.marginBottomOfTopText = 17.5;
    this.widthOfClock = 355;
    this.heightOfClock = 151;
    this.marginBottomOfBottomText = 56;
    this.appItemWidth = 80;
    this.appItemHeight = 100;
    let gridWidthAndGutter: number[] = EmergencyUtils.getGridWidthAndGutter('pad');
    let gridWidth: number = gridWidthAndGutter[0];
    let gridGutter: number = gridWidthAndGutter[1];
    this.appItemPadding = (this.appNameWidth - this.appItemWidth) >> 1;
    this.appGridGutterX = ((4 * gridWidth + 5 * gridGutter - this.appItemWidth) >> 1) - (this.appItemPadding << 1);
    this.appGridGutterY = 60;
    this.appGridWidth = 4 * gridWidth + 5 * gridGutter + 2 * this.appItemWidth + (this.appItemPadding << 1);
    this.appGridHeight = 2 * this.appItemHeight + this.appGridGutterY;
    log.showInfo(`Config gridWidth: ${gridWidth}, gridGutter: ${gridGutter}, appGridGutterX: ${this.appGridGutterX}`);
  }

  public static getInstance(): ThermalPadStyleConfig {
    if (!ThermalPadStyleConfig.instance) {
      ThermalPadStyleConfig.instance = new ThermalPadStyleConfig();
    }
    return ThermalPadStyleConfig.instance;
  }
}