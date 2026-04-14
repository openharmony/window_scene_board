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
import CommonConstants, { CcmOption, SlAreaType, SlPositionType } from '../constants/CommonConstants';
import { image } from '@kit.ImageKit';
// import { CommonUtils, LogDomain, LogHelper, MemoryUtils } from '@ohos/basicutils';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import effectKit from '@ohos.effectKit';
import { BackCacheUnit, SlArea } from './SlVisualData';
import { SLWallpaperType } from '../wallpaper/ScreenLockWallpaperState';
import { SlVisualArgsManager } from './SlVisualArgsManager';
import { SlWidgetAreaManager } from './SlWidgetAreaManager';
import { SlVisualSolidUtils } from './SlVisualUtils';
import { SlColorCacheManager } from './SlColorCacheManager';
import { SlVisualConfigManager } from './SlVisualConfigManager';

const TAG: string = 'SlSolidColorManager';
const log = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 纯色切换监听接口
 */
export interface SolidColorListener {
  onColorChange: () => void;
}

/**
 * 锁屏组件颜色管理
 */
export class SlSolidColorManager {
  /**
   * 纯色计算缓存加速模块
   */
  private cacheManager: SlColorCacheManager = new SlColorCacheManager();

  /**
   * 组件区域管理
   */
  private widgetAreaManager: SlWidgetAreaManager;

  /**
   * 提亮参数管理
   */
  private brightnessManager: SlVisualArgsManager;

  /**
   * 监听纯色刷新
   */
  private listeners: Map<SlAreaType, Set<SolidColorListener>> = new Map();

  /**
   * 当前使用的壁纸类型
   */
  private curWallPaperType: SLWallpaperType = SLWallpaperType.TYPE_ENGINE_THEME;

  /**
   * 锁屏当前壁纸图片
   */
  private curWallpaperImg?: image.PixelMap;

  /**
   * 初始化
   */
  constructor(brightnessManager: SlVisualArgsManager, widgetAreaManager: SlWidgetAreaManager,
    cacheManager: SlColorCacheManager) {
    this.cacheManager = cacheManager;
    this.brightnessManager = brightnessManager;
    this.widgetAreaManager = widgetAreaManager;
  }

  /**
   * 组件区域背景壁纸颜色计算完毕后触发纯色计算和UI刷新
   */
  private notifyCalColorEnd = (widgetArea: SlArea): void => {
    widgetArea.argsArr.forEach((key: SlPositionType) => {
      this.refreshComponentSolidColor(widgetArea, this.curWallPaperType, key);
    });
    this.listeners.get(widgetArea.areaType)?.forEach((listener) => {
      listener.onColorChange();
    });
  };

  /**
   * 注册监听纯色刷新
   *
   * @param areaType 组件所在区域
   * @param listener 监听纯色刷新
   */
  registerListener(areaType: SlAreaType, listener?: SolidColorListener): void {
    if (!areaType || !listener) {
      return;
    }
    let set = this.listeners.get(areaType);
    if (!set) {
      set = new Set();
      this.listeners.set(areaType, set);
    }
    set.add(listener);
  }

  /**
   * 注销监听纯色刷新
   *
   * @param areaType 组件所在区域
   */
  unregisterListener(areaType: SlAreaType, listener?: SolidColorListener): void {
    if (!areaType || !listener) {
      return;
    }
    this.listeners.get(areaType)?.delete(listener);
  }

  /**
   * 注册当前壁纸
   *
   * @param wallPaperType 壁纸类型
   * @param wallPaper 当期壁纸
   * @param isChangeImg 壁纸资源是否刷新
   */
  registerCurrentWallpaper(wallPaperType: SLWallpaperType, wallPaper: image.PixelMap | undefined,
    isChangeImg: boolean): void {
    if (this.isNormalMode()) {
      return;
    }

    if (this.curWallPaperType === wallPaperType && this.curWallpaperImg === wallPaper) {
      log.showInfo(`no need refresh for same wallPaper, wallPaperType:${wallPaperType}`);
      return;
    }

    if (!wallPaper) {
      this.curWallpaperImg = undefined;
      this.curWallPaperType = wallPaperType;
      log.showInfo(`release wallPaper, wallPaperType:${wallPaperType}`);
      return;
    }

    log.showInfo(`registerCurrentWallpaper wallPaperType:${wallPaperType}, isChangeImg:${isChangeImg}`);
    if (isChangeImg) {
      this.cacheManager.invalidBackColorByWallPaperType(wallPaperType);
    }
    this.curWallPaperType = wallPaperType;
    this.curWallpaperImg = wallPaper;
    this.widgetAreaManager.getAllArea().forEach((slArea: SlArea, type: SlAreaType) => {
      this.calSingleAreaBackgroundColor(slArea, wallPaper, wallPaperType);
    });
  }

