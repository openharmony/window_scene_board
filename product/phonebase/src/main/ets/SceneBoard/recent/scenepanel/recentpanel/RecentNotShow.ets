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
  CommonUtils,
} from '@ohos/basicutils';
import {
  SCBSceneInfo,
  SCBSceneSessionManager,
  SCBSceneSession,
  SCBSceneContainerState,
  SCBSceneContainerSession,
  SCBScenePanelManager,
  SCBSceneContainerSessionArray,
  SCBSceneMode
} from '@ohos/windowscene';
import { CommonConstants } from '@ohos/launchercommon';
import { RecentLayoutManager } from '../../common/RecentLayoutManager';
import curves from '@ohos.curves';
import { recentLayoutConfigInstance } from '@ohos/recents';
import { SCBScenePanelViewModel } from '../../../scenemanager/viewmodel/SCBScenePanelViewModel';

const TAG = 'RecentNotShow';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);
const WINDOW_SCALE: number = 0.2;
const BIT_MASK = 0xffff;

export enum ContainerShowState {
  SHOW,
  PRIMARY_SHOW,
  SECONDARY_SHOW,
  NOT_SHOW,
}

export class RecentNotShow {
  private readonly panelManager: SCBScenePanelManager;

  constructor(panelManager: SCBScenePanelManager) {
    this.panelManager = panelManager;
  }

  private getExcludeFromSession(sc: SCBSceneInfo | undefined): boolean {
    //当session为空时，默认该session不显示
    if (!sc) {
      return false;
    }
    return SCBSceneSessionManager.getInstance().isExcludeFromSession(sc.bundleName, sc.moduleName, sc.abilityName);
  }

  public getFloatingShowStatus(session: SCBSceneContainerSession): number {
    if (!session) {
      return ContainerShowState.SHOW;
    }
    if (CommonUtils.isInvalid(session)) {
      return ContainerShowState.SHOW;
    }
    return this.getExcludeFromSession(session.primarySession?.sceneInfo) ? ContainerShowState.NOT_SHOW :
      ContainerShowState.SHOW;
  }

  public getShowStatus(session: SCBSceneContainerSession | null): number {
    if (!session || !session.primarySession) {
      return ContainerShowState.SHOW;
    }
    let firstSession = session?.primarySession;
    let secondarySession = session?.secondarySession;
    let firstSessionDisappearStatus = this.getExcludeFromSession(firstSession?.sceneInfo);
    let secondaryDisappearStatus = this.getExcludeFromSession(secondarySession?.sceneInfo);

    if (firstSessionDisappearStatus && !secondarySession) {
      //不分屏，primarySession不显示
      return ContainerShowState.NOT_SHOW;
    }

    if (firstSession && secondarySession) {
      if (firstSessionDisappearStatus && secondaryDisappearStatus) {
        //分屏，两个session都不显示
        return ContainerShowState.NOT_SHOW;
      }

      if (!firstSessionDisappearStatus && secondaryDisappearStatus) {
        return ContainerShowState.PRIMARY_SHOW;
      }

      if (!secondaryDisappearStatus && firstSessionDisappearStatus) {
        return ContainerShowState.SECONDARY_SHOW;
      }
    }
    return ContainerShowState.SHOW;
  }

