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

export enum ColorMode {
  COLOR_MODE_NOT_SET = -1,
  COLOR_MODE_DARK = 0,
  COLOR_MODE_LIGHT = 1,
}

/**
 * 设置项图标颜色变化事件
 */
export class ColorModeEvent {
  public static eventTypeName: string = 'ColorModeEvent';

  public colorMode?: ColorMode;
}