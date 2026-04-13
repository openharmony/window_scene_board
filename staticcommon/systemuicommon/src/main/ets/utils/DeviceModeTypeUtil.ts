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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceModeEnum, CommonConstants } from '@ohos/commonconstants';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'getIsInEmergencyOrThermalSafeMode';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export const getIsInEmergencyOrThermalSafeMode = (type: DeviceModeEnum): boolean => {
  let tempStatus = false;
  if (type === DeviceModeEnum.EMERGENCY_MODE || type === DeviceModeEnum.THERMAL_SAFE_MODE) {
    tempStatus = true;
  } else {
    tempStatus = false;
  };
  log.showInfo('capsuleList safeMode:' + tempStatus);
  return tempStatus;
};