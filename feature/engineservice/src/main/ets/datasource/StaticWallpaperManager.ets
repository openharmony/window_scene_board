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

import lazy display from '@ohos.display';
import lazy window from '@ohos.window';
import { WallpaperConfig, WallpaperQualifier, WallpaperRect } from '../pages/WallpaperConfig';
import { WallpaperViewController } from '../pages/WallpaperViewController';
import { ResourceQualifierConstants } from '../reloadmanager/ResourceQualifierConstants';
import { Constants, DeviceChangeStatus } from '../utils/Constants';
import { DeviceUtil } from '../utils/DeviceUtil';
import { Log } from '../utils/Log';

const TAG: string = 'StaticWallpaperManager';
const ORIENTATION_BIT_POSITION: number = 1;
const FOLD_BIT_POSITION: number = 2;
const TRI_FOLD_BIT_POSITION: number = 3;

/**
 * 静态壁纸裁切管理类
 *
 * @since 2025-01-18
 */
export class StaticWallpaperManager {
  public lastOrientation: number = DeviceUtil.getOrientation();
  private featherStatus: Set<DeviceChangeStatus> = new Set([DeviceChangeStatus.PORTRAIT_M2G_LAND_INVERTED,
    DeviceChangeStatus.PORTRAIT_INVERTED_M2G_LAND, DeviceChangeStatus.LAND_M2G_PORTRAIT,
    DeviceChangeStatus.LAND_INVERTED_M2G_PORTRAIT_INVERTED, DeviceChangeStatus.PORTRAIT_F2G_LAND_INVERTED]);
  private staticWallpaperAnimSize: Map<DeviceChangeStatus, (isLock: boolean) => StaticWallpaperAnimSize> = new Map([
    [DeviceChangeStatus.ROTATE, (isLock: boolean) => new StaticWallpaperAnimSize(0, 0, '100%', '100%')],
    [DeviceChangeStatus.PORTRAIT_M2G_LAND_INVERTED, (isLock: boolean) => new StaticWallpaperAnimSize(
      px2vp(isLock ? Constants.UNFOLD2_LOCK_OFFSET_X : -Constants.TRI_FOLD_UNFOLD_OFFSET_X), 0,
      px2vp(Constants.TRI_FOLD_UNFOLD_WIDTH), px2vp(Constants.TRI_FOLD_UNFOLD_HEIGHT))],
    [DeviceChangeStatus.PORTRAIT_INVERTED_M2G_LAND, (isLock: boolean) => new StaticWallpaperAnimSize(
      px2vp(isLock ? Constants.TRI_BASE_LOCK_OFFSET_X : 0), 0,
      px2vp(Constants.TRI_FOLD_UNFOLD_WIDTH), px2vp(Constants.TRI_FOLD_UNFOLD_HEIGHT))],
    [DeviceChangeStatus.LAND_M2G_PORTRAIT, (isLock: boolean) => new StaticWallpaperAnimSize(0,
      px2vp(isLock ? Constants.UNFOLD2_LOCK_OFFSET_X : -Constants.TRI_FOLD_UNFOLD_OFFSET_X),
      px2vp(Constants.TRI_FOLD_UNFOLD_HEIGHT), px2vp(Constants.TRI_FOLD_UNFOLD_WIDTH))],
    [DeviceChangeStatus.LAND_INVERTED_M2G_PORTRAIT_INVERTED, (isLock: boolean) => new StaticWallpaperAnimSize(
      0, px2vp(isLock ? Constants.TRI_BASE_LOCK_OFFSET_X : 0),
      px2vp(Constants.TRI_FOLD_UNFOLD_HEIGHT), px2vp(Constants.TRI_FOLD_UNFOLD_WIDTH))],
    [DeviceChangeStatus.PORTRAIT_G2M_LAND, (isLock: boolean) => new StaticWallpaperAnimSize(0,
      px2vp(isLock ? -Constants.UNFOLD2_LOCK_OFFSET_X : Constants.TRI_FOLD_UNFOLD_OFFSET_X),
      px2vp(Constants.TRI_FOLD_UNFOLD_HEIGHT), px2vp(Constants.TRI_FOLD_VIDEO_FRAME_SIZE))],
    [DeviceChangeStatus.PORTRAIT_INVERTED_G2M_LAND_INVERTED, (isLock: boolean) => new StaticWallpaperAnimSize(
      0, px2vp(isLock ? -Constants.TRI_BASE_LOCK_OFFSET_X : 0),
      px2vp(Constants.TRI_FOLD_UNFOLD_HEIGHT), px2vp(Constants.TRI_FOLD_VIDEO_FRAME_SIZE))],
    [DeviceChangeStatus.LAND_INVERTED_G2M_PORTRAIT, (isLock: boolean) => new StaticWallpaperAnimSize(
      px2vp(isLock ? -Constants.UNFOLD2_LOCK_OFFSET_X : Constants.TRI_FOLD_UNFOLD_OFFSET_X), 0,
      px2vp(Constants.TRI_FOLD_VIDEO_FRAME_SIZE), px2vp(Constants.TRI_FOLD_UNFOLD_HEIGHT))],
    [DeviceChangeStatus.LAND_G2M_PORTRAIT_INVERTED, (isLock: boolean) => new StaticWallpaperAnimSize(
      px2vp(isLock ? -Constants.TRI_BASE_LOCK_OFFSET_X : 0), 0,
      px2vp(Constants.TRI_FOLD_VIDEO_FRAME_SIZE), px2vp(Constants.TRI_FOLD_UNFOLD_HEIGHT))],
    [DeviceChangeStatus.PORTRAIT_F2G_LAND_INVERTED, (isLock: boolean) => new StaticWallpaperAnimSize(
      px2vp(isLock ? Constants.TRI_BASE_LOCK_OFFSET_X : 0), 0,
      px2vp(Constants.TRI_FOLD_BASE_WIDTH), px2vp(Constants.TRI_FOLD_UNFOLD_HEIGHT))],
    [DeviceChangeStatus.LAND_INVERTED_G2F_PORTRAIT, (isLock: boolean) => new StaticWallpaperAnimSize(0, 0,
      px2vp(Constants.TRI_FOLD_VIDEO_FRAME_SIZE), px2vp(Constants.TRI_FOLD_UNFOLD_HEIGHT))],
  ]);

