/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import Prompt from '@ohos.promptAction';
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  SingleBase,
  SingleContext,
  singleManager
} from '@ohos/basicutils';
import { DragBehaviorType } from '@ohos/commonconstants';
import {
  DeviceHelper,
  GlobalContext,
  localEventManager,
  ResourceManager,
  ViewManagerPolicy,
  ViewType,
  LightOutdoorConfig
} from '@ohos/frameworkwrapper';
import { DragAccessibilityUtils, RectangularCoordinates, RTLUtil } from '@ohos/componenthelper';
import { DragItemPosition } from '@ohos/componentdrag';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import {
  AppItemInfo,
  AppModel,
  AppStatus,
  Cache2RdbHelper,
  CardItemInfo,
  CommonConstants,
  DeleteItemType,
  DeliverUtil,
  DisappearLastAppData,
  DockContinuableInfo,
  DockItemInfo,
  editModeManager,
  EventConstants,
  FolderItemInfo,
  FolderModel,
  FolderReporter,
  FolderViewModel,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  layoutConfigManager,
  layoutLockUtil,
  LayoutViewModel,
  lockLayoutManager,
  NotHarmonyUtil,
  RdbStoreManager,
  RecentLayoutCacheMgr,
  ResidentLayoutCacheMgr,
  SCBHiSysEventUtil,
  ShortcutViewModel,
  FolderManager,
  ContractedFolderCommonViewModel,
  FolderCommonUtil,
  DragViewModelUtil,
  FolderDragItem,
  FolderCommonConstants,
  FolderDataRefreshType,
  FolderDropType,
  DragCoveredItem,
  COVER_FOLDER_TYPE,
  DragAppToFolderData,
  DeleteDockItem,
  SmartDockZoomFeatureSwitch,
  FormModel,
  StyleConstants
} from '@ohos/launchercommon';
import {
  CheckResult,
  ResultCode,
} from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/ShortcutViewModel';
import { SmartDockStyleMgr } from '../manager/SmartDockStyleMgr';
import { SmartDockStyleConfig } from './SmartDockStyleConfig';
import SmartDockModel from '../model/SmartDockModel';
import SmartDockConstants from './constants/SmartDockConstants';
import SmartDockReorderSolution from './SmartDockReorderSolution';
import SmartDockReorderLayout from '../layout/SmartDockReorderLayout';
import RecentDockModel from '../model/RecentDockModel';
import { BigFolderViewModel } from '@ohos/bigfolder/src/main/ets/default/viewmodel/BigFolderViewModel';
import { PageDesktopDragHandler } from '@ohos/pagedesktop/src/main/ets/default/common/PageDesktopDragHandler';
import { PageDesktopViewModel } from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/PageDesktopViewModel';
import { DragItemFromFolderStartInfo } from '@ohos/bigfolder/src/main/ets/default/common/DragItemFromFolderStartInfo';
import { BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { promptAction } from '@kit.ArkUI';
import type ctx from '@ohos.app.ability.common';
import { DockRegionLayoutModel } from '../model/DockRegionLayoutModel';
import { DockRegionType } from './enum/SmartDockEnum';
import { SmartDockZoomEvent } from '../viewmodel/SmartDockZoomEvent';
import { SmartDockDropPositionUtils } from './SmartDockDropPositionUtils';
import { DragProxyManager, DragHandlerType, IDockDragHandler } from '@ohos/launchercommon/Index';


const TAG = 'SmartDockDragHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DIVIDE_TWO = 2;
const SQUEEZE_DELAY: number = 50;
const FOLDER_DISAPPEAR_DELAY: number = 320;

/**
 * SmartDock DragHandler
 */
export default class SmartDockDragHandler extends SingleBase implements IDockDragHandler {
  public static singleName: string = 'SmartDockDragHandler';
  private static instance: SmartDockDragHandler;
  private mSmartDockModel: SmartDockModel = SmartDockModel.getInstance(this.singleContext);
  private mBigFolderViewModel: BigFolderViewModel = BigFolderViewModel.getInstance();
  private mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
  private mReorderSolution: SmartDockReorderSolution = SmartDockReorderSolution.getInstance();
  private mReorderLayout: SmartDockReorderLayout = SmartDockReorderLayout.getInstance();
  private readonly mSmartDockStyleConfig: SmartDockStyleConfig;
  private desktopContext: ctx.ServiceExtensionContext = GlobalContext.getContext();
  private squeezeIndex: number = 0;
  private squeezeTimeoutId: number = 0;
  private translateMap: Map<string, number> = new Map();
  private coveredItem: DockItemInfo = new DockItemInfo();
  private dropAnimationPosition: number[] = [];
  private recentNumChange: boolean = false;
  private emptyItemExist: boolean = false;
  private folderPos: number[] = [];

  constructor(ctx?: SingleContext) {
    super(ctx);
    this.mSmartDockStyleConfig =
      layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG, SmartDockConstants.FEATURE_NAME);
    this.mReorderLayout.setSmartDockStyleConfig(this.mSmartDockStyleConfig);
    this.mReorderSolution.setSmartDockStyleConfig(this.mSmartDockStyleConfig);
    this.mReorderSolution.setSmartDockReorderLayout(this.mReorderLayout);
  }

  static getInstance(ctx?: SingleContext): SmartDockDragHandler {
    const dragInstance: SmartDockDragHandler = singleManager.get<SmartDockDragHandler>(SmartDockDragHandler, ctx);
    if (!SmartDockDragHandler.instance || (SmartDockDragHandler.instance !== dragInstance)) {
      SmartDockDragHandler.instance = dragInstance;
      DragProxyManager.getInstance().register(DragHandlerType.DOCK, dragInstance);
    }
    return dragInstance;
  }

  /**
   * dock栏内开始拖拽
   */
  public onDragStart(): void {
    const dragItem: DockItemInfo = AppStorage.get<DockItemInfo>('dragItemInfo') as DockItemInfo;
    if (!GridLayoutUtil.isValidLayoutItem(dragItem as Object as GridLayoutItemInfo)) {
      return;
    }

    const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let index: number = residentList.findIndex((item: DockItemInfo) => item.keyName === dragItem.keyName);
    if (index >= 0) {
      // dock栏内元素起拖时直接在原始位置显示落位框
      let center: number = SmartDockStyleMgr.getInstance().getDockItemCenter(residentList.length, index);
      this.desktopContext.eventHub.emit(SmartDockConstants.DOCK_HOLDER_NOTIFY_EVENT, center, true, false);
    }
    this.mReorderLayout.initSolution(dragItem, residentList);
  }

  /**
   * 拖拽进入dock栏
   *
   * @param x 触点x坐标
   * @param y 触点y坐标
   */
  public onDragEnter(x: number, y: number): void {
    if (layoutLockUtil.isLocked('dragEnter on smartDock')) {
      return;
    }
    const dragGridItem: GridLayoutItemInfo = AppStorage.get<GridLayoutItemInfo>('dragItemInfo') as GridLayoutItemInfo;
    const dragItem: DockItemInfo = dragGridItem as Object as DockItemInfo;
    if (!GridLayoutUtil.isValidLayoutItem(dragGridItem)) {
      return;
    }
    if (!GridLayoutUtil.isIconType(dragItem.typeId) && !GridLayoutUtil.isSmallFolder(dragItem)) {
      log.showWarn('onDragEnter, only app and smallFolder can add');
      return;
    }
    if (GridLayoutUtil.isIconType(dragGridItem.typeId) && NotHarmonyUtil.isInNotHarmonyFolder(dragGridItem)) {
      log.showWarn('app drag from custom folder can not enter');
      return;
    }

    // 补齐dragItem缺失属性
    dragItem.itemType = dragItem.typeId;
    if (dragItem.typeId === CommonConstants.TYPE_FOLDER) {
      log.showInfo(`onDragEnter dragFolder length ${dragItem.layoutInfo?.flat().length}`);
      dragItem.appId = dragItem.keyName;
      dragItem.appName = dragGridItem.folderName ?? '';
    }

    const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    this.mReorderLayout.initSolution(dragItem, residentList);
  }

  /**
   * 拖拽离开dock栏
   *
   * @param x 触点x坐标
   * @param y 触点y坐标
   */
  public onDragLeave(x: number, y: number): void {
    if (layoutLockUtil.isLocked('dragLeave on smartDock')) {
      return;
    }
    const dragItem: DockItemInfo = AppStorage.get<DockItemInfo>('dragItemInfo') as DockItemInfo;
    if (!GridLayoutUtil.isValidLayoutItem(dragItem as Object as GridLayoutItemInfo)) {
      return;
    }
    if (!GridLayoutUtil.isIconType(dragItem.typeId) && !GridLayoutUtil.isSmallFolder(dragItem)) {
      log.showWarn('onDragLeave, only app and smallFolder can add');
      return;
    }

    this.resetSqueezeTimeout();
    this.clearLastCoveredItemAnimation();
    this.mReorderLayout.delItem(dragItem);
    this.translateMap.clear();
    this.desktopContext.eventHub.emit(SmartDockConstants.DOCK_HOLDER_NOTIFY_EVENT, 0, false, true);
    DragAccessibilityUtils.resetIndex();
  }

  /**
   * dock栏内拖拽移动
   *
   * @param x 跟手图中心点x坐标
   * @param y 跟手图中心点y坐标
   */
  public onDragMove(x: number, y: number): void {
    if (lockLayoutManager.isLockLayout()) {
      log.showInfo(`layout is locked, can not squeeze`);
      return;
    }
    
    if (layoutLockUtil.isLocked()) {
      return;
    }
    if (LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      return;
    }
    const dragItem: DockItemInfo = AppStorage.get<DockItemInfo>('dragItemInfo') as DockItemInfo;
    const dragGridItem: GridLayoutItemInfo = AppStorage.get<GridLayoutItemInfo>('dragItemInfo') as GridLayoutItemInfo;
    if (!GridLayoutUtil.isValidLayoutItem(dragItem as Object as GridLayoutItemInfo)) {
      return;
    }
    if (!GridLayoutUtil.isIconType(dragItem.typeId) && !GridLayoutUtil.isSmallFolder(dragItem)) {
      return;
    }
    if (GridLayoutUtil.isIconType(dragGridItem.typeId) && NotHarmonyUtil.isInNotHarmonyFolder(dragGridItem)) {
      return;
    }

    let targetIndex: number = this.mReorderSolution.findNearestArea(x, y);
    let targetItem: DockItemInfo | undefined = this.mReorderLayout.getItem(targetIndex);
    let dragIndex: number = this.mReorderLayout.getItemIndex(dragItem);
    // 桌面及文件夹内起拖元素首次进入dock栏时，如果dock栏未满则直接触发挤位
    if (dragIndex < 0 && this.mReorderLayout.getSolution().length < this.mSmartDockStyleConfig.mMaxDockNum) {
      this.setSqueezeTimeout(x, y, targetIndex, dragItem, true);
      return;
    }

    if (targetItem && this.mReorderSolution.isCanCover(x, y, targetIndex, dragItem)) {
      // 触发合并
      if (targetItem.keyName === this.coveredItem.keyName) {
        return;
      }
      this.resetSqueezeTimeout();
      this.coveredItemAnimation(dragItem, targetItem);
    } else {
      // 触发挤位
      if (targetIndex === this.squeezeIndex) {
        this.clearLastCoveredItemAnimation();
        return;
      }
      if (SCBSceneSessionManager.getInstance().isPcMode() && targetIndex === 0) {
        return;
      }

      this.setSqueezeTimeout(x, y, targetIndex, dragItem, false);
    }
  }

  /**
   * 触发元素覆盖动效
   *
   * @param dragItem 拖拽元素
   * @param coveredItem 覆盖元素
   */
  private coveredItemAnimation(dragItem: DockItemInfo, coveredItem: DockItemInfo): void {
    this.clearLastCoveredItemAnimation();
    if (dragItem.keyName === coveredItem.keyName) {
      return;
    }

    this.desktopContext.eventHub.emit(`coveredApp${coveredItem.keyName}`, true);
    this.desktopContext.eventHub.emit(SmartDockConstants.DOCK_HOLDER_NOTIFY_EVENT, 0, false, true);
    log.showWarn('coveredItemAnimation enter: %{public}s', coveredItem.keyName);
    this.coveredItem = coveredItem;

    // 无障碍播报：覆盖应用或者文件夹
    let coveredName: string = this.getAppName(coveredItem);
    if (coveredItem.typeId === CommonConstants.TYPE_APP) {
      DragAccessibilityUtils.textAnnouncedForMoveToMerge(coveredName);
    }
    if (coveredItem.typeId === CommonConstants.TYPE_FOLDER) {
      let realFolderName: string = FolderCommonUtil.getRealFolderName(coveredName);
      DragAccessibilityUtils.textAnnouncedForMoveToFolder(realFolderName);
      ContractedFolderCommonViewModel.getInstance().dragCover('dockFolder coverAnimate', coveredItem.keyName, true);
    }
  }

  /**
   * 清空元素覆盖动效
   */
  private clearLastCoveredItemAnimation(): void {
    if (!this.coveredItem.keyName) {
      return;
    }
    if (this.coveredItem.typeId === CommonConstants.TYPE_FOLDER) {
      ContractedFolderCommonViewModel.getInstance().dragCover('clear dockFolder coverAnimate',
        this.coveredItem.keyName, false);
    } else {
      this.desktopContext.eventHub.emit(`coveredApp${this.coveredItem.keyName}`, false);
    }
    log.showWarn('clearLastCoveredItemAnimation enter: %{public}s', this.coveredItem.keyName);
    this.coveredItem = new DockItemInfo();
  }

  /**
   * 设置挤位定时器
   *
   * @param x 跟手图中心点x坐标
   * @param y 跟手图中心点y坐标
   * @param index 目标索引
   * @param dragItem 拖拽元素
   * @param immediate 是否立刻响应
   */
  private setSqueezeTimeout(x: number, y: number, index: number, dragItem: DockItemInfo, immediate: boolean): void {
    log.showInfo('squeeze timer start');
    const delay: number = immediate ? 0 : SQUEEZE_DELAY;
    this.resetSqueezeTimeout();
    this.clearLastCoveredItemAnimation();
    this.squeezeIndex = index;
    this.squeezeTimeoutId = setTimeout(() => {
      const isDrag: boolean = AppStorage.get<boolean>('isDrag') as boolean;
      if (!isDrag) {
        log.showWarn('no need to squeeze, isDrag: %{public}s', isDrag);
        return;
      }
      let res: boolean = this.mReorderSolution.getReorderSolution(x, y, index, dragItem);
      if (res) {
        // 挤位成功时显示落位框，因插入方向挤位后实际位置可能与index不一致，需重新获取
        let length: number = this.mReorderLayout.getSolution().length;
        let itemIndex: number = this.mReorderLayout.getItemIndex(dragItem);
        let center: number = SmartDockStyleMgr.getInstance().getDockItemCenter(length, itemIndex);
        this.desktopContext.eventHub.emit(SmartDockConstants.DOCK_HOLDER_NOTIFY_EVENT, center, true, false);

        // 无障碍播报：dock元素移动
        DragAccessibilityUtils.textAnnouncedForDragMoveToDock(itemIndex + 1, itemIndex + 1);
      }
      this.squeezeTimeoutId = CommonConstants.INVALID_VALUE;
    }, delay);
  }

  /**
   * 清空挤位定时器
   */
  private resetSqueezeTimeout(): void {
    if (this.squeezeTimeoutId !== CommonConstants.INVALID_VALUE) {
      log.showInfo('squeeze timer clear');
      clearTimeout(this.squeezeTimeoutId);
      this.squeezeIndex = CommonConstants.INVALID_VALUE;
      this.squeezeTimeoutId = CommonConstants.INVALID_VALUE;
    }
  }

  /**
   * 判断是否可落位
   *
   * @param dragGridItem 拖拽元素信息
   * @returns 是否可以落位
   */
  private isValidDrop(dragGridItem: GridLayoutItemInfo): boolean {
    // 锁定布局时不能落位至dock区域
    if (lockLayoutManager.isLockLayout()) {
      lockLayoutManager.toastLockedLayout();
      return false;
    }
    if (!GridLayoutUtil.isValidLayoutItem(dragGridItem)) {
      return false;
    }
    if (GridLayoutUtil.isIconType(dragGridItem.typeId) && NotHarmonyUtil.isInNotHarmonyFolder(dragGridItem)) {
      return false;
    }
    return true;
  }

  /**
   * dock栏内拖拽落位
   *
   * @param x 跟手图中心点x坐标
   * @param y 跟手图中心点y坐标
   * @returns 是否需要落位动效
   */
  public onDragDrop(x: number, y: number): boolean {
    const dragGridItem: GridLayoutItemInfo = AppStorage.get<GridLayoutItemInfo>('dragItemInfo') as GridLayoutItemInfo;
    const dragItem: DockItemInfo = dragGridItem as Object as DockItemInfo;

    const dragItemType: number = AppStorage.get<number>('dragItemType') as number;
    // 快捷方式图标写库
    ShortcutViewModel.getInstance().updateShortcutIcon(dragGridItem);
    if (!this.isValidDrop(dragGridItem)) {
      return false;
    }

    this.resetSqueezeTimeout();
    this.clearLastCoveredItemAnimation();
    this.setDropAnimationInfo(dragItem, dragItemType);
    this.recordDragStartPage(dragGridItem, dragItemType);

    if (layoutLockUtil.isLocked('drop on smartDock') &&
      (dragItemType === CommonConstants.DRAG_FROM_DOCK || dragItemType === CommonConstants.DRAG_FROM_DESKTOP)) {
      // 锁定布局时，桌面和dock起拖的元素需要落位动效
      return true;
    }

    if (!GridLayoutUtil.isIconType(dragItem.typeId) && !GridLayoutUtil.isSmallFolder(dragItem)) {
      return this.handleInvalidDrop(dragItem, dragItemType, x, y);
    }

    if (dragItemType === CommonConstants.DRAG_FROM_SHORTCUT &&
      !ShortcutViewModel.getInstance().canAddShortcutByDrag(dragGridItem)) {
      this.handleInvalidAdd(dragItem);
      return false;
    }

    let targetIndex: number = this.mReorderSolution.findNearestArea(x, y);
    let targetItem: DockItemInfo | undefined = this.mReorderLayout.getItem(targetIndex);
    let dragIndex: number = this.mReorderLayout.getItemIndex(dragItem);
    // 云端2 dock区域不支持挤位，形成文件夹
    if (LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      return true;
    }
    // 合成文件夹或者添加进文件夹
    if (this.mReorderSolution.isCanCover(x, y, targetIndex, dragItem)) {
      if (DeliverUtil.isdeliverApp(dragItem.intent)) {
        log.showInfo(`clear deliver app folder cache: ${dragItem.bundleName}`);
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_FOLDER_APP_PACKAGE_CHANGED, dragItem.bundleName);
      }
      if (targetItem && !FolderViewModel.isLayoutFull(targetItem.layoutInfo)) {
        this.addToOrCreateFolder(dragItem, targetItem, x, y);
        return false;
      } else {
        FolderViewModel.showToast(CommonConstants.RES_FOLDER_ITEMS_FULL);
      }
    }

    // 拖拽元素在当前挤位方案中
    if (dragIndex >= 0) {
      let residentList: DockItemInfo[] = this.getReorderLayoutSolution(dragItem);
      let res: boolean = RecentDockModel.getInstance(this.singleContext).deleteRecentDockItem(dragItem);
      if (SCBSceneSessionManager.getInstance().isPcMode()) {
        this.mSmartDockModel.deletePcModeRecentDockItem(dragItem);
      }
      let beforeRecentListRotateNum = RecentDockModel.getInstance(this.singleContext).getRecentListRotateNum();
      this.setResidentList(residentList);
      // 不涉及小文件夹时直接清空偏移量
      this.desktopContext.eventHub.emit(CommonConstants.DOCK_ITEM_SQUEEZE_CANCEL);
      this.desktopContext.eventHub.emit(SmartDockConstants.DOCK_HOLDER_NOTIFY_EVENT, 0, false, false);
      let afterRecentListRotateNum = RecentDockModel.getInstance(this.singleContext).getRecentListRotateNum();
      // pad竖屏情况下，dock栏常驻区拖入应用，导致recent区空间不足触发图标截断时，需要再次判断recent区前后长度是否一致，刷新deleteRecentItem状态
      this.recentNumChange = res || beforeRecentListRotateNum > afterRecentListRotateNum;
      this.deleteDragItem(dragGridItem, dragItemType, residentList);
      this.reportAddToDock(dragGridItem, dragItemType, targetIndex);
      this.clearSqueezeInfo();
      ShortcutViewModel.getInstance().addShortcutToBMSByDrag(dragItemType, dragGridItem);
      log.showWarn('add %{public}s to dock, index: %{public}d', dragItem.keyName, targetIndex);
      if (dragGridItem.typeId === CommonConstants.TYPE_FOLDER) {
        this.reportDragFolder(x, y, targetIndex, dragGridItem);
      }
      return true;
    }
    // 拖拽元素不在当前挤位方案中
    return this.refreshDragItem(dragItem, dragItemType);
  }

  private reportDragFolder(x: number, y: number, targetIndex: number, dragGridItem: GridLayoutItemInfo): void {
    let startPosition: DragItemPosition | undefined = AppStorage.get<DragItemPosition>('startPosition');
    let mEndPosition: DragItemPosition;
    mEndPosition = {
      page: PageDesktopDragHandler.getInstance(this.singleContext).getDragPageIndex(),
      row: 0,
      column: targetIndex,
      x: x,
      y: y
    };
    if (!startPosition) {
      return;
    }
    const startIsInDockArea: boolean = FolderCommonUtil.isInDockArea(startPosition.y);
    const endIsInDockArea: boolean = FolderCommonUtil.isInDockArea(mEndPosition.y);
    FolderReporter.getInstance()
      .reportDragFolder(dragGridItem, startPosition, mEndPosition, startIsInDockArea, endIsInDockArea);
  }

  private getReorderLayoutSolution(dragItem: DockItemInfo): DockItemInfo[] {
    let tempResidentList: DockItemInfo[] = Array.from(this.mReorderLayout.getSolution());
    if (this.isMainApp(dragItem)) { // 主应用场景，安装过程中拖拽落位，应用状态等信息会改变
      let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      let dragItemInCache =
        residentList.find((item) => this.isMainApp(item) && item.bundleName === dragItem.bundleName);
      let index =
        tempResidentList.findIndex((item) => this.isMainApp(item) && item.bundleName === dragItem.bundleName);
      if (dragItemInCache && index >= 0) { // 拖拽应用为主应用，使用缓存中最新的DockItemInfo，保持和缓存一致
        tempResidentList.splice(index, 1, dragItemInCache);
      }
    }

    return tempResidentList;
  }

  private isMainApp(item: DockItemInfo): boolean {
    return item && item.itemType === CommonConstants.TYPE_APP && item.appIndex === 0;
  }

  /**
   * 设置落位动效终点
   *
   * @param dragItem 拖拽元素
   */
  private setDropAnimationInfo(dragItem: DockItemInfo, dragType: number): void {
    const index: number = this.mReorderLayout.getItemIndex(dragItem);
    let center: number[] = [];
    if (layoutLockUtil.isLocked()) {
      const startPosition: DragItemPosition = AppStorage.get<DragItemPosition>('startPosition') as DragItemPosition;
      if (!startPosition) {
        return;
      }
      center = [startPosition.x, startPosition.y];
      if (dragType === CommonConstants.DRAG_FROM_DESKTOP || dragType === CommonConstants.DRAG_FROM_APP_ICON) {
        let screenWidth: number = AppStorage.get<number>('screenWidth') ?? 0;
        let curPage: number = PageDesktopDragHandler.getInstance(this.singleContext).getDragPageIndex();
        let startPage: number = startPosition.page;
        let screenSpan: number = GridLayoutUtil.isLargeFoldOrTrifoldExpanded() ?
          Math.floor(curPage / DIVIDE_TWO) - Math.floor(startPage / DIVIDE_TWO) : curPage - startPage;
        center[0] -= (screenSpan) * screenWidth;
      }
    } else if (index < 0) {
      // 挤位方案中无拖拽元素时，设置动效终点为拖拽元素起始位置，原始起始位置需从缓存中获取
      let cached: GridLayoutItemInfo | undefined = LaunchLayoutCacheManager.getInstance().selectGridLayoutItemByItem(
        dragItem as Object as GridLayoutItemInfo);
      if (!cached) {
        log.showWarn('unable to find %{public}s in cache', dragItem.keyName);
        return;
      }
      center = GridLayoutUtil.getIconCenterPosition(cached.row, cached.column, cached.area, cached.page);
    } else {
      const screenHeight: number = AppStorage.get('screenHeight') ?? 0;
      const dockHeight: number = AppStorage.get<number>('dockHeight') as number;
      const recentWidth: number = SmartDockStyleMgr.getInstance().getRecentLayoutWidth();
      const screenWidth: number = AppStorage.get<number>('screenWidth') ?? 0;
      log.showInfo('dropAnimation with recentWidth: %{public}d screenWidth: %{public}d', recentWidth, screenWidth);
      const length: number = this.mReorderLayout.getSolution().length;
      let centerX: number = SmartDockStyleMgr.getInstance().getDockItemCenter(length, index);
      const centerY: number = this.mReorderSolution.getDockItemCenterY(screenHeight, dockHeight);
      center = [centerX, centerY];
    }
    this.dropAnimationPosition = center;
    log.showInfo('dropAnimation with center: [%{public}d %{public}d]', center[0], center[1]);
  }

  /**
   * 记录起拖页
   */
  private recordDragStartPage(dragItem: GridLayoutItemInfo, dragType: number): void {
    if (dragType === CommonConstants.DRAG_FROM_DESKTOP || dragType === CommonConstants.DRAG_FROM_APP_ICON) {
      const startPage: Set<number> = new Set();
      startPage.add(dragItem.page ?? 0);
      Cache2RdbHelper.getInstance().setChangedPage(CommonConstants.DRAG_RDB_EVENT, startPage);
    }
  }

  /**
   * 处理无法在dock栏无法落位元素的落位
   *
   * @param dragItem 拖拽元素
   * @param dragType 拖拽类型
   * @param x 跟手图中心点x坐标
   * @param y 跟手图中心点y坐标
   * @returns 是否需要落位动效
   */
  private handleInvalidDrop(dragItem: DockItemInfo, dragType: number, x: number, y: number): boolean {
    const formTypes = [
      CommonConstants.DRAG_FROM_SWIPE_UP,
      CommonConstants.DRAG_FROM_FORM_SERVICE,
      CommonConstants.DRAG_FROM_MANAGE,
      CommonConstants.DRAG_FROM_FORM_INTELLIGENT,
      CommonConstants.DRAG_FROM_FORM_STACK,
    ];

    const formstackClosed: boolean = AppStorage.get<boolean>('dragCardOfFormstackClosed') ?? false;
    if (dragType === CommonConstants.DRAG_FROM_FORM_STACK && !formstackClosed) {
      // 卡片落位时堆叠还未收起，不处理
      log.showWarn('cannot drop when formstack not close');
      return false;
    }

    // 新增卡片直接添加至桌面
    if (formTypes.includes(dragType)) {
      AppStorage.setOrCreate('undoDragFormVisible', false);
      AppStorage.setOrCreate('isFormShowMask', false);
      if (!editModeManager.isInEditMode()) {
        ViewManagerPolicy.showView(ViewType.STATUS_BAR);
      }
      let cardItem: CardItemInfo = dragItem as Object as CardItemInfo;
      // 卡片管理快捷方式加桌上限
      if (!CheckEmptyUtils.isEmpty(cardItem.shortcutInfo)) {
        let checkResult: CheckResult = ShortcutViewModel.getInstance().checkShortcut(cardItem.shortcutInfo);
        if (checkResult.code === ResultCode.FAILED_DUPLICATE_ID) {
          Prompt.showToast({
            message: $r('app.string.add_exist_shortcut'),
            showMode: StyleConstants.DEFAULT_2
          });
          return false;
        }
      }
      // 主题卡是否达到上限
      // 卡片加桌上限
      if (FormModel.getInstance().checkIfCardExceedLimit()) {
        FormModel.getInstance().showToastWhenCardExceed();
        return false;
      }
      this.mPageDesktopViewModel.createCardWithAnimation(cardItem, dragType, x, y);
      log.showWarn('add card %{public}s to desktop', cardItem.cardId);
      return false;
    }

    return this.handleBackToDesktop(dragItem);
  }

  /**
   * 拖拽元素返回桌面时是否需要动效
   * 当拖拽元素起拖位置位于可见页面时，返回原始位置时需要动效
   *
   * @param dragItem 拖拽元素
   * @returns 是否需要动效
   */
  private handleBackToDesktop(dragItem: DockItemInfo): boolean {
    let startPage: number | undefined = dragItem.page;
    if (startPage === undefined) {
      return false;
    }
    let endPage: number = PageDesktopDragHandler.getInstance(this.singleContext).getCurrentPageIndex();
    let isFolderExpand: boolean = GridLayoutUtil.isLargeFoldOrTrifoldExpanded();
    let res: boolean = (startPage === endPage) ||
      (isFolderExpand && Math.floor(startPage / DIVIDE_TWO) === Math.floor(endPage / DIVIDE_TWO));
    log.showWarn('add %{public}s back to desktop', dragItem.keyName);
    return res;
  }

  /**
   * 处理无效添加的shortcut
   *
   * @param dragItem 拖拽元素
   */
  private handleInvalidAdd(dragItem: DockItemInfo): void {
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let index: number = residentList.findIndex((item: DockItemInfo) =>
      item.typeId === CommonConstants.TYPE_SHORTCUT_ICON && item.keyName === dragItem.keyName);
    if (index < 0) {
      this.mReorderLayout.delItem(dragItem);
    }
  }

  /**
   * 添加或创建文件夹
   *
   * @param dragItem 拖拽元素
   * @param targetItem 目标覆盖元素
   * @param x 跟手图中心点x坐标
   * @param y 跟手图中心点y坐标
   * @returns 是否添加或者创建成功
   */
  private addToOrCreateFolder(dragItem: DockItemInfo, targetItem: DockItemInfo, x: number, y: number): boolean {
    // 锁定布局时无法合成文件夹
    if (lockLayoutManager.isLockLayout()) {
      lockLayoutManager.toastLockedLayout();
      log.showWarn(`layout is locked`);
      return false;
    }
    // 拖拽非图标和快捷方式时无法合成文件夹
    if (!GridLayoutUtil.isIconType(dragItem.typeId)) {
      return false;
    }
    const dragItemType: number = AppStorage.get<number>('dragItemType') as number;
    const index: number = this.getIndex(targetItem);
    this.folderPos = this.getDockItemPosition(index);
    if (GridLayoutUtil.isIconType(targetItem.typeId)) {
      this.createFolder(dragItem, targetItem, x, y, dragItemType);
    } else {
      if (!this.canAddToFolder(targetItem)) {
        return false;
      }
      this.addToFolder(dragItem, targetItem, x, y);
    }
    const dragLeaveId: string = FolderManager.getInstance().getDragLeaveFolderId();
    if ((dragItemType === CommonConstants.DRAG_FROM_FOLDER ||
      dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK) && dragLeaveId !== targetItem.keyName) {
      const dragItemInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dragItem);
      ContractedFolderCommonViewModel.getInstance().drop('drop to folder refresh', dragLeaveId,
        FolderDropType.DROP_REFRESH_DOCK, DragViewModelUtil.getDragParams([dragItemInfo]));
    }
    ShortcutViewModel.getInstance().addShortcutToBMSByDrag(dragItemType, dragItem as Object as GridLayoutItemInfo);
    return true;
  }

  /**
   * 创建文件夹
   *
   * @param dragItem 拖拽元素
   * @param targetItem 目标覆盖元素
   * @param x 跟手图中心点x坐标
   * @param y 跟手图中心点y坐标
   * @returns 是否创建成功
   */
  private createFolder(dragItem: DockItemInfo, targetItem: DockItemInfo, x: number, y: number,
    dragItemType: number): boolean {
    let dragGridItem: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dragItem);
    let targetGridItem: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(targetItem);
    // 快捷方式图标写库
    ShortcutViewModel.getInstance().updateShortcutIcon(dragGridItem);
    const dragParam: FolderDragItem = DragViewModelUtil.getDragParams([dragGridItem], targetGridItem,
      dragItemType, x, y);
    dragParam.refreshType = FolderDataRefreshType.DOCK;
    dragParam.dragCoverItem = this.getDragCoverItem(dragItem, targetItem, x, y);
    ContractedFolderCommonViewModel.getInstance().drop('drag one app to dock', FolderCommonConstants.INVALID_FOLDER_ID,
      FolderDropType.DROP_CREATE_FOLDER, dragParam);
    const folderInfo: GridLayoutItemInfo = dragParam.getCreateFolderInfo();
    folderInfo.badgeNumber = (dragGridItem.badgeNumber ?? 0) + (targetGridItem.badgeNumber ?? 0);
    const dockFolderInfo: DockItemInfo = AppModel.getInstance().gridLayoutToDockItem(folderInfo);
    this.updateDockList(dragItem, targetItem, dockFolderInfo);
    log.showWarn('%{public}s and %{public}s create folder: %{public}s',
      dragItem.keyName, targetItem.keyName, folderInfo.keyName);
    return true;
  }

  /**
   * 添加文件夹
   *
   * @param dragItem 拖拽元素
   * @param targetItem 目标覆盖元素
   * @param x 跟手图中心点x坐标
   * @param y 跟手图中心点y坐标
   * @returns 是否添加成功
   */
  private addToFolder(dragItem: DockItemInfo, targetItem: DockItemInfo, x: number, y: number): boolean {
    let dragGridItem: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dragItem);
    // 快捷方式图标写库
    ShortcutViewModel.getInstance().updateShortcutIcon(dragGridItem);
    const dragAppToFolderData: DragAppToFolderData = {
      folderId: targetItem.keyName ?? '',
      appKeyName: dragItem.keyName ?? '',
      appPositionX: x,
      appPositionY: y,
    };
    FolderManager.getInstance().setDragAppToFolder(dragAppToFolderData);
    const dragParam: FolderDragItem = DragViewModelUtil.getDragParams([dragGridItem]);
    ContractedFolderCommonViewModel.getInstance().drop('drag to folder on smart dock', targetItem.keyName,
      FolderDropType.DROP_IN_FOLDER, dragParam);
    // 更新dock区拖拽列表方案中的元素
    const folder: GridLayoutItemInfo = FolderManager.getInstance().getFolder(targetItem.keyName).getGridInfo();
    targetItem.layoutInfo = folder.layoutInfo;
    targetItem.badgeNumber = folder.badgeNumber;
    this.reportAddToFolder(dragItem, targetItem, x, y);
    this.updateDockList(dragItem, targetItem, targetItem);
    log.showWarn('add %{public}s to folder: %{public}s size %{public}d', dragItem.keyName, folder.keyName,
      targetItem.layoutInfo?.flat().length);
    return true;
  }

  /**
   * 添加回原文件夹
   *
   * @param dragItem 拖拽元素
   * @param targetItem 目标覆盖元素
   * @param x 跟手图中心点x坐标
   * @param y 跟手图中心点y坐标
   * @returns 是否添加成功
   */
  private addBackToFolder(dragItem: DockItemInfo, targetItem: DockItemInfo, x: number, y: number): boolean {
    let solutionList: DockItemInfo[] = this.mReorderLayout.getSolution();
    let dragIndex: number = solutionList.findIndex((item: DockItemInfo) => item.keyName === dragItem.keyName);
    // 拖拽元素替换为空白应用，用于文件夹相关动效完成后执行居中靠拢动效
    if (dragIndex >= 0) {
      let temp: DockItemInfo = new DockItemInfo();
      temp.keyName = SmartDockConstants.DOCK_TEMP_ITEM_NAME;
      solutionList.splice(dragIndex, 1, temp);
      this.emptyItemExist = true;
      log.showInfo('replace dragItem: %{public}s with empty', dragItem.keyName);
    }
    const dragAppToFolderData: DragAppToFolderData = {
      folderId: targetItem.keyName ?? '',
      appKeyName: dragItem.keyName ?? '',
      appPositionX: x,
      appPositionY: y,
    };
    const dragGridItem: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dragItem);
    FolderManager.getInstance().setDragAppToFolder(dragAppToFolderData);
    const dragParam: FolderDragItem = DragViewModelUtil.getDragParams([dragGridItem]);
    ContractedFolderCommonViewModel.getInstance().drop('addBack to folder on smart dock', targetItem.keyName,
      FolderDropType.DROP_IN_FOLDER, dragParam);
    log.showWarn('add %{public}s back to folder %{public}s', dragItem.keyName, targetItem.keyName);
    return true;
  }

  /**
   * 是否可以添加到文件夹
   *
   * @param dragItem 拖拽元素
   */
  private canAddToFolder(targetItem: DockItemInfo): boolean {
    const dragItemInfo: GridLayoutItemInfo = AppStorage.get<GridLayoutItemInfo>('dragItemInfo') as GridLayoutItemInfo;
    let waitForHarmony: boolean =
      dragItemInfo.appStatus === AppStatus.WAIT_FOR_HARMONY && dragItemInfo.typeId === CommonConstants.TYPE_APP;
    if (DeliverUtil.isDisableOperationsOnFolder(targetItem.bundleName, dragItemInfo.intent) ||
      (NotHarmonyUtil.isNotHarmonyFolderById(targetItem.bundleName) && !waitForHarmony)) {
      log.showInfo('cannot drag item to flod');
      try {
        promptAction.showToast({
          message: ResourceManager.getInstance().getStringByName('can_not_add_to_flod'),
          duration: 2000,
        });
        // 非鸿蒙化文件夹-提示不支持图标移入打点
        FolderReporter.getInstance()
          .reportDragIconIntoNotHarmonyFolder(dragItemInfo, targetItem, targetItem.bundleName);
      } catch (error) {
        console.error(`showToast args error code is ${error.code}, message is ${error.message}`);
      }
      // 桌面拖拽到dock加入文件夹失败，将元素从挤位方案中删除
      const dragItemType: number = AppStorage.get<number>('dragItemType') as number;
      if (dragItemType !== CommonConstants.DRAG_FROM_DOCK) {
        this.mReorderLayout.delItem(dragItemInfo as AppItemInfo as DockItemInfo);
      }
      return false;
    }
    return true;
  }

  private updateDockList(dragItem: DockItemInfo, targetItem: DockItemInfo, folderInfo: DockItemInfo): void {
    let solutionList: DockItemInfo[] = this.mReorderLayout.getSolution();
    let residentList: DockItemInfo[] = Array.from(solutionList);
    let dragIndex: number = residentList.findIndex((item: DockItemInfo) => item.keyName === dragItem.keyName);
    let targetIndex: number = residentList.findIndex((item: DockItemInfo) => item.keyName === targetItem.keyName);
    FolderCommonUtil.updateFolderAppLocation(folderInfo.layoutInfo?.flat())

    // 目标元素替换为小文件夹
    if (targetIndex >= 0) {
      solutionList.splice(targetIndex, 1, folderInfo);
      residentList.splice(targetIndex, 1, folderInfo);
      log.showInfo('replace targetItem: %{public}s with folder: %{public}s', targetItem.keyName, folderInfo.keyName);
    }
    // 拖拽元素替换为空白应用，用于文件夹相关动效完成后执行居中靠拢动效
    if (dragIndex >= 0) {
      let temp: DockItemInfo = new DockItemInfo();
      temp.keyName = SmartDockConstants.DOCK_TEMP_ITEM_NAME;
      solutionList.splice(dragIndex, 1, temp);
      this.emptyItemExist = true;
      // 真实布局中直接删除拖拽元素
      residentList.splice(dragIndex, 1);
      log.showInfo('replace dragItem: %{public}s with empty', dragItem.keyName);
    }
    this.cleanContinueItem(dragItem);
    // 先计算元素translate，待布局刷新后，更新元素translate
    this.calculateDockItemTranslate(residentList, solutionList);
    this.setResidentList(residentList);
    this.updateDockItemTranslate(solutionList);
  }

  /**
   * dock应用拖入dock文件夹落位后 合并接续退出接续状态
   *
   * @param appInfo 拖拽元素
   *
   */
  private cleanContinueItem(appInfo: DockItemInfo): void {
    const dragItemType: number = AppStorage.get<number>('dragItemType') as number;
    if (dragItemType !== CommonConstants.DRAG_FROM_DOCK) {
      return;
    }
    let deviceInfo: DockContinuableInfo | undefined = AppStorage.get<DockContinuableInfo>('continueDeviceInfo');
    if (!deviceInfo || CheckEmptyUtils.isEmpty(deviceInfo.bundleName)) {
      return;
    }
    if (appInfo.typeId === CommonConstants.TYPE_APP && appInfo.appIndex === 0 &&
      deviceInfo.bundleName === appInfo.bundleName) {
      AppStorage.setAndRef('continueDeviceInfo', new DockContinuableInfo()).set(new DockContinuableInfo());
    }
  }

  private setResidentList(residentList: DockItemInfo[]): void {
    residentList.forEach((item: DockItemInfo, index: number) => {
      item.row = 0;
      item.column = index;
      item.container = CommonConstants.CONTAINER_SMARTDOCK;
      item.areaType = CommonConstants.TYPE_AREA_DOCK;
      const gridItem: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(item);
      Cache2RdbHelper.getInstance().addItem(CommonConstants.DRAG_RDB_EVENT, gridItem);
    });
    LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_set'), residentList);
  }

  /**
   * 形成或添加进文件夹时，dock栏图标数量会发生变化，但在文件夹动效过程中需保持其他元素相对位置，根据挤位方案计算元素translate
   *
   * @param oldList 原始布局
   * @param newList 目标布局
   */
  private calculateDockItemTranslate(oldList: DockItemInfo[], newList: DockItemInfo[]): void {
    let oldLength: number = oldList.length;
    let newLength: number = newList.length;
    oldList.forEach((oldItem: DockItemInfo, oldIndex: number) => {
      let newIndex: number = newList.findIndex((newItem: DockItemInfo) => oldItem.keyName === newItem.keyName);
      if (newIndex < 0) {
        return;
      }
      let oldCenter: number = SmartDockStyleMgr.getInstance().getDockItemCenter(oldLength, oldIndex);
      let newCenter: number = SmartDockStyleMgr.getInstance().getDockItemCenter(newLength, newIndex);
      let translate: number = newCenter - oldCenter;
      if (oldItem.keyName) {
        this.translateMap.set(oldItem.keyName, translate);
      }
    });
  }

  /**
   * 更新元素translate
   *
   * @param newList 目标布局
   */
  private updateDockItemTranslate(newList: DockItemInfo[]): void {
    let length: number = newList.length;
    newList.forEach((item: DockItemInfo, index: number) => {
      if (item.keyName === SmartDockConstants.DOCK_TEMP_ITEM_NAME) {
        return;
      }
      let newCenter: number = SmartDockStyleMgr.getInstance().getDockItemCenter(length, index);
      this.desktopContext.eventHub.emit(`${SmartDockConstants.DOCK_ITEM_SQUEEZE_START}${item.keyName}`, newCenter, true);
    });
    if (AppStorage.get<boolean>('isShowContinuableItem')) {
      let deviceInfo: DockContinuableInfo | undefined = AppStorage.get<DockContinuableInfo>('continueDeviceInfo');
      const center: number = SmartDockStyleMgr.getInstance().getDockItemCenter(length, length);
      this.desktopContext.eventHub.emit(`${SmartDockConstants.DOCK_ITEM_SQUEEZE_START}${deviceInfo?.srcBundleName}`,
        center, true);
    }
  }

  /**
   * 删除桌面或者文件夹中拖拽元素
   *
   * @param dragItem 拖拽元素
   * @param dragType 拖拽类型
   * @param residentList dock栏布局
   */
  private deleteDragItem(dragItem: GridLayoutItemInfo, dragType: number, residentList: DockItemInfo[]): void {
    if (dragType === CommonConstants.DRAG_FROM_DESKTOP || dragType === CommonConstants.DRAG_FROM_APP_ICON) {
      log.showWarn('delete %{public}s from desktop', dragItem.keyName);
      const appItem: DeleteItemType = {
        bundleName: undefined,
        keyName: dragItem.keyName,
        folderId: GridLayoutUtil.isSmallFolder(dragItem) ? dragItem.folderId : undefined,
        deleteByDockDrop: true,
        appIndex: dragItem.appIndex,
      };
      LaunchLayoutCacheManager.getInstance().deleteSameAppAndFolder(appItem, BusinessType.BUSINESS_DRAG, false);
      FolderManager.getInstance().deleteFolderCache(`delete ${dragItem.keyName} from desktop`, appItem.folderId);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
    }

    if (dragType === CommonConstants.DRAG_FROM_FOLDER) {
      log.showWarn('delete %{public}s from folder in desktop', dragItem.keyName);
      ContractedFolderCommonViewModel.getInstance().drop('drag from dock', FolderManager.getInstance()
        .getDragLeaveFolderId(), FolderDropType.DROP_REFRESH_FOLDER, DragViewModelUtil.getDragParams([dragItem]));
      // 先执行文件夹消失动效，再刷新页面
      let delay: number = this.mBigFolderViewModel.isFolderDisappearing() ? FOLDER_DISAPPEAR_DELAY : 0;
      setTimeout(() => {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
      }, delay);
    }

    if (dragType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK) {
      log.showWarn('delete %{public}s from folder in dock', dragItem.keyName);
      const dragLeaveFolderId: string = FolderManager.getInstance().getDragLeaveFolderId();
      for (let residentIndex = 0; residentIndex < residentList.length; residentIndex++) {
        let dockItem = residentList[residentIndex];
        if (dockItem.typeId === CommonConstants.TYPE_FOLDER && dockItem.keyName === dragLeaveFolderId) {
          (dragItem as Object as DeleteDockItem).isDeleteAppToUninstallFolder = false;
          this.mSmartDockModel.delDockItemInFolder(dockItem, dragItem as DeleteDockItem, residentIndex);
        }
      }
      this.handleFolderDisappear();
    }
  }

  private handleFolderDisappear(): void {
    // dock栏文件夹解散时，剩余图标需要具有和文件夹相同的偏移量，挤位方案中元素需要替换为剩余图标
    let disappearLastAppData: DisappearLastAppData | undefined = AppStorage.get('disappearLastAppData');
    if (disappearLastAppData) {
      let solution: DockItemInfo[] = this.mReorderLayout.getSolution();
      let index: number = solution.findIndex((item: DockItemInfo) => item.keyName === disappearLastAppData?.folderId);
      if (index < 0) {
        return;
      }
      let mLayoutInfo: GridLayoutItemInfo[][] | undefined = solution[index].layoutInfo;
      if (mLayoutInfo) {
        let lastItem: DockItemInfo = AppModel.getInstance().gridLayoutToDockItem(mLayoutInfo[0][0]);
        solution.splice(index, 1, lastItem);
        this.translateMap.set(lastItem.keyName ?? '', this.translateMap.get(disappearLastAppData.folderId) ?? 0);
      }
    }
  }

  /**
   * 落位失败时刷新布局
   *
   * @param dragItem 拖拽元素
   * @param dragType 拖拽类型
   * @returns 是否需要落位动效
   */
  private refreshDragItem(dragItem: DockItemInfo, dragType: number): boolean {
    if (dragType === CommonConstants.DRAG_FROM_DOCK) {
      // 当拖拽dock栏元素落位到smartdock（不包含dock栏）或者Aibar上时，落位事件会透传给dock栏
      // 如果此时dock栏落位方案中没有拖拽元素，拖拽元素会直接返回原始位置，并与其他执行过居中靠拢动效的元素重叠
      // 该场景下需要刷新dock栏元素位置，保证dock栏显示正常
      this.refreshDockItem(dragItem);
      return false;
    }

    // 无障碍播报：dock区满，落回原位
    DragAccessibilityUtils.textAnnouncedForDockIsFull();
    if (dragType === CommonConstants.DRAG_FROM_DESKTOP || dragType === CommonConstants.DRAG_FROM_APP_ICON) {
      return this.handleBackToDesktop(dragItem);
    }
    return false;
  }

  public getDragCoverItem(dragItem: DockItemInfo, targetItem: DockItemInfo, x: number, y: number): DragCoveredItem {
    // 获取挤位方案中元素位置
    let index: number = this.mReorderLayout.getItemIndex(targetItem);
    let appPosition: number[] = this.mReorderSolution.getDockItemPosition(index);
    let left: number = appPosition[0] - this.mSmartDockStyleConfig.mListItemWidth / DIVIDE_TWO;
    let top: number = appPosition[1] - this.mSmartDockStyleConfig.mListItemWidth / DIVIDE_TWO;

    let dragCoveredItem: DragCoveredItem = new DragCoveredItem();
    dragCoveredItem.isCreateSmallFolder = true;
    dragCoveredItem.coveredAppPositionX = appPosition[0];
    dragCoveredItem.coveredAppPositionY = appPosition[1];
    dragCoveredItem.dragItemInfo = dragItem;
    dragCoveredItem.coveredItemInfo = targetItem;
    dragCoveredItem.dragItemInfoX = x;
    dragCoveredItem.dragItemInfoY = y;
    dragCoveredItem.coveredItemUpperLeftPosition = [left, top];
    dragCoveredItem.folderType = COVER_FOLDER_TYPE.DOCK_FOLDER;
    return dragCoveredItem;
  }

  private reportCreateFolder(dragItem: DockItemInfo, targetItem: DockItemInfo, folderInfo: GridLayoutItemInfo,
    x: number, y: number): void {
    // 获取挤位方案中元素位置
    let index: number = this.mReorderLayout.getItemIndex(targetItem);
    let appPosition: number[] = this.mReorderSolution.getDockItemPosition(index);
    let left: number = appPosition[0] - this.mSmartDockStyleConfig.mListItemWidth / DIVIDE_TWO;
    let top: number = appPosition[1] - this.mSmartDockStyleConfig.mListItemWidth / DIVIDE_TWO;

    let dragCoveredItem: DragCoveredItem = new DragCoveredItem();
    dragCoveredItem.isCreateSmallFolder = true;
    dragCoveredItem.coveredAppPositionX = appPosition[0];
    dragCoveredItem.coveredAppPositionY = appPosition[1];
    dragCoveredItem.dragItemInfo = dragItem;
    dragCoveredItem.coveredItemInfo = targetItem;
    dragCoveredItem.folderId = folderInfo.keyName ?? '';
    dragCoveredItem.dragItemInfoX = x;
    dragCoveredItem.dragItemInfoY = y;
    dragCoveredItem.coveredItemUpperLeftPosition = [left, top];
    dragCoveredItem.folderType = -1;
    AppStorage.setOrCreate<DragCoveredItem>('DragCoveredItem', dragCoveredItem);

    // 文件夹打点：dock区创建新文件夹
    FolderReporter.getInstance().reportCreateFolder(folderInfo as Object as FolderItemInfo, true, folderInfo);
    // 无障碍播报：合并文件夹
    let dragAppName: string = this.getAppName(dragItem);
    let coveredName: string = this.getAppName(targetItem);
    let realFolderName: string = FolderCommonUtil.getRealFolderName(folderInfo.folderName);
    let itemIndex: number = folderInfo.column ?? 0 + 1;
    DragAccessibilityUtils.textAnnouncedForDropMergeToDock(dragAppName, coveredName, realFolderName, itemIndex);
  }

  private reportAddToFolder(dragItem: DockItemInfo, targetItem: DockItemInfo, x: number, y: number): void {
    // 文件夹打点：dock区小文件夹拖入应用
    FolderReporter.getInstance().reportDragIconIntoDockFolder(dragItem, targetItem);
    // 无障碍播报：应用添加到文件夹播报
    let dragAppName: string = this.getAppName(dragItem);
    let coveredName: string = this.getAppName(targetItem);
    let realFolderName: string = FolderCommonUtil.getRealFolderName(coveredName);
    DragAccessibilityUtils.textAnnouncedForDropToFolder(dragAppName, realFolderName);
  }

  private reportAddToDock(dragItem: GridLayoutItemInfo, dragType: number, index: number): void {
    if (GridLayoutUtil.isIconType(dragItem.typeId)) {
      // 拖拽行为打点
      if ((dragType === CommonConstants.DRAG_FROM_DESKTOP || dragType === CommonConstants.DRAG_FROM_APP_ICON ||
        dragType === CommonConstants.DRAG_FROM_DOCK)) {
        const page: number = CommonConstants.INVALID_VALUE;
        const row: number = 0;
        let fromPosition: string = 'screenId:' + dragItem.page + 'cellX:' + dragItem.column + 'cellY:' + dragItem.row;
        let toPosition: string = 'screenId:' + page + 'cellX:' + index + 'cellY:' + row;
        let deviceState: number | undefined = AppStorage.get<number>('folderStatus');
        let type: number = dragType === CommonConstants.DRAG_FROM_DOCK ?
        DragBehaviorType.DRAG_IN_DOCK_AREA : DragBehaviorType.DRAG_FROM_DESKTOP_TO_DOCK;
        SCBHiSysEventUtil.reportDragIconAdjustmentSequence(fromPosition, toPosition, dragItem.bundleName, deviceState,
          type, PageDesktopDragHandler.getInstance(this.singleContext).getDragBehaviorMode(),
          dragItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON);
      }
      // 文件夹打点：从文件夹中拖拽图标至dock
      if (dragType === CommonConstants.DRAG_FROM_FOLDER || dragType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK) {
        let lastOpenFolderData: GridLayoutItemInfo | undefined = AppStorage.get<GridLayoutItemInfo>('lastOpenFolderData');
        FolderReporter.getInstance().reportDragIconFromFolder(dragItem.bundleName, lastOpenFolderData);
      }
    }
    // 无障碍播报：正常落入dock区
    let dragItemName: string = dragItem.typeId === CommonConstants.TYPE_FOLDER ?
    FolderCommonUtil.getRealFolderName(dragItem.folderName) : this.getAppName(dragItem);
    DragAccessibilityUtils.textAnnouncedForDrop(index + 1, dragItemName);
  }

  /**
   * 获取dock栏落位元素动效终点
   *
   * @returns 落位位置
   */
  public getDropAnimationPosition(): number[] {
    let screenOffset: number = AppStorage.get<number>('translateXForScreenSplit') ?? 0 as number;
    let recentOffsetX: number = 0;
    let recentOffsetY: number = 0;
    const dragItem: DockItemInfo = AppStorage.get<DockItemInfo>('dragItemInfo') as DockItemInfo;
    const index: number = this.mReorderLayout.getItemIndex(dragItem);
    if (this.recentNumChange && (DeviceHelper.isPad() || GridLayoutUtil.isLargeFoldOrTrifoldExpanded())) {
      recentOffsetX =
        SmartDockDropPositionUtils.getInstance().getRecentOffsetX(index, this.mSmartDockStyleConfig) *
        (RTLUtil.isRTL() ? -1 : 1);
      recentOffsetY = SmartDockDropPositionUtils.getInstance().getRecentOffsetY(this.mSmartDockStyleConfig);
      this.recentNumChange = false;
    }
    log.showInfo('dropAnimation with screenOffset: %{public}d, recentOffsetX: %{public}d, recentOffsetY: %{public}d',
      screenOffset, recentOffsetX, recentOffsetY);
    return [this.dropAnimationPosition[0] + screenOffset + recentOffsetX,
      this.dropAnimationPosition[1] + recentOffsetY];
  }

  /**
   * 获取dock栏挤位方案中是否存在空白占位元素
   *
   * @returns 是否存在
   */
  public getEmptyItemExist(): boolean {
    return this.emptyItemExist;
  }

  /**
   * 设置dock栏元素translate
   *
   * @param key 元素标识
   * @param translate 偏移量
   */
  public setDockItemTranslate(key: string, translate: number): void {
    this.translateMap.set(key, translate);
  }

  /**
   * 获取dock栏元素translate，用于新建元素时保持挤位偏移量
   *
   * @param key 元素标识
   * @returns 该元素的translate
   */
  public getDockItemTranslate(key: string): number {
    return this.translateMap.get(key) ?? 0;
  }

  /**
   * 清除dock栏挤位信息
   */
  public clearSqueezeInfo(): void {
    if (this.emptyItemExist) {
      let temp: DockItemInfo = new DockItemInfo();
      temp.keyName = SmartDockConstants.DOCK_TEMP_ITEM_NAME;
      this.mReorderLayout.delItem(temp);
      this.emptyItemExist = false;
    }
    const isDrag: boolean = AppStorage.get<boolean>('isDrag') as boolean;
    if (isDrag) {
      log.showWarn('cannot clear solution, isDrag: %{public}s', isDrag);
      return;
    }
    this.mReorderLayout.clearSolution();
    this.translateMap.clear();
    this.resetSqueezeTimeout();
    this.clearLastCoveredItemAnimation();
  }

  /**
   * 刷新dock栏元素位置
   *
   * @param dragItem 拖拽元素
   */
  public refreshDockItem(dragItem: DockItemInfo): void {
    if (!GridLayoutUtil.isValidLayoutItem(dragItem as Object as GridLayoutItemInfo)) {
      return;
    }

    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let index: number = residentList.findIndex((item: DockItemInfo) => item.keyName === dragItem.keyName);
    if (index >= 0) {
      this.mReorderLayout.addItem(dragItem, index);
      log.showWarn('refreshItem success, key: %{public}s index: %{public}d', dragItem.keyName, index);
    } else { // 应用安装过程中，应用安装成功后keyName会更新，导致dragItem无法在residentList无法找到匹配的Item
      let updatedIndex: number =
        residentList.findIndex((item: DockItemInfo) => item.bundleName === dragItem.bundleName &&
        this.isMainApp(item) && this.isMainApp(dragItem));
      if (updatedIndex >= 0) {
        this.mReorderLayout.addItem(residentList[updatedIndex], updatedIndex);
      }
      log.showWarn(`refreshItem success, dragItem changed: ${dragItem.keyName}, index: ${updatedIndex}`);
    }
  }

  public getDockItemPosition(index: number): number[] {
    if (index < 0) {
      log.showWarn('getDockItemPosition with invalid params');
      return [-1, -1];
    }
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    const centerX: number = SmartDockStyleMgr.getInstance().getDockItemCenter(residentList.length, index);
    const screenHeight: number = AppStorage.get<number>('screenHeight') as number;
    const dockHeight: number = AppStorage.get<number>('dockHeight') as number;
    const centerY: number = this.mReorderSolution.getDockItemCenterY(screenHeight, dockHeight);
    log.showInfo('getDockItemPosition centerX: %{public}d, centerY: %{public}d', centerX, centerY);
    return [centerX, centerY];
  }

  /**
   * 获取dock文件夹中心点位置
   *
   * @param folderItem 文件夹信息
   * @returns 中心点位置
   */
  public getDockItemPositionByItem(folderItem: GridLayoutItemInfo): number[] {
    if (!folderItem) {
      log.showWarn('getDockItemPositionByItem index is error');
      return [-1, -1];
    }
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let index: number = residentList.findIndex((item: DockItemInfo) => item.keyName === folderItem.keyName);
    return this.getDockItemPosition(index);
  }

  public getDockItemLeftTopPosition(folderItem: GridLayoutItemInfo): RectangularCoordinates.Point {
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let index: number = residentList.findIndex((item: DockItemInfo) => item.keyName === folderItem.keyName);
    let centerPos = this.getDockItemPosition(index);
    let itemSize = DockRegionLayoutModel.getInstance().getIconSize();

    return {
      x: centerPos[0] - itemSize / 2,
      y: centerPos[1] - itemSize / 2
    };
  }

  /**
   * dock区域图标的索引值
   */
  private getIndex(targetItem: DockItemInfo): number {
    const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    return residentList.findIndex((item) => item.keyName === targetItem.keyName);
  }

  /**
   * 获取应用名
   * @param itemInfo 应用信息
   * @returns 应用名
   */
  private getAppName(itemInfo: DockItemInfo | GridLayoutItemInfo): string {
    let dragAppname: string = '';
    ResourceManager.getInstance().getAppNameWithCache(itemInfo.appLabelId, itemInfo.bundleName,
      itemInfo.moduleName, itemInfo.appName, (name: string) => {
        dragAppname = name;
      }, itemInfo.appIndex);
    return dragAppname;
  }

  /**
   * 拖拽落位到图标上合并文件夹/落入文件夹时，获取目标文件夹/图标位置
   *
   * @returns 中心点位置
   */
  public getFolderPos(): number[] {
    log.showInfo(`getFolderPos x: ${this.folderPos[0]} y: ${this.folderPos[1]}`);
    return this.folderPos;
  }

  /**
   * 判断dock区域图标是否已满
   *
   * @returns 是否已满
   */
  public isDockFull(): boolean {
    const maxNum: number = this.mSmartDockStyleConfig.mMaxDockNum;
    const dockNum: number = ResidentLayoutCacheMgr.getInstance().getAllDockItems().length;
    log.showWarn(`maxNum: ${maxNum} dockNum: ${dockNum}, isDockFull: ${dockNum === maxNum}`);
    return dockNum === maxNum;
  }
}