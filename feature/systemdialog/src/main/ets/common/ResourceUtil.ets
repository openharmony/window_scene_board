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

import ctx from '@ohos.app.ability.common';
import { accessibility } from '@kit.AccessibilityKit';
import { LogDomain, Logger } from '@ohos/basicutils';

const TAG = 'ResourceUtil';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

export class ResourceUtil {
  public static context: ctx.ExtensionContext | undefined;

  public static setContext(context: ctx.ExtensionContext): void {
    ResourceUtil.context = context;
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
      log.showInfo(TAG, `getStringByNameSync error ${error}`);
      return null;
    }
  }

  /**
   * 在无障碍模式主动聚焦
   *
   * @param customId 主动聚焦组件Id
   */
  public static requestFocusAccessibility(customId: string): void {
    try {
      const eventInfo: accessibility.EventInfo = {
        type: 'requestFocusForAccessibility',
        bundleName: 'com.ohos.sceneboard',
        triggerAction: 'common',
        customId: customId,
      };
      accessibility.sendAccessibilityEvent(eventInfo, (err) => {
        if (err) {
          log.showError(TAG, `failed to send event, Code is ${err.code}, message is ${err.message}`);
          return;
        }
        log.showInfo(TAG, `succeeded in send event, eventInfo is ${eventInfo}`);
      });
    } catch (error) {
      log.showError(TAG, 'sendAccessibilityEvent failed');
    }
  }
}