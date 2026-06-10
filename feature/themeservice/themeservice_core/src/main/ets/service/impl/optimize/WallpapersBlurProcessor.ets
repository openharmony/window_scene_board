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

import taskPool from '@ohos.taskpool';
import { FileUtil, TsLog } from '@ohos/themeservicebase/Index';
import TaskPoolManager from '../../../util/TaskPoolManager';
import { WallpaperInfo } from '../activate/WallpaperCaller';
import { WallpaperBlurHandler } from './WallpaperBlurHandler';

const TAG: string = 'WallpapersBlurProcessor';

@Concurrent
async function saveWallpapersBlurImagePath(wallpapers: Array<WallpaperInfo>,
  wallpaperTypeStr: string, rootPath: string): Promise<Array<WallpaperInfo>> {
  const logTag: string = 'WallpapersBlurProcessor';
  await Promise.all(wallpapers?.map((value) => WallpaperBlurHandler.handleWallpaper(value, wallpaperTypeStr,
    rootPath)));
  TsLog.debug(logTag, `saveWallpapersBlurInTaskPool done`);
  return wallpapers;
}

@Concurrent
async function releaseCache(wallpapers: Array<WallpaperInfo>) {
  await Promise.all(wallpapers?.map((value) => FileUtil.deleteAsync(value.source)));
}

export class WallpapersBlurProcessor {
  static async saveWallpapersBlurInTaskPool(imagePath: Array<WallpaperInfo>,
    wallpaperTypeStr: string, rootPath: string): Promise<Nullable<Array<WallpaperInfo>>> {
    TsLog.debug(TAG, `start saveWallpapersBlurInTaskPool`);
    let result: Nullable<Array<WallpaperInfo>>;
    try {
      const task: taskPool.Task = new taskPool.Task(saveWallpapersBlurImagePath, imagePath, wallpaperTypeStr, rootPath);
      result = (await TaskPoolManager.getInstance().processTask(task)) as Array<WallpaperInfo>;
    } catch (e) {
      TsLog.error(TAG, 'save wallpapers blur taskPool.execute failed:', e);
    }
    return result;
  }

  static async releaseWallpaperBlurCache(wallpapers: Array<WallpaperInfo>) {
    try {
      const task: taskPool.Task = new taskPool.Task(releaseCache, wallpapers);
      await TaskPoolManager.getInstance().processTask(task);
    } catch (e) {
      TsLog.error(TAG, 'releaseCache taskPool.execute failed:', e);
    }
  }
}
