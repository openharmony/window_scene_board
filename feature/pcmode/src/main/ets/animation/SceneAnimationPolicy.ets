/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { AnimateToScheduleUtils, LogHelper } from '@ohos/basicutils';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneMode,
  SCBSceneSession,
  SCBScreenProperty,
  SCBSpecificSession
} from '@ohos/windowscene';
import { LogUtil } from '../utils/LogUtil';
import { AnimationConstants } from '../constants/AnimiationConstants';
import { IFreeWindowsViewModel } from '../presenter/IFreeWindowsViewModel';
import { SCBSceneHelper } from '../utils/SCBSceneHelper';
import { AnimationParams, IAnimationPolicy } from './IAnimationPolicy';
import { SCBSplitLayoutHelper } from '../utils/SCBSplitLayoutHelper';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { ApsUtils, IconExtendParam, IconResourceManager, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { image } from '@kit.ImageKit';
import { curves, performanceMonitor } from '@kit.ArkUI';
import { StyleConstants } from '@ohos/launchercommon';
import { systemAniSceneCtrl } from '../utils/SystemAnimatedSceneController';
import { SystemAnimatedScene } from '../constants/SystemAnimatedScene';
import { SCBSystemSceneUtils } from '../utils/SCBSystemSceneUtils';

export class SceneAnimationPolicy implements IAnimationPolicy {
  protected tag = 'SceneAnimationPolicy';
  protected screenProperty: SCBScreenProperty;
  protected presenter: IFreeWindowsViewModel;
  protected log: LogHelper;

  constructor(presenter: IFreeWindowsViewModel) {
    this.presenter = presenter;
    this.screenProperty = this.presenter.getScreenProperty();
    this.log = LogUtil.getInstance().createLogHelper(this.tag, this.screenProperty.screenId)
  }
  public onStart(): void {
  }

  public onDestroy(): void {
  }

  public switchSplitAnimation(containerSession: SCBSceneContainerSession): void {
    this.presenter.getUiContext().animateTo({
      duration: AnimationConstants.DEFAULT_SPLIT_ANIM_DURATION,
      curve: Curve.Sharp,
      delay: 0,
      onFinish: () => {
        containerSession.dividerParam.splitMovingMode = SCBSceneMode.UNDEFINED;
        SCBSceneHelper.setSplitGravity(containerSession);
      }}, () => {
      this.setSplitSideEndState(containerSession);
    });
    this.updateDividerPosition(containerSession);
    if (containerSession.primarySession?.isActive || AppStorage.get<boolean>('isLock') as boolean) {
      this.presenter.getUiContext().animateTo({
        duration: AnimationConstants.DEFAULT_SPLIT_ANIM_DURATION - AnimationConstants.DIVIDER_DELAY_SHOW_DURATION,
        curve: Curve.Sharp,
        delay: AnimationConstants.DIVIDER_DELAY_SHOW_DURATION,
        }, () => {
        containerSession.dividerParam.setDividerOpacity(1);
      });
    }
  }

  public startResizeTransitionAnim(scene: SCBSceneSession, resizeFun: (scene: SCBSceneSession) => void): void {
    this.log.showInfo(`startResizeTransitionAnim, ${scene.getName()}`);
    scene.isShowSplitResizeMask = true;
    scene.animResizeMaskOpacity = 1;
    scene.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.SPLIT_TO_FULL);
    resizeFun(scene);
    this.updateSceneMaskIcon(scene);
    let taskExecuted: boolean = false;
    const clearMaskTask = () => {
      this.log.showInfo(`clear reizeMask`);
      taskExecuted = true;
      this.presenter.getUiContext().animateTo({
        curve: Curve.EaseOut,
        duration: AnimationConstants.START_RESIZE_MASK_TRANSITION_ANIM_DURATION,
        onFinish: () => {
          scene.isShowSplitResizeMask = false;
          scene.animResizeMaskIcon = undefined;
          scene.animResizeMaskOpacity = 1;
        }
      }, () => {
        scene.animResizeMaskOpacity = 0;
      })
    };
    scene.setFrameLayoutFinishCallback(clearMaskTask);
    setTimeout(() => {
      if (!taskExecuted) {
        this.log.showWarn(`frame layout not received, close mask by timeout`);
        scene.unsetFrameLayoutFinishCallback();
        clearMaskTask();
        taskExecuted = true;
      }
    }, AnimationConstants.FRAME_LAYOUT_CALLBACK_TIMEOUT);
  }

  public minimizeTargetWindowsAnimation(containerSessionList: SCBSceneContainerSessionArray): void {
    if (containerSessionList.length === 0) {
      return;
    }
    performanceMonitor.begin('WINDOW_MINIMIZED_BY_INTERFACE', performanceMonitor.ActionType.LAST_UP);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MIN, StyleConstants.DEFAULT_1);
    AnimateToScheduleUtils.raiseResizeWindow(AnimateToScheduleUtils.VALUE_START);
    systemAniSceneCtrl.enqueue(SystemAnimatedScene.ENTER_MIN_WINDOW, true);

    containerSessionList.forEach((containerSession: SCBSceneContainerSession) => {
      let primarySession = containerSession.primarySession;
      primarySession!.isMinimizing = true;
      containerSession.requestBackground(false, false, false);
      containerSession.isDisappearing = true;
    });

    const finishCallback = () => {
      this.log.showInfo(`minimizeTargetWindowsAnimation onFinish`);
      containerSessionList.forEach((containerSession: SCBSceneContainerSession) => {
        containerSession.primarySession!.isMinimizing = false;
        containerSession.primarySession!.isSessionResizeWhenDragEnd = false;
        containerSession.isDisappearing = false;
        containerSession.needRenderVisibility.setVisibilityWithDfx(false, this.tag, 'setVisibilityMinimizeSession',
          containerSession.getName());
        containerSession.primarySession?.initSceneState();
      });
      performanceMonitor.end('WINDOW_MINIMIZED_BY_INTERFACE');
      // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MIN, StyleConstants.DEFAULT_0);
      systemAniSceneCtrl.dequeue(SystemAnimatedScene.ENTER_MIN_WINDOW);
    }
    this.presenter.getUiContext().animateTo({
      duration: 200,
      curve: Curve.Friction,
      onFinish: finishCallback
    }, () => {
      containerSessionList.forEach((containerSession: SCBSceneContainerSession) => {
        this.getSpecificSceneList(containerSession.primarySession)?.forEach((subSession: SCBSpecificSession) => {
          SCBSceneHelper.setSceneScale(subSession, 0.8);
        });
        SCBSceneHelper.setSceneScale(containerSession, 0.8);
      });
    })
    this.presenter.getUiContext().animateTo({
      delay: 50,
      duration: 150,
      curve: Curve.Friction,
    }, () => {
      containerSessionList.forEach((containerSession: SCBSceneContainerSession) => {
        this.getSpecificSceneList(containerSession.primarySession)?.forEach((subSession: SCBSpecificSession) => {
          subSession.opacity = 0.0;
        });
        containerSession.primarySession!.opacity = 0.0;
      });
    })
    AnimateToScheduleUtils.raiseResizeWindow(AnimateToScheduleUtils.VALUE_END);
  }

  private updateDividerPosition(containerSession: SCBSceneContainerSession): void {
    const primarySession = containerSession.primarySession;
    const secondarySession = containerSession.secondarySession;
    if (primarySession && containerSession.isSplitPrimaryMode()) {
      if (containerSession.dividerParam.isExpandUpDownSplit()) {
        containerSession.dividerParam.positionY =
          `${SCBSystemSceneUtils.getInstance().px2vp(this.presenter.getUiContext(),
            primarySession.currRect.top.getPx() + primarySession.currRect.height.getPx())}`;
      } else {
        containerSession.dividerParam.positionX = `${SCBSystemSceneUtils.getInstance()
          .px2vp(this.presenter.getUiContext(), primarySession.currRect.width.getPx())}`;
      }
    } else if (secondarySession && containerSession.isSplitSecondaryMode()) {
      if (containerSession.dividerParam.isExpandUpDownSplit()) {
        containerSession.dividerParam.positionY =
          `${SCBSystemSceneUtils.getInstance().px2vp(this.presenter.getUiContext(),
            secondarySession.currRect.top.getPx() + secondarySession.currRect.height.getPx())}`;
      } else {
        containerSession.dividerParam.positionX = `${SCBSystemSceneUtils.getInstance()
          .px2vp(this.presenter.getUiContext(), secondarySession.currRect.width.getPx())}`;
      }
    }
  }

  private getSpecificSceneList(primarySession: SCBSceneSession | null): SCBSpecificSession[] | undefined {
    if (!primarySession) {
      this.log.showError('getSpecificSceneList primarySession is null');
      return;
    }
    let specificSceneList: SCBSpecificSession[] = [];
    let dialogSceneList = primarySession.dialogSessionList;
    let subSceneList = primarySession.subSessionList;
    specificSceneList.push(...dialogSceneList as (SCBSpecificSession)[]);
    if (subSceneList !== null) {
      SCBSceneHelper.traverseSubList(subSceneList, specificSceneList);
    }
    return specificSceneList;
  }

  public layoutAnimation(sceneSession: SCBSceneSession, animationParams: AnimationParams,
    finishCallback: Callback<void>): void {
    if (!animationParams.isNeedImplicitAnimation) {
      this.setSnapshotDisappear(sceneSession, animationParams.isMaximizeInImmersive);
    }
    this.presenter.getUiContext().animateToImmediately({
      duration: 0,
      onFinish: () => {
        finishCallback();
      }
    }, () => {
      sceneSession.scaleX = 1;
      sceneSession.scaleY = 1;
      sceneSession.translateX = 0;
      sceneSession.translateY = 0;
      sceneSession.floatBorderRadius = 0;
      this.notifySubSessionEvent(sceneSession);
    });
  }

  public recoverAnimation(sceneSession: SCBSceneSession, animationParams: AnimationParams,
    finishCallback: Callback<void>): void {
    if (!animationParams.isNeedImplicitAnimation) {
      this.setSnapshotDisappear(sceneSession, animationParams.isMaximizeInImmersive);
    }
    this.presenter.getUiContext().animateTo({
      duration: 0,
    }, () => {
      if (!sceneSession.isLastSplit && !AppStorage.get('isLock')) {
        sceneSession.floatBorderRadius = SCBWindowSceneConfig.getInstance().windowSceneConfig.floatCornerRadius;
      }
    })
    this.presenter.getUiContext().animateToImmediately({
      duration: 0,
      onFinish: () => {
        finishCallback();
      }
    }, () => {
      if (!sceneSession.isLastSplit && !AppStorage.get('isLock')) {
        sceneSession.translateX = 0;
        sceneSession.translateY = 0;
        sceneSession.scaleX = 1;
        sceneSession.scaleY = 1;
      }
      this.setWindowEffectConfig(sceneSession);
      AppStorage.setOrCreate('isSplitAnimating', false);
      this.notifySubSessionEvent(sceneSession);
    });
  }

  private setSnapshotDisappear(sceneSession: SCBSceneSession, isMaximizeInImmersive: boolean): void {
    sceneSession.needRenderSnapShotAnimConfig.animVisible = true;
    sceneSession.needRenderSnapShotAnimConfig.animSceneAlpha = 1;
    this.presenter.getUiContext().animateTo({
      duration: 0,
      onFinish: () => {
        sceneSession.needRenderSnapShotAnimConfig.animVisible = false;
        sceneSession.needRenderSnapShotAnimConfig.animSnapshot = undefined;
        sceneSession.needRenderSnapShotAnimConfig.animActionId = 0;
      }
    }, () => {
      sceneSession.needRenderSnapShotAnimConfig.animSceneAlpha = 0;
    });
  }

  private notifySubSessionEvent(sceneSession: SCBSceneSession): void {
    sceneSession.subSessionList.forEach((item) => {
      item.notifyParentRectChange(sceneSession.currRect, sceneSessionManager.SessionSizeChangeReason.UNDEFINED,
        sceneSession.sceneInfo.screenId);
    });
  }

  private setWindowEffectConfig(sceneSession: SCBSceneSession): void {
    sceneSession.setFloatCornerRadiusConfig();
    sceneSession.setWindowShadowConfig();
  }

  private setSplitSideEndState(containerSession: SCBSceneContainerSession): void {
    let primarySession = containerSession.primarySession;
    let secondarySession = containerSession.secondarySession;
    if (primarySession?.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
      primarySession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.SECONDARY);
      if (secondarySession) {
        secondarySession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.PRIMARY);
      }
    } else if (primarySession?.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
      primarySession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.PRIMARY);
      if (secondarySession) {
        secondarySession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.SECONDARY);
      }
    } else {
      this.log.showError('Wrong SCBSceneMOde : ' + primarySession?.sceneInfo.windowMode);
      return;
    }
    containerSession.dividerParam.isSplitPrimaryMode = primarySession.sceneInfo.windowMode === SCBSceneMode.PRIMARY;
    containerSession.dividerParam.splitOrderIsNotReverse = containerSession.dividerParam.isSplitPrimaryMode;
    SCBSplitLayoutHelper.refreshSplitContainer(containerSession, this.screenProperty, this.presenter.getUiContext());
    this.updateSubSession(containerSession);
  }

  private updateSubSession(containerSession: SCBSceneContainerSession): void {
    if (containerSession.primarySession instanceof SCBSceneSession) {
      let primarySession: SCBSceneSession = containerSession.primarySession as SCBSceneSession;
      primarySession.subSessionList.forEach((item) => {
        item.notifyParentRectChange(primarySession.currRect, sceneSessionManager.SessionSizeChangeReason.UNDEFINED,
          primarySession.sceneInfo.screenId);
      });
    }

    if (containerSession.secondarySession instanceof SCBSceneSession) {
      let secondarySession: SCBSceneSession = containerSession.secondarySession as SCBSceneSession;
      secondarySession.subSessionList.forEach((item) => {
        item.notifyParentRectChange(secondarySession.currRect, sceneSessionManager.SessionSizeChangeReason.UNDEFINED,
          secondarySession.sceneInfo.screenId);
      });
    }
  }

  private updateSceneMaskIcon(scene: SCBSceneSession): void {
    let sceneInfo = scene.sceneInfo;
    let param = new IconExtendParam();
    IconResourceManager.getInstance().getCombineIcon(
      sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName, param)
      .then((icon: image.PixelMap) => {
        scene.animResizeMaskIcon = icon;
      })
      .catch((e: Error) => {
        this.log.showError(`getCombineIcon error: ${e?.message}`);
      });
  }

}