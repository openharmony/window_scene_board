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
import { settings } from '@kit.BasicServicesKit';
import { ActivateEventData, ThemeInfo, ThemePackInfo } from '@ohos/themeservice_inner_api';
import {
  ArrayUtils,
  ContextUtil,
  FileUtil,
  NullableType,
  ObjectUtils,
  Singleton,
  StringUtils,
  TsLog
} from '@ohos/themeservicebase';
import { ThemePackCache, ThemePackCacheData } from '../../cache/ThemePackCache';
import { TsPresetRecommend } from '../api/TsPresetRecommend';
import { themeInfoService } from './ThemeInfoServiceImpl';
import { getThemePackParser } from '../../preset/ThemePackParser';

const TAG: string = 'TsPresetRecommend';

// 预置推荐的随动心情主题名称
export const PRESET_RECOMMEND_THEMES: string[] = ['随动心情'];

// 多语言资源目录
const I18N_DIR: string = 'i18n';

// 文件后缀
const I18N_FILE_EXTENSION: string = '.json';

// 资源引用前缀
const I18N_KEY_PREFIX: string = '$t:';

export class TsPresetRecommendImpl implements TsPresetRecommend {
  private static readonly RECOMMEND_ENABLE: string = 'interact_theme_enable';

  private static readonly RECOMMEND_APPLIED: string = 'interact_theme_applied';

  private static readonly ENABLE: string = '1';

  private static readonly DISABLE: string = '0';

  /**
   * 开机初始化处理
   *
   * @returns
   */
  async onInit(): Promise<void> {
    TsLog.info(TAG, 'onInit');
    try {
      const themeList: NullableType<ThemePackCacheData[]> = await ThemePackCache.getInstance().get();
      let hasRecommend: boolean = false;
      if (themeList && !ArrayUtils.isNull(themeList)) {
        for (let themePackCacheData of themeList) {
          const themeTitle: string = await this.getTitleCn(themePackCacheData?.themePack);
          if (PRESET_RECOMMEND_THEMES.includes(themeTitle)) {
            TsLog.info(TAG, `has recommend`);
            hasRecommend = true;
            break;
          }
        }
      }
      this.setValue(TsPresetRecommendImpl.RECOMMEND_ENABLE,
        hasRecommend ? TsPresetRecommendImpl.ENABLE : TsPresetRecommendImpl.DISABLE);
    } catch (err) {
      TsLog.error(TAG, ` onInit get theme pack catch exception. code:${err.code}, message:${err.message}`)
    }

    try {
      const currentTheme: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      const title: string = await this.getTitleCn(currentTheme.originThemePack);
      if (ObjectUtils.isNull(currentTheme) || !PRESET_RECOMMEND_THEMES.includes(title)) {
        return;
      }
      settings.getValue(ContextUtil.getTsServiceContext(), TsPresetRecommendImpl.RECOMMEND_APPLIED)
        .then((value: string) => {
          if (!StringUtils.equals(TsPresetRecommendImpl.ENABLE, value)) {
            this.setValue(TsPresetRecommendImpl.RECOMMEND_APPLIED, TsPresetRecommendImpl.ENABLE);
          }
        })
        .catch(() => {
          this.setValue(TsPresetRecommendImpl.RECOMMEND_APPLIED, TsPresetRecommendImpl.ENABLE);
        });

    } catch (error) {
      TsLog.error(TAG, ` onInit getCurrentTheme catch exception. code:${error.code}, message:${error.message}`)
    }
  }

  /**
   * 主题应用处理
   *
   * @param data 应用主题数据
   */
  async onThemeActivated(data: ActivateEventData): Promise<void> {
    if (ObjectUtils.isNull(data)) {
      return;
    }
    if (!data.fullActivate || StringUtils.isEmpty(data?.path) || !data.path) {
      return;
    }
    const themePack: ThemePackInfo = await getThemePackParser().parse(data.path);
    const title = await this.getTitleCn(themePack);
    TsLog.info(TAG, `activate theme,${title}`);
    if (!PRESET_RECOMMEND_THEMES.includes(title)) {
      return;
    }
    settings.getValue(ContextUtil.getTsServiceContext(), TsPresetRecommendImpl.RECOMMEND_APPLIED)
      .then((value: string) => {
        if (!StringUtils.equals(TsPresetRecommendImpl.ENABLE, value)) {
          this.setValue(TsPresetRecommendImpl.RECOMMEND_APPLIED, TsPresetRecommendImpl.ENABLE);
        }
      })
      .catch(() => {
        this.setValue(TsPresetRecommendImpl.RECOMMEND_APPLIED, TsPresetRecommendImpl.ENABLE);
      });
  }

  private setValue(key: string, value: string): void {
    try {
      settings.setValue(ContextUtil.getTsServiceContext(), key, value)
        .then((ret: boolean) => {
          TsLog.info(TAG, `set ${key} ret ${ret},value:${value}`);
        })
        .catch(() => {
          TsLog.info(TAG, `set ${key} fail,value:${value}`);
        });
    } catch (error) {
      TsLog.info(TAG, `set ${key} error,value:${value}`);
    }
  }

  private async getTitleCn(themePack: NullableType<ThemePackInfo>): Promise<string> {
    if (ObjectUtils.isNull(themePack) || !themePack?.description || StringUtils.isEmpty(themePack?.description)) {
      return '';
    }
    let titleRef: string = '';
    try {
      titleRef = JSON.parse(themePack?.description)['title'];
    } catch (error) {
      TsLog.error(TAG, 'parse description error', error);
      return '';
    }
    const zhLanguage: string = 'zh';
    const filePath: string = `${themePack.srcPath}/${I18N_DIR}/${zhLanguage}${I18N_FILE_EXTENSION}`;
    if (!FileUtil.isFileExists(filePath)) {
      TsLog.info(TAG, `zh language  not exists.`);
      return '';
    }

    const content: string | undefined = await FileUtil.readFileContent(filePath);
    if (!content) {
      TsLog.warning(TAG, `the content of json is undefined.`);
      return '';
    }
    let descList: Map<string, string> = new Map();
    try {
      let json: object = JSON.parse(content);
      let jsonKeys: string[] = Object.keys(json);
      for (let key of jsonKeys) {
        descList.set(key, json[key]);
      }
    } catch (error) {
      TsLog.error(TAG, `parse content error`, error);
    }
    return descList.get(titleRef.substring(I18N_KEY_PREFIX.length)) ?? '';
  }
}

export const presetRecommendService: Singleton<TsPresetRecommend> =
  new Singleton<TsPresetRecommend>(() => new TsPresetRecommendImpl());