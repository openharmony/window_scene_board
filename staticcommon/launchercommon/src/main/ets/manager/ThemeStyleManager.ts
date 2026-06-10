/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { FileUtils, LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import {
  EvtBus,
  AccountEvent,
  AccountMgr,
  DeviceHelper,
  onLineThemeUtil
} from '@ohos/frameworkwrapper';
import { ThemeStyleInfo } from '../bean/ThemeStyleInfo';
import commonEventManager from '@ohos.commonEventManager';
import ThemeHelperUtil from './ThemeHelperUtil';
import { RdbStoreManager } from '../TsIndex';

const TAG = 'ThemeStyleManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const THEME_FLAG_PATH_A: string = '/data/themes/a/app/flag';
const THEME_FLAG_PATH_B: string = '/data/themes/b/app/flag';
const THEME_CONFIG_PATH_A: string = '/data/themes/a/system/home/base/home_style_config.json';
const THEME_CONFIG_PATH_B: string = '/data/themes/b/system/home/base/home_style_config.json';
const THEME_ICON_DESC_PATH_A: string = '/data/themes/a/app/icons/description.json';
const THEME_ICON_DESC_PATH_B: string = '/data/themes/b/app/icons/description.json';
const THEME_ICON_MANIFEST_PATH_A: string = '/data/themes/a/app/icons/manifest.json';
const THEME_ICON_MANIFEST_PATH_B: string = '/data/themes/b/app/icons/manifest.json';
const THEME_STYLE: string = 'ThemeStyle';
const THEME_FLAG_A: string = 'ThemeFlagA';
const THEME_FLAG_B: string = 'ThemeFlagB';
const ACTIVATE_THEME_FLAG: number = 1;
const DEFAULT_USERID: number = 100;
const MAX_THEME_INDEX = 100;
const MAX_ICON_SCALE_SIZE: number = 8;
const MIN_ICON_SCALE_SIZE: number = -6;

/**
 * Theme style call back
 */
export interface ThemeStyleCallback {
  onStyleChanged?(isIconActive: boolean): void;
}

/**
 * 图标所属的主题id, origin
 */
export interface ThemeIconDesc {
  id: string;
  origin: string;
}

/**
 * 图标所属的风格配置项
 */
export interface ThemeIconManifest {
  onlineStyle: string;
}

/**
 * Theme style config manager.
 */
export class ThemeStyleManager {
  private static mInstance: ThemeStyleManager;
  private themeStyle: ThemeStyleInfo = new ThemeStyleInfo();
  private mSubscriber?: commonEventManager.CommonEventSubscriber;
  private index: number = 0;
  private isStyleChanged: boolean = false;
  private lastThemeStyle: ThemeStyleInfo = new ThemeStyleInfo();
  private themeCallback?: ThemeStyleCallback;
  private userId: number = DEFAULT_USERID;
  private isWallpaperTouchable: boolean = false;
  // 收到主题变更通知后设置主题已改变，在资源挂载完成SCBDesktop收到onConfigChange回调后，
  // 判断主题改变时刷新桌面组件并重置属性，避免主题圆角未更新
  private _isStyleChangedFromThemeEvent: boolean = false;

  public set isStyleChangedFromThemeEvent(value: boolean) {
    this._isStyleChangedFromThemeEvent = value;
  }

  public get isStyleChangedFromThemeEvent(): boolean {
    return this._isStyleChangedFromThemeEvent;
  }

  public getIsWallpaperTouchable(): boolean {
    return this.isWallpaperTouchable;
  }
  /**
   * 刷新壁纸是否可以支持交互
   *
   * @param isTouchable 是否touch事件
   */
  public updateWallpaperTouchable(isTouchable: boolean): void {
    this.isWallpaperTouchable = isTouchable;
  }
  /**
   * Get instance of ThemeStyleManager.
   *
   * @returns instance
   */
  public static getInstance(): ThemeStyleManager {
    if (!ThemeStyleManager.mInstance) {
      ThemeStyleManager.mInstance = new ThemeStyleManager();
      ThemeStyleManager.mInstance.loadThemeStyle();
    }
    return ThemeStyleManager.mInstance;
  }

  private constructor() {
    EvtBus.on(AccountEvent, (event) => {
      if (AccountMgr.isInvalidAccount(event?.accountInfo?.localId)) {
        log.showInfo('setCurrentUserId user id err');
        return;
      }
      this.userId = event?.accountInfo?.localId;
      log.showInfo('user change to %{public}d', this.userId);
    });
    this.updateHomeManifest();
    this.setIconThemeInfo();
  }

  /**
   * 设置图标的主题状态, 包含是否是在线主题或者预制主题以及是否为在线主题风格
   */
  public setIconThemeInfo(): void {
    this.setIconThemeOrigin();
    this.setIconThemeStyle();
  }

  /**
   * 设置图标的主题状态是否是在线主题或者预制主题
   */
  private setIconThemeOrigin(): void {
    let iconThemeDesc = this.getCurrentIconThemePath();
    try {
      if (!FileUtils.isExist(iconThemeDesc)) {
        log.showWarn('get isPandoraTheme failed: current theme has no description and manifest.');
        return;
      }
      let themeInfo: ThemeIconDesc = FileUtils.readJsonFile(iconThemeDesc);
      let themeId = themeInfo?.id ?? '';
      let themeOrigin = themeInfo?.origin ?? '';
      log.showInfo(`getCurrentThemeInfo themeId ${themeId} themeOrigin ${themeOrigin}`);
      onLineThemeUtil.setThemeOrigin(themeOrigin);
      onLineThemeUtil.setThemeId(themeId);
    } catch (err) {
      log.showError(`get isPandoraTheme failed: ${err}`);
    }
  }

  private getCurrentIconThemePath(): string {
    if (FileUtils.isExist(THEME_FLAG_PATH_A)) {
      return FileUtils.isExist(THEME_ICON_DESC_PATH_A) ? THEME_ICON_DESC_PATH_A : THEME_ICON_MANIFEST_PATH_A;
    } else if (FileUtils.isExist(THEME_FLAG_PATH_B)) {
      return FileUtils.isExist(THEME_ICON_DESC_PATH_B) ? THEME_ICON_DESC_PATH_B : THEME_ICON_MANIFEST_PATH_B;
    }
    return '';
  }

  /**
   * 设置图标是否为在线主题风格
   */
  private setIconThemeStyle(): void {
    let iconThemeManifest = this.getCurrentIconManifestPath();
    try {
      if (!FileUtils.isExist(iconThemeManifest)) {
        log.showWarn('get iconThemeManifest failed: current theme has no manifest.');
        return;
      }
      let themeInfoManifest: ThemeIconManifest = FileUtils.readJsonFile(iconThemeManifest);
      let themeOnlineStyle: string = themeInfoManifest?.onlineStyle ?? '';
      log.showInfo(`getCurrentThemeInfo themeStyle ${themeOnlineStyle}`);
      onLineThemeUtil.setThemeOnlineStyle(themeOnlineStyle);
    } catch (err) {
      log.showError(`get iconThemeManifest failed: ${err}`);
    }
  }

  private getCurrentIconManifestPath(): string {
    if (FileUtils.isExist(THEME_FLAG_PATH_A)) {
      return THEME_ICON_MANIFEST_PATH_A;
    } else if (FileUtils.isExist(THEME_FLAG_PATH_B)) {
      return THEME_ICON_MANIFEST_PATH_B;
    }
    return '';
  }

  /**
   * Load theme style config file.
   *
   * @returns theme style name.
   */
  public loadThemeStyle(isStyleChanged?: boolean): string {
    if (this.index >= MAX_THEME_INDEX) {
      this.index = 0;
    }

    this.isStyleChanged = false;
    if (FileUtils.isExist(THEME_FLAG_PATH_A)) {
      if (FileUtils.isExist(THEME_CONFIG_PATH_A)) {
        log.showDebug('Current theme config path is THEME_CONFIG_PATH_A');
        this.convertToThemeInfo(FileUtils.readJsonFile(THEME_CONFIG_PATH_A));
      } else {
        this.resetThemeStyle();
      }
      if (this.isStyleChanged || isStyleChanged) {
        this.index++;
      }
      return THEME_STYLE + THEME_FLAG_A + this.index;
    }

    if (FileUtils.isExist(THEME_FLAG_PATH_B)) {
      if (FileUtils.isExist(THEME_CONFIG_PATH_B)) {
        this.convertToThemeInfo(FileUtils.readJsonFile(THEME_CONFIG_PATH_B));
      } else {
        this.resetThemeStyle();
      }
      if (this.isStyleChanged || isStyleChanged) {
        this.index++;
      }
      return THEME_STYLE + THEME_FLAG_B + this.index;
    }

    this.resetThemeStyle();
    log.showError('Get theme config error, no theme package exit.');
    return '';
  }

  /**
   * Get theme style config.
   *
   * @returns themeStyle
   */
  public getThemeStyle(): ThemeStyleInfo {
    return this.themeStyle;
  }

  /**
   * Register theme event.
   *
   * @param callback
   */
  public registerThemeEvent(callback: ThemEventFunc): void {
    log.showInfo('registerThemeActiveEvent');
    let SUBSCRIBE_THEME_INFO: commonEventManager.CommonEventSubscribeInfo =
      { events: ['com.ohos.ActivateTheme'], userId: this.userId };
    try {
      commonEventManager.createSubscriber(SUBSCRIBE_THEME_INFO).then((subscriber) => {
        if (!subscriber) {
          log.showError('Create subscriber failed');
          return;
        }

        this.mSubscriber = subscriber;
        log.showInfo('Create subscriber success');
        this.subscribeActivateThemeEvent(this.mSubscriber, callback);
      });
    } catch (e) {
      log.showError(`Create subscriber error: ${e?.message}`);
    }
  }

  /**
   * Unregister theme event.
   */
  public unregisterThemeEvent(): void {
    if (this.mSubscriber) {
      commonEventManager.unsubscribe(this.mSubscriber);
      this.mSubscriber = undefined;
    }
  }

  /**
   * Is theme style changed.
   *
   * @returns isStyleChanged
   */
  public isThemeStyleChanged(): boolean {
    return this.isStyleChanged;
  }

  /**
   * Notify theme info.
   *
   * @param isIconStyleEnable icon style enable.
   * @param isShowName show name or not.
   * @param iconSize icon scale size.
   * @param radiusSize radius scale size.
   */
  public notifyThemeInfo(isIconStyleEnable: boolean, isShowName?: boolean, iconSize?: number, radiusSize?: number): void {
    log.showInfo(`notify theme style info, iconStyleEnable:${isIconStyleEnable}`);
    this.lastThemeStyle.iconSizeScale = this.themeStyle.iconSizeScale;
    this.lastThemeStyle.radiusSizeScale = this.themeStyle.radiusSizeScale;
    this.lastThemeStyle.isShowName = this.themeStyle.isShowName;

    // iconSize scale range: [-6, 8]
    if (iconSize === undefined || iconSize < MIN_ICON_SCALE_SIZE || iconSize > MAX_ICON_SCALE_SIZE) {
      this.themeStyle.iconSizeScale = undefined;
    } else {
      this.themeStyle.iconSizeScale = iconSize;
    }

    // radius scale size range: [0, 1]
    if (radiusSize === undefined || radiusSize < 0 || radiusSize > 1) {
      this.themeStyle.radiusSizeScale = undefined;
    } else {
      this.themeStyle.radiusSizeScale = radiusSize;
    }

    if (isShowName !== undefined) {
      this.themeStyle.isShowName = isShowName;
    } else {
      this.themeStyle.isShowName = true;
    }

    if (this.themeCallback) {
      this.themeCallback.onStyleChanged?.(isIconStyleEnable);
    }
  }

  /**
   * Notify theme result.
   *
   * @param isSuccess is enable theme success
   */
  public notifyThemeResult(isSuccess: boolean): void {
    if (isSuccess) {
      return;
    }

    log.showWarn('enable theme failed.');
    this.themeStyle.iconSizeScale = this.lastThemeStyle.iconSizeScale;
    this.themeStyle.radiusSizeScale = this.lastThemeStyle.radiusSizeScale;
    this.themeStyle.isShowName = this.lastThemeStyle.isShowName;
    if (this.themeCallback) {
      this.themeCallback.onStyleChanged?.(false);
    }
  }

  /**
   * Register theme callback.
   *
   * @param callBack theme style callback.
   */
  public registerThemeCallBack(callBack: ThemeStyleCallback): void {
    this.themeCallback = callBack;
  }

  /**
   * Unregister theme callback.
   */
  public unRegisterThemeCallBack(): void {
    this.themeCallback = undefined;
  }

  private subscribeActivateThemeEvent(subscriber: commonEventManager.CommonEventSubscriber, callback: ThemEventFunc): void {
    commonEventManager.subscribe(subscriber, (err, eventData: commonEventManager.CommonEventData) => {
      if (err && err?.code !== 0) {
        log.showError(`Can't handle common event, err: ${err.message}`);
        return;
      }

      if (!eventData?.parameters) {
        log.showError('Event parameters is empty');
        return;
      }

      try {
        let isIconsActivate: boolean = eventData?.parameters?.icons === ACTIVATE_THEME_FLAG;
        let isHomeActivate: boolean = eventData?.parameters?.home === ACTIVATE_THEME_FLAG;
        log.showInfo(`Active theme callback, iconActive:${isIconsActivate}`);
        this.updateHomeManifest();
        if (isIconsActivate || isHomeActivate) {
          this.isPcHomeActivateCallBack(isIconsActivate, isHomeActivate, callback);
        } else {
          log.showInfo('Activate theme event is invalid');
        }
      } catch (e) {
        log.showError(`Parse event data err: ${e.message}`);
      }
    });
  }

  private updateHomeManifest(): void {
    let homeManifest = ThemeHelperUtil.getHomeManifest();
    log.showWarn(`getHomeManifest=${JSON.stringify(homeManifest)}`);
    if (homeManifest) {
      this.updateWallpaperTouchable(homeManifest.wallpaperTouchable);
    }
  }

  private isPcHomeActivateCallBack(isIconsActivate: boolean, isHomeActivate: boolean, callback: ThemEventFunc): void {
    if (DeviceHelper.isPC()) {
      callback?.(isIconsActivate, isHomeActivate);
    } else {
      callback?.(isIconsActivate);
    }
  }

  private convertToThemeInfo(themeStyleInfo: iThemeStyleInfo): void {
    if (CheckEmptyUtils.isEmpty(themeStyleInfo)) {
      log.showError('Get theme style config failed.');
      return;
    }

    if (!CheckEmptyUtils.isEmpty(themeStyleInfo.size) && themeStyleInfo.size !== this.themeStyle.iconSizeScale) {
      this.isStyleChanged = true;
      this.themeStyle.iconSizeScale = themeStyleInfo.size;
    }

    if (!CheckEmptyUtils.isEmpty(themeStyleInfo.radius) && themeStyleInfo.radius !== this.themeStyle.radiusSizeScale) {
      this.isStyleChanged = true;
      this.themeStyle.radiusSizeScale = themeStyleInfo.radius;
    }

    if (!CheckEmptyUtils.isEmpty(themeStyleInfo.showAppName) && themeStyleInfo.showAppName !== this.themeStyle.isShowName) {
      this.isStyleChanged = true;
      this.themeStyle.isShowName = themeStyleInfo.showAppName;
    }

    if (!CheckEmptyUtils.isEmpty(themeStyleInfo.iconResourcePath) &&
      themeStyleInfo.iconResourcePath !== this.themeStyle.iconResourcePath) {
      this.isStyleChanged = true;
      this.themeStyle.iconResourcePath = themeStyleInfo.iconResourcePath;
    }
    AppStorage.setOrCreate('themeStyle', this.themeStyle);
  }

  private resetThemeStyle(): void {
    this.themeStyle.iconSizeScale = undefined;
    this.themeStyle.radiusSizeScale = undefined;
    this.themeStyle.isShowName = true;
  }
}

export type ThemEventFunc = (isIconsActivate: boolean, isHomeActivate?: boolean) => void

export interface iThemeStyleInfo {
  size: number;
  radius: number;
  showAppName: boolean;
  iconResourcePath: string;
}