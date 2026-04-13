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
  SCBScenePanelManager,
  SCBSceneContainerSession,
  SCBSessionShowInScreenIndex,
  RecentsStyleConstants,
  SCBTransitionManager
} from '@ohos/windowscene';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { CommonConstants} from '@ohos/launchercommon';
import { recentLayoutConfigInstance } from '@ohos/recents';
import { ContainerBuilder } from '../../common/ContainerBuild';
import { recentRuntimeInstance } from './RecentRuntimeModel';
import systemParameter from '@ohos.systemParameterEnhance';
import { curves, performanceMonitor } from '@kit.ArkUI';
import { RecentLayoutManager } from '../../common/RecentLayoutManager';
import { RecentStyle } from '../../RecentStyle';
import { RecentTitleViewModel } from '../../viewmodel/RecentTitleViewModel';
import { RecentStartSceneCallback } from './RecentCallbacks';
import {
  animateExAddOnFinish,
  AnimateExArgsType,
  animateExBreak,
  animateExNew,
  animateExStart
} from '@ohos/windowscene/Index';
import { quickSwitchViewModel } from '../quickswitchpanel/QuickSwitchViewModel';
import { RecentGestureEventManager } from '../../common/RecentGestureEventManager';
import { RecentGestureEvent } from '../../common/constants/RecentGestureConstants';
import { recentStateManagerInstance } from '../../innerstate/RecentStates';

