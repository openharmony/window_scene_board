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
