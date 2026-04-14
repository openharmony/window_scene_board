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

import type image from '@ohos.multimedia.image';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalStatusCache, StatusCacheConst } from '../base/GlobalStatusCache';

const TAG = 'ScreenLockWallpaperState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
/**
 * 壁纸默认反色，白色
 */
const DEFAULT_REVERSE_COLOR = '#FFFFFF';

/**
 * 锁屏壁纸类型
 */
export enum SLWallpaperType {
  /**
   * 默认无壁纸
   */
  TYPE_NONE = 0,

  /**
   * 引擎主题壁纸
   */
  TYPE_ENGINE_THEME = 0x01,

  /**
   * 沉浸锁屏样式壁纸
   */
  TYPE_IMMERSIVE_STYLE = 0x02,

  /**
   * 锁屏编辑态壁纸
   */
  TYPE_EDIT_STYLE = 0x04,

  /**
   * 默认竖屏景深壁纸
   */
  TYPE_DOF_STYLE = 0x8,

  /**
   * PAD横屏景深壁纸
   */
  TYPE_DOF_LAND_STYLE = 0x09,

  /**
   * 折叠屏展开态竖屏景深壁纸
   */
  TYPE_DOF_UNFOLDED_STYLE = 0x0A,

  /**
   * 折叠屏展开态横屏景深壁纸
   */
  TYPE_DOF_UNFOLDED_LAND_STYLE = 0x0B,

  /**
   * VDE折叠屏折叠态景深壁纸
   */
  TYPE_DOF_SMALL_UNFOLDED_STYLE = 0x0C,
}

/**
 * 锁屏壁纸可见性场景
 */
export enum SLWallpaperVisibleScene {
  /**
   * 默认场景
   */
  SCENE_DEFAULT = 0x01,

  /**
   * 锁屏相机滑出场景
   */
  SCENE_SCREEN_CAMERA = 0x02,

  /**
   * 进入沉浸锁屏卡片场景
   */
  SCENE_IMMERSIVE_CARD = 0x04,

  /**
   * 进入壁纸编辑状态
   */
  SCENE_SCREEN_EDIT = 0x08,
}

/**
 * 锁屏壁纸UI状态管理
 */
@Observed
export class SLWallpaperState {
  /**
   * 锁屏壁纸图片
   */
  @Track public wallpaperImg?: image.PixelMap;

  /**
   * 壁纸内容模糊半径
   */
  @Track public wallpaperBlur: number = 0;

  /**
   * 壁纸s缩放比例
   */
  @Track
  public wallpaperScale: number = 1;

  /**
   * 透明度
   */
  @Track public alpha: number = 1;

  /**
   * 壁纸是否显示
   */
  @Track public isVisible: boolean = false;

  /**
   * 当前壁纸反色颜色
   */
  @Track public wallpaperReverseColor?: string;

  /**
   * 当前壁纸是否为浅色壁纸
   */
  @Track public isLightWallpaper?: boolean;

  /**
   * 锁屏主色调，默认白色
   */
  @Track public slMainColor: Color = Color.White;

  /**
   * 饱和度
   */
  @Track public saturate?: number;

  /**
   * 壁纸亮度
   */
  @Track public light: number = 1;

  /**
   * 获取壁纸反色颜色值
   *
   * @returns 壁纸反色颜色值
   */
  getWallpaperReverseColor(): string | undefined {
    if (GlobalStatusCache.getInstance().getStatus(StatusCacheConst.IS_SPECIAL_MODE_BOUNCER_FOCUS_KEY, false)) {
      log.showInfo('isSpecialModeBouncerFocus return default color');
      return DEFAULT_REVERSE_COLOR;
    }
    return this.wallpaperReverseColor ?? DEFAULT_REVERSE_COLOR;
  }
}