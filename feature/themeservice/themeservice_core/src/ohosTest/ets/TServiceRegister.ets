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

import { TServiceApiName } from '@ohos/themeservice_inner_api/Index';
import { serviceRegister, TsLog } from '@ohos/themeservicebase/Index';
import { DeviceHelper } from '../util/DeviceHelper';
import { ThemeActivateServiceImpl } from './impl/ThemeActivateServiceImpl';
import { UpgradeApiImpl } from './impl/UpgradeApiImpl';

const TAG: string = 'TServiceRegister';

export namespace TServiceRegister {
  export function registerService(): Promise<void> {
    serviceRegister.register(TServiceApiName.UPGRADE, () => new UpgradeApiImpl())
      .register(TServiceApiName.THEME_ACTIVATE, () => new ThemeActivateServiceImpl());
    if (DeviceHelper.isLemFoldProduct()) {
      return registerLemService();
    }
    return Promise.resolve();
  }

  function registerLemService(): Promise<void> {
    TsLog.info(TAG, `registerLemService... `);
    return import('@ohos/themeservice_core_lem').then((ns) => {
      ns.TSServiceRegister.registerLemService();
      TsLog.info(TAG, `registerLemService. `);
    });
  }
}