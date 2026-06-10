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
import { Logger } from '../../base/Logger';
import { RemoteCaller } from '../../base/RemoteCaller';
import { TsContext } from '../../event/TSTypes';
import { TSRemoteApi } from '../api/TSRemoteApi';
import { TConfigArg } from '../model/TConfigArg';
import { WallPaperInfo } from '../model/WallPaper';

const TAG: string = 'TSRemoteCaller';

export class TsRemoteCaller implements TSRemoteApi {
  private readonly remoteCaller: RemoteCaller;

  constructor(context: TsContext) {
    this.remoteCaller = new RemoteCaller(context, {
      bundleName: 'com.ohos.sceneboard',
      abilityName: 'ThemeServiceAbility',
    });
  }

  /**
   * 应用图标资源
   * @param iconResource 图标资源路径
   * @returns 应用结果
   */
  async applyIcons(iconResource: string): Promise<boolean> {
    try {
      return await this.remoteCaller.request(TSRemoteMethod.APPLY_ICONS, iconResource);
    } catch (err) {
      Logger.error(TAG, `applyIcons catch exception.`, err);
      return false;
    }
  }

  /**
   * 设置当前主题资源
   * @param tConfigArgs 需要写入的参数列表
   * @returns 设置结果
   */
  async setCurrentThemeCfg(tConfigArgs: TConfigArg[]): Promise<boolean> {
    try {
      return await this.remoteCaller.request(TSRemoteMethod.SET_CURRENT_THEME_CFG, tConfigArgs);
    } catch (err) {
      Logger.error(TAG, `setCurrentThemeCfg catch exception.`, err);
      return false;
    }
  }

  async applyWallpaper(wallPapers: WallPaperInfo[]): Promise<boolean> {
    try {
      return await this.remoteCaller.request(TSRemoteMethod.APPLY_WALLPAPER, wallPapers);
    } catch (err) {
      Logger.error(TAG, `applyWallpaper catch exception.`, err);
      return false;
    }
  }

  /**
   * 应用aod资源
   * @param aodThemeDir aod主题目录
   * @returns 应用结果
   */
  async applyAod(aodThemeDir: string): Promise<boolean> {
    try {
      return await this.remoteCaller.request(TSRemoteMethod.APPLY_AOD, aodThemeDir);
    } catch (err) {
      Logger.error(TAG, `applyAod catch exception.`, err);
      return false;
    }
  }
}

export function createTsRemoteCaller(context: TsContext): TSRemoteApi {
  return new TsRemoteCaller(context);
}

namespace TSRemoteMethod {
  /**
   * 设置当前主题配置
   */
  export const SET_CURRENT_THEME_CFG: string = `setCurrentThemeCfg`;

  /**
   * 应用字体
   */
  export const APPLY_ICONS: string = `applyIcons`;

  /**
   * 应用aod
   */
  export const APPLY_AOD: string = `applyAod`;

  /**
   * 应用壁纸
   */
  export const APPLY_WALLPAPER: string = `setWallPaper`;
}