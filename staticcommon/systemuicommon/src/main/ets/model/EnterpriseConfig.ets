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
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import settings from '@ohos.settings';
import type ctx from '@ohos.app.ability.common';

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'EnterpriseConfig');
const ENTERPRISE_DEVICE_SYS_KEY = 'const.edm.is_enterprise_device';
const ENTERPRISE_SETTING_KEY = 'com.enterprise.custom_hide_app_list';

export class EnterpriseConfig {
  private static flag: boolean = false;
  private static hideBundles: Set<string> = new Set();

  public static loadConfig(context: ctx.Context): void {
    EnterpriseConfig.flag = EnterpriseConfig.loadFlag();
    if (EnterpriseConfig.flag) {
      EnterpriseConfig.hideBundles = EnterpriseConfig.loadHideBundles(context);
    }
  }

  private static loadFlag(): boolean {
    try {
      const ret = systemParameterEnhance.getSync(ENTERPRISE_DEVICE_SYS_KEY, 'false') === 'true';
      log.showInfo('LoadFlog ret: %{public}s', ret);
      return ret;
    } catch (error) {
      log.error('GetFlag error', error);
      return false;
    }
  }

  private static loadHideBundles(context: ctx.Context): Set<string> {
    const configValue = EnterpriseConfig.loadHideAppConfigValue(context);
    let config: string[] = [];
    try {
      config = configValue.split(',');
    } catch (error) {
      log.error('GetHideBundles', error);
    }
    return new Set(config);
  }

  private static loadHideAppConfigValue(context: ctx.Context): string {
    try {
      const val: string = settings.getValueSync(context, ENTERPRISE_SETTING_KEY, '', settings.domainName.USER_PROPERTY);
      log.showInfo('LoadHideAppConfigValue %{public}s', val);
      return val;
    } catch (error) {
      log.error('LoadHideAppConfigValue error', error);
      return '';
    }
  }

  public static isHideBundle(bundle: string): boolean {
    const ret = EnterpriseConfig.flag && EnterpriseConfig.hideBundles.has(bundle);
    return ret;
  }
}
