/**
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

/**
 * GestureNavBar参数
 */
export class GestureNavBarConstants {
  // AiBar距离屏幕底部的距离
  public static readonly AIBAR_DEFAULT_BOTTOM_MARGIN = 6;
}

export enum OneStepState {
  DEFAULT,
  // only show bg
  SHOW_ONLY_BG,
  // show bg and icon
  SHOW_BG_AND_ICON,
  // enter split
  ENTER_SPLIT,
  // enter floating
  ENTER_FLOATING,
  // enter mid-scene
  ENTER_MID_SCENE
}

const TAG = 'OneStepStateManager';

class OneStepStateManager {
  private state_: OneStepState = OneStepState.DEFAULT;

  public reset(): void {
    this.state_ = OneStepState.DEFAULT;
  }

  public set state(newState: OneStepState) {
    this.state_ = newState;
  }

  public isEnter(): boolean {
    let isEnterSplit = this.state_ === OneStepState.ENTER_SPLIT;
    let isEnterMidScene = this.state_ === OneStepState.ENTER_MID_SCENE;
    let isEnterFloating = this.state_ === OneStepState.ENTER_FLOATING;
    return isEnterSplit || isEnterMidScene || isEnterFloating;
  }
}

export const oneStepStateManagerInstance = SingletonHelper.getInstance(OneStepStateManager, TAG);