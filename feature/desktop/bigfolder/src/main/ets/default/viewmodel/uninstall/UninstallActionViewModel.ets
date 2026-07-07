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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { RTLUtil } from '@ohos/componenthelper';
import {
  ContractedFolderMode,
  ContractedFolderLayoutViewModel,
  DeliverUtil,
  DisappearLastAppData,
  FolderManager,
  GridLayoutItemInfo,
  OBSERVER_SWITCH,
  OBSERVER_TYPE,
  StyleConstants,
  FolderStyleManager,
  BaseObserverManager,
  BaseDataObserverManager,
  FolderIconUpdator
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { UninstallActionLifeCycleStatusManager } from './UninstallActionLifeCycleStatusManager';
import { UninstallAnimatorParams } from './UninstallActionManager';
import { curves } from '@kit.ArkUI';

const TAG: string = 'UninstallActionViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 卸载动效的业务类：打断、删除、添加、播放动效
 */
export class UninstallActionViewModel {
  private static disbandFlag: number = 0;

  /**
   * 启动对应的文件夹类型动效
   */
  public startFolderAnimation(folderItem: GridLayoutItemInfo, aniParams: UninstallAnimatorParams): void {
    let disappearData: DisappearLastAppData = FolderManager.getInstance().getDisappearLastAppData();
    let layoutVm: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance();
    let folderId: string = folderItem.folderId ?? '';
    let osrMgr: BaseObserverManager = layoutVm.getViewOsrMgr(folderId);
    let dataMgr: BaseDataObserverManager = layoutVm.getDataOsrMgr(folderId);
    let updator: FolderIconUpdator =
      osrMgr.getObserverUpdator('disband-start', OBSERVER_TYPE.ICON_DATA) as FolderIconUpdator;
    if (dataMgr.isSmallFolder()) {
      dataMgr.setFolderModel('start disband animation', ContractedFolderMode.MODE_COMPONENT);
      dataMgr.updateCurrentList('start disband animation', false);
    } else {
      this.folderBackgroundAnimator(osrMgr, folderId, folderItem.area ?? [2, 2]);
    }
    this.folderNameAnimator(osrMgr);
    updator.scale(1).transX(0).transY(0);
    osrMgr.switchStatus('disband-isDrag-start', OBSERVER_SWITCH.ICON_ANIMATE, true);
    log.showInfo(`FolderDisbandAnimation flag: ${UninstallActionViewModel.disbandFlag}`);
    UninstallActionViewModel.disbandFlag++;
    animateTo({
      duration: 500,
      curve: Curve.Friction,
      onFinish: () => {
        UninstallActionViewModel.disbandFlag--;
        log.showInfo(`FolderDisbandAnimation flag onFinish: ${UninstallActionViewModel.disbandFlag}`);
        osrMgr.switchStatus('disband-isDrag-end', OBSERVER_SWITCH.ICON_ANIMATE, false);
        UninstallActionLifeCycleStatusManager.getInstance().toDisbanded('animate disband', folderItem, disappearData);
      }
    }, () => {
      updator.scale(aniParams.scale).transX(aniParams.transX).transY(aniParams.transY);
    })
  }

  private folderBackgroundAnimator(osrMgr: BaseObserverManager, folderId: string, area: number[]): void {
    let aniParams: AnimatorParams = this.getBackgroundAnimator(folderId, area);
    animateTo({
      duration: 120,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
    }, () => {
      osrMgr?.getObserverUpdator('disband-folder', OBSERVER_TYPE.FOLDER_BG)
        .transX(aniParams.folderBgTransX)
        .transY(aniParams.folderBgTransY)
        .opacity(aniParams.folderBgOpacity);
      osrMgr?.getObserverUpdator('disband-folder', OBSERVER_TYPE.FOLDER_RESIZE)
        .scaleX(aniParams.folderBgScaleX)
        .scaleY(aniParams.folderBgScaleY)
        .borderRadius(aniParams.folderBgRadius);
    })
  }

  private folderNameAnimator(osrMgr: BaseObserverManager): void {
    animateTo({
      duration: 100,
      curve: Curve.Linear,
    }, () => {
      osrMgr.setFolderNameOpacity('folder disappear', 0);
    })
  }

  private getBackgroundAnimator(folderId: string, area: number[]): AnimatorParams {
    // 定制文件夹解散时背板不需要缩放和位移
    let aniParams: AnimatorParams = new AnimatorParams();
    if (DeliverUtil.isContainerFolder(folderId)) {
      aniParams.folderBgScaleX = 1.0;
      aniParams.folderBgScaleY = 1.0;
      aniParams.folderBgTransX = 0.0;
      aniParams.folderBgTransY = 0.0;
      aniParams.folderBgOpacity = StyleConstants.DEFAULT_FOLDER_HIDDEN_VALUE;
    } else {
      const appIconArea = [1, 1];
      const styleManager = FolderStyleManager.getInstance();
      const desktopGridWidth = styleManager.getDesktopGridWidth();
      let normalAppIconSize = styleManager.getWidthByArea(appIconArea);
      let folderWidth: number = styleManager.getWidthByArea(area);
      let folderHeight: number = styleManager.getHeightByArea(area);
      aniParams.folderBgScaleX = normalAppIconSize / folderWidth;
      aniParams.folderBgScaleY = normalAppIconSize / folderHeight;
      aniParams.folderBgTransX = desktopGridWidth * (1 - area[0] ?? 1) / 2 * RTLUtil.getRTLRate();
      aniParams.folderBgTransY = normalAppIconSize / 2 - folderHeight / 2;
      aniParams.folderBgOpacity = StyleConstants.DEFAULT_FOLDER_HIDDEN_VALUE;
      aniParams.folderBgRadius = styleManager.getFolderRadiusByArea(appIconArea);
    }
    return aniParams;
  }

  /**
   * 执性文件夹动效结束后的操作
   */
  public finishFolderAnimation(folderItem: GridLayoutItemInfo): void {
    log.showInfo('finishFolderAnimation');
    let disappearData: DisappearLastAppData = FolderManager.getInstance().getDisappearLastAppData();
    if (!CheckEmptyUtils.isEmpty(disappearData.lastAppKeyName) && !CheckEmptyUtils.isEmpty(disappearData.restApp)) {
      FolderManager.getInstance().removeFolder('folder disbanded with item', folderItem, disappearData.restApp);
    } else {
      FolderManager.getInstance().removeFolder('folder disbanded with no remaining item', folderItem);
    }
    FolderManager.getInstance().setDisappearLastAppData(new DisappearLastAppData());
  }
}

class AnimatorParams {
  public folderBgScaleX: number = 1.0;

  public folderBgScaleY: number = 1.0;

  public folderBgTransX: number = 0.0;

  public folderBgTransY: number = 0.0;

  public folderBgOpacity: number = 1.0;

  public folderBgRadius: number = 0.0;
}