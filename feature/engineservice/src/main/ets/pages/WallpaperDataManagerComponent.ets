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

import lazy fs from '@ohos.file.fs';
import lazy { WallpaperBuilder } from './WallpaperBuilder';
import lazy { WallpaperConfig } from './WallpaperConfig';
import lazy { WallpaperUtils } from './WallpaperUtils';
import lazy { WallpaperViewController } from './WallpaperViewController';
import { GlobalContext } from '../utils/GlobalContext';
import { WallpaperComponentModifier } from './WallpaperComponentModifier';
import { Constants } from '../utils/Constants';
import { ResourceReloadListener } from '../reloadmanager/ReloadStrategy';
import { DeviceUtil } from '../utils/DeviceUtil';
import { ResourceReloadStrategy } from '../reloadmanager/ResourceReloadStrategy';
import { ScbState, WallpaperType } from './WallpaperConstants';
import { Log } from '../utils/Log';
import { ThemeLoadPublisher } from '../datdamanager/ThemeLoadPublisher';

const TAG: string = 'WallpaperDataManagerComponent';
const SINGLE_COMPONENT_FENCE: number = 1;
const DUAL_COMPONENT_FENCE: number = 2;

/**
 * Wallpaper data manager is a component but also manages which wallpaper would be used
 * It is exposed to SCB_EngineService as an entry to ThemeEngine.
 * All UI related manipulation were managed by WallpaperViewController.
 *
 * @since 2024-02-27
 */
@Component
export struct WallpaperDataManagerComponent {
  private bsodTag: string = Constants.PREFIX_BSOD + TAG;

  public wallpaperType: WallpaperType = WallpaperType.DEFAULT;

  public activeThemePath: string = '';

  public scbState: ScbState = ScbState.UNKNOWN;

  public homeType: WallpaperType = WallpaperType.UNKNOWN;

  public lockType: WallpaperType = WallpaperType.UNKNOWN;

  @Link public modifier: WallpaperComponentModifier;

  private wallpaperViewController: WallpaperViewController = WallpaperViewController.getInstance();

  @Provide('lockPath')
  private lockscreenImagePath: string = '';

  @Provide('homePath')
  private desktopImagePath: string = '';

  @Provide('movingPhotoPath')
  private movingPhotoSrcPath: string = '';

  @Provide('movingPhotoFirstImgSrcPath')
  private movingPhotoFirstImgSrcPath: string = '';

  @Provide('lockWallpaperConfig')
  private lockWallpaperConfig: Nullable<WallpaperConfig> = new WallpaperConfig();

  @Provide('homeWallpaperConfig')
  private homeWallpaperConfig: Nullable<WallpaperConfig> = new WallpaperConfig();

  @Provide('isLockNewResource')
  private isLockNewResource: boolean = false;

  @Provide('isHomeNewResource')
  private isHomeNewResource: boolean = false;

  @Provide('aodMaskPath')
  private aodMaskPath: string = '';

  @StorageLink('blurRadius') @Watch('updateBlurRadius')
  private blurRadius: number = 0;

  @StorageLink('lightUpFactor') @Watch('updateLightUpFactor')
  private lightUpFactor: number = 1;

  @State private isDowngradeStatic: boolean = false;

  @StorageProp('wallpaperType') @Watch('updateWallpaperType')
  private wallpaperHomeType: WallpaperType = WallpaperType.UNKNOWN;

  @Provide('resourceQualifier')
  private lastResourceQualifier: number = AppStorage.get<number>('resourceQualifier') ?? 0;

  private initWallpaperPath(): void {
    let resourceQualifier: number = AppStorage.get<number>('resourceQualifier') ?? 0;
    this.updateWallpaperPath(resourceQualifier);
    GlobalContext.getContext().setObject(Constants.SANDBOX, this.activeThemePath);
  }

  private updateBlurRadius(): void {
    this.modifier?.updateBlurRadius(this.blurRadius);
  }

