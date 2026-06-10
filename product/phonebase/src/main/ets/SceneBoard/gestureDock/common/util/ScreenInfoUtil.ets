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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RotationConstants } from '@ohos/commonconstants';
import { SCBScreenProperty } from '@ohos/windowscene';
import display from '@ohos.display';

const TAG = 'ScreenInfoUtils';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * 屏幕信息工具类
 */
export class ScreenInfoUtil {
  /**
   * isVertical
   *
   * @param screenProperty: SCBScreenProperty
   * @returns isVertical
   */
  public static isVertical(screenProperty: SCBScreenProperty): boolean {
    return screenProperty.rotation === RotationConstants.ROTATION_0 ||
      screenProperty.rotation === RotationConstants.ROTATION_360;
  }

  /**
   * 挖孔是否在屏幕的左侧
   *
   * @param rect
   * @param display
   * @returns isCutOutLeft
   */
  public static isCutOutLeft(rect: display.Rect, display: display.Display): boolean {
    if (rect.left > display.width / 4) {
      return false;
    }
    if (rect.top < display.height / 4 || rect.top > display.height * 3 / 4) {
      // 当摄像头在左上角,左下角不留挖孔
      return false;
    }
    return true;
  }

  /**
   * 挖孔是否在屏幕的右侧
   *
   * @param rect
   * @param display
   * @returns isCutOutRight
   */
  public static isCutOutRight(rect: display.Rect, display: display.Display): boolean {
    if (rect.left < display.width * 3 / 4) {
      return false;
    }
    if (rect.top < display.height / 4 || rect.top > display.height * 3 / 4) {
      // 当摄像头在右上角,右下角不留挖孔
      return false;
    }
    return true;
  }

  /**
   * 挖孔是否在屏幕的底部中间
   *
   * @param rect
   * @param display
   * @returns isCutOutBottom
   */
  public static isCutOutBottom(rect: display.Rect, display: display.Display): boolean {
    if (rect.top < display.height * 3 / 4) {
      return false;
    }
    if (rect.left < display.width / 4 || rect.left > display.width * 3 / 4) {
      return false;
    }
    return true;
  }
}