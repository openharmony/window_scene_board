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
import { LiveNotification } from '../model/LiveNotification';
import { ILiveCapsuleVm } from './ILiveCapsuleVm';

/**
 * 播控VM
 */
export interface ILiveMediaPlayerVm extends ILiveCapsuleVm {
  /**
   * 播控图标切换黑色遮罩透明度
   */
  maskOpacity: number;
  /**
   * 切换前的播控Icon
   */
  oldMediaIcon?: image.PixelMap;
  /**
   * 切换前的播控Icon透明度
   */
  oldMediaIconOpacity: number;
  /**
   * 切换前的播控Icon OffsetX
   */
  oldMediaIconOffsetX: number;
  /**
   * 切换前的播控Icon OffsetY
   */
  oldMediaIconOffsetY: number;
  /**
   * 切换前的播控Icon缩放
   */
  oldMediaIconScale: ScaleOptions;
  /**
   * 切换后的播控Icon OffsetX
   */
  mediaIconOffsetX: number;
  /**
   * 切换后的播控Icon OffsetY
   */
  mediaIconOffsetY: number;
  /**
   * 切换后的播控Icon缩放
   */
  mediaIconScale: ScaleOptions;
  /**
   * 播控Icon圆形裁剪 24x24
   */
  mediaCircleShape: CircleShape;
  /**
   * 新增播控
   */
  addMedia(live: LiveNotification): void;
  /**
   * 更新播控
   */
  updateMedia(live: LiveNotification): Promise<void>;
}