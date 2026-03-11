/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import { TextColor } from './TextColor';
import { SCBConstants, WallpaperConstants } from '@ohos/commonconstants';
import effectKit from '@ohos.effectKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EvtBus } from '../../eventbus/EventBus';
import { DockAvgColorChangeEvent, WallpaperChangeEvent } from '../../eventbus/events/Events';
import image from '@ohos.multimedia.image';
import { WallpaperChangeListener, WallpaperManager, WallpaperType } from './WallpaperManager';
import { ThemeActivationEvent } from '../../eventbus/events/Events';
import { DeviceHelper } from '../../base/DeviceHelper';
import { GlobalContext, SCBVisualEffectData } from '../../TsIndex';
import { GrayscaleUtil } from '../../utils/GrayscaleUtil';

const TAG = 'WallpaperColorManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DARK_COLOR_MODE: number = 0;
const LIGHT_COLOR_MODE: number = 1;
const COLUMN: number = 8;
const ROW: number = 4;

export class WallpaperColorManager {
  mTextColor?: TextColor;
  mWallpaperType?: number;
  mSwiperSelectedColor?: string;
  mSwiperColor?: string;
  mOuterSwiperSelectedColor?: string;
  mOuterSwiperColor?: string;
  mOuterTextColor?: TextColor;
  degreeChangeCallBack: Function | null = null;
  wallpaperDegree?: number;
  backPlaneColor?: string;
  brightness?: number;
  scbVisualEffectData?: SCBVisualEffectData;

  static getInstance(): WallpaperColorManager {
    if (globalThis.wallpaperColorManager == null) {
      log.showInfo('getInstance');
      globalThis.wallpaperColorManager = new WallpaperColorManager();
    }
    return globalThis.wallpaperColorManager;
  }

  private listener: WallpaperChangeListener = {
    registeredTag: TAG,
    listenerType: WallpaperType.ALL,
    onWallPaperChange: (event: ThemeActivationEvent) => {
      log.showInfo('WallpaperColorManager WallPaper Change');
      this.loadWallpaper();
    }
  };

  public setSCBVisualEffectData(value: SCBVisualEffectData): void {
    this.scbVisualEffectData = value;
  }

  public getBackPlaneColor(): string | undefined {
    return this.backPlaneColor;
  }

  /**
   * 壁纸degree变化回调
   * @param callback
   */
  public registerDegreeChangeCallBack(callback: Function): void {
    this.degreeChangeCallBack = callback;
  }

  /**
   * 解注册壁纸degree变化回调
   */
  public unRegisterDegreeChangeCallBack(): void {
    this.degreeChangeCallBack = null;
  }

  /**
   * 注册壁纸变化监听
   *
   */
  public registerWallpaperChange(): void {
    WallpaperManager.getInstance().addWallpaperChangeListener(this.listener);
  }

  /**
   * 反注册壁纸变化监听
   *
   */
  public unregisterWallPaperChange(): void {
    WallpaperManager.getInstance().removeWallpaperChangeListener(this.listener);
  }

  /**
   * 加载并分析壁纸颜色
   */
  public async loadWallpaper(): Promise<void> {
    try {
      await this.processColor();
    } catch (err) {
      log.error('loadWallpaper exception is', err);
      this.generateTextColorInfo(WallpaperConstants.WALLPAPER_TYPE_FIVE, WallpaperConstants.COLOR_WHITE_STRING);
    }
  }

