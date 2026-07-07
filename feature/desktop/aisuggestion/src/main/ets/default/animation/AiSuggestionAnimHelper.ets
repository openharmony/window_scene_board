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

import curves from '@ohos.curves';
import { ArrayUtils, CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { StyleConstants } from '@ohos/launchercommon';
import FormConstants from '@ohos/form/src/main/ets/default/common/constants/FormConstants';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';

const TAG = 'AiSuggestionAnimHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 动效工具
 *
 * @since 2024-02-29
 */
export class AiSuggestionAnimHelper {
  /**
   * 动画执行系数
   */
  private static readonly RATE_DURATION = 50;
  private static readonly TRANSLATE_APPEAR = '20px';
  private static readonly TRANSLATE_DISAPPEAR = '-20px';
  private static transitionCure: ICurve = curves.interpolatingSpring(0, 1, 336, 25);

  static getScaleByDimension(dimension: number, isOuter: boolean): number {
    let scale: number = 1;
    switch (dimension) {
      case FormDimension.Dimension_1_2:
      case FormDimension.Dimension_2_1:
        scale = StyleConstants.DEFAULT_LONG_PRESS_SCALE_90;
        break;
      case FormDimension.Dimension_2_2:
      case FormDimension.Dimension_2_4:
        scale = StyleConstants.DEFAULT_LONG_PRESS_SCALE_95;
        break;
      case FormDimension.Dimension_4_4:
        if (isOuter) {
          scale = StyleConstants.MENU_ANIMATION_TO_SCALE;
          break;
        }
      default:
        scale = StyleConstants.DEFAULT_LONG_PRESS_SCALE_95;
        break;
    }
    return scale;
  }

  static getCurveByDimension(dimension: number): curves.ICurve {
    let curve: curves.ICurve;
    switch (dimension) {
      case FormDimension.Dimension_1_2:
      case FormDimension.Dimension_2_1:
        curve = curves.interpolatingSpring(1, 1, 410, 38);
        break;
      case FormDimension.Dimension_2_2:
      case FormDimension.Dimension_2_4:
        curve = curves.interpolatingSpring(0.5, 1, 350, 35);
        break;
      case FormDimension.Dimension_4_4:
      default:
        curve = curves.interpolatingSpring(0, 1, 240, 28);
        break;
    }
    return curve;
  }

  /**
   * 根据服务类型和要刷新的索引获取转场动画
   *
   * @param item 推荐服务
   * @param index 服务索引
   * @param changedItemIdsSet 要刷新的服务ID集合
   * @param disappearLastIndex 上次刷新最晚消失的服务索引
   * @param iconSize 图标大小
   * @param formItemWidth 卡片宽度
   * @param formItemHeight 卡片高度
   * @returns 转场动画
   */
  static getTransition(item: LauncherRecItem, index: number, changedItemIdsSet: Set<string>,
    disappearLastIndex: number): TransitionEffect {
    if (CheckEmptyUtils.isEmpty(item) || item.bundleName === FormConstants.AI_SUGGESTION_BUNDLE_NAME ||
      item.itemType === AiSuggestionConstants.TYPE_APP_GROUP || index < 0 || ArrayUtils.isEmpty(changedItemIdsSet)) {
      log.showInfo('getTransition params inValid');
      return TransitionEffect.IDENTITY;
    }
    const recItemId = LauncherRecItem.getUniqueId(item);
    if (!changedItemIdsSet.has(recItemId)) {
      return TransitionEffect.IDENTITY;
    }
    const changeArr: string[] = Array.from(changedItemIdsSet);
    const startIndex = changeArr.indexOf(recItemId);
    // 计算上次刷新时最晚消失的服务动效时长
    let appearDelay: number = disappearLastIndex * AiSuggestionAnimHelper.RATE_DURATION;
    // 索引为0或者1出现delay时间太短，需要延迟等待旧的服务消失动效执行完
    if (changeArr.length <= 2 && (index === 0 || index === 1)) {
      appearDelay = 150;
    }
    if (item.itemType === AiSuggestionConstants.TYPE_APP) {
      return AiSuggestionAnimHelper.getAppTransitionEffect(startIndex, index, appearDelay);
    }
    return AiSuggestionAnimHelper.getFormTransitionEffect(index, appearDelay);
  }

  private static getAppTransitionEffect(startIndex: number, index: number, appearDelay: number): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({
        curve: AiSuggestionAnimHelper.transitionCure,
        delay: AiSuggestionAnimHelper.RATE_DURATION * startIndex + appearDelay,
      }).combine(
        TransitionEffect.translate({ y: AiSuggestionAnimHelper.TRANSLATE_APPEAR })
          .animation({
            curve: AiSuggestionAnimHelper.transitionCure,
            delay: AiSuggestionAnimHelper.RATE_DURATION * startIndex + appearDelay,
          })),
      TransitionEffect.OPACITY.animation({
        curve: AiSuggestionAnimHelper.transitionCure,
        delay: startIndex * AiSuggestionAnimHelper.RATE_DURATION,
      }).combine(
        TransitionEffect.translate({ y: AiSuggestionAnimHelper.TRANSLATE_DISAPPEAR })
          .animation({
            curve: AiSuggestionAnimHelper.transitionCure,
            delay: startIndex * AiSuggestionAnimHelper.RATE_DURATION,
          }))
    );
  }

  private static getFormTransitionEffect(index: number, appearDelay: number): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({
        curve: AiSuggestionAnimHelper.transitionCure,
        delay: index * AiSuggestionAnimHelper.RATE_DURATION + appearDelay,
      }).combine(
        TransitionEffect.translate({ y: AiSuggestionAnimHelper.TRANSLATE_APPEAR })
          .animation({
            curve: AiSuggestionAnimHelper.transitionCure,
            delay: index * AiSuggestionAnimHelper.RATE_DURATION + appearDelay,
          })),
      TransitionEffect.OPACITY.animation({
        curve: AiSuggestionAnimHelper.transitionCure,
        delay: index * AiSuggestionAnimHelper.RATE_DURATION
      }).combine(
        TransitionEffect.translate({ y: AiSuggestionAnimHelper.TRANSLATE_DISAPPEAR })
          .animation({
            curve: AiSuggestionAnimHelper.transitionCure,
            delay: index * AiSuggestionAnimHelper.RATE_DURATION
          }))
    );
  }
}