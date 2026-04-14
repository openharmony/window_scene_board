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

import { common2D } from '@kit.ArkGraphics2D';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';

const TAG = 'ClockTextBoundHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const REFERENCE_FONT_SIZE = 100;
const CLOCK_TEXTS = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':']

/**
 * 时钟Text调整的帮助类，其中会保存 时钟数字 在 各种字体下的 参考字号下的 内框（可视区域）与外框大小；
 * 同时提供对外接口，获取某字体下 某字号下 的内框与外框
 */
export class ClockTextBoundHelper {
  // 删除AI字体时，需要删除对应存储的数据，待处理
  private fontInnerBounds: Map<string, Map<string, common2D.Rect>> = new Map();
  private fontOuterBounds: Map<string, Map<string, common2D.Rect>> = new Map();

  /**
   * 获取指定字体下的指定字号，所有数字的最大中框，该框能够涵盖所有数字的有效区域；
   * 由于不同数字Text的外框宽度可能不同，内框宽度也可能不同，内框宽度的中心与外框宽度中心也可能不同，所以进行布局时，让中框的横向中心，与每个数字Text外框横向中心相同；
   * 有与不同数字Text的外框高度相同，所以最大中框纵向的top、bottom值，是相对于外框的数值；
   * @param fontFamily 字体
   * @param fontSize 字号
   * @returns 所有数字的最大中框，该中框能够涵盖所有数字的有效区域
   */
  public getMaxMiddleBound(fontFamily: string, fontSize: number): common2D.Rect | undefined {
    let maxMiddleBound: common2D.Rect = { left: 0, top: 1, right: 0, bottom: 1 };
    CLOCK_TEXTS.forEach((text) => {
      let middleBound = this.getMiddleBound(fontFamily, text, fontSize);
      if (!middleBound) {
        return;
      }

      if (text === '0') { // 有效初始化
        maxMiddleBound = middleBound;
        return;
      }

      if (maxMiddleBound.left > middleBound.left) {
        maxMiddleBound.left = middleBound.left;
      }
      if (maxMiddleBound.right < middleBound.right) {
        maxMiddleBound.right = middleBound.right;
      }
      if (maxMiddleBound.top > middleBound.top) {
        maxMiddleBound.top = middleBound.top;
      }
      if (maxMiddleBound.bottom < middleBound.bottom) {
        maxMiddleBound.bottom = middleBound.bottom;
      }
    })

    return maxMiddleBound;
  }

  /**
   * 获取指定字体的时钟数字在指定字号下的最大外框，也就是Text的大小
   * @param fontFamily 字体
   * @param fontSize 字号
   * @returns
   */
  public getMaxOuterBound(fontFamily: string, fontSize: number): common2D.Rect | undefined {
    let maxOuterBound: common2D.Rect = { left: 0, top: 1, right: 0, bottom: 1 };
    CLOCK_TEXTS.forEach((text) => {
      let outerBound = this.getOuterBound(fontFamily, text, fontSize);
      if (!outerBound) {
        return;
      }

      if (text === '0') { // 有效初始化
        maxOuterBound = outerBound;
        return;
      }

      if ((maxOuterBound.right - maxOuterBound.left < outerBound.right - outerBound.left)) {
        maxOuterBound.left = outerBound.left;
        maxOuterBound.right = outerBound.right;
      }
      if (maxOuterBound.top > outerBound.top) {
        maxOuterBound.top = outerBound.top;
      }
      if (maxOuterBound.bottom < outerBound.bottom) {
        maxOuterBound.bottom = outerBound.bottom;
      }
    })

    return maxOuterBound;
  }