  /**
   * 获取壁纸，处理颜色
   * @param isOuter 是否为新型小折叠外屏
   */
  private async processColor(isOuter: boolean = false): Promise<void> {
    const wallpaperType: WallpaperType = isOuter ? WallpaperType.DESKTOP_SUBSCREEN : WallpaperType.DESKTOP;
    const image: image.PixelMap = await WallpaperManager.getInstance().getWallpaperCache(wallpaperType, TAG);
    let colorPicker = await effectKit.createColorPicker(image);
    let color: effectKit.Color = colorPicker.getReverseColor();
    this.wallpaperDegree = colorPicker.discriminatePitureLightDegree();
    this.generateTextColorInfo(this.wallpaperDegree, color, isOuter);
    log.showInfo(`processColor success fontColor: ${color} wallpapeType: ${this.wallpaperDegree}`);
    if (!isOuter) {
      // handle wallpaper avgColor for dock
      const avgColor = colorPicker.getAverageColor();
      this.handleWallpaperAvgColor(avgColor);
      this.handleDockBackPlaneColor();
    }
    // MemoryUtils.removeNapiWrap(colorPicker, false);
    if (this.degreeChangeCallBack) {
      this.degreeChangeCallBack(this.wallpaperDegree);
    }
  }

  /**
   * 获取壁纸颜色类型
   * @param region 指定图片的取色区域
   */
  public async getDegree(region?: Array<number>): Promise<number> {
    let image: image.PixelMap;
    let degree: number = 0;
    try {
      image = await WallpaperManager.getInstance().getWallpaperCache(WallpaperType.DESKTOP, TAG);
      let colorPicker: effectKit.ColorPicker;
      if (region) {
        colorPicker = await effectKit.createColorPicker(image, region);
      } else {
        colorPicker = await effectKit.createColorPicker(image);
      }
      degree = colorPicker.discriminatePitureLightDegree();
      log.showInfo('getDegree ' + degree);
    } catch (err) {
      log.error('getDegree error ', err);
      this.generateTextColorInfo(WallpaperConstants.WALLPAPER_TYPE_FIVE, WallpaperConstants.COLOR_WHITE_STRING);
    }
    return degree;
  }

  /**
   * 获取壁纸区域平均色
   *
   * @param region 指定壁纸的取色区域
   * @returns 返回壁纸指定区域的平均色
   */
  public async getRegionAvgColor(region?: Array<number>): Promise<effectKit.Color | undefined> {
    let image: image.PixelMap;
    let colorPicker: effectKit.ColorPicker | undefined = undefined;
    let color: effectKit.Color | undefined = undefined;
    try {
      image = await WallpaperManager.getInstance().getWallpaperCache(WallpaperType.DESKTOP, TAG);
      if (region) {
        colorPicker = await effectKit.createColorPicker(image, region);
      } else {
        colorPicker = await effectKit.createColorPicker(image);
      }
      color = colorPicker.getAverageColor();
      log.showWarn(`getRegionAvgColor ,red : ${color.red},green:  ${color.green},blue:  ${color.blue}`);
    } catch (err) {
      log.error('getRegionAvgColor error ', err);
    } finally {
      // MemoryUtils.removeNapiWrap(colorPicker, false);
    }
    return color;
  }

