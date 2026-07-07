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
  LogDomain
} from '@ohos/basicutils';
import {
  SCBScenePanelManager,
  SCBSceneSessionManager,
  SCBSceneContainerSession,
  SCBSessionShowInScreenIndex,
  SCBSceneContainerSessionArray,
  ScenePanelState,
  MidSceneMap,
  SCBSceneSession,
  ControlType
} from '@ohos/windowscene';
import {
  DeviceHelper,
} from '@ohos/frameworkwrapper';
import { MemoryManager } from '@ohos/frameworkcommon';
import {
  ItemUtils
} from '@ohos/componenthelper';
import { RecentStyle } from '../../RecentStyle';
import { recentLayoutConfigInstance, RecentsStyleConfig } from '@ohos/recents';
import prompt from '@ohos.promptAction';
import curves from '@ohos.curves';
import { CommonConstants } from '@ohos/launchercommon';
import { ResUtils } from '@ohos/windowscene';
import { RecentLayoutManager } from '../../common/RecentLayoutManager';
import { ArrayUtils } from '@ohos/basicutils';
import { recentMediaPlayInstance } from './RecentMediaPlay';
import { recentRuntimeInstance, RecentRuntimeModel } from './RecentRuntimeModel';
import lazy { SCBRecentPrepareManager } from '../../../scenemanager/pcmode/SCBRecentPrepareManager';

const TAG = 'RecentDelete';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export interface RecentDeleteConfig {
  // RECENT_DELETE_IMAGE_COLUMN_SIZE
  recentDeleteImageColumSize: number;
  // RECENT_DELETE_SYMBOL_COLUMN_RADIUS
  recentDeleteSymbolColumnRadius: string;
  // RECENT_DELETE_SYMBOL_SIZE
  recentDeleteSymbolSize: string;
  // RECENT_DELETE_SYMBOL_BORDER_RADIUS
  recentDeleteSymbolBorderRadius: number;
}

export const defaultRecentDeleteConfig: RecentDeleteConfig = {
  // RECENT_DELETE_IMAGE_SIZE
  recentDeleteImageColumSize: RecentStyle.RECENT_DELETE_IMAGE_COLUMN_SIZE,
  // RECENT_DELETE_SYMBOL_COLUMN_RADIUS
  recentDeleteSymbolColumnRadius: RecentStyle.RECENT_DELETE_SYMBOL_COLUMN_RADIUS,
  // RECENT_DELETE_SYMBOL_SIZE
  recentDeleteSymbolSize: RecentStyle.RECENT_DELETE_SYMBOL_SIZE,
  // RECENT_DELETE_SYMBOL_BORDER_RADIUS
  recentDeleteSymbolBorderRadius: RecentStyle.RECENT_DELETE_SYMBOL_BORDER_RADIUS,
}

export const outerRecentDeleteConfig: RecentDeleteConfig = {
  // RECENT_DELETE_IMAGE_SIZE
  recentDeleteImageColumSize: RecentStyle.RECENT_DELETE_IMAGE_COLUMN_SIZE_OUTER,
  // RECENT_DELETE_SYMBOL_COLUMN_RADIUS
  recentDeleteSymbolColumnRadius: RecentStyle.RECENT_DELETE_SYMBOL_COLUMN_RADIUS_OUTER,
  // RECENT_DELETE_SYMBOL_SIZE
  recentDeleteSymbolSize: RecentStyle.RECENT_DELETE_SYMBOL_SIZE_OUTER,
  // RECENT_DELETE_SYMBOL_BORDER_RADIUS
  recentDeleteSymbolBorderRadius: RecentStyle.RECENT_DELETE_SYMBOL_BORDER_RADIUS_OUTER,
}

export class RecentDelete {
  private readonly panelManager: SCBScenePanelManager;

  constructor(panelManager: SCBScenePanelManager) {
    this.panelManager = panelManager;
  }

