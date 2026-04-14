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
import { ILayoutConfig, SuggestApp } from './ILayoutConfig';
import { CommonConstants } from '../constants/CommonConstants';
import { AppItemInfo } from '../bean/AppItemInfo';

const TAG = 'SmartDockSuggestAppConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面Dock建议app
 */
export class SmartDockSuggestAppConfig extends ILayoutConfig {
  /**
   * 建议app配置索引
   */
  public static SMART_DOCK_SUGGEST_APP_INFO: string = 'SmartDockSuggestAppInfo';

  private static sInstance: SmartDockSuggestAppConfig;

  protected constructor() {
    super();
  }

  /**
   * 获取建议app布局配置实例
   */
  public static getInstance(): SmartDockSuggestAppConfig {
    if (!SmartDockSuggestAppConfig.sInstance) {
      SmartDockSuggestAppConfig.sInstance = new SmartDockSuggestAppConfig();
      SmartDockSuggestAppConfig.sInstance.initConfig();
    }
    log.showInfo('Launcher SmartDockSuggestAppConfig getInstance');
    return SmartDockSuggestAppConfig.sInstance;
  }

  public initConfig(): void {
    let config = this.loadPersistConfig();
    this.mSuggestAppInfo = config as SuggestApp[];
  }

  public getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_COMMON;
  }

  public getConfigType(): number {
    return CommonConstants.LAYOUT_CONFIG_TYPE_FUNCTION;
  }

  public getConfigName(): string {
    return SmartDockSuggestAppConfig.SMART_DOCK_SUGGEST_APP_INFO;
  }

  public getPersistConfigJson(): string {
    return JSON.stringify(this.mSuggestAppInfo);
  }

  /**
   * 更新dock建议菜单布局数据
   *
   * @params suggestInfo 建议列表数据
   */
  public updateSuggestAppInfo(suggestInfo: SuggestApp[]): void {
    this.mSuggestAppInfo = suggestInfo;
    super.persistConfig();
  }

  /**
   * 获取建议app数据
   *
   * @return 建议app数据
   */
  public getSuggestAppInfo(): SuggestApp[] {
    return this.mSuggestAppInfo;
  }
}
