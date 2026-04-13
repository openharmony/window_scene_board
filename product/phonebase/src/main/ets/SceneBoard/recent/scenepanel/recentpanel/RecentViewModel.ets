/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CommonConstants } from '@ohos/launchercommon';
import {
  SCBSceneContainerSession,
  SCBScenePanelManager } from '@ohos/windowscene/src/main/ets/TsIndex';
import { recentStateManagerInstance } from '../../innerstate/RecentStates';
import { RecentRuntimeModel } from './RecentRuntimeModel';
import { RecentTitleViewModel } from '../../viewmodel/RecentTitleViewModel';
import { RecentZoomAlarm } from './RecentZoomAlarm';
import { RecentGestureEventManager } from '../../common/RecentGestureEventManager';
import { RecentGestureEvent } from '../../common/constants/RecentGestureConstants';
import { RecentDockRefreshAlarm } from './RecentDockRefreshAlarm';
import { SceneBoardStateManager, CoreEventType } from '@ohos/frameworkwrapper/Index';
import { quickSwitchRequestActiveAlarm } from '../quickswitchpanel/QuickSwitchRequestActiveAlarm';
import { animateExBreak } from '@ohos/windowscene/Index';
import { ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';

const TAG = 'RecentViewModel';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class RecentViewModel {
  public static getInstance(): RecentViewModel {
    return SingletonHelper.getInstance(RecentViewModel, TAG);
  }

  /**
   * 生命周期onMinimizeScene中回调，适配多任务场景
   *
   * @param containerSession
   * @returns
   */
  public onMinimizeScene(containerSession: SCBSceneContainerSession): boolean {
    if (!containerSession) {
      log.showError('onMinimizeScene containerSession is null return')
      return false;
    }
    if (recentStateManagerInstance.isInRecentView()) {
      return true;
    }
    return false;
  }

  /**
   * onLockReceived回调适配多任务场景
   */
  public onLockReceived(): void {
    let containerSession = SCBScenePanelManager.getInstance().getSceneContainerSessionList().getTopActiveSession();
    if (containerSession) {
      containerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
      containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.DEFAULT_WINDOWS_RADIUS_0,
        TAG, 'onLockReceived', containerSession.getName());
      RecentGestureEventManager.getInstance()
        .deliverGestureEvent(RecentGestureEvent.ON_LOCK_RECEIVED, containerSession);
    }
    RecentRuntimeModel.getInstance().exit();
    RecentTitleViewModel.exit();
    SceneBoardStateManager.getInstance().consumeEvent(CoreEventType.EXIT_RECENT);
    RecentZoomAlarm.getInstance().restoreScale();
  }

  /**
   * 获取多任务或快切能显示的最大应用个数
   *
   * @returns 可显示的最大应用个数
   */
  public getMaxCount(): number {
    return Math.max(RecentRuntimeModel.getMaxCountsShowInRecent() -
    SCBScenePanelManager.getInstance().getFloatingSessionList().length, 0);
  }

  /**
   * onStartSceneFromOther中回调，适配多任务和快切的逻辑
   *
   */
  public onStartSceneFromOther(): void {
    quickSwitchRequestActiveAlarm.onAlarm();
  }

  /**
   * 退出应用时刷新最近任务区
   */
  public reFreshRecentDock(): void {
    RecentDockRefreshAlarm.getInstance().onAlarm();
  }

  /**
   * 退出应用时打断多任务动效
   */
  public interruptRecentAnimationWhenExitApp(): void {
    animateExBreak('enterAppIdleFromRecentFollowingAnimation', 'interruptRecentAnimationWhenExitApp');
  }

  /**
   * 应用界面手势第一帧回调
   */
  public onEnterZoomFollowing(): void {
    if (!ViewManagerPolicy.getViewController(ViewType.DESKTOP)?.isShowing()) {
      SCBScenePanelManager.getInstance().getBackgroundBlurSession().setBgBlurScale(0.99, 'showDesktopAndBlur');
    }
    ViewManagerPolicy.showView(ViewType.DESKTOP);
    ViewManagerPolicy.showView(ViewType.WALLPAPER);
  }
}

export const recentViewModel = RecentViewModel.getInstance();