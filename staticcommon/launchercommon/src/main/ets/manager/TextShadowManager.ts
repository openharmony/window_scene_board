/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
  DeviceHelper,
  GlobalContext,
  ViewManagerPolicy,
  ViewType,
  WallpaperChangeListener,
  WallpaperManager,
  WallpaperType,
} from '@ohos/frameworkwrapper';
import { ItemUtils } from '@ohos/componenthelper';
// import { CheckEmptyUtils, LogDomain, LogHelper, Trace, SingletonHelper, MemoryUtils } from '@ohos/basicutils';
import { CheckEmptyUtils, LogDomain, LogHelper, Trace, SingletonHelper } from '@ohos/basicutils';
import { StyleConstants } from '../constants/StyleConstants';
import { ColorUtil } from '../utils/ColorUtil';
import { DeviceState } from '../constants/CommonConstants';
import type image from '@ohos.multimedia.image';
import effectKit from '@ohos.effectKit';
import ComponentPosShadowCache from '../cache/ComponentPosShadowCache';
import { ThemeActivationEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import { preferences } from '@kit.ArkData';
import { LaunchLayoutCacheManager, LayoutDescription } from '../TsIndex';
import { CommonConstants } from '../constants/CommonConstants';
import type ctx from '@ohos.app.ability.common';
import { componentUtils, display } from '@kit.ArkUI';

const TAG = 'TextShadowManager';
const DEFAULT_COLOR_COMPONENT = 255;
const SNAP_WALLPAPER_TIMEOUT = 500;
const SNAP_WALLPAPER_MAX_TRY_COUNT = 3;
const IS_LOAD_NEXT_FROM_PREFERENCE = 'isCanNextLoadFromSp';
const NEXT_TEXT_SHADOW_LIST = 'nextTextShadowList';
const CONTRAST2WHITE_LOW: number = 1.2;
const CONTRAST2WHITE_HIGH: number = 1.5;
const DIVIDE_TWO: number = 2.0;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class TextShadowManager {
  private tryCount: number = 0;
  private isCanLoadSinglePage: boolean | undefined = undefined;
  private isCanLoadLeftPage: boolean | undefined = undefined;
  private isCanLoadRightPage: boolean | undefined = undefined;

  private wallPaperListener: WallpaperChangeListener = {
    registeredTag: TAG,
    listenerType: WallpaperType.ALL,
    onWallPaperChange: (event: ThemeActivationEvent) => {
      log.showInfo('WallpaperColorManager WallPaper Change');
      ComponentPosShadowCache.getInstance().clearCache();
      this.resetLoadShadowStatus();
      this.tryUpdateWallpaper(true, true);
    }
  };

  constructor() {
    // 文字阴影仅针对非PC场景
    if (DeviceHelper.isPC()) {
      return;
    }
    WallpaperManager.getInstance().addWallpaperChangeListener(this.wallPaperListener);
  }

  /**
   * 生成文字阴影
   *
   * @param info AppItemTextShadowInfo
   * @param shadowKey the key to cache the textShadow
   * @returns color of text shadow;
   */
  public async generateShadow(info: AppItemTextShadowInfo, shadowKey: string, snap: image.PixelMap):
    Promise<string | undefined> {
    if (await this.isLoadFromPreference()) {
      log.showWarn('not need to generateShadow as isLoadFromPreference');
      return undefined;
    }
    if (info.screenWidth <= info.startOffsetX || info.screenHeight <= info.startOffsetY) {
      log.showError(`the screen width is error screenWidth ${info.screenWidth} screenHeight ${info.screenHeight}`);
      return undefined;
    }
    let resColorShadow: string | undefined = undefined;
    let colorPickerWidth = info.nameWidth;
    let colorPickerX = info.startOffsetX;
    let colorPickerRegion: Array<number> = [colorPickerX / info.screenWidth, info.startOffsetY / info.screenHeight,
      (colorPickerX + colorPickerWidth) / info.screenWidth, (info.startOffsetY + info.nameHeight) / info.screenHeight];
    await this.getShadowColor(snap, colorPickerRegion).then((colorShadow: string | undefined) => {
      if (colorShadow !== undefined) {
        log.showInfo(`caching the TextShadow color ${colorShadow}, key ${shadowKey}`);
        ComponentPosShadowCache.getInstance().setCache(shadowKey, colorShadow);
      }
      resColorShadow = colorShadow;
    }).catch((error: Error) => {
      log.showInfo(`generateShadow error with msg ${error?.message}`);
    });
    return resColorShadow;
  }

  /**
   * 从背景图上按区域取出背景颜色
   *
   * @param snap 背景图
   * @param colorPickerRegion 取色的区域
   */
  public async getShadowColor(snap: image.PixelMap, colorPickerRegion: Array<number>): Promise<string | undefined> {
    let resultColor: string | undefined = undefined;
    let cPicker: effectKit.ColorPicker | undefined = undefined;
    await effectKit.createColorPicker(snap, colorPickerRegion).then((colorPicker) => {
      cPicker = colorPicker;
      let alpha: number = 0;
      let color = colorPicker.getLargestProportionColor();
      if (!color) {
        log.showError('generateShadow, get largest proportion color failed.');
        return undefined;
      }
      let backgroundLuminance = ColorUtil.rgb2Luminance(color.red, color.green, color.blue);
      let contrast2White = ColorUtil.contrast2White(backgroundLuminance);
      if (contrast2White >= CONTRAST2WHITE_LOW && contrast2White <= CONTRAST2WHITE_HIGH) {
        alpha = StyleConstants.APP_NAME_SHADOW_PERCENT_LOWER;
      } else {
        alpha = ColorUtil.rgb2ShadowAlpha(color.red, color.green, color.blue);
      }
      log.showInfo('generateShadow, average red:%{public}d green:%{public}d blue:%{public}d alpha:%{public}d',
        color.red, color.green, color.blue, alpha);
      resultColor = ColorUtil.convertRGBA2ResourceColor(5, 5, 5, Math.ceil(((alpha < 0 || alpha >= 1) ? 0 : alpha) * DEFAULT_COLOR_COMPONENT));
      return resultColor;
    }).catch((error: Error) => {
      log.showInfo(`generate the text shadow error ${error?.message}`);
      resultColor = undefined;
    }).finally(() => {
      // MemoryUtils.removeNapiWrap(cPicker, false);
    });
    return resultColor;
  }

  /**
   * 尝试获取桌面壁纸组件的截图
   * 时机: 1、解锁; 2、替换壁纸; 3、获取桌面壁纸失败的时候
   *
   * @param isForce 是否强制更新
   */
  public tryUpdateWallpaper(isForce: boolean = false, isNeedDelay: boolean): void {
    if (!isForce) {
      log.showInfo('tryUpdateWallpaper desktopImageSnapshot is Exist, return');
      return;
    }
    log.showInfo('tryUpdateWallpaper isForce: %{public}s, tryCount: %{public}d', isForce, this.tryCount);
    let delayTime = isNeedDelay ? SNAP_WALLPAPER_TIMEOUT : 0;
    setTimeout(() => {
      this.handleDesktopWallpaperChange(isForce);
    }, delayTime);
  }

  public async handleDesktopWallpaperChange(isNewWallPaper: boolean = false): Promise<void> {
    let isNewStyle: boolean = AppStorage.get<boolean>('desktopNewStyle') ?? true;
    let desktopTextShadow: boolean = AppStorage.get<boolean>('desktopTextShadow') ?? true;
    if (!(isNewStyle && desktopTextShadow)) {
      return;
    }

    let isLoadFromSp: boolean = await textShadowMgr.isLoadFromPreference();
    if (isLoadFromSp) {
      log.showWarn('handleDesktopWallpaperChange load from preference');
      if (!AppStorage.Has('wallpaperSnapshotChangeFlag')) {
        AppStorage.setOrCreate<boolean>('wallpaperSnapshotChangeFlag', false);
      } else {
        let wallpaperSnapshotChangeFlag = AppStorage.get<boolean>('wallpaperSnapshotChangeFlag');
        AppStorage.setOrCreate('wallpaperSnapshotChangeFlag', !wallpaperSnapshotChangeFlag);
      }
      return;
    }
    if (ViewManagerPolicy.getViewController(ViewType.KEYGUARD)?.isShowing()) {
      log.showInfo('No screenshot is taken when the screen is locked.');
      return;
    }
    log.showInfo('start create snapshot.');
    Trace.start('handleDesktopWallpaperChange');
    this.getWallPaperSnap().then(pixmap => {
      if (CheckEmptyUtils.isEmpty(pixmap)) {
        log.error('handleDesktopWallpaperChange create wallpaperSnap failed');
        if (this.tryCount < SNAP_WALLPAPER_MAX_TRY_COUNT) {
          this.tryCount++;
          this.tryUpdateWallpaper(false, true);
        } else {
          log.showError('handleDesktopWallpaperChange componentSnapshot fail, not try again');
        }
        return;
      }
      this.updateDesktopWallpaperPixmap(pixmap, isNewWallPaper);
    });
    Trace.end('handleDesktopWallpaperChange');
  }

  private async getWallPaperSnap(): Promise<image.PixelMap> {
    let wallPaper: image.PixelMap = await WallpaperManager.getInstance().getWallpaperCache(WallpaperType.DESKTOP, TAG);
    return wallPaper;
  }

  private updateDesktopWallpaperPixmap(pixmap: image.PixelMap, isNewWallPaper: boolean): void {
    this.tryCount = 0;
    try {
      effectKit.createColorPicker(pixmap).then(colorPicker => {
        let degree = colorPicker.discriminatePitureLightDegree();
        log.showInfo('handleDesktopWallpaperChange degree: %{public}d', degree);
        // MemoryUtils.removeNapiWrap(colorPicker, false);
      }).catch((error: Error) => {
        log.showError('createColorPicker with error %{public}s', error.message);
      });
    } catch (error) {
      log.showError('updateDesktopWallpaperPixmap with error %{public}s', error.message);
    }
    if (!AppStorage.has('wallpaperSnapshotChangeFlag')) {
      AppStorage.setOrCreate<boolean>('wallpaperSnapshotChangeFlag', false);
    } else {
      let wallpaperSnapshotChangeFlag = AppStorage.get<boolean>('wallpaperSnapshotChangeFlag');
      AppStorage.setOrCreate('wallpaperSnapshotChangeFlag', !wallpaperSnapshotChangeFlag);
    }
    log.showInfo('finish create snapshot.');
  }

  public resetLoadShadowStatus(): void {
    this.isCanLoadSinglePage = false;
    this.isCanLoadLeftPage = false;
    this.isCanLoadRightPage = false;
    let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
    try {
      preferences.getPreferences(context, 'TextShadowData').then((preference) => {
        preference.put(`${IS_LOAD_NEXT_FROM_PREFERENCE}_${TextShadowScreenType.SINGLE_PAGE}`, this.isCanLoadSinglePage);
        preference.put(`${IS_LOAD_NEXT_FROM_PREFERENCE}_${TextShadowScreenType.DOUBLE_LEFT_PAGE}`, this.isCanLoadLeftPage);
        preference.put(`${IS_LOAD_NEXT_FROM_PREFERENCE}_${TextShadowScreenType.DOUBLE_RIGHT_PAGE}`, this.isCanLoadRightPage);
        preference.flush().then((res) => {
          log.showInfo(TAG, `save restore data to sp success: ${res}`);
        }).catch((reject) => {
          log.showInfo(TAG, 'save restore data to sp fail: %{public}s', reject);
        });
      }).catch((error: Error) => {
        log.showInfo('setCanLoadFromSp error with message %{public}s', error.message);
      });
    } catch (error) {
      log.showError('getPreferencesSync with error %{public}s', error.message);
    }
  }

  /**
   * 更新isLoadFromSp状态
   *
   * @param isLoadFromSp true可以从sp更新
   * @param isLeftPage 是否是左半屏
   * @param isRightPage 是否是右半屏
   */
  public setCanLoadFromSp(isLoadFromSp: boolean, isLeftPage: boolean, isSinglePage: boolean): void {
    this.updateShadowLoadStatus(isLoadFromSp, isLeftPage, isSinglePage);
    let textShadowScreen: number = isSinglePage ? TextShadowScreenType.SINGLE_PAGE :
      (isLeftPage ? TextShadowScreenType.DOUBLE_LEFT_PAGE : TextShadowScreenType.DOUBLE_RIGHT_PAGE);
    let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
    try {
      preferences.getPreferences(context, 'TextShadowData').then((preference) => {
        preference.put(`${IS_LOAD_NEXT_FROM_PREFERENCE}_${textShadowScreen}`, isLoadFromSp);
        preference.flush().then((res) => {
          log.showInfo(TAG, `save restore data to sp success: ${res}`);
        }).catch((reject) => {
          log.showInfo(TAG, 'save restore data to sp fail: %{public}s', reject);
        });
      }).catch((error: Error) => {
        log.showInfo('setCanLoadFromSp error with message %{public}s', error.message);
      });
    } catch (error) {
      log.showError('getPreferences with error %{public}s', error.message);
    }
  }

  private updateShadowLoadStatus(isLoadFromSp: boolean, isLeftPage: boolean, isSinglePage: boolean): void {
    if (isSinglePage) {
      this.isCanLoadSinglePage = isLoadFromSp;
    } else {
      if (isLeftPage) {
        this.isCanLoadLeftPage = isLoadFromSp;
      } else {
        this.isCanLoadRightPage = isLoadFromSp;
      }
    }
  }

  /**
   * 返回是否可以从preference加载textShadow
   */
  public getIsCanLoadFromPreference(folderStatus: number): boolean {
    if (folderStatus === DeviceState.EXPAND_STATE) {
      return (this.isCanLoadLeftPage && this.isCanLoadRightPage) ?? false;
    }
    return this.isCanLoadSinglePage ?? false;
  }

  /**
   * 是否从preference中加载文字阴影
   *
   * @returns true 从preference中加载
   */
  public async isLoadFromPreference(): Promise<boolean> {
    let result: boolean = false;
    if (DeviceHelper.isFoldExpanded()) {
      result = await this.getDoublePageLoadFromPreference();
    } else {
      result = await this.getSinglePageLoadFromPreference();
    }
    return result;
  }

  private async getSinglePageLoadFromPreference(): Promise<boolean> {
    if (this.isCanLoadSinglePage === undefined) {
      let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
      try {
        await preferences.getPreferences(context, 'TextShadowData').then((preference) => {
          this.isCanLoadSinglePage = preference.getSync(`${IS_LOAD_NEXT_FROM_PREFERENCE}_${TextShadowScreenType.SINGLE_PAGE}`, false) as boolean;
        }).catch((error: Error) => {
          log.showInfo('getSinglePageLoadFromPreference error with message %{public}s', error.message);
          this.isCanLoadSinglePage = false;
        });
      } catch (error) {
        log.showError('getPreferences with error %{public}s', error.message);
      }
    }
    return this.isCanLoadSinglePage ?? false;
  }

  private async getDoublePageLoadFromPreference(): Promise<boolean> {
    if (this.isCanLoadLeftPage === undefined || this.isCanLoadRightPage === undefined) {
      let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
      try {
        await preferences.getPreferences(context, 'TextShadowData').then((preference) => {
          this.isCanLoadLeftPage = preference.getSync(`${IS_LOAD_NEXT_FROM_PREFERENCE}_${TextShadowScreenType.DOUBLE_LEFT_PAGE}`, false) as boolean;
          this.isCanLoadRightPage = preference.getSync(`${IS_LOAD_NEXT_FROM_PREFERENCE}_${TextShadowScreenType.DOUBLE_RIGHT_PAGE}`, false) as boolean;
        }).catch((error: Error) => {
          this.isCanLoadLeftPage = false;
          this.isCanLoadRightPage = false;
          log.showInfo('getDoublePageLoadFromPreference error with message %{public}s', error.message);
        });
      } catch (error) {
        log.showError('getPreferences with error %{public}s', error.message);
      }
    }
    return (this.isCanLoadLeftPage && this.isCanLoadRightPage) ?? false;
  }

  /**
   * 从SP解析文字阴影
   *
   * @returns true 解析成功
   */
  public async parseTextShadowPreference(isLeftPage: boolean, isSinglePage: boolean): Promise<boolean> {
    log.showInfo('load textShadow from sp');
    let textShadowList: string[] = [];
    let textShadowScreen: number = isSinglePage ? TextShadowScreenType.SINGLE_PAGE :
      (isLeftPage ? TextShadowScreenType.DOUBLE_LEFT_PAGE : TextShadowScreenType.DOUBLE_RIGHT_PAGE);
    let isLoadFromSp: boolean = true;
    let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
    try {
      await preferences.getPreferences(context, 'TextShadowData').then((preference) => {
        textShadowList = preference.getSync(this.getShadowPreference(textShadowScreen), []) as string[];
      }).catch((error: Error) => {
        log.showInfo('get TextShadowData from preference error %{public}s', error.message);
        isLoadFromSp = false;
      });
    } catch (error) {
      log.showError('getPreferences with error %{public}s', error.message);
    }
    let layoutDescription: LayoutDescription = LaunchLayoutCacheManager.getInstance().selectLayoutDescription();
    let maxRow: number = layoutDescription.row;
    let maxColumn: number = layoutDescription.column * StyleConstants.DEFAULT_2 - 1;
    if (maxRow * maxColumn !== textShadowList.length || CheckEmptyUtils.isEmpty(textShadowList)) {
      log.showInfo('parseTextShadowPreference error as the length of textShadowList is error');
      isLoadFromSp = false;
    }
    if (!isLoadFromSp) {
      this.setCanLoadFromSp(isLoadFromSp, isLeftPage, isSinglePage);
      return false;
    }
    let shadowIndex: number = 0;
    let page: number = this.getTextShadowScreenType(isSinglePage, isLeftPage);
    for (let i = 0; i < maxRow; i++) {
      for (let j = 0; j < maxColumn; j++) {
        if (shadowIndex < textShadowList.length) {
          ComponentPosShadowCache.getInstance().setCache(this.generateShadowKey(page, i, j), textShadowList[shadowIndex]);
        }
        shadowIndex++;
      }
    }
    return true;
  }

  /**
   * 存储文字阴影到sp
   */
  public async storeTextShadowPreference(isLeftPage: boolean, isSinglePage: boolean): Promise<void> {
    let textShadowList: string[] = [];
    let isLoadFinished: boolean = this.checkAndGetAllTextShadows(textShadowList, isLeftPage, isSinglePage);
    let textShadowScreen: number = isSinglePage ? TextShadowScreenType.SINGLE_PAGE :
      (isLeftPage ? TextShadowScreenType.DOUBLE_LEFT_PAGE : TextShadowScreenType.DOUBLE_RIGHT_PAGE);
    if (!isLoadFinished || CheckEmptyUtils.isEmptyArr(textShadowList)) {
      log.showError(`isLoadFinished false or textShadowList is empty!`);
      return;
    }
    let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
    try {
      await preferences.getPreferences(context, 'TextShadowData').then((preference) => {
        preference.putSync(this.getShadowPreference(textShadowScreen), textShadowList);
        preference.flush().then((res) => {
          log.showInfo(TAG, `save restore data to sp success: ${res}`);
        }).catch((reject) => {
          log.showInfo(TAG, 'save restore data to sp fail: %{public}s', reject);
        });
        this.setCanLoadFromSp(true, isLeftPage, isSinglePage);
        log.showInfo('storeTextShadowPreference success');
      }).catch((error: Error) => {
        log.showWarn('failed to storeTextShadowPreference error %{public}s', error.message);
        this.setCanLoadFromSp(false, isLeftPage, isSinglePage);
      });
    } catch (error) {
      log.showError('getPreferences with error %{public}s', error.message);
    }
  }

  private getShadowPreference(textShadowScreenType: number): string {
    return `${NEXT_TEXT_SHADOW_LIST}_${textShadowScreenType}`;
  }

  private checkAndGetAllTextShadows(textShadowList: string[], isLeftPage: boolean, isSinglePage: boolean): boolean {
    let layoutDescription: LayoutDescription = LaunchLayoutCacheManager.getInstance().selectLayoutDescription();
    let maxRow: number = layoutDescription.row;
    let maxColumn: number = layoutDescription.column * StyleConstants.DEFAULT_2 - 1;
    let page: number = this.getTextShadowScreenType(isSinglePage, isLeftPage);
    for (let i = 0; i < maxRow; i++) {
      for (let j = 0; j < maxColumn; j++) {
        let shadowColor: string = ComponentPosShadowCache.getInstance().getCache(this.generateShadowKey(page, i, j));
        if (shadowColor === CommonConstants.INVALID_VALUE.toString()) {
          return false;
        } else {
          textShadowList.push(shadowColor);
        }
      }
    }
    return true;
  }

  /**
   * 预加载文字阴影缓存
   *
   * @param info AppItemTextShadowInfo
   * @param gridItemWidth gridItemWidth
   * @param gridItemHeight gridItemHeight
   * @returns
   */
  private async traversalToCacheTextShadow(index: number, isSinglePage: boolean, isLeftPage: boolean,
    desktopStyleConfig: DesktopStyleConfig): Promise<void> {
    let info: AppItemTextShadowInfo | null =
      await this.getTextShadowInfo(index, isSinglePage, isLeftPage, desktopStyleConfig);
    if (!info) {
      return;
    }
    let startOffsetX: number = info.startOffsetX;
    let startOffsetY: number = info.startOffsetY;
    let maxRow: number = info.maxRow;
    let maxCol: number = info.maxCol * StyleConstants.DEFAULT_2 - 1;
    let snap: image.PixelMap = await this.getWallPaperSnap();
    for (let i = 0; i < maxRow; i++) {
      for (let j = 0; j < maxCol; j++) {
        let shadowKey: string = this.generateShadowKey(info.textShadowScreenType ?? 0, i, j);
        if (ComponentPosShadowCache.getInstance().getCache(shadowKey) !== CommonConstants.INVALID_VALUE.toString()) {
          log.showInfo('the test shadow of key %{public}s is exit', shadowKey);
          continue;
        }
        info.startOffsetX = startOffsetX + j * (desktopStyleConfig.gridItemWidth / StyleConstants.DEFAULT_2);
        info.startOffsetY = startOffsetY + i * desktopStyleConfig.gridItemHeight;
        if (snap) {
          await this.generateShadow(info, shadowKey, snap);
        }
      }
    }
    this.storeTextShadowPreference(info.isLeftPage ?? true, info.isSinglePage ?? true);
  }

  public generateShadowKey(pageIndex: number, rowTrans: number, columnTrans: number): string {
    return `${pageIndex}_${rowTrans}_${columnTrans}`;
  }

  public getTextShadowScreenType(isSinglePage: boolean, isLeftPage: boolean): number {
    return isSinglePage ? TextShadowScreenType.SINGLE_PAGE :
      (isLeftPage ? TextShadowScreenType.DOUBLE_LEFT_PAGE : TextShadowScreenType.DOUBLE_RIGHT_PAGE);
  }

  public async startToCacheShadow(folderStatus: number, mainPageIndex: number, desktopStyleConfig: DesktopStyleConfig): Promise<void> {
    if (folderStatus === DeviceState.EXPAND_STATE) {
      let subpageIndex = mainPageIndex % 2 === 0 ? mainPageIndex + 1 : mainPageIndex - 1;
      await this.traversalToCacheTextShadow(mainPageIndex, false, (mainPageIndex % 2 === 0), desktopStyleConfig);
      await this.traversalToCacheTextShadow(subpageIndex, false, (subpageIndex % 2 === 0), desktopStyleConfig);
    } else {
      await this.traversalToCacheTextShadow(mainPageIndex, true, true, desktopStyleConfig);
    }
  }

  private async getTextShadowInfo(index: number, isSinglePage: boolean, isLeftPage: boolean,
    desktopStyleConfig: DesktopStyleConfig): Promise<AppItemTextShadowInfo | null> {
    let offsetOfScreen: componentUtils.Offset = ItemUtils.getOffsetRelativeScreenById(CommonConstants
      .SWIPER_GRID_WORKSPACE_TAG + index);
    if (CheckEmptyUtils.isEmpty(offsetOfScreen)) {
      log.showWarn('generate the TextShadow error for page %{public}d', index);
      return null;
    }
    let offsetX: number = px2vp(offsetOfScreen.x);
    let offsetY: number = px2vp(offsetOfScreen.y) + desktopStyleConfig.iconSize + desktopStyleConfig.itemPadding +
    desktopStyleConfig.iconNameMarginTop;
    let textShadowScreenType: number = textShadowMgr.getTextShadowScreenType(isSinglePage, isLeftPage);
    let info : AppItemTextShadowInfo = {
      startOffsetX: offsetX,
      startOffsetY: offsetY,
      maxRow: desktopStyleConfig.row,
      maxCol: desktopStyleConfig.col,
      nameWidth: desktopStyleConfig.nameWidth,
      nameHeight: desktopStyleConfig.nameHeight,
      screenWidth: 0,
      screenHeight: 0,
      textShadowScreenType: textShadowScreenType,
      isSinglePage: isSinglePage,
      isLeftPage: isLeftPage
    };
    await this.completeAppTextShadowInfo(info, isSinglePage);
    return info;
  }

  private async completeAppTextShadowInfo(info: AppItemTextShadowInfo, isSinglePage: boolean): Promise<void> {
    // 初始化屏幕信息
    let screenInfo: display.Display | undefined = undefined;
    try {
      screenInfo = display.getDefaultDisplaySync();
    } catch (error) {
      log.showError('get screenInfo with error %{public}s', error.message);
    }
    if (!screenInfo) {
      log.showError('completeAppTextShadowInfo screenInfo is undefined');
      return;
    }
    const screenWidth: number = px2vp(screenInfo.width);
    const screenHeight: number = px2vp(screenInfo.height);
    info.screenWidth = screenWidth;
    info.screenHeight = screenHeight;
    if (!DeviceHelper.isFold()) {
      return;
    }
    let image: image.PixelMap | null = null;
    try {
      image = await this.getWallPaperSnap();
      let imageInfo = image.getImageInfoSync();
      let imageWidth: number = px2vp(imageInfo.size.width);
      let imageHeight: number = px2vp(imageInfo.size.height);
      if (imageWidth === 0) {
        log.showError('getWallPaperSnap error with imageWidth zero');
        return;
      }
      if (isSinglePage) {
        info.startOffsetX += (imageWidth - screenWidth) / DIVIDE_TWO;
        info.screenWidth = imageWidth;
      } else {
        let ratio: number = screenWidth / imageWidth;
        imageHeight = imageHeight * ratio;
        info.screenHeight = imageHeight;
        info.nameHeight = info.nameHeight * ratio;
        info.startOffsetY += (imageHeight - screenHeight) / DIVIDE_TWO;
      }
    } catch (err) {
      log.showError('completeAppTextShadowInfo error with %{public}s', err.message);
    }
  }

  public async startToParseShadow(folderStatus: number, mainPageIndex: number): Promise<boolean> {
    if (folderStatus === DeviceState.EXPAND_STATE) {
      let subpageIndex = mainPageIndex % 2 === 0 ? mainPageIndex + 1 : mainPageIndex - 1;
      let loadMainPage: boolean = await this.parseTextShadowPreference((mainPageIndex % 2 === 0), false);
      let loadSubPage: boolean = await this.parseTextShadowPreference((subpageIndex % 2 === 0), false);
      return loadMainPage && loadSubPage;
    } else {
      return await this.parseTextShadowPreference(true, true);
    }
  }
}

export interface DesktopStyleConfig {
  iconSize: number,
  itemPadding: number,
  iconNameMarginTop: number,
  row: number,
  col: number,
  nameWidth: number,
  nameHeight: number,
  gridItemWidth: number,
  gridItemHeight: number
}

/**
 * 文字阴影信息
 */
export interface AppItemTextShadowInfo {
  startOffsetX: number,
  startOffsetY: number,
  maxRow: number,
  maxCol: number,
  nameWidth: number,
  nameHeight: number,
  screenWidth: number,
  screenHeight: number,
  textShadowScreenType?: number,
  isSinglePage?: boolean,
  isLeftPage?: boolean
}

enum TextShadowScreenType {
  SINGLE_PAGE = 0,
  DOUBLE_LEFT_PAGE = 1,
  DOUBLE_RIGHT_PAGE = 2,
}

// 单例
export let textShadowMgr: TextShadowManager = SingletonHelper.getInstance(TextShadowManager, TAG);
