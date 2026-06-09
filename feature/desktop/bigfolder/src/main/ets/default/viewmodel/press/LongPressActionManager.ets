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
  BaseObserverManager,
  ContractedFolderLayoutViewModel,
  FolderActionLifeCycleEvent,
  FolderActionLifeCycleEventManager,
  FolderCommonConstants,
  FolderLifeCyclePriority,
  GridLayoutItemInfo,
  OBSERVER_SWITCH
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { LongPressActionViewModel } from './LongPressActionViewModel';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import { DropAnimationCancelReason } from '@ohos/componentanimator/src/main/ets/TsIndex';
import { SCBTransitionManager } from '@ohos/windowscene/src/main/ets/TsIndex';

const TAG: string = 'LongPressActionLifeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 长按动效的管理类
 */
class LongPressActionManager {
  private aniViewModel: LongPressActionViewModel = new LongPressActionViewModel();

  private mDesktopContext?: ServiceExtensionContext = GlobalContext.getContext();

  private mLongPressActionLifeEvent: FolderActionLifeCycleEvent = {
    description: 'LongPress on folder',
    priority: FolderLifeCyclePriority.NORMAL,
    onPressingFolder: (folder: GridLayoutItemInfo) => {
      let folderId: string = folder.folderId ?? FolderCommonConstants.INVALID_FOLDER_ID;
      if (folderId !== FolderCommonConstants.INVALID_FOLDER_ID) {
        // 动效执行前逻辑
        dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
        SCBTransitionManager.getInstance().cancelCloseAppAnimate();
        // 开始按压动效
        this.aniViewModel.setToLongPressScale(folder);
        this.aniViewModel.startFolderAnimation(folderId, true);
      }
    },
    onPressedFolder: (folder: GridLayoutItemInfo) => {
      let folderId: string = folder.folderId ?? FolderCommonConstants.INVALID_FOLDER_ID;
      if (folderId !== FolderCommonConstants.INVALID_FOLDER_ID) {
        // 动效开始前逻辑
        this.mDesktopContext?.eventHub.off(`otherIconLongPressEffectCancel`);
        // 按压恢复动效
        this.aniViewModel.startFolderAnimation(folderId, false);
      }
    },
    cancelPressAnimation: (folder: GridLayoutItemInfo) => {
      let folderId: string = folder.folderId ?? FolderCommonConstants.INVALID_FOLDER_ID;
      if (folderId !== FolderCommonConstants.INVALID_FOLDER_ID) {
        this.aniViewModel.cancelLongPressAnimation(folderId);
      }
    },
    breakPressAnimation: (folder: GridLayoutItemInfo) => {
      let folderId: string = folder.folderId ?? FolderCommonConstants.INVALID_FOLDER_ID;
      if (folderId !== FolderCommonConstants.INVALID_FOLDER_ID) {
        this.aniViewModel.breakLongPressAnimation(folderId);
      }
    },
    onFolderMenuShow: (folder: GridLayoutItemInfo) => {
      let folderId: string = folder.folderId ?? FolderCommonConstants.INVALID_FOLDER_ID;
      let osrMgr: BaseObserverManager = ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folderId);
      osrMgr.switchStatus('menu show to hide folder', OBSERVER_SWITCH.FOLDER_VISIBLE, false);
      if (folderId !== FolderCommonConstants.INVALID_FOLDER_ID || !osrMgr.getStatus(OBSERVER_SWITCH.CONVERT_ANIMATE)) {
        this.aniViewModel.changeAppNameOpacity(folder.folderId, false);
      }
    },
    onFolderMenuHidden: (folder: GridLayoutItemInfo) => {
      ContractedFolderLayoutViewModel.getInstance()
        .getViewOsrMgr(folder.folderId).switchStatus('menu hide to show folder', OBSERVER_SWITCH.FOLDER_VISIBLE, true);
      this.aniViewModel.changeAppNameOpacity(folder.folderId, true);
    }
  }

  /**
   * 注册长按动效事件
   */
  public registerActionEvent(): void {
    FolderActionLifeCycleEventManager.getInstance().register(this.mLongPressActionLifeEvent);
  }

  /**
   * 取消注册长按动效事件
   */
  public unRegisterActionEvent(): void {
    FolderActionLifeCycleEventManager.getInstance().unregister(this.mLongPressActionLifeEvent);
  }
}

// 单例
export let pressAniMgr: LongPressActionManager = SingletonHelper.getInstance(LongPressActionManager, TAG);