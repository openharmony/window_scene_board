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
import { ResourceReloadListener } from '../../reloadmanager/ReloadStrategy';
import { ResourceReloadStrategy } from '../../reloadmanager/ResourceReloadStrategy';
import { DeviceUtil } from '../../utils/DeviceUtil';
import { JsonUtil } from '../../utils/JsonUtil';
import { Log } from '../../utils/Log';
import lazy { AnimationConstants } from './AnimationConstants';

const TAG: string = 'AodMaskDataManager';

const WALLPAPER_PARAM_CONFIG: string = '/data/themes/s/aod/customClock/imageParam.json';

const CENTRE_DIVIDEND: number = 2;

const OFFSET_DELTA_DIVIDEND: number = 6;

const OFFSET_ARR_SIZE: number = 2;

// 默认蒙版上边距，96vp
const DEFAULT_TOP_PADDING: number = 96;

// 超大屏G态或者PAD竖屏状态蒙版上边距，132vp
const LARGE_TOP_PADDING: number =  132;

// 默认蒙版宽高，200vp
const DEFAULT_MASK_EDGE_LENGTH: number = 200;

// 超大屏G态或者PAD竖屏状态蒙版宽高，240vp
const LARGE_MASK_EDGE_LENGTH: number = 240;

export class AodMaskDataManager {
  private static instance: AodMaskDataManager;

  private wallpaperScaleMap: Map<string, number> = new Map();

  private wallpaperOffsetXMap: Map<string, number> = new Map();

  private wallpaperOffsetYMap: Map<string, number> = new Map();

  private wallpaperScale: number = 1;

  private wallpaperOffsetX: number = 0;

  private wallpaperOffsetY: number = 0;

  private aodMaskOffset: number[] = [0, 0];

  private maskExitTarget: number = 0;

  private maskCentrePadding: number = 0;

  private lastResourceQualifier: number = AppStorage.get<number>('resourceQualifier') ?? 0;

  private topPadding: number = 0;

  private maskEdgeLength: number = 0;

  private updateParamCallback: ResourceReloadListener = {
    reloadResource: async (resourceQualifier: number) => {
      this.updateParam(resourceQualifier);
    }
  }

  private constructor() {
    ResourceReloadStrategy.getInstance().addReloadListener(this.updateParamCallback);
    this.loadImageParam();
  }

  public destructor(): void {
    ResourceReloadStrategy.getInstance().removeReloadListener(this.updateParamCallback);
  }

  public loadImageParam(): void {
    this.initDataMap();
    this.updateParam(this.lastResourceQualifier, true);
  }

  public static getInstance(): AodMaskDataManager {
    if (!AodMaskDataManager.instance) {
      AodMaskDataManager.instance = new AodMaskDataManager();
    }

    return AodMaskDataManager.instance;
  }

  /**
   * Calculate the offset that requires to put the centre of the mask to the 1/3 of the screen
   *
   * @returns Offset to place the mask position
   */
  public getExitTarget(): number {
    // To ensure the accuracy of the offset, only to acquire value when needed
    let screenHeight: number = DeviceUtil.getScreenHeight();
    if (DeviceUtil.isPhoneInLandscape() && DeviceUtil.getScreenWidth() > DeviceUtil.getScreenHeight()) {
      screenHeight = DeviceUtil.getScreenWidth();
    }
    this.maskCentrePadding = this.alignFourByte(vp2px(this.maskEdgeLength)) / CENTRE_DIVIDEND + vp2px(this.topPadding);
    this.maskExitTarget = (screenHeight / CENTRE_DIVIDEND - this.maskCentrePadding) *
      AnimationConstants.AOD_INVISIBLE_SCALE - screenHeight / OFFSET_DELTA_DIVIDEND;
    return this.maskExitTarget;
  }

  public alignFourByte(px: number): number {
    px = Math.floor(px);

    // Align the image size with 4 byte
    let alignImageHeight: number = 4;
    if (px % alignImageHeight !== 0) {
      px += (alignImageHeight - (px % alignImageHeight));
    }

    return px;
  }

  private initDataMap(): void {
    let contentString: string = '';
    try {
      if (!fs.accessSync(WALLPAPER_PARAM_CONFIG)) {
        Log.warn(TAG, 'No AOD wallpaper param file was found.');
        return;
      }
      contentString = fs.readTextSync(WALLPAPER_PARAM_CONFIG);
    } catch (err) {
      Log.error(TAG, `Error on calling fs intfs ${err?.code}`);
    }

    let paramContent: object | undefined = JsonUtil.jsonParse(contentString);
    if (!paramContent) {
      Log.error(TAG, 'Invalid AOD wallpaper param data.');
      return;
    }

    for (let key of Object.keys(paramContent)) {
      if (key.includes('wallpaperScale')) {
        this.wallpaperScaleMap.set(key, paramContent[key]);
        continue;
      }

      if (key.includes('offsetX')) {
        this.wallpaperOffsetXMap.set(key, paramContent[key]);
        continue;
      }

      if (key.includes('offsetY')) {
        this.wallpaperOffsetYMap.set(key, paramContent[key]);
        continue;
      }
    }
  }

