/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { VisualEffectConstants } from '@ohos/commonconstants';

export class FormStackConfig {
  private static mInstance: FormStackConfig;
  private disableShadow: boolean = false;

  public static getInstance(): FormStackConfig {
    if (!FormStackConfig.mInstance) {
      FormStackConfig.mInstance = new FormStackConfig();
    }

    return FormStackConfig.mInstance;
  }

  public isSupportShadow(): boolean {
    return !this.disableShadow && (DeviceHelper.isBarPhone());
  }

  private constructor() {
    this.disableShadow = SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.ICON_CARD_SHADOW_DISABLE);
  }
}