  /**
   * 根据开关判断是否是正常模式，正常模式是纯色关闭、提亮开启
   *
   * @returns true 表示正常模式
   */
  isNormalMode(): boolean {
    return !SlVisualConfigManager.getInstance().getEnable(CcmOption.SOLID) &&
    SlVisualConfigManager.getInstance().getEnable(CcmOption.BRIGHT);
  }

  /**
   * 组件位置更新后需重新触发背景颜色计算
   *
   * @param slAreaType 组件类型
   */
  reCalColorForAreaChange(slAreaType: SlAreaType): void {
    log.showInfo(`reCalColorForAreaChange slAreaType:${slAreaType}`);
    let slArea: SlArea | undefined = this.widgetAreaManager.getArea(slAreaType);
    if (!slArea) {
      log.showWarn(`reCalColorForAreaChange fail for invalid area, area:${slAreaType}`);
      return;
    }
    if (!this.curWallpaperImg) {
      log.showWarn(`reCalColorForAreaChange fail for invalid img, type:${this.curWallPaperType}`);
      return;
    }
    this.calSingleAreaBackgroundColor(slArea, this.curWallpaperImg, this.curWallPaperType);
  }

  /**
   * 获取当前制定区域的缓存背景色
   *
   * @param areaType 区域类型
   * @returns 背景色
   */
  getCurBackColorByType(areaType: SlAreaType): effectKit.Color | undefined {
    let pos = this.widgetAreaManager.getArea(areaType)?.position ?? CommonConstants.DEFAULT_WIDGET_AREA;
    return this.cacheManager.getBackColorCache(this.curWallPaperType, pos)?.color;
  }

  /**
   * 壁纸更新后，计算组件区域的背景壁纸的颜色
   *
   * @param widgetArea 组件的区域
   * @param img 壁纸图片
   * @param wallPaperType 壁纸类型
   */
  private async calSingleAreaBackgroundColor(widgetArea: SlArea, img: image.PixelMap,
    wallPaperType: SLWallpaperType): Promise<void> {
    let oldBackCache = this.cacheManager.getBackColorCache(wallPaperType, widgetArea.position);
    if (oldBackCache) {
      log.showInfo(this.printCalSingleColorLog('cal color match cache', widgetArea, wallPaperType));
      this.notifyCalColorEnd(widgetArea);
      return;
    }

    try {
      let colorPicker: effectKit.ColorPicker = await effectKit.createColorPicker(img, widgetArea.position);
      if (!colorPicker) {
        log.showError(this.printCalSingleColorLog('colorPicker invalid', widgetArea, wallPaperType));
        return;
      }

      let backInfo = BackCacheUnit.wrapper(colorPicker.getAverageColor(), colorPicker.discriminatePitureLightDegree());
      this.cacheManager.setBackColorCache(wallPaperType, widgetArea.position, backInfo);
      this.notifyCalColorEnd(widgetArea);
      log.showInfo(this.printCalSingleColorLog('cal Color suc', widgetArea, wallPaperType));
      // 回收内存
      // MemoryUtils.removeNapiWrap(colorPicker, false);
    } catch (err) {
      log.showError(this.printCalSingleColorLog(`cal Color err: ${err?.code}`, widgetArea, wallPaperType));
    }
  }

  private printCalSingleColorLog(prefix: string, widgetArea: SlArea, wallPaperType: SLWallpaperType): string {
    let backInfo = this.cacheManager.getBackColorCache(wallPaperType, widgetArea?.position);
    let colorString = SlVisualSolidUtils.getColorString(backInfo?.color);
    return prefix + ` ,areaType:${widgetArea.areaType}, wallPaperType:${wallPaperType},
      position:${widgetArea.printPosition()},` + `color:${colorString}, degree:${backInfo?.degree}`;
  }

  /**
   * 刷新组件的纯色
   *
   * @param slArea 组件所在区域
   * @param key 组件提亮参数唯一标识
   */
  private refreshComponentSolidColor(slArea: SlArea, wallPaperType: SLWallpaperType, key: SlPositionType): void {
    let backInfo = this.cacheManager.getBackColorCache(wallPaperType, slArea.position);
    if (!backInfo) {
      log.showWarn(`refreshComponentSolidColor fail, wallPaperType:${wallPaperType}, key:${key}, area:${slArea.areaType}`);
      return;
    }
    this.brightnessManager.updateBrightColor(key, backInfo.color, backInfo.getIsLightStatus());
  }
}