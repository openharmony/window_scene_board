/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
  LogDomain
} from '@ohos/basicutils';
import {
  RecentClearAllCallback
} from './RecentCallbacks';
import {
  SCBScenePanelManager,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneSession,
} from '@ohos/windowscene';
import { DeviceHelper, } from '@ohos/frameworkwrapper';
import { RecentDelete } from './RecentDelete';
import { SCBOuterScenePanelManager } from '../../../scenemanager/SCBOuterScenePanelManager';
import { RecentLockIconModel } from './RecentLockIconModel';
import { RecentTitleViewModel } from '../../viewmodel/RecentTitleViewModel';
import { launcherVisualEffectMgr } from '@ohos/launchercommon/src/main/ets/manager/LauncherVisualEffectManager';
import { recentRuntimeInstance } from './RecentRuntimeModel';
import { SceneBoardStateManager, CoreEventType } from '@ohos/frameworkwrapper/Index';

const TAG = 'RecentClearAll';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class RecentClearAll {
  private readonly panelManager: SCBScenePanelManager;
  private recentDelete: RecentDelete;

  constructor(panelManager: SCBScenePanelManager) {
    this.panelManager = panelManager;
    this.recentDelete = new RecentDelete(this.panelManager);
  }

  /**
   * 屏幕内的卡片设置pos
   *
   * @param { SCBSceneContainerSessionArray} containerList - 屏幕内卡片list.
   * @param { number } currentOffsetX - 当前scroll的offsetx.
   * @returns { void }
   */
  public setInScreenConatinerPos(containerList: SCBSceneContainerSessionArray, currentOffsetX: number): void {
    containerList.forEach((container) => {
      this.recentDelete.setNeedRenderPosForDeleteAllAnimation(container, currentOffsetX);
    })
  }

  /**
   * 获取屏幕外的卡片
   *
   * @param { number[] } filterIndex - 屏幕内卡片的index.
   * @param { SCBSceneContainerSessionArray } cloneList - 多任务所有的卡片.
   * @returns { SCBSceneContainerSessionArray } 屏幕外的卡片
   */
  public getOffScreenSession(filterIndex: number[],
    cloneList: SCBSceneContainerSessionArray): SCBSceneContainerSessionArray {
    let sessionList = new SCBSceneContainerSessionArray();
    for (let index = 0; index < cloneList.length; index++) {
      let container = cloneList[index];
      if (!container || index === filterIndex[0] || index === filterIndex[1] || index === filterIndex[2]) {
        continue;
      }
      sessionList.push(container);
    }
    return sessionList;
  }

  /**
   * 不可删除卡片的重置参数的处理
   *
   * @param { SCBSceneContainerSession } container
   * @returns { void }
   */
  public resetParamUnclearableContainer(container: SCBSceneContainerSession): void {
    let nameForDfx = container.getName();
    container.requestBackground();
    container.needRenderPos.setPosXWithDfx(0, TAG, 'filterSceneContainerSessionList', nameForDfx);
    container.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'filterSceneContainerSessionList', nameForDfx);
    container.needRenderVisibility.setVisibilityWithDfx(false, TAG,
      'filterSceneContainerSessionList', nameForDfx);
    container.needRenderShowRecentTitle.setShowRecentTitle(false);
  }

  /**
   * 外屏条件下，删除和销毁屏幕外的卡片
   *
   * @param { SCBSceneContainerSessionArray } cloneList - 所有的多任务的卡片
   * @param { number } leftIndex,curIndex,rightIndex - 屏幕内卡片的index
   * @param { SCBSceneContainerSessionArray } containerSessionList - 全屏卡片list
   * @returns { void }
   */
  public removeAndDestructOffScreenSessionsForOuterScreen(offScreenContainers: SCBSceneContainerSessionArray): void {
    for (let container of offScreenContainers) {
      // 不可删除卡片 不删除也不销毁
      if (!this.recentDelete.isUnclearAbleWhenClearAll(container)) {
        container.requestDestruction(true, false, true, true, true);
        // 屏幕外的 可删除卡片 只清理悬浮窗，全屏的卡片的清理在 外屏 其他的逻辑中
        if (container.isFloat) {
          this.panelManager.removeFloatContainerSession(container);
        }
      } else {
        // 屏幕外的 不可删除的 卡片 下树的操作
        this.resetParamUnclearableContainer(container);
        this.resetIsKillParam(container);
      }
    }
  }

  /**
   * 外屏条件下，删除屏幕外 可删除的全屏卡片
   *
   * @param { SCBSceneContainerSessionArray } cloneList - 所有的多任务的卡片
   * @param { number } leftIndex,curIndex,rightIndex - 屏幕内卡片的index
   * @param { SCBSceneContainerSessionArray } containerSessionList - 全屏卡片list
   * @returns { void }
   */
  public removeOffScreenSessionsForOuterScreen(cloneList: SCBSceneContainerSessionArray, indexList: number[],
    containerSessionList: SCBSceneContainerSessionArray): void {
    let screenSessionIdx: number[] = [];
  }

  /**
   * 内屏条件下，删除和销毁屏幕外的卡片
   *
   * @param { SCBSceneContainerSessionArray } offScreenContainers - 屏幕外的卡片.
   * @param { RecentClearAllCallback } recentClearAllCallback - 一键删除中的回调
   * @returns { void }
   */
  public removeAndDestructOffScreenSessions(offScreenContainers: SCBSceneContainerSessionArray,
    recentClearAllCallback: RecentClearAllCallback): void {
    for (let container of offScreenContainers) {
      // 不可删除和PC侧的prepareSessions的卡片 不删除也不销毁
      if (!this.recentDelete.isUnclearAbleWhenClearAll(container)) {
        container.requestDestruction(true, false, true, true, true);
        if (container.isFloat) {
          this.panelManager.removeFloatContainerSession(container);
        } else {
          this.panelManager.removeSceneContainerSession(container);
        }
      } else {
        recentClearAllCallback.initFloatingWhenClearAll(container);
        this.resetParamUnclearableContainer(container);
        this.resetIsKillParam(container);
      }
    }
    log.info(`recentClearAll ${this.panelManager.getSceneContainerSessionList()
      .length} ${this.panelManager.getFloatingSessionList().length}`);
  }

  /**
   * 一键删除中，模糊的动效需要延迟的时间，加锁应用存在屏幕中 450，不可删除 350
   *
   * @param { boolean } isContainerLocked - 是否包含上锁的container.
   * @param { SCBSceneContainerSessionArray } inScreenContainer - 屏幕内的container.
   */
  public delayTimeForBlurAnimation(isContainerLocked: boolean,
    inScreenContainer: SCBSceneContainerSessionArray): number {
    if (isContainerLocked) {
      return launcherVisualEffectMgr.isRecentBlurEffectDisabled() ? 550 : 450;
    }
    let delayTime = 0;
    for (let container of inScreenContainer) {
      if (this.recentDelete.isUnclearAbleWhenClearAll(container)) {
        delayTime = launcherVisualEffectMgr.isRecentBlurEffectDisabled() ? 400 : 350;
        break;
      }
    }
    return delayTime;
  }

  /**
   * 加锁卡片标题消失
   *
   * @param { SCBSceneContainerSession } sceneContainerSession - 做动效的卡片
   * @param { UIContext } context - 设备类型.
   * @param { boolean } isDelayUnClearableAnimate - 是否有加锁的卡片.
   */
  public titleDisappearAnimationForUnClearable(sceneContainerSession: SCBSceneContainerSession,
    context: UIContext | undefined,
    isDelayUnClearableAnimate: boolean): void {
    if (sceneContainerSession.isAppLockedForbidDelete) {
      RecentLockIconModel.lockIconPosChangeAnimate(sceneContainerSession, context);
      RecentLockIconModel.lockIconZoomInAnimate(sceneContainerSession);
      RecentLockIconModel.lockIconZoomOutAnimate(sceneContainerSession);
    }
    RecentTitleViewModel.playTitleDisAppearAnimation(sceneContainerSession, isDelayUnClearableAnimate);
  }

  /**
   * 一键删除中，可以删除卡片的销毁
   *
   * @param { SCBSceneContainerSession } sceneContainerSession - 做动效的卡片
   */
  public containerDestructionForClearAll(sceneContainerSession: SCBSceneContainerSession): void {
    // pendingRemove表示销毁卡片中，如果此时启动可以把值置为false，打断销毁
    sceneContainerSession.sessionData.pendingRemove = true;
    // isDisappearing保证动效正常，保证卡片在树上，可以做动效
    sceneContainerSession.isDisappearing = true;

    sceneContainerSession.setIsClearSession(true);
    // 通知窗口卡片销毁，active状态的卡片不走强杀
    sceneContainerSession.requestDestruction(true, false, true, !sceneContainerSession.isActive, true);
  }


  /**
   * active状态的container 在closeList中的container不被强杀
   *
   * @param { SCBSceneContainerSession } sceneContainerSession - 做动效的卡片
   */
  private checkIsForceCleanForSession(session: SCBSceneSession, isActive: boolean): void {
    if (this.panelManager.getCloseContainerSessionList().findSessionIndexForCloseList(session) !== -1 || isActive) {
      log.info(`set close for ${session.sceneInfo.bundleName}`);
      session.sessionData.isForceCleanWhenClearAll = false;
    }
  }

  /**
   * 遍历closeList，属于list中的app / active状态 不走强杀
   *
   * @param { SCBSceneContainerSession } sceneContainerSession - 做动效的卡片
   */
  public setIsForceCleanForContainer(cloneList: SCBSceneContainerSessionArray): void {
    cloneList.forEach((container) => {
      if (!container) {
        log.showError('container is null.')
        return;
      }
      // 分屏和全屏应用
      if (!container.isMidScene) {
        container.primarySession && this.checkIsForceCleanForSession(container.primarySession, container.isActive);
        container.secondarySession && this.checkIsForceCleanForSession(container.secondarySession, container.isActive);
      } else {
        for (let ele of container.midSceneMap.values()) {
          this.checkIsForceCleanForSession(ele, container.isActive)
        }
      }
    })
  }

  /**
   * active状态的container 在closeList中的container不被强杀
   *
   * @param { SCBSceneContainerSession } sceneContainerSession - 做动效的卡片
   */
  public resetIsKillParam(container: SCBSceneContainerSession): void {
    if (!container) {
      log.showError('container is null.')
      return;
    }
    // 分屏和全屏应用
    if (!container.isMidScene) {
      if (container.primarySession) {
        container.primarySession.sessionData.isForceCleanWhenClearAll = true;
      }
      if (container.secondarySession) {
        container.secondarySession.sessionData.isForceCleanWhenClearAll = true;
      }
    } else {
      for (let ele of container.midSceneMap.values()) {
        ele.sessionData.isForceCleanWhenClearAll = true;
      }
    }
    log.info(`reset closeParam ${container.primarySession?.sessionData.isForceCleanWhenClearAll}`);
  }

  /**
   * 清理多任务List
   *
   * @param { number } animationCount - 动效前transitioncount
   * @param { SCBSceneContainerSession } sceneContainer - 做动效的卡片
   */
  public clearRecentListIfNeed(animationCount: number, sceneContainer: SCBSceneContainerSession): void {
    if (animationCount !== sceneContainer.getTransitionCount()) {
      return;
    }
    recentRuntimeInstance.exit();
    RecentTitleViewModel.exit();
    SceneBoardStateManager.getInstance().consumeEvent(CoreEventType.EXIT_RECENT);
    log.info(`clear recent list`);
  }
}