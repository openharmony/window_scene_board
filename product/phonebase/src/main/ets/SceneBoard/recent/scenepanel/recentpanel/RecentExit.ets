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

import {
  LogHelper,
  LogDomain,
  TraceUtil,
  DomainName
} from '@ohos/basicutils';
import {
  SCBScenePanelManager,
  SCBSceneContainerSession,
  SCBSessionShowInScreenIndex,
  RecentsStyleConstants,
  SCBContainerRotationReason,
  SCBTransitionManager,
  ScenePanelState
} from '@ohos/windowscene';
import { RecentExitCallback } from './RecentCallbacks';
import { recentRuntimeInstance } from './RecentRuntimeModel';
import systemParameter from '@ohos.systemParameterEnhance';
import curves from '@ohos.curves';
import { RecentLayoutManager } from '../../common/RecentLayoutManager';
import { recentLayoutConfigInstance } from '@ohos/recents';
import { SCBScenePanelViewModel } from '../../../scenemanager/viewmodel/SCBScenePanelViewModel';
import { RecentGestureEventManager } from '../../common/RecentGestureEventManager';
import { RecentGestureEvent } from '../../common/constants/RecentGestureConstants';
import { RotateFuncType } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSessionManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { UIExceptionDetection, UIExceptionCaller } from '@ohos/windowscene/Index';

