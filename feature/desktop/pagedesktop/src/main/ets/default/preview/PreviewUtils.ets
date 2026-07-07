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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { BundleConstants, GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';

/**
 * 预览帮助类
 */
export class PreviewUtils {
  /**
   * 检查对象是否为空
   * @param obj 检查对象
   * @returns 是否是空对象
   */
  public static isEmpty(obj: Object | number | undefined): boolean {
    return (typeof obj === 'undefined' || obj == null || obj === '');
  }

  /**
   * 检查字符串是否为空
   * @param str 字符串
   * @returns 是否是空字符串
   */
  public static checkStrIsEmpty(str: string): boolean {
    return str === undefined || str === null || str.trim().length === 0;
  }

  public static isVoiceAbilityForm(bundleName: string, abilityName: string): boolean {
    return bundleName === BundleConstants.AI_SUGGESTION_BUNDLE && abilityName === BundleConstants.AI_SUGGESTION_ABILITY;
  }

  public static isFormSupportShadow(formItem: GridLayoutItemInfo): boolean {
    return DeviceHelper.isBarPhone() && !formItem.isTransparent;
  }
}