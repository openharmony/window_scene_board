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

import fs from '@ohos.file.fs';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ThemeConstant } from '../ThemeConstant';

const TAG: string = 'TsMashupHandler';

const LOG: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 新主题包规范 home对应的manifest.json
 */
interface HomeManifest {
  /**
   * 壁纸类型
   * image：静态壁纸
   * longTake：对应一镜到底的配置模式
   * script：动态壁纸
   */
  type: string;
}

/**
 * 新主题包规范 lock对应的manifest.json
 */
interface LockManifest {
  /**
   * 壁纸类型
   * image：静态壁纸
   * longTake：对应一镜到底的配置模式
   * script：动态壁纸
   */
  type: string;
}

/**
 * 承载大主题内部规范的主题内容配置描述文件
 */
interface ContentDescription {
  /**
   * 资源id
   */
  id: string;

  /**
   * 壁纸资源为MovingPhoto
   */
  movingPhoto: MovingPhoto;
}

/**
 * 壁纸资源：MovingPhoto
 */
interface MovingPhoto {
  /**
   * 是否应用MovingPhoto效果，true：启用
   */
  enable: boolean;

  /**
   * MovingPhoto资源路径（MP4文件）
   */
  src: string;
}

/**
 * Handler class to manager edited/mixed theme state
 *
 * @since 2024-02-29
 */
export class TsMashupHandler {
  private themePath: string = '';

  private isDynamicInvolved: boolean = false;

  private isOuterDynamicInvolved: boolean = false;

  /**
   * Creating a new handler instance with current theme path
   *
   * @param themePath Current active theme path
   */
  public constructor(themePath: string) {
    LOG.info(`create`);
    this.themePath = themePath;
  }

  /**
   * Update theme path as such path could be changed over the whole wallpaper lifecycle.
   *
   * @param themePath Current active theme path
   */
  public setActiveThemePath(themePath: string): void {
    LOG.info(`setActiveThemePath`);
    this.themePath = themePath;
  }

  /**
   * Get current outer screen active theme path.
   *
   * @returns Current active theme path
   */
  private getOuterScreenActiveThemePath(themePath: string): string {
    let path: string = themePath;
    if (path) {
      path += '/sub_screen';
    }
    LOG.info(`getOuterScreenActiveThemePath`);
    return path;
  }

  /**
   * 从 ThemeEditor 解析配置文件，以确定当前主题是否由用户编辑。在混搭的情况下，可由用户编辑和编辑的动态主题将变成静态主题。
   *
   * @returns True if this theme is edited by used, otherwise false.
   */
  public isThemeEdited(): boolean {
    let lockCfg: string = `${this.themePath}/unlock/base/wallpaperconfig.json`;
    let homeCfg: string = `${this.themePath}/home/base/wallpaperconfig.json`;

    try {
      LOG.info(`Check wallpaperconfig accessable`);
      if (fs.accessSync(lockCfg) || fs.accessSync(homeCfg)) {
        LOG.info(`This theme's wallpaper was edited before, dynamic engine is not applicable.`);
        return true;
      }
      LOG.info(`Load the theme as the original design.`);
      return false;
    } catch (err) {
      LOG.error('Error on accessing file system,' +
        `considering the theme is not edited by default. ${err.code} - ${err.message}`);
    }
    return false;
  }

  /**
   * 判断当前主题包是否符合新主题包规范
   *
   * @param isOuter: 是否为外屏，默认为false
   * @returns true：表示当前主题包符合新的主题包规范
   */
  public isNgTheme(isOuter: boolean = false): boolean {
  let themePath: string = this.themePath;
    if (isOuter === true) {
      themePath = this.getOuterScreenActiveThemePath(themePath);
    }
    let ngHomeManifest: string = `${themePath}/${ThemeConstant.MANIFEST_HOME}`;
    let ngLockManifest: string = `${themePath}/${ThemeConstant.MANIFEST_LOCK}`;
    // 如果两个文件都存在，函数返回true，表示当前主题包符合新的主题包规范
    LOG.info(`Check manifest accessable`);
    let isNgTheme: boolean = fs.accessSync(ngHomeManifest) && fs.accessSync(ngLockManifest);
    LOG.info(`isNgTheme = ${isNgTheme}`);
    return isNgTheme;
  }

  /**
   * 判断当前主题包是否使用静态壁纸
   *
   * @param isOuter: 是否为外屏，默认为false
   * @returns true：使用静态壁纸
   */
  public checkIsNgStatic(isOuter: boolean = false): boolean {
    let themePath: string = this.themePath;
    if (isOuter === true) {
      themePath = this.getOuterScreenActiveThemePath(themePath);
    }
    LOG.info('Both manifest.json shoule be exist here.');
    let ngHomeManifest: string = `${themePath}/${ThemeConstant.MANIFEST_HOME}`;
    let ngLockManifest: string = `${themePath}/${ThemeConstant.MANIFEST_LOCK}`;

    try {
      let homeManifestContent: HomeManifest = JSON.parse(fs.readTextSync(ngHomeManifest));
      let lockManifestContent: LockManifest = JSON.parse(fs.readTextSync(ngLockManifest));
      if (!homeManifestContent || !lockManifestContent) {
        return true;
      }
      if (homeManifestContent.type === undefined || lockManifestContent.type === undefined) {
        LOG.warn('No type was specified in either home or lock manifest.');
        return true;
      }
      if (homeManifestContent.type === 'script' || homeManifestContent.type === 'longTake' ||
        lockManifestContent.type === 'script' || lockManifestContent.type === 'longTake') {
        if (isOuter === true) {
          this.isOuterDynamicInvolved = true;
        } else {
          this.isDynamicInvolved = true;
        }
      } else {
        if (isOuter === true) {
          this.isOuterDynamicInvolved = false;
        } else {
          this.isDynamicInvolved = false;
        }
      }
      // type对应字段 image：静态壁纸 script：动态壁纸 longTake：对应一镜到底的配置模式
      if (lockManifestContent.type === 'image') {
        LOG.warn('Home or lock are specified using image type.');
        let lockDescription: string = `${themePath}/${ThemeConstant.DESCRIPTION_LOCK}`;
        let lockDescriptionContent: ContentDescription = JSON.parse(fs.readTextSync(lockDescription));
        if (lockDescriptionContent && lockDescriptionContent.movingPhoto &&
          lockDescriptionContent.movingPhoto.enable && lockDescriptionContent.movingPhoto.src) {
          // 静态壁纸资源为MovingPhoto类型，支持动态效果
          LOG.info('Lock support MovingPhoto');
          if (isOuter) {
            this.isOuterDynamicInvolved = true;
          } else {
            this.isDynamicInvolved = true;
          }
        }
        return true;
      }
    } catch (err) {
      LOG.error(`Defective JSON in home or lock's manifest.json file ${err.code}`);
      return true;
    }
    return false;
  }

  /*
   * 判断混搭场景是否有动态主题的存在
   *
   * @returns true: 有动态主题
   */
  public checkIsDynamicInvolved(): boolean {
    return this.isDynamicInvolved;
  }

  /*
 * 判断外屏混搭场景是否有动态主题的存在
 *
 * @returns true: 有动态主题
 */
  public checkIsOuterDynamicInvolved(): boolean {
    return this.isOuterDynamicInvolved;
  }
}
