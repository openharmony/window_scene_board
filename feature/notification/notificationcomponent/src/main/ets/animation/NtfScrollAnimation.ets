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

import { LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import { NotificationAnimationParas } from '../common/NotificationAnimationParas';
import { NotificationConstants } from '../common/NotificationConstants';
import { NotificationEntry } from '../model/NotificationEntry';
import { ItemUtils } from '@ohos/componenthelper/src/main/ets/TsIndex';

const TAG = 'NtfScrollAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const DEFAULT_CENTER_Y = '50';

/**
 * 通知列表滑动动效
 *
 * @since 2024-10-17
 */
export class NtfScrollAnimation {
  public static listRect: RectInfo = ItemUtils.getRectById(NotificationConstants.NTF_LIST_ROW_ID);
  /**
   * 校验缓慢下滑或几乎不动时（滑动距离小于0.4），卡片位移是否过大（大于1），位移过大会导致卡片闪跳
   * 如果位移过大，则固定移动距离为1
   *
   * @param itemScrollOffset 滑动距离
   * @param animationPara 动效参数
   * @param positionYDiff 卡片最终偏移量
   * @returns 偏移量
   */
  public getCorrectPositionYDiff(itemScrollOffset: number, animationPara: NotificationAnimationParas | undefined,
    positionYDiff: number): number {
    if (!animationPara || animationPara.clearAnimOpacity === 0) {
      return positionYDiff;
    }
    const ntfItemTranslateY = animationPara.ntfItemTranslateY;
    if (this.checkIsTranslateYInvalid(itemScrollOffset, ntfItemTranslateY, positionYDiff)) {
      return itemScrollOffset > 0 ? ntfItemTranslateY + 1 : ntfItemTranslateY - 1;
    }
    return positionYDiff;
  }

  private checkIsTranslateYInvalid(itemScrollOffset: number, ntfItemTranslateY: number,
    positionYDiff: number): boolean {
    const offset = Math.abs(itemScrollOffset);
    if (offset === 0 || offset >= 0.4) {
      return false;
    }
    if (Math.abs(ntfItemTranslateY - positionYDiff) <= 1) {
      return false;
    }
    return true;
  }

  public getClipParam(ntfAniParameters: NotificationAnimationParas, ntfEntry: NotificationEntry | undefined,
    isClearAll: boolean, radius: number, isSlimDown: boolean): RectAttribute | boolean {
    const isBottom: boolean = ntfAniParameters?.isBottomItem;
    if (!isBottom) {
      return true;
    }
    const outScale: number = ntfAniParameters?.clearAnimScale ?? 1;
    const outScaleCenterY: string | number = ntfAniParameters?.ntfItemRotateCenterY ?? DEFAULT_CENTER_Y;
    const groupItemArea = ntfAniParameters?.clipArea;
    const rectHeight = Number(groupItemArea?.height);
    const rectTop = Number(groupItemArea?.globalPosition.y);
    const rectBottom = Number(groupItemArea?.globalPosition?.y) + Number(groupItemArea?.height);
    const shouldUpdate = (rectHeight ?? 0) > NotificationConstants.NTF_MAX_HEIGHT_THRESHOLD;
    const clipHeightConst = ntfEntry?.isLiveType() ? NotificationConstants.LIVE_VIEW_MAX_HEIGHT_THRESHOLD :
    NotificationConstants.NTF_MAX_HEIGHT_THRESHOLD;
    if (outScale < 1 && shouldUpdate && !isClearAll) {
      if (ntfEntry?.isLiveType() && ((rectHeight ?? 0) <= clipHeightConst)) {
        // 不带按钮的实况
        return true;
      }
      if (outScaleCenterY === '0%') {
        // 处理堆叠态底部裁剪
        return new Rect({ width: '100%', height: clipHeightConst, radius: radius });
      } else {
        // 处理堆叠态顶部裁剪
        return new Rect({ width: '100%', height: clipHeightConst, radius: radius })
          .position({ y: rectHeight! - clipHeightConst });
      }
    } else if ((rectTop < NtfScrollAnimation.listRect.top || rectBottom > NtfScrollAnimation.listRect.bottom) &&
        shouldUpdate) {
        // 最大字体情况下，处理非堆叠态超高卡片超出列表范围裁剪
      const clipHeight: number = rectTop < NtfScrollAnimation.listRect.top ?
        (rectBottom > NtfScrollAnimation.listRect.bottom ? NtfScrollAnimation.listRect.height ?? 0 :
          rectBottom - NtfScrollAnimation.listRect.top) : NtfScrollAnimation.listRect.bottom - rectTop;
      const clipHeightExpand: number = 1;
      if (clipHeight < NotificationConstants.NTF_MAX_HEIGHT_THRESHOLD) {
        return true;
      } else if (isSlimDown || ntfAniParameters?.ntfItemTranslateX !== 0) {
        // 有缩放或者横滑才裁切
        return new Rect({
          width: '100%',
          height: clipHeight * clipHeightExpand,
          radius: radius
        }).position({ y: rectTop < NtfScrollAnimation.listRect.top ? NtfScrollAnimation.listRect.top - rectTop : 0 });
      }
      return true;
    } else {
      // 通知列表中裁剪
      return true;
    }
  }
}