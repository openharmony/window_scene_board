/**
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

import { FileUtils, SingleBase, SingleContext } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import type ctx from '@ohos.app.ability.common';
import { DesktopDataLoader } from '../viewmodel/DesktopDataLoader';
import { AppItemInfo } from '../bean/AppItemInfo';

/**
 * Layout configuration base class,
 * which defines the interfaces that all configuration objects need to implement.
 */
export abstract class ILayoutConfig extends SingleBase {

  public static singleName: string = 'ILayoutConfig';

  private static readonly COMMON_FEATURE_NAME = 'featureCommon';

  /**
   * 建议app布局数据
   */
  public mSuggestAppInfo: SuggestApp[] = [];

  /**
   * Desktop data loader
   */
  protected mDesktopDataLoader?: DesktopDataLoader;

  protected constructor(ctx?: SingleContext) {
    super(ctx);
  }

  /**
   * Initialize the configuration,
   * each configuration must recreate this function.
   */
  abstract initConfig(): void;

  /**
   * The current configuration level,
   * each configuration must reset this function.
   */
  abstract getConfigLevel(): string;

  /**
   * The current configuration type,
   * each configuration must recreate this function.
   */
  abstract getConfigType(): number;

  /**
   * The current configuration name,
   * each configuration must recreate this function.
   */
  abstract getConfigName(): string;

  /**
   * The JSON string corresponding to the current configuration.
   */
  public abstract getPersistConfigJson(): string;

  public updateSuggestAppInfo(suggestInfo: SuggestApp[]): void {
    this.mSuggestAppInfo = suggestInfo;
  }

  public getSuggestAppInfo(): SuggestApp[] {
    return this.mSuggestAppInfo;
  }

  /**
   * load configuration.
   */
  protected loadPersistConfig(): Object {
    let defaultConfig = this.getPersistConfigJson();
    return JSON.parse(defaultConfig);
  }

  /**
   * load configuration from file.
   */
  loadPersistConfigFromFile(): string {
    const configFromFile = FileUtils.readStringFromFile(this.getConfigFileAbsPath());
    return configFromFile;
  }

  /**
   * Check if the current property already exists.
   */
  isConfigExist(): boolean {
    return FileUtils.isExist(this.getConfigFileAbsPath());
  }

  /**
   * Force reload of configuration values.
   */
  forceReloadConfig(): void {
    this.initConfig();
  }

  /**
   * Persistent configuration values.
   */
  persistConfig(): void {
    FileUtils.writeStringToFile(this.getPersistConfigJson(), this.getConfigFileAbsPath());
  }

  /**
   * delete configuration value.
   */
  deleteConfig(): void {
    FileUtils.deleteConfigFile(this.getConfigFileAbsPath());
  }

  /**
   * Get the current configuration name.
   */
  getFeatureName(): string {
    return ILayoutConfig.COMMON_FEATURE_NAME;
  }

  /**
   * Get the absolute path of the current configuration file.
   */
  getConfigFileAbsPath(): string {
    let filesDir = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)?.filesDir + '/';
    return filesDir + this.getConfigName() + AppStorage.get('device') + '.json';
  }
}

export interface SuggestApp {
  itemType: number;
  bundleName: string;
  abilityName: string;
  editable: boolean;
}