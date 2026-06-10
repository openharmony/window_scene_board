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
import { common2D } from '@kit.ArkGraphics2D';
import { UseScene } from '../../common/adapter/Constans';
import { ClockAdapterFactory } from '../adapter/ClockAdapter';

const TAG = 'ScreenLock-LayoutModifierUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 时钟布局动态调整类，主要是根据不同字体的可视区域不同，动态调整时钟文字的大小、位置，满足设计的同时避免截断、重叠
 */
export class LayoutModifierUtil {

  /**
   * 计算所有元素（艺术文字、时钟、日期、农历、星期）的外框
   * @returns 所有元素的外框
   */
  public static computeWholeBound(): common2D.Rect | undefined {
    let visibleRectsOfClock = ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE).getClockWidgetModel()
      .getClockLayoutModifier().getVisibleRectsInParent();

    let wholeBound: common2D.Rect = {left: Number.MAX_VALUE, top: Number.MAX_VALUE, right: 0, bottom: 0};
    let visibleRectsArr = [visibleRectsOfClock];
    visibleRectsArr.forEach(visibleRects => {
      visibleRects.forEach(visibleRect => {
        wholeBound.left = Math.min(wholeBound.left, visibleRect.left);
        wholeBound.top = Math.min(wholeBound.top, visibleRect.top);
        wholeBound.right = Math.max(wholeBound.right, visibleRect.right);
        wholeBound.bottom = Math.max(wholeBound.bottom, visibleRect.bottom);
      })
    });

    if (wholeBound.left > wholeBound.right || wholeBound.top > wholeBound.bottom) {
      return undefined;
    }
    return wholeBound;
  }
}