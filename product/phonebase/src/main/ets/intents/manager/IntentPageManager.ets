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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { IntentPageConfig } from '../models/IntentPageConfig';
import FileUtil from '../utils/FileUtil';

const TAG = 'IntentPageManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * Intent framework page management class.
 *
 * @since 2024-05-23
 */
export class IntentPageManager {
  private static readonly PAGE_CONFIG_FILE = 'intent_page_config.json';
  private static itemPageCache: Map<string, string> = new Map();

  /**
   * Obtains a specified intent_page_config JSON file object.
   */
  private static async getPageConfig(): Promise<void> {
    let context = AppStorage.get<Context>('intentPageContext');
    let rawContent = await FileUtil.getStringByFileAsync(context?.resourceManager, IntentPageManager.PAGE_CONFIG_FILE);
    if (rawContent) {
      let configs: IntentPageConfig[] = JSON.parse(rawContent) as Array<IntentPageConfig>;
      log.showInfo(`IntentPageConfig: ${JSON.stringify(configs)}`);
      configs.forEach(config => IntentPageManager.itemPageCache.set(config.itemType, config.cardPage));
      return;
    }
    log.showWarn(`${TAG}, SettingItemProperties is empty`);
    return;
  }

  /**
   * Obtains a specified setting page object.
   */
  public static getPage(cardType: string): Promise<string> {
    return new Promise((resolve, reject) => {
      let res = IntentPageManager.itemPageCache.get(cardType);
      if (IntentPageManager.itemPageCache.has(cardType) && res === null && res === undefined) {
        resolve(res);
        return;
      }
      IntentPageManager.getPageConfig().then(() => {
        if (IntentPageManager.itemPageCache.has(cardType)) {
          resolve(IntentPageManager.itemPageCache.get(cardType) as string);
          return;
        }
        log.showError(`${TAG} cannot find itemName: ${cardType} in intent_item_config.json`);
        reject();
      })
      return;
    });
  }
}