  /**
   * 弹出删除弹框
   */
  public showClearAllMissionsToast(index: SCBSessionShowInScreenIndex): void {
    if (recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      this.showClearToast(index, SCBSessionShowInScreenIndex.INDEX_RIGHT);
    } else {
      this.showClearToast(index, SCBSessionShowInScreenIndex.INDEX_MIDDLE);
    }
  }

  private showClearToast(index: SCBSessionShowInScreenIndex,
    deleteMissionLocation: SCBSessionShowInScreenIndex): void {
    if (index === deleteMissionLocation) {
      log.showInfo('showClearToast, index matches');
      MemoryManager.getInstance().notifyClearRecentMissions();
    }
  }

  /**
   * 一键清理时是否禁止删除 isUnclearAbleContainer
   */
  public isUnclearAbleWhenClearAll(session: SCBSceneContainerSession): boolean {
    if (!session) {
      log.showError(`session is null.`);
      return false;
    }
    if (session.primarySession?.isUnclearable() || session.secondarySession?.isUnclearable()) {
      log.showInfo(`session Unclearable.`);
      return true;
    }
    if (session.primarySession?.sceneInfo.isLockedInRecent || session.secondarySession?.sceneInfo.isLockedInRecent) {
      log.showInfo(`session locked. ${session.primarySession?.sceneInfo.isLockedInRecent} ${session.secondarySession?.sceneInfo.isLockedInRecent}`);
      return true;
    }
    let sceneInfo = session?.primarySession?.sceneInfo;
    if (sceneInfo &&
      recentMediaPlayInstance.isContainerMediaPlay(`${sceneInfo?.bundleName}${sceneInfo?.abilityName}`)) {
      return true;
    }
    sceneInfo = session?.secondarySession?.sceneInfo;
    if (sceneInfo &&
      recentMediaPlayInstance.isContainerMediaPlay(`${sceneInfo?.bundleName}${sceneInfo?.abilityName}`)) {
      return true;
    }
    if (session?.isMidScene && this.isMidSceneUnClearable(session)) {
      log.showInfo(`session MidScene UnClearable.`);
      return true;
    }
    if (DeviceHelper.isPad() && SCBRecentPrepareManager.getInstance().isPcAppInPadByContainer(session)) {
      log.showInfo(`session isPcAppInPadByContainer.`);
      return true;
    }
    return false;
  }

  /**
   * 上滑删除时是否禁止删除 isUnclearAbleWhenMoveClear
   */
  public isUnclearAbleWhenMoveClear(session: SCBSceneContainerSession): boolean {
    if (!session) {
      return false;
    }
    if (session.primarySession?.isUnclearable() || session.secondarySession?.isUnclearable()) {
      return true;
    }
    return false;
  }

  /**
   * 禁止删除的任务包名list
   */
  public getUnClearAbleBundleNameList(totalContainerSessionList: SCBSceneContainerSessionArray): string[] {
    let unClearAbleList: string[] = [];
    if (!totalContainerSessionList) {
      return unClearAbleList;
    }
    for (let i = 0; i < totalContainerSessionList.length; i++) {
      let bundleName = totalContainerSessionList[i].primarySession?.sceneInfo.bundleName
      if (totalContainerSessionList[i].primarySession?.isUnclearable() && bundleName) {
        unClearAbleList.push(bundleName);
      }
    }
    return unClearAbleList
  }

  public static getClearAllButtonPos(): Position {
    let screenProperty = SCBScenePanelManager.getInstance().getScreenProperty()
    let halfRecentDeleteImageSize = vp2px(RecentStyle.RECENT_DELETE_IMAGE_COLUMN_SIZE) / 2;
    let posX = screenProperty.width / 2 - halfRecentDeleteImageSize;
    let realBottomMargin: number = RecentLayoutManager.getRealBottomMargin(screenProperty)
    let posY = screenProperty.height - vp2px(realBottomMargin) / 2 - halfRecentDeleteImageSize;

    return {
      x: ItemUtils.num2PxStr(posX),
      y: ItemUtils.num2PxStr(posY)
    };
  }

