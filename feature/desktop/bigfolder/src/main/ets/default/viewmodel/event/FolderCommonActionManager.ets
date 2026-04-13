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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  ContractedFolderLayoutViewModel,
  FolderActionLifeCycleEvent,
  FolderActionLifeCycleEventManager,
  FolderLifeCyclePriority,
  FolderManager,
  GridLayoutItemInfo,
  OBSERVER_TYPE
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FolderCommonActionViewModel } from './FolderCommonActionViewModel';

const TAG: string = 'FolderCommonActionLifeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹小动效公共管理类，应用退出时堆叠图标动效，占位图标显示动效
 */
class FolderCommonActionManager {
  private mActionVm: FolderCommonActionViewModel = new FolderCommonActionViewModel();

  private mFolderActionLifeEvent: FolderActionLifeCycleEvent = {
    description: 'folder common action',
    priority: FolderLifeCyclePriority.NORMAL,
    onPlaceHolderShow: (folder: GridLayoutItemInfo) => {
      let osrMgr = ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folder.folderId);
      if (osrMgr.getObserverUpdator('get opacity', OBSERVER_TYPE.PH_ICON_FST).getOpacity() === 0 ||
        osrMgr.getObserverUpdator('get opacity', OBSERVER_TYPE.PH_ICON_SND).getOpacity() === 0) {
        if (ContractedFolderLayoutViewModel.getInstance().getIsNewStyle()) {
          // 使用动效刷新生命周期，保证closed时能执行展开态的aboutToDisAppear，确保下次opening能执行展开态的aboutToAppear
          this.mActionVm.showPlaceholderAnimate(folder.folderId ?? '', 0);
        } else {
          osrMgr.showPlaceHolder('common-show');
        }
      }
    },
    onAppExit: (folder: GridLayoutItemInfo) => {
      this.mActionVm.startAppExitAnimation(folder, FolderManager.getInstance().getExitIndex());
    }
  }

  /**
   * 注册动效的生命周期回调
   */
  public registerFolderActionLife(): void {
    FolderActionLifeCycleEventManager.getInstance().register(this.mFolderActionLifeEvent);
  }

  /**
   * 取消动效的生命周期回调
   */
  public unregisterFolderActionLife(): void {
    FolderActionLifeCycleEventManager.getInstance().unregister(this.mFolderActionLifeEvent);
  }
}

// 单例
export let folderAniMgr: FolderCommonActionManager = SingletonHelper.getInstance(FolderCommonActionManager, TAG);