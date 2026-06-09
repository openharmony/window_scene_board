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

import { SettingsDataUtils } from './SettingsDataUtils';
import Constants from '../model/Constants';
import settings from '@ohos.settings';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { StringUtil } from '../model/StringUtil';

const TAG = 'utils.CollaborationSwitchManager: ';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class CollaborationSwitchManager {

  public static getCollaborationSwitchState(): string {
    let state: string = SettingsDataUtils.getSettingsData(Constants.COLLABORATION_SERVICE_SWITCH,
      Constants.COLLABORATION_SERVICE_SWITCH_ON, settings.domainName.DEVICE_SHARED);
    if (StringUtil.checkStrIsEmpty(state)) {
      log.warn(TAG, 'collaboration service switch state is invalid');
      return Constants.COLLABORATION_SERVICE_SWITCH_ON;
    }
    log.info(TAG, `the collaboration service switch is active ? ${state}`);
    return state === Constants.COLLABORATION_SERVICE_SWITCH_ON ?
    Constants.COLLABORATION_SERVICE_SWITCH_ON : Constants.COLLABORATION_SERVICE_SWITCH_OFF;
  }
}