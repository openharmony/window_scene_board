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
import { Context } from '@kit.AbilityKit';
import { createPreference, PreferenceApi, serviceRegister } from '@ohos/themeservicebase';
import { LemApi } from './api/LemApi';
import { ThemeActivateApi } from './api/ThemeActivateApi';
import { UpgradeApi } from './api/UpgradeApi';
import { SubScreenApi } from './api/SubScreenApi';
import { TsPreferenceName } from './constant/TSTypes';
import { LemDefaultApi } from './default/LemDefaultApi';
import { ThemeActivateDefaultApi } from './default/ThemeActivateDefaultApi';
import { ThemeInfoForInnerServiceDefaultApi } from './default/ThemeInfoForInnerServiceDefaultApi';
import { UpgradeDefaultApi } from './default/UpgradeDefaultApi';
import { SubScreenDefaultApi } from './default/SubScreenDefaultApi';
import { TServiceApiName } from './TServiceApiName';
import { ThemeInfoApi } from './api/ThemeInfoApi';

export namespace TServiceApi {
  export function preference(context: Context, name: TsPreferenceName): PreferenceApi {
    return createPreference(context, name);
  }

  export function lem(): LemApi {
    return serviceRegister.get<LemApi>(TServiceApiName.LEM) ?? new LemDefaultApi();
  }

  export function subScreen(): SubScreenApi {
    return serviceRegister.get<SubScreenApi>(TServiceApiName.SUB_SCREEN) ?? new SubScreenDefaultApi();
  }

  export function upgrade(): UpgradeApi {
    return serviceRegister.get<UpgradeApi>(TServiceApiName.UPGRADE) ?? new UpgradeDefaultApi();
  }

  export function themeActivate(): ThemeActivateApi {
    return serviceRegister.get<ThemeActivateApi>(TServiceApiName.THEME_ACTIVATE) ?? new ThemeActivateDefaultApi();
  }

  export function themeInfoInner(): ThemeInfoApi {
    return serviceRegister.get<ThemeInfoApi>(TServiceApiName.THEME_INFO_SERVICE) ??
      new ThemeInfoForInnerServiceDefaultApi();
  }
}