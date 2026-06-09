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

import type { LockscreenFormConfig } from '../../common/WidgetParam';

export default class ScreenLockFormUtil {
  public static getFormConfigKey(form: LockscreenFormConfig) {
    return `${form.dimensionX}_${form.formInfo?.bundleName}_${form.formInfo?.cardName}_${form.formInfo?.tempId}`;
  }

  public static getFormConfigByKey(formConfigs: LockscreenFormConfig[],
    targetKey: string): LockscreenFormConfig | undefined {
    for (let i: number = 0; i < formConfigs.length; i++) {
      let key: string = ScreenLockFormUtil.getFormConfigKey(formConfigs[i]);
      if (key === targetKey) {
        return formConfigs[i];
      }
    }
    return undefined;
  }
}