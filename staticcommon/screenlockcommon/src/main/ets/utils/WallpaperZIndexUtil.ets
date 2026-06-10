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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ViewController, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';

const TAG = 'WallpaperZIndexUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 壁纸层级设置工具类
 */
export class WallpaperZIndexUtils {
  private static setWallpaperIndexTimer?: number;

  private constructor() {
  }

  /**
   * 设置壁纸层级
   *
   * @param zIndex 目标壁纸Z序层级
   * @param delay 延时控制，小于等于0时，不创建timeout线程
   */
  public static setWallpaperZIndex(zIndex: number, delay: number, reason: string = 'noConfig'): void {
    WallpaperZIndexUtils.cleanSetWallpaperTimer();
    let controller: ViewController | undefined = viewMgrPolicy.getViewController(ViewType.WALLPAPER);
    if (!controller) {
      log.showError(`wallpaper controller undefined`);
      return;
    }
    if (delay <= 0) {
      if (controller?.getZIndex() !== zIndex) {
        log.showWarn(`Set wallpaper zindex ${zIndex}, reason: ${reason}`);
      }
      controller?.setZIndex(zIndex);
    } else {
      WallpaperZIndexUtils.setWallpaperIndexTimer = setTimeout(() => {
        WallpaperZIndexUtils.cleanSetWallpaperTimer();
        controller?.setZIndex(zIndex);
        log.showInfo(`Set wallpaper zindex delay, index: ${zIndex}`);
      }, delay);
    }
  }

  private static cleanSetWallpaperTimer(): void {
    if (WallpaperZIndexUtils.setWallpaperIndexTimer) {
      log.showInfo(`cleanSetWallpaperTimer`);
      clearTimeout(WallpaperZIndexUtils.setWallpaperIndexTimer);
      WallpaperZIndexUtils.setWallpaperIndexTimer = undefined;
    }
  }
}