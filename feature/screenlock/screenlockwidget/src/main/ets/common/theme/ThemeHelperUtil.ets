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
import { GlobalStatusCache, } from '@ohos/screenlockcommon';

const TAG = 'ThemeHelperUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏配置文件接口
 */
export interface LockManifest {
  /**
   * 壁纸类型
   */
  type: string;

  /**
   * 静态壁纸路径
   */
  image: Image;

  /**
   * 锁屏时钟是否显示
   */
  clockVisible: boolean;

  /**
   * 锁屏工具是否显示
   */
  quickToolsVisible: boolean;

  /**
   * 锁屏服务卡片是否显示
   */
  formVisible: boolean;

  /**
   * 锁屏是否透传触摸事件
   */
  wallpaperTouchable: boolean;

  /**
   * 互动壁纸下，锁屏是否主动发起解锁
   */
  wallpaperTouchableStrategy: number;
}

/**
 * 静态壁纸路径
 */
export interface Image {
  src: string;
}
/**
 * 主题ID,NAME
 */
export interface ThemeList {
  id: string;
  name: string;
  origin: string;
}

const LONG_TAKE_THEME = 'longTake';
const DEFAULT_IMAGE_SCR: Image = {
  src: 'unlock_wallpaper_0.jpg',
};

/**
 * 锁屏默认配置文件
 */
export const defaultManifestParam: LockManifest = {
  type: LONG_TAKE_THEME,
  image: DEFAULT_IMAGE_SCR,
  clockVisible: true,
  quickToolsVisible: true,
  formVisible: true,
  wallpaperTouchable: false,
  wallpaperTouchableStrategy: -1
};



export default class ThemeHelperUtil {
  /**
   * 标记文件。存在该文件，表示当前a为使用中的主题，a、b目录同一时刻只能有一个存在flag文件。
   */
  public static readonly FLAG_PATH_A: string = '/data/themes/a/app/flag';
  /**
   * manifest沙箱文件路径a
   */
  public static readonly MANIFEST_PATH_A: string = '/data/themes/a/system/lock/manifest.json';
  /**
   * sub_screen manifest沙箱文件路径a
   */
  public static readonly SUB_MANIFEST_PATH_A: string = '/data/themes/a/system/sub_screen/lock/manifest.json';
  /**
   * 标记文件。存在该文件，表示当前b为使用中的主题，a、b目录同一时刻只能有一个存在flag文件。
   */
  public static readonly FLAG_PATH_B: string = '/data/themes/b/app/flag';
  /**
   * manifest沙箱文件路径b
   */
  public static readonly MANIFEST_PATH_B: string = '/data/themes/b/system/lock/manifest.json';
  /**
   * sub_screen manifest沙箱文件路径B
   */
  public static readonly SUB_MANIFEST_PATH_B: string = '/data/themes/b/system/sub_screen/lock/manifest.json';
  private static isMirrorToEnd: boolean = true;

  public static isMirrorsToEnd(): boolean {
    return ThemeHelperUtil.isMirrorToEnd;
  }

  // 获取当前主题的id和name
  public static getCurrentThemeInfo(activeThemePath: string | null): void {
    if (activeThemePath === null) {
      return;
    }
    const themeDesc: string = `${activeThemePath}/description.json`;
    log.showDebug(`getCurrentThemeInfo themeDesc ${themeDesc}`);
    try {
      if (!fs.accessSync(themeDesc)) {
        log.showWarn(TAG, `get isPandoraTheme themeDesc ${themeDesc} failed: current theme has no description.`);
        return;
      }
      let themeInfo: ThemeList = JSON.parse(fs.readTextSync(themeDesc));
      let themeId = themeInfo.id;
      let themeName = themeInfo.id;
      GlobalStatusCache.getInstance().setStatus('editThemeId', themeId);
      GlobalStatusCache.getInstance().setStatus('editThemeName', themeName);
      log.showInfo(`getCurrentThemeInfo themeDesc ${themeDesc} themeId ${themeId} themeName ${themeName} themeOrigin ${themeInfo.origin}`);
    } catch (err) {
      log.showError(`get isPandoraTheme themeDesc ${themeDesc} failed: ${err}`);
    }
  }

  public static getLockManifest(isOuterScreen: boolean = false): LockManifest {
    try {
      let manifestPath: string;
      if (isOuterScreen) {
        manifestPath = fs.accessSync(ThemeHelperUtil.FLAG_PATH_A) ? ThemeHelperUtil.SUB_MANIFEST_PATH_A :
        ThemeHelperUtil.SUB_MANIFEST_PATH_B;
      } else {
        manifestPath = fs.accessSync(ThemeHelperUtil.FLAG_PATH_A) ? ThemeHelperUtil.MANIFEST_PATH_A :
        ThemeHelperUtil.MANIFEST_PATH_B;
      }
      ThemeHelperUtil.getCurrentThemeInfo(manifestPath.slice(0, 21));
      if (!fs.accessSync(manifestPath)) {
        log.showError(`lock manifest file path not exist=${manifestPath}`);
        return defaultManifestParam;
      }
      const manifestString: string = fs.readTextSync(manifestPath);
      if (!manifestString) {
        log.showError('lock manifest file is empty');
        return defaultManifestParam;
      }
      let manifestParam: LockManifest = JSON.parse(manifestString);
      if (!manifestParam.type || !manifestParam.image) {
        log.showError('manifest type or image is empty');
      }
      ThemeHelperUtil.isMirrorToEnd = manifestParam.type === LONG_TAKE_THEME;
      return {
        type: manifestParam.type,
        image: manifestParam.image,
        clockVisible: manifestParam?.clockVisible ?? defaultManifestParam.clockVisible,
        quickToolsVisible: manifestParam?.quickToolsVisible ?? defaultManifestParam.quickToolsVisible,
        formVisible: manifestParam?.formVisible ?? defaultManifestParam.formVisible,
        wallpaperTouchable: manifestParam?.wallpaperTouchable ?? defaultManifestParam.wallpaperTouchable,
        wallpaperTouchableStrategy: manifestParam?.wallpaperTouchableStrategy ??
          defaultManifestParam.wallpaperTouchableStrategy
      };
    } catch (e) {
      log.showError('ThemeHelperUtil exception err');
    }
    return defaultManifestParam;
  }

  public static isStaticTheme(isOuter: boolean = false): boolean {
    if(isOuter) {
      return AppStorage.get<boolean>('outerEngineThemeStatic') ? true : false;
    }
    const isStaticTheme = AppStorage.get<boolean>('engineThemeStatic');
    return isStaticTheme ? true : false;
  }
}
