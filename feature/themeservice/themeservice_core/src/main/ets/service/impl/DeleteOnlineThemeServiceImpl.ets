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
import { ORIGIN_PRESET, ThemeResource } from '@ohos/themeservice_inner_api';
import { ArrayUtils, NullableType, Singleton, TsLog } from '@ohos/themeservicebase';
import { ThemeCacheInfo } from '../../cache/ThemeInfoStoreCache';
import { ThemePackCache } from '../../cache/ThemePackCache';
import { DeleteOnlineThemeService } from '../api/DeleteOnlineThemeService';
import { themeInfoService } from './ThemeInfoServiceImpl';
import { updateThemeInfoService } from './UpdateThemeInfoServiceImpl';

const TAG: string = 'DeleteOnlineThemeServiceImpl';

export class DeleteOnlineThemeServiceImpl implements DeleteOnlineThemeService {
  public async deleteTheme(themeResources: ThemeResource[]): Promise<boolean> {
    TsLog.info(TAG, `delete theme enter`);
    if (ArrayUtils.isNull(themeResources)) {
      TsLog.info(TAG, `delete theme parasm empty`);
      return false;
    }
    await this.deleteUpdateTheme(themeResources);
    let themeCacheList: NullableType<ThemeCacheInfo[]> = themeInfoService.get().getCacheThemeList();
    if (!themeCacheList) {
      TsLog.warning(TAG, `themeCacheList is null`);
      return false;
    }
    let editorIdList: string[] = [];
    let themeIdList: string[] = [];
    try {
      for (const resource of themeResources) {
        if (resource.type !== 'theme') {
          continue;
        }
        let themeInfos: NullableType<ThemeCacheInfo[]> = themeCacheList.filter(theme =>
        resource.id === theme.id.toString() && theme.originType !== ORIGIN_PRESET);
        themeInfos?.forEach(theme => {
          editorIdList.push(theme.editorId);
          themeIdList.push(theme.id);
        });
      }
      // 删除画廊主题套系数据
      if (editorIdList.length > 0) {
        TsLog.debug(TAG, `delete theme list: ${editorIdList.toString()}`)
        await themeInfoService.get().removeTheme(editorIdList);
      }
      // 删除原始主题包缓存数据
      if (themeIdList.length > 0) {
        TsLog.debug(TAG, `delete origin themePack list: ${themeIdList.toString()}`);
        await ThemePackCache.getInstance().removeOriginThemePack(themeIdList);
      }
      return true;
    } catch (error) {
      TsLog.error(TAG, `deleteTheme catch exception.`, error);
      return false;
    }
  }

  private async deleteUpdateTheme(themeResources: ThemeResource[]): Promise<void> {
    let ids: string[] = [];
    themeResources.forEach((resource) => {
      if (resource.type === 'theme') {
        ids.push(resource.id);
      }
    });
    updateThemeInfoService.get().resourceChangeNotification(ids);
  }
}

export const deleteOnlineThemeService: Singleton<DeleteOnlineThemeService> =
  new Singleton<DeleteOnlineThemeService>(() => new DeleteOnlineThemeServiceImpl());
