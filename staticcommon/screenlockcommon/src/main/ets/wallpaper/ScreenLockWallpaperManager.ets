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

import {
  CommonUtils,
  LogDomain,
  LogHelper,
  // MemoryUtils,
  SingletonHelper,
  ArrayUtils
} from '@ohos/basicutils';
import { WallpaperConstants } from '@ohos/commonconstants';
import { CustomPromise, DeviceHelper, EvtBus, sSettingsUtil } from '@ohos/frameworkwrapper';
import { SLWallpaperState, SLWallpaperVisibleScene } from './ScreenLockWallpaperState';
import { SLWallpaperType } from './ScreenLockWallpaperState';
import type image from '@ohos.multimedia.image';
import effectKit from '@ohos.effectKit';
import type { BusinessError } from '@ohos.base';
import {
  ScreenLockWallpaperChangeEvent
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/event/ImmersiveEvent';
import {
  ClockBindStateType,
  ClockStaticStateType,
  SlBindStateType,
  SlMainStateType,
  SlStaticStateType,
  SlSubStateType,
} from '../constants/SlStateType';
import { slUiStateMgr } from '../manager/ScreenLockUiStateManager';
import { ISlStateChangeListener } from '../interface/ISlStateChangeListener';
import { ISlState } from '../interface/ISlState';
import { ThemeScene } from '../constants/ThemeEditAndScreenLockConstants';
import { SlVisualControl } from '../visual/SlVisualControl';
import { ScreenBp, SizeBpSplice, SizeBp } from '../immersivekgcommon/base/utils/ScreenBreakPoint';
import { FileUtil } from '../utils/FileUtil';

const TAG = 'ScreenLockWallpaperManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 亮屏动效，壁纸默认模糊半径
 */
const DEFAULT_ANIM_BLUR = 242;

/**
 * 沉浸锁屏场景，壁纸模糊半径
 */
const IMMERSIVE_BLUR = 242;

/**
 * 壁纸浅色度，浅色类型
 */
const EXTREMELY_LIGHT_COLOR_PICTURE = 1;

/**
 * 数据库键值：是否为浅色壁纸 0深色壁纸，1浅色壁纸
 */
const SETTINGSDB_SCREENLOCK_WALLPAPER_ISLIGHTWALLPAPER: string = 'SettingsDB.Screenlock.Wallpaper.IsLightWallpaper';

/**
 * 锁屏亮屏动效场景，壁纸模糊参数
 */
class WallpaperAnimBlur {
  /**
   * 动效起始，壁纸模糊半径
   */
  public animStartBlur: number = DEFAULT_ANIM_BLUR;

  /**
   * 动效结束，壁纸最终模糊半径
   */
  public animEndBlur: number = 0;

  /**
   * 构造
   *
   * @param animStartBlur 动效起始模糊半径
   * @param animEndBlur 动效结束模糊半径
   */
  constructor(animStartBlur: number, animEndBlur: number) {
    this.animStartBlur = animStartBlur;
    this.animEndBlur = animEndBlur;
  }
}

/**
 * 景深壁纸参数
 */
export interface IDofParam {
  type: SLWallpaperType | null,
  isDofDone: boolean, // 当前形态的景深是否经过智慧美学计算过
  isDof: boolean,
  clockType?: number, // 景深效果对应的ID
  pic: image.PixelMap | undefined,
  configPath: string, // wallpaper_config.json的路径
  configContent: string, // wallpaper_config.json的内容
}

/**
 * 壁纸类型与模糊半径映射关系
 */
const ANIM_BLUR_MAP: Map<SLWallpaperType, WallpaperAnimBlur> = new Map([
  [SLWallpaperType.TYPE_NONE, new WallpaperAnimBlur(DEFAULT_ANIM_BLUR, 0)],
  [SLWallpaperType.TYPE_ENGINE_THEME, new WallpaperAnimBlur(DEFAULT_ANIM_BLUR, 0)],
  [SLWallpaperType.TYPE_IMMERSIVE_STYLE, new WallpaperAnimBlur(DEFAULT_ANIM_BLUR, IMMERSIVE_BLUR)]
]);

/**
 * 锁屏壁纸不同类型显示优先级
 * 沉浸锁屏壁纸 > 引擎主题壁纸 > 无壁纸
 */
const WALLPAPER_TYPE_PRIORITY: SLWallpaperType[] = [
  SLWallpaperType.TYPE_EDIT_STYLE,
  SLWallpaperType.TYPE_IMMERSIVE_STYLE,
  SLWallpaperType.TYPE_ENGINE_THEME,
  SLWallpaperType.TYPE_NONE
];

/**
 * 锁屏壁纸状态装饰器
 */
class SlWallpaperStateWrapper {
  /**
   * 锁屏壁纸状态，被装饰对象
   */
  public slWallpaperState: SLWallpaperState = new SLWallpaperState();

  /**
   * 复合壁纸类型
   */
  private allWallpaperType: SLWallpaperType = SLWallpaperType.TYPE_NONE;

  /**
   * 单一壁纸类型
   */
  private curWallpaperType: SLWallpaperType = SLWallpaperType.TYPE_NONE;

  /**
   * 壁纸类型与壁纸图片映射关系
   */
  private wallpaperImgMap: Map<SLWallpaperType, image.PixelMap> = new Map();

  /**
   * 壁纸类型与壁纸反色映射关系
   */
  private wallpaperReverseColorMap: Map<SLWallpaperType, string> = new Map();

  /**
   * 壁纸类型与壁纸深浅色状态映射关系
   */
  private wallpaperLightStateMap: Map<SLWallpaperType, boolean> = new Map();

  /**
   * 壁纸反色等待
   */
  private reverseColorPromiseMap: Map<SLWallpaperType, Map<SLWallpaperType, CustomPromise<string>>> = new Map();

  /**
   * 壁纸深浅色等待
   */
  private lightStatePromiseMap: Map<SLWallpaperType, Map<SLWallpaperType, CustomPromise<boolean>>> = new Map();

  /**
   * 壁纸反色信息切换事件
   */
  private slWallpaperChangeEvent: ScreenLockWallpaperChangeEvent = new ScreenLockWallpaperChangeEvent();

  /**
   * 设置锁屏壁纸图片
   *
   * @param type 壁纸类型
   * @param img 壁纸图片
   * @param isRecycleOld 壁是否回收旧图
   */
  setWallpaperImg(type: SLWallpaperType, img?: image.PixelMap, isRecycleOld?: boolean): void {
    // 刷新壁纸图片
    if (this.refreshWallpaperImg(type, img, isRecycleOld)) {
      // 刷新壁纸反色
      this.refreshWallpaperReverseColor();

      // 刷新壁纸深浅色状态
      this.refreshWallpaperLightState();
    }
  }

  /**
   * 设置壁纸可见性
   *
   * @param type 可见壁纸类型
   * @param isVisible 是否请求可见
   */
  setWallpaperVisibility(type: SLWallpaperType, isVisible: boolean = false): void {
    if (isVisible) {
      this.allWallpaperType |= type;
    } else {
      this.allWallpaperType &= ~Number(type);
    }

    // 刷新锁屏壁纸可见性
    this.refreshWallpaperVisibility();

    // 刷新可见壁纸类型
    if (this.refreshWallpaperType()) {
      this.refreshVisualWallPaper(this.curWallpaperType, false);

      // 刷新壁纸图
      this.checkNewWallpaperImg();

      // 刷新壁纸模糊半径
      this.setBlurByAnimEnd();

      // 刷新壁纸反色
      this.refreshWallpaperReverseColor();

      // 刷新壁纸深浅色状态
      this.refreshWallpaperLightState();
    }
  }

  /**
   * 设置模糊半径为动效起始值
   */
  setBlurByAnimStart(): void {
    this.slWallpaperState.wallpaperBlur = ANIM_BLUR_MAP.get(this.curWallpaperType)?.animStartBlur ?? DEFAULT_ANIM_BLUR;
  }

  /**
   * 设置模糊半径为最终值
   */
  setBlurByAnimEnd(): void {
    this.slWallpaperState.wallpaperBlur = ANIM_BLUR_MAP.get(this.curWallpaperType)?.animEndBlur ?? 0;
  }

  /**
   * 刷新当前显示壁纸类型
   *
   * @returns 是否切换当前壁纸类型
   */
  private refreshWallpaperType(): boolean {
    // 根据优先级选择当前显示壁纸类型
    let tarType = WALLPAPER_TYPE_PRIORITY.find((type) => {
      // 兜底，默认类型
      if (type === SLWallpaperType.TYPE_NONE) {
        return true;
      }
      return (this.allWallpaperType & type) !== 0;
    });

    // 刷新当前显示壁纸类型
    if (tarType !== undefined && tarType !== this.curWallpaperType) {
      log.showWarn(`refreshWallpaperType tarType: ${tarType} curWallpaperType: ${this.curWallpaperType}`);
      this.curWallpaperType = tarType;
      return true;
    }
    return false;
  }

  /**
   * 刷新壁纸图片
   *
   * @param type 壁纸类型
   * @param img 壁纸图片
   * @param isRecycleOld 是否回收旧图
   * @returns 是否切换当前壁纸图片
   */
  private refreshWallpaperImg(type: SLWallpaperType, img?: image.PixelMap, isRecycleOld?: boolean): boolean {
    let oldImg = this.wallpaperImgMap.get(type);
    let isClear = CommonUtils.isInvalid(img);
    if (isClear) {
      this.wallpaperImgMap.delete(type);
    } else {
      if (img) {
        this.wallpaperImgMap.set(type, img);
      }
    }

    this.refreshVisualWallPaper(type, oldImg !== img);

    // 图片有变化，则刷新图片反色及深浅色状态
    if (oldImg !== img) {
      // 优先删除图片反色，开启异步加载新图片反色
      this.wallpaperReverseColorMap.delete(type);
      this.wallpaperLightStateMap.delete(type);
      this.refreshWallpaperColor(type, img);

      // 回收图片
      if (isRecycleOld) {
        oldImg?.release();
      }
    }
    return this.checkNewWallpaperImg();
  }

  /**
   * 获取壁纸反色颜色
   *
   * @param mainType 主壁纸类型
   * @param subType 子壁纸类型
   * @returns 壁纸反色值
   */
  private async getWallpaperReverseColor(mainType: SLWallpaperType, subType: SLWallpaperType): Promise<string> {
    mainType = this.getDefaultWallpaperType(mainType);

    // 存在则直接返回
    if (this.wallpaperReverseColorMap.has(mainType)) {
      return this.wallpaperReverseColorMap.get(mainType) ?? '';
    }

    if (mainType === SLWallpaperType.TYPE_IMMERSIVE_STYLE) {
      // 沉浸壁纸不存在，选用主题壁纸
      if (!this.wallpaperImgMap.has(mainType)) {
        return this.getWallpaperReverseColor(SLWallpaperType.TYPE_ENGINE_THEME, mainType);
      } else {
        this.deleteReverseColorPromise(SLWallpaperType.TYPE_ENGINE_THEME, mainType);
      }
    }

    // 等待壁纸反色完成
    let colorPromise = this.reverseColorPromiseMap.get(mainType)?.get(subType);
    if (CommonUtils.isInvalid(colorPromise)) {
      colorPromise = new CustomPromise();
      this.addReverseColorPromise(mainType, subType, colorPromise);
    }
    return colorPromise ?? '';
  }

  private addReverseColorPromise(mainType: SLWallpaperType, subType: SLWallpaperType, pr: CustomPromise<string>): void {
    let promiseMap = this.reverseColorPromiseMap.get(mainType);
    if (!promiseMap) {
      promiseMap = new Map();
      this.reverseColorPromiseMap.set(mainType, promiseMap);
    }
    promiseMap.set(subType, pr);
  }

  private deleteReverseColorPromise(mainType: SLWallpaperType, subType: SLWallpaperType): void {
    let promiseMap = this.reverseColorPromiseMap.get(mainType);
    if (promiseMap) {
      // 释放等待器
      promiseMap.get(subType)?.reject();
      promiseMap.delete(subType);
      if (ArrayUtils.isEmpty(promiseMap)) {
        this.reverseColorPromiseMap.delete(mainType);
      }
    }
  }

  /**
   * 获取壁纸深浅色状态
   *
   * @param mainType 主壁纸类型
   * @param subType 子壁纸类型
   * @returns true浅色壁纸
   */
  private async getWallpaperLightState(mainType: SLWallpaperType, subType: SLWallpaperType): Promise<boolean> {
    mainType = this.getDefaultWallpaperType(mainType);

    // 存在则直接返回
    if (this.wallpaperLightStateMap.has(mainType)) {
      return this.wallpaperLightStateMap.get(mainType) ?? false;
    }

    if ((mainType === SLWallpaperType.TYPE_IMMERSIVE_STYLE || mainType === SLWallpaperType.TYPE_EDIT_STYLE)) {
      // 沉浸壁纸不存在，选用主题壁纸
      if (!this.wallpaperImgMap.has(mainType)) {
        return this.getWallpaperLightState(SLWallpaperType.TYPE_ENGINE_THEME, mainType);
      } else { // 存在壁纸图片后，即时释放
        this.deleteLightStatePromise(SLWallpaperType.TYPE_ENGINE_THEME, mainType);
      }
    }

    // 等待壁纸切换深浅色完成
    let lightPromise = this.lightStatePromiseMap.get(mainType)?.get(subType);
    if (CommonUtils.isInvalid(lightPromise)) {
      lightPromise = new CustomPromise();
      this.addLightStatePromise(mainType, subType, lightPromise);
    }
    return lightPromise ?? false;
  }

  private addLightStatePromise(mainType: SLWallpaperType, subType: SLWallpaperType, pr: CustomPromise<boolean>): void {
    let promiseMap = this.lightStatePromiseMap.get(mainType);
    if (!promiseMap) {
      promiseMap = new Map();
      this.lightStatePromiseMap.set(mainType, promiseMap);
    }
    promiseMap.set(subType, pr);
  }

  private deleteLightStatePromise(mainType: SLWallpaperType, subType: SLWallpaperType): void {
    let promiseMap = this.lightStatePromiseMap.get(mainType);
    if (promiseMap) {
      // 释放等待器
      promiseMap.get(subType)?.reject();
      promiseMap.delete(subType);
      if (ArrayUtils.isEmpty(promiseMap)) {
        this.lightStatePromiseMap.delete(mainType);
      }
    }
  }

  /**
   * 检测刷新当前锁屏壁纸图
   *
   * @returns true壁纸已刷新
   */
  private refreshVisualWallPaper(type: SLWallpaperType, isChangeImg: boolean): void {
    let newImg = this.wallpaperImgMap.get(type);
    // 刷新当前显示壁纸图
    if (CommonUtils.isInvalid(newImg) || this.curWallpaperType === SLWallpaperType.TYPE_NONE) {
      // 默认图使用主题壁纸图
      newImg = this.wallpaperImgMap.get(SLWallpaperType.TYPE_ENGINE_THEME);
      SlVisualControl.getInstance().registerCurrentWallpaper(SLWallpaperType.TYPE_ENGINE_THEME, newImg, isChangeImg);
    } else {
      SlVisualControl.getInstance().registerCurrentWallpaper(type, newImg, isChangeImg);
    }
  }

  /**
   * 检测刷新当前锁屏壁纸图
   *
   * @returns true壁纸已刷新
   */
  private checkNewWallpaperImg(): boolean {
    // 刷新当前显示壁纸图
    let newImg = this.getNewCurWallpaperImg();
    if (this.slWallpaperState.wallpaperImg !== newImg) {
      this.slWallpaperState.wallpaperImg = newImg;
      return true;
    }
    return false;
  }

  /**
   * 刷新锁屏壁纸可见性
   */
  private refreshWallpaperVisibility(): void {
    let isCurVisible = (this.allWallpaperType !== SLWallpaperType.TYPE_NONE);

    if ((this.allWallpaperType & SLWallpaperType.TYPE_EDIT_STYLE) !== 0) {
      // 锁屏编辑态，需清除沉浸式和编辑态数据后判断壁纸是否可见
      let editType = this.allWallpaperType;
      editType &= ~ (SLWallpaperType.TYPE_IMMERSIVE_STYLE | SLWallpaperType.TYPE_EDIT_STYLE);
      isCurVisible = editType !== SLWallpaperType.TYPE_NONE;
    }

    if (this.slWallpaperState.isVisible !== isCurVisible) {
      this.slWallpaperState.isVisible = isCurVisible;
    }
  }

  /**
   * 刷新壁纸反色颜色值
   */
  private refreshWallpaperReverseColor(): void {
    let curWallpaperType = this.curWallpaperType;
    this.getWallpaperReverseColor(curWallpaperType, curWallpaperType).then((color) => {
      if (curWallpaperType !== this.curWallpaperType) {
        return;
      }
      if (this.slWallpaperState.wallpaperReverseColor !== color) {
        this.slWallpaperState.wallpaperReverseColor = color;
      }
    });
  }

  /**
   * 刷新壁纸深浅色状态
   */
  private refreshWallpaperLightState(): void {
    let curWallpaperType = this.curWallpaperType;
    this.getWallpaperLightState(curWallpaperType, curWallpaperType).then((isLight) => {
      if (curWallpaperType !== this.curWallpaperType) {
        return;
      }
      if (this.slWallpaperState.isLightWallpaper !== isLight) {
        this.slWallpaperState.isLightWallpaper = isLight;
        sSettingsUtil.setValue(SETTINGSDB_SCREENLOCK_WALLPAPER_ISLIGHTWALLPAPER, isLight.toString());
        // 切换采用V1状态记录
        slUiStateMgr.getSlState(SlMainStateType.SL_BIND_STATE)?.setSlState(SlBindStateType.SL_WALLPAPER_LIGHT, isLight);
      }

      EvtBus.post(ScreenLockWallpaperChangeEvent, this.slWallpaperChangeEvent);

      // 浅色壁纸使用黑色文本
      let mainColor = isLight ? Color.Black : Color.White;
      if (this.slWallpaperState.slMainColor !== mainColor) {
        this.slWallpaperState.slMainColor = mainColor;
      }
    });
  }

  /**
   * 获取默认壁纸类型，默认主题壁纸类型
   *
   * @param type 壁纸类型
   * @returns 默认类型
   */
  private getDefaultWallpaperType(type: SLWallpaperType): SLWallpaperType {
    if (type === SLWallpaperType.TYPE_NONE) {
      return SLWallpaperType.TYPE_ENGINE_THEME;
    }
    return type;
  }

  /**
   * 刷新壁纸反色、深浅色状态
   *
   * @param type 壁纸类型
   * @param img 壁纸图
   * @returns void
   */
  private async refreshWallpaperColor(type: SLWallpaperType, img?: image.PixelMap): Promise<void> {
    if (img) {
      try {
        let colorPicker = await effectKit.createColorPicker(img);
        let reverseColor = this.getColorString(colorPicker.getReverseColor());
        let isLightWallpaper = this.isLightWallpaper(colorPicker.discriminatePitureLightDegree());
        this.wallpaperReverseColorMap.set(type, reverseColor);
        this.wallpaperLightStateMap.set(type, isLightWallpaper);

        // 回收内存
        // MemoryUtils.removeNapiWrap(colorPicker, false);

        // 回调反色值
        this.reverseColorPromiseMap.get(type)?.forEach((pr) => pr.resolve?.(reverseColor));
        this.reverseColorPromiseMap.delete(type);

        // 回调壁纸深浅色状态
        this.lightStatePromiseMap.get(type)?.forEach((pr) => pr.resolve?.(isLightWallpaper));
        this.lightStatePromiseMap.delete(type);

        log.showInfo('refreshWallpaperColor reverseColor: ' + reverseColor + ', ' + isLightWallpaper + ', ' + type);
      } catch (e) {
        let err = e as BusinessError;
        log.showWarn('refreshWallpaperColor createColorPicker err: ' + err?.message);
      }
    }
  }

  /**
   * 获取当前最新壁纸图
   *
   * @returns 壁纸图
   */
  private getNewCurWallpaperImg(): image.PixelMap | undefined {
    let newImg = this.wallpaperImgMap.get(this.curWallpaperType);
    if (CommonUtils.isInvalid(newImg)) {
      // 默认图使用主题壁纸图
      newImg = this.wallpaperImgMap.get(SLWallpaperType.TYPE_ENGINE_THEME);
      this.updateUsingImmersiveWallPaper(false);
    } else {
      this.updateUsingImmersiveWallPaper(this.curWallpaperType === SLWallpaperType.TYPE_IMMERSIVE_STYLE);
    }

    return newImg;
  }

  private updateUsingImmersiveWallPaper(newStatus: boolean): void {
    slUiStateMgr.getSlState(SlMainStateType.SL_BIND_STATE)?.setSlState(SlBindStateType.IS_USING_IMMERSIVE_WALL_PAPER,
      newStatus);
  }

  /**
   * 是否为浅色壁纸
   *
   * @param lightDegree 浅色度
   * @returns true浅色壁纸
   */
  private isLightWallpaper(lightDegree: effectKit.PictureLightColorDegree): boolean {
    return lightDegree === EXTREMELY_LIGHT_COLOR_PICTURE;
  }

  /**
   * 颜色值转字串
   *
   * @param color 颜色值
   * @returns 字串颜色
   */
  private getColorString(color: effectKit.Color): string {
    let red = this.toNumber16(color?.red);
    let green = this.toNumber16(color?.green);
    let blue = this.toNumber16(color?.blue);
    return `${WallpaperConstants.COLOR_PREFIX}${red}${green}${blue}`;
  }

  /**
   * 颜色值转16进制字串
   *
   * @param color 颜色值
   * @returns 16进制字串
   */
  private toNumber16(color: number): string {
    return color?.toString(WallpaperConstants.NUMBER_16)
      .padStart(WallpaperConstants.NUMBER_2, WallpaperConstants.PREFIX_0);
  }
}

/**
 * 锁屏壁纸状态管理
 */
class ScreenLockWallpaperManager {
  /**
   * 锁屏壁纸状态
   */
  private slWallpaperState: SlWallpaperStateWrapper = new SlWallpaperStateWrapper();

  /**
   * 锁屏壁纸类型与可见场景映射
   */
  private slWallpaperSceneMap: Map<SLWallpaperType, number> = new Map();

  /**
   * 当前是否沉浸态显示
   */
  private isImmersiveWallpaper: boolean = false;

  // 锁屏首页静态状态
  private slStaticState?: ISlState = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE);

  /**
   * 当前是否竖屏状态
   */
  private isPortrait?: boolean;

  /**
   * 是否添加了服务卡片
   */
  private hasFormCard: boolean = false;

  /**
   * 时钟是否展开显示
   */
  private isClockExpand: boolean = true;

  /**
   * 时钟UI状态监听器
   */
  private clockBindStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_CLOCK_WG_BIND_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === ClockBindStateType.HAS_FORM_CARD) {
        this.hasFormCard = slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_BIND_STATE)?.getSlState(
          ClockBindStateType.HAS_FORM_CARD) as boolean;
      }
    }
  };

  /**
   * 时钟静态状态监听器
   */
  private clockStaticStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_CLOCK_WG_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === ClockStaticStateType.IS_CLOCK_EXPAND_STATE) {
        this.isClockExpand = slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE)?.getSlState(
          ClockStaticStateType.IS_CLOCK_EXPAND_STATE) as boolean;
      }
    }
  };

  init(): void {
    slUiStateMgr.registerSlStateChangeListener(this.clockBindStateListener);
    slUiStateMgr.registerSlStateChangeListener(this.clockStaticStateListener);
  }

  release(): void {
    slUiStateMgr.unregisterSlStateChangeListener(this.clockBindStateListener);
    slUiStateMgr.unregisterSlStateChangeListener(this.clockStaticStateListener);
  }

  /**
   * 获取锁屏壁纸状态
   *
   * @returns 锁屏壁纸状态
   */
  getSlWallpaperState(): SLWallpaperState {
    return this.slWallpaperState.slWallpaperState;
  }

  /**
   * 设置锁屏壁纸图片
   *
   * @param type 锁屏壁纸类型
   * @param img 锁屏壁纸图片
   * @param isRecycleOld 是否回收旧图片
   */
  setSlWallpaperImg(type: SLWallpaperType, img?: image.PixelMap, isRecycleOld?: boolean): void {
    this.slWallpaperState.setWallpaperImg(type, img, isRecycleOld);
  }

  /**
   * 进入锁屏壁纸场景
   *
   * @param type 壁纸类型
   * @param scene 场景
   */
  enterSlWallpaperScene(type: SLWallpaperType,
    scene: SLWallpaperVisibleScene = SLWallpaperVisibleScene.SCENE_DEFAULT): void {
    let allScene = this.slWallpaperSceneMap.get(type) ?? 0;
    allScene |= scene;
    this.slWallpaperSceneMap.set(type, allScene);

    // 设置壁纸可见
    if (type === SLWallpaperType.TYPE_IMMERSIVE_STYLE) {
      this.isImmersiveWallpaper = true;
    }

    this.slWallpaperState.setWallpaperVisibility(type, true);
    log.showInfo('enterSlWallpaperScene: ' + type + ', ' + scene);
  }

  /**
   * 退出锁屏壁纸场景
   *
   * @param type 壁纸类型
   * @param scene 场景
   */
  exitSlWallpaperScene(type: SLWallpaperType,
    scene: SLWallpaperVisibleScene = SLWallpaperVisibleScene.SCENE_DEFAULT): void {
    let allScene = this.slWallpaperSceneMap.get(type) ?? 0;
    allScene &= ~Number(scene);
    this.slWallpaperSceneMap.set(type, allScene);

    // 场景清空后，设置壁纸不可见
    if (type === SLWallpaperType.TYPE_IMMERSIVE_STYLE) {
      this.isImmersiveWallpaper = false;
    }
    if (allScene === 0) {
      this.slWallpaperState.setWallpaperVisibility(type);
    }
    log.showInfo('exitSlWallpaperScene: ' + type + ', ' + scene);
  }

  /**
   * 设置锁屏壁纸模糊半径为动效起始值
   */
  setSlWallpaperBlurByAnimStart(): void {
    this.slWallpaperState.setBlurByAnimStart();
  }

  /**
   * 设置锁屏壁纸模糊半径为动效结束值
   */
  setSlWallpaperBlurByAnimEnd(): void {
    this.slWallpaperState.setBlurByAnimEnd();
  }

  /**
   * 设置壁纸透明度
   */
  setSlWallpaperAlpha(alpha: number = 1): void {
    this.slWallpaperState.slWallpaperState.alpha = alpha;
  }

  setSlWallpaperSaturate(saturate: number = 1): void {
    this.slWallpaperState.slWallpaperState.saturate = saturate;
  }

  public setPortrait(isPortrait: boolean): void {
    this.isPortrait = isPortrait;
  }

  /**
   * 得到当前主题场景
   */
  public getCurrentThemeScene(): ThemeScene {
    if (DeviceHelper.isPadOr2in1PcType()) {
      if (this.isPortrait) {
        return ThemeScene.BASE;
      } else {
        return ThemeScene.LAND;
      }
    } else if (DeviceHelper.isLargeInFoldProduct()) {
      if (this.slStaticState?.getSlState(SlStaticStateType.FOLD_EXPAND_STATE) as boolean) {
        if (this.isPortrait) {
          return ThemeScene.UNFOLDED;
        } else {
          return ThemeScene.LAND_UNFOLDED;
        }
      } else {
        return ThemeScene.BASE;
      }
    } else if (DeviceHelper.isUltraScreenGPortrait()) {
      if (DeviceHelper.isMState()) {
        if (this.isPortrait) {
          return ThemeScene.UNFOLDED;
        } else {
          return ThemeScene.LAND_UNFOLDED;
        }
      } else if (DeviceHelper.isGState()) {
        if (this.isPortrait) {
          return ThemeScene.UNFOLDED2;
        } else {
          return ThemeScene.LAND_UNFOLDED2;
        }
      }
    }
    return ThemeScene.BASE;
  }

  /**
   * 获取当前主题新形态小折叠vde景深场景
   */
  private getSmallFoldThemeScene(): ThemeScene {
    let screenBreakPoint = this.slStaticState?.getSlState(SlStaticStateType.SCREEN_BP) as ScreenBp;
    if (screenBreakPoint?.widthBp === SizeBp.SM && screenBreakPoint?.heightBp === SizeBp.MD) {
      log.showInfo(`CurrentThemeScene is vde fold`);
      return ThemeScene.SMALL_FOLD;
    }
    return ThemeScene.BASE;
  }
}

// 单例
export let slWallpaperMgr: ScreenLockWallpaperManager = SingletonHelper.getInstance(ScreenLockWallpaperManager, TAG);