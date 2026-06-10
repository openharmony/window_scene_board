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
import { GlobalContext } from '../utils/GlobalContext';
import { common, contextConstant } from '@kit.AbilityKit';
import { HiDfxEventUtil } from '../hisysevent/HiDfxEventUtil';

const TAG = 'ContextModifyUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class ContextModifyUtils {
  static modifyGlobalContext(areaMode: contextConstant.AreaMode, callback: Function, callMessage: string): void {
    ContextModifyUtils.modifyTargetContext(GlobalContext.getContext(), areaMode, callback, callMessage);
  }

  static modifyTargetContext(targetContext: common.Context, areaMode: contextConstant.AreaMode, callback: Function,
    callMessage: string, needRecovery: boolean = true): void {
    let oldArea = targetContext.area;
    if (oldArea === areaMode) {
      try {
        callback(targetContext);
      } catch (err) {
        log.showError(`modifyGlobalContext whitout change call error, err:${err?.code} from:${callMessage}`);
      }
      return;
    }
    this.reportSwitchArea('modifyTargetContext', oldArea, areaMode, needRecovery, callMessage);
    targetContext.area = areaMode;
    try {
      callback(targetContext);
    } catch (err) {
      log.showError(`modifyGlobalContext error, err:${err?.code}`);
    } finally {
      if (needRecovery) {
        targetContext.area = oldArea;
      }
      log.showWarn(`modifyGlobalContext finsh from:${callMessage} finsh`);
    }
  }

  static async modifyTargetContextAsync(targetContext: common.Context, areaMode: contextConstant.AreaMode,
    callback: Function, callMessage: string, needRecovery: boolean = true): Promise<void> {
    let oldArea = targetContext.area;
    if (oldArea === areaMode) {
      try {
        await callback(targetContext);
      } catch (err) {
        log.showError(`modifyGlobalContext whitout change call error, err:${err?.code} from:${callMessage}`);
      }
      return;
    }
    this.reportSwitchArea('modifyTargetContextAsync', oldArea, areaMode, needRecovery, callMessage);
    targetContext.area = areaMode;
    try {
      await callback(targetContext);
    } catch (err) {
      log.showError(`modifyGlobalContext error, err:${err?.code} from:${callMessage}`);
    } finally {
      if (needRecovery) {
        targetContext.area = oldArea;
      }
      log.showWarn(`modifyGlobalContext finsh from:${callMessage} finsh`);
    }
  }

  private static reportSwitchArea(label: string, oldArea: contextConstant.AreaMode, newArea: contextConstant.AreaMode,
    needRecovery: boolean, callMessage: string): void {
    log.showWarn(`${label} from:${callMessage} oldArea:${oldArea} and newArea:${newArea} and needRecovery:${needRecovery}`);
    HiDfxEventUtil.reportLauncherLayoutAbnormal('MODIFY_CONTEXT_AREA',
      `${oldArea} to ${newArea} when ${label}_${callMessage} and needRecovery:${needRecovery}`);
  }
}