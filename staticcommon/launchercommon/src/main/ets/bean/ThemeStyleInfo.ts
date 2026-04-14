/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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

/**
 * Theme style info.
 */
export class ThemeStyleInfo {
  /**
   * Indicates icon size scale number.
   */
  public iconSizeScale?: number;

  /**
   * Indicates radius size scale number.
   */
  public radiusSizeScale?: number;

  /**
   * Indicates whether show icon name.
   */
  public isShowName: boolean = true;

  /**
   * 图标资源路径
   */
  public iconResourcePath?: string;
}