  /**
   * 获取数字的middleBound，其含义是，以outerBound的中心为middleBound中心，且middleBound能够刚好包含innerBound
   * @param fontFamily 字体
   * @param text 时钟文本，数字或者分隔符
   * @param fontSize 字号
   * @returns 返回middleBound
   */
  public getMiddleBound(fontFamily: string, text: string, fontSize: number): common2D.Rect | undefined {
    let innerBound = this.geInnerBound(fontFamily, text, fontSize);
    let outerBound = this.getOuterBound(fontFamily, text, fontSize);
    if (!innerBound || !outerBound) {
      return undefined;
    }

    let middleBound: common2D.Rect = { left: 0, right: 0, top: innerBound.top, bottom: innerBound.bottom };
    let outerCenterX = (outerBound.left + outerBound.right) / 2;
    let halfWidth = Math.max(Math.abs(innerBound.left - outerCenterX), Math.abs(innerBound.right - outerCenterX));
    middleBound.left = outerCenterX - halfWidth;
    middleBound.right = outerCenterX + halfWidth;

    // 对中框周围保留冗余安全距离，避免AOD显示截断
    if (middleBound.left - 1 > outerBound.left) {
      middleBound.left -= 1;
    }
    if (middleBound.right + 1 < outerBound.right) {
      middleBound.right += 1;
    }
    if (middleBound.top - 1 > outerBound.top) {
      middleBound.top -= 1;
    }
    if (middleBound.bottom + 1 < outerBound.bottom) {
      middleBound.bottom += 1;
    }

    return middleBound;
  }

  /**
   * 获取指定字体的时钟数字在指定字号下的内框，也就是可视区域大小
   * @param fontFamily 字体
   * @param text 时钟数字字符
   * @param fontSize 字号
   * @returns
   */
  public geInnerBound(fontFamily: string, text: string, fontSize: number): common2D.Rect | undefined {
    if (!this.fontInnerBounds.get(fontFamily)) {
      this.computeInnerAndOuterBounds(fontFamily);
    }

    let fontInnerBound = this.fontInnerBounds.get(fontFamily);
    let textOfFontInnerBound = fontInnerBound?.get(text);
    if (!textOfFontInnerBound) {
      log.error(`clock text is ${text}, the outer bound does not exisit.`)
      return undefined;
    }

    let scale = fontSize / REFERENCE_FONT_SIZE;
    return {
      left: textOfFontInnerBound.left * scale,
      top: textOfFontInnerBound.top * scale,
      right: textOfFontInnerBound.right * scale,
      bottom: textOfFontInnerBound.bottom * scale,
    }
  }

  /**
   * 获取指定字体的时钟数字在指定字号下的外框，也就是Text的大小
   * @param fontFamily 字体
   * @param text 时钟数字字符
   * @param fontSize 字号
   * @returns
   */
  public getOuterBound(fontFamily: string, text: string, fontSize: number): common2D.Rect | undefined {
    if (!this.fontOuterBounds.get(fontFamily)) {
      this.computeInnerAndOuterBounds(fontFamily);
    }

    let fontOuterBound = this.fontOuterBounds.get(fontFamily);
    let textOfFontOuterBound = fontOuterBound?.get(text);
    if (!textOfFontOuterBound) {
      log.error(`clock text is ${text}, the outer bound does not exisit.`)
      return undefined;
    }

    let scale = fontSize / REFERENCE_FONT_SIZE;
    return {
      left: textOfFontOuterBound.left * scale,
      top: textOfFontOuterBound.top * scale,
      right: textOfFontOuterBound.right * scale,
      bottom: textOfFontOuterBound.bottom * scale,
    }
  }

  private computeInnerAndOuterBounds(fontFamily: string): void {
    log.showInfo(`computeInnerAndOuterBounds for fontFamily ${fontFamily}`);
    let innerMap: Map<string, common2D.Rect> = new Map();
    let outerMap: Map<string, common2D.Rect> = new Map();


    this.fontInnerBounds.set(fontFamily, innerMap);
    this.fontOuterBounds.set(fontFamily, outerMap);
  }
}

export let clockTextBoundHelper: ClockTextBoundHelper = SingletonHelper.getInstance(ClockTextBoundHelper, TAG);