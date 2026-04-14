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

import type ctx from '@ohos.app.ability.common';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { BadgeAnimationType } from '@ohos/launchercommon/Index';
import {
  CommonConstants,
  ContractedFolderLayoutViewModel,
  FolderAppItemInfo,
  FolderConstants,
  GridLayoutItemInfo,
  GridLayoutUtil
} from '@ohos/launchercommon/src/main/ets/TsIndex';

const TAG = 'FolderItemBadgeChangeNotifyUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/* 文件夹角标更新工具类 */
export class FolderItemBadgeChangeNotifyUtils {
  /* 小文件夹角标更新 */
  public static notifySmallFolderItemBadgeChange(folderId: string | undefined, isOpen: boolean): void {
    if (CheckEmptyUtils.isEmpty(folderId)) {
      return;
    }
    let aniType: BadgeAnimationType = isOpen ? BadgeAnimationType.HIDE_WITHOUT_ANIM :
      BadgeAnimationType.CLOSE_FOLDER_COMPONENT_SHOW;
    ContractedFolderLayoutViewModel.getInstance().getDataOsrMgr(folderId)
      .updateBadgeAniType(aniType, `folder ${isOpen ? 'open to hide' : 'close to show'}`);
  }

  /* 大文件夹角标更新 */
  public static notifyBigFolderItemBadgeChange(folder: GridLayoutItemInfo, isOpen: boolean): void {
    const context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
    if (!context) {
      log.showWarn('cannot get desktop context, the badge of folder item in big folder may not be shown');
      return;
    }
    let layout = folder.layoutInfo;
    if (layout && layout[0]) {
      let notifyData: FolderAppItemInfo = {
        isEmpty: false,
        alignContent: Alignment.Center,
        folderId: folder.folderId,
        isOpenFolder: isOpen,
        geometryId: '',
        appIconId: 0,
        abilityName: '',
        appName: '',
        bundleName: ''
      };

      layout[0].forEach((item: GridLayoutItemInfo) => {
        FolderItemBadgeChangeNotifyUtils.notifyBigFolderItemBadgeChangeVisible(context, item, notifyData);
      })

      let area: number[] = folder.area ?? [2, 2];
      /* 4*X的文件夹还要通知第二屏 */
      if (area[0] === CommonConstants.GRID_SPAN_4 && layout.length > 1) {
        let second = layout[1];
        let left = GridLayoutUtil.getCountPerPageInFolder(area) - GridLayoutUtil.getCountPerPageFolderOpen();
        for (let i: number = 0; i < second.length && i < left; i++) {
          FolderItemBadgeChangeNotifyUtils.notifyBigFolderItemBadgeChangeVisible(context, second[i], notifyData);
        }
      }
    }
  }
  /* 文件夹展开态角标更新 */
  public static notifyOpenedFolderItemBadgeChange(folder: GridLayoutItemInfo, isOpen: boolean): void {
    const context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
    if (!context) {
      log.showWarn('cannot get desktop context, the badge of folder item in opened folder may not be shown');
      return;
    }
    let array = folder.layoutInfo?.flat();
    if (!array) {
      log.showWarn('folder %{public}s has no layout??', folder.folderId);
      return;
    }
    let notifyData: FolderAppItemInfo = {
      isEmpty: false,
      alignContent: Alignment.Center,
      folderId: isOpen ? folder.folderId : '-1',
      isOpenFolder: isOpen,
      geometryId: '',
      appIconId: 0,
      abilityName: '',
      appName: '',
      bundleName: ''
    };

    array.forEach((item: GridLayoutItemInfo) => {
      try {
        if (!item) {
          log.showError(`notifyOpenedFolderItemBadgeChange array.forEach error ${folder?.folderId}`);
          return;
        }
        context.eventHub.emit(`${FolderConstants.OPEN_FOLDER_ITEM_BADGE_CHANGE}${item.keyName}`, notifyData);
      } catch (err) {
        log.showError('eventHub emit notifyOpenedFolderItemBadgeChange error%{public}d:%{public}s', err.code,
          err.message);
      }
    })
  }

  private static notifyBigFolderItemBadgeChangeVisible(context: ctx.ServiceExtensionContext, item: GridLayoutItemInfo,
    data: FolderAppItemInfo): void {
    if (!item) {
      return;
    }
    try {
      let event = `${CommonConstants.EVENTHUB_BIG_FOLDER_OPEN_STATUS}${item.keyName}`;
      context.eventHub.emit(event, data);
    } catch (err) {
      log.showError('eventHub emit notifyBigFolderItemBadgeChangeVisible error%{public}d:%{public}s', err.code,
        err.message);
    }
  }
}