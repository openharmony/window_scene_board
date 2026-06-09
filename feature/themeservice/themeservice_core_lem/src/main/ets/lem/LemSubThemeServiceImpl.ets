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

import List from '@ohos.util.List';
import {
  ActivateEventData,
  Constants,
  EventId,
  ThemeOptions,
  TServiceApi
} from '@ohos/themeservice_inner_api';
import { EventEmitter, FileUtil, NullableType, ObjectUtils, StringUtils, TsLog } from '@ohos/themeservicebase';
import { LemSubScreenInfo } from './LemSubScreenInfo';
import { LemSubThemeService } from './LemSubThemeService';
import { LemTsSubScreenCache } from './LemTsSubScreenCache';

const TAG: string = 'LemSubThemeDataService';

/**
 * 主题包description.json名称
 */
const DESCRIPTION: string = 'description.json';

/**
 * 非法的index
 */
const INVALID_INDEX: number = -1;

/**
 * 画廊最少需要1个主题
 */
const LEAST_LENGTH: number = 1;

/**
 * @description 主题数据业务
 */
export class LemSubThemeServiceImpl implements LemSubThemeService {
  private serviceHasInit: boolean = false;
  private userSubScreenThemeList: List<LemSubScreenInfo> = new List<LemSubScreenInfo>();

  /**
   * 应用外屏主题
   * @param subScreenTheme 外屏主题信息
   * @returns 是否应用成功
   */
  async onSubThemeActivated(subScreenTheme: LemSubScreenInfo): Promise<boolean> {
    if (ObjectUtils.isNull(subScreenTheme)) {
      return false;
    }
    TsLog.info(TAG, `onSubThemeActivated: ${subScreenTheme.themeId}`);
    let shouldAdd: boolean = true;
    let currentSubScreenTheme: LemSubScreenInfo = subScreenTheme;
    this.userSubScreenThemeList.forEach((theme: LemSubScreenInfo) => {
      if (theme.themeId === currentSubScreenTheme.themeId) {
        theme.battery = currentSubScreenTheme.battery;
        theme.vibration = currentSubScreenTheme.vibration;
        theme.sound = currentSubScreenTheme.sound;
        shouldAdd = false;
        currentSubScreenTheme = theme;
      }
    })
    if (shouldAdd) {
      currentSubScreenTheme.order = this.userSubScreenThemeList.length;
      this.userSubScreenThemeList.add(currentSubScreenTheme);
    }
    this.subScreenUpdate();
    return await this.activate(currentSubScreenTheme);
  }

  /**
   * 外屏画廊中主题新增
   * @param subScreenTheme 新增的外屏主题信息
   * @returns 当前的外屏主题列表
   */
  onSubThemeAdded(subScreenTheme: LemSubScreenInfo): LemSubScreenInfo[] {
    if (ObjectUtils.isNull(subScreenTheme)) {
      return this.userSubScreenThemeList.convertToArray();
    }
    TsLog.info(TAG, `onSubThemeAdded: ${subScreenTheme.themeId}`);
    for (let i: number = 0; i < this.userSubScreenThemeList.length; i++) {
      if (this.userSubScreenThemeList[i].themeId === subScreenTheme.themeId) {
        return this.userSubScreenThemeList.convertToArray();
      }
    }
    subScreenTheme.order = this.userSubScreenThemeList.length;
    this.userSubScreenThemeList.add(subScreenTheme);
    this.subScreenUpdate();
    return this.userSubScreenThemeList.convertToArray();
  }

  /**
   * 外屏画廊中主题被删除
   * @param themeId 删除的主题id
   * @returns 当前的外屏主题列表
   */
  onSubThemeDeleted(themeId: string): LemSubScreenInfo[] {
    if (StringUtils.isEmpty(themeId)) {
      TsLog.error(TAG, 'onSubThemeDeleted error themeId is empty');
      return this.userSubScreenThemeList.convertToArray();
    }
    TsLog.info(TAG, `onSubThemeDeleted: ${themeId}`);
    if (this.userSubScreenThemeList.length <= LEAST_LENGTH) {
      TsLog.warning(TAG, `The list requires at least one theme`);
      return this.userSubScreenThemeList.convertToArray();
    }
    let order: number = 0;
    this.userSubScreenThemeList.forEach(async (theme: LemSubScreenInfo) => {
      if (theme.themeId === themeId) {
        this.userSubScreenThemeList.remove(theme);
      } else {
        theme.order = order;
        order++;
      }
    })
    this.subScreenUpdate();
    return this.userSubScreenThemeList.convertToArray();
  }