  /**
   * 禁止删除的任务包名list, listLen 当前有几张卡片做动效
   */
  public showStatusBarIfNeedOnfinish(scenePanelState: ScenePanelState, listLen: number): void {
    // 最后一张卡片删除动画结束时恢复状态栏（scenePanelState 可能尚未切 HOME）
    if (listLen === 1) {
      SCBSceneSessionManager.getInstance().enterRecentTask(false);
    }
  }

  /**
   * 是否是notshow且需要被删除的应用
   */
  private isClearInNotShow(container: SCBSceneContainerSession) {
    if (this.isUnclearAbleWhenClearAll(container)) {
      return false;
    }
    if (container && container.primarySession?.sceneInfo.needClearInNotShowRecent) {
      return true;
    }
    return false;
  }

  /**
   * 删除和销毁notshow里面的可删除的container
   */
  public destructContaierInNotShow(): void {
    let notShowList = this.panelManager.getNotShowRecentList();
    for (let i = notShowList.length - 1; i >= 0; i--) {
      let container = notShowList[i];
      if (this.isClearInNotShow(container)) {
        let res = notShowList.splice(i, 1)[0];
        if (res) {
          container.requestDestruction(true, false, true, true, true);
          this.deleteOtherScreenContainerSessionIfNeed(container);
          log.info(`deleteAll clear container delContainer${res.getName()} ${container.getName()}`);
        }
      }
    }
  }

  /**
   * 新形态小折叠产品，一键清理notShow数据时，同步清理其他屏幕中的containerSessionList数据
   *
   * @param container notShowList中的数据
   */
  private deleteOtherScreenContainerSessionIfNeed(container: SCBSceneContainerSession): void {
    if (this.panelManager.getSceneContainerSessionList().findIndexByContainerId(container?.containerId) >= 0 &&
      this.panelManager.getSceneContainerSessionListForView().findIndexByContainerId(container?.containerId) < 0) {
      this.panelManager.removeSceneContainerSession(container);
    }
  }

  public setNeedRenderPosForDeleteAllAnimation(session: SCBSceneContainerSession, currentOffsetX: number): void {
    if (!session) {
      return;
    }
    let newPosX = session.needRenderPos.posX - currentOffsetX;
    let nameDfx = session.getName();
    session.needRenderPos.setPosXWithDfx(0, TAG, 'setPosXForDeleteAllAnimation', nameDfx);
    session.needRenderTranslate.setTranslateXWithDfx(session.needRenderTranslate.translateX + newPosX, TAG,
      'setPosXForDeleteAllAnimation', nameDfx);
  }

