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
import {
  ContextUtil,
  FileUtil,
  NullableType,
  PreferenceStoreCache,
  Singleton,
  TsLog,
} from '@ohos/themeservicebase/Index';
import { TServiceApi } from '@ohos/themeservice_inner_api/Index';
import { TSPathUtils } from '../util/TSPathUtils';
import { ThemeCacheInfo } from './ThemeInfoStoreCache';

import { hash } from '@kit.CoreFileKit';
import { themeInfoService } from '../service/impl/ThemeInfoServiceImpl';
import taskPool from '@ohos.taskpool';
import TaskPoolManager from '../util/TaskPoolManager';
import { ThemeOptimizeInfo } from './ThemeOptimizeInfo';

const TAG: string = `ThemeOptimizeCache`;

@Concurrent
async function updateOptimizeCache(caches: ThemeCacheInfo[], optimizeInfos: ThemeOptimizeInfo[], rootPath: string):
  Promise<ThemeOptimizeInfo[]> {
  const logTag: string = 'updateOptimizeCache';
  let validOptimizeInfo: ThemeOptimizeInfo[] = [];
  if (caches.length === 0 || optimizeInfos.length === 0) {
    TsLog.info(logTag, `optimizeInfo or cache length is 0, need update`);
    await FileUtil.rmdirAsync(rootPath);
    return validOptimizeInfo;
  }
  TsLog.info(logTag, `start update optimize cache, optimizeInfos: ${optimizeInfos.length}, caches: ${caches.length}`);
  for (let info of optimizeInfos) {
    const cache: NullableType<ThemeCacheInfo> = caches.find(item => item.id === info.themeId);
    const optThemePath: string = `${rootPath}/${info.themeId}/opt/${info.optType}`;
    if (!cache) {
      TsLog.info(logTag, `cache undefined, remove invalid cache: ${info.themeId}`);
      await FileUtil.rmdirAsync(optThemePath);
      continue;
    }
    const presetThemePath: string = `${cache.srcPath}/${info.optType}/${info.name}`;
    let newHash: string = '';
    try {
      newHash = await hash.hash(presetThemePath, 'sha256');
    } catch (err) {
      TsLog.error(logTag, `update theme optimize cache error:`, err);
    }
    if (newHash !== info.hash) {
      // 文件hash值有变化，删除原缓存
      TsLog.info(logTag, `hash change, remove invalid cache: ${info.themeId}`);
      await FileUtil.rmdirAsync(optThemePath);
      continue;
    }
    validOptimizeInfo.push(info);
  }
  return validOptimizeInfo;
}

/**
 * 优化主题资源信息缓存，记录原始资源文件hash值
 */
export class ThemeOptimizeCache extends PreferenceStoreCache<ThemeOptimizeInfo[]> {
  private static readonly INSTANCE: Singleton<ThemeOptimizeCache> =
    new Singleton<ThemeOptimizeCache>(() => new ThemeOptimizeCache());

  private constructor() {
    super(TServiceApi.preference(ContextUtil.getTsApplicationContext(), 'optimize_theme'));
  }

  /**
   * 获取单例对象
   *
   * @returns 对象
   */
  public static getInstance(): ThemeOptimizeCache {
    return ThemeOptimizeCache.INSTANCE.get();
  }

  /**
   * 刷新缓存
   */
  public async refreshCache(): Promise<void> {
    const optimizeInfos: NullableType<ThemeOptimizeInfo[]> = await this.get();
    const caches: NullableType<ThemeCacheInfo[]> = themeInfoService.get().getCacheThemeList();
    if (!optimizeInfos || !caches) {
      TsLog.info(TAG, `optimizeInfo or cache is undefined`);
      return;
    }
    const rootPath: string = TSPathUtils.getTsPresetOptimizePath();
    const task: taskPool.Task = new taskPool.Task(updateOptimizeCache, caches, optimizeInfos, rootPath);
    let result: ThemeOptimizeInfo[] = [];
    try {
      result = (await TaskPoolManager.getInstance().processTask(task)) as ThemeOptimizeInfo[] ?? [];
    } catch (e) {
      TsLog.error(TAG, 'refreshCache failed:', e);
    }
    await this.update(result);
  }
}