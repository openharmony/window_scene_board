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
import { FileUtil, JsonUtils, Singleton, StoreCache, StoreManager, TsLog } from '@ohos/themeservicebase';
import { GlobalPersistInfo } from '../remote/model/GlobalPersistInfo';

const TAG: string = `GlobalPersistCache`;

export class GlobalPersistCache extends StoreCache<GlobalPersistInfo, string> {
  private static readonly INSTANCE: Singleton<GlobalPersistCache> =
    new Singleton<GlobalPersistCache>(() => new GlobalPersistCache());

  private constructor() {
    super(new GlobalPersistStoreManger());
  }

  /**
   * 获取单例对象
   * @returns 对象
   */
  public static getInstance(): GlobalPersistCache {
    return GlobalPersistCache.INSTANCE.get();
  }
}

class GlobalPersistStoreManger implements StoreManager<GlobalPersistInfo, string> {
  private readonly persistFile: string = `/data/themes/s/themeEngine/ts_globalPersist.json`;

  getName(): string {
    return `GlobalPersistStoreManger`;
  }

  async clear(): Promise<void> {
    TsLog.info(TAG, `clear`);
    await FileUtil.deleteAsync(this.persistFile);
  }

  async put(key: string, value: string | number): Promise<void> {
    TsLog.info(TAG, `put, value = ${value}`);
    if (!FileUtil.isFileExists(this.persistFile)) {
      FileUtil.writeFileSync(this.persistFile, JSON.stringify({ key, value }));
      return;
    }
    const persistInfo: object = JSON.parse(await FileUtil.readFileContent(this.persistFile));
    persistInfo[key] = value;
    FileUtil.writeFileSync(this.persistFile, JsonUtils.stringify(persistInfo));
  }

  async get(key: string, def?: string | number | undefined): Promise<string | number | undefined> {
    if (!FileUtil.isFileExists(this.persistFile)) {
      TsLog.info(TAG, `get, not find file, return def = ${def}`);
      return new Promise((resolve) => {
        resolve(def);
      });
    }

    const persistInfo: object = JSON.parse(await FileUtil.readFileContent(this.persistFile));
    TsLog.info(TAG, `get, return ${persistInfo[key]}`);
    return persistInfo[key];
  }

  decode(value: string): GlobalPersistInfo | undefined {
    return JsonUtils.parse(value);
  }

  encode(data: GlobalPersistInfo): string | undefined {
    return JsonUtils.stringify(data);
  }
}

