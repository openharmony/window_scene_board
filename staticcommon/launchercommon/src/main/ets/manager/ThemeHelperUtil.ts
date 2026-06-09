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

const TAG = 'launchercommon-ThemeHelperUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 静态壁纸路径
 */
export interface Image {
  src: string;
}

/**
 * 桌面配置文件接口
 */
export interface HomeManifest {

  /**
   * 壁纸类型
   */
  type: string;

  /**
   * 静态壁纸路径
   */
  image: Image;

  /**
   * 锁屏是否透传触摸事件
   */
  wallpaperTouchable: boolean;
}

export default class ThemeHelperUtil {

  /**
   * 标记文件。存在该文件，表示当前a为使用中的主题，a、b目录同一时刻只能有一个存在flag文件。
   */
  private static readonly FLAG_PATH_A: string = '/data/themes/a/app/flag';

  /**
   * 标记文件。存在该文件，表示当前b为使用中的主题，a、b目录同一时刻只能有一个存在flag文件。
   */
  private static readonly FLAG_PATH_B: string = '/data/themes/b/app/flag';

  /**
   * manifest沙箱文件路径a
   */
  private static readonly MANIFEST_HOME_PATH_A: string = '/data/themes/a/system/home/manifest.json';

  /**
   * sub_screen manifest沙箱文件路径a
   */
  private static readonly SUB_MANIFEST_HOME_PATH_A: string = '/data/themes/a/system/sub_screen/home/manifest.json';

  /**
   * manifest沙箱文件路径b
   */
  private static readonly MANIFEST_HOME_PATH_B: string = '/data/themes/b/system/home/manifest.json';

  /**
   * sub_screen manifest沙箱文件路径B
   */
  private static readonly SUB_MANIFEST_HOME_PATH_B: string = '/data/themes/b/system/sub_screen/home/manifest.json';

  /**
   * 从主题包home目录中获取manifest.json配置文件内容
   *
   * @param isOuterScreen 是否是外屏
   * @returns HomeManifest manifest中数据
   */
  public static getHomeManifest(isOuterScreen: boolean = false): HomeManifest | undefined {
    try {
      let manifestPath: string;
      if (isOuterScreen) {
        manifestPath = fs.accessSync(ThemeHelperUtil.FLAG_PATH_A) ? ThemeHelperUtil.SUB_MANIFEST_HOME_PATH_A :
        ThemeHelperUtil.SUB_MANIFEST_HOME_PATH_B;
      } else {
        manifestPath = fs.accessSync(ThemeHelperUtil.FLAG_PATH_A) ? ThemeHelperUtil.MANIFEST_HOME_PATH_A :
        ThemeHelperUtil.MANIFEST_HOME_PATH_B;
      }
      if (!fs.accessSync(manifestPath)) {
        log.showError('home manifest file path not exist');
        return undefined;
      }
      const manifestString: string = fs.readTextSync(manifestPath);
      if (!manifestString) {
        log.showError('home manifest file is empty');
        return undefined;
      }
      log.showInfo(`manifestString=${manifestString}`);

      let manifestParam: HomeManifest = JSON.parse(manifestString);
      if (!manifestParam || !manifestParam.type || !manifestParam.image) {
        log.showError('manifest type or image is empty');
        return undefined;
      }
      return manifestParam;
    } catch (e) {
      log.showError('ThemeHelperUtil exception err');
    }
    return undefined;
  }
}