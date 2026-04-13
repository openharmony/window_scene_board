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
import { OriginType, ORIGIN_PRESET, TWallpaperType, WallPaperContentType } from '../constant/TSTypes';

export class WallPaper {
  /**
   * 壁纸资源
   */
  public src: string = '';
  /**
   * 壁纸内容类型
   */
  public contentType: WallPaperContentType = 'default';
  /**
   * 壁紙资源类型：base，dark，参考主题规范资源限定符
   */
  public category: string = 'base';
  /**
   * 壁纸应用来源：图库/预置壁纸/在线主题APP设置
   */
  public applyFrom?: string = 'default';
  /**
   * 图片资源id，需要提供在线资源ID
   */
  public id?: string = '';
  /**
   * 壁纸资源分类：在线/预置
   */
  public origin: OriginType = ORIGIN_PRESET;
  /**
   * 壁纸类型：静态壁纸 或 movingPhoto
   */
  public type: 'image' | 'movingPhoto' = 'image';
  /**
   * 是否写入到manifest和description文件
   */
  public property: string = 'main';
}

export class WallPaperInfo {
  public wallPapers: WallPaper[];
  public wallPaperType: TWallpaperType;
  /**
   * 壁纸类型：image:静态壁纸，script:动态壁纸，longTake:对应一镜到底配置模式,movingPhoto
   * 当前仅支持静态壁纸
   */
  public type: string = 'image';

  constructor(wallPapers: WallPaper[], wallPaperType: TWallpaperType) {
    this.wallPapers = wallPapers;
    this.wallPaperType = wallPaperType;
  }
}
