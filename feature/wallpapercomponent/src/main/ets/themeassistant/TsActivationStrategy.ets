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

import fs from '@ohos.file.fs';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { TsMashupHandler } from './handler/TsMashupHandler';
import { ThemeType } from './ThemeConstant';

const TAG: string = 'TsActivationStrategy';
const LOG: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class TsActivationStrategy {
  private mashupHandler: TsMashupHandler = new TsMashupHandler('');
  private activeThemePath: string = '';

  /**
   * 获取当前主题的类型
   *
   * @param isOuter: 是否为外屏，默认为false
   * @returns ThemeType: 当前主题类型
   */
  public getActivationType(isOuter: boolean = false): ThemeType {
    // 新主题包规范
    if (this.mashupHandler.isNgTheme(isOuter)) {
      let type: ThemeType = this.mashupHandler.checkIsNgStatic(isOuter) ? ThemeType.STATIC : ThemeType.DYNAMIC;
      LOG.info(`getActivationType , isNgTheme  type = ${type}`);
      return type;
    }
    // 兼容旧主题包规范
    const isStaticValid: boolean = this.isStaticResourceValid();
    if (this.mashupHandler.isThemeEdited()) {
      LOG.info(`getActivationType , isThemeEdited`);
      return this.staticValidityCheck(isStaticValid);
    }

    const themeDesc: string = `${this.activeThemePath}/description.json`;

    try {
      LOG.info(`Check description accessable`);
      if (!fs.accessSync(themeDesc)) {
        return this.staticValidityCheck(isStaticValid);
      }
    } catch (err) {
      LOG.error(`Error on checking theme desc JSON file, ${err.code} - ${err.message}`);
      return this.staticValidityCheck(isStaticValid);
    }

    return this.checkThemeType() ? ThemeType.DYNAMIC : this.staticValidityCheck(isStaticValid);
  }

  public updateActiveThemePath(themePath: string): void {
    this.activeThemePath = themePath;
    this.mashupHandler.setActiveThemePath(themePath);
  }

  private checkThemeType(): boolean {
    const themeDesc: string = `${this.activeThemePath}/description.json`;
    try {
      const themeDescContent: string = fs.readTextSync(themeDesc);
      let searchResult: boolean = themeDescContent.search('type') >= 0;
      LOG.info(`Search result ${searchResult} during searching for 'type' key.`);
      return searchResult;
    } catch (err) {
      LOG.error(`Error on parsing theme desc JSON file, ${err.code} - ${err.message}`);
    }

    return false;
  }

  /**
   * 判断老主题包中静态资源是否存在
   * @returns
   */
  private isStaticResourceValid(): boolean {
    let lockscreenImagePath: string = `${this.activeThemePath}/unlock/unlock_wallpaper_0.jpg`;
    let desktopImagePath: string = `${this.activeThemePath}/home/home_wallpaper_0.jpg`;
    LOG.info(`Check isStaticResourceValid`);
    let isStaticValid: boolean = fs.accessSync(lockscreenImagePath) && fs.accessSync(desktopImagePath);
    LOG.info(`isStaticResourceValid , isStaticValid = ${isStaticValid}`);
    return isStaticValid;
  }

  private staticValidityCheck(isStaticValid: boolean): ThemeType {
    let check: ThemeType = isStaticValid ? ThemeType.STATIC : ThemeType.DEFAULT;
    LOG.info(`staticValidityCheck , check = ${check}`);
    return check;
  }

  /*
   * 判断混搭场景是否有动态主题的存在
   *
   * @returns true: 有动态主题
   */
  public isDynamicInvolved(): boolean {
    return this.mashupHandler.checkIsDynamicInvolved();
  }

  /*
 * 判断混搭场景是否有动态主题的存在
 *
 * @returns true: 有动态主题
 */
  public isOuterDynamicInvolved(): boolean {
    return this.mashupHandler.checkIsOuterDynamicInvolved();
  }
}