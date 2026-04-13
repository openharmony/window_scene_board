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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { curves } from '@kit.ArkUI';
import {
  BaseObserverManager,
  ContractedFolderLayoutViewModel,
  FolderActionLifeCycleEventManager,
  FolderActionLifeCycleStatus,
  FolderCommonUtil,
  FolderManager,
  GridLayoutItemInfo,
  OBSERVER_SWITCH,
  OBSERVER_TYPE,
  StyleConstants} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { Trace } from '@ohos/basicutils';

const TAG: string = 'FolderCommonActionViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹公共动效管理类
 */
export class FolderCommonActionViewModel {
  /**
   * 占位图标动画
   *
   * @param delayTime 延迟时间
   */
  public showPlaceholderAnimate(folderId: string, delayTime: number): void {
    log.showInfo('showPlaceholderAnimate delayTime = ' + delayTime);
    let layoutVm: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance();
    let osrMgr: BaseObserverManager = layoutVm.getViewOsrMgr(folderId);
    // 第9个图标落位不需要动效，直接复位
    osrMgr.getObserverUpdator('show-phIcon', OBSERVER_TYPE.SP_ICON_TRD).offsetX(0.0).offsetY(0.0).opacity(1.0);
    // eleventh placeholder animate
    try {
      Trace.start('showPlaceholderAnimate');
      animateTo({
        delay: delayTime,
        duration: 400,
        curve: curves.cubicBezierCurve(0.2, 0.2, 0.2, 1),
        onFinish: () => {
          Trace.end('showPlaceholderAnimate');
        }
      }, () => {
        osrMgr.getObserverUpdator('show-phIcon1', OBSERVER_TYPE.PH_ICON_FST).offsetX(0.0).offsetY(0.0);
      })
      animateTo({
        delay: delayTime,
        duration: 200,
        curve: Curve.Friction,
      }, () => {
        osrMgr.getObserverUpdator('show-phIcon', OBSERVER_TYPE.PH_ICON_FST).opacity(1.0);
      })
      // tenth placeholder animate
      animateTo({
        delay: 50 + delayTime,
        duration: 400,
        curve: curves.cubicBezierCurve(0.4, 0.2, 0.2, 1),
      }, () => {
        osrMgr.getObserverUpdator('show-phIcon2', OBSERVER_TYPE.PH_ICON_SND).offsetX(0.0).offsetY(0.0);
      })
      animateTo({
        delay: 50 + delayTime,
        duration: 200,
        curve: Curve.Friction,
      }, () => {
        osrMgr.getObserverUpdator('show-phIcon2', OBSERVER_TYPE.PH_ICON_SND).opacity(1.0);
      })
    } catch (error) {
      log.error('showLastThreeAppAnimate: curves error', error);
    }
  }

  /**
   * 执行应用退出动效
   *
   * @param folderItem 文件夹item
   * @param exitIndex 退出的位置序号
   */
  public startAppExitAnimation(folderItem: GridLayoutItemInfo, exitIndex: number): void {
    log.showInfo(`startAppExitAnimation mAppListLength: exitAppIndex: ${exitIndex}`);
    let layoutVm: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance();
    let maxShow: number = FolderCommonUtil.getContractedFolderMaxShowIconNum(folderItem.area);
    // 退出动效角标隐藏包含全部堆叠角标
    const supposeIconNum = 3;
    if (exitIndex <= maxShow - supposeIconNum) {
      return;
    }
    let osrMgr: BaseObserverManager = layoutVm.getViewOsrMgr(folderItem.folderId);
    let averPosition: number = StyleConstants.FOLDER_LAST_THREE_APP_ANIMATE_POSITION / 3;
    let appTranslation: number = this.getInteralNum(exitIndex, maxShow, folderItem.area) * averPosition;
    osrMgr.getObserverUpdator('exit-app-start', OBSERVER_TYPE.ANI_ICON)
      .transX(appTranslation).transY(appTranslation).opacity(1);
    osrMgr.switchStatus('start app exit', OBSERVER_SWITCH.LAST_APP_SHOW, true);
    animateTo({
      curve: Curve.Sharp,
      duration: 400,
      onFinish: () => {
        osrMgr.switchStatus('end app exit', OBSERVER_SWITCH.LAST_APP_SHOW, false);
        FolderManager.getInstance().setExitAppItem(undefined);
      }
    }, () => {
      osrMgr.getObserverUpdator('exit-app-end', OBSERVER_TYPE.ANI_ICON).transX(0).transY(0).opacity(0);
    })
  }

  private getInteralNum(exitIndex: number, maxShow: number, area?: number[]): number {
    if (FolderCommonUtil.isLayout4X2(area)) {
      // 4x2退出落位被固定在右下角
      const supposeIconNo = 2;
      return supposeIconNo;
    }
    if (exitIndex >= maxShow) {
      return 0;
    }
    return maxShow - exitIndex;
  }
}