  public setAodMaskOffset(offset: number[]): void {
    if (!offset || offset.length !== OFFSET_ARR_SIZE) {
      return;
    }

    this.aodMaskOffset = offset;
  }

  public getAodMaskOffset(): number[] {
    return this.aodMaskOffset;
  }

  public getWallpaperScale(): number {
    return this.wallpaperScale;
  }

  public getWallpaperOffset(): number[] {
    return [this.wallpaperOffsetX, this.wallpaperOffsetY];
  }

  /**
   * 更新自定义aod参数
   *
   * @param resourceQualifier 当前设备状态限定符
   * @param forceUpdate 是否忽视限定符变化强制更新，一般用于限定符不变，但是用户修改了aod的类型或者参数时
   */
  private updateParam(resourceQualifier: number, forceUpdate: boolean = false): void {
    if (this.lastResourceQualifier === resourceQualifier && !forceUpdate) {
      Log.warn(TAG, 'ResourceQualifier not change, skip updateParam.');
      return;
    }
    this.lastResourceQualifier = resourceQualifier;

    // Qualifier's bit-1 indicates land/portrait, bit-2 indicates fold/unfolded
    const isLandscape: boolean = ((resourceQualifier >> 1) & 1) === 1;
    const isUnfolded: boolean = ((resourceQualifier >> 2) & 1) === 1;
    const isTriUnfolded: boolean = ((resourceQualifier >> 3) & 1) === 1;
    let scaleKeyBase: string = 'wallpaperScale';
    let offsetXKeyBase: string = 'offsetX';
    let offsetYKeyBase: string = 'offsetY';

    if (isUnfolded) {
      Log.info(TAG, 'Concatenate unfolded suffix');
      scaleKeyBase += 'Unfolded';
      offsetXKeyBase += 'Unfolded';
      offsetYKeyBase += 'Unfolded';
    } else if (isTriUnfolded) {
      Log.info(TAG, 'Concatenate tri-unfolded suffix');
      scaleKeyBase += 'Unfolded2';
      offsetXKeyBase += 'Unfolded2';
      offsetYKeyBase += 'Unfolded2';
    }

    if (isLandscape) {
      Log.info(TAG, 'Concatenate land suffix');
      scaleKeyBase += 'Land';
      offsetXKeyBase += 'Land';
      offsetYKeyBase += 'Land';
    }

    const scaleMapVal: number | undefined = this.wallpaperScaleMap.get(scaleKeyBase);
    if (scaleMapVal === undefined) {
      Log.warn(TAG, `Default scale will apply - no ${scaleKeyBase} stored.`);
      this.wallpaperScale = 1;
    } else {
      this.wallpaperScale = scaleMapVal;
    }

    const offsetXMapVal: number | undefined = this.wallpaperOffsetXMap.get(offsetXKeyBase);
    if (offsetXMapVal === undefined) {
      Log.warn(TAG, `Default horizontal offset will apply - no ${offsetXKeyBase} stored.`);
      this.wallpaperOffsetX = 0;
    } else {
      this.wallpaperOffsetX = offsetXMapVal;
    }

    const offsetYMapVal: number | undefined = this.wallpaperOffsetYMap.get(offsetYKeyBase);
    if (offsetYMapVal === undefined) {
      Log.warn(TAG, `Default vertical offset will apply - no ${offsetYKeyBase} stored.`);
      this.wallpaperOffsetY = 0;
    } else {
      this.wallpaperOffsetY = offsetYMapVal;
    }

    // 更新遮罩层上边距和宽高
    let localTopPadding: number = DEFAULT_TOP_PADDING;
    let localMaskEdgeLength: number = DEFAULT_MASK_EDGE_LENGTH;
    // 平板或者超大屏G态参数计算
    if (DeviceUtil.isPad() || (DeviceUtil.isTriFoldProduct() && isTriUnfolded)) {
      localMaskEdgeLength = LARGE_MASK_EDGE_LENGTH;
      if (isLandscape) {
        localTopPadding = DEFAULT_TOP_PADDING;
      } else {
        localTopPadding = LARGE_TOP_PADDING;
      }
    }

    Log.info(TAG, `[ ${scaleKeyBase} ] params: wallpaperScale = ${this.wallpaperScale}, ` +
      `wallpaperOffsetX = ${localMaskEdgeLength}, wallpaperOffsetX = ${this.wallpaperOffsetX}`);

    if (this.topPadding !== localTopPadding) {
      this.topPadding = localTopPadding;
      AppStorage.setOrCreate<number>('topPadding', localTopPadding);
    }
    if (this.maskEdgeLength !== localMaskEdgeLength) {
      this.maskEdgeLength = localMaskEdgeLength;
      AppStorage.setOrCreate<number>('maskEdgeLength', localMaskEdgeLength);
    }
    Log.info(TAG, `update topPadding = ${localTopPadding}, maskEdgeLength = ${localMaskEdgeLength}`);
  }
}