const TAG = 'RecentStartScene';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class RecentStartScene {
  private readonly panelManager: SCBScenePanelManager;
  private isNewStyle = systemParameter.getSync('sceneboard.isNewStyle', 'true') === 'true';

  constructor(panelManager: SCBScenePanelManager) {
    this.panelManager = panelManager;
    this.initAnimations();
  }

  private initAnimations(): void {
    this.createStartSceneAnimationInMultiRow();
    this.createStartSceneAnimationInSingleRow();
  }

  private createStartSceneAnimationInMultiRow(): void {
    let param: AnimateParam = {};
    if (this.isNewStyle) {
      param.curve = curves.interpolatingSpring(0, 1, 300, 35);
      param.finishCallbackType = FinishCallbackType.LOGICALLY;
    } else {
      param.duration = 300;
      param.curve = Curve.Linear;
    }
    animateExNew('startSceneAnimationInMultiRow', param,
      /* event = */this.startSceneAnimationEventInMultiRow,
      /* onFinish = */(...args: AnimateExArgsType[]) => {
        let callback: RecentStartSceneCallback = args[1] as RecentStartSceneCallback;
        callback.onFinish(args[2] as SCBSceneContainerSession, args[3] as number);
      });
  }

  private createStartSceneAnimationInSingleRow(): void {
    let param: AnimateParam = {};
    if (this.isNewStyle) {
      param.curve = curves.interpolatingSpring(0, 1, 300, 35);
      param.finishCallbackType = FinishCallbackType.LOGICALLY;
    } else {
      param.duration = 300;
      param.curve = Curve.Linear;
    }
    animateExNew('startSceneAnimationInSingleRow', param,
      /* event = */this.startSceneAnimationEventInSingleRow,
      /* onFinish = */(...args: AnimateExArgsType[]) => {
        let callback: RecentStartSceneCallback = args[1] as RecentStartSceneCallback;
        callback.onFinish(args[2] as SCBSceneContainerSession, args[3] as number);
        this.startSceneFinishInnerCallback(args[2] as SCBSceneContainerSession);
      }, true);
  }

  public prepareEnterAppFromRecent(clickSession: SCBSceneContainerSession, currentOffsetX: number): number {
    let containerSessionList = this.panelManager.getSceneContainerSessionListForView();
    let clickIndex = containerSessionList.findIndex(item => {
      return item.containerId === clickSession.containerId &&
        item.primarySession?.session.persistentId === clickSession.primarySession?.session.persistentId &&
        item.secondarySession?.session.persistentId === clickSession.secondarySession?.session.persistentId;
    });
    this.panelManager.setScreenPropertyToViewParam();
    log.showInfo(`enterFromRecentAnim clickIdx: ${clickIndex} currColumn:${recentRuntimeInstance.autoCenterColumn}`);
    let oldXOffset = currentOffsetX;
    ContainerBuilder.resetAllContainerPreBuildStage(this.panelManager.getTotalSessionList());
    let containerListLen = containerSessionList.length;
    for (let i = recentRuntimeInstance.leftBoundaryIndex; i < containerListLen; i++) {
      let session = containerSessionList[i];
      let nameDfx = session.getName();
      if (Math.abs(recentRuntimeInstance.getRelativeColumn(i) +
      recentRuntimeInstance.leftBoundaryColumn - recentRuntimeInstance.autoCenterColumn) <= 1 || i == clickIndex) {
        let oldPosX = session.needRenderPos.posX;
        session.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'prepareEnterAppFromRecent', nameDfx);
        session.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'prepareEnterAppFromRecent', nameDfx);
        session.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'prepareEnterAppFromRecent', nameDfx);
        session.needRenderPos.setPosXWithDfx(0, TAG, 'prepareEnterAppFromRecent', nameDfx);
        let diffOffset = oldPosX - oldXOffset;
        session.needRenderTranslate.setTranslateXWithDfx(diffOffset +
        session.needRenderTranslate.translateX, TAG, 'prepareEnterAppFromRecent', nameDfx);
        if (recentLayoutConfigInstance.isNeedMultiRowLayout()) {
          session.needRenderZIndex.setZIndex(i === clickIndex ? 1 : 0);
        } else {
          session.needRenderZIndex.setZIndex(1);
        }
      } else if (session.needRenderShowInRecent.showInRecent) {
        session.resetNeedRenderPosByTranslate();
        session.needRenderVisibility.setVisibilityWithDfx(false, TAG, 'prepareEnterAppFromRecent', nameDfx);
        session.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'prepareEnterAppFromRecent', nameDfx);
      }
    }
    return clickIndex;
  }

  public playStartSceneAnimation(clickIndex: number, autoCenterColumn: number,
    containerSession: SCBSceneContainerSession, callback: RecentStartSceneCallback) {
    let isNeedChangeToMultiRow = recentLayoutConfigInstance.isNeedMultiRowLayout();
    if (isNeedChangeToMultiRow) {
      this.playStartSceneAnimationInMultiRow(clickIndex, containerSession, callback, autoCenterColumn);
    } else {
      this.playStartSceneAnimationInSingleRow(clickIndex, containerSession, callback);
    }
  }

  private playStartSceneAnimationInSingleRow(clickIndex: number, containerSession: SCBSceneContainerSession,
    callback: RecentStartSceneCallback) {
    let animationNum = containerSession.getTransitionCount();
    animateExBreak('startSceneAnimationInSingleRow', 'playStartSceneAnimationInSingleRow');
    animateExAddOnFinish('startSceneAnimationInSingleRow', this.unbreakableFinishCallBack, false);
    animateExStart('startSceneAnimationInSingleRow', clickIndex, callback, containerSession, animationNum);
    RecentTitleViewModel.playTitleDisAppearAnimation(containerSession);
  }

  private playStartSceneAnimationInMultiRow(clickIndex: number, containerSession: SCBSceneContainerSession,
    callback: RecentStartSceneCallback, autoCenterColumn: number) {
    RecentTitleViewModel.playTitleDisAppearAnimation(containerSession);
    containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.getDeviceRadius(), TAG,
      'playStartSceneAnimationInMultiRow', containerSession.getName());
    let animationNum = containerSession.getTransitionCount();
    animateExBreak('startSceneAnimationInMultiRow', 'playStartSceneAnimationInMultiRow');
    animateExAddOnFinish('startSceneAnimationInMultiRow', this.unbreakableFinishCallBack, false);
    animateExStart('startSceneAnimationInMultiRow', clickIndex, callback, containerSession, animationNum,
      autoCenterColumn);
  }

  private adjustSessionParamForStartSceneAnimation(containerSession: SCBSceneContainerSession, idx: number,
    autoCenterColumn: number): void {
    let column = recentRuntimeInstance.getAbsoluteColumn(idx);
    let curPos = RecentLayoutManager.getSessionContainerRelativePos(column, autoCenterColumn);
    if (curPos === SCBSessionShowInScreenIndex.INDEX_NONE) {
      return;
    }
    let scaleX = RecentsStyleConstants.MULTI_RECENT_SCALE * RecentStyle.START_SCENE_SCALE_PERCENT_MULTI_ROW;
    let scaleY = RecentsStyleConstants.MULTI_RECENT_SCALE * RecentStyle.START_SCENE_SCALE_PERCENT_MULTI_ROW;
    containerSession.needRenderScale.setScaleXWithDfx(scaleX, TAG, 'adjustSessionParamForStartSceneAnimation',
      containerSession.getName());
    containerSession.needRenderScale.setScaleYWithDfx(scaleY, TAG, 'adjustSessionParamForStartSceneAnimation',
      containerSession.getName());
    containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(RecentStyle.START_SCENE_ALPHA_MULTI_ROW, TAG,
      'adjustSessionParamForStartSceneAnimation', containerSession.getName());
    containerSession.needRenderTitleViewAlpha.setTitleViewAlpha(RecentStyle.START_SCENE_ALPHA_MULTI_ROW);
    // 根据卡片的上下情况，分别向下和向上位移
    let newTranslateY = containerSession.needRenderTranslate.translateY +
      (containerSession.needRenderTranslate.translateY < 0 ? RecentStyle.START_SCENE_TRANSLATE_OFFSET_MULTI_ROW :
        -RecentStyle.START_SCENE_TRANSLATE_OFFSET_MULTI_ROW);
    containerSession.needRenderTranslate.setTranslateYWithDfx(newTranslateY, TAG,
      'adjustSessionParamForStartSceneAnimation', containerSession.getName());
    // 左侧卡片右移，右侧卡片左移
    let newTranslateX = containerSession.needRenderTranslate.translateX;
    switch (curPos) {
      case SCBSessionShowInScreenIndex.INDEX_LEFT:
        newTranslateX += RecentStyle.START_SCENE_TRANSLATE_OFFSET_MULTI_ROW;
        containerSession.needRenderTranslate.setTranslateXWithDfx(newTranslateX, TAG,
          'adjustSessionParamForStartSceneAnimation', containerSession.getName());
        break;
      case SCBSessionShowInScreenIndex.INDEX_RIGHT:
        newTranslateX -= RecentStyle.START_SCENE_TRANSLATE_OFFSET_MULTI_ROW;
        containerSession.needRenderTranslate.setTranslateXWithDfx(newTranslateX, TAG,
          'adjustSessionParamForStartSceneAnimation', containerSession.getName());
        break;
      default:
        break;
    }
  }

  /**
   * 动效被打断场景仍然调用该回调
   */
  private unbreakableFinishCallBack = (...args: AnimateExArgsType[]): void => {
    SCBTransitionManager.getInstance().reduceStartExitAnimationCount('playStartSceneAnimation end');
    performanceMonitor.end('LAUNCHER_APP_LAUNCH_FROM_RECENT');
  }

  private startSceneAnimationEventInSingleRow = (...args: AnimateExArgsType[]) => {
    let screenW = px2vp(this.panelManager.getScreenProperty().width);
    let margin = RecentLayoutManager.getWidthSpace();
    let clickIndex = args[0] as number;
    this.panelManager.getSceneContainerSessionListForView().forEach((containerSession, idx) => {
      containerSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'playStartSceneAnimationInSingleRow',
        containerSession.getName());
      if (Math.abs(idx - clickIndex) <= 2 && containerSession.needRenderShowInRecent.showInRecent) {
        containerSession.needRenderTranslate.setTranslateXWithDfx((idx - clickIndex) * (screenW + margin), TAG,
          'playStartSceneAnimationInSingleRow', containerSession.getName());
        containerSession.needRenderScale.setScaleXWithDfx(idx == clickIndex ? 1 : 0.85, TAG,
          'playStartSceneAnimationInSingleRow',
          containerSession.getName());
        containerSession.needRenderScale.setScaleYWithDfx(idx == clickIndex ? 1 : 0.85, TAG,
          'playStartSceneAnimationInSingleRow',
          containerSession.getName());
      }
    });
  }

  private startSceneAnimationEventInMultiRow = (...args: AnimateExArgsType[]) => {
    let clickIndex = args[0] as number;
    let autoCenterColumn = args[4] as number;
    this.panelManager.getSceneContainerSessionList().forEach((containerSession, idx) => {
      if (idx === clickIndex) {
        containerSession.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'playStartSceneAnimationInMultiRow',
          containerSession.getName());
        containerSession.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'playStartSceneAnimationInMultiRow',
          containerSession.getName());
        containerSession.needRenderScale.setScaleXWithDfx(1, TAG, 'playStartSceneAnimationInMultiRow',
          containerSession.getName());
        containerSession.needRenderScale.setScaleYWithDfx(1, TAG, 'playStartSceneAnimationInMultiRow',
          containerSession.getName());
        containerSession.needRenderRotate.setAngleWithDfx(0, TAG, 'playStartSceneAnimationInMultiRow',
          containerSession.getName());
        containerSession.needRenderBlurRadius.reset();
      } else {
        this.adjustSessionParamForStartSceneAnimation(containerSession, idx, autoCenterColumn);
      }
    });
  }

  private startSceneFinishInnerCallback(containerSession: SCBSceneContainerSession): void {
    if (recentStateManagerInstance.isInitState() || !quickSwitchViewModel.isAnimatingState()) {
      RecentGestureEventManager.getInstance()
        .deliverGestureEvent(RecentGestureEvent.START_SCENE_FROM_RECENT_END, containerSession);
    }
  }
}