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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  ContractedFolderLayoutViewModel,
  FolderActionLifeCycleEvent,
  FolderActionLifeCycleEventManager,
  FolderLifeCyclePriority,
  GridLayoutItemInfo
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { DownloadActionViewModel } from './DownloadActionViewModel';

const TAG: string = 'DownloadActionManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 下载动效的管理类
 */
class DownloadActionManager {
  private aniViewModel: DownloadActionViewModel = new DownloadActionViewModel();

  private downloadCallback: FolderActionLifeCycleEvent = {
    description: TAG,
    priority: FolderLifeCyclePriority.HIGH,
    onInstallingFolder: (folder: GridLayoutItemInfo) => {
      if (folder.folderId === undefined) {
        return;
      }
      log.showInfo('installing callback for folder %{public}s', folder.folderId);
      this.aniViewModel.playInstallingAni(folder.folderId);
    },
    onInstalledFolder: (folder: GridLayoutItemInfo) => {
      if (folder.folderId === undefined) {
        return;
      }
      this.aniViewModel.finishDownloadAni(folder.folderId);
    }
  }

  /**
   * 注册安装动效事件
   */
  public registerActionEvent(): void {
    FolderActionLifeCycleEventManager.getInstance().register(this.downloadCallback);
  }

  /**
   * 取消注册安装动效事件
   */
  public unRegisterActionEvent(): void {
    FolderActionLifeCycleEventManager.getInstance().unregister(this.downloadCallback);
  }
}

// 单例
export let downloadAniMgr: DownloadActionManager = SingletonHelper.getInstance(DownloadActionManager, TAG);