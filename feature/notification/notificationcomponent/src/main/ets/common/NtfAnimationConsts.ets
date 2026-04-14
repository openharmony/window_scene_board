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
import curves from '@ohos.curves';
import { RTLUtil } from '@ohos/componenthelper';

/**
 * 通知动效参数常量
 *
 * @since 2024-06-29
 */
export class NtfAnimationConsts {
  /**
   * 组通知折叠收起动效曲线
   */
  public static readonly GROUP_ITEM_EXPAND_CURVE: ICurve = curves.cubicBezierCurve(0.2, 0, 0.2, 1);
  /**
   * 组通知展开曲线
   */
  public static readonly GROUP_DETAIL_EXPAND_CURVE: ICurve = curves.interpolatingSpring(0, 1, 225, 25);
  /**
   * 更多通知折叠展开曲线
   */
  public static readonly EXTRA_NTF_EXPAND_CURVE: ICurve = curves.interpolatingSpring(0, 1, 228, 30);
  /**
   * 通知卡片转测动效曲线
   */
  public static readonly LIST_ITEM_TRANSITION_CURVE: ICurve = curves.interpolatingSpring(0, 1, 228, 28);
  /**
   * 第一条子通知标题展开时x轴方案位移距离
   */
  public static readonly GROUP_FIRST_TITLE_TRANSX: number = 44;
  /**
   * 第一条子通知标题展开时y轴方案位移距离
   */
  public static readonly GROUP_FIRST_TITLE_TRANSY: number = 20;
  /**
   * 第一条子通知标题展开动效时长
   */
  public static readonly GROUP_FIRST_TITLE_ANI_DURATION: number = 333;

  /**
   * 获取更多通知标题动画效果
   * @param isOverlay 是否为会话类通知
   * @param fontScale 字体大小
   * @param isGroupBrief 是否为组通知
   * @returns
   */
  public static getNtfGroupTitleTransition(isOverlay: boolean, fontScale: number,
    isGroupBrief: boolean): TransitionEffect {
    let transX = 0;
    if (!isOverlay) {
      transX =
        RTLUtil.isRTL() ? NtfAnimationConsts.GROUP_FIRST_TITLE_TRANSX : -NtfAnimationConsts.GROUP_FIRST_TITLE_TRANSX;
    }
    let transY = NtfAnimationConsts.GROUP_FIRST_TITLE_TRANSY * (1 + fontScale);
    if (!isGroupBrief) {
      transX = -transX;
      transY = -transY;
    }
    // 动效延迟40ms，防止文字与图标重叠
    return TransitionEffect.asymmetric(
      TransitionEffect.translate({ x: transX })
        .animation({
          delay: isGroupBrief ? 0 : 40,
          duration: NtfAnimationConsts.GROUP_FIRST_TITLE_ANI_DURATION,
          curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE,
        })
        .combine(TransitionEffect.translate({ y: transY })
          .animation({
            delay: isGroupBrief ? 40 : 0,
            duration: NtfAnimationConsts.GROUP_FIRST_TITLE_ANI_DURATION,
            curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE,
          })),
      TransitionEffect.translate({ x: transX })
        .animation({
          delay: isGroupBrief ? 40 : 0,
          duration: NtfAnimationConsts.GROUP_FIRST_TITLE_ANI_DURATION,
          curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE,
        })
        .combine(TransitionEffect.translate({ y: transY })
          .animation({
            delay: isGroupBrief ? 0 : 40,
            duration: NtfAnimationConsts.GROUP_FIRST_TITLE_ANI_DURATION,
            curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE,
          }))
    );
  }
}