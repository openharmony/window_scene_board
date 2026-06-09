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

import { Log, CheckEmptyUtils } from '@ohos/basicutils';
import { MeasureUtils, UIContext } from '@kit.ArkUI';
import { MeasureOptions } from '@ohos.measure';
import type ctx from '@ohos.app.ability.common';
import {
  GlobalContext,
} from '@ohos/frameworkwrapper';
import { FileFolderStyleConstants } from '../common/FileFolderStyleConstants';

const TAG = 'RenameUtil';
const HEX_7F = 0x007f;
const HEX_7FF = 0x07ff;
const HEX_FFFF = 0xffff;
const NUM_2 = 2;
const NUM_3 = 3;
const NUM_4 = 4;

export class RenameUtil {
  public static strSizeUTF8(str: string): number {
    if (!str) {
      Log.showInfo(TAG, 'strSizeUTF8 str is null or undefined');
      return 0;
    }
    let strLen = str.length;
    let bytesLen = 0;
    for (let i = 0; i < strLen; i++) {
      let charCode = str.charCodeAt(i);
      if (charCode <= HEX_7F) {
        bytesLen++;
      } else if (charCode <= HEX_7FF) {
        bytesLen += NUM_2;
      } else if (charCode <= HEX_FFFF) {
        bytesLen += NUM_3;
      } else {
        bytesLen += NUM_4;
      }
    }
    return bytesLen;
  }

  /**
   * 计算重命名输入框 textArea组件的高度
   * @param maxWidth  textArea组件的最大宽度，用于计算换行
   * @param textContent textArea文本内容
   * @param fontSize 字体大小
   * @param uiContext  用于获取getMeasureUtils字体测算工具
   * @param minHeight textArea组件的最小高度
   * @param fontWeight 字体粗细
   * @param padding  textArea的内边距，number类型数据
   * @param borderWidth 边框宽度
   * @returns
   */
  public static calcTextAreaHeight(maxWidth: number, textContent: string, fontSize: number, uiContext: UIContext,
    minHeight: number = FileFolderStyleConstants.TEXTAREA_MIN_HEIGHT,
    fontWeight: FontWeight = FileFolderStyleConstants.TEXTAREA_FONT_WEIGHT,
    padding: Padding = FileFolderStyleConstants.TEXTAREA_PADDING,
    borderWidth: number = FileFolderStyleConstants.TEXTAREA_BORDER_WIDTH): number {
    let height: number = minHeight;
    if (CheckEmptyUtils.isEmpty(textContent) || CheckEmptyUtils.isEmpty(fontSize) ||
      CheckEmptyUtils.isEmpty(fontWeight)  || !uiContext) {
      return height;
    }
    const paddingLeft: number = (padding.left ?? 0) as number;
    const paddingRight: number = (padding.right ?? 0) as number;
    const paddingTop: number = (padding.top ?? 0) as number;
    const paddingBottom: number = (padding.bottom ?? 0) as number;
    // 设置里修改字体大小后，桌面主动转px，避免arkUI底层时序问题
    let serviceContext = GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext
    const fontSizeScale = vp2px(fontSize) * (serviceContext?.config?.fontSizeScale ?? 1) + 'px';
    let measureUtils: MeasureUtils = uiContext.getMeasureUtils();
    const measureOptions: MeasureOptions = {
      textContent: textContent,
      fontSize: fontSizeScale,
      fontWeight: FontWeight.Medium,
      // 文字宽度 = 组件宽度 - 左右padding - 左右border
      constraintWidth: maxWidth - paddingLeft - paddingRight - borderWidth * 2,
      textAlign: TextAlign.Center
    }
    const measureTextHeight = measureUtils.measureTextSize(measureOptions).height as number;
    // 文字高度 + 上下padding + 上下border
    const measureHeight = Math.round(px2vp(measureTextHeight)) + paddingTop + paddingBottom + borderWidth * 2;
    height = Math.max(height, measureHeight);
    Log.showDebug(TAG, `calcTextAreaHeight ${measureHeight}. ${measureTextHeight}`);
    return height;
  }
}