  /**
   * filter Scene Container Session List
   *
   * @param { Number[] } filterIndex
   * @param { prepareSessions }  prepare Terminate application sessions which is pc application in pad
   */
  public filterSceneContainerSessionList(containerSessionList: SCBSceneContainerSessionArray, filterIndex: number[],
    prepareSessions: SCBSceneContainerSessionArray): void {
    let filterList = containerSessionList.filter((item, index) => {
      return ArrayUtils.contains(filterIndex, index);
    });
    let notShowList = containerSessionList.filter((item, index) => {
      return !ArrayUtils.contains(filterIndex, index);
    });
    let unClearAbleSessionTotalList = notShowList.filter((item) =>
    this.isUnclearAbleWhenClearAll(item) ||
    prepareSessions.findByContainerId(item.containerId));
    containerSessionList.clear();
    for (let containerSession of filterList) {
      containerSessionList.push(containerSession);
    }
    for (let containerSession of unClearAbleSessionTotalList) {
      // 做动画的卡片在前面已经全部初始化完成，这里数据的变更都为不可见，
      containerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'filterSceneContainerSessionList');
      containerSessionList.push(containerSession);
    }
  }

  private isMidSceneUnClearable(session: SCBSceneContainerSession): boolean {
    if (!session) {
      return false;
    }
    let midSceneMap: MidSceneMap<number, SCBSceneSession> = session.midSceneMap;
    let unClearable = false;
    midSceneMap.forEach((value) => {
      if (value?.sceneInfo &&
        recentMediaPlayInstance.isContainerMediaPlay(
          `${value?.sceneInfo?.bundleName}${value?.sceneInfo?.abilityName}`)) {
        unClearable = true;
        return;
      }
    });
    return unClearable;
  }

  /**
   * terminate时，多任务相关list和leftBoundaryIndex参数的处理
   * 16张以内和以外的都需要执行更新,notRemovingSessionList的操作，recentRuntimeInstance.leftBoundaryIndex在更新后读出自动减一
   * 边界范围外的卡片：此时多任务列表notRemovingSessionList.length减一，多任务显示数量containerCountsShowInRecent无需变动
   * 删除边界范围内的应用或当前只有一张卡片的时候，最大显示数量需要减1
   *
   * @param { SCBSceneContainerSessionArray } totalContainerSessionList - 多任务totallist
   * @param { number } containerId - 被terminate卡片的containerId
   * @param { number } index - 被terminate卡片在notRemovingSessionList中的index
   * @returns { void }
   */
  public setParamAfterTerminate(totalContainerSessionList: SCBSceneContainerSessionArray, containerId: number,
    index: number): void {
    log.showInfo(`setParamAfterTerminate  ${index} ${recentRuntimeInstance.leftBoundaryIndex}`);
    if (index >= recentRuntimeInstance.leftBoundaryIndex || recentRuntimeInstance.notRemovingSessionList.length === 0) {
      recentRuntimeInstance.containerCountsShowInRecent--;
    }
    totalContainerSessionList.deleteByContainerId(containerId);
    recentRuntimeInstance.update(totalContainerSessionList);
  }

  /**
   * 松手的时候，title还在显示的状态，增加一个title消失的动效
   *
   * @param { SCBSceneContainerSession } container
   * @returns { void }
   */
  public titleDisappearAnimationForDelete(sceneContainerSession: SCBSceneContainerSession): void {
    if (!sceneContainerSession || sceneContainerSession.needRenderTitleViewAlpha.titleViewAlpha === 0) {
      log.info(`sceneContainerSession is null!`);
      return;
    }
    let param: AnimateParam = {
      curve: curves.responsiveSpringMotion()
    };
    animateTo(param, () => {
      sceneContainerSession.needRenderTitleViewAlpha.setTitleViewAlpha(0);
    });
  }

  /**
   *多任务垃圾桶提亮
   */
  public static backgroundNineDarkOption: BrightnessOptions = {
    rate: ResUtils.getConvertNumber($r('app.float.Control_center_icon_default_bg_brightness')),
    lightUpDegree: ResUtils.getConvertNumber($r('app.float.phone_clear_brightness_lightUpDegree_off_darkMode')),
    cubicCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    quadCoeff: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_default')),
    fraction: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_off')),
    saturation: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_n_dark')),
    posRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_redCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_greenCof1_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_blueCof1_dark'))],
    negRGB: [ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_redCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_greenCof2_dark')),
      ResUtils.getConvertNumber($r('app.float.Control_center_brightness_edit_card_bg_blueCof2_dark'))]
  };

  /**
   * is session locked in container
   * @returns boolean
   */
  public static isAppLocked(sceneContainer: SCBSceneContainerSession): boolean {
    if (!sceneContainer) {
      log.showWarn(`container is null.`);
      return false;
    }
    if (!sceneContainer.isMidScene) {
      return sceneContainer.primarySession?.useControlList?.[0] === ControlType.APP_LOCK ||
        sceneContainer.secondarySession?.useControlList?.[0] === ControlType.APP_LOCK;
    }
    for (let ele of sceneContainer.midSceneMap.values()) {
      if (ele.useControlList?.[0] === ControlType.APP_LOCK) {
        return true;
      }
    }
    return false;
  }
}