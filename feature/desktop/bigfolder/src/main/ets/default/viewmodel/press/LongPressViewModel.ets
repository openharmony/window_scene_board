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

import {
  CommonConstants,
  ContractedFolderCommonViewModel,
  ContractedFolderLayoutViewModel,
  ContractedFolderViewModelManager,
  ContractedFolderViewModelType,
  editModeManager,
  EditModeUtils,
  FolderActionLifeCycleEventManager,
  FolderActionLifeCycleStatus,
  FolderCommonUtil,
  FolderManager,
  GridLayoutItemInfo,
  GridLayoutUtil,
  IContractedFolderLongPressViewModel,
  OBSERVER_SWITCH,
  DesktopItemVibratorManager,
  lockLayoutManager,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlobalContext, HiSysEventUtil } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import {
  DragAccessibilityUtils,
  dragSnapshotHelper,
  SCBVisualEffectMgr,
  SnapshotType
} from '@ohos/componenthelper/src/main/ets/TsIndex';
import { EventType, scbEventExclusiveManager } from '@ohos/windowscene/src/main/ets/TsIndex';
import { BadgeAnimationType } from '@ohos/launchercommon/Index';

const TAG = 'LongPressViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹长按业务处理
 */
export class LongPressViewModel implements IContractedFolderLongPressViewModel {
  private static instance: LongPressViewModel;

  private mDesktopContext?: ServiceExtensionContext = GlobalContext.getContext();

  private mFolderManager: FolderManager = FolderManager.getInstance();

  // 文件夹动效生命周期事件管理
  private mActionEventMgr: FolderActionLifeCycleEventManager = FolderActionLifeCycleEventManager.getInstance();

  private mLayoutVm: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance();

  private isMenuDisappear: boolean = false;

  // 标记DROP截图和菜单的临时标志
  private isDropFinish: boolean = false;
  private isNeedMenuShow: boolean = false;

  private constructor() {
  }

  public static getInstance(): LongPressViewModel {
    if (!LongPressViewModel.instance) {
      LongPressViewModel.instance = new LongPressViewModel();
      ContractedFolderViewModelManager.getInstance().register(ContractedFolderViewModelType.LONG_PRESS,
        LongPressViewModel.instance);
    }
    return LongPressViewModel.instance;
  }

  /**
   * 图标长按效果取消
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param isAppTouch 按压图标
   */
  public onIconPressCancel(msg: string, folderId: string, isAppTouch: boolean): void {
    if (isAppTouch) {
      this.mDesktopContext?.eventHub.emit(`appIconLongPressEffectCancel`, true);
    }
  }

  /**
   * 长按350ms触发截图事件
   *
   * @param msg 事件描述
   * @param folderId 文件夹id
   * @param event 事件信息
   */
  public onActionSnapshot(msg: string, folderId: string): void {
    // 截图先触发, 先恢复菜单和截图标志.
    this.isNeedMenuShow = false;
    this.isDropFinish = false;
    const isEditMode = editModeManager.isInEditMode();
    const dropCallback = isEditMode ? undefined : () => {
      if (this.isNeedMenuShow) {
        this.isNeedMenuShow = false;
        log.showInfo('snapshot drop finish.');
        this.makeMenuShow('onActionSnapshot', folderId);
      } else {
        this.isDropFinish = true;
      }
    };
    log.showInfo('start to snapshot %{public}s', msg);
    this.mLayoutVm.getViewOsrMgr(folderId).switchStatus(msg, OBSERVER_SWITCH.DOWNLOAD_MASK, true);
    const key: string = GridLayoutUtil.generateUniqueKey(this.mFolderManager.getFolder(folderId)?.getGridInfo());
    const isSolidColor = SCBVisualEffectMgr.isFolderSolidColor();
    // 先取DRAP, 再取DROP, 确保长按显示拖拽和落位都存在截图
    const scale = EditModeUtils.getDesktopScale();
    const dropId = (isEditMode || isSolidColor) ? CommonConstants.FOLDER_GROUP_TAG + folderId
      : CommonConstants.FOLDER_GRID_TAG + folderId;
    log.showInfo(`onActionSnapshot ${dropId}, ${scale}`);
    const dragId = isSolidColor ? CommonConstants.FOLDER_GROUP_TAG + folderId
        : CommonConstants.FOLDER_GRID_TAG + folderId;
    dragSnapshotHelper.snapshotFromId(dragId, SnapshotType.DRAG, key, null, scale, scale);
    dragSnapshotHelper.snapshotFromId(dropId, SnapshotType.DROP, key, dropCallback);
  }

