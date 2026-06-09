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
  CheckEmptyUtils,
  DomainName,
  LogDomain,
  Logger,
  TraceUtil
} from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  GlobalContext,
  SCBDesktopCacheManager,
  SceneIdentificationManager,
  SceneState
} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import {
  CommonConstants,
  ContractedFolderLayoutViewModel,
  ContractedFolderViewModelManager,
  ContractedFolderViewModelType,
  FolderActionLifeCycleEvent,
  FolderActionLifeCycleEventManager,
  FolderActionLifeCycleStatus,
  FolderCommonConstants,
  FolderCommonUtil,
  FolderLifeCyclePriority,
  FolderManager,
  FolderModel,
  FolderOperationFlag,
  FolderReporter,
  GridLayoutItemInfo,
  IContractedFolderOpenCloseViewModel,
  OBSERVER_SWITCH,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { OpenCloseActionLifeCycleStatusManager } from './OpenCloseActionLifeCycleStatusManager';
import { performanceMonitor } from '@kit.ArkUI';
import { CurrentMemScene, PerformanceReporter } from '@ohos/frameworkcommon/src/main/ets/TsIndex';
import FeatureConstants from '../../common/constants/FeatureConstants';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { desktopUtil } from '@ohos/componenthelper';

const TAG = 'OpenCloseViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 文件夹打开、关闭业务处理
 */
export class OpenCloseViewModel implements IContractedFolderOpenCloseViewModel {
  private static instance: OpenCloseViewModel;

  private mDataManager: FolderManager = FolderManager.getInstance();

  private mDesktopContext?: ServiceExtensionContext = GlobalContext.getContext();

  private mOpenCloseMgr: OpenCloseActionLifeCycleStatusManager = OpenCloseActionLifeCycleStatusManager.getInstance();

  private mActionEventMgr: FolderActionLifeCycleEventManager = FolderActionLifeCycleEventManager.getInstance();

  private mLayoutVm: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance();

  private mClosedCall: (() => void) | undefined = undefined;

  private folderOperationFlag: FolderOperationFlag = FolderOperationFlag.NONE;

  private mOpenCloseCallback: FolderActionLifeCycleEvent = {
    description: TAG,
    priority: FolderLifeCyclePriority.HIGHER,
    onOpeningFolder: (folder: GridLayoutItemInfo) => {
      this.onCommonOpeningFolder('common opening', folder);
    },
    onOpenedFolder: (folder: GridLayoutItemInfo) => {
      this.onCommonOpenedFolder('common opened', folder);
    },
    onClosingFolder: (folder: GridLayoutItemInfo) => {
      this.onCommonClosingFolder('common closing', folder);
    },
    onClosedFolder: (folder: GridLayoutItemInfo) => {
      this.onCommonClosedFolder('common closed', folder);
    }
  };

  private constructor() {
    this.mActionEventMgr.register(this.mOpenCloseCallback);
  }

  public static getInstance(): OpenCloseViewModel {
    if (!OpenCloseViewModel.instance) {
      OpenCloseViewModel.instance = new OpenCloseViewModel();
      ContractedFolderViewModelManager.getInstance()
        .register(ContractedFolderViewModelType.OPEN_CLOSE, OpenCloseViewModel.instance);
    }
    return OpenCloseViewModel.instance;
  }

  /**
   * 打开文件夹
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param isRename 是否重命名
   * @param flags 打开类型
   */
  public open(msg: string, folderId: string, isRename: boolean, flags: number = FolderOperationFlag.NONE): void {
    let folderItem: GridLayoutItemInfo = this.mDataManager.getFolder(folderId).getGridInfo();
    if (folderItem.folderId === FolderCommonConstants.INVALID_FOLDER_ID) {
      log.showWarn(TAG, 'opening folder failed, cannot find folder(%{public}s) in cache list ...');
      return;
    }
    log.showInfo(TAG, '(%{public}s) openFolder: %{public}s isRename:%{public}s container %{public}d', msg, folderId,
      isRename, folderItem.container);
    this.mLayoutVm.setAutoEnterEditing(isRename);
    this.mDataManager.setOpenFolderId(folderItem.folderId);
    if (this.mDataManager.getOpenedFolder().folderId !== FolderCommonConstants.INVALID_FOLDER_ID ||
      this.mDataManager.getClosingFolder()) {
      log.showWarn(TAG, '(%{public}s), folder(%{public}s) has already opened, close it firstly ...', msg, folderId);
      this.close('close folder by repeat open', FolderOperationFlag.IMMEDIATELY);
    }

    if (this.isImmediately(flags)) {
      /* 立刻切换状态，跳过ING的过程态，避免业务的动效被触发，直接组件上下树 */
      this.mOpenCloseMgr.toOpened(msg + ' Opened', folderItem);
    } else {
      this.mOpenCloseMgr.toOpening(msg + ' opening', folderItem);
    }
  }

  /**
   * 关闭文件夹
   *
   * @param msg 用于DFX的日志打印
   * @param flags 标志关闭的模式
   */
  public close(msg: string, flags: number = FolderOperationFlag.NONE): void {
    let openedFolder: GridLayoutItemInfo = this.mDataManager.getOpenedFolder();
    let closingFolder: GridLayoutItemInfo = this.mDataManager.getClosingFolder();
    if (!openedFolder || openedFolder.folderId === FolderCommonConstants.INVALID_FOLDER_ID) {
      if (this.isImmediately(flags) && closingFolder) {
        log.showWarn(TAG, 'closing folder by (%{public}s) failed, closing folder is abnormal, repair it ...', msg);
        this.mOpenCloseMgr.toClosedRepair(msg + 'closed repair', openedFolder);
      } else {
        log.showWarn(TAG, 'closing folder by (%{public}s) failed, no opened folder? ...', msg);
      }
      return;
    }
    log.showInfo(TAG, 'folder(%{public}s) closing, by (%{public}s), flags:%{public}d',
      this.getFolderDesc(openedFolder), msg, flags);
    this.folderOperationFlag = flags;
    if (this.isImmediately(flags) || this.isBreak(flags)) {
      log.showInfo(TAG, 'close folder no animate');
      this.mOpenCloseMgr.toClosed(msg + 'closed', openedFolder);
    } else {
      this.mOpenCloseMgr.toClosing(msg + 'closing', openedFolder);
    }
  }

  private getFolderDesc(folder?: GridLayoutItemInfo): string {
    return folder?.folderId ?? 'unknown';
  }

  private isImmediately(folderOperationFlag: FolderOperationFlag): boolean {
    return (folderOperationFlag & FolderOperationFlag.IMMEDIATELY) !== 0;
  }

  private isBreak(folderOperationFlag: FolderOperationFlag): boolean {
    return (folderOperationFlag & FolderOperationFlag.BREAK) !== 0;
  }

  /**
   * 根据folderId给每个文件夹注册动效生命周期回调
   *
   * @param folderId 文件夹id
   */
  public registerFolderActionEventByFolderId(folderId: string): void {
    this.mActionEventMgr.register(this.getFolderActionLifeCycleEvent(folderId));
  }

  /**
   * 根据folderId给每个文件夹取消注册动效生命周期回调
   *
   * @param folderId 文件夹id
   */
  public unregisterFolderActionEventByFolderId(folderId: string): void {
    this.mActionEventMgr.unregisterByFolderId(folderId);
  }

  /**
   * 设置文件夹关闭后的回调
   *
   * @param callback
   */
  public setClosedCallBack(callback: () => void): void {
    this.mClosedCall = callback;
  }

  private getFolderActionLifeCycleEvent(folderId: string): FolderActionLifeCycleEvent {
    return {
      folderId: folderId,
      description: TAG,
      priority: FolderLifeCyclePriority.LOW,
      onOpeningFolder: (folder: GridLayoutItemInfo) => {
        this.onItemOpeningFolder('Contracted Folder opening', folder);
      },
      onClosingFolder: (folder: GridLayoutItemInfo) => {
        this.onItemClosingFolder('Contracted Folder closing', folder);
      },
      onClosedFolder: (folder: GridLayoutItemInfo) => {
        this.onItemClosedFolder('Contracted Folder closed', folder);
      }
    } as FolderActionLifeCycleEvent;
  }

  /**
   * 打开文件夹opening状态的回调
   *
   * @param msg 用于DFX的日志打印
   * @param folder 文件夹
   */
  private onItemOpeningFolder(msg: string, folder: GridLayoutItemInfo): void {
    this.mActionEventMgr.notify(msg, folder, FolderActionLifeCycleStatus.BREAK_PRESS);
    performanceMonitor.begin('LAUNCHER_FOLDER_OPEN', performanceMonitor.ActionType.LAST_UP);
    this.mDataManager.setDragItemFolder(undefined);
    this.startTransitionAnimation(true);
    if (this.hasPlaceHolder(folder)) {
      // 恢复值，无需动效进行刷新，在closedFolderCallback里有用
      // 不恢复会影响打断场景连续打开关闭文件夹动效
      this.mLayoutVm.getViewOsrMgr(folder.folderId).hidePlaceHolder('opening-folder');
    }
  }

  /**
   * 关闭文件夹closing状态的回调
   *
   * @param msg 用于DFX的日志打印
   * @param folder 文件夹
   */
  private onItemClosingFolder(msg: string, folder: GridLayoutItemInfo): void {
    performanceMonitor.begin('CLOSE_FOLDER_ANI', performanceMonitor.ActionType.LAST_UP);
    if (this.hasPlaceHolder(folder)) {
      this.mLayoutVm.getViewOsrMgr(folder.folderId).hidePlaceHolder(msg);
    }
  }

  private hasPlaceHolder(folder: GridLayoutItemInfo): boolean {
    // 堆叠处有一个图标以上,就需要处理堆叠图标的场景
    let maxShow: number = FolderCommonUtil.getContractedFolderMaxShowIconNum(folder.area) - CommonConstants.NUMBER_TWO;
    let appListLength: number = FolderCommonUtil.getFilterAppListInFolder(folder).length;
    let isSmall: boolean = FolderCommonUtil.isLayout1X1(folder.area);
    let isLayout4X2: boolean = FolderCommonUtil.isLayout4X2(folder.area);
    log.showInfo(TAG, 'folder mAppListLength = %{public}d, maxShow = %{public}d', appListLength, maxShow);
    return (!isSmall && (appListLength >= maxShow && appListLength <= maxShow + 1)) ||
      (isLayout4X2 && appListLength > maxShow + 1);
  }

  /**
   * 关闭文件夹closed状态的回调
   *
   * @param msg 用于DFX的日志打印
   * @param folder 文件夹
   */
  private onItemClosedFolder(msg: string, folder: GridLayoutItemInfo): void {
    log.showInfo(TAG, 'folder %{public}s on closed: (%{public}s) with flag: %{public}d', folder.folderId, msg,
      this.folderOperationFlag);
    if (FolderCommonUtil.isLayout1X1(folder.area)) {
      this.closedToSwitchScreenShot(folder);
    } else {
      if (this.isBreak(this.folderOperationFlag)) {
        // 立即关闭场景(关闭文件夹时滑动桌面)不涉及动画, 直接显示.
        this.mLayoutVm.getViewOsrMgr(folder.folderId)?.showPlaceHolder(msg);
      } else if (!this.isImmediately(this.folderOperationFlag)) {
        // 从应用上滑返回时不显示，退出完成后会执行动效
        this.closedToShowPlaceHolder(msg, folder);
      }
    }
    FolderReporter.getInstance().reportCloseFolder(true, folder, folder.folderId); // 文件夹关闭 - 打点
  }

  private closedToShowPlaceHolder(msg: string, folder: GridLayoutItemInfo): void {
    setTimeout(() => {
      this.mActionEventMgr.notify(msg, folder, FolderActionLifeCycleStatus.PLACEHOLDER_SHOW);
    }, 20);
  }

  private closedToSwitchScreenShot(folder: GridLayoutItemInfo): void {
    // 使用动效刷新生命周期，保证closed时能执行展开态的aboutToDisAppear，确保下次opening能执行展开态的aboutToAppear
    let isShowEndPage: boolean = false;
    if (!CheckEmptyUtils.isEmpty(this.mDataManager.getDragItemFolder()?.keyName)) {
      let maxPerPage: number = FolderModel.getInstance().getOpenFolderMaxPerPage();
      let folderSize: number = folder.layoutInfo?.flat().length ?? 0;
      isShowEndPage = folderSize >= maxPerPage;
    }
    setTimeout(() => {
      this.mDataManager.setPageIndex(0);
      this.mLayoutVm.getViewOsrMgr(folder.folderId)
        .switchStatus('close folder', OBSERVER_SWITCH.END_PAGE_SHOW, isShowEndPage)
        .switchStatus('close folder', OBSERVER_SWITCH.CURRENT_PAGE_SHOW, false);
    }, 20);
  }

  private onCommonOpeningFolder(msg: string, folder: GridLayoutItemInfo): void {
    log.showInfo(TAG, 'folder %{public}s on opening: (%{public}s)', folder.folderId, msg);
    TraceUtil.traceOnce(DomainName.HOME, TraceUtil.CORE_METHOD_OPEN_FOLDER);
    this.report(true, folder);
    SceneIdentificationManager.notify(SceneState.FOLDER_OPEN);
    this.mDataManager.setPageIndex(0);
    AppStorage.setOrCreate('isMouseCross', true);
    this.updateStatus(false, true, false);
  }

  private onCommonOpenedFolder(msg: string, folder: GridLayoutItemInfo): void {
    log.showInfo(TAG, 'folder %{public}s on opened: (%{public}s)', folder.folderId, msg);
    // 展开态的挤位标记，在文件夹关闭后需要复位
    this.mDataManager.setIsSqueezing(false);
    this.updateStatus(false, false, true);
    this.startTransitionAnimation(false);
  }

  private onCommonClosingFolder(msg: string, folder: GridLayoutItemInfo): void {
    log.showInfo(TAG, 'folder %{public}s on closing: (%{public}s)', folder.folderId, msg);
    TraceUtil.traceOnce(DomainName.HOME, TraceUtil.CORE_METHOD_CLOSE_FOLDER);
    this.report(false, folder);
    AppStorage.setOrCreate('isMouseCross', false);
    this.mLayoutVm.updateOpenFolderStatus(FeatureConstants.OPEN_FOLDER_STATUS_CLOSE);
    this.updateStatus(true, true, false);
    let openFolder: GridLayoutItemInfo = this.mDataManager.getOpenedFolder();
    let isSmallFolder: boolean = FolderCommonUtil.isLayout1X1(openFolder.area);
    if ((FolderCommonUtil.isFolderInCurrentPage(openFolder) || openFolder.isInDock) && !isSmallFolder) {
      this.startTransitionAnimation(true, true);
      // 原位置OpenFolderComponent控制角标隐藏显示，待调整修改
      if (desktopUtil.isFoldExpandStatus()) {
        AppStorage.setOrCreate('isExpandFolderAnimClosing', true);
      }
    }
    this.mDesktopContext?.eventHub.emit(CommonConstants.DESKTOP_RECOVER_STATE);
  }

  private onCommonClosedFolder(msg: string, folder: GridLayoutItemInfo): void {
    SceneIdentificationManager.notify(SceneState.FOLDER_CLOSE);
    // 依赖关闭刷新的回调处理--例：解散状态更新
    if (this.mClosedCall) {
      this.mClosedCall();
      this.mClosedCall = undefined;
    }
    this.mLayoutVm.updateOpenFolderStatus(FeatureConstants.OPEN_FOLDER_STATUS_CLOSE);
    this.updateStatus(false, false, true);
  }

  private updateStatus(isFolderClosing: boolean, isFolderChanging: boolean,
    isIconTouchEnabled: boolean): void {
    this.mDataManager.setIsFolderClosing(isFolderClosing);
    this.mDataManager.setIsFolderChanging(isFolderChanging);
    this.mDataManager.setIsOpenFolderIconTouchEnabled(isIconTouchEnabled);
  }

  private report(isOpening: boolean, folder: GridLayoutItemInfo): void {
    if (isOpening) {
      PerformanceReporter.getInstance().reportEnterMemScene(CurrentMemScene.SCENE_FOLDER);
      FolderReporter.getInstance().reportFolderOperation(folder, true);
    } else {
      PerformanceReporter.getInstance().reportExitMemScene(CurrentMemScene.SCENE_FOLDER);
      FolderReporter.getInstance().reportFolderOperation(folder, false);
    }
  }

  /**
   * 开始文件夹位移动效
   *
   * @param isStart 是否开始执行
   * @param isCloseFolderAni 是否关闭文件夹动画
   */
  public startTransitionAnimation(isStart: boolean, isCloseFolderAni: boolean = false): void {
    let traceTag: string = this.getTraceTag(isCloseFolderAni);
    if (isStart) {
      TraceUtil.startAnimTrace(DomainName.HOME, traceTag);
    } else {
      TraceUtil.endAnimTrace(DomainName.HOME, traceTag);
      let folderItem: GridLayoutItemInfo = this.mDataManager.getOpenedFolder();
      FolderReporter.getInstance().reportCloseFolder(isCloseFolderAni, folderItem, folderItem.folderId); // 文件夹关闭 - 打点
    }
    this.renderGroupFolder(isStart, isCloseFolderAni);
  }

  private getTraceTag(isCloseFolderAni: boolean): string {
    return isCloseFolderAni ? TraceUtil.CORE_METHOD_CLOSE_FOLDER_ANI : TraceUtil.CORE_METHOD_OPEN_FOLDER_ANI;
  }

  private renderGroupFolder(isStart: boolean, isCloseFolderAni: boolean): void {
    if (isStart && isCloseFolderAni) {
      // 文件夹关闭动效开始取消桌面render group
      let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
      SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'FolderOpenComponentReusable', false, expandStatus);
    }
    if (!isStart && !isCloseFolderAni) {
      // 文件夹打开动效结束添加桌面render group
      let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
      SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(true, 'FolderOpenComponentReusable', false, expandStatus);
    }
  }
}