/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 */
import { VersionCode } from "../utils/Constants";

/**
 * 壁纸配置文件wallpaper_config.json,由合一编辑器定义的数据结构
 */
export class WallpaperConfig {
  /**
   * 版本号标识
   */
  public versionCode: VersionCode = VersionCode.VERSION_CODE_UNKNOWN;

  /**
   * 壁纸的rect信息,包括rect以及qualifier
   */
  public rectData: WallpaperRectData = new WallpaperRectData();

  /**
   * 壁纸原始数据, 包括图片的宽高
   */
  public wallpaperAttr: WallpaperAttr = new WallpaperAttr();

  /**
   * 壁纸来源信息,如预置壁纸,图库照片等
   */
  public wallpaperSourceType: WallpaperSourceType = WallpaperSourceType.UNKNOWN;

  /**
   * 桌面壁纸是否虚化
   */
  public isHomeScreenBlur: boolean = false;

  /**
   * 锁屏壁纸是否虚化
   */
  public isLockScreenBlur: boolean = false;

  /**
   * 模糊半径
   */
  public blurRadius: number = 0;
}

/**
 * 壁纸的显示rect信息
 */
export class WallpaperRectData {
  /**
   * 壁纸对应的qualifier信息
   */
  public qualifier: WallpaperQualifier = WallpaperQualifier.BASE;

  /**
   * 壁纸被编辑后相对于原图的Rect信息
   */
  public rect: WallpaperRect = new WallpaperRect();
}

/**
 * 壁纸显示区域
 */
export class WallpaperRect {
  /**
   * 裁剪后偏移X坐标，单位px
   */
  public x: number = 0;

  /**
   * 裁剪后偏移Y坐标，单位px
   */
  public y: number = 0;

  /**
   * 裁剪后内容展示宽度，单位px
   */
  public width: number = 0;

  /**
   * 裁剪后内容展示高度，单位px
   */
  public height: number = 0;

  /**
   * 壁纸显示比例
   */
  public ratio: number = 0;
}

/**
 * 壁纸属性
 */
export class WallpaperAttr {
  /**
   * 壁纸原始高，单位px
   */
  public originHeight: number = 0;

  /**
   * 壁纸原始宽，单位px
   */
  public originWidth: number = 0;
}

/**
 * 壁纸编辑场景限定符
 */
export enum WallpaperQualifier {
  BASE = 'BASE',
  LAND = 'LAND', // 专指平板横屏
  UNFOLDED = 'UNFOLDED',
  UNFOLDED2 = 'UNFOLDED2',
  UNFOLDED_LAND = 'UNFOLDED-LAND',
  UNFOLDED2_LAND = 'UNFOLDED2-LAND',
  ORIGIN = 'ORIGIN',
  SUB_SCREEN = 'SUB_SCREEN',
};

/**
 * 壁纸设置来源类型
 */
export enum WallpaperSourceType {
  UNKNOWN,
  THEME,
  PRESET,
  HISTORY,
  RECOMMEND,
  PHOTO,
  BACKUP,
  DOWN,
}