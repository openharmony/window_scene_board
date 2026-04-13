/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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
import { launcherStatusUtil } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ILayoutConfig } from './ILayoutConfig';
import { CommonConstants } from '../constants/CommonConstants';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { AppItemInfo } from '../bean/AppItemInfo';

const TAG = 'PageDesktopAppModeConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Desktop Workspace App Configuration
 */
export class PageDesktopAppModeConfig extends ILayoutConfig {
  private static mInstance: PageDesktopAppModeConfig;
  /**
   * Workspace Feature Layout Configuration Index
   */
  static DESKTOP_APPLICATION_INFO = 'DesktopApplicationInfo';

  private static readonly DEFAULT_LAYOUT_INFO: GridLayoutItemInfo[] = [];

  private mAppListInfo: GridLayoutItemInfo[] = PageDesktopAppModeConfig.DEFAULT_LAYOUT_INFO;

  private mOuterAppListInfo: GridLayoutItemInfo[] = PageDesktopAppModeConfig.DEFAULT_LAYOUT_INFO;

  protected constructor() {
    super();
  }

  /**
   * Get an instance of the workspace function layout configuration
   */
  static getInstance(): PageDesktopAppModeConfig {
    if (!PageDesktopAppModeConfig.mInstance) {
      PageDesktopAppModeConfig.mInstance = new PageDesktopAppModeConfig();
      PageDesktopAppModeConfig.mInstance.initConfig();
    }
    return PageDesktopAppModeConfig.mInstance;
  }

  initConfig(): void {
    this.loadRdbPersistConfig();
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_COMMON;
  }

  getConfigType(): number {
    return CommonConstants.LAYOUT_CONFIG_TYPE_MODE;
  }

  getConfigName(): string {
    return PageDesktopAppModeConfig.DESKTOP_APPLICATION_INFO;
  }

  public getPersistConfigJson(isOuter?: boolean): string {
    let showOuter = isOuter === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter;
    if (!showOuter) {
      return JSON.stringify(this.mAppListInfo);
    } else {
      return JSON.stringify(this.mOuterAppListInfo);
    }
  }

  /**
   * update appList in desktop
   *
   * @params appListInfo
   */
  updateAppListInfo(appListInfo: GridLayoutItemInfo[] | AppItemInfo[], isOuter?: boolean): void {
    let showOuter = isOuter === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter;
    if (!showOuter) {
      this.mAppListInfo = appListInfo as GridLayoutItemInfo[];
    } else {
      this.mOuterAppListInfo = appListInfo as GridLayoutItemInfo[];
    }
  }

  /**
   * Get workspace shortcuts
   *
   * @return Workspace shortcuts
   */
  getAppListInfo(isOuter?: boolean): GridLayoutItemInfo[] {
    let showOuter = isOuter === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter;
    if (!showOuter) {
      return this.mAppListInfo;
    } else {
      return this.mOuterAppListInfo;
    }
  }


    /**
   * load configuration
   */
  private loadRdbPersistConfig(): void {
    let defaultConfig = super.loadPersistConfig();
    try {
      globalThis.RdbStoreManagerInstance.queryDesktopApplication(false)
        .then((config: GridLayoutItemInfo[]) => {
          log.showDebug('loadPersistConfig configFromRdb success.');
          this.mAppListInfo = config;
        }).catch((err: Error) => {
        log.showError(`loadPersistConfig configFromRdb err: ${err.toString()}`);
        this.mAppListInfo = defaultConfig as GridLayoutItemInfo[];
      });
    } catch (err) {
      log.showError(`queryDesktopAppApplication err with code %{public}d message %{public}s`, err.code, err.message);
    }
  }
}