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
import { image } from '@kit.ImageKit';

/**
 * 动效view数据类
 */
@Observed
export class ScreenLockFormAniData {
  public id: string = '';
  public isAnimationViewShow: boolean = false;
  public color: ResourceColor | undefined = '#ffffff';
  public isLightWallpaper: boolean = false;
  public position: Position = { x: 0, y: 0 };
  public gridWidth: number = 0;
  public dimensionX: number = 0;
  public width: number = 0;
  public height: number = 0;
  public radius: number = 0;
  public snapshot?: image.PixelMap;
  public scaleX: number = 1;
  public scaleY: number = 1;
}

/**
 * 播放动效数据类
 */
export class ScreenLockAniParam {
  public color: string = '#ffffff';
  public isLightWallpaper: boolean = false;
  public startPosition: Position = { x: 0, y: 0 };
  public endPosition: Position = { x: 0, y: 0 };
  public scaleX: number = 1;
  public scaleY: number = 1;
}