  /**
   * 获取用户的所有主题列表
   * @returns 应用过的所有主题列表
   */
  async getSubThemeUsed(): Promise<LemSubScreenInfo[]> {
    this.init();
    return this.userSubScreenThemeList.convertToArray();
  }

  /**
   * 外屏主题画廊初始化
   * @returns void
   */
  async init(): Promise<void> {
    if (this.serviceHasInit) {
      return;
    }
    let cache: LemTsSubScreenCache = LemTsSubScreenCache.getInstance();
    let cachedSubThemeInfoList: NullableType<List<LemSubScreenInfo>> = await cache?.get();
    cachedSubThemeInfoList?.forEach((item: LemSubScreenInfo) => {
      this.userSubScreenThemeList.add(item);
    });
    this.serviceHasInit = true;
    this.userSubScreenThemeList.sort((themeFirst: LemSubScreenInfo, themeSecond: LemSubScreenInfo) => {
      return themeFirst.order - themeSecond.order;
    })
    await this.subScreenUpdate();
    EventEmitter.on(EventId.EVENT_ACTIVATE_THEME, (data: ActivateEventData) => this.onThemeActivated(data));
  }

  private onThemeActivated(data: ActivateEventData): void {
    if (ObjectUtils.isNull(data) || !data.fullActivate) {
      TsLog.info(TAG, `data is null or not full activate.`);
      return;
    }
    TsLog.info(TAG, `onThemeActivated ${data.id}`);
    if (!data.path || !FileUtil.isFileExists(data.path)) {
      TsLog.error(TAG, 'data.path not exist.');
      return;
    }
    let subThemeSrc: string = `${data.path}${'/'}${Constants.SUB_SCREEN_PREFIX}`;
    if (!FileUtil.isFileExists(subThemeSrc)) {
      TsLog.error(TAG, `subThemeSrc not exist.`);
      return;
    }
    let content: string = FileUtil.getStringByFile(subThemeSrc + Constants.FILE_SEPARATOR + DESCRIPTION);
    if (StringUtils.isEmpty(content)) {
      TsLog.error(TAG, 'Error, no default sub screen theme.');
      return;
    }
    try {
      let json: object = JSON.parse(content);
      let themeId: string = json[Constants.ID_PREFIX];
      const length: number = this.userSubScreenThemeList.length;
      for (let i: number = 0; i < length; i++) {
        if (this.userSubScreenThemeList[i].themeId === themeId) {
          TsLog.info(TAG, 'themeId is exist.');
          return;
        }
      }
      let subTheme: LemSubScreenInfo = new LemSubScreenInfo(themeId, subThemeSrc);
      subTheme.order = this.userSubScreenThemeList.length;
      this.userSubScreenThemeList.add(subTheme);
      this.subScreenUpdate();
    } catch (error) {
      TsLog.error(TAG, `onThemeActivated error: ${error?.message}`);
    }
  }

  private async activate(subTheme: LemSubScreenInfo): Promise<boolean> {
    if (ObjectUtils.isNull(subTheme)) {
      return false;
    }
    let index: number = subTheme.path.indexOf('/sub_screen');
    if (index === INVALID_INDEX) {
      TsLog.error(TAG, 'activate path is error.');
      return false;
    }
    let option: ThemeOptions = new ThemeOptions().enableSubScreen();
    return TServiceApi.themeActivate().activateTheme(subTheme.path.substring(0, index), option, false);
  }

  private async subScreenUpdate() {
    LemTsSubScreenCache.getInstance().update(this.userSubScreenThemeList);
  }
}

export const lemSubThemeService: LemSubThemeService = new LemSubThemeServiceImpl();