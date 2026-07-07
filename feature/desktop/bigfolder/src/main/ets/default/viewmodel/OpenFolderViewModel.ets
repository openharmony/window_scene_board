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

import { CheckEmptyUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import {
  BigFolderStyleConfig,
  DeliverUtil,
  FolderActionLifeCycleEvent,
  FolderActionLifeCycleEventManager,
  FolderLifeCyclePriority,
  FolderManager,
  FolderModel,
  GridLayoutItemInfo,
  GridLayoutUtil,
  OpenFolderStyleConfig
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { AppBubbleCommonParams, FolderStyleManager } from '@ohos/launchercommon/Index';
import FeatureConstants from '../common/constants/FeatureConstants';
import { NumberConstants } from '@ohos/commonconstants';
import { OpenFolderAppBubbleNodeManager } from '../view/node/OpenFolderAppBubbleNodeManager';

const TAG = 'OpenFolderViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹展开态业务管理
 */
export class OpenFolderViewModel {
  private mFolderDropAnimateWaitCallBack: Callback<void>[] = [];

  private isDropAnimationStatus: boolean = false;

  private mCloseFolderEndCallback: (() => void) | undefined = undefined;

  private mOpenCloseCallback: FolderActionLifeCycleEvent = {
    description: TAG,
    priority: FolderLifeCyclePriority.HIGH,
    onOpeningFolder: (folder: GridLayoutItemInfo) => {
      log.showInfo('folder on open');
      let isSmallFolder: boolean = GridLayoutUtil.isSmallFolder(folder);
      let bigStyle: BigFolderStyleConfig = FolderStyleManager.getInstance().getFolderStyleConfig();
      let iconSizeInFolder: number = FolderStyleManager.getInstance().getFolderAppSize(folder.area, folder.isInDock);

      AppStorage.setOrCreate('isAddIconHidden', false);
      DeliverUtil.addAddIcon(folder, 'OpenFolderViewModel open folder');

      let newAppBubbleCommonParams = new AppBubbleCommonParams();
      newAppBubbleCommonParams.bindFolderId = folder.folderId || '';
      newAppBubbleCommonParams.isSmallFolder = isSmallFolder;
      newAppBubbleCommonParams.appItemWidth = OpenFolderStyleConfig.getInstance().getOpenFolderStyle().iconSize;
      newAppBubbleCommonParams.nameSize = bigStyle.mOpenFolderAppNameSize;
      newAppBubbleCommonParams.nameHeight = bigStyle.mOpenFolderAppNameHeight;
      newAppBubbleCommonParams.nameWidth = OpenFolderStyleConfig.getInstance().getOpenFolderStyle().gridItemWidth;
      newAppBubbleCommonParams.mIconNameMargin =
        OpenFolderStyleConfig.getInstance().getOpenFolderStyle().appNameMarginTop;
      /*
       * 文件夹的图标使用公共图标能力，这里传递过去的时候并没有指定iconRadius，而当前的mFolderIconRadius实际上是给拖拽截图用的。
       * 这里和公共图标的iconRadius默认值保持一致
       */
      newAppBubbleCommonParams.mFolderIconRadius = bigStyle.mFolderIconRadius;
      newAppBubbleCommonParams.nameLines = bigStyle.mNameLines;
      newAppBubbleCommonParams.iconRadius = isSmallFolder ?
        FolderStyleManager.getInstance().getSmallFolderStyleConfig()?.mSmallFolderIconRadius :
      bigStyle.mClosedFolderIconRadius;
      newAppBubbleCommonParams.iconSizeInFolder = iconSizeInFolder;
      OpenFolderAppBubbleNodeManager.getInstance().setAppBubbleCommonParams(newAppBubbleCommonParams);
    }
  }

  public registerOpenCloseCallback(): void {
    FolderActionLifeCycleEventManager.getInstance().register(this.mOpenCloseCallback);
  }

  public unregisterOpenCloseCallback(): void {
    FolderActionLifeCycleEventManager.getInstance().unregister(this.mOpenCloseCallback);
  }

  public registerCloseFolderEndCallback(callback: () => void): void {
    this.mCloseFolderEndCallback = callback;
  }

  public unregisterCloseFolderEndCallback(): void {
    this.mCloseFolderEndCallback = undefined;
  }

  public executeCloseFolderEndCallback(state: number): void {
    if (state === FeatureConstants.OPEN_FOLDER_STATUS_TRANSITION_END &&
      !FolderManager.getInstance().isFolderOpen()) {
      this.mCloseFolderEndCallback?.();
    }
  }

  /***
   * 快速挤位后迅速关闭大文件夹展开态场景中
   * 记录从落位动效执行完到大文件夹开始关闭转场动效前，存在的页面刷新任务
   * 避免转场过程中，因为落位动效导致界面刷新造成的动效异常
   * */
  public runFolderDropAnimateWaitCallBack(): void {
    log.showInfo('Run dropAnimateWaitCallBack status %{public}s  callBack length %{public}d', this.isDropAnimationStatus,
      this.mFolderDropAnimateWaitCallBack.length);
    if (this.isDropAnimationStatus) {
      this.mFolderDropAnimateWaitCallBack.forEach((callback) => {
        if (callback) {
          callback();
        }
      });
      this.mFolderDropAnimateWaitCallBack = [];
      this.setDropAnimationEnd();
    }
  }

  /***
   * 设置DropAnimation开始
   * */
  public setDropAnimationStart(): void {
    log.showInfo('SetDropAnimationStart ');
    this.isDropAnimationStatus = true;
  }

  /***
   * 设置DropAnimation结束
   * Note：如果不触发buildRefresh界面刷新，等待队列将会不执行，无法执行队列；
   * */
  private setDropAnimationEnd(): void {
    log.showInfo('SetDropAnimationEnd ');
    this.isDropAnimationStatus = false;
  }

  /***
   * 获取DropAnimation状态
   * */
  public getDropAnimationStatus(): boolean {
    log.showInfo('GetDropAnimationStatus  isDropAnimationStatus : %{public}s ', this.isDropAnimationStatus);
    return this.isDropAnimationStatus;
  }

  /***
   * 将callBack添加到等待队列中
   * */
  public pushDropAnimationCallBack(callback: Callback<void>): void {
    if (this.mFolderDropAnimateWaitCallBack.length === 0) {
      this.mFolderDropAnimateWaitCallBack.push(callback);
    } else {
      this.mFolderDropAnimateWaitCallBack = [];
      callback?.();
      log.showInfo('Has already push , WaitCallBack.length : %{public}d ', this.mFolderDropAnimateWaitCallBack.length);
    }
  }

  /**
   * 计算图标在文件夹内的位置
   * @param layoutInfo 文件夹布局
   * @param item 拖拽图标
   * @returns [row, column, pageIndex]
   */
  public calculateArea(layoutInfo: GridLayoutItemInfo[][] | undefined, item: GridLayoutItemInfo): number[] {
    let column: number = FolderModel.getInstance().getFolderOpenLayout().column;
    // rst 中每列的含义： appIndex , appColumn , appRow
    let rst = [-1, -1, -1];
    if (!layoutInfo) {
      log.showError('calculateArea: layoutInfo error');
      return rst;
    }
    for (let j = 0; j < layoutInfo.length; j++) {
      if (CheckEmptyUtils.isEmptyArr(layoutInfo[j]) || CheckEmptyUtils.isEmpty(item)) {
        log.showInfo('calculateArea item bundleName:' + item?.bundleName);
        return rst;
      }
      for (let i = 0; i < layoutInfo[j].length; i++) {
        if (layoutInfo[j][i]?.appIconId === item.appIconId) {
          rst[NumberConstants.CONSTANT_NUMBER_TWO] = j;
          rst[1] = i % column;
          rst[0] = Math.floor(i / column);
        }
      }
    }
    return rst;
  }

  /**
   * 更新文件夹展开态中应用的下载安装状态
   * @param bundleName 应用的包名
   */
  public updateOpenFolderAppStatus(bundleName: string, newStatus: number): void {
    let openFolderData: GridLayoutItemInfo = FolderManager.getInstance().getOpenedFolder();
    if (!openFolderData.layoutInfo) {
      return;
    }
    openFolderData.layoutInfo.forEach((page: GridLayoutItemInfo[]) => {
      page.forEach((item: GridLayoutItemInfo) => {
        if (item?.bundleName === bundleName) {
          item.appStatus = newStatus;
        }
      });
    });
  }
}

// 单例
export let openFolderVm: OpenFolderViewModel = SingletonHelper.getInstance(OpenFolderViewModel, TAG);