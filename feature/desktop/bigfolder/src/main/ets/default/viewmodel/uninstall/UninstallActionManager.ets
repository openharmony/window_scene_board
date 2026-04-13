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
import { NumberConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { RTLUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import {
  AppModel,
  CommonConstants,
  ContractedFolderLayoutStyle,
  ContractedFolderLayoutViewModel,
  FolderActionLifeCycleEvent,
  FolderActionLifeCycleEventManager,
  FolderLifeCyclePriority,
  FolderManager,
  FolderStyleManager,
  GridLayoutItemInfo,
  GridLayoutUtil
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { UninstallActionViewModel } from './UninstallActionViewModel'

const TAG: string = 'UninstallActionLifeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 卸载动效的管理类
 */
class UninstallActionManager {
  private aniViewModel: UninstallActionViewModel = new UninstallActionViewModel();

  private mUninstallActionLifeEvent: FolderActionLifeCycleEvent = {
    description: 'uninstall item in folder',
    priority: FolderLifeCyclePriority.NORMAL,
    isStateChange: true,
    onDisbandingFolder: (folder: GridLayoutItemInfo) => {
      let aniParams: UninstallAnimatorParams = this.calculateAniParam(folder);
      this.aniViewModel.startFolderAnimation(folder, aniParams);
    },
    onDisbandedFolder: (folder: GridLayoutItemInfo) => {
      this.uninstallAppRemove();
      this.aniViewModel.finishFolderAnimation(folder)
    }
  }

  private uninstallAppRemove(): void {
    let uninstallApp: GridLayoutItemInfo | undefined =
      FolderManager.getInstance().getDisappearLastAppData().uninstallApp;
    // 未安装应用移除时，需要同步删除桌面占位快捷方式
    if (uninstallApp && uninstallApp.typeId === CommonConstants.TYPE_APP &&
      !GridLayoutUtil.isAppInstalled(uninstallApp)) {
      AppModel.getInstance().appItemRemove(uninstallApp.bundleName, uninstallApp.appIndex);
    }
  }

  private calculateAniParam(folder: GridLayoutItemInfo): UninstallAnimatorParams {
    let aniParams: UninstallAnimatorParams = new UninstallAnimatorParams();
    let style: ContractedFolderLayoutStyle =
      ContractedFolderLayoutViewModel.getInstance().getLayoutStyle(folder.folderId);
    aniParams.transX = this.getTransItemX(style);
    aniParams.transY = this.getTransItemY(style);
    aniParams.scale = (style.mDesktopIconSize !== 0) ?
      style.mDesktopIconSize / style.mFolderAppSize : NumberConstants.CONSTANT_NUMBER_ONE;
    return aniParams;
  }

  private getTransItemX(style: ContractedFolderLayoutStyle) {
    if (style.isLayout1X1()) {
      const transX: number = style.mFolderAppSize + style.getColumnGap();
      return RTLUtil.isRTL() ? -transX : transX;
    }

    const columns = style.area[0] ?? 1;
    const gridWidth = FolderStyleManager.getInstance().getDesktopGridWidth();
    const iconCenterOffset = style.mFolderAppSize / 2 + style.getPadding(true);
    const iconTotalOffset = iconCenterOffset + (gridWidth * columns - style.backgroundWidth) / 2;
    const transX = gridWidth / 2 - iconTotalOffset;
    return RTLUtil.isRTL() ? -transX : transX;
  }

  private getTransItemY(style: ContractedFolderLayoutStyle): number {
    if (style.isLayout1X1()) {
      return style.mFolderAppSize + style.getRowGap();
    }
    return style.mDesktopIconSize / 2.0 - (style.getPadding(false) + style.mFolderAppSize / 2.0);
  }

  /**
   * 注册解散动效事件
   */
  public registerActionEvent(): void {
    FolderActionLifeCycleEventManager.getInstance().register(this.mUninstallActionLifeEvent);
  }

  /**
   * 取消注册解散动效事件
   */
  public unRegisterActionEvent(): void {
    FolderActionLifeCycleEventManager.getInstance().unregister(this.mUninstallActionLifeEvent);
  }
}

/**
 * 卸载动效参数类
 */
export class UninstallAnimatorParams {
  /**
   * 位移X
   */
  public transX: number = 0;
  /**
   * 位移Y
   */
  public transY: number = 0;
  /**
   * 缩放scale
   */
  public scale: number = 1;
  /**
   * 背板缩放X
   */
  public bgScaleX: number = 1;
  /**
   * 背板缩放Y
   */
  public bgScaleY: number = 1;
  /**
   * 背板位移X
   */
  public bgTransX: number = 0;
  /**
   * 背板位移Y
   */
  public bgTransY: number = 0;
}

// 单例
export let uninstallAniMgr: UninstallActionManager = SingletonHelper.getInstance(UninstallActionManager, TAG);