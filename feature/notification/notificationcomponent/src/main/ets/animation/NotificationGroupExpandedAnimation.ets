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

import { AnimationBase, AnimationNames } from '@ohos/systemuicommon/newIndex';
import { curves } from '@kit.ArkUI';


/**
 * 组通知折叠展开动效
 *
 * @since 2024-11-11
 */
export class NotificationGroupExpandedAnimation extends AnimationBase {
  public static readonly duration = 333;
  public static readonly curve = curves.cubicBezierCurve(0.2, 0, 0.2, 1);

  constructor() {
    super(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION);
  }

  public getBriefTextAnimation(index: number): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.translate({ y: 50 * index + 35 })
        .animation({
          duration: NotificationGroupExpandedAnimation.duration,
          curve: NotificationGroupExpandedAnimation.curve
        })
        .combine(TransitionEffect.OPACITY.animation({
          delay: 60,
          duration: NotificationGroupExpandedAnimation.duration,
          curve: NotificationGroupExpandedAnimation.curve
        })),
      TransitionEffect.translate({ y: 50 * index + 35 })
        .animation({
          duration: NotificationGroupExpandedAnimation.duration,
          curve: NotificationGroupExpandedAnimation.curve
        })
        .combine(TransitionEffect.OPACITY.animation({ duration: 200, curve: NotificationGroupExpandedAnimation.curve }))
    );
  }

  public getContentTextAnimation(): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.translate({ y: -30 })
        .animation({
          duration: NotificationGroupExpandedAnimation.duration,
          curve: NotificationGroupExpandedAnimation.curve
        }).combine(
        TransitionEffect.OPACITY.animation({
          delay: 60,
          duration: NotificationGroupExpandedAnimation.duration,
          curve: NotificationGroupExpandedAnimation.curve
        })
      ),
      TransitionEffect.translate({ y: -30 })
        .animation({
          duration: NotificationGroupExpandedAnimation.duration,
          curve: NotificationGroupExpandedAnimation.curve
        }).combine(
        TransitionEffect.OPACITY.animation({
          duration: 200,
          curve: NotificationGroupExpandedAnimation.curve
        })
      )
    );
  }
}