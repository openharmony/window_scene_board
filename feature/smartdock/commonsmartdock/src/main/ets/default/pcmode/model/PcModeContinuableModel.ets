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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { DockContinuableInfo, DockItemInfo, RecentBundleMissionInfo } from '@ohos/launchercommon';
import RecentDockModel from '../../model/RecentDockModel';
import { PcModeDockUtils } from '../../utils/PcModeDockUtils';

const TAG = 'PcModeContinuableModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default class PcModeContinuableModel {
  private static instance : PcModeContinuableModel;
  private _continuableItemDisappearInfo: ContinuableItemDisappearInfo | null = null;
  private _isOpenPopupOnContinuableItem: boolean = false;

  private constructor() {
  }

  private findContinuableItemInRecentList(recentList: DockItemInfo[], deviceInfo: DockContinuableInfo): number {
    return recentList.findIndex((item: DockItemInfo) => {
      return item.bundleName === deviceInfo.bundleName && (item.appIndex ?? 0) === 0;
    });
  }

  /**
   * 对比新旧列表上一次接续图标位置前的数据, 若全部相同，则说明接续图标位置没变; 若出现不相同的, 说明接续图标前方减少了一个图标, 接续图标位置要减1
   * @param newList 当前要更新的列表, this.localRecentList是上次显示的列表
   * @returns 返回新的接续图标位置索引
   */
  private getRealContinueItemIndex(oldList: DockItemInfo[], newList: DockItemInfo[], lastContinueItemIndex: number):
    number {
    const length: number = Math.min(lastContinueItemIndex, newList.length);
    log.showInfo(`getRealContinueItemIndex minLength: ${length}, lastRecentListLen: ${oldList.length}, curRecentListLen: ${newList.length}`);
    let diffIndex: number = -1;
    for (let i = 0; i < length; i++) {
      if (oldList[i]?.bundleName !== newList[i]?.bundleName || oldList[i]?.appIndex !== newList[i]?.appIndex) {
        diffIndex = i;
        break;
      }
    }
    let continuableItemIndex = diffIndex === -1 ? lastContinueItemIndex : lastContinueItemIndex - 1;
    log.showInfo(`diffIndex: ${diffIndex}, continuableItemIndex: ${continuableItemIndex}`);
    return continuableItemIndex;
  }

  public set continuableItemDisappearInfo(value: ContinuableItemDisappearInfo | null) {
    this._continuableItemDisappearInfo = value;
  }

  public get continuableItemDisappearInfo(): ContinuableItemDisappearInfo | null {
    return this._continuableItemDisappearInfo;
  }

  public set isOpenPopupOnContinuableItem(value: boolean) {
    this._isOpenPopupOnContinuableItem = value;
  }

  public get isOpenPopupOnContinuableItem(): boolean {
    return this._isOpenPopupOnContinuableItem;
  }

  public isRealContinuableItemExist(recentList: DockItemInfo[], deviceInfo: DockContinuableInfo, ): boolean {
    if (RecentDockModel.getInstance().continuableItemExists(deviceInfo) &&
      PcModeDockUtils.isInDockList(recentList, deviceInfo.bundleName)) {
      return true;
    }
    return false;
  }

  /**
   *接续图标如果不在列表最后一位, 点击拉起本地窗口时需要更新dock运行区本地图标的位置
   * @param list 要更新的运行区列表
   */
  public updateDisappearContinuableItem(list: Array<RecentBundleMissionInfo>): void {
    const info = this._continuableItemDisappearInfo;
    if (!info || CheckEmptyUtils.checkStrIsEmpty(info.bundleName) || info.index === -1) {
      return;
    }
    const curentIndex = list.findIndex((item: RecentBundleMissionInfo) => {
      return item.bundleName === info.bundleName && (item.appIndex ?? 0) === 0;
    });
    log.showInfo(`updateDisappearContinuableItem bundleName: ${info.bundleName}, info.index: ${info.index}, curentIndex: ${curentIndex}`);
    if (curentIndex >= 0 && curentIndex === (list.length - 1)) {
      list.splice(info.index, 0, list.splice(curentIndex, 1)[0]);
      this._continuableItemDisappearInfo = null;
    }
  }

  /**
   * 更新接续图标在运行区的位置
   * @param localRecentList
   * @param isAddContinuableItem
   */
  public updateContinuableItemInList(residentList: DockItemInfo[], oldRecentList: DockItemInfo[],
    localRecentList: DockItemInfo[], deviceInfo: DockContinuableInfo,
    isAddContinuableItem: boolean = false): void {
    if (!RecentDockModel.getInstance().continuableItemExists(deviceInfo)) {
      log.showInfo('continue is not show, return');
      return;
    }
    // 由对端触发的接续图标出现, 将接续图标添加到末尾
    if (isAddContinuableItem && !PcModeDockUtils.isInDockList(localRecentList, deviceInfo.bundleName) &&
      !PcModeDockUtils.isInDockList(residentList, deviceInfo.bundleName)) {
      localRecentList.push(deviceInfo);
      log.showInfo(`add continuable Item Index: ${localRecentList.length}`);
      return;
    }
    if (!isAddContinuableItem) {
      // 之前的列表找到接续合并图标的位置和图标信息
      const lastContinuableItemIndex: number = this.findContinuableItemInRecentList(oldRecentList, deviceInfo);
      const realContinuableItemIndex: number = this.getRealContinueItemIndex(oldRecentList, localRecentList,
        lastContinuableItemIndex);
      const curContinuableItemIndex: number = this.findContinuableItemInRecentList(localRecentList, deviceInfo);
      log.showInfo(`updateContinuableItemInList lastContinuableItemIndex: ${lastContinuableItemIndex}, curContinuableItemIndex: ${curContinuableItemIndex}, realContinuableItemIndex: ${realContinuableItemIndex}`);
      if (curContinuableItemIndex >= 0) {
        if (curContinuableItemIndex === realContinuableItemIndex) {
          // 接续合并图标位置没有发生变化
          log.showInfo(`continuableItem not change, Index: ${curContinuableItemIndex}`);
          return;
        }
        if (realContinuableItemIndex >= 0) {
          // 接续合并图标位置变化, 更新位置
          log.showInfo(`change continue item position from ${curContinuableItemIndex} to ${realContinuableItemIndex}`);
          const curContinueItem: DockItemInfo = localRecentList[curContinuableItemIndex];
          localRecentList.splice(curContinuableItemIndex, 1);
          localRecentList.splice(realContinuableItemIndex, 0, curContinueItem);
          return;
        }
        return;
      }
      if (lastContinuableItemIndex >= 0 && !PcModeDockUtils.isInDockList(residentList, deviceInfo.bundleName)) {
        // 合并接续图标消失, 更新接图标以及位置。 如果常驻区文件夹内有对应图标则显示接续图标。该场景pc上不支持菜单和拖拽显示接续图标
        if (DeviceHelper.isPC() || PcModeDockUtils.isInResidentFolder(residentList, deviceInfo.bundleName)) {
          localRecentList.splice(realContinuableItemIndex, 0, deviceInfo);
          log.showInfo(`is in folder, add continue item, index: ${realContinuableItemIndex},`);
        } else {
          localRecentList.splice(realContinuableItemIndex, 0, oldRecentList[lastContinuableItemIndex]);
          log.showInfo(`add merge continue item, index: ${realContinuableItemIndex},`);
        }
      }
    }
  }

  static getInstance(): PcModeContinuableModel {
    if (PcModeContinuableModel.instance == null) {
      PcModeContinuableModel.instance = new PcModeContinuableModel();
    }
    return PcModeContinuableModel.instance;
  }
}

export interface ContinuableItemDisappearInfo {
  bundleName: string;
  index: number;
}