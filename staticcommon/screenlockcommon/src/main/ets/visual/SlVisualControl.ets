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
import { SlVisualArgsManager } from './SlVisualArgsManager';
import { SlSolidColorManager, SolidColorListener } from './SlSolidColorManager';
import { SlWidgetAreaManager } from './SlWidgetAreaManager';
import { image } from '@kit.ImageKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SlVisualArgs } from './SlVisualData';
import { SLWallpaperType } from '../wallpaper/ScreenLockWallpaperState';
import { SlColorCacheManager } from './SlColorCacheManager';
import { SlVisualConfigManager } from './SlVisualConfigManager';
import { effectKit } from '@kit.ArkGraphics2D';
import { ThemeActivationEvent, WallpaperChangeListener, WallpaperManager, WallpaperType } from '@ohos/frameworkwrapper';

const TAG = 'SlVisualControl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏元素视效控制
 */
export class SlVisualControl {
  /**
   * 单例实例对象
   */
  private static instance: SlVisualControl;

  /**
   * 纯色计算缓存加速模块
   */
  private cacheManager: SlColorCacheManager = new SlColorCacheManager();

  /**
   * 组件区域管理
   */
  private widgetAreaManager: SlWidgetAreaManager = new SlWidgetAreaManager();

  /**
   * 视效参数管理
   */
  private visualArgsManager: SlVisualArgsManager = new SlVisualArgsManager();

  /**
   * 纯色管理
   */
  private solidColorManager: SlSolidColorManager = new SlSolidColorManager(
    this.visualArgsManager, this.widgetAreaManager, this.cacheManager);

  private listener?: WallpaperChangeListener;

  private constructor() {
    if (SlVisualConfigManager.getInstance().getEnable(CcmOption.SOLID)) {
      this.listener = {
        registeredTag: TAG,
        listenerType: WallpaperType.SCEENLOCK,
        onWallPaperChange: (event: ThemeActivationEvent): void => {
          this.handleWallPaperChange();
        }
      };
      WallpaperManager.getInstance().addWallpaperChangeListener(this.listener);
    }
  }

  /**
   * 获取单例对象
   *
   * @returns 实例
   */
  static getInstance(): SlVisualControl {
    if (!SlVisualControl.instance) {
      SlVisualControl.instance = new SlVisualControl();
    }
    return SlVisualControl.instance;
  }

  /**
   * 查词对应区域CCM配置
   *
   * @param option 需要查询的属性
   * @param type 组件所在区域
   * @returns 查询结果
   */
  getEnable(option: CcmOption, type?: SlAreaType): boolean {
    return SlVisualConfigManager.getInstance().getEnable(option, type);
  }

  /**
   * 查询视效参数
   *
   * @param positionType 参数使用位置
   * @returns 视效参数
   */
  getVisualArgs(positionType: SlPositionType): SlVisualArgs | undefined {
    return this.visualArgsManager.getVisualArgs(positionType);
  }

  /**
   * 更新锁屏元素根组件区域
   *
   * @param slArea 组件类型
   * @param area 组件区域坐标
   */
  updateComponentArea(slAreaType: SlAreaType, area: Area): void {
    if (this.widgetAreaManager.updateComponentArea(slAreaType, area)) {
      this.solidColorManager.reCalColorForAreaChange(slAreaType);
    }
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
    if (wallPaperType === SLWallpaperType.TYPE_IMMERSIVE_STYLE) {
      this.solidColorManager.registerCurrentWallpaper(wallPaperType, wallPaper, isChangeImg);
    } else {
      this.handleWallPaperChange();
    }
  }

  /**
   * 各个业务注册视效参数
   *
   * @param args 锁屏子业务所有视效参数
   */
  registerSlVisualArr(args: SlVisualArgs[]): void {
    if (!args || args.length <= 0) {
      return;
    }
    args.forEach((args: SlVisualArgs) => {
      this.registerVisualArgs(args);
    });
  }

  /**
   * 注销各个业务注册视效参数
   *
   * @param args 锁屏子业务所有视效参数
   */
  unregisterSlVisualArr(args: SlVisualArgs[]): void {
    args?.forEach((args: SlVisualArgs) => {
      this.unregisterVisualArgs(args);
    });
  }

  /**
   * 注册监听纯色刷新
   *
   * @param areaType 组件所在区域
   * @param listener 监听纯色刷新
   */
  registerSolidListener(areaType: SlAreaType, listener?: SolidColorListener): void {
    this.solidColorManager.registerListener(areaType, listener);
  }

  /**
   * 注销监听纯色刷新
   *
   * @param areaType 组件所在区域
   * @param listener 监听纯色刷新
   */
  unregisterSolidListener(areaType: SlAreaType, listener?: SolidColorListener): void {
    this.solidColorManager.unregisterListener(areaType, listener);
  }

  /**
   * 获取当前制定区域的缓存背景色
   *
   * @param areaType 区域类型
   * @returns 背景色
   */
  getCurBackColorByType(areaType: SlAreaType): effectKit.Color | undefined {
    return this.solidColorManager.getCurBackColorByType(areaType);
  }

  /**
   * 提供给feature层各个模块注册视效参数
   *
   * @param args 视效参数
   */
  private registerVisualArgs(args: SlVisualArgs): void {
    if (this.visualArgsManager.registerVisualOption(args)) {
      this.widgetAreaManager.registerVisualOption(args);
    }
  }

  /**
   * 注销视效参数
   *
   * @param args 视效参数
   * */
  private unregisterVisualArgs(args: SlVisualArgs): void {
    if (this.visualArgsManager.unregisterVisualOption(args)) {
      this.widgetAreaManager.unregisterVisualOption(args);
    }
  }

  private handleWallPaperChange(): void {
    if (this.solidColorManager.isNormalMode()) {
      return;
    }
    log.showInfo('WallPaper Change');
    try {
      WallpaperManager.getInstance().getWallpaperCache(WallpaperType.SCEENLOCK, TAG).then((wallPaper) => {
        this.solidColorManager.registerCurrentWallpaper(SLWallpaperType.TYPE_ENGINE_THEME, wallPaper, true);
      });
    } catch (error) {
      log.error('getWallpaperCache promise::try catch : ', error);
    }
  }
}