  public generateTextColorInfo(type: number, color: effectKit.Color | string, isOuter: boolean = false): void {
    let textColor: TextColor;
    let swiperColor: string;
    let swiperSelectedColor: string;
    switch (type) {
      case WallpaperConstants.WALLPAPER_TYPE_ONE: {
        textColor = new TextColor(color, WallpaperConstants.NUMBER_0, WallpaperConstants.NUMBER_0, WallpaperConstants.NUMBER_0,
          WallpaperConstants.ALPHA_0, type);
        swiperColor = WallpaperConstants.SWIPER_BLACK_COLOR;
        swiperSelectedColor = WallpaperConstants.SWIPER_BLACK_COLOR_SELECTED;
        break;
      }
      case WallpaperConstants.WALLPAPER_TYPE_TWO: {
        textColor = new TextColor(color, WallpaperConstants.NUMBER_20, WallpaperConstants.NUMBER_0, WallpaperConstants.NUMBER_0,
          WallpaperConstants.ALPHA_40, type);
        swiperColor = WallpaperConstants.SWIPER_WHITE_COLOR;
        swiperSelectedColor = WallpaperConstants.SWIPER_WHITE_COLOR_SELECTED;
        break;
      }
      case WallpaperConstants.WALLPAPER_TYPE_THREE: {
        textColor = new TextColor(color, WallpaperConstants.NUMBER_20, WallpaperConstants.NUMBER_0, WallpaperConstants.NUMBER_0,
          WallpaperConstants.ALPHA_40, type);
        swiperColor = WallpaperConstants.SWIPER_WHITE_COLOR;
        swiperSelectedColor = WallpaperConstants.SWIPER_WHITE_COLOR_SELECTED;
        break;
      }
      case WallpaperConstants.WALLPAPER_TYPE_FOUR: {
        textColor = new TextColor(color, WallpaperConstants.NUMBER_0, WallpaperConstants.NUMBER_0, WallpaperConstants.NUMBER_0,
          WallpaperConstants.ALPHA_0, type);
        swiperColor = WallpaperConstants.SWIPER_WHITE_COLOR;
        swiperSelectedColor = WallpaperConstants.SWIPER_WHITE_COLOR_SELECTED;
        break;
      }
      case WallpaperConstants.WALLPAPER_TYPE_FIVE: {
        textColor = new TextColor(color, WallpaperConstants.NUMBER_20, WallpaperConstants.NUMBER_0, WallpaperConstants.NUMBER_0,
          WallpaperConstants.ALPHA_40, type);
        swiperColor = WallpaperConstants.SWIPER_WHITE_COLOR;
        swiperSelectedColor = WallpaperConstants.SWIPER_WHITE_COLOR_SELECTED;
        break;
      }
      case WallpaperConstants.WALLPAPER_TYPE_SIX: {
        textColor = new TextColor(color, WallpaperConstants.NUMBER_20, WallpaperConstants.NUMBER_0, WallpaperConstants.NUMBER_0,
          WallpaperConstants.ALPHA_80, type);
        swiperColor = WallpaperConstants.SWIPER_WHITE_COLOR;
        swiperSelectedColor = WallpaperConstants.SWIPER_WHITE_COLOR_SELECTED;
        break;
      }
      default: {
        // 默认按照type5处理
        textColor = new TextColor(color, WallpaperConstants.NUMBER_20, WallpaperConstants.NUMBER_0, WallpaperConstants.NUMBER_0,
          WallpaperConstants.ALPHA_40, type);
        swiperColor = WallpaperConstants.SWIPER_WHITE_COLOR;
        swiperSelectedColor = WallpaperConstants.SWIPER_WHITE_COLOR_SELECTED;
        break;
      }
    }
    if (isOuter) {
      this.mOuterTextColor = textColor;
      this.mOuterSwiperColor = swiperColor;
      this.mOuterSwiperSelectedColor = swiperSelectedColor;
    } else {
      this.mTextColor = textColor;
      this.mSwiperColor = swiperColor;
      this.mSwiperSelectedColor = swiperSelectedColor;
    }
    this.updateFontColor();
  }

  private updateFontColor(): void {
    log.showWarn(`updateFontColor:${this.mTextColor?.mTextColor}`);
    if (!AppStorage.Has('wallpaperChangeFlag')) {
      AppStorage.setOrCreate<boolean>('wallpaperChangeFlag', false);
    } else {
      let wallpaperChangeFlag = AppStorage.get<boolean>('wallpaperChangeFlag');
      AppStorage.setOrCreate('wallpaperChangeFlag', !wallpaperChangeFlag);
    }
    // 通知图标名称文字颜色改变事件
    GlobalContext.getContext()?.eventHub.emit(SCBConstants.EVENT_UPDATE_FONT_COLOR);
  }

