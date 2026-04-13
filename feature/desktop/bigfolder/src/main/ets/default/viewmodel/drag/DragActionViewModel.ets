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
import {
  DragAppToFolderData,
  DragCoveredItem
} from '@ohos/launchercommon/src/main/ets/folder/next/common/model/data/FoldersData';
import {
  BaseDataObserverManager,
  BaseObserverManager,
  CommonConstants,
  ContractedFolderLayoutViewModel,
  ContractedFolderMode,
  COVER_FOLDER_TYPE,
  EventConstants,
  FolderCommonConstants,
  FolderCommonUtil,
  FolderIconUpdator,
  FolderManager,
  GridLayoutItemInfo,
  OBSERVER_SWITCH,
  OBSERVER_TYPE,
  StyleConstants
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { DragAnimatorParams } from './DragActionManager';
import { curves } from '@kit.ArkUI';
import { RTLUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { NumberConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { Trace } from '@ohos/basicutils';
import { localEventManager } from '@ohos/frameworkwrapper';
import { FolderAddEventParams } from '../../common/constants/FolderAddDialogConstant';
import { DragHandlerType, DragProxyManager, IDockDragHandler } from '@ohos/launchercommon/Index';

const TAG: string = 'DragActionViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const FOLDER_ADD_DIALOG_OPEN_DELAY = 300;

/**
 * 拖拽动效执类
 */
export class DragActionViewModel {
  /**
   * 开始落位动效
   *
   * @param folderItem 文件夹
   * @param aniParams 动画参数
   */
  public startDropAnimation(folderItem: GridLayoutItemInfo, aniParams: DragAnimatorParams, isCreate: boolean): void {
    let layoutVm: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance();
    if (isCreate) {
      this.createFolderAnimate(layoutVm, folderItem, aniParams);
    } else {
      this.dragInAnimate(layoutVm, folderItem, aniParams);
    }
  }

  private createFolderAnimate(layoutVm: ContractedFolderLayoutViewModel, folderItem: GridLayoutItemInfo,
    aniParams: DragAnimatorParams): void {
    let folderId: string = folderItem.folderId ?? '';
    let dragCoveredItem: DragCoveredItem = FolderManager.getInstance().getDragCoverItem();
    let dataOsrMgr: BaseDataObserverManager = layoutVm.getDataOsrMgr(folderId);
    dataOsrMgr.setFolderModel('create folder', ContractedFolderMode.MODE_COMPONENT);
    dataOsrMgr.updateCurrentList('create folder', true);
    let osrMgr: BaseObserverManager = layoutVm.getViewOsrMgr(folderId);
    let fstUpdator: FolderIconUpdator =
      osrMgr.getObserverUpdator('create folder start', OBSERVER_TYPE.ICON_DATA) as FolderIconUpdator;
    let sndUpdator: FolderIconUpdator =
      osrMgr.getObserverUpdator('create folder start', OBSERVER_TYPE.SND_ICON_DATA) as FolderIconUpdator;
    fstUpdator.transX(aniParams.transX).transY(aniParams.transY).scale(aniParams.scale);
    sndUpdator.transX(aniParams.coveredTransX).transY(aniParams.coveredTransY).scale(aniParams.coveredScale);
    osrMgr.switchStatus('create-start-isDrag', OBSERVER_SWITCH.ICON_ANIMATE, true);
    try {
      animateTo({
        curve: curves.interpolatingSpring(0, 1, 250, 30),
        onFinish: () => {
          log.showInfo('finish coveredApp and dragApp Animate');
          fstUpdator.finish();
          sndUpdator.finish();
          if (dragCoveredItem.folderType === COVER_FOLDER_TYPE.DOCK_FOLDER) {
            dragCoveredItem.isCreateSmallFolder = false;
            const dragProxy: IDockDragHandler = DragProxyManager.getInstance()
              .get('create folder to clear squeeze', DragHandlerType.DOCK) as IDockDragHandler;
            dragProxy?.clearSqueezeInfo();
          } else {
            dragCoveredItem.isCreateSmallFolder = false;
          }
          FolderManager.getInstance().clearDragCoverItem();
          osrMgr.switchStatus('drop-end-isDrag', OBSERVER_SWITCH.ICON_ANIMATE, false);
          dataOsrMgr.setFolderModel('create folder', ContractedFolderMode.MODE_IMAGE);
        }
      }, () => {
        fstUpdator.transX(0).transY(0).scale(1);
        sndUpdator.transX(0).transY(0).scale(1);
      });
    } catch (error) {
      log.error('coveredAppToFolderAnimate: curves error', error);
      dragCoveredItem.isCreateSmallFolder = false;
    }
  }

  public isDragMultiItems(): boolean {
    const dragObj: Object | undefined = AppStorage.get<Object>('dragItemInfo');
    if (!dragObj || !Array.isArray(dragObj)) {
      return false;
    }

    const dragItems = dragObj as GridLayoutItemInfo[];
    const isMulti = dragItems.length > 1;
    log.showInfo(`isDragMultiItems:${isMulti}`);
    return isMulti;
  }

  private dragInAnimate(layoutVm: ContractedFolderLayoutViewModel, folderItem: GridLayoutItemInfo,
    aniParams: DragAnimatorParams): void {
    let folderId: string = folderItem.folderId ?? '';
    let dataOsrMgr: BaseDataObserverManager = layoutVm.getDataOsrMgr(folderId);
    const isMulti = this.isDragMultiItems();
    if (dataOsrMgr.isSmallFolder()) {
      // 多选拖拽时, 不需要设置为组件模式
      if (!isMulti) {
        dataOsrMgr.setFolderModel('start drag animation', ContractedFolderMode.MODE_COMPONENT);
        dataOsrMgr.updateCurrentList('drop to folder', false);
      }
    }
    let osrMgr: BaseObserverManager = layoutVm.getViewOsrMgr(folderId);
    let updator: FolderIconUpdator =
      osrMgr.getObserverUpdator('drop-folder', OBSERVER_TYPE.ICON_DATA) as FolderIconUpdator;
    updator.transX(aniParams.transX).transY(aniParams.transY).scale(aniParams.scale);
    osrMgr.switchStatus('drop-start-isDrag', OBSERVER_SWITCH.ICON_ANIMATE, true);
    try {
      animateTo({
        curve: curves.springMotion(0.416, 0.99, 0),
        duration: 1000,
        onFinish: () => {
          log.showInfo('dragAppToFolderAnimate end');
          updator.finish();
          osrMgr.switchStatus('drop-start-isDrag', OBSERVER_SWITCH.ICON_ANIMATE, false);
          FolderManager.getInstance().setDragAppToFolder(new DragAppToFolderData());
          if (dataOsrMgr.isSmallFolder() && !isMulti) {
            setTimeout(() => {
              osrMgr.switchStatus('drop-end-show', OBSERVER_SWITCH.END_PAGE_SHOW, false);
            }, 20);
            const dragProxy: IDockDragHandler = DragProxyManager.getInstance()
              .get('drag in folder to clear squeeze', DragHandlerType.DOCK) as IDockDragHandler;
            dragProxy?.clearSqueezeInfo();
            FolderManager.getInstance().setLastAnimateInfo(undefined);
            dataOsrMgr.setFolderModel('end drag animation', ContractedFolderMode.MODE_IMAGE)
          }
        }
      }, () => {
        updator.transX(0).transY(0).scale(1);
      })
    } catch (error) {
      log.showError(`dragInAnimate catch error: ${error?.message}`);
      if (dataOsrMgr.isSmallFolder() && !isMulti) {
        dataOsrMgr.setFolderModel('end drag animation catch error', ContractedFolderMode.MODE_IMAGE);
      }
    }
  }

  /**
   * 开始拖拽应用到文件夹动效
   *
   * @param folderItem 文件夹item
   * @param needExitAnimate 是否需要退出动效节点
   * @param aniParams 动效参数
   */
  public showDragAppToFolderAnimate(folderItem: GridLayoutItemInfo, needExitAnimate: boolean,
    aniParams: DragAnimatorParams): void {
    log.showInfo(`showDragAppToFolderAnimate needExitAnimate:${needExitAnimate}`);
    let layoutVm: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance();
    let folderId: string = folderItem.folderId ?? '';
    let osrMgr: BaseObserverManager = layoutVm.getViewOsrMgr(folderId);
    osrMgr.getObserverUpdator('drag-start', OBSERVER_TYPE.ANI_ICON)
      .opacity(1).transX(aniParams.transX).transY(aniParams.transY).scale(aniParams.scale);
    osrMgr.switchStatus('drag-start-last', OBSERVER_SWITCH.LAST_APP_SHOW, needExitAnimate)
      .switchStatus('drag-start-isDrag', OBSERVER_SWITCH.ICON_ANIMATE, true);
    try {
      animateTo({
        curve: curves.springMotion(0.416, 0.99, 0),
        duration: 500,
        onFinish: () => {
          log.showInfo('end drag app to folder animate')
          if (!needExitAnimate) {
            osrMgr.switchStatus('drag-finish-isDrag', OBSERVER_SWITCH.ICON_ANIMATE, false);
            FolderManager.getInstance().setDragAppToFolder(new DragAppToFolderData());
          }
        }
      }, () => {
        osrMgr.getObserverUpdator('drag-end', OBSERVER_TYPE.ANI_ICON).transX(0).transY(0).scale(1);
      })
    } catch (error) {
      log.error('showDragAppToFolderAnimate: curves error', error);
    }

    if (needExitAnimate) {
      animateTo({
        delay: 520,
        duration: 400,
        curve: Curve.Sharp,
        onFinish: () => {
          osrMgr.switchStatus('drag-exit-last', OBSERVER_SWITCH.LAST_APP_SHOW, false)
            .switchStatus('drag-exit-isDrag', OBSERVER_SWITCH.ICON_ANIMATE, false);
          FolderManager.getInstance().setDragAppToFolder(new DragAppToFolderData());
          FolderManager.getInstance().setLastAnimateInfo(undefined);
        }
      }, () => {
        osrMgr.getObserverUpdator('drag-exit', OBSERVER_TYPE.ANI_ICON)
          .offsetX(-StyleConstants.FOLDER_LAST_THREE_APP_ANIMATE_POSITION / 3 * RTLUtil.getRTLRate())
          .offsetY(-StyleConstants.FOLDER_LAST_THREE_APP_ANIMATE_POSITION / 3)
          .opacity(NumberConstants.CONSTANT_NUMBER_ZERO);
      })
    }
  }

  /**
   * 堆叠图标入场与退出动效
   *
   * @param folderId 文件夹id
   * @param delayTime 延迟时间
   * @param isLastThreeAppDisappear 是否退场动效
   */
  public showLastThreeAppAnimate(folderId: string, delayTime: number, isLastThreeAppDisappear: boolean): void {
    log.showInfo(`showLastThreeAppAnimate delayTime:${delayTime} isLastThreeAppDisappear:${isLastThreeAppDisappear}`);
    let layoutVm: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance();
    let osrMgr: BaseObserverManager = layoutVm.getViewOsrMgr(folderId);
    try {
      if (isLastThreeAppDisappear) {
        let rate: number = RTLUtil.getRTLRate();
        // eleventh app animate
        animateTo({
          delay: NumberConstants.CONSTANT_NUMBER_ZERO,
          duration: 400,
          curve: curves.cubicBezierCurve(0.2, 0.2, 0.2, 1),
        }, () => {
          osrMgr.getObserverUpdator('show-spIcon3-end', OBSERVER_TYPE.SP_ICON_TRD)
            .offsetX(StyleConstants.FOLDER_LAST_THREE_APP_ANIMATE_POSITION / 3 * rate)
            .offsetY(StyleConstants.FOLDER_LAST_THREE_APP_ANIMATE_POSITION / 3);
        })
        animateTo({
          delay: NumberConstants.CONSTANT_NUMBER_ZERO,
          duration: 200,
          curve: Curve.Sharp,
        }, () => {
          osrMgr.getObserverUpdator('show-spIcon3-end', OBSERVER_TYPE.SP_ICON_TRD).opacity(0);
        })

        // tenth app animate
        animateTo({
          delay: 50,
          duration: 400,
          curve: curves.cubicBezierCurve(0.4, 0.2, 0.2, 1),
        }, () => {
          osrMgr.getObserverUpdator('show-spIcon2-end', OBSERVER_TYPE.SP_ICON_SND)
            .offsetX(StyleConstants.FOLDER_LAST_THREE_APP_ANIMATE_POSITION / 3 * 2 * rate)
            .offsetY(StyleConstants.FOLDER_LAST_THREE_APP_ANIMATE_POSITION / 3 * 2);
          osrMgr.getObserverUpdator('show-phIcon2-end', OBSERVER_TYPE.PH_ICON_SND)
            .offsetX(StyleConstants.FOLDER_LAST_THREE_APP_ANIMATE_POSITION / 3 * rate)
            .offsetY(StyleConstants.FOLDER_LAST_THREE_APP_ANIMATE_POSITION / 3)
        })
        animateTo({
          delay: 50,
          duration: 200,
          curve: Curve.Sharp,
        }, () => {
          osrMgr.getObserverUpdator('show-spIcon2-end', OBSERVER_TYPE.SP_ICON_SND).opacity(0);
          osrMgr.getObserverUpdator('show-phIcon2-end', OBSERVER_TYPE.PH_ICON_SND).opacity(0);
        })

        // ninth app animate
        animateTo({
          delay: 100,
          duration: 175,
          curve: curves.cubicBezierCurve(0.2, 0.2, 0.2, 1),
        }, () => {
          osrMgr.getObserverUpdator('show-spIcon1-end', OBSERVER_TYPE.SP_ICON_FST)
            .offsetX(StyleConstants.FOLDER_LAST_THREE_APP_ANIMATE_POSITION * rate)
            .offsetY(StyleConstants.FOLDER_LAST_THREE_APP_ANIMATE_POSITION);
          osrMgr.getObserverUpdator('show-phIcon1-end', OBSERVER_TYPE.PH_ICON_FST)
            .offsetX(StyleConstants.FOLDER_LAST_THREE_APP_ANIMATE_POSITION / 3 * 2 * rate)
            .offsetY(StyleConstants.FOLDER_LAST_THREE_APP_ANIMATE_POSITION / 3 * 2);
        })
        animateTo({
          delay: 100,
          duration: 350,
          curve: Curve.Sharp,
        }, () => {
          osrMgr.getObserverUpdator('show-spIcon1-end', OBSERVER_TYPE.SP_ICON_FST).opacity(0);
          osrMgr.getObserverUpdator('show-phIcon1-end', OBSERVER_TYPE.PH_ICON_FST).opacity(0);
        })
      } else {
        // eleventh app enter animate
        animateTo({
          delay: delayTime,
          duration: 400,
          curve: curves.cubicBezierCurve(0.2, 0.2, 0.2, 1),
        }, () => {
          osrMgr.getObserverUpdator('hide-spIcon1-end', OBSERVER_TYPE.SP_ICON_FST).offsetX(0).offsetY(0);
          osrMgr.getObserverUpdator('hide-phIcon1-end', OBSERVER_TYPE.PH_ICON_FST).offsetX(0).offsetY(0);
        })
        animateTo({
          delay: delayTime,
          duration: 200,
          curve: Curve.Sharp,
        }, () => {
          osrMgr.getObserverUpdator('hide-spIcon1-end', OBSERVER_TYPE.SP_ICON_FST).opacity(1.0);
          osrMgr.getObserverUpdator('hide-phIcon1-end', OBSERVER_TYPE.PH_ICON_FST).opacity(1.0);
        })

        // tenth app enter animate
        animateTo({
          delay: 50 + delayTime,
          duration: 400,
          curve: curves.cubicBezierCurve(0.4, 0.2, 0.2, 1),
        }, () => {
          osrMgr.getObserverUpdator('hide-spIcon2-end', OBSERVER_TYPE.SP_ICON_SND).offsetX(0).offsetY(0);
          osrMgr.getObserverUpdator('hide-phIcon2-end', OBSERVER_TYPE.PH_ICON_SND).offsetX(0).offsetY(0);
        })
        animateTo({
          delay: 50 + delayTime,
          duration: 200,
          curve: Curve.Sharp,
        }, () => {
          osrMgr.getObserverUpdator('hide-spIcon2-end', OBSERVER_TYPE.SP_ICON_SND).opacity(1.0);
          osrMgr.getObserverUpdator('hide-phIcon2-end', OBSERVER_TYPE.PH_ICON_SND).opacity(1.0);
        })

        // ninth app enter animate
        animateTo({
          delay: 100 + delayTime,
          duration: 350,
          curve: curves.cubicBezierCurve(0.4, 0.2, 0.4, 1),
        }, () => {
          osrMgr.getObserverUpdator('hide-spIcon3-end', OBSERVER_TYPE.SP_ICON_TRD).offsetX(0).offsetY(0);
        })
        animateTo({
          delay: 100 + delayTime,
          duration: 175,
          curve: Curve.Sharp,
        }, () => {
          osrMgr.getObserverUpdator('hide-spIcon3-end', OBSERVER_TYPE.SP_ICON_TRD).opacity(1.0);
        })
      }
    } catch (error) {
      log.error('curves error', error);
    }
  }

  /**
   * 开始占位图标动效
   *
   * @param folderId 文件夹id
   * @param delayTime 延迟时间
   */
  public showPlaceholderAnimate(folderId: string, delayTime: number): void {
    log.showInfo('showPlaceholderAnimate delayTime = %{public}d', delayTime);
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
          log.showInfo('showPlaceholderAnimate end')
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
   * 背板缩放动画
   *
   * @param isFolderBackplaneOpen 是否缩放
   * @return boolean 是否是小文件夹
   */
  public showFolderBackplaneAnimate(folder: GridLayoutItemInfo, isFolderBackplaneOpen: boolean): void {
    log.showInfo('showFolderBackplaneAnimate isFolderBackplaneOpen:%{public}s', isFolderBackplaneOpen);
    let osrMgr: BaseObserverManager = ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folder.folderId);
    try {
      if (isFolderBackplaneOpen) {
        animateTo({
          curve: curves.springMotion(0.414, 0.82, 0)
        }, () => {
          let scale: number = FolderCommonUtil.isLayout1X1(folder.area) ? 1.1 : CommonConstants.ICON_DEFAULT_SCALE;
          osrMgr.getObserverUpdator('folderBg open', OBSERVER_TYPE.FOLDER_BG).scaleX(scale).scaleY(scale);
        })
      } else {
        animateTo({
          curve: curves.springMotion(0.414, 0.82, 0)
        }, () => {
          osrMgr.getObserverUpdator('folderBg close', OBSERVER_TYPE.FOLDER_BG).scaleX(1.0).scaleY(1.0);
        })
      }
    } catch (error) {
      log.error('showFolderBackplaneAnimate: curves error', error);
    }
  }
}