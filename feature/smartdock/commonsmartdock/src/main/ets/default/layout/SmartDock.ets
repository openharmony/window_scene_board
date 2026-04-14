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
  AppItemInfo,
  CardItemInfo,
  CommonConstants,
  DeleteDockItem,
  DeviceState,
  DockContinuableInfo,
  DockItemInfo,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LayoutViewModel,
  MenuInfo,
  RecentBundleMissionInfo,
  SmartDockZoomFeatureSwitch,
  EventConstants
} from '@ohos/launchercommon';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { ReConfirmationUninstallDialog, UninstallDialog, UninstallDialogUtil } from '@ohos/launchercommon/Index';
import { CheckEmptyUtils, LogDomain, LogHelper, ObjUtil, SingleContext } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext, HiSysEventUtil, localEventManager, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { launcherStatusUtil, SCBSceneSessionManager } from '@ohos/windowscene';
import { DragConstants, SCBConstants } from '@ohos/commonconstants';
import { DropAnimationDestination, DropAnimationParam } from '@ohos/componentanimator';
import { FormManagerDialog } from '@ohos/form';
import { PageDesktopDragHandler, PageDesktopViewModel } from '@ohos/pagedesktop';
import ResidentLayout from './ResidentLayout';
import SmartDockDragHandler from '../common/SmartDockDragHandler';
import SmartDockReorderSolution from '../common/SmartDockReorderSolution';
import SmartDockViewModel from '../viewmodel/SmartDockViewModel';
import SmartDockConstants from '../common/constants/SmartDockConstants';
import ScbRecentLayout from './ScbRecentLayout';
import SmartDockModel from '../model/SmartDockModel';
import RecentDockModel from '../model/RecentDockModel';
import {
  dropAnimationManager,
  ForceType,
  GravityAnimationConfig,
  GravityAnimationManager,
} from '@ohos/componentanimator/Index';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import lazy { PcModeRecentLayout } from './PcModeRecentLayout';
import { IconType } from '@ohos/launchercommon/src/main/ets/bean/DockItemInfo';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { SwiperLoadData } from '@ohos/swiperdata';
import { SmartDockDebug } from '../debug/SmartDockDebug';
import { DockRegionLayoutModel } from '../model/DockRegionLayoutModel';
import { DomainName, TraceUtil } from '@ohos/basicutils';
import {
  DoubleClickLockScreenModel
} from '@ohos/launchercommon/src/main/ets/pagedesktop/viewmodel/DoubleClickLockScreenModel';

