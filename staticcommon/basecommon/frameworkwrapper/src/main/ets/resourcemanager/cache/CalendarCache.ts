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
import image from '@ohos.multimedia.image';

export interface CalendarCache {
  // 获取动态日历图标
  getCalendarImage(bundleName: string): Promise<image.PixelMap | undefined>;
  getCalendarImageSync(bundleName: string): image.PixelMap | undefined;

  /**
   * 校验是否动态日历图标
   * @param bundleName 包名
   * @returns true|false 是|否
   */
  checkIsDynamicCalendarIcon(bundleName: string): boolean;

  /**
   * 直接获取日历缓存图标
   * @returns 日历缓存图标
   */
  getCalendarImageSyncWithoutCheck(): image.PixelMap | undefined;
}