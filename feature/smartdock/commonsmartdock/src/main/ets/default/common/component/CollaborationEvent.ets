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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DockItemInfo } from '@ohos/launchercommon';

const TAG = 'CollaborationEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Collaboration Event
 */
  export class CollaborationEvent {

   /**
   * changeServiceList
   *
   * @param serviceInfo serviceInfo
   */
  public static changeServiceList(perceptionType: number, serviceInfo: DockItemInfo): void {
    // perceptionType为0代表入场，为1代表退场
    let serviceList: DockItemInfo[] = [];
    if (perceptionType === 0) {
      log.showInfo('add serviceList');
      serviceList.push(serviceInfo);
    } else if (perceptionType === 1) {
      CollaborationEvent.clearCarDataList();
    }
  }

  /**
   * 判断当前collaborationDataList是否存在车机应用
   * @param collaborationDataList
   * @param item
   * @returns
   */
  private static isCollaborationDataListExistItem(collaborationDataList: DockItemInfo[], item: DockItemInfo):
    boolean {
    let existFlag: boolean = false;
    if (CheckEmptyUtils.isEmptyArr(collaborationDataList)) {
      return existFlag;
    }
    for (let dockItemInfo of collaborationDataList) {
      if (dockItemInfo.bundleName === item.bundleName) {
        existFlag = true;
        break;
      }
    }
    return existFlag;
  }

  /**
   * 清理车机数据
   */
  public static clearCarDataList(): void {
    let carDataList: DockItemInfo[] = [];
  }
}