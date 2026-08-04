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
import { SCBNaviBarConstants } from '../SCBNaviBarConstants';
import { gestureNavBarSettings } from '@ohos/gesturenavigation/src/main/ets/GestureNavBarSettings';

@Observed
export class NAVIBarClickBackgroundData {
  // ai导航条背板透明度
  public naviBarBackgroundOpacity_: number = 0;
  // ai导航条背板宽度
  public naviBarBackgroundWidth_: number = SCBNaviBarConstants.NAVI_BAR_BACKGROUND_DEFAULT_WIDTH;
  // 导航条底板距离热区底部高度
  public naviBarBackgroundBottomDistance_: number =
    gestureNavBarSettings.getNaviBarMarginBottom() - SCBNaviBarConstants.NAVI_BAR_GAP_BETWEEN_BACKGROUND_AND_BAR;
  private static mInstance: NAVIBarClickBackgroundData;

  public static getInstance(): NAVIBarClickBackgroundData {
    if (NAVIBarClickBackgroundData.mInstance == null) {
      NAVIBarClickBackgroundData.mInstance = new NAVIBarClickBackgroundData();
    }
    return NAVIBarClickBackgroundData.mInstance;
  }

  public get naviBarBackgroundOpacity() {
    return this.naviBarBackgroundOpacity_;
  }

  public get naviBarBackgroundWidth() {
    return this.naviBarBackgroundWidth_;
  }

  public get naviBarBackgroundBottomDistance() {
    return this.naviBarBackgroundBottomDistance_;
  }

  public set naviBarBackgroundOpacity(naviBarBackgroundOpacity: number) {
    if (CommonUtils.equals(this.naviBarBackgroundOpacity_, naviBarBackgroundOpacity)) {
      return;
    }
    this.naviBarBackgroundOpacity_ = naviBarBackgroundOpacity;
  }

  public set naviBarBackgroundWidth(naviBarBackgroundWidth: number) {
    if (CommonUtils.equals(this.naviBarBackgroundWidth_, naviBarBackgroundWidth)) {
      return;
    }
    this.naviBarBackgroundWidth_ = naviBarBackgroundWidth;
  }


}