  /**
   * 刷新图片数据和区域播放展示数据
   *
   * @param wallpaperConfig 显示区域参数
   * @returns 显示区域
   */
  public updateRectData(wallpaperConfig: Nullable<WallpaperConfig>): RectAttr | undefined {
    if (!wallpaperConfig) {
      Log.warn(TAG, 'WallpaperConfig is invalid');
      return undefined;
    }
    Log.info(TAG, 'updateRectData by wallpaperConfig');
    return new RectAttr(wallpaperConfig);
  }

  /**
   * 设置静态壁纸横竖屏和折展动画组件尺寸
   *
   * @param deviceChangeStatus 设备改变形态
   * @param isLock 是否是锁屏界面
   * @returns 返回静态壁纸横竖屏和折展动画组件尺寸
   */
  public setStaticWallpaperAnimSize(deviceChangeStatus: DeviceChangeStatus, isLock: boolean): StaticWallpaperAnimSize {
    return this.staticWallpaperAnimSize.get(deviceChangeStatus)?.(isLock) ??
      new StaticWallpaperAnimSize(0, 0, '100%', '100%');
  }

  /**
   * 获取设备折展横竖屏旋转改变状态
   * 判断设备是否发生旋转，没有发生旋转的场景如下：
   * 1、当前处于折叠状态，不会旋转
   * 2、根据限定词获取旋转状态，判断是否发生旋转
   * 3、对于三折叠M到G，G到M,F到G, G到F，没有发生旋转
   *
   * @param lastResourceQualifier 上次的限定符
   * @param resourceQualifier 当前的限定符
   * @returns boolean 返回设备折展横竖屏旋转改变状态
   */
  public getDeviceChangeStatus(lastResourceQualifier: number, resourceQualifier: number): DeviceChangeStatus {
    if (DeviceUtil.isFoldStatus()) {
      return DeviceChangeStatus.INVALID;
    }
    let lastOrientation: number = (lastResourceQualifier >> ORIENTATION_BIT_POSITION) & 1;
    let currentOrientation: number = (resourceQualifier >> ORIENTATION_BIT_POSITION) & 1;
    let isRotate: boolean = (lastOrientation ^ currentOrientation) === 1;
    if (!DeviceUtil.isTriFoldProduct()) {
      return (isRotate && DeviceUtil.isFoldStatus()) ? DeviceChangeStatus.ROTATE : DeviceChangeStatus.INVALID;
    }
    let isM2G: boolean = ((lastResourceQualifier >> FOLD_BIT_POSITION) & 1) === 1 &&
      ((resourceQualifier >> TRI_FOLD_BIT_POSITION) & 1) === 1;
    let isG2M: boolean = ((lastResourceQualifier >> TRI_FOLD_BIT_POSITION) & 1) === 1 &&
      ((resourceQualifier >> FOLD_BIT_POSITION) & 1) === 1;
    let isF2G: boolean = lastResourceQualifier <= ResourceQualifierConstants.IDX_DARK &&
      ((lastResourceQualifier >> FOLD_BIT_POSITION) & 1) === 0 &&
      ((resourceQualifier >> TRI_FOLD_BIT_POSITION) & 1) === 1;
    let isG2F: boolean = resourceQualifier <= ResourceQualifierConstants.IDX_DARK &&
      ((lastResourceQualifier >> TRI_FOLD_BIT_POSITION) & 1) === 1 &&
      ((resourceQualifier >> FOLD_BIT_POSITION) & 1) === 0;
    let status: DeviceChangeStatus = DeviceChangeStatus.INVALID;
    if (isM2G) {
      status = this.getStatusBaseOrientation(true);
    } else if (isG2M) {
      status = this.getStatusBaseOrientation(false);
    } else if (isF2G) {
      status = DeviceChangeStatus.PORTRAIT_F2G_LAND_INVERTED;
    } else if (isG2F) {
      status = this.lastOrientation === display.Orientation.LANDSCAPE_INVERTED ?
      DeviceChangeStatus.LAND_INVERTED_G2F_PORTRAIT : status = DeviceChangeStatus.INVALID;
    } else {
      status = isRotate ? DeviceChangeStatus.ROTATE : DeviceChangeStatus.INVALID;
    }
    Log.info(TAG, `getDeviceChangeStatus ${status}, isM2G: ${isM2G} isG2M: ${isG2M} isF2G: ${isF2G} isG2F: ${isG2F}`);
    return status;
  }

