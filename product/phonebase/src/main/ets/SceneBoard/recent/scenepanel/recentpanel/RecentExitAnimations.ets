/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { curves } from '@kit.ArkUI';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SingletonHelper } from '@ohos/basicutils';
import { RecentsStyleConstants, SCBScenePanelManager } from '@ohos/windowscene';
import { RecentStateManager, recentStateManagerInstance } from '../../innerstate/RecentStates';
import { homeViewModel } from '../homepanel/HomeViewModel';
import { RecentForegroundBlurAniMgr } from './RecentForegroundBlurAniMgr';

const TAG = 'RecentExitAnimations';

export class RecentExitAnimations {
  public static getInstance(): RecentExitAnimations {
    return SingletonHelper.getInstance(RecentExitAnimations, TAG);
  }

  /**
   * 桌面跟手反悔动效
   */
  public startExitHomeFollowing(): void {
    animateTo({
      curve: curves.springMotion(0.25, 1, 0),
      onFinish: () => {
        if (!RecentStateManager.getInstance().isRecentState()) {
          homeViewModel.exitFollowingFinishCallback();
        }
      }
    }, () => {
      homeViewModel.updateSceneContainerSessionWhenExit();
    })
  }

  /**
   * 跟手反悔时前景模糊动效
   */
  public startExitHomeFollowingForegroundBlur() {
    let containerSessionList = SCBScenePanelManager.getInstance().getSceneContainerSessionListForView();
    let listLen = containerSessionList.length;
    let index = listLen - 1;
    if (index >= 0 && !DeviceHelper.isFoldExpanded() &&
    RecentForegroundBlurAniMgr.getInstance().isForegroundEffectSupport()) {
      animateTo({
        curve: Curve.Smooth,
        duration: 180,
        onFinish: () => {
          if (!recentStateManagerInstance.isRecentState()) {
            containerSessionList[index]?.needRenderBlurRadius.reset();
          }
        }
      }, () => {
        RecentForegroundBlurAniMgr.getInstance()
          .startForegroundBlurAnimation(containerSessionList[index], RecentsStyleConstants.IN_OUT_RECENT_BLUR_RADIUS,
            true)
      });
    }
  }
}