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

import { AppItemInfo } from '@ohos/launchercommon';
import lazy { ResourceManager } from '@ohos/frameworkwrapper';

export class AppCastUtil {
  public static isHuaweiCast(bundleName: string): boolean {
    return bundleName === 'com.ohos.huaweicast';
  }

  /**
   * 获取到应用动态缓存的图标，只处理无线投屏场景
   * @param appInfo
   * @returns
   */
  public static getMissionIcon(appInfo: AppItemInfo): PixelMap | undefined {
    if (AppCastUtil.isHuaweiCast(appInfo.bundleName)) {
      return ResourceManager.getInstance()
        .getCachedIconPixelMap(appInfo.appIconId, appInfo.bundleName, appInfo.moduleName);
    }
    return undefined;
  }
}