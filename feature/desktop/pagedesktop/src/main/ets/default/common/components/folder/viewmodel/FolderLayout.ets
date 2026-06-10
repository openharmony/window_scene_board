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

import {
  AnimateToScheduleUtils,
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import FeatureConstants from '@ohos/bigfolder/src/main/ets/default/common/constants/FeatureConstants';
import {
  ContractedFolderLayoutViewModel,
  FolderActionLifeCycleEvent,
  FolderActionLifeCycleEventManager,
  FolderLifeCyclePriority,
  GridLayoutItemInfo,
  OBSERVER_TYPE,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { performanceMonitor } from '@kit.ArkUI';
import { openFolderVm } from '@ohos/bigfolder/src/main/ets/default/viewmodel/OpenFolderViewModel';

const TAG: string = 'FolderLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹折叠态布局总管理类
 */
export class FolderLayout {
  private closingFolder: GridLayoutItemInfo | undefined = undefined;

  private mOpenCloseCallback: FolderActionLifeCycleEvent = {
    description: TAG,
    priority: FolderLifeCyclePriority.NORMAL,
    onOpeningFolder: (folder: GridLayoutItemInfo) => {
      // 当文件夹A处于关闭状态时，打开文件夹B，需要将文件夹A的折叠态置为显示，如果当前打开的为文件夹A，则无需处理文件夹A的展开态
      if (this.closingFolder === undefined || folder === this.closingFolder) {
        return;
      }
      ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(this.closingFolder.folderId)
        .getObserverUpdator('opening-opacity', OBSERVER_TYPE.FOLDER_ICON).opacity(1.0);
      this.closingFolder = undefined;
    },
    onOpenedFolder: (folder: GridLayoutItemInfo) => {
      openFolderVm.executeCloseFolderEndCallback(FeatureConstants.OPEN_FOLDER_STATUS_TRANSITION_END);
      AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
      log.showInfo('FolderToOpenFolderAnimate finish');
      performanceMonitor.end('LAUNCHER_FOLDER_OPEN');
      // 状态变量forbidFolderOpenSwiper的更新，会触发swiper的最小化更新导致翻页失败，此处加延迟规避
      setTimeout(() => {
        GlobalContext.getContext().eventHub.emit(`globalSearchLocationFolderOpen`);
      }, 30);
    },
    onClosingFolder: (folder: GridLayoutItemInfo) => {
      this.closingFolder = folder;
    },
    onClosedFolder: (folder: GridLayoutItemInfo) => {
      log.showInfo('close folder animate finish, folderId: %{public}s', folder.folderId);
      performanceMonitor.end('CLOSE_FOLDER_ANI');
      ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folder.folderId)
        .getObserverUpdator('closed-opacity', OBSERVER_TYPE.FOLDER_ICON).opacity(1.0);
      this.closingFolder = undefined;
    }
  }

  /**
   * 桌面文件夹布局管理类注册文件夹打开关闭状态变化
   */
  public registerFolderActionCallback(): void {
    FolderActionLifeCycleEventManager.getInstance().register(this.mOpenCloseCallback);
  }
}

// 单例
export let folderLayout: FolderLayout = SingletonHelper.getInstance(FolderLayout, TAG);