  /**
   * 长按500ms触发的振动事件
   *
   * @param msg 事件描述
   * @param folderId 文件夹id
   */
  public onActionVibrator(msg: string, folderId: string): void {
    log.showInfo('long press to vibrator: %{public}s', msg);
    if (!scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
      DesktopItemVibratorManager.getInstance().longPressVibrator(TAG);
    }
    // 锁定布局时长按不弹出菜单，提示toast框
    if (lockLayoutManager.isLockLayout()) {
      lockLayoutManager.toastLockedLayout();
      return;
    }
    // 拖拽适配无障碍朗读文件夹起拖播报
    DragAccessibilityUtils.textAnnouncedForDragStart();
    if (!editModeManager.isInEditMode() && !AppStorage.get<boolean>('isDrag')) {
      // 这里需要等待截图成功, 才能显示菜单. 截图类型为SnapshotType.DROP
      if (this.isDropFinish) {
        this.isDropFinish = false;
        this.makeMenuShow(msg, folderId);
      } else {
        this.isNeedMenuShow = true;
        log.showInfo('snapshot drop is not ready.');
      }
    }
  }

  private makeMenuShow(msg: string, folderId: string):void {
    this.isMenuDisappear = false;
    this.mLayoutVm.getViewOsrMgr(folderId).switchStatus(msg, OBSERVER_SWITCH.MENU_SHOW, true);
  }

  /**
   * 长按550ms后触发
   *
   * @param msg 事件描述
   * @param folderId 文件夹id
   */
  public onActionPressAnimation(msg: string, folderId: string): void {
    if (editModeManager.isInEditMode()) {
      let folder: GridLayoutItemInfo = this.mFolderManager.getFolder(folderId)?.getGridInfo();
      this.mActionEventMgr.notify('long press animation', folder, FolderActionLifeCycleStatus.PRESSED);
    }
  }

  /**
   * 通用场景下文件夹菜单显示执行
   *
   * @param msg 事件描述
   * @param folderId 文件夹id
   * @param isLongPress 是否长按
   */
  public onAppMenuAppear(msg: string, folderId: string, isLongPress: boolean): void {
    log.showInfo('%{public}s, menu onAppear for press folder isMenuDisappear = %{public}s', msg, this.isMenuDisappear);
    if (this.isMenuDisappear) {
      return;
    }
    HiSysEventUtil.reportLongPressFolder(folderId, true);
    if (isLongPress) {
      let folder: GridLayoutItemInfo = this.mFolderManager.getFolder(folderId).getGridInfo();
      this.mActionEventMgr.notify('showMenu hide name', folder, FolderActionLifeCycleStatus.MENU_SHOW);
      this.mActionEventMgr.notify('AppMenu appear', folder, FolderActionLifeCycleStatus.PRESSED);
    }
  }

  /**
   * 通用场景下文件夹菜单消失执行
   *
   * @param msg 事件描述
   * @param folderId 文件夹id
   * @param isLongPress 是否长按
   */
  public onAppMenuDisappear(msg: string, folderId: string, isLongPress: boolean): void {
    log.showInfo('%{public}s: menu disappear for press folder', msg);
    this.isMenuDisappear = true;
    if (isLongPress && !this.mLayoutVm.isFolderUnregister(folderId)) {
      let folder: GridLayoutItemInfo = this.mFolderManager.getFolder(folderId).getGridInfo();
      this.mActionEventMgr.notify('AppMenu disappear', folder, FolderActionLifeCycleStatus.MENU_HIDDEN);
    }
    ContractedFolderCommonViewModel.getInstance().execFolderMenuDisappearCall();
  }

  onActionHideBadge(folderId: string): void {
    if (!editModeManager.isInEditMode()) {
      let folder: GridLayoutItemInfo = this.mFolderManager.getFolder(folderId)?.getGridInfo();
      if (FolderCommonUtil.isLayout1X1(folder.area)) {
        ContractedFolderLayoutViewModel.getInstance().getDataOsrMgr(folderId)
          .updateBadgeAniType(BadgeAnimationType.OPACITY_ZERO, 'folder longPress to hide');
      }
    }
  }
}