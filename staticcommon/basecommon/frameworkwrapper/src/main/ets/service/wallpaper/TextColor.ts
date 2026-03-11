/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { WallpaperConstants } from '@ohos/commonconstants';
import effectKit from '@ohos.effectKit';

export class TextColor {
  mTextColor: string;
  mWallpaperType: number;

  constructor(color: effectKit.Color | string, shadowRadius: number, shadowDx: number, shadowDy: number, shadowAlpha: string, paperType: number) {
    if (typeof color === 'string') {
      this.mTextColor = color;
    } else {
      this.mTextColor = '#' + this.decToHex(color.red) + this.decToHex(color.green) + this.decToHex(color.blue);
    }
    this.mWallpaperType = paperType;
  }

  private decToHex(dec: number): string {
    let hex: string = (dec).toString(WallpaperConstants.NUMBER_16);
    let result: string = '00' + hex;
    result = result.substr(hex.length, result.length);
    return result;
  }
}