  private updateBrightness(): void {
    let currColorMode: number =
      AppStorage.get<number>('currColorMode') ?? GlobalContext.getContext().config.colorMode as number;
    log.showDebug(`currColorMode:${currColorMode}`);
    // 1-极浅壁纸；2-浅色壁纸；3-深色壁纸；4-极深壁纸；5-普通花壁纸；6-极花壁纸
    if (currColorMode === DARK_COLOR_MODE &&
      this.wallpaperDegree === WallpaperConstants.WALLPAPER_TYPE_FOUR) {
      // 1、深色模式 极深壁纸 brightness设置1.15
      this.brightness = SCBConstants.BACK_PLANE_BRIGHTNESS_UP_FIFTEEN_PERCENT;
    } else if (currColorMode === LIGHT_COLOR_MODE &&
      this.wallpaperDegree !== WallpaperConstants.WALLPAPER_TYPE_ONE) {
      // 2、浅色模式 非极浅壁纸 brightness设置1.1
      this.brightness = SCBConstants.BACK_PLANE_BRIGHTNESS_UP_TEN_PERCENT;
    } else if (currColorMode === LIGHT_COLOR_MODE &&
      this.wallpaperDegree === WallpaperConstants.WALLPAPER_TYPE_ONE) {
      // 3、浅色模式 极浅壁纸 brightness设置0.92
      this.brightness = SCBConstants.BACK_PLANE_BRIGHTNESS_DOWN_EIGHT_PERCENT;
    } else if (currColorMode === DARK_COLOR_MODE &&
      this.wallpaperDegree === WallpaperConstants.WALLPAPER_TYPE_ONE) {
      // 4、深色模式 极浅壁纸 brightness设置1
      this.brightness = SCBConstants.BACK_PLANE_BRIGHTNESS_DEFAULT;
    } else {
      // 5、深色模式 非极深极浅壁纸 brightness设置0.95
      this.brightness = SCBConstants.BACK_PLANE_BRIGHTNESS_DOWN_FIVE_PERCENT;
    }
    log.showWarn(`updateBrightness mBackgroundBrightness=${this.brightness}`);
  }

  public async handleDockBackPlaneColor(): Promise<void> {
    if (!this.scbVisualEffectData?.isDockSolidColor) {
      return;
    }
    this.updateBrightness();
    let isPortrait: boolean = AppStorage.get<boolean>('isPortrait') ?? true;
    let dockOffset = isPortrait ? (COLUMN - 1) / COLUMN : (ROW - 1) / ROW;
    const region: number[] = [0, dockOffset, 1, 1];
    let dockAvgColor: effectKit.Color | undefined = await this.getRegionAvgColor(region);
    if (dockAvgColor && this.brightness) {
      let temp: number = Math.round((this.brightness - 1) * WallpaperConstants.NUMBER_255);
      this.backPlaneColor =
        GrayscaleUtil.calGrayscale(dockAvgColor.red + temp, dockAvgColor.green + temp, dockAvgColor.blue + temp,
          dockAvgColor.alpha);
      log.showWarn(`dockAvgColor: ${this.backPlaneColor},isPortrait: ${isPortrait}`);
    }
  }

  /**
   * revert the decimal color to hexadecimal color and add 3% alpha effect
   * @param color current color
   */
  private handleWallpaperAvgColor(color: effectKit.Color): void {
    log.showInfo('handleWallpaperAvgColor avgColor');
    let red: string = color.red.toString(WallpaperConstants.NUMBER_16).padStart(WallpaperConstants.NUMBER_2, WallpaperConstants.PREFIX_0);
    let green: string = color.green.toString(WallpaperConstants.NUMBER_16).padStart(WallpaperConstants.NUMBER_2, WallpaperConstants.PREFIX_0);
    let blue: string = color.blue.toString(WallpaperConstants.NUMBER_16).padStart(WallpaperConstants.NUMBER_2, WallpaperConstants.PREFIX_0);
    const finalColorForStatusBarPanel = `${WallpaperConstants.COLOR_PREFIX}${WallpaperConstants.ALPHA_10}${red}${green}${blue}`;
    EvtBus.post(WallpaperChangeEvent, { avgColor: finalColorForStatusBarPanel});
  }

  /**
   * 是否是浅色壁纸，当壁纸是浅色时文字颜色为深色，即#000000
   *
   * @returns 浅色壁纸返回true，深色壁纸返回false
   */
  public isLightWallpaper(isOuter?: boolean): boolean {
    if (isOuter) {
      return this.mOuterTextColor?.mTextColor === '#000000';
    }
    return this.mTextColor?.mTextColor === '#000000';
  }
}