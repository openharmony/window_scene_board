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
  AnimateToScheduleUtils,
  CheckEmptyUtils,
  LogDomain,
  Logger,
  RectInfo,
  SingletonHelper,
  StartType
} from '@ohos/basicutils/src/main/ets/TsIndex';
import { DragConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { dropAnimationManager } from '@ohos/componentanimator/Index';
import { DropAnimationCancelReason, DropAnimationScene } from '@ohos/componentanimator/src/main/ets/TsIndex';
import { ItemUtils, RTLUtil, SCBVisualEffectMgr } from '@ohos/componenthelper';
import { DeviceHelper, GlobalContext, localEventManager, ResourceManager } from '@ohos/frameworkwrapper';
import { BadgeAnimationType, FolderResizeUtil, HoverAnimationUtil, MenuCommonUtil } from '@ohos/launchercommon/Index';
import { AppInstallingDataManager } from '@ohos/launchercommon/src/main/ets/appinstall/AppInstallingDataManager';
import {
  DragAppToFolderData,
  FoldersData
} from '@ohos/launchercommon/src/main/ets/folder/next/common/model/data/FoldersData';
import {
  AppGalleryDownloadManager,
  AppInstallUtils,
  AppItemInfo,
  AppStatus,
  BaseObserverManager,
  CloseAppManager,
  CommonConstants,
  ContractedFolderCommonViewModel,
  ContractedFolderLayoutViewModel,
  ContractedFolderViewModelManager,
  ContractedFolderViewModelType,
  DesktopLayoutState,
  DeviceState,
  DownloadStatusInfo,
  editModeManager,
  EditModeUtils,
  EventConstants,
  FolderActionLifeCycleEventManager,
  FolderActionLifeCycleStatus,
  FolderClickType,
  FolderCommonUtil,
  FolderManager,
  FolderModel,
  FolderReporter,
  FolderStyleManager,
  GridLayoutItemInfo,
  GridLayoutUtil,
  IContractedFolderDragViewModel,
  IContractedFolderEventViewModel,
  IContractedFolderLongPressViewModel,
  LayoutViewModel,
  MenuDataOption,
  MenuInfo,
  OBSERVER_SWITCH,
  PreInstallUtils,
  ReceiveEventInfo,
  ScreenSplitUtil,
  ShortcutViewModel,
  StyleConstants,
  desktopItemDraggableManager,
  OBSERVER_TYPE,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { ItemsCount } from '@ohos/launchercommon/src/main/ets/utils/GridLayoutUtil';
import {
  EventType,
  scbEventExclusiveManager,
  SCBSceneSessionManager,
  SCBTransitionManager
} from '@ohos/windowscene/src/main/ets/TsIndex';
import ServiceExtensionContext from 'application/ServiceExtensionContext';

const TAG = 'ContractedFolderEventViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 折叠态文件夹通用事件处理
 */
class ContractedFolderEventViewModel implements IContractedFolderEventViewModel {
  private mDataMgr: FolderManager = FolderManager.getInstance();

  private mIsAppTouch: boolean = false;

  private dragFolderId: string = '-1';

  private folderRect: RectInfo = new RectInfo();

  private touchEvent: TouchEvent | undefined = undefined;

  private convertSmallText: Resource = $r('app.string.covertTo_smallFolder');

  private convertBigText: Resource = $r('app.string.covertTo_bigFolder');

  private mDesktopContext?: ServiceExtensionContext = GlobalContext.getContext();


  public constructor() {
    log.showInfo(TAG, 'ContractedFolderEventViewModel constructor');
  }

  private registerEvent(listener: ReceiveEventInfo): void {
    localEventManager.registerEventListener(listener, [
      EventConstants.EVENT_BADGE_UPDATE,
      EventConstants.EVENT_EDIT_MODE_TOUCH_DOWN_ITEM,
      EventConstants.EVENT_FOLDER_DRAG_END
    ]);
  }

  /**
   * 文件夹网格的鼠标事件
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param event 鼠标事件
   */
  public onMouse(msg: string, folderId: string, event?: MouseEvent): void {
    log.showInfo(TAG, `receive a mouse event:${event?.button} for (${msg})`);
    if (event?.button == MouseButton.Right) {
      if (event.stopPropagation) {
        event.stopPropagation();
      }
      log.showInfo(TAG, 'onMouse mouse button right');
      AppStorage.setOrCreate<string | undefined>('selectDesktopAppItem', folderId);
      AppStorage.setOrCreate<string | undefined>('selectItem', folderId);
    }
  }

  /**
   * 拖拽开始手势判断
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param gestureInfo 手势
   * @param event 基础手势事件
   */
  public onDragGestureJudgeBegin(msg: string, folderId: string, gestureInfo: GestureInfo): number {
    log.showInfo(TAG, '(%{public}s), just drag begin for folder %{public}s', msg, folderId);
    let folderItem: GridLayoutItemInfo = this.mDataMgr.getFolder(folderId).getGridInfo();
    if (gestureInfo.type === GestureControl.GestureType.DRAG) {
      if (editModeManager.isInEditMode() && !editModeManager.isDraggable(folderItem) ||
        !desktopItemDraggableManager.getEnableDrag()) {
        log.showInfo(TAG, `${folderId} dragGestureJudge:${GestureJudgeResult.REJECT}`);
        return GestureJudgeResult.REJECT;
      }
    }
    log.showInfo(TAG, `${folderId} dragGestureJudge:${GestureJudgeResult.CONTINUE}`);
    return GestureJudgeResult.CONTINUE;
  }

  /**
   * 拖拽开始手势判断
   *
   * @param msg 用于DFX的日志打印
   * @param event 基础手势事件
   * @param folderId 文件夹id
   * @param dragStart 拖拽开始回调
   */
  public onDragStart(msg: string, event: DragEvent, folderId: string,
    dragStart?: (event: DragEvent) => DragItemInfo): DragItemInfo | undefined {
    log.showInfo(TAG, `onDragStart:${folderId}`);
    // 开始拖动时清理一次缓存，防止文件夹判断出现异常
    this.mDataMgr.deleteFolderCache(msg, folderId);
    let dragViewModel: IContractedFolderDragViewModel = ContractedFolderViewModelManager.getInstance()
      .get(ContractedFolderViewModelType.DRAG) as IContractedFolderDragViewModel;
    this.dragFolderId = folderId;
    let folderItem: GridLayoutItemInfo = this.mDataMgr.getFolder(folderId).getGridInfo();
    // dock区拖拽事件由父组件的回调执行
    if (folderItem.container === CommonConstants.CONTAINER_SMARTDOCK) {
      ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folderId)
        .switchStatus(msg, OBSERVER_SWITCH.MENU_SHOW, false);
      log.showInfo(TAG, `drag from dock :${folderId} > ${folderItem.container}`);
      return dragStart?.(event);
    }
    let key: string = GridLayoutUtil.generateUniqueKey(folderItem);
    let styleMgr: FolderStyleManager = FolderStyleManager.getInstance();
    // 文件夹菜单及拖拽过程中未放大1.05倍，落位动效需要在默认1.05倍基础上反向缩放，保证动效正常
    const startScale: number = 1 / DragConstants.DROP_START_SCALE;
    dropAnimationManager.getDropViewModel(DropAnimationScene.SCENE_DESKTOP, key)
      ?.setWidth(EditModeUtils.convertWithDesktopScale(styleMgr.getWidthByArea(folderItem?.area)))
      .setHeight(EditModeUtils.convertWithDesktopScale(styleMgr.getHeightByArea(folderItem?.area)))
      .setRadius(EditModeUtils.convertWithDesktopScale(styleMgr.getFolderRadiusByArea(folderItem?.area)))
      .setUseEffect(editModeManager.isInNormalMode() && !SCBVisualEffectMgr.isFolderSolidColor())
      .setScale(startScale);
    // 适配空间感动效，起拖时桌面恢复大小，避免起拖时菜单异常放大
    if (!ContractedFolderLayoutViewModel.getInstance()
      .getViewOsrMgr(folderId)?.getStatus(OBSERVER_SWITCH.FOLDER_VISIBLE)) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_DESKTOP_MENU_EVENT, 1);
    }
    log.showInfo(TAG, `to dragStart :${folderId}`);
    return dragViewModel?.dragStart(msg, folderId, event);
  }

  /**
   * 拖拽开始手势判断
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  public onDragEnd(msg: string, folderId: string): boolean {
    this.dragFolderId = '-1';
    let dragViewModel: IContractedFolderDragViewModel = ContractedFolderViewModelManager.getInstance()
      .get(ContractedFolderViewModelType.DRAG) as IContractedFolderDragViewModel;
    dragViewModel?.dragEnd(msg, folderId);
    return false;
  }

  /**
   * 图标长按效果取消
   */
  public onIconPressCancel(): void {
    if (this.mIsAppTouch) {
      GlobalContext.getContext()?.eventHub.emit(`appIconLongPressEffectCancel`, true);
    }
  }

  /**
   * 获取长按菜单出现的回调
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param isLongPress 是否长按触发的菜单显示
   * @returns 回调函数
   */
  public onAppMenuAppear(msg: string, folderId: string, isLongPress: boolean): void {
    let longPressViewModel: IContractedFolderLongPressViewModel = ContractedFolderViewModelManager.getInstance()
      .get(ContractedFolderViewModelType.LONG_PRESS) as IContractedFolderLongPressViewModel;
    longPressViewModel?.onAppMenuAppear(msg, folderId, isLongPress);
  }

  /**
   * 获取长按菜单显示的回调
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   * @param isLongPress 是否长按触发的菜单显示
   * @returns 回调函数
   */
  public onAppMenuDisappear(msg: string, folderId: string, isLongPress: boolean): void {
    log.showInfo(TAG, 'onAppMenuDisappear dragFolderId %{public}s', this.dragFolderId);
    let longPressViewModel: IContractedFolderLongPressViewModel = ContractedFolderViewModelManager.getInstance()
      .get(ContractedFolderViewModelType.LONG_PRESS) as IContractedFolderLongPressViewModel;
    longPressViewModel?.onAppMenuDisappear(msg, folderId, isLongPress);
  }

  /**
   * 菜单关闭
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  public onMenuClose(msg: string, folderId: string): void {
    let layoutVm: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance();
    layoutVm.getViewOsrMgr(folderId).switchStatus(msg, OBSERVER_SWITCH.MENU_SHOW, false);
    layoutVm.getViewOsrMgr(folderId).switchStatus(msg, OBSERVER_SWITCH.MENU_EFFECT_HIDE, false);
    ContextMenu.close();
  }

  /**
   * 创建文件夹菜单
   *
   * @param convertFolder 文件夹大小转换
   * @param menuCallback 菜单回退
   * @param isConvertToSmall 是否大小转换
   * @param isCanRenameFolder 是否重命名
   * @returns
   */
  public buildMenuInfoList(menuCallback: Function, isConvertToSmall: boolean,
    isCanRenameFolder: boolean): MenuInfo[] {
    const menuInfoList: MenuInfo[] = [];
    if (isCanRenameFolder) {
      const renameMenu = new MenuInfo();
      renameMenu.menuType = CommonConstants.MENU_TYPE_FIXED;
      renameMenu.menuImgSrc = StyleConstants.DEFAULT_RENAME_IMAGE;
      renameMenu.menuText = ResourceManager.getInstance().getStringByName('rename_folder');
      renameMenu.onMenuClick = (): void => {
        log.showInfo(TAG, 'Launcher click menu to rename');
        menuCallback();
      };
      menuInfoList.push(renameMenu);
    }
    return menuInfoList;
  }

  /**
   * 文件夹点击事件处理统一入口
   *
   * @param msg 用于DFX日志打印
   * @param folderId 文件夹id
   * @param clickType 点击类型
   * @param appItem 应用
   */
  public onClick(msg: string, folderId: string, clickType: number, appItem?: GridLayoutItemInfo): void {
    log.showInfo(TAG, '(%{public}s) for clickType %{public}d', msg, clickType);
    switch (clickType) {
      case FolderClickType.ICON_CLICK:
        this.execIconClickEvent(folderId, appItem);
        break;
      case FolderClickType.GRID_CLICK:
        this.execFolderGridClickEvent(folderId);
        break;
      default:
        break;
    }
  }

  private execIconClickEvent(folderId: string, appItem?: GridLayoutItemInfo): void {
    if (editModeManager.isInEditMode() || ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folderId)
      .getIsMenuShow()) {
      log.showInfo(TAG, 'open folder app fail as edit mode or menu show');
      return;
    }
    if (!appItem) {
      log.showWarn(TAG, 'open folder app fail with null item');
      return;
    }
    log.showWarn(TAG, `onAppIconClick, icon status is ${appItem.appStatus}`);
    let folderItem: GridLayoutItemInfo = this.mDataMgr.getFolder(folderId).getGridInfo();
    if (appItem.appStatus !== AppStatus.INSTALLED && appItem.appStatus !== undefined) {
      let downloadStatusInfo: DownloadStatusInfo | undefined =
        AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(appItem.bundleName);
      if (downloadStatusInfo) {
        this.dealUninstalledItemClickEvent(downloadStatusInfo.status, appItem, folderItem);
      } else {
        this.dealUninstalledItemClickEvent(appItem.appStatus as AppStatus, appItem, folderItem);
      }
    } else {
      const actionMgr: FolderActionLifeCycleEventManager = FolderActionLifeCycleEventManager.getInstance();
      actionMgr.notify('click folder icon', folderItem, FolderActionLifeCycleStatus.ICON_CLICK);
      this.openItemInFolder(folderItem, appItem);
    }
  }

  private openItemInFolder(folderItem: GridLayoutItemInfo, appItem: GridLayoutItemInfo): void {
    this.setStartAppInfo(appItem);
    FolderReporter.getInstance().reportClickAppIconInFolderEvent(folderItem, appItem);
    ContractedFolderCommonViewModel.getInstance().waitFolderAnimateFinish(() => {
      log.showInfo(TAG, `onAppIconClick waitFolderAnimateFinish openApplication`);
      if (appItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        ShortcutViewModel.getInstance().onShortcutAppClick(appItem as object as AppItemInfo);
      } else {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_OPEN_APPLICATION, appItem);
      }
    });
  }

  private setStartAppInfo(item: GridLayoutItemInfo): void {
    let startType: StartType = StartType.FOLDER;
    if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      startType = StartType.SHORTCUT_APP;
    }
    CloseAppManager.getInstance().setStartAppType(startType, undefined, undefined, item.shortcutId);
  }

  private dealUninstalledItemClickEvent(appStatus: AppStatus, appItem: GridLayoutItemInfo,
    folderItem: GridLayoutItemInfo): void {
    // 如果应用正在安装（更新过程中的安装，第一次下载应用安装由于有动效不需要toast），点击应用弹出toast
    if (AppInstallingDataManager.getInstance().isInstalling(appItem.bundleName)) {
      AppInstallingDataManager.getInstance().toastInstalling(appItem.bundleName);
      return;
    }
    if ((appItem.appIndex && appItem.appIndex > 0) || appItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      AppInstallUtils.getInstance().clickTwinApp(appItem.bundleName);
      return;
    }
    if (appStatus === AppStatus.DOWNLOADING) {
      //  调用暂停接口
      AppInstallUtils.getInstance().pauseTask(appItem.bundleName);
    } else if (appStatus === AppStatus.PENDING || appStatus === AppStatus.WAIT_FOR_HARMONY) {
      //  调用检查接口
      if (PreInstallUtils.checkIsNeedInstallAppByIntent(appItem)) {
        AppInstallUtils.getInstance().requestTask(appItem);
      } else {
        AppInstallUtils.getInstance().checkTask(appItem);
      }
      FolderReporter.getInstance().reportClickAppIconInFolderEvent(folderItem, appItem);
    } else if (appStatus === AppStatus.PAUSING || appStatus === AppStatus.WIFI_WAITING) {
      //  调用恢复接口
      AppInstallUtils.getInstance().resumeTask(appItem.bundleName);
    } else if (appStatus === AppStatus.WAITING) {
      AppInstallUtils.getInstance().dealClickPreDownload(appItem as GridLayoutItemInfo);
    }
  }

  private execFolderGridClickEvent(folderId: string): void {
    let folderItem: GridLayoutItemInfo = this.mDataMgr.getFolder(folderId).getGridInfo();
    if (!this.isCanOpenFolder(folderItem)) {
      return;
    }
    if (this.isDragAppToFolder()) {
      animateTo({
        duration: 0, onFinish: () => {
          setTimeout(() => {
            this.openFolder('click and delay to open folder', folderItem);
          }, 200)
        }
      }, () => {
        this.mDataMgr.setDragAppToFolder(new DragAppToFolderData());
      })
    } else {
      this.openFolder('click to open folder', folderItem);
    }
  }

  private openFolder(msg: string, folderItem: GridLayoutItemInfo): void {
    SCBTransitionManager.getInstance().cancelCloseAppAnimate();
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
    ContractedFolderCommonViewModel.getInstance().openFolder(msg, folderItem.folderId, false)
  }

  private isCanOpenFolder(folderItem: GridLayoutItemInfo): boolean {
    if (scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
      log.showWarn(TAG, 'click open folder fail as exclusive desktop click');
      return false;
    }
    if (this.isDragAppToFolder()) {
      log.showWarn(TAG, 'click open folder fail as dragging app to folder');
      return false;
    }
    if (ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folderItem.folderId).getIsMenuShow()) {
      log.showWarn(TAG, 'click open folder fail as the folder menu is show');
      return false;
    }
    // 解决编辑模式下打开折叠屏相邻页文件夹，手势返回后，文件夹显示透明问题
    if (!editModeManager.isDraggable(folderItem)) {
      log.showWarn(TAG, 'click open Folder fail for another page');
      return false;
    }
    if (this.mDataMgr.getDisappearLastAppData()?.folderId === folderItem.folderId) {
      log.showWarn(TAG, 'click open Folder fail for this folder is disappear');
      return false;
    }
    // 拖拽改变大小动效过程中不支持点击，避免展开获取的缓存信息与实际结果不匹配
    if (FolderModel.getInstance().getResizeAnimationState()) {
      log.showError(TAG, 'click open Folder fail for adjustSize animation going');
      return false;
    }
    return true;
  }

  private isDragAppToFolder(): boolean {
    let item: DragAppToFolderData = this.mDataMgr.getDragAppToFolder();
    return !CheckEmptyUtils.checkStrIsEmpty(item.appKeyName);
  }

  /**
   * 文件夹touch事件处理统一入口
   *
   * @param msg 用于DFX日志打印
   * @param folderId 文件夹id
   * @param event touch事件
   * @param item 触碰的item
   */
  public onTouch(msg: string, folderId: string, event?: TouchEvent, item?: GridLayoutItemInfo): void {
    if (!event) {
      log.showError(TAG, '(%{public}s) folder %{public}s touch error with null event', msg, folderId);
      return;
    }
    if (item) {
      this.execIconTouchEvent(msg, item, event);
    } else {
      this.execGridTouchEvent(msg, folderId, event);
    }
  }

  private execIconTouchEvent(msg: string, item: GridLayoutItemInfo, event: TouchEvent): void {
    if (event.type === CommonConstants.TOUCH_TYPE_DOWN) {
      log.showInfo(TAG, '(%{public}s) onTouch down start: %{public}s', msg, item.bundleName);
      this.mIsAppTouch = true;
      CloseAppManager.getInstance().setAdaptiveIcon(item.bundleName, item.moduleName, item.abilityName, item.appIconId);
    }
  }

  private execGridTouchEvent(msg: string, folderId: string, event: TouchEvent): void {
    let layoutVm: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance();
    if ((event.type === TouchType.Up || event.type === TouchType.Cancel) &&
    layoutVm.getViewOsrMgr(folderId).getIsHideMask()) {
      layoutVm.getViewOsrMgr(folderId).switchStatus(msg, OBSERVER_SWITCH.DOWNLOAD_MASK, false);
    }
    let folder: GridLayoutItemInfo = FolderManager.getInstance().getFolder(folderId).getGridInfo();
    if (scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
      if (event.touches.length === 1 && event.type === TouchType.Down) {
        scbEventExclusiveManager.restoreAllEventExclusive(EventType.DESKTOP_CLICK);
      }
      log.showWarn(TAG, '(%{public}s) exclusive event %{public}s on folder %{public}s', msg, event.type, folderId);
      return;
    }
    log.showInfo(TAG, '(%{public}s) grid touch on folder %{public}s', msg, folderId);
    if (event.type === TouchType.Down) {
      this.onTouchDown(folder, layoutVm);
      this.setFolderMenuPosition(folderId, event);
    }
    if (event.type === TouchType.Up) {
      this.onTouchUp(folder, layoutVm);
    }
    if (event.type === TouchType.Cancel) {
      this.onTouchCancel(folder);
    }
  }

  /**
   * 处理touch down事件
   *
   * @param folderOsr 文件夹observer类
   * @param folder 文件夹对象
   */
  private onTouchDown(folder: GridLayoutItemInfo | undefined, layoutVm: ContractedFolderLayoutViewModel): void {
    dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.TOUCH_DESKTOP_ITEM);
    let actionMgr: FolderActionLifeCycleEventManager = FolderActionLifeCycleEventManager.getInstance();
    this.mDesktopContext?.eventHub.off(`otherIconLongPressEffectCancel`);
    this.mDesktopContext?.eventHub.on(`otherIconLongPressEffectCancel`,
      () => actionMgr.notify('cancel other icon press', folder, FolderActionLifeCycleStatus.CANCEL_PRESS));
    if (layoutVm.isResizeFolder(folder?.folderId)) {
      log.showWarn(TAG, 'notify pressing animation fail as folder is adjusting');
      return;
    }
    // 基于UX设计，按压到图标时延迟100ms做按压动效
    if (this.mIsAppTouch) {
      setTimeout(() => {
        if (this.mIsAppTouch) {
          actionMgr.notify('touch down delay to press animation', folder, FolderActionLifeCycleStatus.PRESSING);
        }
      }, 100);
    } else {
      actionMgr.notify('touch down delay to press animation', folder, FolderActionLifeCycleStatus.PRESSING);
    }
  }

  /**
   * 处理touch up事件
   *
   * @param folder 文件夹对象
   */
  private onTouchUp(folder: GridLayoutItemInfo, layoutVm: ContractedFolderLayoutViewModel): void {
    this.mIsAppTouch = false;
    if (ScreenSplitUtil.isScreenSplit(TAG)) {
      layoutVm.getViewOsrMgr(folder.folderId).switchStatus('hide menu screen split', OBSERVER_SWITCH.MENU_SHOW, false);
    }
    if (layoutVm.isResizeFolder(folder.folderId)) {
      log.showWarn(TAG, 'notify pressed animation fail as folder is adjusting');
      return;
    }
    FolderActionLifeCycleEventManager.getInstance()
      .notify('touch up to restore animation', folder, FolderActionLifeCycleStatus.PRESSED);
  }

  private onTouchCancel(folder: GridLayoutItemInfo): void {
    FolderActionLifeCycleEventManager.getInstance()
      .notify('touch up to restore animation', folder, FolderActionLifeCycleStatus.PRESSED);
  }

  private setFolderMenuPosition(folderId: string, event: TouchEvent): void {
    this.folderRect = ItemUtils.getRectById(CommonConstants.FOLDER_GROUP_TAG + folderId);
    this.touchEvent = event;
  }

  /**
   * 鼠标悬停处理
   *
   * @param msg DFX日志
   * @param folderId 文件夹id
   * @param isHover 鼠标是否悬停在图标上
   */
  public onHover(msg: string, folderId: string, isHover: boolean): void {
    log.showInfo('(%{public}s on hover folder %{public}s, isHover: %{public}s)', msg, folderId, isHover);
    const isSmall: boolean = this.mDataMgr.getFolder(folderId).isSmall();
    let osrMgr: BaseObserverManager = ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folderId);
    HoverAnimationUtil.hoverEffect(isHover, isSmall, (hoverScale: number) => {
      osrMgr.getObserverUpdator('onHover folder', OBSERVER_TYPE.FOLDER).scale(hoverScale);
    });
  }

  /**
   * 获取长按文件夹的截图显示的配置
   *
   * @param msg 事件描述
   * @param folderId 文件夹id
   * @param pageIndex 长按的文件夹所在页
   */
  public getMenuOption(msg: string, folderId: string, pageIndex: number): MenuDataOption {
    let menuDataOption: MenuDataOption = new MenuDataOption();
    let sign: number = RTLUtil.getRTLRate();
    let folder: FoldersData = FolderManager.getInstance().getFolder(folderId);
    let folderItem: GridLayoutItemInfo = folder.getGridInfo();
    let hotAreaSideWidth = FolderResizeUtil.getHotAreaSideWidth(FolderCommonUtil.isDockFolder(folderId));
    menuDataOption.layoutRegionMargin = { top: 0, left: 0, right: 0, bottom: 0 };
    menuDataOption.preAnimationStartScale = this.getFolderMenuAnimateStartScale(folderItem);
    menuDataOption.preAnimationEndScale = this.getFolderMenuAnimateEndScale(folderItem);
    menuDataOption.offset = { x: hotAreaSideWidth / 2 * sign };
    menuDataOption.onDisappearCallback = (): void => {
      let viewMgr: BaseObserverManager = ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folderId);
      viewMgr.switchStatus(msg, OBSERVER_SWITCH.MENU_SHOW, false)
        .switchStatus(msg, OBSERVER_SWITCH.MENU_EFFECT_HIDE, false);
      if (!viewMgr.getStatus(OBSERVER_SWITCH.EDIT_FOLDER_MODE)) {
        ContractedFolderLayoutViewModel.getInstance().getDataOsrMgr(folderId)
          .updateBadgeAniType(BadgeAnimationType.CLOSE_FOLDER_COMPONENT_SHOW, 'menu disappear to show');
      }
    };
    this.getBigFolderMenuPosition(menuDataOption, folderId, pageIndex, sign);
    if (folder.isSmall()) {
      menuDataOption.placement = MenuCommonUtil.getMenuPlacement(this.touchEvent as TouchEvent, this.folderRect, 1, 1);
    }
    if (menuDataOption.placement === Placement.BottomRight || menuDataOption.placement === Placement.TopRight) {
      menuDataOption.offset = { x: -(hotAreaSideWidth / 2) * sign };
    }
    log.showInfo(TAG, `getContextMenu placement: ${menuDataOption.placement}`);
    menuDataOption.onWillAppear = () => {
      localEventManager.sendLocalEventSticky(
        EventConstants.EVENT_DESKTOP_MENU_EVENT, CommonConstants.SCALE_FACTOR_WHEN_MENU_SHOW);
    };
    menuDataOption.onWillDisappear = () => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_DESKTOP_MENU_EVENT, 1);
    };
    return menuDataOption;
  }

  private getBigFolderMenuPosition(menuDataOption: MenuDataOption, folderId: string, pageIndex: number,
    sign: number): void {
    let folderMenuIsShowBottom: boolean = MenuCommonUtil.setIsMenuShowBottom(this.folderRect);
    menuDataOption.placement = folderMenuIsShowBottom ? Placement.BottomLeft : Placement.TopLeft;
    // 修改offsetX偏移为负值，当文件夹在直板机或折叠屏幕右侧时，菜单会调整显示位置，pad始终可显示下，无需调整
    let folderStatus: number = AppStorage.get('folderStatusMenu') as number ?? DeviceState.DEFAULT_STATE;
    if (!DeviceHelper.isPad() && FolderCommonUtil.isColumnMoreTwo(folderId)) {
      // 直板机或者折叠屏展开时右半屏
      if (folderStatus === DeviceState.DEFAULT_STATE ||
        (folderStatus !== DeviceState.DEFAULT_STATE && pageIndex % 2 === 1)) {
        menuDataOption.placement = folderMenuIsShowBottom ? Placement.BottomRight : Placement.TopRight;
      }
    }
  }

  private getFolderMenuAnimateEndScale(item: GridLayoutItemInfo): number {
    return (!CheckEmptyUtils.isEmptyArr(item.area) && GridLayoutUtil.getCountPerRowInFolder(item.area) === ItemsCount
      .SIZE_4.valueOf()) ? StyleConstants.MENU_BIG_FOLDER_4_2_TO : StyleConstants.MENU_BIG_FOLDER_TO;
  }

  private getFolderMenuAnimateStartScale(item: GridLayoutItemInfo): number {
    return (!CheckEmptyUtils.isEmptyArr(item.area) && GridLayoutUtil.getCountPerRowInFolder(item.area) === ItemsCount
      .SIZE_4.valueOf()) ? StyleConstants.MENU_BIG_FOLDER_4_2_FROM : StyleConstants.MENU_ANIMATION_FROM_DEFAULT;
  }

  public openApplication(msg: string, appItem: GridLayoutItemInfo): void {
    if (CheckEmptyUtils.isEmpty(appItem)) {
      log.showWarn(TAG, '(%{public}s), open application bundleName %{public}s fail', msg, appItem.bundleName)
      return;
    }
    log.showInfo(TAG, '(%{public}s), open application bundleName %{public}s', msg, appItem.bundleName);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_OPEN_APPLICATION, appItem);
  }

  public uninstallApplication(msg: string, appItem: GridLayoutItemInfo): void {
    if (CheckEmptyUtils.isEmpty(appItem)) {
      log.showWarn(TAG, '(%{public}s), uninstall application bundleName %{public}s fail', msg, appItem.bundleName);
      return;
    }
    log.showInfo(TAG, '(%{public}s), uninstall application bundleName %{public}s', msg, appItem.bundleName);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_UNINSTALL_APPLICATION, appItem);
  }
}

// 单例
export let eventFolderMgr: ContractedFolderEventViewModel =
  SingletonHelper.getInstance(ContractedFolderEventViewModel, TAG);