const TAG = 'RecentExit';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class RecentExit {
  private readonly panelManager: SCBScenePanelManager;
  private isNewStyle = (systemParameter.getSync('sceneboard.isNewStyle', 'true') === 'true');

  constructor(panelManager: SCBScenePanelManager) {
    this.panelManager = panelManager;
  }

  public recordExitRecentLog(): void {
    TraceUtil.traceOnce(DomainName.RECENT, TraceUtil.CORE_METHOD_EXIT_RECENT);
    log.showWarn(`exit recent to home. viewParam:  ${this.panelManager.getViewParam().toString()}`);
  }

  public exitRecentWithoutAnimation(callback: RecentExitCallback, isFollowing: boolean = false) {
    this.panelManager.onBlurTransitionInactive();
    log.showInfo(`exitRecent isFollowing ${isFollowing}`);
    let containerSessionList = isFollowing ?
    SCBScenePanelManager.getInstance().getSceneContainerSessionList() : recentRuntimeInstance.notRemovingSessionList;
    containerSessionList.forEach((sceneContainerSession) => {
      if (sceneContainerSession && sceneContainerSession.needRenderShowInRecent.showInRecent) {
        if (!(sceneContainerSession.isFloat && sceneContainerSession.isActive)) {
          sceneContainerSession.requestBackground();
        }
        sceneContainerSession.init();
        sceneContainerSession.needRenderVisibility.setVisibilityWithDfx(false, TAG, 'init',
          sceneContainerSession.getName());
        sceneContainerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
      }
    });
    callback.exitRecentWithoutAnimationFinish();
  }

  public exitRecentWithAnimation(scenePanel: SCBScenePanelViewModel, currentOffsetX: number,
    isScrolling: boolean | undefined): void {
    let distance = this.getContainerMoveDistance(currentOffsetX);
    let exitAnimationCount = 0;
    RecentGestureEventManager.getInstance().deliverGestureEvent(RecentGestureEvent.ENTER_HOME_IDLE_START);
    recentRuntimeInstance.notRemovingSessionList.forEach((sceneContainerSession, idx) => {
      // 退出多任务悬浮窗的动效交由悬浮窗自己完成
      if (!sceneContainerSession || !sceneContainerSession.needRenderShowInRecent.showInRecent ||
      sceneContainerSession.isFloat) {
        return;
      }
      this.resetSessionParam(sceneContainerSession);
      let column = recentRuntimeInstance.getAbsoluteColumn(idx);
      let curPos = RecentLayoutManager.getSessionContainerRelativePos(column);
      let callerName: string = 'exitRecentWithAnimation';
      if (curPos === SCBSessionShowInScreenIndex.INDEX_NONE) {
        sceneContainerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, callerName);
        sceneContainerSession.needRenderVisibility.setVisibility(false);
        if (!isScrolling) {
          scenePanel.sceneContainerTransitionReset(sceneContainerSession);
        }
        sceneContainerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
        return;
      }
      let dfxName = sceneContainerSession.getName();
      let positionX = this.getExitFinalPositionX(column);
      sceneContainerSession.needRenderTranslate.setTranslateXWithDfx(distance + positionX, TAG, callerName, dfxName);
      let param = this.getContainerOutAnimParam(curPos);
      sceneContainerSession.addTransitionCount();
      SCBTransitionManager.getInstance().addStartExitAnimationCount(callerName);
      let animationNum = sceneContainerSession.getTransitionCount();
      exitAnimationCount++;
      param.onFinish = () => {
        exitAnimationCount--;
        SCBTransitionManager.getInstance()
          .reduceStartExitAnimationCount('exitRecentWithAnimation end');
        if (exitAnimationCount === 0) {
          scenePanel.checkIfNeedRecoverScreenProperty(RotateFuncType.EXIT_SCENE);
          if (scenePanel.isHomeState()) {
            UIExceptionDetection.getInstance().backgroundBlurExceptionDetection(UIExceptionCaller.RECENT_EXIT_TO_HOME);
          }
        }
        if (!scenePanel.isRecentState()) {
          sceneContainerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, callerName, dfxName);
          sceneContainerSession.needRenderShowRecentTitle.setShowRecentTitle(false);
          sceneContainerSession.transitionOutFinishIfNeed(animationNum, false);
          log.showInfo(`exitRecentAnimCnt:${exitAnimationCount} column:${column}`);
          if (exitAnimationCount === 0) {
            scenePanel.resetDesktopAfterExitRecent();
            scenePanel.exitSceneWithRotationRecover(undefined, SCBContainerRotationReason.EXIT_RECENT);
            RecentGestureEventManager.getInstance().deliverGestureEvent(RecentGestureEvent.ENTER_HOME_IDLE_END);
          }
        }
      };
      animateTo(param, () => {
        sceneContainerSession.needRenderTranslate.setTranslateXWithDfx(positionX, TAG,
          'exitRecentWithAnimation', dfxName);
      })
    });
    log.showInfo('exitRecent exitAnimationCount = ' + exitAnimationCount);
    if (exitAnimationCount === 0) {
      scenePanel.resetDesktopAfterExitRecent();
      scenePanel.exitSceneWithRotationRecover(undefined, SCBContainerRotationReason.EXIT_RECENT);
    } else {
      scenePanel.updateScreenRotationPropertyForExit();
    }
  }

  public resetSessionParam(sceneContainerSession: SCBSceneContainerSession) {
    if (!sceneContainerSession) {
      return;
    }
    sceneContainerSession.needRenderPos.setPosXWithDfx(0, TAG, 'resetSessionParam');
    sceneContainerSession.needRenderZIndex.resetZIndex();
    if (!(sceneContainerSession.isFloat && sceneContainerSession.isActive)) {
      sceneContainerSession.requestBackground();
    }
  }

  public getContainerMoveDistance(currentOffsetX: number): number {
    let isNeedChangeToMultiRow = recentLayoutConfigInstance.isNeedMultiRowLayout();
    let currSession = this.getSessionInMiddleColumn(isNeedChangeToMultiRow);
    if (!currSession) {
      return 0;
    }
    log.showInfo(`exit recent current xOffset is ${currentOffsetX}`);
    let screenProperty = this.panelManager.getScreenProperty();
    let recentScale = RecentLayoutManager.getScale(screenProperty);
    let screenWidth = px2vp(screenProperty.width);
    let extraOffsetX = this.getExtraOffsetX(screenWidth * recentScale);
    let recentMargin = RecentLayoutManager.getWidthSpace();
    let leftMargin = RecentLayoutManager.getLeftMargin(screenProperty);
    let cardWidth = RecentLayoutManager.getCardWidth(screenProperty);
    let diffOffsetAndPosX = currSession.needRenderPos.posX - currentOffsetX;
    if (isNeedChangeToMultiRow && recentRuntimeInstance.containerCountsShowInRecent <= 2) {
      // 双行情况下，只有两张以下卡片时，当前卡片显示在右侧，不是中间列，算法有差异
      return diffOffsetAndPosX + leftMargin + cardWidth + extraOffsetX;
    }
    return diffOffsetAndPosX + leftMargin + cardWidth * 2 + recentMargin + extraOffsetX;
  }

  private getSessionInMiddleColumn(isMultiRow: boolean): SCBSceneContainerSession {
    let currColumn = recentRuntimeInstance.autoCenterColumn;
    if (isMultiRow) {
      return recentRuntimeInstance.notRemovingSessionList[Math.min(currColumn * 2,
        recentRuntimeInstance.notRemovingSessionList.length - 1)];
    } else {
      return recentRuntimeInstance.notRemovingSessionList[currColumn];
    }
  }

  private getExtraOffsetX(cardWidth: number): number {
    return recentLayoutConfigInstance.isNeedMultiRowLayout() ?
      cardWidth * RecentsStyleConstants.EXTRA_EXIT_RECENT_MOVE_DISTANCE : 0;
  }

  public getExitFinalPositionX(sessionColumn: number): number {
    let screenProperty = this.panelManager.getScreenProperty();
    let recentScale = RecentLayoutManager.getScale(screenProperty);
    let screenWidth = px2vp(screenProperty.width);
    let recentMargin = RecentLayoutManager.getWidthSpace();
    let extraOffsetX = this.getExtraOffsetX(screenWidth * recentScale);
    let column = sessionColumn;
    if (recentLayoutConfigInstance.isNeedMultiRowLayout() && recentRuntimeInstance.containerCountsShowInRecent <= 2) {
      // 双行情况下，只有两张以下卡片时，卡片显示在右侧，最终位置需要当第1列来计算，不能按照第0列计算
      column = 1;
    }
    return (column - recentRuntimeInstance.autoCenterColumn - 2) * screenWidth * recentScale +
      (column - recentRuntimeInstance.autoCenterColumn - 1) * recentMargin -
      (1 - recentScale) * screenWidth / 2 - extraOffsetX;
  }

  public getContainerOutAnimParam(curPos: number): AnimateParam {
    return recentLayoutConfigInstance.isNeedMultiRowLayout() ? this.getSessionContainerOutAnimInMultiRow(curPos) :
      this.getSessionContainerOutAnimInSingleRow(curPos)
  }

  private getSessionContainerOutAnimInMultiRow(curPos: number): AnimateParam {
    let param: AnimateParam = {};
    if (this.isNewStyle) {
      param = {
        finishCallbackType: FinishCallbackType.LOGICALLY
      }
      switch (curPos) {
        case SCBSessionShowInScreenIndex.INDEX_LEFT:
          param.curve = curves.springMotion(0.314, 1, 0);
          break;
        case SCBSessionShowInScreenIndex.INDEX_MIDDLE:
          param.curve = curves.springMotion(0.363, 1, 0);
          break;
        case SCBSessionShowInScreenIndex.INDEX_RIGHT:
          param.curve = curves.springMotion(0.41, 0.99, 0);
          break;
      }
    } else {
      param = {
        duration: 400,
        delay: 0,
        curve: Curve.Linear
      }
    }
    return param;
  }

  private getSessionContainerOutAnimInSingleRow(curPos: number): AnimateParam {
    let param: AnimateParam = {};
    if (this.isNewStyle) {
      switch (curPos) {
        case SCBSessionShowInScreenIndex.INDEX_LEFT:
          param = {
            duration: 400,
            delay: 0,
            curve: Curve.Friction
          }
          break;
        case SCBSessionShowInScreenIndex.INDEX_MIDDLE:
          param = {
            duration: 400,
            delay: 0,
            curve: curves.cubicBezierCurve(0.3, 0, 0.3, 1)
          }
          break;
        case SCBSessionShowInScreenIndex.INDEX_RIGHT:
          param = {
            duration: 400,
            delay: 0,
            curve: curves.cubicBezierCurve(0.35, 0, 0.35, 1)
          }
          break;
      }
    } else {
      param = {
        duration: 400,
        delay: 0,
        curve: Curve.Linear
      }
    }
    return param;
  }
}