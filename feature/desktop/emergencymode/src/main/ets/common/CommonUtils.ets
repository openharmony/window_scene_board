/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { DialogConstants } from './CommonConstants';
import measure from '@ohos.measure';

const TAG = 'CommonUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * CommonUtils
 */
export class CommonUtils {
  /**
   * 计算行数
   */
  public static calTextLines(text: Resource, fontSize: number, fontWeight: FontWeight, lineWidth: number): number {
    let textWidth: number = Math.round(px2vp(measure.measureText({
      textContent: text,
      fontSize: (fontSize) + 'vp',
      lineHeight: DialogConstants.ENTER_TITLE_LINE_HEIGHT,
      fontWeight: fontWeight
    })));
    let lines: number = 0;
    if (lineWidth <= 0 || textWidth <= 0) {
      return lines;
    }
    while (textWidth != 0) {
      if (textWidth > lineWidth) {
        textWidth = textWidth - lineWidth;
      } else {
        textWidth = 0;
      }
      lines++;
    }
    return lines;
  }

}