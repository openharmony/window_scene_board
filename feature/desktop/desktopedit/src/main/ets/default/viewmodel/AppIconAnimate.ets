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

import { AppIconItemData } from './OuterEditCenterObservedData';
import { curves, promptAction } from '@kit.ArkUI';
import { DesktopUtils, StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import EditModeStyleConstants from '../common/constants/EditModeStyleConstants';
import lazy { OuterIconCenterViewManager } from '@ohos/launchercommon/src/main/ets/manager/OuterIconCenterViewManager';

interface IconAnimParams {
  params: AnimateParam;
  scale: number;
};

export class AppIconAnimate {
  private mAnimateData: AppIconItemData = new AppIconItemData();

  /**
   * 初始化animate数据
   *
   * @param animateData 数据
   */
  public initData(animateData: AppIconItemData): void {
    this.mAnimateData = animateData;
  }

  /**
   * 缩放动效
   *
   * @param isZoomOut
   */
  public scaleAnimate(isZoomOut: boolean): void {
    let params: IconAnimParams = this.getPressAnimParams(isZoomOut);
    animateTo(params.params, () => {
      this.mAnimateData.iconAnimateScale = params.scale;
    });
  }

  /**
   * 获取动效参数
   * @param isZoomOut
   *
   * @returns 动效参数
   */
  public getPressAnimParams(isZoomOut: boolean): IconAnimParams {
    let params: IconAnimParams = {
      params: { playMode: PlayMode.Normal },
      scale: EditModeStyleConstants.OUTER_ICON_ANIM_SCALE
    };
    if (!isZoomOut) {
      params.params.duration = EditModeStyleConstants.OUTER_PRESS_ANIMATE_DURATION;
      params.params.curve = Curve.Friction;
      return params;
    }
    params.params.curve = curves.interpolatingSpring(EditModeStyleConstants.OUTER_INTER_POLATING_SPRING_VELOCITY,
      EditModeStyleConstants.OUTER_INTER_POLATING_SPRING_MASS,
      EditModeStyleConstants.OUTER_INTER_POLATING_SPRING_STIFFNESS,
      EditModeStyleConstants.OUTER_INTER_POLATING_SPRING_DAMPING);
    params.scale = StyleConstants.DEFAULT_LONG_PRESS_SCALE_90;
    return params;
  }

  /**
   * 触发点击动效
   *
   * @param appName 应用名
   * @param callBack 动效完成之后的回调
   */
  public startOnClickAnim(appName:string, callBack?: () => void): void {
    animateTo({ curve: curves.springMotion(EditModeStyleConstants.OUTER_ICON_SCALE_RESPONSE
      , EditModeStyleConstants.OUTER_ICON_SCALE_DAMPING_FRACTION), onFinish: () => {
      promptAction.showToast({ message: $r('app.string.add_outer_app_tips', appName)
        , bottom: EditModeStyleConstants.OUTER_SEARCH_BUTTON_MARGIN });
    }}, () => {
      this.mAnimateData.animateScale = 0;
    })
    // 大模糊
    animateTo({ curve: Curve.Sharp }, () => {
      this.mAnimateData.mBlur = EditModeStyleConstants.OUTER_ICON_MAX_BLUR;
    })
    if (callBack != undefined) {
      callBack();
    }
  }
}