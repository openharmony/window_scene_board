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
import { systemDateTime } from '@kit.BasicServicesKit';
import { JsonUtils, Singleton, TsLog } from '@ohos/themeservicebase';
import {
  IgnoreUpdateThemeInfoCache,
  UpdateResourceInfo,
  UpdateThemeInfoCache,
  UpdateThemeRefreshTimeCache,
} from '../../cache/UpdateThemeInfoCache';
import { TSRemoteCaller, UpdatableResourceResult } from '../../remote/caller/TSRemoteCaller';
import { UpdateThemeInfoService } from '../api/UpdateThemeInfoService';

const TAG: string = 'UpdateThemeInfoServiceImpl';

const DURATION: number = 12 * 60 * 60 * 1000;

export class UpdateThemeInfoServiceImpl implements UpdateThemeInfoService {
  async getUpdateThemeListAndRefresh(): Promise<Nullable<UpdateResourceInfo[]>> {
    let needRefresh: boolean = false;
    try {
      let updateResourceArray: Nullable<UpdateResourceInfo[]> = await UpdateThemeInfoCache.getInstance().get();
      if (!updateResourceArray) {
        TsLog.info(TAG, `getUpdateThemeList, no cache`);
        needRefresh = true;
        return;
      }
      const lastUpdateTime: Nullable<number> = await UpdateThemeRefreshTimeCache.getInstance().get();
      if (!lastUpdateTime || systemDateTime.getTime() - lastUpdateTime > DURATION) {
        TsLog.info(TAG, `data expired, lastUpdateTime = ${lastUpdateTime}`);
        needRefresh = true;
      }
      const ignoreThemeArray: Nullable<UpdateResourceInfo[]> = await IgnoreUpdateThemeInfoCache.getInstance().get();
      if (!ignoreThemeArray || ignoreThemeArray.length === 0) {
        TsLog.info(TAG, `no ignore theme, updateThemeArray size = ${updateResourceArray.length}`);
        return updateResourceArray;
      }
      TsLog.info(TAG, `ignoreThemeArray size = ${ignoreThemeArray.length}`);
      ignoreThemeArray.forEach((ignoreTheme) => {
        updateResourceArray = updateResourceArray?.filter(updateTheme => updateTheme.id !== ignoreTheme.id ||
          updateTheme.latestVersion !== ignoreTheme.latestVersion,
        );
      });
      TsLog.info(TAG, `updateThemeArray size = ${updateResourceArray.length}`);
      return updateResourceArray;
    } finally {
      if (needRefresh) {
        TsLog.info(TAG, `need refresh`);
        this.refreshUpdateThemeInfoCache();
      }
    }
  }

  async ignoreUpdateTheme(id: string, ignoreVersion: string): Promise<boolean> {
    let ignoreArray: Nullable<UpdateResourceInfo[]> = await IgnoreUpdateThemeInfoCache.getInstance().get();
    let ignoreInfo: UpdateResourceInfo = { id: id, latestVersion: ignoreVersion };
    TsLog.info(TAG, `ignoreUpdateTheme, id = ${id}, version = ${ignoreVersion}`);
    if (!ignoreArray) {
      return await IgnoreUpdateThemeInfoCache.getInstance().update([ignoreInfo]);
    }
    ignoreArray = ignoreArray.filter(ignoreTheme => ignoreTheme.id !== id);
    ignoreArray.push(ignoreInfo);
    return await IgnoreUpdateThemeInfoCache.getInstance().update(ignoreArray);
  }

  async resourceChangeNotification(ids: string[]): Promise<void> {
    TsLog.info(TAG, `resourceChangeNotification, resourceInfo size = ${ids.length}`);
    let updateResourceArray: Nullable<UpdateResourceInfo[]> = await UpdateThemeInfoCache.getInstance().get();
    if (!updateResourceArray) {
      TsLog.info(TAG, `resourceChangeNotification, no cache`);
      return;
    }
    const beforeSize: number = updateResourceArray.length;
    ids.forEach((id) => {
      updateResourceArray = updateResourceArray?.filter(updateResource => updateResource.id !== id);
    });
    const afterSize: number = updateResourceArray.length;
    if (afterSize !== beforeSize) {
      TsLog.info(TAG, `resourceChangeNotification, beforeSize = ${beforeSize}, afterSize = ${afterSize}`);
      await UpdateThemeInfoCache.getInstance().update(updateResourceArray);
    }
  }

  private async refreshUpdateThemeInfoCache(): Promise<void> {
    TsLog.info(TAG, `refreshUpdateThemeInfoCache start`);
    let result: Nullable<UpdatableResourceResult>;
    try {
      result = await TSRemoteCaller.getUpdatableResourceList();
    } catch (err) {
      TsLog.warning(TAG, `getUpdatableResourceList error, err = ${err}`);
      return;
    }
    if (!result) {
      TsLog.warning(TAG, `getUpdatableResourceList, not get data`);
      return;
    }
    if (result.errCode !== 0) {
      TsLog.warning(TAG,
        `getUpdatableResourceList error, code = ${result.errCode}, msg = ${result.returnValue[0]}`);
      return;
    }
    let retVals: string[] = result.returnValue;
    let updateResourceInfos: UpdateResourceInfo[] = [];
    retVals.forEach((retVal) => {
      let updateInfo: Nullable<UpdateResourceInfo> = JsonUtils.parse(retVal);
      if (updateInfo) {
        updateResourceInfos.push(updateInfo);
      }
    });
    await UpdateThemeRefreshTimeCache.getInstance().update(systemDateTime.getTime());
    await UpdateThemeInfoCache.getInstance().update(updateResourceInfos);
  }

  async clearUpdateThemeAllCache(): Promise<boolean> {
    TsLog.info(TAG, `clearUpdateThemeAllCache`);
    try {
      await UpdateThemeInfoCache.getInstance().clear();
      await UpdateThemeRefreshTimeCache.getInstance().clear();
      await IgnoreUpdateThemeInfoCache.getInstance().clear();
    } catch (err) {
      TsLog.warning(TAG, `clearUpdateThemeAllCache error`);
      return false;
    }
    return true;
  }
}

export const updateThemeInfoService: Singleton<UpdateThemeInfoServiceImpl> =
  new Singleton<UpdateThemeInfoServiceImpl>(() => new UpdateThemeInfoServiceImpl());