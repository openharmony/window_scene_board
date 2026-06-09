/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2024. All rights reserved.
 */

export class WallPaper {
  public src: string = '';

/**
 * 壁纸类型：image:静态壁纸，script:动态壁纸，longTake:对应一镜到底配置模式
 * 当前仅支持静态壁纸
 */
  public contentType?: 'default' | 'video' | 'image' | 'json';

/**
 * 壁纸资源类型: base, unfold等, 参考主题规范资源限定符
 */
  public category: string = 'base';

  public applyFrom?: string = 'default';

  public id?: string;

  public origin?: string;
}

export interface WallPaperInfo {
  wallPapers: WallPaper[];
  wallPaperType: TWallpaperType;
  type?: 'image' | 'movingPhoto';
}

export type TWallpaperType = 'lock' | 'home';
