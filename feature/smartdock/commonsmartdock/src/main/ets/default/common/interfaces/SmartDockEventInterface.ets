/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import type { SCBSceneContainerSession, SCBSceneSession, SCBScreenProperty } from '@ohos/windowscene';
import type { AppItemInfo, DeleteDockItem, MenuInfo } from '@ohos/launchercommon';
import type { DockItemInfo } from '@ohos/launchercommon';
import type { RecentBundleMissionInfo } from '@ohos/launchercommon';
import type { SnapshotInfo } from '@ohos/launchercommon';
import type { AppStatus } from '@ohos/launchercommon';

/**
 * smartdock event interface
 */
export interface SmartDockEventInterface {

  /**
   * resident dock item onClick function
   * @param event
   * @param item
   * @param callback
   * @param startNewAbility whether start new ability
   * @return whether to open the missions hover window, true is open
   */
  residentOnClick: (event: ClickEvent | null, item: DockItemInfo, startNewAbility: boolean, callback?: Function | null,
    params?: Map<string, Object>) => boolean;

  /**
   * resident dock item onClick with specified screenId
   *
   * @param screenId Source screen ID
   * @param event
   * @param item
   * @param startNewAbility whether start new ability
   * @param callback
   * @param params
   * @returns whether to open the missions hover window, true is open
   */
  residentOnClickWithDisplay: (screenId: number, event: ClickEvent | null, item: DockItemInfo,
    startNewAbility: boolean, callback?: Function | null, params?: Map<string, Object>) => boolean;

  /**
   * recent dock item onClick function
   * @param event
   * @param item
   * @param startNewAbility whether start new ability
   * @return whether to open the missions hover window, true is open
   */
  recentOnClick: (event: ClickEvent | null, item: DockItemInfo, startNewAbility: boolean,
    callback?: Function | null) => boolean;

  /**
   * recent dock item onClick function
   *
   * @param screenId Source screen ID
   * @param event
   * @param item
   * @param startNewAbility whether start new ability
   * @param callback
   * @returns whether to open the missions hover window, true is open
   */
  recentOnClickWithDisplay: (screenId: number, event: ClickEvent, item: DockItemInfo, startNewAbility: boolean,
    callback?: Function) => boolean;

  /**
   * build menu for @Component CustomOverlay
   * @param appInfo
   * @param dockType
   * @param callback
   * @param screenId
   */
  buildMenuInfoList: (appInfo: DockItemInfo, dockType: number, formDialog?: CustomDialogController | null,
    callback?: Function, screenId?: number) => MenuInfo[];

  /**
   * 构建非安装状态应用长按菜单Map
   * @param bundleName 应用bundleName
   * @returns Map<AppStatus, MenuInfo[]>
   */
  buildNotInstalledAppMenu: (item: DockItemInfo, dialog: CustomDialogController) => Map<AppStatus, MenuInfo[]>;

  /**
   * delete dock item
   * @param dockItem
   * @param dockType
   */
  deleteDockItem: (dockItem: DeleteDockItem, dockType: number) => void;

  /**
   * get selected dock Item
   * @returns
   */
  getSelectedItem: () => DockItemInfo | undefined;

  /**
   * get selected dock type
   * @returns
   */
  getSelectedDockType: () => number;

  /**
   * 初始化数据列表
   *
   * @param containerSessionList 会话列表
   */
  initRecentDataList: (containerSessionList: SCBSceneContainerSession[], tag?: string) => void;

  /**
   * 更新数据列表
   *
   * @param containerSessionList 全屏会话列表
   * @param floatSceneSessionList 悬浮窗会话列表
   */
  updateRecentDataList: (containerSessionList: Array<SCBSceneContainerSession>,
    floatSceneSessionList: Array<SCBSceneSession>, screenProperty: SCBScreenProperty) => void;

  /**
   * get snapshot
   *
   * @param missionIds missionid list
   * @return snapshot list
   */
  getSnapshot: (missionInfos: RecentBundleMissionInfo) => Promise<SnapshotInfo[]>;

}