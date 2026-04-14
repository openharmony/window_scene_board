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
import { IntentItemConfig } from '../models/IntentItemConfig';
import FileUtil from '../utils/FileUtil';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'IntentItemManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * Intent framework item management class.
 *
 * @since 2024-05-23
 */
export class IntentItemManager {
  private static readonly ITEM_CONFIG_FILE: string = 'intent_item_config.json';
  private static itemInfoCache: Map<string, IntentItemConfig> = new Map();

  /**
   * Obtains a specified intent_item_config JSON file object.
   */
  private static async getSettingItemsConfig(): Promise<void> {
    let context = AppStorage.get<Context>('intentPageContext');
    let rawContent = await FileUtil.getStringByFileAsync(context?.resourceManager, IntentItemManager.ITEM_CONFIG_FILE);
    if (rawContent) {
      try {
        let items: IntentItemConfig[] = JSON.parse(rawContent) as Array<IntentItemConfig>;
        log.showInfo(`SettingItemProperties: ${JSON.stringify(items)}`);
        items.forEach(item => IntentItemManager.itemInfoCache.set(item.itemName, item));
        return;
      } catch (error) {
        log.error('parse file intent_item_config error!');
      }
    }
    log.showWarn(`SettingItemProperties is empty`);
    return;
  }

  /**
   * Obtains a specified setting item object.
   */
  public static getItem(itemName: string): Promise<IntentItemConfig> {
    return new Promise((resolve, reject) => {
      if (IntentItemManager.itemInfoCache.has(itemName)) {
        resolve(IntentItemManager.itemInfoCache.get(itemName) as IntentItemConfig);
        return;
      }
      IntentItemManager.getSettingItemsConfig().then(() => {
        if (IntentItemManager.itemInfoCache.has(itemName)) {
          resolve(IntentItemManager.itemInfoCache.get(itemName) as IntentItemConfig);
          return;
        }
        log.showError(`cannot find itemName: ${itemName} in intent_item_config.json`);
        reject();
      }).catch((err: object) => {
        log.error(`getSettingItemsConfig error: ${err}`);
      });
    });
  }
}

