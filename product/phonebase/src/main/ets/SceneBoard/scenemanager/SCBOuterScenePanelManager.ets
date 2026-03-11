/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ArrayUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import {
  ContainerDataCategory,
  SCBPropertyChangeReason,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBScenePanelManager,
  SCBSceneSessionManager
} from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { OuterAppManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAppManager';
import { SCBScenePanel } from './SCBScenePanel';
import {
  defaultRecentDeleteConfig,
  outerRecentDeleteConfig,
  RecentDelete
} from '../recent/scenepanel/recentpanel/RecentDelete';
import { display } from '@kit.ArkUI';
import { SmallFoldStyleUtil } from '@ohos/launchercommon/src/main/ets/utils/SmallFoldStyleUtil';
import { ContainerShowState, RecentNotShow } from '../recent/scenepanel/recentpanel/RecentNotShow';

const TAG = 'SCBOuterScenePanelManager';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

const BIT_MASK = 0xffff;

/**
 * 折叠开合场景，多任务session管理 （扩展新形态小折叠产品）
 *
 * @param reason 屏幕属性变化的原因
 * @param scenePanel SCBScenePanel
 * @param containerSessionList 当前多任务的containerSessionList
 * @param floatingSessionList 当前多任务的floatingSessionList
 * @param totalContainerSessionList 当前多任务的totalContainerSessionList
 * @param recentNotShow RecentNotShow
 */
export interface parmForOuter {
  reason: SCBPropertyChangeReason;
  scenePanel: SCBScenePanel;
  containerSessionList: SCBSceneContainerSessionArray;
  floatingSessionList: SCBSceneContainerSessionArray;
  totalContainerSessionList: SCBSceneContainerSessionArray;
  recentNotShow: RecentNotShow;
}

/**
 * 用于存放外屏多任务的方法管理
 */
export class SCBOuterScenePanelManager {
  private filterList: Map<string, string[]> = SmallFoldStyleUtil.getMultitaskingFilterMap();
  private mOuterAppManager: OuterAppManager = OuterAppManager.getInstance();

  /**
   * 获取SCBOuterScenePanelManager单例的静态方法
   *
   * @returns SCBOuterScenePanelManager单例
   */
  public static getInstance(): SCBOuterScenePanelManager {
    return SingletonHelper.getInstance(SCBOuterScenePanelManager, TAG);
  }

  /**
   * 更新当前status
   *
   * @param status 当前样机的状态
   */
  public updateCurrentStatus(status: display.FoldDisplayMode): void {
    AppStorage.setOrCreate('singleDisplayPocketFoldDisplayMode', status);
  }

  private isBlockListSession(item: string, abilityName: string): boolean {
    if (!item) {
      return false;
    }
    return this.mOuterAppManager.isBlockApp(item, abilityName);
  }

  /**
   * 持久化lastUsedPosition字段
   */
  private persistentLastUsedPosition(containerSession: SCBSceneContainerSession | null,
    lastUsedPosition: string): void {
    if (containerSession === null) {
      log.showWarn('persistentLastUsedPosition failed, containerSession is null.');
      return;
    }
    containerSession.getData(ContainerDataCategory.BASIC)?.setLastUsedPosition(lastUsedPosition);
    let sceneSession = containerSession.primarySession;
    if (sceneSession) {
      SCBSceneSessionManager.getInstance().getScenePersistent().modifyPersistentMap(
        sceneSession.session.persistentId & BIT_MASK, sceneSession.sceneInfo,
        containerSession.currentRotation,
        containerSession.getData(ContainerDataCategory.BASIC)?.lastUsedPosition);
    }
  }

  /**
   * 折叠开合场景，多任务session管理 （扩展新形态小折叠产品）
   *
   * @param parm parmForOuter 多任务session管理入参
   */
  public processSingleDisplayPocketFold(parm: parmForOuter): void {

  }

  /**
   * filter Scene Container Session List for Outer Screen
   *
   * @param { Number[] } filterIndex
   * @param  SCBSceneContainerSessionArray containerSessionList
   */
  public filterSceneContainerListForOuter(filterIndex: number[],
    containerSessionList: SCBSceneContainerSessionArray, recentDelete?: RecentDelete): void {
    let filterList = new SCBSceneContainerSessionArray();
    let notShowList = new SCBSceneContainerSessionArray();
    containerSessionList.forEach((item) => {
      let lastUsedPosition = item?.getData(ContainerDataCategory.BASIC)?.lastUsedPosition;
      if (ArrayUtils.contains(filterIndex, item.containerId) ||
        !(lastUsedPosition && lastUsedPosition === DeviceHelper.getCurrentDeviceScene())) {
        filterList.add(item);
      } else {
        notShowList.add(item);
      }
    });

    let unClearAbleSessionTotalList = notShowList.filter(item => recentDelete?.isUnclearAbleWhenClearAll(item));
    log.showInfo(`Current containerSessionList length = ${containerSessionList.length}`);
    containerSessionList.clear();
    for (let containerSession of filterList) {
      containerSessionList.push(containerSession);
    }
    for (let containerSession of unClearAbleSessionTotalList) {
      // 做动画的卡片在前面已经全部初始化完成，这里数据的变更都为不可见，
      containerSession.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'filterSceneContainerListForOuter');
      containerSessionList.push(containerSession);
    }
    log.showInfo(`Processed containerSessionList length = ${containerSessionList.length}`);
  }
}