  private updateLightUpFactor(): void {
    this.modifier?.updateLightUpFactor(this.lightUpFactor);
  }

  private updateWallpaperType() {
    Log.info(TAG, 'updateWallpaperType, load static wallpaper.');
    this.homeType = WallpaperType.STATIC;
    this.lockType = WallpaperType.STATIC;
    let resourceQualifier: number = AppStorage.get<number>('resourceQualifier') ?? 0;
    this.updateWallpaperPath(resourceQualifier);
    this.wallpaperViewController.setWallpaperType(this.lockType, this.homeType);
    ResourceReloadStrategy.getInstance().addReloadListener(this.resourceReloadListener);
    setTimeout(() => {
      this.wallpaperViewController.destroy();
      this.isDowngradeStatic = true;
    }, Constants.SECOND_IN_MILLS);
  }

  private resourceReloadListener: ResourceReloadListener = {
    reloadResource: async (resourceQualifier: number) => {
      Log.info(TAG, `lastQualifier: ${this.lastResourceQualifier}, curQualifier: ${resourceQualifier}`);
      if (this.lastResourceQualifier === resourceQualifier && DeviceUtil.isTriFoldProduct()) {
        Log.info(TAG, 'qualifier same and return.');
        return;
      }
      const latestRoot: string = GlobalContext.getContext().getObject(Constants.SANDBOX) as string;
      if (latestRoot) {
        this.activeThemePath = latestRoot;
      }
      let lastOrientation: number = (this.lastResourceQualifier >> 1) & 1;
      let currentOrientation: number = (resourceQualifier >> 1) & 1;

      // Check whether the screen rotates except folded state of folding screen.
      if ((lastOrientation ^ currentOrientation) === 1 && !DeviceUtil.isFoldStatus()) {
        Log.info(TAG, `The screen rotates.`);
        GlobalContext.getContext().setObject(Constants.IS_ROTATED, true);
      } else {
        GlobalContext.getContext().setObject(Constants.IS_ROTATED, false);
      }
      this.lastResourceQualifier = resourceQualifier;
      this.updateWallpaperPath(resourceQualifier);
      WallpaperViewController.getInstance().updateAodCoefficient(resourceQualifier);
    }
  }

  /**
   * 静态壁纸刷新刷新获取到的壁纸资源
   *
   * @param resourceQualifier 资源限定符
   */
  private updateWallpaperPath(resourceQualifier: number): void {
    this.updateWallPaperConfig(resourceQualifier);

    if (this.lockType === WallpaperType.STATIC) {
      let lockImagePath: string = WallpaperUtils.getLockWallpaperPath(this.activeThemePath, resourceQualifier,
        this.lockWallpaperConfig);
      if (fs.accessSync(lockImagePath)) {
        Log.debug(TAG, `onLockImagePathChange, resourceQualifier: ${resourceQualifier}`);
        this.lockscreenImagePath = lockImagePath;
        this.isLockNewResource =
          (GlobalContext.getContext().getObject(Constants.IS_LOCK_NEW_RESOURCE_READING) as boolean) ?? false;
      } else {
        Log.error(TAG, `File not accessable, set lockscreenImagePath failed.`);
      }
    }

    if (this.homeType === WallpaperType.STATIC) {
      let homeImagePath: string =
        WallpaperUtils.getHomeWallpaperPath(this.activeThemePath, resourceQualifier, this.homeWallpaperConfig);
      if (fs.accessSync(homeImagePath)) {
        Log.debug(TAG, `onHomeImagePathChange, resourceQualifier: ${resourceQualifier}`);
        this.desktopImagePath = homeImagePath;
        this.isHomeNewResource =
          (GlobalContext.getContext().getObject(Constants.IS_HOME_NEW_RESOURCE_READING) as boolean) ?? false;
      } else {
        Log.error(TAG, `File not accessable, set desktopImagePath failed.`);
      }
    }

    this.aodMaskPath = `${this.activeThemePath}/aod/base/resources/decoration.png`;
  }

