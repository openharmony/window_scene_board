/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
 * search info
 */
export class SearchItemInfo {
  /**
   * Indicates app name.
   */
  public appName: string = '';

  /**
   * Indicates app icon.
   */
  public icon: string | image.PixelMap = '';

  /**
   * Indicates app bundleName.
   */
  public bundleName: string = '';

  /**
   * Indicates app abilityName.
   */
  public abilityName: string = '';

  /**
   * Indicates app location
   */
  public lcationId: number = 0;

  /**
   * Indicates app clickTime
   */
  public lastClickTime: number = 0;

  /**
   * Indicates app type
   */
  public contentType: string = '';

  /**
   * Indicates app identifier
   */
  public identifier: string = '';
}