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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { RectangularCoordinates, RTLUtil, SCBVisualEffectMgr } from '@ohos/componenthelper';
import {
  FolderLayoutInOpen,
  FolderModel,
  GridLayoutItemInfo,
  GridLayoutUtil,
  folderLayoutUtil,
  EditModeUtils,
  editModeManager,
  StyleConstants,
  folderGesData,
  LayoutViewModel,
  FolderActionLifeCycleEvent,
  FolderLifeCyclePriority,
  FolderActionLifeCycleEventManager,
  FolderManager,
  ContractedFolderLayoutViewModel,
  OpenFolderStyleConfig,
  NotHarmonyUtil,
  OBSERVER_TYPE,
  SmartDockZoomFeatureSwitch,
  FolderCommonUtil,
  FolderStyleConstants,
  MultiSelectManager
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import lazy { SmartDockZoomManager }from '@ohos/launchercommon/src/main/ets/dock/common/SmartDockZoomManager';
import { AppIconData } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconData';
import {
  AppBubbleParams,
  BadgeAnimationType,
  DragHandlerType,
  DragProxyManager,
  FolderResizeUtil,
  FolderStyleManager,
  IDockDragHandler,
  PageEditViewModel,
} from '@ohos/launchercommon/Index';
import { FolderStatus } from '@ohos/launchercommon/src/main/ets/utils/FolderLayoutUtil';
import { AppNameVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppNameVm';
import { VisualEffectConstants } from '@ohos/commonconstants';
import { OpenCloseAnimationViewModel } from '../OpenCloseAnimationViewModel';
import { openFolderLayout } from '../OpenFolderLayout';
import { aniBatchUtil } from '../AnimationBatchUtil';
import { FolderType } from '../../model/AnimationParameterModel';
import {
  openFolderAppBubbleLayout
} from '@ohos/launchercommon/src/main/ets/folder/viewmdoel/OpenFolderAppBubbleLayout';
import FeatureConstants from '../../common/constants/FeatureConstants';
import { OpenCloseActionLifeCycleStatusManager } from './OpenCloseActionLifeCycleStatusManager';
import { openFolderVm } from '../OpenFolderViewModel';
import { OpenCloseAnimationUtil } from './OpenCloseAnimationUtil';
import { FolderItemBadgeChangeNotifyUtils } from '../../common/FolderItemBadgeChangeNotifyUtils';
import {
  openFolderHiddenIconLayout
} from '@ohos/launchercommon/src/main/ets/folder/viewmdoel/OpenFolderHiddenIconLayout';
import { OpenFolderAppBubbleNodeManager } from '../../view/node/OpenFolderAppBubbleNodeManager';
import {
  FolderIconParam
} from '@ohos/launchercommon/src/main/ets/folder/next/contractedfolder/viewmodel/layout/resize/FolderResizeUtil';

const TAG: string = 'OpenCloseActionManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const STACK_ICON_RATIO: number = 0.8;
// 透明度为0会导致图标下树进而影响到动效,当前先使用0.0001代替
const NEAR_OPACITY_ZERO = 0.0001;
// 没有进行文件夹展开关闭动效
const FOLDER_STATIC_TYPE: number = -1;

/**
 * 文件夹展开态动效管理类，如打开关闭文件夹动效
 */
class OpenCloseActionManager {
  private aniViewModel: OpenCloseAnimationViewModel = new OpenCloseAnimationViewModel();
  private animatingType: number = FOLDER_STATIC_TYPE;
  private isOpen: boolean = false;
  private lastOpenFolderScreenWidth: number = 0;
  private aniBatchArray: number[] = [0, 0, 1, 2, 3, 4, 5];
  private folderSenseOfOrderDisable: boolean = false;
  private mDataMgr: FolderManager = FolderManager.getInstance();
  private mUiContext?: UIContext;
  private hasDealCloseBadgeAnimate: boolean = false;

  private mOpenCloseCallback: FolderActionLifeCycleEvent = {
    description: TAG,
    priority: FolderLifeCyclePriority.LOW,
    onOpeningFolder: (folder: GridLayoutItemInfo) => {
      log.showInfo(`folder on open:${folder.folderId}, ${this.mDataMgr.getOpenFolderId()}`);
      if (this.mDataMgr.getOpenFolderId() !== folder.folderId) {
        this.mDataMgr.setOpenFolderId(folder.folderId);
      }
      this.initOpenFolderBackgroundAniParam(folder);
      this.initOpenFolderAniStartParam(folder);
      ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folder.folderId)
        .getObserverUpdator('openFolder-opacity', OBSERVER_TYPE.FOLDER_ICON).opacity(0);
      openFolderLayout.getGridSwiperLayout().isShowOpenFolder = true;
      openFolderLayout.getGridSwiperLayout().isShowIndicator = true;
      if (this.isOpen || this.animatingType == FOLDER_STATIC_TYPE) {
        // 如果当前正处于无动效状态，则等待文件夹展开态上树且显示后再开始动效
        ContractedFolderLayoutViewModel.getInstance().getDataOsrMgr(folder.folderId)
          .updateBadgeAniType(BadgeAnimationType.HIDE_WITHOUT_ANIM, 'folder opening to hide');
        return;
      }
      this.breakCurrentAnimation();
      this.openingSmallFolderWithAnimation();
      ContractedFolderLayoutViewModel.getInstance().getDataOsrMgr(folder.folderId)
        .updateBadgeAniType(BadgeAnimationType.HIDE_WITHOUT_ANIM, 'folder opening to hide');
    },
    onOpenedFolder: (folder: GridLayoutItemInfo) => {
      log.showInfo(`folder on opened:${folder.folderId}`);
      this.delAniParams(folder);
      this.animatingType = FOLDER_STATIC_TYPE;
      if (DeviceHelper.isUltraScreenProduct()) {
        this.updateOpenFolderAppNameWidth(folder);
      }
    },
    onClosingFolder: (folder: GridLayoutItemInfo) => {
      if (!openFolderLayout.getGridSwiperLayout().isShowOpenFolder) {
        ContractedFolderLayoutViewModel.getInstance().getViewOsrMgr(folder.folderId)
          .getObserverUpdator('folder-closed-opacity', OBSERVER_TYPE.FOLDER_ICON).opacity(1.0);
        return;
      }
      this.breakCurrentAnimation();
      let openFolderPageIndex: number = this.mDataMgr.getPageIndex();
      this.closingSmallFolderWithAnimation(folder, openFolderPageIndex);
      FolderItemBadgeChangeNotifyUtils.notifyOpenedFolderItemBadgeChange(folder, false);
      this.hasDealCloseBadgeAnimate = true;
    },
    onClosedFolder: (folder: GridLayoutItemInfo) => {
      log.showInfo(`folder on closed:${folder.folderId}`);
      this.breakCurrentAnimation();
      openFolderLayout.getGridSwiperLayout().isShowOpenFolder = false;
      this.animatingType = FOLDER_STATIC_TYPE;
      FolderItemBadgeChangeNotifyUtils.notifySmallFolderItemBadgeChange(folder.folderId, false);
      ContractedFolderLayoutViewModel.getInstance().getDataOsrMgr(folder.folderId)
        .updateBadgeAniType(BadgeAnimationType.CLOSE_FOLDER_COMPONENT_SHOW, 'folder closed to show');
      if (!this.hasDealCloseBadgeAnimate) {
        FolderItemBadgeChangeNotifyUtils.notifyOpenedFolderItemBadgeChange(folder, false);
      }
      this.hasDealCloseBadgeAnimate = false;
    }
  }
  private mIsGetRectById: boolean = true;

  // 设置是否使用getRectangleById获取坐标
  public isGetRectById(isGetById: boolean): void {
    this.mIsGetRectById = isGetById;
  }

  /**
   * 注册文件夹展开态的打开关闭
   */
  public registerFolderStatus(): void {
    this.folderSenseOfOrderDisable =
      SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.FOLDER_SENSE_OF_ORDER_DISABLE);
    FolderActionLifeCycleEventManager.getInstance().register(this.mOpenCloseCallback);
  }

  /**
   * 反注册文件夹展开态的打开关闭
   */
  public unregisterFolderStatus(): void {
    FolderActionLifeCycleEventManager.getInstance().unregister(this.mOpenCloseCallback);
  }

  /**
   * 当文件夹展开态在树上显示时的回调
   *
   * @param isSmallFolder 当前打开的文件夹是否是小文件夹
   */
  public onOpenFolderGridShow(isSmallFolder: boolean): void {
    log.showInfo('onOpenFolderGridShow type:%{public}d', this.animatingType);
    if (this.animatingType !== FOLDER_STATIC_TYPE) {
      // 当前如果已经在进行其他动效，则此时不开启对应的打开动效
      return;
    }
    this.openingSmallFolderWithAnimation();
  }

  /**
   * 初始化背板相关的动效参数
   *
   * @param folder 被打开文件夹的缓存数据
   */
  private initOpenFolderBackgroundAniParam(folder: GridLayoutItemInfo): void {
    let isSmall: boolean = GridLayoutUtil.isSmallFolder(folder);
    const folderStyle: FolderStyleManager = FolderStyleManager.getInstance();
    openFolderLayout.getBackgroundLayout().closedHeight =
      folderStyle.getHeightByArea(this.mDataMgr.getOpenedFolder().area ?? []);
    openFolderLayout.getBackgroundLayout().closedWidth =
      isSmall ? openFolderLayout.getBackgroundLayout().closedHeight :
      folderStyle.getWidthByArea(this.mDataMgr.getOpenedFolder().area ?? []);
    openFolderLayout.getBackgroundLayout().openedWidth = this.getBackgroundWidth();
    openFolderLayout.getBackgroundLayout().openedHeight = this.getBackgroundHeight(isSmall);
    openFolderLayout.getBackgroundLayout().openedMargin = this.getBackgroundMarginValue();
    openFolderLayout.getBackgroundLayout().radius = folderStyle.getFolderRadiusByArea(folder.area);
    // dock缩放
    if (SmartDockZoomFeatureSwitch.isSupportZoom() && folder.isInDock) {
      openFolderLayout.getBackgroundLayout().closedWidth *= SmartDockZoomManager.getDockScale();
      openFolderLayout.getBackgroundLayout().closedHeight *= SmartDockZoomManager.getDockScale();
      openFolderLayout.getBackgroundLayout().radius =
        folderStyle.getFolderRadiusByArea(folder.area) *
        SmartDockZoomManager.getDockScale();
    }

    openFolderLayout.getGridSwiperLayout().bgOpacity = 1.0;
    openFolderLayout.getGridSwiperLayout().bgHeight = openFolderLayout.getBackgroundLayout().closedHeight;
    openFolderLayout.getGridSwiperLayout().bgWidth = openFolderLayout.getBackgroundLayout().closedWidth;
    const pos: number[] = this.getFolderCenterPosition(this.mDataMgr.getOpenedFolder());
    if (pos.length > 1) {
      this.lastOpenFolderScreenWidth = AppStorage.get<number>('screenWidth') as number;
      openFolderLayout.getGridSwiperLayout().bgTranslateX =
        pos[0] - this.lastOpenFolderScreenWidth / 2;
      openFolderLayout.getGridSwiperLayout().bgTranslateY = pos[1] -
        openFolderLayout.getBackgroundLayout().closedHeight * 0.5 -
      openFolderLayout.getBackgroundLayout().openedMargin - this.getEditModeCompensateTransY();
    }
  }

  private getFolderCenterPosition(folder: GridLayoutItemInfo): number[] {
    let pos = [-1, -1];
    if (folder.isInDock) {
      const dragProxy: IDockDragHandler = DragProxyManager.getInstance()
        .get('get folder center postion from openClose folder', DragHandlerType.DOCK) as IDockDragHandler;
      pos = dragProxy?.getDockItemPositionByItem(folder);
    } else {
      pos = folderLayoutUtil.getFolderComponentCenterPosition(folder);
    }
    return pos;
  }

  private getEditModeCompensateTransY(): number {
    // 编辑模式补偿偏移
    let editModeCompensateTransY: number =
    editModeManager.isInEditMode() ? OpenFolderStyleConfig.getInstance().getCompensateTranslateYInEditMode() : 0;
    // 添加设置主屏按钮后新增的偏移
    let whiteBoxTranslateY: number = PageEditViewModel.getInstance().getWhiteBoxTranslateY();
    return editModeCompensateTransY - whiteBoxTranslateY;
  }

  /**
   * 初始化图标相关的动效参数，当前图标加载分两种情况：
   * 1.缓存节点内无缓存时，则直接向缓存管理中添加需要参与动效图标的节点参数
   * 2.缓存节点内有缓存时，则直接修改对应状态变量完成动效参数初始化
   *
   * @param folder 被打开文件夹的缓存数据
   */
  private initOpenFolderAniStartParam(folder: GridLayoutItemInfo): void {
    let array: GridLayoutItemInfo[] = this.mDataMgr.getItemsInFolder(folder);
    let pageNum: number = OpenCloseAnimationUtil.getOpenFolderAppAnimateCount();
    const maxNum: number = GridLayoutUtil.getCountPerPageInFolder(folder.area);
    let optIndex: number = aniBatchUtil.getShouldOptIndex(aniBatchUtil.getFolderType(folder.area ?? [1, 1]));

    let folderType: FolderType = aniBatchUtil.getFolderType(folder.area ?? [1, 1]);
    let folderPos = this.getFolderScreenPosition(folder);
    let iconSizeInFolder: number =
      OpenFolderAppBubbleNodeManager.getInstance().getAppBubbleCommonParams().iconSizeInFolder;
    let openFolderIconSize: number = FolderStyleManager.getInstance().getFolderStyleConfig().mOpenFolderAppSize;
    let scale: number = iconSizeInFolder / openFolderIconSize;
    let scaleStack: number = scale * STACK_ICON_RATIO;
    let editModeTranslateY = this.getEditModeTranslateY();
    const isUltraScreenProduct: boolean = DeviceHelper.isUltraScreenProduct();
    const ultraScreenGridItemWidth: number =
      isUltraScreenProduct ? OpenFolderStyleConfig.getInstance().getOpenFolderStyle().gridItemWidth : 0;
    for (let i = 0; i < array.length; i++) {
      if (i == pageNum) {
        break;
      }
      let item: GridLayoutItemInfo = array[i];
      let closeFolderAppPos: RectangularCoordinates.Point = this.getItemPosition2Parent(folder, i);
      let openFolderAppPos: RectangularCoordinates.Point =
        folderLayoutUtil.getItemPostion(FolderStatus.OPEN_FOLDER, folder, i);
      let transX: number = folderPos.x + closeFolderAppPos.x - openFolderAppPos.x;
      let transY: number = folderPos.y + closeFolderAppPos.y - openFolderAppPos.y + editModeTranslateY;
      let iconScale: number = i < maxNum - 1 ? scale : scaleStack;

      let data: AppIconData = openFolderAppBubbleLayout.getIconData(item.keyName ?? item.bundleName);
      if (!CheckEmptyUtils.checkStrIsEmpty(data.iconId)) {
        data.transX = transX;
        data.transY = transY;
        data.setIconScale(iconScale);

        // 当前展开态图标为节点缓存，图标透明度上次关闭时透明度处于未知状态，需要在打开前将透明度初始化为1
        data.setIconOpacity(1, TAG, 'initOpenFolderAniStartParam');

        // 折叠态上图标树少于展开态上每页显示的图标数时，展开态上多出的图标初始透明度为0
        if (i >= optIndex && folderType !== FolderType.TYPE_4X2_BIG_FOLDER || GridLayoutUtil.isAddIcon(item)) {
          data.setIconOpacity(NEAR_OPACITY_ZERO, TAG, 'initOpenFolderAniStartParam');
        }

        let nameData: AppNameVm =
          openFolderAppBubbleLayout.getNameData(item.keyName ?? item.bundleName);
        nameData.modifier.attribute?.opacity(0);
        if (isUltraScreenProduct) {
          nameData.modifier.attribute?.width(ultraScreenGridItemWidth);
        }
      }

      // 首次预加载组件没有初始化时，需要主动初始化一次属性.
      if (data && CheckEmptyUtils.checkStrIsEmpty(data.iconId)) {
        let params: AppBubbleParams = OpenFolderAppBubbleNodeManager.getInstance().getNodeParams(item.keyName || '');
        params.openFolderAniParams.splice(0, 4);
        params.openFolderAniParams.push(transX);
        params.openFolderAniParams.push(transY);
        params.openFolderAniParams.push(iconScale);
        params.openFolderAniParams.push(
          i >= optIndex && folderType !== FolderType.TYPE_4X2_BIG_FOLDER || GridLayoutUtil.isAddIcon(item) ? 0 : 1);
        params.openFolderIconNameOpt = 0;
        params.common = OpenFolderAppBubbleNodeManager.getInstance().getAppBubbleCommonParams();
        params.common.mFolderIconRadius = FolderStyleManager.getInstance().getFolderStyleConfig().mFolderIconRadius;
        params.item = item;
        params.index = i;
        params.pageIndex = 0;
        OpenFolderAppBubbleNodeManager.getInstance().updateNodeParams(item.keyName || '',
          params, 'updateNode in initOpenFolderAniStartParam');
      }
    }
  }

  private updateOpenFolderAppNameWidth(folder: GridLayoutItemInfo): void {
    const items: GridLayoutItemInfo[] = this.mDataMgr.getItemsInFolder(folder);
    const gridItemWidth: number = OpenFolderStyleConfig.getInstance().getOpenFolderStyle().gridItemWidth;
    items.forEach(item => {
      let nameData: AppNameVm =
        openFolderAppBubbleLayout.getNameData(item.keyName ?? item.bundleName);
      nameData.modifier.attribute?.width(gridItemWidth);
    })
  }

  private getBackgroundMarginValue(): number {
    // pad背板没有包住图标， UX定制
    if (DeviceHelper.isPad()) {
      return FolderStyleManager.getInstance().getFolderStyleConfig().mOpenFolderTittleMargin;
    }
    return FolderStyleConstants.DEFAULT_OPEN_FOLDER_BACKGROUND_MARGIN_TOP;
  }

  private getBackgroundHeight(isSmall: boolean): number {
    let openFolderData: GridLayoutItemInfo = this.mDataMgr.getOpenedFolder();
    if (openFolderData.isInDock) {
      let screenHeight: number = AppStorage.get<number>('screenHeight') as number;
      let dockHeight: number = LayoutViewModel.getInstance().getDockHeight();
      return screenHeight - this.getBackgroundMarginValue() - dockHeight +
      FolderStyleManager.getInstance().getFolderStyleConfig().mOpenFolderAppSize;
    }
    return FolderStyleConstants.FOLDER_DOWN_OPEN_BACKGROUND_HEIGHT;
  }

  private getBackgroundWidth(): number {
    return FolderStyleConstants.DEFAULT_OPEN_FOLDER_BACKGROUND_WIDTH;
  }

  private delAniParams(folder: GridLayoutItemInfo): void {
    let array: GridLayoutItemInfo[] = this.mDataMgr.getItemsInFolder(folder);
    let pageNum: number = OpenCloseAnimationUtil.getOpenFolderAppAnimateCount();
    for (let i = 0; i < array.length; i++) {
      if (i == pageNum) {
        break;
      }
      let item: GridLayoutItemInfo = array[i];
      let data: AppIconData = openFolderAppBubbleLayout.getIconData(item.keyName ?? item.bundleName);
      this.setAppCloneBadgeVisible(item, data, true);
      let params: AppBubbleParams = OpenFolderAppBubbleNodeManager.getInstance().getNodeParams(item.keyName || '');
      if (!params.item.bundleName) {
        params.common = OpenFolderAppBubbleNodeManager.getInstance().getAppBubbleCommonParams();
        params.item = item;
        params.index = i;
        params.pageIndex = 0;
      }
      params.openFolderAniParams.splice(0, 4);
      params.openFolderIconNameOpt = 1;
      OpenFolderAppBubbleNodeManager.getInstance().updateNodeParams(item.keyName || '',
        params, 'updateNode in delAniParams');
    }
  }

  private addFinishEvent(batch: number = 0): void {
    this.aniViewModel.addIconFinish(this.animatingType, true, () => {
      OpenCloseActionLifeCycleStatusManager.getInstance().opened('opened big-opened-folder when animation finished');
    }, batch);
  }

  private openFolderTitleAndBg(): void {
    // 背板分为透明度动效和缩放偏移动效
    this.aniViewModel.addBgEvent(this.animatingType, true, () => {
      openFolderLayout.getGridSwiperLayout().bgOpacity = 0;
    }, 0);
    this.aniViewModel.addBgEvent(this.animatingType, true, () => {
      this.doOpenFolderBackgroundAnimation();
    }, 1);

    this.aniViewModel.addTitleEvent(this.animatingType, true, () => {
      openFolderLayout.getGridSwiperLayout().titleOpacity = 1;
    });
  }

  private handleIconMask(data: AppIconData, bgColor: string, eventBatch: number = 0, finishBatch: number = 0) {
    data.isShowMask = true;
    data.maskBgColor = bgColor;
    data.maskOpacity = 0;
    this.aniViewModel.addIconEvent(this.animatingType, false, () => {
      data.maskOpacity = 1;
    }, eventBatch);
  }

  private getOpenItemPosition(folderItem: GridLayoutItemInfo, index: number,
    data: AppIconData, item: GridLayoutItemInfo): RectangularCoordinates.Point {
    let openFolderAppPos: RectangularCoordinates.Point | undefined;
    // 多选下的不可拖出应用不从Id拿位置
    if (this.mIsGetRectById) {
      openFolderAppPos = folderLayoutUtil.getOpenFolderItemPoint(this.mUiContext, data.iconId);
    }
    if (!openFolderAppPos) {
      openFolderAppPos = folderLayoutUtil.getItemPostion(FolderStatus.OPEN_FOLDER, folderItem, index);
    }
    return openFolderAppPos;
  }

  private getClosedItemPosition(folder: GridLayoutItemInfo, index: number, folderPos: RectangularCoordinates.Point,
    editModeTranslateY: number): RectangularCoordinates.Point {
    let closeFolderAppPos = this.getItemPosition2Parent(folder, index);
    let translateXForScreenSplit: number = AppStorage.get<number>('translateXForScreenSplit') ?? 0 as number;
    closeFolderAppPos.x = folderPos.x + closeFolderAppPos.x + translateXForScreenSplit;
    closeFolderAppPos.y = folderPos.y + closeFolderAppPos.y + editModeTranslateY;
    return closeFolderAppPos;
  }

  private getItemPosition2Parent(folder: GridLayoutItemInfo, index: number): RectangularCoordinates.Point {
    const iconParams: FolderIconParam[] = FolderResizeUtil.getGridItemParamByArea(folder.area ?? [1, 1],
      RTLUtil.isRTL());
    const realIndex: number = Math.min(index, iconParams.length - 1);
    log.showInfo(`getItemPosition2Parent, index:${realIndex}, x:${iconParams[realIndex].x},` +
      ` y:${iconParams[realIndex].y}`);
    return {
      x: iconParams[realIndex].x,
      y: iconParams[realIndex].y
    }
  }

  private handleExtrasIcon(nameData: AppNameVm, data: AppIconData, item: GridLayoutItemInfo) {
    nameData.modifier.attribute?.opacity(0);
    data.setIconOpacity(NEAR_OPACITY_ZERO, TAG, 'handleExtrasIcon');
    if (!GridLayoutUtil.isAddIcon(item)) {
      this.aniViewModel.addIconOptEvent(this.animatingType, false, () => {
        data.setIconOpacity(1, TAG, 'handleExtrasIcon');
      });
    }
  }

  private closeFolderTitleAndBg(isNeedFinish: boolean) {
    this.aniViewModel.addBgEvent(this.animatingType, false, () => {
      openFolderLayout.getGridSwiperLayout().bgOpacity = 1.0;
    }, 0);
    this.aniViewModel.addBgEvent(this.animatingType, false, () => {
      this.doCloseFolderBackgroundAnimation();
    }, 1);
    this.aniViewModel.addTitleEvent(this.animatingType, false, () => {
      openFolderLayout.getGridSwiperLayout().isShowIndicator = false;
      openFolderLayout.getGridSwiperLayout().titleOpacity = 0;
    });
    if (isNeedFinish) {
      this.aniViewModel.addBgFinish(this.animatingType, false, () => {
        OpenCloseActionLifeCycleStatusManager.getInstance().closed('closed opened-folder when animation finished');
        openFolderVm.executeCloseFolderEndCallback(FeatureConstants.OPEN_FOLDER_STATUS_TRANSITION_END);
      });
    }
  }

  private needMaskAni(item: GridLayoutItemInfo, isDraggingOutOfFolder: boolean, folderType: FolderType): boolean {
    if (GridLayoutUtil.isAddIcon(item)) {
      return false;
    }
    if (isDraggingOutOfFolder) {
      return false;
    }
    if (folderType === FolderType.TYPE_4X2_BIG_FOLDER) {
      return false;
    }
    return true;
  }

  private setAppCloneBadgeVisible(item: GridLayoutItemInfo, data: AppIconData, isVisible: boolean): void {
    if (item.appIndex && item.appIndex > 0 ||
      NotHarmonyUtil.isWaitingDownloadApp(item)) {
      data.cloneBadgeVisible = isVisible;
    }
  }

  private openingSmallFolderWithAnimation(): void {
    let openedFolder: GridLayoutItemInfo = this.mDataMgr.getOpenedFolder();
    if (!openedFolder.folderId || openedFolder.folderId == '-1') {
      log.showError('no find openedFolder data in startSmallFolderData');
      return;
    }
    this.animatingType = FolderType.TYPE_SMALL_FOLDER | FolderType.TYPE_3X4_OPEN_FOLDER;
    if (FolderModel.getInstance().getFolderLayoutInOpen() === FolderLayoutInOpen.FOLDER_OPEN_LAYOUT_4x4) {
      this.animatingType = FolderType.TYPE_SMALL_FOLDER | FolderType.TYPE_4X4_OPEN_FOLDER;
    }
    log.showInfo('start to prepare animation for opening small folder %{public}s with animation %{public}d',
      openedFolder.folderId, this.animatingType);
    this.aniViewModel.deleteFolderAnimation(this.animatingType, true);

    let pageNum: number = FolderModel.getInstance().getOpenFolderMaxPerPage();
    let array: GridLayoutItemInfo[] = this.mDataMgr.getItemsInFolder(openedFolder);
    let folderRegion: number = FolderCommonUtil.getSmallFolderRegion(openedFolder);
    let minAniBatch: number = 5;
    let maxAniBatch: number = 0;
    for (let i = 0; i < array.length; i++) {
      if (i == pageNum) {
        break;
      }
      let batch: number = this.getOpenFolderFlag(folderRegion, i, true, true);
      minAniBatch = Math.min(minAniBatch, batch);
      maxAniBatch = Math.max(maxAniBatch, batch);
    }
    log.showInfo('openingSmallFolder minAniBatch = %{public}d, maxAniBatch = %{public}d', minAniBatch, maxAniBatch);

    let folderPos = this.getFolderScreenPosition(openedFolder);
    log.showInfo(`folderPos x=${folderPos.x}, y=${folderPos.y}`);
    let optIndex: number = aniBatchUtil.getShouldOptIndex(FolderType.TYPE_SMALL_FOLDER);

    array.forEach((item: GridLayoutItemInfo, index: number) => {
      if (!item || index >= pageNum) {
        log.showError(`openingSmallFolder array.forEach error ${openedFolder?.folderId}  ${index >= pageNum}`);
        return;
      }
      let data: AppIconData = openFolderAppBubbleLayout.getIconData(item.keyName ?? item.bundleName);
      this.setAppCloneBadgeVisible(item, data, false);

      let batch: number = this.getOpenFolderFlag(folderRegion, index, true, true) - minAniBatch;
      this.aniViewModel.addIconEvent(this.animatingType, true, () => {
        data.transX = 0;
        data.transY = 0;
        data.setIconScale(1);
      }, batch);

      this.aniViewModel.addIconFinish(this.animatingType, true, () => {
        folderGesData.setOpenFolderIconTouchEnabled(true);
      }, batch);

      if (index >= optIndex || GridLayoutUtil.isAddIcon(item)) {
        this.aniViewModel.addIconOptEvent(this.animatingType, true, () => {
          data.setIconOpacity(1, TAG, 'openingSmallFolderWithAnimation');
        }, batch);
      }

      let nameData: AppNameVm = openFolderAppBubbleLayout.getNameData(item.keyName ?? item.bundleName);
      this.aniViewModel.addBottomTextEvent(this.animatingType, true, () => {
        nameData.modifier.attribute?.opacity(1);
      });
    });

    this.openFolderTitleAndBg();

    this.aniViewModel.addIconFinish(this.animatingType, true, () => {
      OpenCloseActionLifeCycleStatusManager.getInstance().opened('opened small-opened-folder when animation finished');
    }, maxAniBatch - minAniBatch);

    FolderItemBadgeChangeNotifyUtils.notifySmallFolderItemBadgeChange(openedFolder.folderId, true);
    FolderItemBadgeChangeNotifyUtils.notifyOpenedFolderItemBadgeChange(openedFolder, true);

    log.showInfo('start to run animation for opening small folder');
    openFolderLayout.getGridSwiperLayout().isInterceptEvent = true;
    this.isOpen = true;
    this.aniViewModel.startFolderAnimation(this.animatingType, true);
  }

  private closingSmallFolderWithAnimation(folderItem: GridLayoutItemInfo, openFolderPageIndex: number): void {
    this.animatingType = FolderType.TYPE_SMALL_FOLDER | FolderType.TYPE_3X4_OPEN_FOLDER;
    if (FolderModel.getInstance().getFolderLayoutInOpen() === FolderLayoutInOpen.FOLDER_OPEN_LAYOUT_4x4) {
      this.animatingType = FolderType.TYPE_SMALL_FOLDER | FolderType.TYPE_4X4_OPEN_FOLDER;
    }
    log.showInfo('start to prepare animation for closing small folder %{public}s with animation %{public}d',
      folderItem.folderId, this.animatingType);
    this.aniViewModel.deleteFolderAnimation(this.animatingType, false);
    let params: AnimatorParams = new AnimatorParams();
    let smallFolderIconSize: number =
      FolderStyleManager.getInstance().getFolderAppSize(folderItem.area, folderItem.isInDock) ?? 0;
    smallFolderIconSize = px2vp(Math.ceil(vp2px(smallFolderIconSize)));
    let openFolderIconSize: number = FolderStyleManager.getInstance().getFolderStyleConfig().mOpenFolderAppSize;
    params.scale = smallFolderIconSize / openFolderIconSize;
    params.array = this.mDataMgr.getItemsInFolder(folderItem);
    params.pageCount = FolderModel.getInstance().getOpenFolderMaxPerPage();
    params.pageNum = params.pageCount * openFolderPageIndex;
    log.showInfo('closeSmallFolderData array.length = %{public}d, pageNum = %{public}d', params.array.length,
      params.pageNum);

    params.folderRegion = FolderCommonUtil.getSmallFolderRegion(folderItem);
    params.minAniBatch = 5;
    params.maxAniBatch = 0;
    params.editModeTranslateY = this.getEditModeTranslateY();
    const iconLength = Math.min(params.pageCount, params.array.length - params.pageNum);
    this.closeFolderTitleAndBg(iconLength <= 0);
    this.closeSmallFolderIconAnimation(params, folderItem, openFolderPageIndex);
    if (iconLength > 0) {
      this.aniViewModel.addIconFinish(this.animatingType, false, () => {
        OpenCloseActionLifeCycleStatusManager.getInstance().closed('closed small folder when animation finished');
        openFolderVm.executeCloseFolderEndCallback(FeatureConstants.OPEN_FOLDER_STATUS_TRANSITION_END);
      }, params.maxAniBatch - params.minAniBatch);
    }

    // 关闭过程中为保证能通过打开文件夹进行打断，需要将展开态面板设置为事件可透传
    openFolderLayout.getGridSwiperLayout().isInterceptEvent = false;
    log.showInfo('openFolderGrid intercept event change in closeSmallFolderData');

    this.isOpen = false;
    this.aniViewModel.startFolderAnimation(this.animatingType, false);

    params.array.slice(params.pageNum, params.pageNum + params.pageCount)
      .forEach((item: GridLayoutItemInfo) => {
        let data: AppIconData = openFolderAppBubbleLayout.getIconData(item.keyName ?? item.bundleName);
        data.setIsLock(true, `${item.bundleName} join close folder animation`);
      });
  }

  private closeSmallFolderIconAnimation(params: AnimatorParams, folderItem: GridLayoutItemInfo,
    openFolderPageIndex: number) {
    for (let i = params.pageNum; i < params.array.length; i++) {
      if (i == params.pageNum + params.pageCount) {
        break;
      }
      let batch: number = this.getOpenFolderFlag(params.folderRegion, i - params.pageNum, false, true);
      params.minAniBatch = Math.min(params.minAniBatch, batch);
      params.maxAniBatch = Math.max(params.maxAniBatch, batch);
    }
    if (params.minAniBatch > params.maxAniBatch) {
      // 没有图标场景
      params.minAniBatch = 0;
      params.maxAniBatch = 0;
    }

    log.showInfo('closeSmallFolderData minAniBatch = %{public}d, maxAniBatch = %{public}d', params.minAniBatch,
      params.maxAniBatch);

    let folderPos = this.getFolderScreenPosition(folderItem);
    log.showInfo(`folderPos x=${folderPos.x}, y=${folderPos.y}`);
    let optIndex: number = aniBatchUtil.getShouldOptIndex(FolderType.TYPE_SMALL_FOLDER);

    params.array.slice(params.pageNum, params.pageNum + params.pageCount)
      .forEach((item: GridLayoutItemInfo, index: number) => {
        if (!item) {
          log.showError(`closeSmallFolderIconAnimation params.array forEach error ${folderItem?.folderId}`);
          return;
        }
        // 在关闭文件夹场景，安装中到安装完成，但新节点未创建时，短暂时间内，安装完成节点需要复用安装中节点iconData和nameData做关闭文件夹动效
        let data: AppIconData = openFolderAppBubbleLayout.getIconData(item.keyName || '', item.bundleName);
        log.showInfo(`geticonData ${item.keyName} ${data.iconId}`);
        let nameData: AppNameVm = openFolderAppBubbleLayout.getNameData(item.keyName || '', item.bundleName);
        let batch: number = this.getOpenFolderFlag(params.folderRegion, index, false, true) - params.minAniBatch;

        this.setAppCloneBadgeVisible(item, data, false);

        let closeFolderAppPos = this.getClosedItemPosition(folderItem, index, folderPos, params.editModeTranslateY);
        let openFolderAppPos = this.getOpenItemPosition(folderItem, index, data, item);
        this.aniViewModel.addIconEvent(this.animatingType, false, () => {
          data.transX = closeFolderAppPos.x - openFolderAppPos.x;
          data.transY = closeFolderAppPos.y - openFolderAppPos.y;
          data.setIconScale(params.scale);
        }, batch);

        this.aniViewModel.addIconFinish(this.animatingType, false, () => {
          folderGesData.setOpenFolderIconTouchEnabled(true);
        }, batch);

        if (index >= optIndex) {
          this.aniViewModel.addIconOptEvent(this.animatingType, false, () => {
            data.setIconOpacity(NEAR_OPACITY_ZERO, TAG, 'closeSmallFolderIconAnimation');
          }, batch);
        }

        if (GridLayoutUtil.isAddIcon(item)) {
          this.handleIconOptAni(data, nameData, batch);
        }

        this.aniViewModel.addBottomTextEvent(this.animatingType, false, () => {
          nameData.modifier.attribute?.opacity(0);
        });
      });
  }

  private handleIconOptAni(data: AppIconData, nameData: AppNameVm, batch: number = 0): void {
    this.aniViewModel.addIconOptEvent(this.animatingType, false, () => {
      data.setIconOpacity(NEAR_OPACITY_ZERO, TAG, 'handleIconOptAni');
    }, batch);
  }

  /**
   * 背板打开动效
   */
  private doOpenFolderBackgroundAnimation(): void {
    openFolderLayout.getGridSwiperLayout().bgTranslateX = 0;
    openFolderLayout.getGridSwiperLayout().bgTranslateY = 0;
    openFolderLayout.getGridSwiperLayout().bgHeight = openFolderLayout.getBackgroundLayout().openedHeight;
    openFolderLayout.getGridSwiperLayout().bgWidth = openFolderLayout.getBackgroundLayout().openedWidth;
  }

  /**
   * 背板关闭动效
   */
  private doCloseFolderBackgroundAnimation(): void {
    openFolderLayout.getGridSwiperLayout().bgHeight = openFolderLayout.getBackgroundLayout().closedHeight;
    openFolderLayout.getGridSwiperLayout().bgWidth = openFolderLayout.getBackgroundLayout().closedWidth;

    const pos: number[] = this.getFolderCenterPosition(this.mDataMgr.getOpenedFolder());
    let editModeTranslateY = this.getEditModeTranslateY(pos);
    if (pos.length > 1) {
      let translateXForScreenSplit: number = AppStorage.get<number>('translateXForScreenSplit') ?? 0 as number;
      openFolderLayout.getGridSwiperLayout().bgTranslateX = pos[0] - this.lastOpenFolderScreenWidth / 2 +
        translateXForScreenSplit;
      openFolderLayout.getGridSwiperLayout().bgTranslateY = pos[1] + editModeTranslateY -
        openFolderLayout.getBackgroundLayout().closedHeight * 0.5 - openFolderLayout.getBackgroundLayout().openedMargin;
    }
  }

  private getEditModeTranslateY(openedFolderPos?: number[]): number {
    if (!editModeManager.isInEditMode()) {
      return 0;
    }
    if (!openedFolderPos) {
      openedFolderPos = folderLayoutUtil.getFolderComponentCenterPosition(this.mDataMgr.getOpenedFolder());
    }
    let posEdit = folderLayoutUtil.getCurrentFolderCenterPosition(this.mDataMgr.getOpenedFolder());
    let editModeScale = EditModeUtils.getDesktopScale();
    let screenHeight = AppStorage.get<number>('screenHeight') as number;
    let scaleHeight = (screenHeight / 2) * (1 - editModeScale);
    let offsetYInEditMode: number = OpenFolderStyleConfig.getInstance().getCompensateTranslateYInEditMode();
    editModeScale = editModeScale === 0 ? 1 : editModeScale;
    let bgTranslateY = (posEdit[1] - scaleHeight - offsetYInEditMode) / editModeScale;
    return bgTranslateY - openedFolderPos[1];
  }

  private getOpenFolderFlag(folderRegion: number, index: number, isOpen: boolean, isSmall: boolean): number {
    // 判断是否需要秩序感，若不需要则直接返回0
    if (this.folderSenseOfOrderDisable) {
      return 0;
    }
    let flag: number = aniBatchUtil.getFolderItemOrder(folderRegion, index, isSmall);
    let aniBatch: number = 0;
    if (flag) {
      aniBatch = this.aniBatchArray?.[flag];
    }
    if (isOpen) {
      return aniBatch;
    }
    if (isSmall || FolderModel.getInstance().getFolderLayoutInOpen() === FolderLayoutInOpen.FOLDER_OPEN_LAYOUT_4x4) {
      return 5 - aniBatch;
    }
    return 0;
  }

  private breakCurrentAnimation(): void {
    if (this.animatingType != FOLDER_STATIC_TYPE) {
      this.aniViewModel.breakFolderAnimation(this.animatingType, this.isOpen);
      this.aniViewModel.deleteFolderAnimation(this.animatingType, this.isOpen);
    }
  }

  private getFolderScreenPosition(folderItem: GridLayoutItemInfo): RectangularCoordinates.Point {
    if (!folderItem.isInDock) {
      const pos: number[] = GridLayoutUtil.getRealGridItemPosition(folderItem);
      return {
        x: pos[0] + FolderStyleManager.getInstance().getFolderLeft2Parent(folderItem.area),
        y: pos[1] + FolderStyleManager.getInstance().getFolderTop2Parent()
      };
    }
    const dragProxy: IDockDragHandler = DragProxyManager.getInstance()
      .get('get folder screen position from openClose folder', DragHandlerType.DOCK) as IDockDragHandler;
    return dragProxy?.getDockItemLeftTopPosition(folderItem);
  }

  public setComponentUtils(util: UIContext): void {
    this.mUiContext = util;
  }
}

/**
 * 动效参数
 */
class AnimatorParams {
  /**
   * 动效-缩放比
   */
  public scale: number = 0;
  /**
   * 动效-元素集合
   */
  public array: GridLayoutItemInfo[] = [];
  /**
   * 动效-单页显示元素的数量
   */
  public pageCount: number = 0;
  /**
   * 动效-参与动效的元素的数量
   */
  public pageNum: number = 0;
  /**
   * 动效-文件夹在桌面上的方位
   */
  public folderRegion: number = 0;
  /**
   * 动效-秩序计数
   */
  public minAniBatch: number = 0;
  /**
   * 动效-秩序计数
   */
  public maxAniBatch: number = 0;
  /**
   * 动效-编辑模式Y抽偏移
   */
  public editModeTranslateY: number = 0;
}

// 单例
export let openCloseAniMgr: OpenCloseActionManager = SingletonHelper.getInstance(OpenCloseActionManager, TAG);