  public fullScreenNotShowAnimation(lastSession: SCBSceneContainerSession | null,
    totalContainerSessionList: SCBSceneContainerSessionArray, scenePanel: SCBScenePanelViewModel): void {
    let screenProperty = this.panelManager.getScreenProperty();
    if (!lastSession) {
      return;
    }
    lastSession.sessionData.pendingRemove = true;
    let animationNum = lastSession.getTransitionCount();
    animateTo({
      curve: curves.springMotion(0.55, 1, 0),
      finishCallbackType: FinishCallbackType.LOGICALLY,
      onFinish: () => {
        if (animationNum === lastSession.getTransitionCount()) {
          this.notShowContainerDestroy(lastSession, totalContainerSessionList);
        } else {
          lastSession.sessionData.pendingRemove = false;
        }
        lastSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'resetSessionParam');
        lastSession.needRenderZIndex.resetZIndex();
        if (totalContainerSessionList.length === 0) {
          scenePanel.exitSceneWithRotationRecover(lastSession);
        }
      }
    }, () => {
      let sessionName = lastSession.getName();
      lastSession.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'fullScreenNotShowAnimation', sessionName);
      lastSession.needRenderScale.setScaleXWithDfx(0.035, TAG, 'fullScreenNotShowAnimation', sessionName);
      lastSession.needRenderScale.setScaleYWithDfx(0.035, TAG, 'fullScreenNotShowAnimation', sessionName);
      lastSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'fullScreenNotShowAnimation', sessionName);
      lastSession.needRenderVisibility.setVisibilityWithDfx(false, TAG, 'fullScreenNotShowAnimation', sessionName);
      lastSession.needRenderTitleViewAlpha.setTitleViewAlpha(0);
      lastSession.needRenderTranslate.setTranslateYWithDfx(-px2vp(screenProperty.height * WINDOW_SCALE), TAG, 'fullScreenNotShowAnimation', sessionName);
      lastSession.needRenderTranslateIcon.translateIconX = 0;
      lastSession.needRenderTranslateIcon.translateIconY = 0;
      lastSession.needRenderClip.setClipHeight(screenProperty.height);
      lastSession.needRenderBorderRadius.setBorderRadiusWithDfx(CommonConstants.getDeviceRadius(), TAG,
        'fullScreenNotShowAnimation', sessionName);
    });
  }

  public notShowContainerAnimationOut(totalContainerSessionList: SCBSceneContainerSessionArray,
    scenePanel: SCBScenePanelViewModel): void {
    if (!totalContainerSessionList) {
      return;
    }
    //做最后一张卡片的动效
    let containerList = this.panelManager.getSceneContainerSessionList();
    let lastSession = containerList.getTopSession();
    if (!lastSession) {
      return;
    }
    let sessionShowStatus = this.getShowStatus(lastSession);
    log.info(`session ${lastSession.getName()} sessionShowStatus ${sessionShowStatus}`);
    if (sessionShowStatus === ContainerShowState.NOT_SHOW) {
      this.fullScreenNotShowAnimation(lastSession, totalContainerSessionList, scenePanel);
    } else if (sessionShowStatus !== ContainerShowState.SHOW) {
      this.splitScreenNotShowAnimation(lastSession, sessionShowStatus);
    }
  }

  private splitUpdatePositionAndSize(session: SCBSceneContainerSession | null,
                                     sessionShowStatus: ContainerShowState): void {
    if (!session) {
      return;
    }
    let screenProperty = this.panelManager.getScreenProperty();
    let screenW = screenProperty.width;
    let screenH = screenProperty.height;
    let transX = screenW / 8 * 1.25;
    let transY = screenH / 8 * 1.25;
    //当前左右分屏
    if (!session.dividerParam.isUpDownSplit()) {
      if (sessionShowStatus === ContainerShowState.PRIMARY_SHOW) {
        session.dividerParam.primary.width = '100%';
        session.dividerParam.primary.translateX = session.dividerParam.splitOrderIsNotReverse ? 0 : -transX;
        session.dividerParam.secondary.translateX = session.dividerParam.splitOrderIsNotReverse ? transX : -transX;
      } else {
        session.dividerParam.secondary.width = '100%';
        session.dividerParam.primary.translateX = session.dividerParam.splitOrderIsNotReverse ? -transX :
          transX;
        session.dividerParam.secondary.translateX = session.dividerParam.splitOrderIsNotReverse ? -transX :
          0;
      }
    } else {
      if (sessionShowStatus === ContainerShowState.PRIMARY_SHOW) {
        session.dividerParam.primary.height = '100%';
        session.dividerParam.primary.translateY = session.dividerParam.splitOrderIsNotReverse ? 0 : -transY;
        session.dividerParam.secondary.translateY = session.dividerParam.splitOrderIsNotReverse ? transY : -transY;
      } else {
        session.dividerParam.secondary.height = '100%';
        session.dividerParam.primary.translateY = session.dividerParam.splitOrderIsNotReverse ? -transY : transY;
        session.dividerParam.secondary.translateY = session.dividerParam.splitOrderIsNotReverse ? -transY : 0;
      }
    }
  }

  public notShowSessionDestroy(session: SCBSceneContainerSession | null,
    totalContainerSessionList?: SCBSceneContainerSessionArray): void {
    if (!session) {
      return;
    }
    let sessionShowStatus: ContainerShowState = this.getShowStatus(session);
    if (sessionShowStatus === ContainerShowState.NOT_SHOW) {
      this.notShowContainerDestroy(session, totalContainerSessionList);
    } else if (sessionShowStatus !== ContainerShowState.SHOW) {
      this.splitScreenDestroy(session, sessionShowStatus);
    }
  }

  private exitSplit(backgroundSession: SCBSceneSession | null): void {
    if (!backgroundSession) {
      return;
    }
    let screenProperty = this.panelManager.getScreenProperty();
    // 删除不显示的session
    backgroundSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    backgroundSession.requestSessionBackground();
    let container = new SCBSceneContainerSession(backgroundSession, screenProperty);
    container.primarySession?.updateCurRectForMultiWindowToFull(screenProperty);
    container.isSplit = false;
    this.addNotShowList(container);
  }

  public splitScreenDestroy(session: SCBSceneContainerSession, sessionShowStatus: ContainerShowState): void {
    if (!session) {
      return;
    }
    log.info(`splitScreenDestroy session ${session.getName()}`);
    let forgroundSession = sessionShowStatus === ContainerShowState.PRIMARY_SHOW ?
      session?.primarySession : session?.secondarySession;
    let backgroundSession = sessionShowStatus === ContainerShowState.PRIMARY_SHOW ?
      session?.secondarySession : session?.primarySession;
    let screenProperty = this.panelManager.getScreenProperty();

    session.removeSceneSession(backgroundSession);
    this.exitSplit(backgroundSession);
    if (backgroundSession) {
      SCBSceneSessionManager.getInstance()
        .getScenePersistent()
        .deletePersistentMapElement(backgroundSession.session.persistentId & BIT_MASK);
    }
    session.requestBackground();
    session.isSplit = false;
    session.dividerParam.init();
    if (forgroundSession) {
      forgroundSession.updateCurRectForMultiWindowToFull(screenProperty);
    }
    session.changeState(SCBSceneContainerState.FULL_SCREEN);
    // 标题淡入
    animateTo({
      curve: Curve.Linear,
      duration: 50,
    }, () => {
      session.needRenderShowRecentTitle.setShowRecentTitle(true);
      session.needRenderTitleViewAlpha.setTitleViewAlpha(1);
    });
  }

  public splitScreenNotShowAnimation(session: SCBSceneContainerSession, sessionShowStatus: ContainerShowState) {
    if (!session) {
      return;
    }
    let forgroundSession = sessionShowStatus === ContainerShowState.PRIMARY_SHOW ?
      session?.primarySession : session?.secondarySession;
    session.needRenderTitleViewAlpha.setTitleViewAlpha(0);
    let screenProperty = this.panelManager.getScreenProperty();
    let animationTime = recentLayoutConfigInstance.isNeedMultiRowLayout() ? 300 : 150;
    if (forgroundSession) {
      forgroundSession.updateCurRectForMultiWindowToFull(screenProperty);
    }
    animateTo({
      curve: Curve.Linear,
      duration: animationTime,
      onFinish: () => {
        this.splitScreenDestroy(session, sessionShowStatus);
      }
    }, () => {
      session.dividerParam.blackBackgroundOpacity = 0;
      this.splitUpdatePositionAndSize(session, sessionShowStatus);
      session.isSplit = false;
    });
  }

  private addNotShowList(container: SCBSceneContainerSession) {
    let notShowList = this.panelManager.getNotShowRecentList();
    let index = notShowList.findIndexByContainerId(container.containerId);
    log.info(`add to notShowList ${container?.getName()} ${index}`);
    if (index === -1) {
      notShowList.push(container);
    } else {
      notShowList.splice(index, 1, container);
    }
  }

  public notShowContainerDestroy(lastSession: SCBSceneContainerSession | null,
                                 totalContainerSessionList?: SCBSceneContainerSessionArray): void {
    if (!lastSession) {
      return;
    }
    log.info(`notShowContainerDestroy lastSession ${lastSession.getName()}`);
    let deleteSession =
      this.panelManager.getSceneContainerSessionList().deleteByContainerId(lastSession.containerId);
    log.info(`notShowContainerDestroy delete ${deleteSession?.getName()}`);
    totalContainerSessionList?.deleteByContainerId(lastSession.containerId);
    lastSession.requestBackground();
    this.addNotShowList(lastSession);
    if (lastSession.primarySession) {
      SCBSceneSessionManager.getInstance()
        .getScenePersistent()
        .deletePersistentMapElement(lastSession.primarySession.session.persistentId & BIT_MASK);
    }
    if (lastSession.secondarySession) {
      SCBSceneSessionManager.getInstance()
        .getScenePersistent()
        .deletePersistentMapElement(lastSession.secondarySession.session.persistentId & BIT_MASK);
    }
  }
}