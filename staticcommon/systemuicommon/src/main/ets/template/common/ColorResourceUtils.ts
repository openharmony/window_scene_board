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

import resourceManager from '@ohos.resourceManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'ColorResourceUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

/**
 * 资源工具类。
 */
export class ColorResourceUtils {
  constructor(rsManager: resourceManager.ResourceManager) {
    this.rsManager = rsManager;
  }

  // 16进制
  private static readonly HEX_NUMBER: number = 16;

  private static readonly HEX_COLOR_PREFIX: string = `#`;

  // 资源管理器对象
  private rsManager: resourceManager.ResourceManager;

  /**
   * 获取颜色资源的 HEX 字符串格式（#FFFFFFFF）的颜色值
   *
   * @param r 资源对象
   * @returns 要获取的颜色资源的 HEX 字符串格式（#FFFFFFFF）的颜色值 string 对象
   */
  public getColorHexByResource(r: Resource): string {
    let resStr = ColorResourceUtils.HEX_COLOR_PREFIX;
    try {
      resStr += this.rsManager.getColorSync(r.id)?.toString(ColorResourceUtils.HEX_NUMBER);
    } catch (error) {
      log.showError(`getColorHexByResource error:${error}`);
    }
    return resStr;
  }

  public getArrayColor(resource: Resource): number[] {
    log.showInfo('start getArrayColor');
    let strColor: string = this.getColorHexByResource(resource);
    let arrayColor: number[] = [];
    if (strColor?.length === 7) {
      arrayColor[0] = parseInt(strColor.substring(1, 3), 16);
      arrayColor[1] = parseInt(strColor.substring(3, 5), 16);
      arrayColor[2] = parseInt(strColor.substring(5), 16);
    } else if (strColor?.length === 9) {
      arrayColor[0] = parseInt(strColor.substring(3, 5), 16);
      arrayColor[1] = parseInt(strColor.substring(5, 7), 16);
      arrayColor[2] = parseInt(strColor.substring(7), 16);
      arrayColor[3] = parseInt(strColor.substring(1, 3), 16) / 255;
    } else {
      return [0, 0, 0];
    }
    return arrayColor;
  }
}