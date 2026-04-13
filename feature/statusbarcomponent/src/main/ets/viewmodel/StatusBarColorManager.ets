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

import { ViewManagerPolicy, ViewType, WallpaperManager, WallpaperType } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import effectKit from '@ohos.effectKit';
import image from '@ohos.multimedia.image';
import { DesktopModeManagerAdapter, SceneSessionAdapter, ScreenSessionAdapter } from '@ohos/systemuicommon';
import { scbStatusBarStatusManager } from '@ohos/systemuicommon/Index';
import { StatusBarType } from '@ohos/systemuicommon/Index';
import { StatusBarTint } from '../common/StatusBarTint';
import display from '@ohos.display';
import { EXTREMELY_LIGHT_COLOR_PICTURE } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusbarConstants';
import { Singleton } from '@ohos/systemuicommon/newTsIndex';
import { StatusBarColorData } from './StatusBarColorData';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { DesktopModeEnum } from '@ohos/launchercommon';
import { DeviceInfoVm, ResourceVm } from '@ohos/systemuicommon/newIndex';
import { SCBScreenProperty } from '@ohos/windowscene';

// instrument ignore file

const TAG = 'StatusBarColorManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class StatusBarColorManager {
  @Singleton.decorate()
  public static get instance(): StatusBarColorManager { return new StatusBarColorManager(); }

  /**
   * 缓存状态栏取色结果，<statusBarType, <width, color>>
   */
  private statusBarContentColorCacheMap: Map<number, Map<number, string>> = new Map();

  private statusBarUpdateColorFuncMap: Map<number, Function> = new Map([
    [StatusBarType.TYPE_MAIN_PHONE_LAUNCHER, (): Promise<void> => this.updateLauncherStatusBarColor()],
    [StatusBarType.TYPE_MAIN_PHONE_KEYGUARD, (): Promise<void> => this.updateKeyGuardStatusBarColor()]]);

  private clearBarContentColorCacheMap(statusBarType: number): void {
    if (!this.statusBarContentColorCacheMap.has(statusBarType)) {
      return;
    }
    let widthColorMap: Map<number, string> = this.statusBarContentColorCacheMap.get(statusBarType)!;
    widthColorMap.clear();
    this.statusBarContentColorCacheMap.delete(statusBarType);
  }

  private hasContentColorCache(statusBarType: number, width: number): boolean {
    if (!this.statusBarContentColorCacheMap.has(statusBarType)) {
      return false;
    }
    const widthColorMap: Map<number, string> = this.statusBarContentColorCacheMap.get(statusBarType)!;
    if (!widthColorMap.has(width)) {
      return false;
    }

    return true;
  }

  private getBarContentColorCache(statusBarType: number, width: number): string | null {
    if (!this.hasContentColorCache(statusBarType, width)) {
      log.showInfo(`status bar(type ${statusBarType}, width ${width}) not cache content color.`);
      return null;
    }
    const widthColorMap: Map<number, string> = this.statusBarContentColorCacheMap.get(statusBarType)!;
    const contentColor: string = widthColorMap.get(width)!;
    log.showInfo(`get cache status bar(type ${statusBarType}, width ${width}) content color(${contentColor})`);
    return contentColor;
  }

  private setBarContentColorCache(statusBarType: number, width: number, contentColor: string): void {
    log.showInfo(`cache status bar(type ${statusBarType}, width ${width}) content color(${contentColor})`);
    let widthColorMap: Map<number, string> = new Map();
    if (this.statusBarContentColorCacheMap.has(statusBarType)) {
      widthColorMap = this.statusBarContentColorCacheMap.get(statusBarType)!;
    }

    widthColorMap.set(width, contentColor);
    this.statusBarContentColorCacheMap.set(statusBarType, widthColorMap);
  }

  public init(persistentId: number): void {
    log.showInfo(`Init for ${persistentId}`);
    this.updateLauncherAndScreenLockColor();
    this.subscribeWallpaperChangeEvent();
    this.subscribeEmergencyModeChangeEvent();
    this.subscribeScreenPropertyChangeEvent(persistentId);
  }

  private setContentColor(statusBarType: number, contentColor: string): void {
    scbStatusBarStatusManager.setContentColor(statusBarType, contentColor);
    StatusBarColorData.instance().setContentColor(statusBarType, contentColor);
  }

  private updateLauncherAndScreenLockColor(): void {
    const commands = [StatusBarType.TYPE_MAIN_PHONE_LAUNCHER, StatusBarType.TYPE_MAIN_PHONE_KEYGUARD];
    this.updateStatusBarsContentColorAndLauncherColor(commands);
  }

  /**
   * 获取状态栏区域亮度等级
   */
  private async getStatusBarAreaImageLightDegree(pixelMap: image.PixelMap | null, displayData: display.Display,
    tag: string) : Promise<ESObject | null> {
    if (!pixelMap) {
      log.showError('image is null.');
      return null;
    }

    try {
      const imageInfo: image.ImageInfo = await pixelMap.getImageInfo();
      const statusBarHeight = ArkUIAdapter.vp2px(ResourceVm.instance.getNumber($r('app.float.status_bar_phone_height')))
      let cropRegionHeight: number = Math.min(imageInfo.size.height, statusBarHeight);
      let cropRegionWidth: number = Math.min(imageInfo.size.width, displayData.width);
      if ((displayData.width > imageInfo.size.width || statusBarHeight > imageInfo.size.height) &&
        displayData?.height > 0) {
        cropRegionHeight = imageInfo.size.height * (statusBarHeight / displayData?.height);
        cropRegionWidth = imageInfo.size.width;
      }
      log.showInfo(`getStatusBarAreaImageLightDegree for ${tag}, imageInfo(${imageInfo.size.width}, ${imageInfo.size.height}), ` +
        `region(width ${cropRegionWidth}, height ${cropRegionHeight})`);
      const pickRegion = [0, 0, cropRegionWidth / imageInfo.size.width, cropRegionHeight / imageInfo.size.height];
      const colorPicker: effectKit.ColorPicker = await effectKit.createColorPicker(pixelMap, pickRegion);
      /*const degree: effectKit.PictureLightColorDegree = colorPicker.discriminatePitureLightDegree();
      log.showInfo(`getStatusBarAreaImageLightDegree for ${tag} result(${degree}).`);
      MemoryUtils.removeNapiWrap(colorPicker, false);
      return degree;*/
      return {};
    } catch (e) {
      log.error(`getStatusBarAreaImageLightDegree for ${tag}`);
      return null;
    }
  }

  private async updateLauncherStatusBarColor(): Promise<void> {
    try {
      const displayData: display.Display = display.getDefaultDisplaySync();
      log.showInfo(`displayData(${displayData.width} ${displayData.height}) `);
      if (this.hasContentColorCache(StatusBarType.TYPE_MAIN_PHONE_LAUNCHER, displayData.width)) {
        const contentColor: string = this.getBarContentColorCache(StatusBarType.TYPE_MAIN_PHONE_LAUNCHER,
          displayData.width)!;
        this.setContentColor(StatusBarType.TYPE_MAIN_PHONE_LAUNCHER, contentColor);
        return;
      }

      const wallpaperType = WallpaperType.DESKTOP;
      const desktopWallpaper = await WallpaperManager.getInstance().getWallpaperCache(wallpaperType, TAG);
      const lightColorDegree: ESObject | null =
        await this.getStatusBarAreaImageLightDegree(desktopWallpaper, displayData, 'launcher');
      if (!lightColorDegree) {
        log.showError('get status bar area image light degree fail.');
        return;
      }

      const contentColor: string = this.getInverseColor(lightColorDegree);
      log.showInfo(`update launcher status bar content color(${contentColor}).`);
      this.setContentColor(StatusBarType.TYPE_MAIN_PHONE_LAUNCHER, contentColor);
      this.setBarContentColorCache(StatusBarType.TYPE_MAIN_PHONE_LAUNCHER, displayData.width, contentColor);
    } catch (e) {
      log.error(`update launcher status bar clolor failed reason code ${e?.code}, message${e?.message}`, e);
    }
  }

  /**
   * 设置状态栏颜色配置为指定的颜色
   * @param color 需要修改的状态栏颜色
   * @param scenarios 修改的场景（用于呈现当前设置状态栏为固定颜色的场景）
   */
  private setColorConfig(color: string, scenarios: string): void {
    log.showInfo(`setColorConfig to ${color}, scenarios: ${scenarios}`);
    StatusBarColorData.instance().forceColor = color;
    // 修改窗口存储的桌面和锁屏颜色
    SceneSessionAdapter.updateDesktopDefaultSystemBarContentColor(color);
    SceneSessionAdapter.updateLockDefaultSystemBarContentColor(color);
  }

  /**
   * 清理状态栏全局颜色配置，状态栏颜色，恢复成取色配置策略
   */
  private clearColorConfig(): void {
    StatusBarColorData.instance().forceColor = undefined;
    const commands = [StatusBarType.TYPE_MAIN_PHONE_LAUNCHER, StatusBarType.TYPE_MAIN_PHONE_KEYGUARD];
    this.updateStatusBarsContentColorAndLauncherColor(commands);
  }

  private getInverseColor(lightColorDegree: ESObject): string {
    return lightColorDegree === EXTREMELY_LIGHT_COLOR_PICTURE
      ? StatusBarTint.CONTENT_COLOR_OPAQUE_BLACK : StatusBarTint.CONTENT_COLOR_OPAQUE_WHITE;
  }

  private async updateKeyGuardStatusBarColor(): Promise<void> {
    log.showInfo('updateKeyGuardStatusBarColor begin.');
    const displayData: display.Display = display.getDefaultDisplaySync();
    log.showInfo(`displayData(${displayData.width} ${displayData.height}) `);
    if (this.hasContentColorCache(StatusBarType.TYPE_MAIN_PHONE_KEYGUARD, displayData.width)) {
      const contentColor: string = this.getBarContentColorCache(StatusBarType.TYPE_MAIN_PHONE_KEYGUARD,
        displayData.width)!;
      this.setContentColor(StatusBarType.TYPE_MAIN_PHONE_KEYGUARD, contentColor);
      return;
    }

    const wallpaperType = WallpaperType.SCEENLOCK;
    const screenLockWallpaper = await WallpaperManager.getInstance().getWallpaperCache(wallpaperType, TAG);
    const lightColorDegree: ESObject | null =
      await this.getStatusBarAreaImageLightDegree(screenLockWallpaper, displayData, 'screenLock');
    if (!lightColorDegree) {
      log.showError('get status bar area image light degree fail.');
      return;
    }

    const contentColor: string = this.getInverseColor(lightColorDegree);
    log.showInfo(`update key guard status bar content color(${contentColor}).`);
    this.setContentColor(StatusBarType.TYPE_MAIN_PHONE_KEYGUARD, contentColor);
    this.setBarContentColorCache(StatusBarType.TYPE_MAIN_PHONE_KEYGUARD, displayData.width, contentColor);
  }

  private async updateStatusBarsContentColor(statusBarTypes: number[]): Promise<void> {
    log.showInfo(`updateStatusBarsContentColor statusBarType(${JSON.stringify(statusBarTypes)}) begin`);
    const commands: Promise<void>[] = statusBarTypes.map((statusBarType: number) => {
      return this.statusBarUpdateColorFuncMap.get(statusBarType)?.() as Promise<void>;
    });

    await Promise.all(commands);
  }

  /**
   * 更新状态栏颜色，涉及到的场景有：壁纸或主题更新/旋转设备
   * @param statusBarTypes
   */
  private updateStatusBarsContentColorAndLauncherColor(statusBarTypes: number []) {
    this.updateStatusBarsContentColor(statusBarTypes).then(() => {
      let launcherColor = StatusBarColorData.instance().getContentColor(StatusBarType.TYPE_MAIN_PHONE_LAUNCHER);
      let lockColor = StatusBarColorData.instance().getContentColor(StatusBarType.TYPE_MAIN_PHONE_KEYGUARD);
      log.showInfo(`update statusbar color,launcher color: ${launcherColor}, lock color: ${lockColor}`);

      SceneSessionAdapter.updateDesktopDefaultSystemBarContentColor(launcherColor);
      if (scbStatusBarStatusManager.getIsSetImmersiveColor()) {
        log.showInfo('set immersive color, do not set lock screen color');
        return;
      }
      SceneSessionAdapter.updateLockDefaultSystemBarContentColor(lockColor);
    });
  }

  private subscribeWallpaperChangeEvent(): void {
    WallpaperManager.getInstance().addWallpaperChangeListener({
      registeredTag: TAG,
      listenerType: WallpaperType.ALL,
      onWallPaperChange: (event) => {
        log.showInfo(`On wallpaper change, themeType:${event.themeType}`);
        const statusBarTypes = [StatusBarType.TYPE_MAIN_PHONE_LAUNCHER, StatusBarType.TYPE_MAIN_PHONE_KEYGUARD];

        statusBarTypes.forEach((statusBarType: number) => {
          this.clearBarContentColorCacheMap(statusBarType);
        });

        this.updateStatusBarsContentColorAndLauncherColor(statusBarTypes);
      },
    });
  }

  private subscribeEmergencyModeChangeEvent(): void {
    DesktopModeManagerAdapter.registerModeChangeCallback({
      registerTag: TAG,
      callback: (preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum) => {
        // 进入应急模式或者热安全模式  状态栏颜色设为白色
        if (targetDesktopMode === DesktopModeEnum.THERMAL_SAFE_MODE ||
          targetDesktopMode === DesktopModeEnum.EMERGENCY_MODE) {
          log.showInfo(`Into the THERMAL_SAFE_MODE or EMERGENCY_MODE`);
          this.setColorConfig(StatusBarTint.CONTENT_COLOR_OPAQUE_WHITE,
            targetDesktopMode === DesktopModeEnum.THERMAL_SAFE_MODE ? 'safe_mode' : 'emergency_mode');
        } else {
          // 退出时恢复
          log.showInfo(`Exit the THERMAL_SAFE_MODE or EMERGENCY_MODE`);
          this.clearColorConfig();
        }
      }
    }, `${TAG}_registerModeChangeCallback`);
  }

  private subscribeScreenPropertyChangeEvent(persistentId: number): void {
    ScreenSessionAdapter.registerScreenPropertyChangeCallbacks({
      callback: (screenProperty: SCBScreenProperty) => {
        log.showInfo(`screenProperty:` + screenProperty.getLogString());
        const oldArea = ViewManagerPolicy.getArea(ViewType.STATUS_BAR);
        if (oldArea.width === screenProperty.width) {
          return;
        }
        this.updateLauncherAndScreenLockColor();
      },
      screenId: undefined,
      isRotatable: true,
      persistentId
    }, `${TAG}_registerScreenPropertyChangeCallbacks`);
  }
}