  private getStatusBaseOrientation(isM2G: boolean): DeviceChangeStatus {
    let deviceChangeStatus: DeviceChangeStatus = DeviceChangeStatus.INVALID;
    if (this.lastOrientation === display.Orientation.PORTRAIT) {
      deviceChangeStatus =
        isM2G ? DeviceChangeStatus.PORTRAIT_M2G_LAND_INVERTED : DeviceChangeStatus.PORTRAIT_G2M_LAND;
    } else if (this.lastOrientation === display.Orientation.PORTRAIT_INVERTED) {
      deviceChangeStatus =
        isM2G ? DeviceChangeStatus.PORTRAIT_INVERTED_M2G_LAND : DeviceChangeStatus.PORTRAIT_INVERTED_G2M_LAND_INVERTED;
    } else if (this.lastOrientation === display.Orientation.LANDSCAPE) {
      deviceChangeStatus = isM2G ? DeviceChangeStatus.LAND_M2G_PORTRAIT : DeviceChangeStatus.LAND_G2M_PORTRAIT_INVERTED;
    } else if (this.lastOrientation === display.Orientation.LANDSCAPE_INVERTED) {
      deviceChangeStatus =
        isM2G ? DeviceChangeStatus.LAND_INVERTED_M2G_PORTRAIT_INVERTED : DeviceChangeStatus.LAND_INVERTED_G2M_PORTRAIT;
    } else {
      deviceChangeStatus = DeviceChangeStatus.INVALID;
    }
    return deviceChangeStatus;
  }

  /**
   * 需要羽化的状态
   *
   * @param status 设备改变形态
   * @returns true表示需要羽化
   */
  public isFeatherStatus(status: DeviceChangeStatus): boolean {
    return this.featherStatus.has(status);
  }
}

/**
 * 显示区域范围
 */
@Observed
export class RectAttr {
  /**
   * 裁剪后偏移X坐标，单位vp
   */
  public contentOffsetX: Nullable<number>;
  /**
   * 裁剪后偏移Y坐标，单位vp
   */
  public contentOffsetY: Nullable<number>;
  /**
   * 内容原始宽度，单位vp
   */
  public contentShowWidth: Nullable<number>;
  /**
   * 内容原始高度，单位vp
   */
  public contentShowHeight: Nullable<number>;
  /**
   * 更新时的限定符
   */
  private qualifier: Nullable<WallpaperQualifier>;
  /**
   * 记录窗口或者屏幕的宽度
   */
  private displayWidth: Nullable<number>;
  /**
   * 记录窗口或者屏幕的高度
   */
  private displayHeight: Nullable<number>;