  private updateWallPaperConfig(resourceQualifier: number) {
    this.lockWallpaperConfig = WallpaperUtils.getWallpaperConfig(this.activeThemePath, 'lock', resourceQualifier);
    this.homeWallpaperConfig = WallpaperUtils.getWallpaperConfig(this.activeThemePath, 'home', resourceQualifier);
    Log.info(TAG, `lockBlurRadius = ${this.lockWallpaperConfig?.blurRadius ??
      0}, homeBlurRadius = ${this.homeWallpaperConfig?.blurRadius ?? 0}`);
  }


  private handleFreakTheme(): void {
    this.wallpaperType = this.isThemeEdited() ? WallpaperType.STATIC : this.wallpaperType;
  }

  /**
   * Check if the theme was edited before.
   * In the scenario where dynamic theme is edited with customised wallpaper, dynamic capability needs to be dropped.
   *
   * @returns Return true if theme was edited by the ThemeEditor, otherwise false
   */
  private isThemeEdited(): boolean {
    let lockCfg: string = `${this.activeThemePath}/unlock/base/wallpaperconfig.json`;
    let homeCfg: string = `${this.activeThemePath}/home/base/wallpaperconfig.json`;

    try {
      if (fs.accessSync(lockCfg) || fs.accessSync(homeCfg)) {
        Log.info(TAG, `This theme's wallpaper was edited before, dynamic engine is not applicable.`);
        return true;
      }
      Log.info(TAG, `Load the theme as the original design.`);
      return false;
    } catch (err) {
      Log.error(TAG, `Error on accessing file system,
        considering the theme is not edited by default. ${err?.code} - ${err?.message}`);
    }
    return false;
  }

  private calculateStaticLoadFence(): void {
    let fence: number = 0;
    if (this.lockType === WallpaperType.DYNAMIC && this.homeType === WallpaperType.DYNAMIC) {
      fence = SINGLE_COMPONENT_FENCE;
    } else {
      fence = DUAL_COMPONENT_FENCE; // Pure static and/or mashup would use two wallpaper components
    }

    ThemeLoadPublisher.getInstance().setLoadFence(fence);
  }

  /**
   * On initialising WDM, parse wallpaper path if using normal static wallpaper.
   */
  public async aboutToAppear(): Promise<void> {
    this.handleFreakTheme();
    Log.info(TAG, `Initialising WDM, initial SCB state is ${this.scbState}, wallpaper type ${this.wallpaperType}`);

    // For backward compatibility - EngineService doesn't have to specify dual type if mashup is not supported
    Log.info(TAG, `Given lock and home type are ${this.lockType} and ${this.homeType}`);
    this.initWallpaperPath();

    this.wallpaperViewController.setWallpaperType(this.lockType, this.homeType);
    this.wallpaperViewController.onScbUpdate(this.scbState);

    // DEFAULT doesn't response to resource reload, DYNAMIC asks all nodes to implement their own reloader
    if (this.lockType === WallpaperType.STATIC || this.homeType === WallpaperType.STATIC) {
      ResourceReloadStrategy.getInstance().addReloadListener(this.resourceReloadListener);
    }
    this.calculateStaticLoadFence();
    this.wallpaperViewController.setUiContext(this.getUIContext());
  }

  /**
   * Release resource on component destruction
   */
  public aboutToDisappear(): void {
    Log.warn(this.bsodTag, `in aboutToDisappear() release resource.`);
    ResourceReloadStrategy.getInstance().removeReloadListener(this.resourceReloadListener);
  }

  public onPageHide(): void {
    Log.warn(this.bsodTag, `in onPageHide() release resource.`);
  }

  public build(): void {
    if (this.isDowngradeStatic) {
      WallpaperBuilder({
        lockType: this.lockType,
        homeType: this.homeType,
      })
    } else {
      WallpaperBuilder({
        lockType: this.lockType,
        homeType: this.homeType,
      })
    }
  }
}