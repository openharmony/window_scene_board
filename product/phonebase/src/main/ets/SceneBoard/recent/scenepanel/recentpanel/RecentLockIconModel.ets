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

import { recentLayoutConfigInstance, RecentsStyleConfig } from '@ohos/recents';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneContainerSession, SCBSceneContainerSessionArray, SCBSceneSessionManager, SCBScreenProperty } from '@ohos/windowscene';
import {
  LockType,
  RecentAccessibilityUtils
} from './RecentAccessibilityUtils';
import { RecentGesture } from './RecentGesture';
import { recentRuntimeInstance } from './RecentRuntimeModel';
import { HiSysEventUtil, ReportParams } from '@ohos/frameworkwrapper';
import { SlideLockAppInRecentParams } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';
import { recentLockModel } from '../../settings/RecentLockModel';
import { RecentLayoutManager } from '../../common/RecentLayoutManager';

const TAG = 'RecentLockIconModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class RecentLockIconModel {
  /**
   * 一键删除时小锁图标放大动画
   * @param sceneContainerSession
   */
  public static lockIconZoomInAnimate(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    animateTo({
      curve: Curve.Sharp,
      duration: 100
    }, () => {
      sceneContainerSession.needRenderLockIconScale.setLockIconScale(1.3);
    })
  }

  /**
   * 一键删除时小锁图标缩小动画
   * @param sceneContainerSession
   */
  public static lockIconZoomOutAnimate(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    animateTo({
      curve: Curve.Sharp,
      duration: 100,
      delay: 300
    }, () => {
      sceneContainerSession.needRenderLockIconScale.setLockIconScale(1);
    })
  }

  /**
   * 下拉卡片超过阈值时小锁出现动画
   * @param sceneContainerSession
   */
  public static lockIconAppearAnimate(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession) {
      return;
    }
    animateTo({
      curve: Curve.Friction,
      duration: 250,
    }, () => {
      sceneContainerSession.needRenderLockIconScale.setLockIconScale(1);
      sceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity(1);
    })
  }

  /**
   * 下拉卡片超过阈值时小锁消失动画
   * @param sceneContainerSession 锁定的应用
   * @param appName 应用名称
   */
  public static lockIconDisAppearAnimate(sceneContainerSession: SCBSceneContainerSession, appName: string): void {
    if (!sceneContainerSession) {
      return;
    }
    recentLockModel.deleteRecentLockForContainer(sceneContainerSession);
    animateTo({
      curve: Curve.Friction,
      duration: 250,
      onFinish: () => {
        RecentAccessibilityUtils.textAnnouncedForLockApp(appName, LockType.UNLOCK);
        RecentLockIconModel.lockStateChange(sceneContainerSession, false);
        RecentAccessibilityUtils.requestFocusForSession(sceneContainerSession, false);
      }
    }, () => {
      sceneContainerSession.needRenderLockIconScale.setLockIconScale(0.5);
      sceneContainerSession.needRenderLockIconOpacity.setLockIconOpacity(0);
    })
  }

  public static getLockIconMarginStart(screenProperty: SCBScreenProperty, titleViewScale: number): number {
    let marginStart = RecentLayoutManager.getTitleWidth(screenProperty) -
    RecentsStyleConfig.getInstance().lockIconClickHotAreaSize +
    RecentsStyleConfig.getInstance().lockIconClickHotAreaPadding;
    return marginStart * titleViewScale;
  }

  /**
   * 一键删除小锁位移动画
   * @param sceneContainerSession
   */
  public static lockIconPosChangeAnimate(sceneContainerSession: SCBSceneContainerSession,
    uiContext: UIContext | undefined): void {
    if (!uiContext || !sceneContainerSession) {
      log.showInfo('no uiContext, keyframe failed');
      return;
    }
    uiContext.keyframeAnimateTo({ iterations: 1 }, [
      {
        duration: 50,
        event: () => {
          sceneContainerSession.needRenderLockIconTranslate.setLockIconTranslateX(-2.5);
        }
      },
      {
        duration: 100,
        event: () => {
          sceneContainerSession.needRenderLockIconTranslate.setLockIconTranslateX(1.25);
        }
      },
      {
        duration: 100,
        event: () => {
          sceneContainerSession.needRenderLockIconTranslate.setLockIconTranslateX(-0.63);
        }
      },
      {
        duration: 100,
        event: () => {
          sceneContainerSession.needRenderLockIconTranslate.setLockIconTranslateX(0.31);
        }
      },
      {
        duration: 100,
        event: () => {
          sceneContainerSession.needRenderLockIconTranslate.setLockIconTranslateX(0);
        }
      }
    ]);
  }

  /**
   * 返回启动一键删除时双行多任务情况下当前屏幕中是否存在加锁卡片
   * @param recentGesture
   * @returns
   */
  public static existLockedSessionInMultiTask(recentGesture: RecentGesture): boolean {
    if (!recentGesture) {
      log.showInfo('recentGesture undefined!');
      return false;
    }

    let notRemovingSessionLength = recentRuntimeInstance.notRemovingSessionList.filterClone().length;
    let multiCol = recentGesture.multiColumnNum;
    let midIndex = recentGesture.middleColumnIndex;
    let leftIndex = recentGesture.leftColumnIndex;
    let rightIndex = recentGesture.rightColumnIndex;
    for (let i = 0; i < notRemovingSessionLength; i++) {
      let container = recentRuntimeInstance.notRemovingSessionList[i];
      if (!container) {
        continue;
      }
      let colIndex = multiCol - 1 - (Math.floor((notRemovingSessionLength - 1 - i) / 2));
      if (colIndex === leftIndex || colIndex === midIndex || colIndex === rightIndex) {
        if (container?.isAppLockedForbidDelete) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * 返回启动一键删除时单行多任务情况下当前屏幕中是否存在加锁卡片
   * @returns
   */
  public static existLockedSessionInSingleTask(): boolean {
    let midIndex = recentRuntimeInstance.autoCenterColumn;
    let rightIndex: number = recentRuntimeInstance.getSafeIndex(midIndex + 1);
    let leftIndex: number = recentRuntimeInstance.getSafeIndex(midIndex - 1);
    let midSession = recentRuntimeInstance.notRemovingSessionList.filterClone()[midIndex];
    if (!midSession) {
      return false;
    }
    if (midSession?.isAppLockedForbidDelete) {
      return true;
    }
    if (rightIndex !== midIndex) {
      let rightSession = recentRuntimeInstance.notRemovingSessionList.filterClone()[rightIndex];
      if (rightSession?.isAppLockedForbidDelete) {
        return true;
      }
    }
    if (leftIndex !== midIndex) {
      let leftSession = recentRuntimeInstance.notRemovingSessionList.filterClone()[leftIndex];
      if (leftSession?.isAppLockedForbidDelete) {
        return true;
      }
    }
    return false;
  }

  /**
   * 是否延迟不可删除相关的动画（模糊or显隐）
   * @param recentGesture
   * @returns
   */
  public static isDelayUnClearableAnimate(recentGesture: RecentGesture): boolean {
    return recentLayoutConfigInstance.isNeedMultiRowLayout() ?
    RecentLockIconModel.existLockedSessionInMultiTask(recentGesture) :
    RecentLockIconModel.existLockedSessionInSingleTask();
  }

  /**
   * 加锁状态改变并进行持久化处理
   * @param sceneContainerSession
   * @param isLock 加锁/解锁
   */
  public static lockStateChange(sceneContainerSession: SCBSceneContainerSession, isLock: boolean): void {
    if (!sceneContainerSession) {
      return;
    }
    log.info(`ForbidDelete from ${sceneContainerSession.isAppLockedForbidDelete} to ${isLock}`);
    sceneContainerSession.isAppLockedForbidDelete = isLock;
    if (sceneContainerSession?.primarySession?.sceneInfo) {
      sceneContainerSession.primarySession.sceneInfo.isLockedInRecent = isLock;
    }
    if (sceneContainerSession?.primarySession?.session) {
      SCBSceneSessionManager.getInstance().getScenePersistent().setLockInRecentStatus(
        sceneContainerSession.primarySession.session.persistentId, isLock);
    }
    if (isLock) {
      recentLockModel.insertRecentLock(sceneContainerSession);
    }
  }

  /**
   * 下拉锁定打点
   * @param sceneContainerSession 锁定卡片
   * @param lockType 锁定类型 0：锁定 1：取消锁定
   */
  public static reportSlideLock(sceneContainerSession: SCBSceneContainerSession, lockType: number): void {
    let reportParams : SlideLockAppInRecentParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: sceneContainerSession?.getBundleName(),
      LOCK_TYPE: lockType
    };
    HiSysEventUtil.reportSlideLockAppInRecent(reportParams);
  }
}