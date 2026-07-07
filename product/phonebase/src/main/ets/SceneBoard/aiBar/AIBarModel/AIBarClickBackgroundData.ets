/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { CommonUtils } from '@ohos/basicutils';
import { SCBAiBarConstants } from '../SCBAiBarConstants';
import { gestureNavBarSettings } from '@ohos/gesturenavigation/src/main/ets/GestureNavBarSettings';

@Observed
export class AIBarClickBackgroundData {
  // ai导航条背板透明度
  public aiBarBackgroundOpacity_: number = 0;
  // ai导航条背板宽度
  public aiBarBackgroundWidth_: number = SCBAiBarConstants.AI_BAR_BACKGROUND_DEFAULT_WIDTH;
  // 导航条底板距离热区底部高度
  public aiBarBackgroundBottomDistance_: number =
    gestureNavBarSettings.getAiBarMarginBottom() - SCBAiBarConstants.AI_BAR_GAP_BETWEEN_BACKGROUND_AND_BAR;
  private static mInstance: AIBarClickBackgroundData;

  public static getInstance(): AIBarClickBackgroundData {
    if (AIBarClickBackgroundData.mInstance == null) {
      AIBarClickBackgroundData.mInstance = new AIBarClickBackgroundData();
    }
    return AIBarClickBackgroundData.mInstance;
  }

  public get aiBarBackgroundOpacity() {
    return this.aiBarBackgroundOpacity_;
  }

  public get aiBarBackgroundWidth() {
    return this.aiBarBackgroundWidth_;
  }

  public get aiBarBackgroundBottomDistance() {
    return this.aiBarBackgroundBottomDistance_;
  }

  public set aiBarBackgroundOpacity(aiBarBackgroundOpacity: number) {
    if (CommonUtils.equals(this.aiBarBackgroundOpacity_, aiBarBackgroundOpacity)) {
      return;
    }
    this.aiBarBackgroundOpacity_ = aiBarBackgroundOpacity;
  }

  public set aiBarBackgroundWidth(aiBarBackgroundWidth: number) {
    if (CommonUtils.equals(this.aiBarBackgroundWidth_, aiBarBackgroundWidth)) {
      return;
    }
    this.aiBarBackgroundWidth_ = aiBarBackgroundWidth;
  }


}