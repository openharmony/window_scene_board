/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { AppItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';

/**
 * Emergency Thermal Default App info.
 */
export class EmergencyThermalAppVo {
  /**
   * Application item info.
   */
  public appItem: AppItemInfo = new AppItemInfo();

  /**
   * Default emergency application
   *   1: The default application cannot be deleted,
   *   2 or undefined: Non-default applications can be deleted.
   */
  public defaultEmergencyApp?: number;
}