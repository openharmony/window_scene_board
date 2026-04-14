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

import ctx from '@ohos.app.ability.common';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'ResourceUtil');

export class ResourceUtil {
  public static context: ctx.ExtensionContext | undefined;

  public static setContext(context: ctx.ExtensionContext): void {
    ResourceUtil.context = context;
  }

  public static clearContext(): void {
    ResourceUtil.context = undefined;
  }

  public static getFontScale(): number {
    return ResourceUtil.context?.config.fontSizeScale ?? 1;
  }

  public static isRTL(): boolean {
    return AppStorage.get<boolean>('isSystemLanguageRTL') as boolean;
  }

  /**
   * 应用内字串获取通过资源名
   *
   * @param resName 资源名
   * @return 字串
   */
  public static getInnerStringByName(resName: string): string | null {
    if (!resName) {
      return null;
    }
    try {
      return ResourceUtil.context?.resourceManager?.getStringByNameSync(resName) as string;
    } catch (error) {
      log.showInfo(`getStringByNameSync error ${error}`);
      return null;
    }
  }
}