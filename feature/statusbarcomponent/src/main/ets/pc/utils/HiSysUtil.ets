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
import { HiSysEventUtil } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/HiSysEventUtil';
import { PositionProperty } from '../plugingroup/viewdata/PositionProperty';
import { PluginStyleUtil } from '../common/PluginStyleUtil';

const TAG = 'HiSysUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

// 语音助手语音图标单独分组，其图标个数
const assistantVoiceNum: number = 1;

export class HiSysUtil {
  private static instance: HiSysUtil;
  public isStart: boolean = false;
  private visiblePropertysNum: number = 0;

  private constructor() {
  }

  static getInstance(): HiSysUtil {
    if (!HiSysUtil.instance) {
      HiSysUtil.instance = new HiSysUtil();
    }
    return HiSysUtil.instance;
  }

  init() {
    this.isStart = true;
  }

  private getPropertysNum(property: PositionProperty): number {
    return property.getVisualPluginNumOnDock() + assistantVoiceNum;
  }

  public hiSysOnIconItemsNumberChange(property: PositionProperty): void {
    if (!this.isStart) {
      log.showWarn(`isStart is false`)
      return;
    }
    if (PluginStyleUtil.isMacStyle()) {
      return;
    }
    let visibleNum = this.getPropertysNum(property);
    log.showInfo('hiSysOnIconItemsNumberChange, visibleNum:' +
      visibleNum + ' visiblePropertysNum:' + this.visiblePropertysNum);
    if (this.visiblePropertysNum === visibleNum) {
      log.showWarn(`visiblePropertysNum equal visibleNum`)
      return;
    }
    this.visiblePropertysNum = visibleNum;
    HiSysEventUtil.hiSysOnIconItemsNumberChange(visibleNum);
  }
}