const TAG = 'SmartDock';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct SmartDock {
  @Prop singleContext?: SingleContext;
  device: string = AppStorage.get<string>('device') as string;
  persistentId: number = 0;
  private mSmartDockViewModel: SmartDockViewModel = SmartDockViewModel.getInstance();
  private mRecentDockModel: RecentDockModel = RecentDockModel.getInstance();
  private mSelectedItem: DockItemInfo | undefined = new DockItemInfo();
  private mSelectedDockType = 0;
  private mOverLayDragSelectItemIndex: number = 0
  private gravityAnimTimeoutId?: number;
  private clearForm?: Function;
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private smartDockDropEvent: Function = (event: DragEvent) => this.onDropEvent(event);
  @StorageLink('screenWidth') mScreenWidth: number = AppStorage.get<number>('screenWidth') as number;
  @StorageLink('recentDockList') recentDockList: Array<DockItemInfo> = [];
  @StorageLink('folderStatus') folderStatus: number = AppStorage.get<number>('folderStatus') as number;
  @StorageLink('showDock') showDock: boolean = false;
  @StorageLink('residentList') residentList: Array<DockItemInfo> = [];
  @StorageLink('recentList') recentList: Array<RecentBundleMissionInfo> = [];
  @StorageLink('overLayDragInsertItemIndex') @Watch('refreshItem') overLayDragInsertItemIndex: number = 0;
  @StorageLink('formAppInfo') formAppInfo: AppItemInfo = new AppItemInfo();
  @StorageLink('showRecentAnimState') showRecentAnimState: string = 'none';
  @StorageLink('continueDeviceInfo') continuableInfo: DockContinuableInfo = new DockContinuableInfo();
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @State onHoverItem: DockItemInfo = new DockItemInfo();
  @Consume isDesktopEnabled: boolean;

  @StorageLink('recentLayoutWidth') recentLayoutWidth: number = 0;
  @StorageLink('residentLayoutWidth') residentLayoutWidth: number = 0;
  @StorageLink('dividerWidth') dividerWidth: number = 0;
  @StorageLink('gettingSnapshotStatus') gettingSnapshotStatus: boolean = false;
  @State isFoldProductFold: boolean = launcherStatusUtil.getShowOutLauncherStatus();
  @State isPcMode: boolean = SCBSceneSessionManager.getInstance().isPcMode();

  @StorageLink('collaborationDataList') @Watch('isShowLeftRecent') collaborationDataList: Array<DockItemInfo> = [];
  @State convertDataList: Array<DockItemInfo> = [];
  @StorageLink('isPortrait') mIsPortrait: boolean = true;

  private refreshItem(): void {
    animateTo({
      duration: 300,
      curve: Curve.Sharp,
      iterations: 1,
      playMode: PlayMode.Normal,
    }, (): void => {
      this.mOverLayDragSelectItemIndex = AppStorage.get<number>('overLayDragSelectItemIndex') as number;
      if (this.mOverLayDragSelectItemIndex < this.overLayDragInsertItemIndex) {
        const selectItem = this.residentList[this.mOverLayDragSelectItemIndex];
        for (let i = this.mOverLayDragSelectItemIndex; i < this.overLayDragInsertItemIndex; i++) {
          this.residentList[i] = this.residentList[i + 1];
        }
        this.residentList[this.overLayDragInsertItemIndex] = selectItem;
      }
      if (this.mOverLayDragSelectItemIndex > this.overLayDragInsertItemIndex) {
        const selectItem = this.residentList[this.mOverLayDragSelectItemIndex];
        for (let i = this.mOverLayDragSelectItemIndex; i > this.overLayDragInsertItemIndex; i--) {
          this.residentList[i] = this.residentList[i - 1];
        }
        this.residentList[this.overLayDragInsertItemIndex] = selectItem;
      }
      AppStorage.setOrCreate('overLayDragSelectItemIndex', this.overLayDragInsertItemIndex);
      LayoutViewModel.getInstance(this.singleContext).updateResidentDockLayout(TAG.concat('_refresh'),
        this.residentList);
    })
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear start!');
    try {
      this.mSmartDockViewModel = SmartDockViewModel.getInstance(this.singleContext);
      this.mPageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
    } catch (error) {
      log.showError('aboutToAppear error%{public}d:%{public}s', error.code, error.message);
    }
    // 刷新状态栏状态
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
    this.mSmartDockViewModel.initRecentDataList(containerSessionList, TAG);
    if (this.device != CommonConstants.PAD_DEVICE_TYPE) {
      this.mSmartDockViewModel.registerAppListChangeCallback();
    }
    this.desktopContext?.eventHub.on(DragConstants.SMART_DOCK_DROP_EVENT, this.smartDockDropEvent);
    this.residentList.forEach(item =>
    SmartDockModel.getInstance(this.singleContext).getShortcutInfoFromManager(item.bundleName));
    log.showInfo(`aboutToAppear end! mScreenWidth:${this.mScreenWidth}  residentLayoutWidth:${this.residentLayoutWidth}
    dividerWidth:${this.dividerWidth} recentLayoutWidth:${this.recentLayoutWidth}`);
    if (SmartDockZoomFeatureSwitch.isSupportZoom()) {
      SmartDockDebug.getInstance().registerDebug();
    }
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear!');
    this.mDialogController = null;
    this.formManagerDialogController = undefined;
    this.desktopContext?.eventHub.off(DragConstants.SMART_DOCK_DROP_EVENT, this.smartDockDropEvent);
    if (SmartDockZoomFeatureSwitch.isSupportZoom()) {
      SmartDockDebug.getInstance().unregisterDebug();
    }
  }

  private mDialogController: CustomDialogController | null = new CustomDialogController({
    builder: UninstallDialog({
      singleContext: this.singleContext,
      cancel: () => {
        this.mDialogController?.close()
      },
      confirm: () => {
        this.uninstallDialogConfirm()
      },
      dialogName: this.device === CommonConstants.PAD_DEVICE_TYPE ?
      $r('app.string.is_delete_form', this.mSelectedItem?.appName) : $r('app.string.isUninstall', this.mSelectedItem?.appName),
    }),
    cancel: () => {
    },
    autoCancel: true,
    showInSubWindow: true,
    alignment: DialogAlignment.Center,
  });


  private uninstallDialogConfirm(): void {
    if (!this.mSelectedItem || CheckEmptyUtils.isEmpty(this.mSelectedDockType)) {
      log.showWarn('onConfirm click menu item null!');
      return;
    }
    if (UninstallDialogUtil.getIsNeedReConfirmationApp(this.mSelectedItem.bundleName)) {
      this.reConfirmationDialogController?.open();
    } else {
      this.onConfirm();
    }
  }

  /**
   * 二次卸载菜单弹框
   */
  private reConfirmationDialogController: CustomDialogController | null = new CustomDialogController({
    builder: ReConfirmationUninstallDialog({
      cancel: () => {
        this.mDialogController?.close();
      },
      confirm: () => {
        this.onConfirm();
      },
      appIndex: this.mSelectedItem?.appIndex,
      bundleName: this.mSelectedItem?.bundleName,
      moduleName: this.mSelectedItem?.moduleName,
      abilityName: this.mSelectedItem?.abilityName
    }),
    cancel: () => { log.showInfo('cancel app uninstall dialog'); },
    autoCancel: true,
    showInSubWindow: true,
    alignment: DialogAlignment.Center,
  });

  /**
   * Dialog for form manager view (pad adaptation).
   */
  formManagerDialogController: CustomDialogController | undefined = new CustomDialogController({
    builder: FormManagerDialog({
      singleContext: this.singleContext,
      cancel: (callback?: Function) => {
        // delete all form
        if (callback !== undefined) {
          this.clearForm = callback;
        } else {
          log.showError('FormManagerDialog callback error'); // 维测日志
        }
      },
      confirm: (formCardItem: CardItemInfo) => {
        // add form to desktop
        log.showInfo(`createCardToDeskTop formCardItem: ${JSON.stringify(formCardItem)}`);
        this.mPageDesktopViewModel.createCardToDeskTop(formCardItem);
        // delete other form
      },
      bundleName: this.formAppInfo.bundleName,
      appName: this.formAppInfo.appName,
      appLabelId: this.formAppInfo.applicationLabelId
    }),
    cancel: this.cancelFormDialog,
    autoCancel: false,
    customStyle: true,
    showInSubWindow: true,
    alignment: DialogAlignment.Center,
  });

  cancelFormDialog() {
    log.showInfo('cancel form dialog');
    this.clearForm?.();
  }

  onConfirm() {
    if (!this.mSelectedItem || CheckEmptyUtils.isEmpty(this.mSelectedDockType)) {
      log.showDebug('onConfirm click menu item null!');
      return;
    }
    if (this.device === CommonConstants.PAD_DEVICE_TYPE) {
      this.mSmartDockViewModel.deleteDockItem(this.mSelectedItem as DeleteDockItem, this.mSelectedDockType);
    } else {
      this.mSmartDockViewModel.uninstallApp(this.mSelectedItem.bundleName as string,
        this.mSelectedItem.isUninstallAble as boolean, this.mSelectedItem.appIndex as number);
      // 卸载主应用时，同步移除未安装的分身应用
      if (this.mSelectedItem.appIndex === 0) {
        this.mSmartDockViewModel.deleteNotInstallApp(true, this.mSelectedItem.bundleName,
          this.mSelectedItem.appIndex, false);
      }
    }
    this.mDialogController?.close();
  }

  showDialog() {
    this.mSelectedItem = this.mSmartDockViewModel.getSelectedItem();
    this.mSelectedDockType = this.mSmartDockViewModel.getSelectedDockType();
    this.mDialogController?.open();
  }

  continuableItemExistsInRecent(): boolean {
    let ret = ObjUtil.isValid(this.continuableInfo) && ObjUtil.isValid(this.continuableInfo.bundleName) &&
      ObjUtil.isValid(this.continuableInfo.sourceDeviceName);
    if (!ret) {
      return false;
    }
    if (this.residentList.find((value) => value.appIndex === 0 && value.typeId === CommonConstants.TYPE_APP &&
      value.bundleName === this.continuableInfo.bundleName)) {
      return false;
    }
    return true;
  }

  showRecentLayoutForPhone(): boolean {
    if (this.folderStatus === DeviceState.DEFAULT_STATE && (!DeviceHelper.isPad())) {
      return false;
    }
    let ret: boolean = this.recentDockList.length > 0;
    if (!ret) {
      if (this.continuableItemExistsInRecent()) {
        log.showInfo('showRecentLayoutForPhone to true because of continuable item: ' + this.continuableInfo.bundleName);
        return true;
      }
    }
    log.showInfo('showRecentLayoutForPhone: ' + ret + ', folderStatus: ' + this.folderStatus);
    return ret;
  }

  private isShowLeftRecent(): boolean {
    if (!DeviceHelper.isPad() || CheckEmptyUtils.isEmptyArr(this.collaborationDataList)) {
      return false;
    }
    let rstDataList: DockItemInfo[] = [];
    if (!SmartDockZoomFeatureSwitch.isDebugMode() && this.mIsPortrait) {
      // 如果是竖屏，暂时只有车机数据支持
      rstDataList = this.collaborationDataList.filter(
        item => {
          return item.iconType === IconType.CAR;
        });
    } else {
      rstDataList = this.collaborationDataList;
    }

    this.convertDataList = rstDataList;
    return !CheckEmptyUtils.isEmptyArr(this.convertDataList);
  }

  private startUIAbility(item: DockItemInfo) {
    let context = getContext(this) as common.UIAbilityContext;
    let want: Want = {
      bundleName: item.bundleName,
      abilityName: item.abilityName
    }
    context.startAbility(want).then(() => {
      log.showInfo('Succeed in starting Ability');
    }).catch((err: BusinessError) => {
      log.showError('Failed to starting Ability');
    })
  }

  @Builder
  SmartDock() {
    Row() {
      if (this.isShowLeftRecent()) {
      }

      ResidentLayout({
        singleContext: this.singleContext,
        mSmartDockStyleConfig: this.mSmartDockViewModel.getStyleConfig(),
        onItemClick: (event: ClickEvent, item: DockItemInfo): boolean => this.mSmartDockViewModel
          .residentOnClick(event, item),
        buildMenu: ((item: DockItemInfo): MenuInfo[] => this.mSmartDockViewModel.buildMenuInfoList(
          item, SmartDockConstants.RESIDENT_DOCK_TYPE, this.isPcMode ? undefined : this.formManagerDialogController,
          (): void => this.showDialog())),
        onDockListChangeFunc: (): void => this.mSmartDockViewModel.onDockListChange(),
        deviceType: this.device
      })

      if (this.isPcMode) {
        PcModeRecentLayout({
          singleContext: this.singleContext,
          mSmartDockStyleConfig: this.mSmartDockViewModel.getStyleConfig(),
          onItemClick: (event: ClickEvent, item: DockItemInfo): void => {
            this.mSmartDockViewModel.residentOnClick(event, item);
          },
          buildMenu: ((item: DockItemInfo): MenuInfo[] => this.mSmartDockViewModel.buildMenuInfoList(
            item, SmartDockConstants.RECENT_DOCK_TYPE, undefined, undefined)),
          deviceType: this.device
        })
      } else if (this.showRecentLayoutForPhone()) {
        ScbRecentLayout({
          recentDockList: $recentDockList,
          singleContext: this.singleContext,
          mSmartDockStyleConfig: this.mSmartDockViewModel.getStyleConfig(),
          onItemClick: (event: ClickEvent, item: DockItemInfo): void => {
            this.mRecentDockModel.recentDockOnClick(item);
          },
          buildMenu: ((item: DockItemInfo): MenuInfo[] => this.mSmartDockViewModel.buildMenuInfoList(
            item, SmartDockConstants.RECENT_DOCK_TYPE, this.formManagerDialogController,
            (): void => this.showDialog())),
          deviceType: this.device
        })
      }
    }
    .enabled(this.isDesktopEnabled)
    .height(SmartDockConstants.PERCENTAGE_100)
    .width(this.mScreenWidth)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Top)
    .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
    .onDragEnter((event: DragEvent) => {
      this.onEnterEvent(event);
    })
    .onDragMove((event: DragEvent) => {
      this.onMoveEvent(event);
    })
    .onDragLeave((event: DragEvent) => {
      this.onLeaveEvent(event);
    })
    .onDrop((event: DragEvent) => {
      this.onDropEvent(event);
    })
    .gesture(GestureGroup(GestureMode.Parallel,
      TapGesture({ count: CommonConstants.GESTURE_DOUBLE_CLICK })
        .onAction((event?: GestureEvent) => {
          DoubleClickLockScreenModel.getInstance().sendDoubleClicked(TAG, event);
        }),
    ))
  }

  private onEnterEvent(event: DragEvent): void {
    log.showWarn('onDragEnter event:[%{public}d, %{public}d]', event.getWindowX(), event.getWindowY());
    dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
    SmartDockDragHandler.getInstance(this.singleContext).onDragEnter(event.getWindowX(), event.getWindowY());
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_FALL_BOX_HIDE, 'dragEnterDock');
  }

  private onMoveEvent(event: DragEvent): void {
    log.showDebug('onDragMove event:[%{public}d, %{public}d]', event.getWindowX(), event.getWindowY());
    let rectangle = event.getPreviewRect();
    let dropX = Number(rectangle.x) + Number(rectangle.width) / 2;
    let dropY = Number(rectangle.y) + Number(rectangle.height) / 2;
    SmartDockReorderSolution.getInstance().recordV(event.getVelocityX(), event.getVelocityY());
    SmartDockDragHandler.getInstance(this.singleContext).onDragMove(dropX, dropY);
  }

  private onLeaveEvent(event: DragEvent): void {
    log.showWarn('onDragLeave event:[%{public}d, %{public}d]', event.getWindowX(), event.getWindowY());
    SmartDockDragHandler.getInstance(this.singleContext).onDragLeave(event.getWindowX(), event.getWindowY());
  }

  private onDropEvent(event: DragEvent): void {
    performanceMonitor.end(HiSysEventUtil.DRAG_ITEM_ANI);
    TraceUtil.endTrace(DomainName.HOME, HiSysEventUtil.DRAG_ITEM_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    if (!AppStorage.get<boolean>('isDrag')) {
      log.showInfo('not dragging desktop component');
      event.setResult(DragResult.DRAG_FAILED);
      return;
    }

    event.useCustomDropAnimation = true;
    if (editModeManager.isInEditMode()) {
      // 编辑模式由gridSwiper代理drop事件
      this.desktopContext?.eventHub.emit(CommonConstants.GRID_SWIPER_DELEGATE_TO_DROP, event, 'resident');
      return;
    }

    dropAnimationManager.prepareDropItem(DropAnimationDestination.DOCK);
    log.showWarn('onDrop event:[%{public}d, %{public}d]', event.getWindowX(), event.getWindowY());
    let rectangle = event.getPreviewRect();
    let dropX = Number(rectangle.x) + Number(rectangle.width) / 2;
    let dropY = Number(rectangle.y) + Number(rectangle.height) / 2;
    let dragItemInfo: GridLayoutItemInfo = AppStorage.get<GridLayoutItemInfo>('dragItemInfo') as GridLayoutItemInfo;
    let res: boolean = SmartDockDragHandler.getInstance(this.singleContext).onDragDrop(dropX, dropY);
    if (res && !this.isPcMode) {
      let fallPosition: number[] = SmartDockDragHandler.getInstance(this.singleContext).getDropAnimationPosition();
      let screenHeight: number = LayoutViewModel.getInstance(this.singleContext).getScreenHeight();
      let dockHeight: number = LayoutViewModel.getInstance(this.singleContext).getDockHeight();
      let dropToDesktop: boolean = fallPosition[1] < screenHeight - dockHeight;
      let dropAnimationParam: DropAnimationParam =
        new DropAnimationParam(GridLayoutUtil.generateUniqueKey(dragItemInfo), dropX, dropY,
          fallPosition[0], fallPosition[1]);
      dropAnimationParam.startWidth = Number(rectangle.width);
      dropAnimationParam.startHeight = Number(rectangle.height);
      // 落位到桌面失败，需要落回dock，缩放为dock大小
      if (!dropToDesktop) {
        dropAnimationParam.endWidth = DockRegionLayoutModel.getInstance().getIconSize();
        dropAnimationParam.endHeight = DockRegionLayoutModel.getInstance().getIconSize();
        dropAnimationParam.endRadius = DockRegionLayoutModel.getInstance().getIconRadius();
      }
      event.executeDropAnimation(() => {
        dropAnimationManager.startDropAnimation(
          dropToDesktop ? DropAnimationDestination.DESKTOP : DropAnimationDestination.DOCK,
          dropAnimationParam);
        PageDesktopDragHandler.getInstance().onStartDrop();
      })
      this.triggerGravityAnimation(dropAnimationParam, dragItemInfo, false);
      return;
    }
    PageDesktopDragHandler.getInstance(this.singleContext).onStartDrop();
    if (!this.isPcMode && SmartDockDragHandler.getInstance().isDockFull()) {
      const folderPos = SmartDockDragHandler.getInstance(this.singleContext).getFolderPos();
      let dropAnimationParam: DropAnimationParam =
        new DropAnimationParam(GridLayoutUtil.generateUniqueKey(dragItemInfo), dropX, dropY,
          folderPos[0], folderPos[1]);
      this.triggerGravityAnimation(dropAnimationParam, dragItemInfo, true);
    }
  }

  private triggerGravityAnimation(dropParam: DropAnimationParam | null, dragItemInfo: GridLayoutItemInfo,
    addOrCreateFolder: boolean): void {
    let forceType = addOrCreateFolder ? ForceType.GRAVITATION : ForceType.REPULSION;
    let size = dragItemInfo.area as number[];
    let swiperKey = SwiperLoadData.getInstance().getSwiperKeyByIndex(dragItemInfo.page);
    this.gravityAnimTimeoutId = setTimeout(() => {
      this.gravityAnimTimeoutId = undefined;
      if (dropParam && swiperKey !== undefined) {
        log.showInfo(`trigger gravity animation with item drop on dock but back to desktop`);
        GravityAnimationManager.getInstance()
          .run(swiperKey, dropParam.endX, dropParam.endY, forceType, size);
      }
    }, GravityAnimationConfig.getDelayOnDrop());
  }

  build() {
    if (!this.isFoldProductFold) {
      this.SmartDock();
    }
  }
}

// 应用内dock两边的空隙
@Extend(Column)
function dockBilateral(dockBilateralWidth: number) {
  .width(dockBilateralWidth)
  .height(SmartDockConstants.PERCENTAGE_100)
  .hitTestBehavior(HitTestMode.Transparent)
  .onTouch(() => {
    if (GlobalContext.getInstance().hasObject('dockHideAnimation')) {
      let dockHideAnimation = (GlobalContext.getInstance().getObject('dockHideAnimation')) as Function;
      dockHideAnimation(true);
    }
  })
}
