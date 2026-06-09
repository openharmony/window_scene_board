/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import { DockItemInfo, SmartDockStyleConfig } from '@ohos/launchercommon';

@Observed
export class CommonDockAppIconAreaViewData {
  public screenId: number = 0;
  public localResidentList: DockItemInfo[] = [];
  public localRecentList: DockItemInfo[] = [];
  public systemItemList: DockItemInfo[] = [];
  public iconSize: number = 0;
  public dockListItemWidth: number = 0;
  public dockListItemGap: number = 0;
  public dockListDirection: number = 0;
  public dockHeight: number = 0;
  public residentListAreaWidth: number = 0;
  public recentListAreaWidth: number = 0;
  public additionResidentListWidth: number = 0;
  public additionRecentListWidth: number = 0;
  public baseResidentListWidth: number = 0;
  public baseRecentListWidth: number = 0;
  public residentStartIndex: number = 0;
  public recentStartIndex: number = 0;
  public residentMaxNum: number = 0;
  public recentMaxNum: number = 0;
  public isResidentArrowShow: boolean = false;

  public updateRecentListAreaWidth(globalRecentList: DockItemInfo[], cfg: SmartDockStyleConfig): void {
    let recentAppNum: number = 0;
    recentAppNum = globalRecentList.length;

    this.recentListAreaWidth = (cfg.mListItemWidth + cfg.mListItemGap) * recentAppNum;
  }

  /**
   * Whole as a string
   *
   * @returns
   */
  public toString(): string {
    return [`sid: ${this.screenId}`, `iconSize: ${this.iconSize}`, `dockListItemWidth: ${this.dockListItemWidth}`,
      `dockListItemGap: ${this.dockListItemGap}`, `dockListDirection: ${this.dockListDirection}`,
      `dockHeight: ${this.dockHeight}`, `residentListAreaWidth: ${this.residentListAreaWidth}`,
      `recentListAreaWidth: ${this.recentListAreaWidth}`,
      `additionResidentListWidth: ${this.additionResidentListWidth}`,
      `additionRecentListWidth: ${this.additionRecentListWidth}`,
      `baseResidentListWidth: ${this.baseResidentListWidth}`,
      `baseRecentListWidth: ${this.baseRecentListWidth}`, `residentStartIndex: ${this.residentStartIndex}`,
      `residentMaxMaxNum: ${this.residentMaxNum}`, `recentMaxMaxNum: ${this.recentMaxNum}`].join(',');
  }
}