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
import { DockContinuableInfo, DockItemInfo } from '@ohos/launchercommon';
import { DockArrowModel } from './DockArrowModel';

export class ExtScreenModeDockBarModel {
  /* Dock栏业务模型数据 */
  public attachedScreenId: number = 0;
  public screenWidth: number = 0;
  public localResidentList: DockItemInfo[] = [];
  public localRecentList: DockItemInfo[] = [];
  public systemItemList: DockItemInfo[] = [];
  public residentNum: number = 0;
  public recentNum: number = 0;

  /* 系统信息 */
  public isShowContinuableItem: boolean = false;
  public currentColorMode: number = 0;

  /* Dock箭头 */
  public arrowThreshold: number = 0;
  public residentMaxNum: number = 0;
  public recentMaxNum: number = 0;
  public residentStartIndex: number = 0;
  public recentStartIndex: number = 0;

  /* Dock跟手动效参数 */
  public additionResidentListWidth: number = 0;
  public additionRecentListWidth: number = 0;
  public baseResidentListWidth: number = 0;
  public baseRecentListWidth: number = 0;

  /* Dock布局信息 */
  public iconSize: number = 0;
  public dockListItemWidth: number = 0;
  public dockListItemGap: number = 0;
  public dockListDirection: number = 0;
  public dockHeight: number = 0;
  public residentListAreaWidth: number = 0;
  public recentListAreaWidth: number = 0;
  public recentScrollCount: number = 0;
  public residentScrollCount: number = 0;

  /* Dock箭头模型数据 */
  public arrowModel: DockArrowModel | null = null;

  /* Dock接续图标信息 */
  public deviceInfo: DockContinuableInfo = new DockContinuableInfo();

  /**
   * All As a String
   *
   * @returns
   */
  public toString(): string {
    return [`screenId: ${this.attachedScreenId}`, `screenWidth: ${this.screenWidth}`,
      `residentNum: ${this.residentNum}`, `recentNum: ${this.recentNum}`, `rsLen: ${this.localResidentList.length}`,
      `rcLen: ${this.localRecentList.length}`, `currentColorMode: ${this.currentColorMode}`,
      `arrowThreshold: ${this.arrowThreshold}`, `residentMaxNum: ${this.residentMaxNum}`,
      `recentMaxNum: ${this.recentMaxNum}`, `residentStartIndex: ${this.residentStartIndex}`,
      `recentStartIndex: ${this.recentStartIndex}`, `additionResidentListWidth: ${this.additionResidentListWidth}`,
      `additionRecentListWidth: ${this.additionRecentListWidth}`,
      `baseResidentListWidth: ${this.baseResidentListWidth}`, `baseRecentListWidth: ${this.baseRecentListWidth}`,
      `iconSize: ${this.iconSize}`, `dockListItemWidth: ${this.dockListItemWidth}`,
      `dockListItemGap: ${this.dockListItemGap}`, `dockListDirection: ${this.dockListDirection}`,
      `dockHeight: ${this.dockHeight}`, `residentListAreaWidth: ${this.residentListAreaWidth}`,
      `recentListAreaWidth: ${this.recentListAreaWidth}`, `recentScrollCount: ${this.recentScrollCount}`,
      `residentScrollCount: ${this.residentScrollCount}`, this.arrowModel?.toString()].join(',');
  }
}