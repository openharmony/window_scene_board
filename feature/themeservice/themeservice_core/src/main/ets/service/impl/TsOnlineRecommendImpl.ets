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
import { Constants, ThemeCode, ThemeRecommendInfo } from '@ohos/themeservice_inner_api';
import { ArrayUtils, FileUtil, NullableType, TsLog } from '@ohos/themeservicebase';
import { TsRecommendCache } from '../../cache/TsRecommendCache';
import { TSPathUtils } from '../../util/TSPathUtils';
import { PathValidateUtil } from '../../validate/PathValidateUtil';
import { TsOnlineRecommend } from '../api/TsOnlineRecommend';
import { themeInfoService } from './ThemeInfoServiceImpl';
import { ThemeCacheInfo } from '../../cache/ThemeInfoStoreCache';

const TAG: string = 'TsOnlineRecommendImpl';

class TsOnlineRecommendImpl implements TsOnlineRecommend {
  /**
   * 异步通知在线推荐更新
   * @param updateInfoList 更新信息列表，可能为空
   * @return 返回一个Promise，如果成功，返回SUCCESS，如果失败，返回UNKNOWN_ERROR或者ERROR_PARAMS
   */
  async notifyOnlineRecommendationUpdate(recommendInfoList: Nullable<ThemeRecommendInfo[]>): Promise<number> {
    // 如果更新信息列表为空，打印警告并返回错误参数代码
    if (!recommendInfoList || ArrayUtils.isNull(recommendInfoList)) {
      TsLog.warning(TAG, `notifyOnlineRecommendationUpdate error params`);
      return ThemeCode.ERROR_PARAMS;
    }
    let onlineRecommendPath: string = TSPathUtils.getTsOnlineRecommendPath();
    await FileUtil.rmdirAsync(onlineRecommendPath);
    await TsRecommendCache.getInstance().clear();

    let themeCacheInfoList: NullableType<ThemeCacheInfo[]> = await themeInfoService.get().getCacheThemeList();
    // 将更新信息列表转换为主题推荐信息列表
    let recommendInfos: ThemeRecommendInfo[] = [];
    for (const recommendInfo of recommendInfoList) {
      let value: Nullable<ThemeRecommendInfo> = await this.handleRecommendInfo(recommendInfo,
        onlineRecommendPath);
      let cacheInfo: Nullable<ThemeCacheInfo> = themeCacheInfoList?.find((item: ThemeCacheInfo) => {
        return item.id === value?.contentId;
      });
      if (value && cacheInfo === undefined) {
        recommendInfos.push(value);
      }
    }
    if (recommendInfoList.length > 0 && recommendInfos?.length !== recommendInfoList.length) {
      TsLog.warning(TAG, `Copy file fail, theme app recommend:${recommendInfoList.length},
       but TS copy file ${recommendInfos?.length}`);
      return ThemeCode.ERROR_COPY_FILE;
    }
    // 更新推荐缓存，并根据更新结果返回相应的状态码
    return TsRecommendCache.getInstance()
      .update(recommendInfos)
      .then(ret => ret ? ThemeCode.SUCCESS : ThemeCode.UNKNOWN_ERROR);
  }

  async updateOnlineRecommendWhenApplyTheme(id: string): Promise<number> {
    TsLog.warning(TAG, `updateOnlineRecommendWhenApplyTheme ${id}`);
    let themeRecommendInfoList: NullableType<ThemeRecommendInfo[]> = await this.getOnlineRecommendation();
    if (!themeRecommendInfoList) {
      return ThemeCode.UNKNOWN_ERROR;
    }
    let index: Nullable<number> = themeRecommendInfoList.findIndex((item: ThemeRecommendInfo) => {
      return item.contentId === id;
    });
    if (index !== undefined && index !== -1) {
      themeRecommendInfoList.splice(index, 1);
    }
    // 更新推荐缓存，并根据更新结果返回相应的状态码
    return TsRecommendCache.getInstance()
      .update(themeRecommendInfoList)
      .then(ret => ret ? ThemeCode.SUCCESS : ThemeCode.UNKNOWN_ERROR);
  }

  private async handleRecommendInfo(recommendInfo: ThemeRecommendInfo, recommendPath: string):
    Promise<Nullable<ThemeRecommendInfo>> {
    let recommendSrcPath: NullableType<string> = recommendInfo.filePath;
    if (!recommendSrcPath) {
      return;
    }
    const srcPathEnable: boolean = await PathValidateUtil.validatePath(recommendSrcPath);
    if (!srcPathEnable) {
      TsLog.warning(TAG, `Recommend src filepath validate fail`);
      return;
    }
    let fileName: string =
      `${recommendInfo.contentId}${Constants.FILE_SUFFIX}${FileUtil.getFileSuffix(recommendSrcPath)}`;
    recommendInfo.filePath = `${recommendPath}/${fileName}`
    const destPathEnable: boolean = await PathValidateUtil.validatePath(recommendInfo.filePath);
    if (!destPathEnable) {
      TsLog.warning(TAG, `Recommend dest filepath validate fail`);
      return;
    }
    if (TsLog.isDebug(TAG)) {
      TsLog.debug(TAG, `recommend Src filename:${FileUtil.getFileName(recommendSrcPath)}`);
      TsLog.debug(TAG, `recommend TS filename:${FileUtil.getFileName(recommendInfo.filePath)}`);
    }
    if (!FileUtil.copyFileSync(recommendSrcPath, recommendInfo.filePath)) {
      TsLog.warning(TAG,
        `copy ${FileUtil.getFileName(recommendSrcPath)} to ${FileUtil.getFileName(recommendInfo.filePath)} fail`);
      return;
    }
    return recommendInfo;
  }

  getOnlineRecommendation(): Promise<NullableType<ThemeRecommendInfo[]>> {
    return TsRecommendCache.getInstance().get();
  }
}

export const tsOnlineRecommend: () => TsOnlineRecommend = () => new TsOnlineRecommendImpl();