  /**
   * 根据主题包区域显示配置信息转换得到实际区域展示信息
   */
  public constructor(wallpaperConfig: Nullable<WallpaperConfig>) {
    this.update(wallpaperConfig);
  }

  /**
   * 更新显示数据
   *
   * @param wallpaperConfig 壁纸配置文件
   */
  public update(wallpaperConfig: Nullable<WallpaperConfig>): void {
    if (!wallpaperConfig || !wallpaperConfig.rectData) {
      Log.warn(TAG, `create RectAttr fail, wallpaperConfig invalid`);
      return;
    }
    const rect: WallpaperRect = wallpaperConfig.rectData.rect;
    if (!rect || rect.width <= 0 || rect.height <= 0) {
      Log.warn(TAG, `create RectAttr fail, rect invalid`);
      return;
    }
    const windowRect: window.Rect | undefined = WallpaperViewController.getInstance().getWindowRect();
    let useWindowSize: boolean = true;
    if (!windowRect || windowRect.width === 0 || windowRect.height == 0) {
      useWindowSize = false;
    }
    const displayWidth: number = useWindowSize ? windowRect?.width as number : DeviceUtil.getScreenWidth();
    const displayHeight: number = useWindowSize ? windowRect?.height as number : DeviceUtil.getScreenHeight();
    Log.info(TAG, `Get ${useWindowSize ? 'window' : 'device'} size [w:${displayWidth}, h:${displayHeight}]`);
    if (displayWidth <= 0 || displayHeight <= 0) {
      Log.warn(TAG, `create RectAttr fail, display invalid [w:${displayWidth},h:${displayHeight}]`);
      return;
    }

    // 如果配置文件和窗口大小都没变化，则不更新显示范围
    if (this.qualifier === wallpaperConfig.rectData.qualifier &&
      this.displayWidth === displayWidth && this.displayHeight === displayHeight) {
      Log.warn(TAG, `config and display size not change, skip update rect attr.`);
      return;
    }
    // 如果配置文件和窗口大小有变化，则记录最新值并重新计算显示范围
    this.qualifier = wallpaperConfig.rectData.qualifier;
    this.displayWidth = this.displayWidth;
    this.displayHeight = this.displayHeight;

    const originContentWidth: number = wallpaperConfig.wallpaperAttr?.originWidth ?? 0;
    const originContentHeight: number = wallpaperConfig.wallpaperAttr?.originHeight ?? 0;
    if (originContentWidth <= 0 || originContentHeight <= 0) {
      Log.warn(TAG, `create RectAttr fail, invalid size [w:${originContentWidth},h:${originContentHeight}]`);
      return;
    }
    let minRatio: number = Math.min(rect.width / displayWidth, rect.height / displayHeight);
    this.contentOffsetX = -rect.x / minRatio;
    this.contentOffsetY = -rect.y / minRatio;
    this.contentShowWidth = originContentWidth / minRatio;
    this.contentShowHeight = originContentHeight / minRatio;
    Log.info(TAG, `update rectAttr success, origin: x:${rect.x} y:${rect.y} w:${rect.width} h:${rect.height}, result: `+
      `x:${this.contentOffsetX} y:${this.contentOffsetY} w:${this.contentShowWidth} h:${ this.contentShowHeight}`);
  }
}

/**
 * 静态壁纸折展横竖屏旋转动画组件尺寸信息
 *
 * @since 2025-04-25
 */
export class StaticWallpaperAnimSize {
  /**
   * 组件x轴位置
   */
  public posX: Length = 0;
  /**
   * 组件y轴位置
   */
  public posY: Length = 0;
  /**
   * 组件宽度
   */
  public width: Length = '100%';
  /**
   * 组件高度
   */
  public height: Length = '100%';

  constructor(posX: Length = 0, posY: Length = 0, width: Length = '100%', height: Length = '100%') {
    this.posX = posX;
    this.posY = posY;
    this.width = width;
    this.height = height;
  }
}