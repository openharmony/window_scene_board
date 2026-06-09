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
import { SingletonHelper } from '@ohos/basicutils';
import { curves } from '@kit.ArkUI';


const TAG = 'BackgroundAnimManager';

export class BackgroundAnimConstants {

  /*
  背景转场曲线
  */
  public static readonly BACKGROUND_TRANSITION_CURVE: ICurve = curves.cubicBezierCurve(0.4, 0.0, 0.4, 1.0);

  /*
  背景转场持续时间
  */
  public static readonly BACKGROUND_TRANSITION_DURATION: number = 400;
}


/**
 * 状态栏背景动效管理
 */
class BackgroundAnimManager {
  /**
   * 获取背景转场转场效果
   *
   * @returns 返回对应的转场效果
   */
  public getTransitionEffect(): TransitionEffect {

    return TransitionEffect.OPACITY.animation(
      {
        duration: BackgroundAnimConstants.BACKGROUND_TRANSITION_DURATION,
        curve: BackgroundAnimConstants.BACKGROUND_TRANSITION_CURVE
      });
  }
}

// 单例
export let backgroundAnimManager: BackgroundAnimManager = SingletonHelper.getInstance(BackgroundAnimManager, TAG);