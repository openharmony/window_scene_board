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

import buffer from '@ohos.buffer';
import util from '@ohos.util';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import AiSuggestionActionManager from './AiSuggestionActionManager';

const TAG: string = 'AiSuggestionResourceManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * resource manager for ai suggestion
 */
export class AiSuggestionResourceManager {
  private static sInstance: AiSuggestionResourceManager = new AiSuggestionResourceManager();
  private resourceCacheMap: Map<string, string> = new Map();

  /**
   * get AiSuggestionResourceManager instance
   *
   * @return AiSuggestionResourceManager instance
   */
  static getInstance(): AiSuggestionResourceManager {
    return AiSuggestionResourceManager.sInstance;
  }

  async getResource(resUrl: string): Promise<string | undefined> {
    if (CheckEmptyUtils.checkStrIsEmpty(resUrl)) {
      return Promise.reject(new Error('getResource resUrl is invalid'));
    }

    let encodedRes = this.resourceCacheMap.get(resUrl);
    if (encodedRes) {
      return Promise.resolve(encodedRes);
    }

    // fetch resource from ai suggestion
    const resource = await AiSuggestionActionManager.getInstance().getResource(resUrl);
    if (CheckEmptyUtils.checkStrIsEmpty(resource?.res)) {
      return Promise.reject(new Error(`getResource failed, resUrl = ${resUrl}`));
    }
    try {
      const buf = buffer.from(resource?.res, 'hex');
      const base64 = new util.Base64Helper().encodeToStringSync(new Uint8Array(buf.buffer));
      log.showInfo(`getResource succeeded, resUrl = ${resUrl}, buf len = ${buf.buffer?.byteLength}`);
      encodedRes = `data:image/png;base64,${base64}`;
      this.resourceCacheMap.set(resUrl, encodedRes);
      AppStorage.setOrCreate(resUrl, encodedRes);
      return Promise.resolve(encodedRes);
    } catch (e) {
      return Promise.reject(new Error(`getResource failed, get buffer error, resUrl = ${resUrl}`));
    }
  }

  async loadResources(resUrls: string[]): Promise<void> {
    if (CheckEmptyUtils.isEmptyArr(resUrls)) {
      log.showWarn('loadResources resUrls is invalid');
      return;
    }

    await Promise.all(
      resUrls
        .filter(Boolean)
        .map(
          async (resUrl: string) => {
            await this.getResource(resUrl).catch(
              (err: Error) => {
                log.showError('loadResources occurs unknown error = %{public}s', err?.message);
              }
            );
          }
        )
    );
  }
}