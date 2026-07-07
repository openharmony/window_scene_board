/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import type image from '@ohos.multimedia.image';
import prompt from '@ohos.promptAction';
import {
  CardItemInfo,
  CommonConstants,
  DeliverUtil,
  NotHarmonyUtil,
  DesktopDragResult,
  DeviceState,
  DragItem,
  EditModeUtils,
  EventConstants,
  Extend1Data,
  FolderLayoutCacheManager,
  FolderReporter,
  FolderViewModel,
  FormCommonUtil,
  FormHiSysEventReporter,
  FormManager,
  FormModel,
  FormStackEventIdUtil,
  GridLayoutItemInfo,
  GridLayoutUtil,
  HiEditModeEventUtils,
  LaunchLayoutCacheManager,
  layoutConfigManager,
  layoutLockUtil,
  LayoutViewModel,
  MoveCardEvent,
  MultiSelectManager,
  PadLaunchLayoutCacheManager,
  PageDesktopModel,
  SCBHiSysEventUtil,
  SettingsModel,
  ShortcutViewModel,
  StyleConstants,
  DesktopUtils,
  EditModeConstants,
  Cache2RdbHelper,
  DefaultDesktopLayoutInfo,
  ReportEmptyGridUtil,
  DockItemInfo,
  FormLayoutCacheManager,
  ResidentLayoutCacheMgr,
  GameCardInfo,
  FolderImageRegister,
  SmartDockZoomFeatureSwitch,
  FolderManager,
  ContractedFolderCommonViewModel,
  FolderCommonUtil,
  DragViewModelUtil,
  FolderCommonConstants,
  FolderDropType,
  lockLayoutManager,
  GridLayoutConfig,
  DragAppToFolderData,
  FolderDragItem,
  desktopItemDraggableManager,
} from '@ohos/launchercommon';
import {
  CheckResult,
  ResultCode,
} from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/ShortcutViewModel';
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  RectItem,
  SingleContext,
  singleManager,
  Trace
} from '@ohos/basicutils';
import {
  ResourceManager,
  ResultType,
  SceneIdentificationManager,
  SceneState,
  ViewManagerPolicy,
  ViewType,
  GlobalContext,
  HiSysEventUtil,
  localEventManager,
  DeviceHelper,
  IconResourceManager,
  LightOutdoorConfig
} from '@ohos/frameworkwrapper';
import {
  SqueezeExtraParam,
  DragGridPosition,
  BaseDragHandler,
  CellAndSpan,
  CellLayoutDragDelegate,
  DragItemPosition,
  DragEventManager,
  DragPosition,
  DragGridItem
} from '@ohos/componentdrag';
import {
  animationContinueManager,
  AnimationViewData,
} from '@ohos/componentanimator';
import {
  DragAccessibilityUtils,
  desktopUtil,
  ObjectCopyUtil,
  RTLUtil
} from '@ohos/componenthelper';
import { launcherStatusUtil } from '@ohos/windowscene';
import {
  DragConstants,
  DragBehaviorMode,
  DragBehaviorType,
  NumberConstants,
  OverflowConstants,
} from '@ohos/commonconstants';
import { scbEventExclusiveManager, EventType } from '@ohos/windowscene';
import { RectInfo } from '@ohos/basicutils';
import {
  GridOccupyStatus,
  GridOccupyStatusEnum,
  ItemConfiguration,
  DragArea
} from '@ohos/componentdrag';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import { BigFolderViewModel } from '@ohos/bigfolder/src/main/ets/default/viewmodel/BigFolderViewModel';
import { FormStackViewModel } from '@ohos/formstack/src/main/ets/viewmodel/FormStackViewModel';
import { PageDesktopViewModel } from './viewmodel/PageDesktopViewModel';
import { FormViewModel } from '@ohos/form/src/main/ets/default/viewmodel/FormViewModel';
import type ctx from '@ohos.app.ability.common';
import { FormStackStyleConstants } from '@ohos/formstack/src/main/ets/common/FormStackStyleConstants';
import lazy { FileFolderDragHandler } from '@ohos/desktopfilefolder/src/main/ets/default/manager/FileFolderDragHandler';
import { FileFolderConfig } from '@ohos/desktopfilefolder/src/main/ets/default/common/FileFolderConfig';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import { FormStackManager } from '@ohos/formstack/src/main/ets/common/FormStackManager';
import { AppStatus, BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { performanceMonitor } from '@kit.ArkUI';
import MultipleDragSettings, { MultipleDragPosition } from '@ohos/launchercommon/src/main/ets/pagedesktop/viewmodel/MultipleDragSettings';
import { PreventAddCardStackEvent } from '@ohos/launchercommon/src/main/ets/utils/FormHiSysEventReporter';
import { CardSqueezer } from './CardSqueezer';
import FeatureConstants from './constants/FeatureConstants';
import { PageInfoManager } from '@ohos/launchercommon/src/main/ets/cache/layout/PageInfoManager'
import { DragProxyManager, DragHandlerType, IDesktopDragHandler } from '@ohos/launchercommon/Index';
import { DomainName, TraceUtil } from '@ohos/basicutils';
import { LightOutdoorDesktopViewModel } from './viewmodel/LightOutdoorDesktopViewModel';
import { emitter } from '@kit.BasicServicesKit';

const TAG = 'PageDesktopDragHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const EXPONENT_OF_BASE_TWO = 2;
const NUM_HALF = 2;
const DELAY_TIME_FIFTY = 50;
const FOLD_DEVICE_DELETE_PAGE = 2;
const SWIPE_DELAY = 650;
const SCREEN_GREP_FACTOR = 0.6;
const SQUEEZE_DELAY = 350;
const ICON_SQUEEZE_DELAY = 50;
const DRAG_SAMPLE_FREQ = 60;
const N_SQUEEZE_DELAY = 150;
const N_SQUEEZE_HORIZONTAL_OFFSET = 20;
const N_SQUEEZE_VERTICAL_OFFSET = 0;
const FORM_STACK_CREATE_FACTOR = 0.6;
const HALF_OF_WIDTH_OR_WIDTH = 2;

/**
 * Desktop workspace drag and drop processing class
 */
export class PageDesktopDragHandler extends BaseDragHandler implements IDesktopDragHandler {
  public static singleName: string = 'PageDesktopDragHandler';
  private static instance: PageDesktopDragHandler;
  private readonly mPageDesktopStyleConfig: PageDesktopGridStyleConfig;
  private readonly mBigFolderViewModel: BigFolderViewModel = BigFolderViewModel.getInstance();
  private readonly mFormStackViewModel: FormStackViewModel;
  private readonly mSettingsModel: SettingsModel;
  private readonly mLayoutCacheManager: LaunchLayoutCacheManager;
  private readonly mFolderCacheManager: FolderLayoutCacheManager;
  private readonly mPageDesktopModel: PageDesktopModel;
  private readonly mPageDesktopViewModel: PageDesktopViewModel;
  private readonly mIsPrintLog: boolean = false; // log打印开关
  private mGridConfig: GridLayoutConfig | undefined;
  private mDragCreaseHeight: number;
  private mPageCoordinateData: PageCoordinateData = {
    gridXAxis: [],
    gridYAxis: []
  };
  private mWaterfallPageCoordinateData: PageCoordinateData = {
    gridXAxis: [],
    gridYAxis: []
  };
  private mStartPosition: DragItemPosition | undefined;
  private mEndPosition: DragItemPosition | undefined;
  private mLastPosition: DragItemPosition | undefined;
  private mGridItemHeight: number = 0;
  private mGridItemWidth: number = 0;
  private mPaddingLeft: number = 0;
  private mPaddingTop: number = 0;
  private dragStartItemIndex: number = -1;
  private dragEndItemIndex: number = 0;
  private currentMoveItemList: MoveItem[] = [];
  private lastMoveItemList: MoveItem[] = [];
  private lastMoveItemIndex: number = -1;
  private lastMovePageIndex: number = -1;
  private lastBoxPage: number = -1;
  private isStartToSqueeze: boolean = false;
  private isSqueezeSuccess: boolean = false; // 挤位是否成功
  private dragBehaviorMode: number = DragBehaviorMode.DRAG_BY_LONG_PRESS;
  private isFoldNearScreen: boolean = false;
  private indexInFoldExpand: number = 0;
  private lastFoldStatus: boolean | undefined = false;
  private isNearReArrangeSolutionSuccess: boolean = false;
  private isLeaveSwiperPage: boolean = false;
  private isPc: boolean = false;
  private isPhone: boolean = false;
  private isSuperFold: boolean = false;
  private hasCancelSqueezeAnimation: boolean = true;
  private isDropFileToDesktop: boolean = false;
  private isPortrait: boolean = false;
  private isExpandStatus: boolean = false;
  // 应用起拖页面 桌面元素跨页拖拽的时候会重建, 无法找到起拖的page
  private dragStartPage: Set<number> = new Set();

  // 为避免pageIndex设置不及时导致的动效异常，draghandler内部维护额外的pageIndex
  private dragPageIndex: number = 0;

  // 为避免pageIndex设置不及时导致的动效异常，draghandler内部维护额外的pageIndex
  private outerDragPageIndex: number = 0;

  // 最终落位位置
  private finallyFallPosition: number[] = [];
  // 拖动元素是否覆盖另一个元素
  private coveredIsOtherItem: boolean = false;
  // 是否已经播报靠近屏幕边缘
  private isAnnouncedForNearScreen: boolean = false;

  // 翻页定时器id
  private swipeTimeoutId: number = CommonConstants.INVALID_VALUE;

  private squeezeTimeoutId: number = CommonConstants.INVALID_VALUE;
  private squeezeIndex: number = CommonConstants.INVALID_VALUE;
  private coverItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  private coverItemCenter: number[] = [];
  private coverItemWidth: number = 0;
  private coverItemHeight: number = 0;
  private coveredItem: GridLayoutItemInfo | undefined = new GridLayoutItemInfo();
  private moveList: Set<string> = new Set();
  private cellAndSpan: CellAndSpan = new CellAndSpan(0, 0, 0, 0);
  private isSupportFolder: boolean = !DeviceHelper.isPC();
  private zSqueeze: boolean = !DeviceHelper.isPC();

  private pcMultiDragCount: number = 0;
  private multiDragItems : number[][] = [];
  // 存放多选元素原始位置和相对位置
  private multiDragItemPosMap: Map<string, number[][]> = new Map();
  private isContinue: boolean = false;
  private enoughToConDrop: boolean = false;
  private animationFunc: Function | undefined;
  private isDragPaste: boolean = false;
  private dragStartSourceType: number = SourceType.TouchScreen;
  private mFolderMgr: FolderManager;
  // 用于记录拖拽时手指移动方向，用于判定是否跟手图已移出目标图标范围
  private avgVX: number[] = [];
  private avgVY: number[] = [];
  private isJudgingIconCover: boolean = false;

   constructor(ctx?: SingleContext) {
    super(ctx);
    this.mBigFolderViewModel = BigFolderViewModel.getInstance();
    this.mFormStackViewModel = new FormStackViewModel();
    this.mSettingsModel = SettingsModel.getInstance();
    this.mLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    this.mFolderCacheManager = FolderLayoutCacheManager.getInstance();
    this.mPageDesktopModel = PageDesktopModel.getInstance();
    this.mPageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
    this.mPageDesktopStyleConfig = layoutConfigManager.getStyleConfig(PageDesktopGridStyleConfig.APP_GRID_STYLE_CONFIG,
     CommonConstants.PAGE_DESKTOP_FEATURE_NAME);
    this.mDragCreaseHeight = this.mPageDesktopStyleConfig.mPhysicalAxisAreaHeight;
    let device: string = AppStorage.get('device') as string;
    this.isPhone = (device === CommonConstants.DEFAULT_DEVICE_TYPE);
    this.isPc = DeviceHelper.isPC();
    this.isSuperFold = DeviceHelper.isSuperFoldMachine();
    this.mFolderMgr = FolderManager.getInstance();
    // 拖拽手势自愈订阅
    scbEventExclusiveManager.registerEventExclusive(EventType.DESKTOP_DRAG, this.dragEventCancel);
    log.showDebug(`pageDesktopStyleConfig: ${JSON.stringify(this.mPageDesktopStyleConfig)}`);
  }

  static getInstance(ctx?: SingleContext): PageDesktopDragHandler {
    const dragInstance: PageDesktopDragHandler = singleManager.get<PageDesktopDragHandler>(PageDesktopDragHandler, ctx);
    if (!PageDesktopDragHandler.instance || (PageDesktopDragHandler.instance !== dragInstance)) {
      PageDesktopDragHandler.instance = dragInstance;
      DragProxyManager.getInstance().register(DragHandlerType.DESKTOP, dragInstance);
    }
    return dragInstance;
  }

  private dragEventCancel = (source?: SourceType, fingerId?: number): void => {
    let isDrag = scbEventExclusiveManager.getEventExclusiveByCaller(EventType.DESKTOP_DRAG);
    log.showInfo(`in dragEventCancel, the isDrag is ${isDrag}， current touch source is ${source}, current fingerId is ${fingerId}， touch source before drag is ${this.dragStartSourceType}`);
    // 起拖后的手势自愈，仅在fingerId为0，且手势类型与起拖的手势类型一致时才触发
    if (isDrag && fingerId === 0 && source === this.dragStartSourceType) {
      scbEventExclusiveManager.setEventExclusive(EventType.DESKTOP_DRAG, false);
      AppStorage.setOrCreate('isDrag', false);
    }
  }

  /**
   * 记录起拖前最后一次触摸事件的手势类型，用于在起拖后触发手势自愈时进行判断
   *
   * @param source 手势类型
   */
  public setDragStartSourceType(source: SourceType): void {
    let isDrag = scbEventExclusiveManager.getEventExclusiveByCaller(EventType.DESKTOP_DRAG);
    // 已开始的拖拽过程中的触摸不做记录，以避免影响
    if (!isDrag) {
      this.dragStartSourceType = source;
    }
  }

  /**
   * 设置落位动效
   *
   * @param animationFunc 动效逻辑
   */
  public setAnimationFunc(animationFunc: Function): void {
    this.animationFunc = animationFunc;
  }

  /**
   * 设置翻页定时器
   *
   * @param callback 翻页逻辑
   */
  public setSwipeTimeout(callback: Function): void {
    if (this.swipeTimeoutId === CommonConstants.INVALID_VALUE) {
      log.showInfo('swipe timer start');
      this.swipeTimeoutId = setTimeout(() => {
        callback();
        this.swipeTimeoutId = CommonConstants.INVALID_VALUE;
        this.setDragBehaviorMode(DragBehaviorMode.DRAG_BY_ITEM_MOVE_PAGE);
      }, SWIPE_DELAY);
    }
  }

  /**
   * 清空翻页定时器
   */
  public clearSwipeTimeout(): void {
    if (this.swipeTimeoutId !== CommonConstants.INVALID_VALUE) {
      log.showInfo('swipe timer clear');
      clearTimeout(this.swipeTimeoutId);
      this.swipeTimeoutId = CommonConstants.INVALID_VALUE;
    }
  }

  /**
   * 获取拖拽内部维护的pageIndex
   */
  public getDragPageIndex(): number {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return this.outerDragPageIndex;
    } else {
      return this.dragPageIndex;
    }
  }

  /**
   * 获取页面拖拽落位index
   */
  public getPageDragDropIndex(): number {
    const count: number = PageInfoManager.getInstance().getDisplayCount();
    let pageIndex = this.getDragPageIndex();
    return count !== 1 ? Math.floor(pageIndex / count) * count : pageIndex;
  }

  /**
   * 设置dragHanlder内部维护的pageIndex
   * @param index 当前页面数
   */
  public setDragPageIndex(index: number, isOuter?: boolean): void {
    const isOuterDesktop: boolean = isOuter == null ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter;
    if (isOuterDesktop) {
      if (index === this.outerDragPageIndex) {
        return;
      }
      log.showInfo('dragPageIndex changed to page: %{public}d', index);
      this.outerDragPageIndex = index;
    } else {
      if (index === this.dragPageIndex) {
        return;
      }
      log.showInfo('dragPageIndex changed to page: %{public}d', index);
      this.dragPageIndex = index;
    }

    let isDrag: boolean = AppStorage.get('isDrag') as boolean;
    if (isDrag) {
      this.resetSqueezeStatus();
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)
        .eventHub.emit(DragConstants.WHITE_BOX_CHANGE_EVENT);
    }
  }

  /**
   * 更新dragHanlder内部维护的pageIndex
   * @param showNext true表示触发showNext, false表示触发showPrevious
   */
  public updateDragPageIndex(showNext: boolean): void {
    let count: number = PageInfoManager.getInstance().getDisplayCount();
    let modifyCount: number = showNext ? count : -count;
    let targetPageIndex: number = this.getDragPageIndex() + modifyCount;
    let curPageCount: number = this.mLayoutCacheManager.selectPageCount();
    if (targetPageIndex >= 0 && targetPageIndex < curPageCount) {
      this.setDragPageIndex(targetPageIndex);
    }
  }

  /**
   * 获取发生拖拽的页面对应的pageIndex
   * @returns 页面数
   */
  public getCurrentPageIndex(): number {
    let pageIndex: number = this.getDragPageIndex();
    if (this.isSuperFold) {
      return pageIndex;
    }
    return this.getRTLShowPage(pageIndex);
  }

  public setStartPosition(startPosition?: DragItemPosition): void {
    if (CheckEmptyUtils.isEmpty(startPosition)) {
      log.showError('startPosition invalid');
    }
    this.mStartPosition = startPosition;
  }

  setDragEffectArea(effectArea: DragArea): void {
    log.showDebug('setDragEffectArea, left: %{public}d, right: %{public}d, top: %{public}d, bottom: %{public}d',
      effectArea?.left, effectArea?.right, effectArea?.top, effectArea?.bottom);
    AppStorage.setOrCreate('pageDesktopDragEffectArea', effectArea);
    super.setDragEffectArea(effectArea);
    this.updateGridParam(effectArea);
  }

  public isDragEffectArea(x: number, y: number): boolean {
    if (x === undefined || x === null || y === undefined || y === null) {
      log.showError('isDragEffectArea: x or y invalid');
      return false;
    }
    const isInEffectArea = super.isDragEffectArea(x, y);
    log.showDebug(`isDragEffectArea x: ${x}, y: ${y}, isInEffectArea: ${isInEffectArea}`);
    const deviceType: string = AppStorage.get('device') ?? CommonConstants.DEFAULT_DEVICE_TYPE;
    const smartDockDragEffectArea: DragArea | undefined = AppStorage.get('smartDockDragEffectArea');
    if (smartDockDragEffectArea) {
      if (deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
        if (isInEffectArea || (y <= smartDockDragEffectArea.bottom && y >= smartDockDragEffectArea.top) &&
          x <= smartDockDragEffectArea.right && x >= smartDockDragEffectArea.left) {
          return true;
        }
        return false;
      }
      return isInEffectArea;
    }
    return false;
  }

  private getRow(index: number): number {
    return ~~(index / this.mSettingsModel.getGridConfig().column);
  }

  private getColumn(index: number): number {
    return index % this.mSettingsModel.getGridConfig().column;
  }

  /**
   * 设置dragBehaviorMode用于数据打点
   */
  public setDragBehaviorMode(dragBehaviorMode: number): void {
    this.dragBehaviorMode = dragBehaviorMode;
  }

  /**
   * 获取dragBehaviorMode用于数据打点
   */
  public getDragBehaviorMode(): number {
    return this.dragBehaviorMode;
  }

  private updateDragGridParam(offset: number): void {
    if (offset === undefined || offset === null) {
      return;
    }
    for (let index = 0; index < this.mPageCoordinateData?.gridXAxis?.length; index++) {
      if (this.mPageCoordinateData?.gridXAxis[index] && this.mWaterfallPageCoordinateData?.gridXAxis[index]) {
        this.mPageCoordinateData.gridXAxis[index] += offset;
        this.mWaterfallPageCoordinateData.gridXAxis[index] += offset;
      }
    }
  }

  private updateGridParam(effectArea: DragArea): void {
    const gridWidth = this.mPageDesktopStyleConfig.mGridWidth;
    const gridHeight = this.mPageDesktopStyleConfig.mGridHeight;
    log.showDebug(`updateGridParam gridWidth: ${gridWidth}, gridHeight: ${gridHeight}`);
    this.mGridConfig = this.mSettingsModel.getGridConfig();
    const column = this.mGridConfig.column;
    const row = this.mGridConfig.row;
    const columnsGap = this.mPageDesktopStyleConfig.mColumnsGap;
    const rowGap = this.mPageDesktopStyleConfig.mRowsGap;
    this.mPaddingLeft = effectArea.left;
    this.mPaddingTop = effectArea.top;
    this.mGridItemHeight = row > 0 ? gridHeight / row : 0;
    this.mGridItemWidth = column > 0 ? gridWidth / column : 0;
    this.lastFoldStatus = undefined;
    log.showDebug(`updateGridParam column: ${column}, row: ${row}`);
    this.mPageCoordinateData.gridYAxis = [];
    for (let i = 1; i <= row; i++) {
      const touchPositioningY = (gridHeight / row) * i + effectArea.top;
      this.mPageCoordinateData.gridYAxis.push(touchPositioningY);
    }

    this.mWaterfallPageCoordinateData.gridYAxis = [];
    for (let i = 1; i <= row * CommonConstants.WATERFALL_PAGE_COUNT; i++) {
      const touchPositioningY = (gridHeight / row) * i + effectArea.top;
      this.mWaterfallPageCoordinateData.gridYAxis.push(touchPositioningY);
    }

    this.mPageCoordinateData.gridXAxis = [];
    this.mWaterfallPageCoordinateData.gridXAxis = [];
    for (let i = 1; i <= column; i++) {
      const touchPositioningX = (gridWidth / column) * i + effectArea.left;
      this.mPageCoordinateData.gridXAxis.push(touchPositioningX);
      this.mWaterfallPageCoordinateData.gridXAxis.push(touchPositioningX);
    }
  }

  private updateFoldRelatedStatus(x: number, y: number): void {
    if (y == null || x == null) {
      return;
    }
    let screenWidth = AppStorage.get<number>('screenWidth') as number;
    let screenHeight = AppStorage.get<number>('screenHeight') as number;
    let isFoldExpandNearScreen: boolean = false;
    let indexInFoldExpand: number = 0;
    let foldStatus: boolean = this.isFoldExpandStatus();
    let count: number = PageInfoManager.getInstance().getDisplayCount();
    let offset: number = 0;
    if (foldStatus) {
      if (screenWidth != null) {
        indexInFoldExpand = Math.floor(x / Math.floor(screenWidth / count));
        if (editModeManager.isInEditMode()) {
          const editModeScreenWidth = EditModeUtils.convertWithDesktopScale(screenWidth);
          const editModeX = x - (1 - EditModeUtils.getDesktopScale()) * screenWidth / 2;
          indexInFoldExpand = Math.floor(editModeX / Math.floor(editModeScreenWidth / count));
        }
        indexInFoldExpand = Math.max(Math.min(indexInFoldExpand, count - 1), 0);
      }
      if (screenWidth != null && x > Math.floor(screenWidth / count) * (count - 1)) {
        isFoldExpandNearScreen = true;
      }
    }

    if (foldStatus) {
      if (indexInFoldExpand < Math.floor(count / 2)) {
        offset = screenWidth / count * indexInFoldExpand + this.mPageDesktopStyleConfig.mMargin + (this.mPageDesktopStyleConfig.mFoldPaddingSide ?? 0);
      } else if (indexInFoldExpand > Math.floor(count / 2)) {
        offset = screenWidth / count * indexInFoldExpand + this.mPageDesktopStyleConfig.mMargin - (this.mPageDesktopStyleConfig.mFoldPaddingSide ?? 0);
      } else {
        offset = screenWidth / count * indexInFoldExpand + this.mPageDesktopStyleConfig.mMargin;
      }
    } else {
      offset = this.isSuperFold ? this.mPageDesktopStyleConfig.mWorkSpacePadding : this.mPageDesktopStyleConfig.mMargin;
    }
    let paddingLeftOffset: number = offset - this.mPaddingLeft;
    this.mPaddingLeft = offset;
    if (foldStatus !== this.lastFoldStatus || indexInFoldExpand !== this.indexInFoldExpand) {
      // 左右半屏切换时重置挤位
      this.resetSqueezeStatus();
      this.updateDragGridParam(paddingLeftOffset);
    }
    this.lastFoldStatus = foldStatus;
    this.isFoldNearScreen = isFoldExpandNearScreen;
    this.indexInFoldExpand = indexInFoldExpand;
  }

  public getPageIndex(): number {
    let pageIndex: number = desktopUtil.getPageIndexValue();
    if (this.isSuperFold) {
      if (pageIndex % NUM_HALF !== 0) {
        pageIndex--;
      }
      return this.isFoldNearScreen ? pageIndex + 1 : pageIndex;
    }
    return this.getRTLShowPage(pageIndex);
  }

  private getRTLShowPage(pageIndex: number): number {
    let count: number = PageInfoManager.getInstance().getDisplayCount();
    const leftPageIndex = Math.floor(pageIndex / count) * count;
    if (RTLUtil.isRTL()) {
      return count - 1 - this.indexInFoldExpand + leftPageIndex;
    } else {
      return this.indexInFoldExpand + leftPageIndex;
    }
  }

  private isFoldExpandStatus(): boolean {
    if (!DeviceHelper.isThreeFoldProduct()) {
      return desktopUtil.isFoldExpandStatus();
    }
    return !DeviceHelper.isFState();
  }

  public getItemIndex(x: number, y: number): number {
    if (x === undefined || x === null || y === undefined || y === null) {
      log.showError('getItemIndex: x or y invalid');
      return CommonConstants.INVALID_VALUE;
    }
    let res = this.isSuperFold ? GridLayoutUtil.getRowAndColumnAndPage(x, y, this.isPortrait) :
    GridLayoutUtil.getRowAndColumn(x, y, this.getCurrentPageIndex());
    const rowVal = res.row;
    const columnVal = res.column;
    const column = this.mGridConfig?.column ?? 0;
    const row = this.mGridConfig?.row ?? 0;
    if (rowVal !== CommonConstants.INVALID_VALUE && columnVal !== CommonConstants.INVALID_VALUE) {
      if (this.isSuperFold && this.isExpandStatus) {
        return this.getItemIndexForSuperFold(columnVal, rowVal, res.page);
      }
      return this.isPc ? columnVal * row + rowVal : rowVal * column + columnVal;
    }
    return CommonConstants.INVALID_VALUE;
  }

  protected getItemByIndex(index: number): GridLayoutItemInfo | undefined {
    if (!this.mGridConfig) {
      return undefined;
    }
    let column = this.isPc ? Math.floor(index / this.mGridConfig.row) : index % this.mGridConfig.column;
    let row = this.isPc ? index % this.mGridConfig.row : Math.floor(index / this.mGridConfig.column);
    let pageIndex: number = this.getCurrentPageIndex();
    if (this.isSuperFold && this.isExpandStatus) {
      const position: DragGridPosition = this.getItemByIndexForSuperFold(index);
      column = position.column;
      row = position.row;
      pageIndex = position.page ?? -1;
    }
    const layoutInfo = this.mLayoutCacheManager.selectGridLayoutItemsByPage(pageIndex);
    const itemInfo = layoutInfo.find(item => {
      if (GridLayoutUtil.isIconType(item.typeId)) {
        return item.column === column && item.row === row;
      } else if (item.typeId === CommonConstants.TYPE_FOLDER || item.typeId === CommonConstants.TYPE_CARD ||
        item.typeId === CommonConstants.TYPE_FILE_FOLDER || item.typeId === CommonConstants.TYPE_FORM_STACK) {
        return this.isItemInRowColumn(row, column, item);
      }
      return false;
    });
    return itemInfo;
  }

  protected getItemByPosition(position: DragItemPosition): GridLayoutItemInfo | undefined {
    if (this.mIsPrintLog) {
      log.showDebug('position page: %{public}d, row: %{public}d, column: %{public}d, X: %{public}d, Y: %{public}d',
        position.page, position.row, position.column, position?.x, position?.y);
    }
    const pageIndex: number = this.getCurrentPageIndex();
    const layoutInfo = this.mLayoutCacheManager.selectGridLayoutItemsByPage(pageIndex);
    // 兼容多选情况
    const dragItemInfoList: GridLayoutItemInfo[] = this.getDragItems() ?? [];
    const dragItemSet = new Set<string>();
    dragItemInfoList.forEach((dragItemInfo: GridLayoutItemInfo) => {
      dragItemSet.add(GridLayoutUtil.generateUniqueKey(dragItemInfo));
    });
    if (dragItemSet.size === 0) {
      return undefined;
    }
    const dragItemInfo = dragItemInfoList[0];
    const itemInfo = layoutInfo.find(item => {
      if (!item || item.column === undefined || item.row === undefined || !dragItemInfo.area|| !item.area){
        return false;
      }
      if (item.column < (position.column + dragItemInfo.area[0]) &&
        position.column < (item.column + item.area[0]) &&
        item.row < (position.row + dragItemInfo.area[1]) &&
        position.row < (item.row + item.area[1]) &&
        !dragItemSet.has(GridLayoutUtil.generateUniqueKey(item))
      ) {
        return item;
      }
      return false;
    });
    return itemInfo;
  }

  /**
   * judge the item is at target row and column
   * @param row
   * @param column
   * @param item
   */
  private isItemInRowColumn(row: number, column: number, item: GridLayoutItemInfo): boolean {
    if (!item || !item.area || item.column === undefined || item.row === undefined) {
      return false;
    }
    return item.column <= column && column < item.column + item.area[0] && item.row <= row && row < item.row + item.area[1];
  }

  public getTouchPosition(x: number, y: number): DragItemPosition {
    const pageIndex: number = this.getCurrentPageIndex();
    log.showDebug(`getTouchPosition pageIndex: ${pageIndex}`);
    AppStorage.setOrCreate('dragFromPage', pageIndex);
    const position: DragItemPosition = {
      page: pageIndex,
      row: 0,
      column: 0,
      x: x,
      y: y
    };
    if (x === undefined || x === null || y === undefined || y === null) {
      log.showError('getTouchPosition: x or y invalid');
      return position;
    }
    if (this.isSuperFold) {
      const touchPosition: DragGridPosition = GridLayoutUtil.getRowAndColumnAndPage(x, y, this.isPortrait);
      position.column = touchPosition.column;
      position.row = touchPosition.row;
      position.page = touchPosition.page ?? -1;
      return position;
    }
    for (let i = 0; i < this.mPageCoordinateData.gridXAxis.length; i++) {
      if (x < this.mPageCoordinateData.gridXAxis[i]) {
        position.column = i;
        break;
      } else {
        position.column = this.mPageCoordinateData.gridXAxis.length - 1;
      }
    }
    for (let i = 0; i < this.mPageCoordinateData.gridYAxis.length; i++) {
      if (y < this.mPageCoordinateData.gridYAxis[i]) {
        position.row = i;
        break;
      } else {
        position.row = this.mPageCoordinateData.gridYAxis.length - 1;
      }
    }
    return position;
  }

  private updateStartPosition(): void {
    let dragItem: GridLayoutItemInfo | undefined = this.getSingleDragItemInfo();
    if (!dragItem || !GridLayoutUtil.isValidLayoutItem(dragItem) || this.isPc) {
      return;
    }
    let cached: GridLayoutItemInfo | undefined =
      LaunchLayoutCacheManager.getInstance().selectGridLayoutItemByItem(dragItem);
    if (!cached) {
      log.showWarn('unable to find %{public}s in cache', dragItem.keyName);
      return;
    }
    let center: number[] = GridLayoutUtil.getIconCenterPosition(cached.row, cached.column, cached.area, cached.page);
    this.mStartPosition = {
      page: cached.page ?? -1,
      row: cached.row ?? 0,
      column: cached.column ?? 0,
      x: center[0],
      y: center[1],
    };
  }

  private getPositionByRowAndColumn(row: number, column: number, page?: number): number[] {
    const position: number[] = this.isSuperFold ?
    GridLayoutUtil.getSuperFoldGridItemPosition(row, column, page ?? this.getCurrentPageIndex(), this.isPortrait) :
    GridLayoutUtil.getGridItemPosition(row, column, page ?? this.getCurrentPageIndex());
    log.showInfo('get position by row %{public}d, column %{public}d and page %{public}d.' +
      ' position is [%{public}d, %{public}d]', row, column, page ?? this.getCurrentPageIndex(), position[0], position[1]);
    return position;
  }

  private getPositionByRowAndColumnWithoutRTL(row: number, column: number, page?: number): number[] {
    let position = GridLayoutUtil.getGridItemPositionWithoutRTL(row, column, page ?? this.getCurrentPageIndex());
    log.showInfo('get position by row %{public}d, column %{public}d and page %{public}d.' +
      ' position is [%{public}d, %{public}d]', row, column, page, position[0], position[1]);
    return position;
  }

  private getPaddingLeft(itemPage: number): number {
    let screenWidth = AppStorage.get<number>('screenWidth') as number;
    let isFoldExpandNearScreen: boolean = false;
    let foldStatus: boolean = this.isFoldExpandStatus();
    if (foldStatus) {
      if (itemPage % 2 !== 0) {
        isFoldExpandNearScreen = true;
      }
    }
    let paddingLeft = 0;
    if (isFoldExpandNearScreen) {
      paddingLeft = screenWidth / NumberConstants.CONSTANT_NUMBER_TWO + this.mPageDesktopStyleConfig.mMargin;
    } else if (foldStatus) {
      paddingLeft = this.mPageDesktopStyleConfig.mFoldPaddingSide + this.mPageDesktopStyleConfig.mMargin;
    } else {
      paddingLeft = this.mPageDesktopStyleConfig.mMargin;
    }
    return paddingLeft;
  }

  /**
   * 起拖时，初始化多选拖起图标的相对位置和锚点
   */
  private initMultiDragItemsData(): void {
    if (this.zSqueeze) {
      return;
    }
    if (!this.mStartPosition) {
      log.showWarn('desktop drag initMultiDragItemsData mStartPosition undefined');
      return;
    }
    const dragItems: GridLayoutItemInfo[] | undefined = this.getDragItems();
    if (!dragItems || CheckEmptyUtils.isEmptyArr(dragItems)) {
      log.showWarn('desktop drag initMultiDragItemsData empty');
      return;
    }
    const item: GridLayoutItemInfo | undefined = LaunchLayoutCacheManager.getInstance().selectGridLayoutItemByItem(dragItems[0]);
    if (!item) {
      return;
    }
    // 修正起拖位置
    this.fixStartPosition(dragItems, item);
    log.showInfo(`desktop drag initMultiDragItemsData: dragStartItemIndex: ${this.dragStartItemIndex} mStartPosition: row ${this.mStartPosition.row},
      column: ${this.mStartPosition.column}, page ${this.mStartPosition.page}`);
    this.multiDragItemPosMap.clear();
    this.pcMultiDragCount = dragItems.length;
    dragItems.forEach((item: GridLayoutItemInfo) => {
      const key: string = this.getItemEventKey(item);
      let position: number[][] = [];
      if (!item || item.row === undefined || item.column === undefined || !this.mStartPosition) {
        return;
      }
      let oldPos: number[] = [item.row, item.column];
      let offset: number[] = [item.row - this.mStartPosition.row, item.column - this.mStartPosition.column];
      // super fold展开态，需要当做整屏处理
      if (this.isExpandStatus) {
        if (item.page === undefined || !this.mGridConfig) {
          return;
        }
        if (this.isPortrait) {
          oldPos[0] = oldPos[0] + item.page * this.mGridConfig.row;
          offset[0] = oldPos[0] - this.mStartPosition.row - this.mStartPosition.page * this.mGridConfig.row;
        } else {
          oldPos[1] = oldPos[1] + item.page * this.mGridConfig.column;
          offset[1] = oldPos[1] - this.mStartPosition.column - this.mStartPosition.page * this.mGridConfig.column;
        }
      }
      position[0] = oldPos;
      position[1] = offset;
      this.multiDragItemPosMap.set(key, position);
      log.showInfo(`desktop drag initMultiDragItemsData: init key: ${key}, pos: ${oldPos[0]}, ${oldPos[1]}, offset: ${offset[0]}, ${offset[1]}`);
    });
  }

  /**
   * 修正起拖位置
   */
  private fixStartPosition(dragItems: GridLayoutItemInfo[], item: GridLayoutItemInfo): void {
    if (dragItems.length === 1 && (this.mStartPosition?.column !== item.column ||
      this.mStartPosition?.row !== item.row || this.mStartPosition?.page !== item.page)) {
      let center: number[] = GridLayoutUtil.getIconCenterPosition(item.row, item.column, item.area, item.page);
      this.mStartPosition = {
        page: item.page ?? -1,
        row: item.row ?? 0,
        column: item.column ?? 0,
        x: center[0],
        y: center[1],
      };
    }
  }

  onDragStart(x: number, y: number): void {
    Trace.start(Trace.CORE_METHOD_DRAG_START);
    const dragItemInfo: GridLayoutItemInfo | undefined = this.getSingleDragItemInfo();
    if (!dragItemInfo || !GridLayoutUtil.isValidLayoutItem(dragItemInfo)) {
      log.showError('onDragStart dragItemInfo is null');
      Trace.end(Trace.CORE_METHOD_DRAG_START);
      return;
    }
    log.showInfo('onDragStart start');
    if (dragItemInfo.typeId === CommonConstants.TYPE_FOLDER) {
      log.showInfo(`dragFolder length ${dragItemInfo.layoutInfo?.flat().length}`);
    }
    LightOutdoorDesktopViewModel.getInstance().removeAddIcon();
    DragEventManager.getInstance(launcherStatusUtil.getShowOutLauncherStatus()).dragStartInDesktop(this.getItemEventKey(dragItemInfo));
    this.mStartPosition = undefined;
    this.isSqueezeSuccess = false;
    this.dragBehaviorMode = DragBehaviorMode.DRAG_BY_LONG_PRESS;
    this.updateFoldRelatedStatus(x, y);
    const selectAppIndex = this.getItemIndex(x, y);
    this.dragStartItemIndex = selectAppIndex;
    log.showInfo(`onDragStart, dragStartItemIndex:${this.dragStartItemIndex}, x:${x}, y:${y}`);
    AppStorage.setOrCreate<number>('selectAppIndex', selectAppIndex);
    this.mStartPosition = this.getTouchPosition(x, y);
    if (!this.isPc) {
      this.updateStartPosition();
    }
    // 初始起拖时调用播报，此时只更新初始位置，不会进行播报
    if (DragAccessibilityUtils.isAccessibilityMode()) {
      let startIndex: number[] = [this.mStartPosition.row + 1, this.mStartPosition.column + 1];
      this.finallyFallPosition = [this.mStartPosition.row + 1, this.mStartPosition.column + 1];
      this.textAnnounced(startIndex);
    }
    AppStorage.setOrCreate<Object>('startPosition', this.mStartPosition);
    let pageIndex: number = this.getCurrentPageIndex();
    this.mLastPosition = {
      page: pageIndex,
      row: dragItemInfo.row ?? 0,
      column: dragItemInfo.column ?? 0,
      x: x,
      y: y
    };
    this.initMultiDragItemsData();
    Trace.end(Trace.CORE_METHOD_DRAG_START);
  }

  private getItemEventKey(item: GridLayoutItemInfo | MoveItem): string {
    return GridLayoutUtil.generateUniqueKey(item as GridLayoutItemInfo);
  }

  onDragLeave(x: number, y: number): void {
    log.showDebug(`in onDragLeave, pageIndex: ${desktopUtil.getPageIndexValue()}`);
    this.resetMoveItemList();
    this.resetLastMoveItemList();
    this.updateLastPosition();
    this.clearLastCoveredItemAnimation();
    this.clearSwipeTimeout();
    this.resetSqueezeTimeout();
    this.notifyGridWhiteEdgeHide(this.lastBoxPage);
    if (this.isPc) {
      if (this.isDropFileToDesktop) {
        AppStorage.setOrCreate('isDrag', false);
        this.isDropFileToDesktop = false;
      }
      this.isLeaveSwiperPage = true;
    }
    DragAccessibilityUtils.resetIndex();
  }

  isDragLeaveSwiperPage(): boolean {
    return this.isLeaveSwiperPage;
  }

  /*
   * 拖拽离开图标后, 清理上一个图标的背板动效, 进行回缩动效
   */
  public clearLastCoveredItemAnimation(): void {
    log.showInfo('clearLastCoveredItemAnimation enter');
    this.coveredItem = new GridLayoutItemInfo();
    let lastCoveredItem: GridLayoutItemInfo =
      AppStorage.get<GridLayoutItemInfo>('coveredItemInfo') as GridLayoutItemInfo;
    if (JSON.stringify(lastCoveredItem) === '{}' || lastCoveredItem === undefined || lastCoveredItem === null) {
      log.showWarn('lastCoveredItem is null');
      return;
    }

    log.showInfo(`clearLastCoveredItemAnimation typeId:${lastCoveredItem.typeId}, keyName:${lastCoveredItem.keyName}`);
    if (GridLayoutUtil.isIconType(lastCoveredItem.typeId) && lastCoveredItem.keyName !== undefined) {
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub.emit(`coveredApp${lastCoveredItem.keyName}`, false);
      AppStorage.setOrCreate('coveredItemInfo', {});
      this.coveredIsOtherItem = false;
      return;
    }

    if (lastCoveredItem.typeId === CommonConstants.TYPE_FOLDER && lastCoveredItem.folderId !== undefined) {
      ContractedFolderCommonViewModel.getInstance().dragCover('clear cover animate', lastCoveredItem.folderId, false);
      AppStorage.setOrCreate('coveredItemInfo', {});
      this.coveredIsOtherItem = false;
      return;
    }

    if (lastCoveredItem.typeId === CommonConstants.TYPE_CARD && lastCoveredItem.cardId !== undefined) {
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub.emit(`coveredCard${lastCoveredItem.cardId}`, false);
      AppStorage.setOrCreate('coveredItemInfo', {});
      this.coveredIsOtherItem = false;
      return;
    }

    if (lastCoveredItem.typeId === CommonConstants.TYPE_FORM_STACK && lastCoveredItem.formStackId !== undefined) {
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub.emit(`coveredFormStack${lastCoveredItem.formStackId}`, false);
      AppStorage.setOrCreate<object>('coveredItemInfo', {});
      this.coveredIsOtherItem = false;
      return;
    }

    if (lastCoveredItem.typeId === CommonConstants.TYPE_FILE_FOLDER && lastCoveredItem.ino !== undefined) {
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub.emit(`coveredFileFolder${lastCoveredItem.ino}`, false);
      AppStorage.setOrCreate('coveredItemInfo', {});
      return;
    }
    log.showError('abnormal data lastCoveredItem.keyName: %{public}s, lastCoveredItem.folderId: %{public}d',
      lastCoveredItem.keyName, lastCoveredItem.folderId); // 正常流程不会走这个逻辑
    AppStorage.setOrCreate('coveredItemInfo', {});
  }

  /*
   * 对应图标背板动效
   */
  private coveredItemAnimation(dragItemInfo: GridLayoutItemInfo, itemInfo: GridLayoutItemInfo): void {
    log.showInfo('coveredItemAnimation enter');
    this.coveredItem = itemInfo;
    log.showInfo('dragItemInfo.typeId: %{public}s, itemInfo.typeId: %{public}s, area: %{public}s, itemInfo.area: %{public}s',
      dragItemInfo.typeId, itemInfo.typeId, dragItemInfo.area, itemInfo.area);
    // app覆盖
    if (GridLayoutUtil.isIconType(dragItemInfo.typeId) && GridLayoutUtil.isIconType(itemInfo.typeId) &&
      JSON.stringify(dragItemInfo.area) === JSON.stringify(itemInfo.area)) {
      const coveredAppInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      coveredAppInfo.appName = itemInfo.appName;
      coveredAppInfo.keyName = itemInfo.keyName;
      coveredAppInfo.bundleName = itemInfo.bundleName;
      coveredAppInfo.area = itemInfo.area;
      coveredAppInfo.typeId = itemInfo.typeId;
      AppStorage.setOrCreate('coveredItemInfo', coveredAppInfo);
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub.emit(`coveredApp${itemInfo.keyName}`, true);
      this.textAnnouncedMerge(itemInfo);
      return;
    }

    // app覆盖文件夹
    if (GridLayoutUtil.isIconType(dragItemInfo.typeId) && itemInfo.typeId === CommonConstants.TYPE_FOLDER &&
      !FolderViewModel.isFolderFull(itemInfo)) {
      const coveredFolderInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      coveredFolderInfo.folderId = itemInfo.folderId;
      coveredFolderInfo.area = itemInfo.area;
      coveredFolderInfo.typeId = CommonConstants.TYPE_FOLDER;
      AppStorage.setOrCreate('coveredItemInfo', coveredFolderInfo);
      ContractedFolderCommonViewModel.getInstance().dragCover('cover animation', itemInfo.folderId, true);
      this.textAnnouncedMerge(itemInfo);
      return;
    }

    // 同尺寸的卡片覆盖
    if (dragItemInfo.typeId === CommonConstants.TYPE_CARD && itemInfo.typeId === CommonConstants.TYPE_CARD &&
      dragItemInfo.cardDimension === itemInfo.cardDimension) {
      const coveredFormInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      coveredFormInfo.cardId = itemInfo.cardId;
      coveredFormInfo.area = itemInfo.area;
      coveredFormInfo.typeId = CommonConstants.TYPE_CARD;
      AppStorage.setOrCreate('coveredItemInfo', coveredFormInfo);
      FormStackManager.getInstance().getBreakFormStackExpandAnimation()?.();
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub.emit(`coveredCard${itemInfo.cardId}`, true);
      this.textAnnouncedMerge(itemInfo);
      return;
    }

    // 同尺寸的卡片覆盖卡片堆叠
    if (dragItemInfo.typeId === CommonConstants.TYPE_CARD && itemInfo.typeId === CommonConstants.TYPE_FORM_STACK &&
      dragItemInfo.cardDimension === itemInfo.layoutInfo?.[0]?.[0]?.cardDimension) {
      AppStorage.setOrCreate<GridLayoutItemInfo>('coveredItemInfo', itemInfo);
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub.emit(`coveredFormStack${itemInfo.formStackId}`, true);
      this.textAnnouncedMerge(itemInfo);
    }
    // 桌面文件覆盖
    if (FileFolderConfig.getInstance().isFileFolderEnable() &&
    FileFolderDragHandler.getInstance().isSupportCover(dragItemInfo, itemInfo)) {
      AppStorage.setOrCreate('coveredItemInfo', itemInfo);
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)
        .eventHub.emit(`coveredFileFolder${itemInfo.ino}`, true);
    }
  }

  private textAnnouncedMerge(itemInfo: GridLayoutItemInfo): void {
    switch (itemInfo.typeId) {
      case CommonConstants.TYPE_FOLDER:
        // 无障碍朗读移动至文件夹
        const realFolderName: string = FolderCommonUtil.getRealFolderName(itemInfo.folderName);
        DragAccessibilityUtils.textAnnouncedForMoveToFolder(realFolderName);
        break;
      case CommonConstants.TYPE_CARD:
        // 无障碍朗读合并为堆叠卡片
        if (!this.coveredIsOtherItem) {
          let cardName = this.getAppName(itemInfo);
          DragAccessibilityUtils.textAnnouncedForMoveToMergeCard(cardName);
        }
        break;
      case CommonConstants.TYPE_FORM_STACK:
        // 无障碍朗读移至堆叠卡片
        if (!this.coveredIsOtherItem && itemInfo.layoutInfo && !CheckEmptyUtils.isEmptyArr(itemInfo.layoutInfo[0])) {
          let cardName = this.getAppName(itemInfo.layoutInfo[0][itemInfo.layoutInfo[0].length - 1]);
          DragAccessibilityUtils.textAnnouncedForMoveToFormStack(cardName);
        }
        break;
      default:
      // 无障碍朗读移动至应用上
        let appName = this.getAppName(itemInfo);
        DragAccessibilityUtils.textAnnouncedForMoveToMerge(appName);
        break;
    }
    this.coveredIsOtherItem = true;
  }

  onDragEnter(x: number, y: number): void {
    const dragItemInfo: GridLayoutItemInfo | undefined = this.getSingleDragItemInfo();
    if (!dragItemInfo || !GridLayoutUtil.isValidLayoutItem(dragItemInfo)) {
      return;
    }
    this.isLeaveSwiperPage = false;
    log.showInfo('desktop drag dragItemInfo, appName: %{public}s, bundleName: %{public}s, moduleName: %{public}s, typeId: %{public}d, ino: %{public}s, infoId: %{public}s',
      dragItemInfo?.appName, dragItemInfo.bundleName, dragItemInfo.moduleName, dragItemInfo.typeId, dragItemInfo?.ino, dragItemInfo?.infoId);
  }

  /**
   * 获取拖拽元素的落位位置
   *
   * @param dragItem 拖拽元素
   * @returns 落位的行列信息
   */
  private getItemDropPosition(dragItem: GridLayoutItemInfo): number[] {
    let position: number[] = [];
    // 使用LayoutInfo信息具有实时性，DragRelativeData只有在布局刷新之后才会刷新，有时序问题。
    let itemList: GridLayoutItemInfo[] = this.mLayoutCacheManager.getAllGridLayoutItemList(BusinessType.BUSINESS_DRAG);
    log.showInfo(`itemList length: ${itemList.length}`);
    // 考虑到跨页拖拽场景，需要搜索桌面上所有的item
    for (let i = 0; i < itemList.length; i++) {
      if (this.judgeItem(itemList[i], dragItem) || this.isInFormStack(itemList[i], dragItem)) {
        position[0] = itemList[i].column ?? 0;
        position[1] = itemList[i].row ?? 0;
        position[2] = itemList[i].page ?? -1;
        break;
      }
    }
    return position;
  }

  private isInFormStack(formStackItem: GridLayoutItemInfo, cardItem: GridLayoutItemInfo): boolean {
    if (!formStackItem || !cardItem) {
      return false;
    }
    if (formStackItem.typeId !== CommonConstants.TYPE_FORM_STACK || cardItem.typeId !== CommonConstants.TYPE_CARD) {
      return false;
    }
    if (!formStackItem.layoutInfo || CheckEmptyUtils.isEmptyArr(formStackItem.layoutInfo)) {
      return false;
    }
    for (let i = 0; i < formStackItem.layoutInfo[0].length; i++) {
      if (formStackItem.layoutInfo[0][i].cardId === cardItem.cardId) {
        return true;
      }
    }
    return false;
  }

  /**
   * 处理白框落位动效
   * @param isShow 是否显示
   * @param dropY 落位纵坐标
   */
  private handleFallItemAnimation(isShow: boolean, dropY?: number): void {
    log.showDebug('in handleFallItemAnimation...');
    const page = this.getCurrentPageIndex();
    if (!Number.isInteger(page)) {
      return;
    }
    let curPage: number = Number(page);
    if (this.lastBoxPage === -1) {
      this.lastBoxPage = curPage;
    }
    let dragTranslate: number[] = [];
    if (RTLUtil.isRTL()) {
      if (this.isSuperFold && this.isLeaveSwiperPage) {
        dragTranslate = this.getDragTranslate(dropY ?? 0);
        isShow = dragTranslate.length === 0 ? false : isShow;
      } else {
        if (!this.mEndPosition) {
          return;
        }
        dragTranslate = GridLayoutUtil.getIconCenterPositionWithoutRTL(this.mEndPosition.row,
          this.mEndPosition.originColumn, [1, 1], curPage, this.isPortrait);
        isShow = this.needHideWhiteEdge() ? false : isShow;
      }
    } else {
      if (this.isSuperFold && this.isLeaveSwiperPage) {
        dragTranslate = this.getDragTranslate(dropY ?? 0);
        isShow = dragTranslate.length === 0 ? false : isShow;
      } else {
        if (!this.mEndPosition) {
          return;
        }
        dragTranslate = GridLayoutUtil.getIconCenterPosition(this.mEndPosition.row,
          this.mEndPosition.column, [1, 1], curPage, this.isPortrait);
        isShow = this.needHideWhiteEdge() ? false : isShow;
      }
    }
    // 翻页时，移除上一页的白框并显示新一页的白框.在当前页时则仅更新显示或显示位置
    if (this.lastBoxPage !== page) {
      this.notifyGridWhiteEdgeHide(this.lastBoxPage);
      if (isShow) {
        this.notifyGridWhiteEdgeShow(curPage, dragTranslate);
      }
    } else {
      if (isShow) {
        this.notifyGridWhiteEdgeShow(curPage, dragTranslate);
      } else {
        this.notifyGridWhiteEdgeHide(curPage);
      }
    }
    this.lastBoxPage = curPage;
  }

  private needHideWhiteEdge(): boolean {
    let needHideWhiteEdge: boolean = false;
    if (this.isSuperFold && this.currentMoveItemList.length === 0) {
      const dragItemInfo: GridLayoutItemInfo | undefined = this.getSingleDragItemInfo();
      if (!this.mEndPosition) {
        return false;
      }
      const coveredItem: GridLayoutItemInfo | undefined = this.getItemByPosition(this.mEndPosition);
      if (dragItemInfo && coveredItem && !GridLayoutUtil.checkGridItemEqual(dragItemInfo, coveredItem)) {
        //当前未发生挤位，但落位框所在的宫格上已经有元素，且非拖拽元素，则不显示
        log.showWarn(`occupied Y: ${this.mEndPosition.column}, X: ${this.mEndPosition.row}, P: ${this.dragPageIndex}`);
        needHideWhiteEdge = true;
      }
    }
    return needHideWhiteEdge;
  }

  private getDragTranslate(dropY: number): number[] {
    const dragItemInfo: GridLayoutItemInfo | undefined = this.getSingleDragItemInfo();
    if (!dragItemInfo) {
      log.showWarn('getDragTranslate dragItemInfo undefined');
      return [];
    }
    const screenHalfHeight = LayoutViewModel.getInstance().getScreenHeight() / 2;
    const dragCreaseHalfHeight = this.mDragCreaseHeight / 2;
    let dragTranslatePos: DragGridPosition = { row: 0, column: 0, page: 0 };
    // B面拖到中轴区以上，C面拖到中轴区以下，弹回原位
    if ((dragItemInfo.page === 0 && dropY < screenHalfHeight) ||
      (dragItemInfo.page === 1 && dropY > screenHalfHeight &&
        dropY < (screenHalfHeight + dragCreaseHalfHeight))) {
      dragTranslatePos.column = dragItemInfo.column ?? 0;
      dragTranslatePos.row = dragItemInfo.row ?? 0;
      dragTranslatePos.page = dragItemInfo.page ?? 0;
      let fallBackPos: DragItemPosition = {
        page: this.dragPageIndex,
        row: dragTranslatePos.row,
        column: dragTranslatePos.column,
        originColumn: 0,
        x: 0,
        y: 0
      };
      const coveredItem: GridLayoutItemInfo | undefined = this.getItemByPosition(fallBackPos);
      if (coveredItem && !GridLayoutUtil.checkGridItemEqual(dragItemInfo, coveredItem)) {
        //外部拖入场景，该位置有元素，无法弹回
        log.showWarn(`occupied y: ${dragTranslatePos.column}, x: ${dragTranslatePos.row}, p: ${dragTranslatePos.page}`);
        return [];
      }
    }
    // B面拖拽到中轴区以下
    if (dragItemInfo.page === 0 && dropY > screenHalfHeight && dropY <
      (screenHalfHeight + dragCreaseHalfHeight)) {
      const endPos: number[] = this.getEndPosition(1, dragItemInfo);
      if (endPos.length === 0) {
        return [];
      }
      dragTranslatePos.column = endPos[0];
      dragTranslatePos.row = endPos[1];
      dragTranslatePos.page = 1;
    }
    // C面拖拽到中轴区以上
    if (dragItemInfo.page === 1 && dropY < screenHalfHeight) {
      const endPos: number[] = this.getEndPosition(0, dragItemInfo);
      if (endPos.length === 0) {
        return [];
      }
      dragTranslatePos.column = endPos[0];
      dragTranslatePos.row = endPos[1];
      dragTranslatePos.page = 0;
    }
    return GridLayoutUtil.getIconCenterPosition(dragTranslatePos.row, dragTranslatePos.column,
      [1, 1], dragTranslatePos.page, this.isPortrait);
  }

  private getDragFormTypes(): number[] {
    const dragFormTypes = [
      CommonConstants.DRAG_FROM_MANAGE,
      CommonConstants.DRAG_FROM_FORM_SERVICE,
      CommonConstants.DRAG_FROM_FORM_INTELLIGENT,
      CommonConstants.DRAG_FROM_FORM_STACK,
      CommonConstants.DRAG_FROM_SWIPE_UP,
    ];
    return dragFormTypes;
  }

  onDragMove(x?: number, y?: number): boolean {
    log.showDebug('swiperPage dragMove');
    if (x === undefined || y === undefined || isNaN(x) || isNaN(y)) {
      log.showWarn('onDragMove x or y is NaN');
      return false;
    }
    this.updateFoldRelatedStatus(x, y);
    // 再次读取拖拽对象信息
    const dragItemInfo: GridLayoutItemInfo | undefined = this.getSingleDragItemInfo();
    if (!dragItemInfo || !GridLayoutUtil.isValidLayoutItem(dragItemInfo)) {
      log.showWarn('dragItemInfo is null?');
      return false;
    }

    // 如果堆叠未收起不进行挤位
    if (AppStorage.get<boolean>('formStackEditShow') && !AppStorage.get<boolean>('couldSqueezeStack')) {
      log.showWarn('dragItemInfo formstack expanding, can not squeeze!');
      return false;
    }

    const dragItemType: number | undefined = AppStorage.get('dragItemType');
    if (!dragItemType) {
      return false;
    }
    // 桌面拖拽只响应桌面相关拖拽事件，不响应应用中心
    if (dragItemType === CommonConstants.DRAG_FROM_APPCENTER) {
      log.showWarn('appCenter is dragging on Desktop returns');
      return false;
    }
    const deviceType: string | undefined = AppStorage.get('device');
    const pageIndex: number = this.getCurrentPageIndex();
    if (this.mIsPrintLog) {
      log.showDebug('drag info dragItemType: %{public}s, deviceType: %{public}s, pageIndex: %{public}d, bundleName: %{public}s, moduleName: %{public}s',
        dragItemType, deviceType, pageIndex, dragItemInfo.bundleName, dragItemInfo.moduleName);
    }
    const isDragItemSmallFolder = GridLayoutUtil.isSmallFolder(dragItemInfo);

    // dock appInfo has no location information.
    if (dragItemType === CommonConstants.DRAG_FROM_DOCK && deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
      if (!dragItemInfo.area) {
        dragItemInfo.area = [1, 1];
      }
      if (dragItemInfo.page !== pageIndex) {
        dragItemInfo.page = pageIndex;
      }
    }

    if (this.getDragFormTypes().includes(dragItemType)) {
      if (dragItemInfo.typeId !== CommonConstants.TYPE_CARD) {
        dragItemInfo.typeId = CommonConstants.TYPE_CARD;
      }
      if (dragItemInfo.page !== pageIndex) {
        dragItemInfo.page = pageIndex;
      }
    }
    if (!dragItemInfo.area) {
      let dragItemArea: number[] | undefined = this.getDragItemArea(dragItemInfo);
      if (!dragItemArea) {
        log.showError('dragItemInfo has no area');
        return false;
      } else {
        dragItemInfo.area = dragItemArea;
      }
    }
    return this.onDragMoveSqueeze(x, y, dragItemInfo, pageIndex, dragItemType, isDragItemSmallFolder, deviceType ?? '');
  }

  public getDragDelegate(): CellLayoutDragDelegate | undefined {
    if (editModeManager.isInEditMode()) {
      let coordinates = EditModeUtils.getCoordinates()[0];
      let count: number = PageInfoManager.getInstance().getDisplayCount();
      if (RTLUtil.isRTL()) {
        coordinates = EditModeUtils.getCoordinates()[count - 1 - this.getCurrentPageIndex() % count];
      } else {
        coordinates = EditModeUtils.getCoordinates()[this.getCurrentPageIndex() % count];
      }
      if (this.mGridConfig) {
        return this.generateDragDelegate(coordinates[0], coordinates[1],
          coordinates[2] / this.mGridConfig.column, coordinates[3] / this.mGridConfig.row);
      }
      return undefined;
    }
    let paddingTop: number = this.mPaddingTop;
    let paddingLeft: number = this.mPaddingLeft;
    if (this.isSuperFold) {
      const paddings: number[] = this.uniquePaddingForSuperFold();
      paddingTop = paddings[0];
      paddingLeft = paddings[1];
    }
    paddingLeft = this.initFolderPaddingLeftForTrifold(paddingLeft);
    return this.generateDragDelegate(paddingLeft, paddingTop, this.mGridItemWidth, this.mGridItemHeight );
  }

  private initFolderPaddingLeftForTrifold(paddingLeft: number): number {
    if (!DeviceHelper.isThreeFoldProduct()) {
      return paddingLeft;
    }
    if (DeviceHelper.isFState()) {
      return this.mPaddingLeft;
    }
    return this.mPaddingLeft;
  }

  private uniquePaddingForSuperFold(): number[] {
    let paddingTop: number = 0;
    let paddingLeft: number = 0;
    if (this.isPortrait) {
      if (this.dragPageIndex & 1) {
        paddingTop = this.isExpandStatus ? this.mPageDesktopStyleConfig.mWorkSpaceHeight :
          this.mPageDesktopStyleConfig.mWorkSpaceHeight +
          this.mPageDesktopViewModel.getPageDesktopStyleConfig().mFoldCreaseRegionHeight;
      }
      if (this.mPageDesktopViewModel.getKeyBoardStatus() === FeatureConstants.KEYBOARD_PAGE_C) {
        paddingTop = this.mPaddingTop;
      }
    } else {
      if (RTLUtil.isRTL()) {
        paddingLeft = (this.dragPageIndex & 1) ? this.mPaddingLeft :
          this.mPaddingLeft + this.mPageDesktopStyleConfig.mWorkSpaceWidth;
      } else {
        paddingLeft = (this.dragPageIndex & 1) ?
          this.mPaddingLeft + this.mPageDesktopStyleConfig.mWorkSpaceWidth : this.mPaddingLeft;
      }
    }
    return [paddingTop, paddingLeft];
  }

  private generateDragDelegate(left: number, top: number, width: number, height: number): CellLayoutDragDelegate {
    return new CellLayoutDragDelegate(left, top,
      this.mGridConfig?.row ?? 0, this.mGridConfig?.column ?? 0, width, height,
      this.mPageDesktopStyleConfig.mRowsGap, this.mPageDesktopStyleConfig.mColumnsGap);
  }

  private onDragMoveSqueeze(x: number, y: number, dragItemInfo: GridLayoutItemInfo | undefined, pageIndex: number,
    dragItemType: number, isDragItemSmallFolder: boolean, deviceType: string): boolean {
    if (!dragItemInfo || !dragItemInfo.area) {
      return false;
    }
    if (this.isLockedLayout(pageIndex, dragItemInfo.page ?? 0, dragItemType)) {
      return false;
    }
    let dragDelegate: CellLayoutDragDelegate | undefined = this.getDragDelegate();
    if (!dragDelegate) {
      return false;
    }
    this.cellAndSpan = new CellAndSpan(x, y, dragItemInfo.area[0], dragItemInfo.area[1]);
    let result: number[] = this.getNearestArea(dragDelegate, this.cellAndSpan);
    if (dragItemInfo.typeId !== CommonConstants.TYPE_CARD &&
      dragItemInfo.typeId !== CommonConstants.TYPE_REGION_FOLDER) {
      this.updateDragEndPosition(result, x, y);
    }
    this.mEndPosition = {
      page: this.getCurrentPageIndex(),
      row: result[1],
      column: result[0],
      originColumn: result[2] ?? result[0],
      x: x,
      y: y
    };
    let itemInfo = this.getItemByPosition(this.mEndPosition);
    if (itemInfo) {
      this.updateCoverItemInfo(itemInfo);
    }
    const targetIndex: number = this.getIndexByPosition(result[1], result[0]);
    if (itemInfo && this.canCover(x, y, dragItemInfo, itemInfo) && this.needToCover(itemInfo) &&
      !lockLayoutManager.isLockLayout()) {
      if (LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
        this.resetSqueezeStatus();
        this.handleFallItemAnimation(false);
        return false;
      }
      if (GridLayoutUtil.checkGridItemEqual(this.coveredItem, itemInfo)) {
        return false;
      }
      const findDragItems: GridLayoutItemInfo[] | undefined = this.getDragItems();
      if (findDragItems && findDragItems.length > 1) {
        dragItemInfo = findDragItems.find(item => item.typeId === CommonConstants.TYPE_FILE_FOLDER) ?? dragItemInfo;
      }
      if (!this.isPc) {
        this.resetSqueezeTimeout();
        this.clearLastCoveredItemAnimation();
      } else {
        this.resetSqueezeStatus();
      }
      this.coveredItemAnimation(dragItemInfo, itemInfo);
      this.handleFallItemAnimation(false);
    } else {
      if (lockLayoutManager.isLockLayout()) {
        this.handleFallItemAnimation(!GridLayoutUtil.isValidLayoutItem(itemInfo));
        return false;
      }
      if (this.isDragInCentral(y)) {
        this.handleFallItemAnimation(true, y);
        return false;
      }
      if (!this.shouldSqueeze(targetIndex, itemInfo)) {
        return false;
      }
      // 云端2底部元素是预制元素，不挤位
      if (LightOutdoorConfig.getInstance().isOnLightOutdoorMode() &&
        !desktopItemDraggableManager.isItemDraggable(itemInfo as Object as GridLayoutItemInfo)) {
        this.resetSqueezeStatus();
        this.handleFallItemAnimation(!GridLayoutUtil.isValidLayoutItem(itemInfo));
        log.showInfo('onLightOutdoorMode under preItem no need to squeeze');
        return false;
      }

      if (!this.zSqueeze && (dragItemInfo.typeId === CommonConstants.TYPE_CARD ||
        dragItemInfo.typeId === CommonConstants.TYPE_REGION_FOLDER)) {
        this.computeCardSqueeze(dragDelegate);
        const isShowFallItemAnimation: boolean = this.isSqueezeSuccess || (this.isSuperFold && this.isLeaveSwiperPage);
        this.handleFallItemAnimation(isShowFallItemAnimation, y);
        this.isSqueezeSuccess = false;
        return true;
      }
      if (!itemInfo) {
        this.resetSqueezeStatus();
        this.handleFallItemAnimation(true);
        this.squeezeIndex = targetIndex;
        this.textAnnouncedForDragMove(undefined, dragItemInfo, dragDelegate, this.cellAndSpan);
        log.showInfo('no need to squeeze, index: %{public}d', targetIndex);
        return false;
      }
      const callback: Function = () => {
        if (!dragItemInfo || !itemInfo || !dragDelegate) {
          return;
        }
        this.squeezeInHotArea(dragItemInfo, itemInfo, dragDelegate, dragItemType, targetIndex);
      };
      this.setSqueezeTimeout(targetIndex, callback);
    }
    this.mLastPosition = this.mEndPosition;
    return true;
  }

  private needToCover(itemInfo: GridLayoutItemInfo): boolean {
    let typeNeedToCover: boolean = itemInfo.typeId === CommonConstants.TYPE_CARD ||
      itemInfo.typeId === CommonConstants.TYPE_FORM_STACK;
    return !launcherStatusUtil.getShowOutLauncherStatus() || typeNeedToCover;
  }

  private textAnnouncedForDragMove(itemInfo: GridLayoutItemInfo | undefined, dragItemInfo: GridLayoutItemInfo,
    dragDelegate: CellLayoutDragDelegate, cellAndSpan: CellAndSpan): void {
    if (!this.mEndPosition) {
      return;
    }
    if (DragAccessibilityUtils.isAccessibilityMode()) {
      this.finallyFallPosition = [this.mEndPosition.row + 1, this.mEndPosition.column + 1];
      let currentIndex: number[] = [this.mEndPosition.row + 1, this.mEndPosition.column + 1];
      // 获取挤位失败时，最终落点
      if (this.currentMoveItemList.length === 0 && itemInfo != null && !this.isPc) {
        let tempLocation: number[] = [-1, -1];
        let direction: number[] = [0, 0];
        // 获取当前页上不含拖拽元素的元素集合，当前拖拽元素的原位置应该算为空位
        const currentPageLayoutInfo = this.getCurrentPageLayoutInfo(dragItemInfo);
        let gridOccupyStatus: GridOccupyStatus = dragDelegate.getGridOccupyStatus(currentPageLayoutInfo);
        cellAndSpan.setCellX(this.mEndPosition.column);
        cellAndSpan.setCellY(this.mEndPosition.row);
        let res = dragDelegate.findNearestAreaTwo(cellAndSpan, direction, gridOccupyStatus, null, tempLocation);
        this.finallyFallPosition = [res[1] + 1, res[0] + 1];
      }
      this.updateColumnInFoldRight();
      this.textAnnounced(currentIndex);
    }
  }

  private textAnnounced(currentIndex: number[]): void {
    // 如果没有播报合并文件夹/堆叠或进入文件夹/堆叠，则进行拖动位置的播报
    if (this.finallyFallPosition[0] > 0 && this.finallyFallPosition[1] > 0 && !this.coveredIsOtherItem) {
      DragAccessibilityUtils.textAnnouncedForDragMoveToDesktop(this.finallyFallPosition, currentIndex);
    }
  }

  /**
   * 如果是落位到折叠屏展开态的右屏，column需要更新
   */
  private updateColumnInFoldRight(): void {
    if (this.isFoldNearScreen) {
      this.finallyFallPosition[1] += LaunchLayoutCacheManager.getInstance().selectLayoutDescription().column;
    }
  }

  /**
   * 获取应用名
   * @param itemInfo 应用信息
   * @returns 应用名
   */
  private getAppName(itemInfo: GridLayoutItemInfo): string {
    let dragAppname: string = '';
    // 一键锁屏卡使用别名，播报需要适配
    if (itemInfo.bundleName === CommonConstants.SCENEBOARD_BUNDLE) {
      dragAppname = ResourceManager.getInstance().getStringByName('lock_screen');
    } else {
      IconResourceManager.getInstance().getAppNameWithCallback(itemInfo.appLabelId, itemInfo.bundleName,
        itemInfo.moduleName, itemInfo.appName, (name: string) => {
          dragAppname = name;
        }, itemInfo.appIndex);
    }
    return dragAppname;
  }

  private squeezeInHotArea(dragItemInfo: GridLayoutItemInfo, itemInfo: GridLayoutItemInfo,
    dragDelegate: CellLayoutDragDelegate, dragItemType: number, index: number): void {
    const isDrag: boolean = AppStorage.get<boolean>('isDrag') as boolean;
    if (!isDrag) {
      log.showWarn('no need to squeeze, isDrag: %{public}s', isDrag);
      return;
    }
    let x: number = this.cellAndSpan.getCellX();
    let y: number = this.cellAndSpan.getCellY();
    this.dragEndItemIndex = index;
    if (!this.zSqueeze) {
      this.squeezeForPC(dragItemInfo, itemInfo, x, y, dragDelegate, this.cellAndSpan, dragItemType);
    } else {
      if ((GridLayoutUtil.isIconType(dragItemInfo.typeId) || GridLayoutUtil.isSmallFolder(dragItemInfo)) &&
        (GridLayoutUtil.isIconType(itemInfo.typeId) || GridLayoutUtil.isSmallFolder(itemInfo))) {
        if (!this.hasEnoughArea() && this.lastFoldStatus) {
          this.multiItemSqueeze(dragDelegate, dragItemInfo, this.cellAndSpan, true);
        } else {
          this.appDragMove(x, y, this.coverItemWidth, dragItemType);
        }
      } else {
        this.multiItemSqueeze(dragDelegate, dragItemInfo, this.cellAndSpan);
      }
    }

    if (this.isSqueezeSuccess) {
      this.handleFallItemAnimation(true);
      this.isSqueezeSuccess = false;
      this.moveList.clear();
      this.currentMoveItemList.forEach(item => this.moveList.add(this.getItemEventKey(item)));
      log.showWarn('squeeze success, index: %{public}d', index);
    } else {
      this.resetMoveItemList();
      this.resetLastMoveItemList();
      this.handleFallItemAnimation(false);
      log.showWarn('squeeze fail, unable to find solution');
    }

    // 无障碍朗读，拖动过程中，落位位置无应用和文件夹的播报
    this.textAnnouncedForDragMove(itemInfo, dragItemInfo, dragDelegate, this.cellAndSpan);
  }

  /**
   * 拖拽完成后，重置桌面元素挤位状态，删除空白页
   */
  public resetPageDesktopStatus(): void {
    this.resetSqueezeStatus();
    this.coverItem = new GridLayoutItemInfo();
    this.coveredItem = new GridLayoutItemInfo();
  }

  private judgeSqueezeExcludeCard(dragItemInfo: GridLayoutItemInfo | undefined, itemInfo: GridLayoutItemInfo | undefined): boolean {
    return !(dragItemInfo !== undefined && (dragItemInfo.typeId === CommonConstants.TYPE_APP || dragItemInfo.typeId === CommonConstants.TYPE_FILE_FOLDER ||
      dragItemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) && itemInfo !== undefined &&
      ((itemInfo.typeId === CommonConstants.TYPE_APP && dragItemInfo.keyName !== itemInfo.keyName) ||
        (itemInfo.typeId === CommonConstants.TYPE_FILE_FOLDER && dragItemInfo.ino !== itemInfo.ino) ||
        (itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON && dragItemInfo.shortcutId !== itemInfo.shortcutId)) &&
      itemInfo.typeId !== CommonConstants.TYPE_CARD);
  }

  private reSqueezeOnDropForPC(squeezeData: SqueezeData): void {
    let x: number = squeezeData.x;
    let y: number = squeezeData.y;
    let dragDelegate: CellLayoutDragDelegate | undefined = squeezeData.dragDelegate;
    let dragItemInfo: GridLayoutItemInfo | undefined = squeezeData.dragItemInfo;
    let cellAndSpan: CellAndSpan | undefined = squeezeData.cellAndSpan;
    let itemInfo: GridLayoutItemInfo | undefined = squeezeData.itemInfo;
    let isSamePlace: boolean = squeezeData.isSamePlace;
    let dragItemType: number = squeezeData.dragItemType;
    if (!dragItemInfo) {
      return;
    }
    if (dragItemInfo.typeId === CommonConstants.TYPE_CARD) {
      if (!dragDelegate) {
        return;
      }
      this.computeCardSqueeze(dragDelegate);
      return;
    }
    // 当拖动图标（包含应用、文件、文件夹、图片、FA卡片），并且拖动到的位置下面不为FA卡片时，才会计算热区进行挤位
    if (this.judgeSqueezeExcludeCard(dragItemInfo, itemInfo)) {
      if (!dragDelegate || !cellAndSpan) {
        return;
      }
      this.squeezeExcludeCard(x, y, itemInfo, dragDelegate, dragItemInfo, cellAndSpan);
      return;
    }
    log.showDebug('under appItem or calculate hot area');
    if (!GridLayoutUtil.checkGridItemEqual(this.coveredItem, itemInfo)) {
      // not in hot area, then squeeze
      this.clearLastCoveredItemAnimation();
      if (this.listElementTypeForPC().includes(dragItemInfo.typeId ?? -1)) {
        // 获取当前拖拽元素的位置所在的元素index
        this.dragEndItemIndex = this.getIndexByRowAndColumn(this.mEndPosition?.row ?? 0, this.mEndPosition?.column ?? 0);
        if (this.lastMovePageIndex === this.mEndPosition?.page && this.lastMoveItemIndex === this.dragEndItemIndex) {
          log.showInfo('not squeeze, keep shake');
          return;
        }
        let dragItemTypeId = this.getItemByIndex(this.dragEndItemIndex)?.typeId;
        if (this.listElementTypeForPC().includes(dragItemTypeId ?? -1)) {
          this.itemMoveNSqueeze(x, y, this.coverItemHeight, dragItemType);
        }
      }
    }
  }

  private multiReSqueezeOnDropForPC(squeezeData: SqueezeData): void {
    try {
      let x: number = squeezeData.x;
      let y: number = squeezeData.y;
      let dragItemType: number = squeezeData.dragItemType;
      log.showDebug('multiReSqueezeOnDropForPCin');
      this.itemMoveReNSqueeze(x, y, dragItemType);
    } catch (e) {
      log.error('multiReSqueezeOnDropForPC fail', e);
    }
  }

  private squeezeExcludeCard(x: number, y: number, itemInfo: GridLayoutItemInfo | undefined, dragDelegate: CellLayoutDragDelegate,
    dragItemInfo: GridLayoutItemInfo | undefined, cellAndSpan: CellAndSpan): void {
    this.clearLastCoveredItemAnimation();
    this.updateLastPosition();

    if (itemInfo === undefined) {
      log.showDebug('reset state4');
      this.resetMoveItemList();
      this.resetLastMoveItemList();
    } else if (itemInfo.typeId === CommonConstants.TYPE_CARD) {
      log.showInfo('desktop drag app item in card ' + itemInfo?.bundleName);
      this.resetMoveItemList();
      this.resetLastMoveItemList();
    }
  }

  private squeezeForPC(dragItemInfo: GridLayoutItemInfo, itemInfo: GridLayoutItemInfo, x: number, y: number,
    dragDelegate: CellLayoutDragDelegate, cellAndSpan: CellAndSpan, dragItemType: number): boolean {
    log.showInfo(`desktop drag squeeze isLeaveSwiperPage ${this.isLeaveSwiperPage}, squeeze item appName ${itemInfo?.appName},
      bundleName ${itemInfo.bundleName}, ino ${itemInfo?.ino}, infoId ${itemInfo?.infoId}, typeId ${itemInfo.typeId}`);
    if (this.isLeaveSwiperPage) {
      return false;
    }
    if (this.judgeSqueezeExcludeCard(dragItemInfo, itemInfo)) {
      this.squeezeExcludeCard(x, y, itemInfo, dragDelegate, dragItemInfo, cellAndSpan);
    } else {
      this.startToSqueeze(x, y, itemInfo, dragItemType, this.coverItemHeight);
    }
    return true;
  }

  private startToSqueeze(x: number, y: number, itemInfo: GridLayoutItemInfo | undefined, dragItemType: number, height: number): boolean {
    log.showDebug('startToSqueeze');
    // 获取当前拖拽元素的位置所在的元素index
    this.dragEndItemIndex = this.getDragEndPositionIndex(x, y);
    let dragItemTypeId = this.getItemByIndex(this.dragEndItemIndex)?.typeId ?? -1;
    // 多选元素不挤位
    if (this.listElementTypeForPC().includes(dragItemTypeId) && this.pcMultiDragCount === 1) {
      this.itemMoveNSqueeze(x, y, height, dragItemType);
    }
    return true;
  }

  private changeToExpandDragDelegate(dragDelegate: CellLayoutDragDelegate): CellLayoutDragDelegate {
    if (!this.isSuperFold || !this.isExpandStatus || !this.mGridConfig) {
      return dragDelegate;
    }
    let row: number = this.mGridConfig.row;
    let column: number = this.mGridConfig.column;
    let width: number = this.mGridItemWidth;
    let height: number = this.mGridItemHeight;
    if (this.isPortrait) {
      row = row * 2;
      height = height * 2;
    } else {
      column = column * 2;
      width = width * 2;
    }
    const paddings: number[] = this.uniquePaddingForSuperFold();
    return new CellLayoutDragDelegate(paddings[1], paddings[0], row, column, width, height,
      this.mPageDesktopStyleConfig.mRowsGap, this.mPageDesktopStyleConfig.mColumnsGap);
  }

  private computeCardSqueeze(dragDelegate: CellLayoutDragDelegate): boolean {
    if (this.isLeaveSwiperPage) {
      return false;
    }
    let position: DragGridPosition = { row: this.mEndPosition?.row ?? 0, column: this.mEndPosition?.column ?? 0,
      page: this.mEndPosition?.page ?? -1 };
    if (this.isSuperFold && this.isExpandStatus) {
      position = GridLayoutUtil.changeDragGridPositionToExpand(position, this.isPortrait, this.mGridConfig?.row ?? 0,
        this.mGridConfig?.column ?? 0);
    }
    let moveItems: MoveItem[] = CardSqueezer.getInstance(this.singleContext).getSolution(this.changeToExpandDragDelegate(dragDelegate), position);
    let moveItemsMap: Map<string, MoveItem> = new Map();
    moveItems.forEach((item: MoveItem) => moveItemsMap.set(this.getItemEventKey(item), item));

    this.lastMoveItemList.forEach((last: MoveItem) => {
      let itemKey: string = this.getItemEventKey(last);
      if (!moveItemsMap.has(itemKey)) {
        this.resetMoveItem(last);
      } else {
        let cur: MoveItem | undefined = moveItemsMap.get(itemKey);
        if (cur) {
          cur.isRepeatItem = last.row === cur.row && last.column === cur.column;
        }
      }
    });

    this.currentMoveItemList = moveItems;
    this.currentMoveItemList.forEach(item => {
      if (!item.isRepeatItem) {
        DragEventManager.getInstance(launcherStatusUtil.getShowOutLauncherStatus()).startSqueezedInDesktop(this.getItemEventKey(item), item.position);
      }
    });
    this.lastMoveItemList = Array.from(this.currentMoveItemList);
    this.isSqueezeSuccess = CardSqueezer.getInstance(this.singleContext).getSqueezeSuccess();
    return this.isSqueezeSuccess;
  }

  private itemMoveNSqueeze(x: number, y: number, itemHeight: number, dragItemType: number): void {
    log.showDebug('in itemMoveNSqueeze');
    // if finger doesn't change, don't shake again.
    if (CheckEmptyUtils.isEmpty(this.dragEndItemIndex) || !this.mEndPosition || itemHeight === -1) {
      log.showInfo('itemMoveNSqueeze: dragEndItem is invalid');
      return;
    }
    // fingers not hovering
    let centerY = this.getPositionByRowAndColumn(this.mEndPosition.row, this.mEndPosition.column)[1];
    let isSqueezeBackwards = centerY + itemHeight / NUM_HALF > y ? true : false;
    // calculate item position
    this.computeAppItemNSqueezed(isSqueezeBackwards, x, y, dragItemType);
    this.lastMoveItemIndex = this.dragEndItemIndex;
    this.lastMovePageIndex = this.mEndPosition.page;
  }

  private itemMoveReNSqueeze(x: number, y: number, dragItemType: number): void {
    log.showDebug('in itemMoveReNSqueeze');
    if (CheckEmptyUtils.isEmpty(this.dragEndItemIndex) || !this.mEndPosition) {
      log.showInfo('itemMoveNSqueeze: dragEndItem is invalid');
      return;
    }
    this.computeAppItemReNSqueezed(true, x, y, dragItemType);
    this.lastMoveItemIndex = this.dragEndItemIndex;
    this.lastMovePageIndex = this.mEndPosition.page;
  }

  private listElementTypeForPC(): number[] {
    return [CommonConstants.TYPE_APP, CommonConstants.TYPE_CARD, CommonConstants.TYPE_FILE_FOLDER,
      CommonConstants.TYPE_SHORTCUT_ICON];
  }

  public notifyIntelligentDragEnter(): void {
    const isDrag: boolean = AppStorage.get('isDrag') as boolean;
    if (!isDrag) {
      log.showDebug('enter intelligent not in drag mode');
      return;
    }
    const dragItemInfo: GridLayoutItemInfo | undefined = this.getSingleDragItemInfo();
    let moveY: number = 0;
    if (this.mEndPosition) {
      moveY = this.mEndPosition.y;
    }
    localEventManager.sendLocalEvent(EventConstants.EVENT_INTELLIGENT_CARD_DRAG_ENTER, {
      'id': dragItemInfo?.negativeId,
      'moveY': moveY.toString()
    });
  }

  private isValidArea(area: number[]): boolean {
    return !CheckEmptyUtils.isEmpty(area) && area.length === 2;
  }

  /**
   * If multiple items are involved in this squeeze, use this method
   *
   * @param dragDelegate  squeeze solution
   * @param dragItemInfo  drag item
   * @param cellAndSpan  the layout of current page
   * @param isDualSqueeze 是否是跨屏挤位
   */
  private multiItemSqueeze(dragDelegate: CellLayoutDragDelegate, dragItemInfo: GridLayoutItemInfo,
    cellAndSpan: CellAndSpan, isDualSqueeze: boolean = false): void {
    if (!dragItemInfo || !dragDelegate || !cellAndSpan) {
      log.showError('dragDelegate or dragItemInfo or cellAndSpan invalid');
      return;
    }
    if (this.mBigFolderViewModel.getFolderAnimationCount() !== 0) {
      log.showInfo('inFolderAnimation, multiItemSqueeze interrupt');
      return;
    }
    let curPageSqueezeItems: GridLayoutItemInfo[] = this.getPageLayoutInfo(this.mEndPosition?.page ?? 0);

    if (!this.isPc) {
      const iconSize = LayoutViewModel.getInstance().calculateDesktop().mIconSize;
      dragDelegate.recordIconSize(iconSize);
    }
    // calculate all items squeeze direction
    dragDelegate.getDirectionVectorForDrop(cellAndSpan, dragItemInfo, curPageSqueezeItems);
    // get all items squeeze solution
    let translateViews = dragDelegate.getReorderSolution(cellAndSpan, dragItemInfo, curPageSqueezeItems);
    if (this.lastFoldStatus && (!dragDelegate?.isReArrangeSolutionSuccess() || isDualSqueeze)) {
      log.showDebug(`isReArrangeSolutionSuccess: ${dragDelegate?.isReArrangeSolutionSuccess()}}`);
      // 折叠屏展开态 且 单屏挤位失败，尝试双屏挤位
      translateViews = this.tryFoldExpandDualSqueezed(dragDelegate, dragItemInfo, cellAndSpan, curPageSqueezeItems);
    } else {
      this.isNearReArrangeSolutionSuccess = false;
    }
    if (!translateViews) {
      log.showError('translateViews invalid');
      return;
    }
    if (dragDelegate.isReArrangeSolutionSuccess() && !CheckEmptyUtils.isEmpty(translateViews)) {
      log.showDebug('start to computeMultiItemSqueezed..');
      this.computeMultiItemSqueezed(translateViews);
    }
  }

  private getCurrentPageLayoutInfo(dragItemInfo: GridLayoutItemInfo): GridLayoutItemInfo[] {
    let pageIndex: number = this.getCurrentPageIndex();
    let layoutInfo = this.mLayoutCacheManager.selectGridLayoutItemsByPage(pageIndex);
    return layoutInfo.filter((value: GridLayoutItemInfo) => !this.judgeItem(value, dragItemInfo));
  }

  private getPageLayoutInfo(pageIndex: number): GridLayoutItemInfo[] {
    const layoutInfo = this.mLayoutCacheManager.selectGridLayoutItemsByPage(pageIndex);
    const dragItemInfoList: GridLayoutItemInfo[] = this.getDragItems() ?? [];
    const dragItemSet = new Set<string>();
    dragItemInfoList.forEach((dragItemInfo: GridLayoutItemInfo) => {
      dragItemSet.add(GridLayoutUtil.generateUniqueKey(dragItemInfo));
    });
    return layoutInfo.filter((value: GridLayoutItemInfo) => !dragItemSet.has(GridLayoutUtil.generateUniqueKey(value)));
  }

  private isTwoItemOverlap(rectX: RectItem, rectY: RectItem): boolean {
    return !(rectY.bottom < rectX.top || rectX.bottom < rectY.top || rectX.left > rectY.right || rectY.left > rectX.right);
  }

  // 更新waterfallListInfo中位置信息
  private updatePosition(waterfallListInfo: GridLayoutItemInfo[], dragItemInfo: GridLayoutItemInfo,
    result: number[]): void {
    for (let layout of waterfallListInfo) {
      if ((layout.typeId === 0 && layout.keyName === dragItemInfo.keyName) ||
        (layout.cardId !== undefined && layout.cardId === dragItemInfo.cardId) ||
        (layout.folderId !== undefined && layout.folderId === dragItemInfo.folderId)) {
        layout.row = result[1];
        layout.column = result[0];
        layout.page = CommonConstants.WATERFALL_PAGE_INDEX;
        log.showInfo('appItem dragItemInfo: bundleName: %{public}s, keyName: %{public}s, moduleName: %{public}s',
          dragItemInfo.bundleName, dragItemInfo.keyName, dragItemInfo.moduleName);
        log.showInfo('appItem layout: column: %{public}d, row: %{public}d, page: %{public}d', layout.column, layout.row, layout.page);
      }
    }
  }

  /**
   * reset all current move items translation
   */
  private resetMoveItemList(): void {
    log.showDebug('in resetMoveItemList..');
    this.currentMoveItemList?.forEach((item) => {
      DragEventManager.getInstance(launcherStatusUtil.getShowOutLauncherStatus()).cancelSqueezedInDesktop(this.getItemEventKey(item),
        this.hasCancelSqueezeAnimation);
    });
    this.currentMoveItemList = [];
    this.moveList.clear();
    this.isStartToSqueeze = false;
  }

  private resetLastMoveItemList(): void {
    log.showDebug('in resetLastMoveItemList..');
    this.lastMoveItemList?.forEach((item) => {
      DragEventManager.getInstance(launcherStatusUtil.getShowOutLauncherStatus()).cancelSqueezedInDesktop(this.getItemEventKey(item),
        this.hasCancelSqueezeAnimation);
    });
    this.lastMoveItemList = [];
  }

  /**
   * update item position (if squeeze list exist, update squeeze position)
   *
   * @param fallItem  dragItem
   */
  private updateMoveList(fallItemData: DragItem): void {
    if (!this.isPc && this.currentMoveItemList.length === 0) {
      return;
    }
    let updateLayoutInfo: GridLayoutItemInfo[] = [];
    let curPage: number = this.getCurrentPageIndex();
    this.currentMoveItemList.forEach((value: MoveItem) => {
      let gridItem: GridLayoutItemInfo = value as Object as GridLayoutItemInfo;
      updateLayoutInfo.push(gridItem);
      this.showSqueezeContinueItem(gridItem, curPage);
      Cache2RdbHelper.getInstance().addItem(CommonConstants.DRAG_RDB_EVENT, gridItem);
    });
    if (this.isSuperFold && this.isLeaveSwiperPage) {
      curPage = fallItemData.result[2] ?? curPage;
    }
    log.showInfo(`desktop drag isDragPaste: ${this.isDragPaste}, pcMultiDragCount: ${this.pcMultiDragCount}, currentMoveItemList length: ${this.currentMoveItemList.length}`);
    if (!this.isDragPaste && this.isPc && this.pcMultiDragCount === 1 && fallItemData?.data?.uri !== CommonConstants.MOCK_URI) {
      const item: GridLayoutItemInfo = this.getNewDragItemInfo(fallItemData.data as GridLayoutItemInfo, fallItemData.result, curPage);
      updateLayoutInfo.push(item);
      Cache2RdbHelper.getInstance().addItem(CommonConstants.DRAG_RDB_EVENT, item);
      const data = fallItemData.data;
      log.showInfo(`desktop drag fallItemData detail: app: ${data?.appName}, infoId:${data?.infoId}, ino:${data?.ino}, typeId:${data?.typeId},
        from page:${data?.page}, column: ${data?.column}, row:${data?.row},
        to page:${item?.page}, column: ${item?.column}, row:${item?.row}`);
    }
    this.mLayoutCacheManager.updateGridLayoutItemsPositionById(updateLayoutInfo, BusinessType.BUSINESS_DRAG, true,
      false, launcherStatusUtil.getShowOutLauncherStatus());
    this.resetMoveItemList();
  }

  private calculateEmptyCount(fallItemData: DragItem): void {
    if (!this.mGridConfig) {
      return;
    }
    try {
      let startIndex: number = (fallItemData.result[0] + 1) * this.mGridConfig.row -
        (this.mGridConfig.row - fallItemData.result[1] - 1) - 1;
      let endIndex: number = this.mGridConfig.row * this.mGridConfig.column;
      let emptyCount: number = 0;
      let continueEmptyCount: number = 0;
      this.isContinue = true;
      this.multiDragItems = [];
      for (let i = startIndex; i < endIndex; i++) {
        let thisItem = this.getItemByIndex(i);
        if (emptyCount < this.pcMultiDragCount) {
          let itemRow = i % this.mGridConfig.row;
          let itemColumn = Math.floor(i / this.mGridConfig.row);
          this.multiDragItems.push([itemColumn, itemRow]);
        }
        if (CheckEmptyUtils.isEmpty(thisItem)) {
          emptyCount++;
          if (this.isContinue) {
            continueEmptyCount++;
          }
          continue;
        } else {
          this.isContinue = false;
        }
      }
      if (emptyCount === 0) {
        this.multiDragItems = [];
        for (let i = startIndex; i > 0; i--) {
          let thisItem = this.getItemByIndex(i);
          if (emptyCount < this.pcMultiDragCount) {
            let itemRow = i % this.mGridConfig.row;
            let itemColumn = Math.floor(i / this.mGridConfig.row);
            this.multiDragItems.push([itemColumn, itemRow]);
          }
          if (CheckEmptyUtils.isEmpty(thisItem)) {
            emptyCount++;
            if (this.isContinue) {
              continueEmptyCount++;
            }
            continue;
          } else {
            log.showInfo(`reverse direction break continuity index: ${i}`);
            this.isContinue = false;
          }
        }
      }
      this.enoughToConDrop = this.pcMultiDragCount === 1 || this.pcMultiDragCount < continueEmptyCount;
      log.showInfo(`emptyCount: ${emptyCount},startIndex: ${startIndex}, endIndex: ${endIndex}, continueEmptyCount: ${continueEmptyCount}, ` +
        `fallItemData.result[0]: ${fallItemData.result[0]}, fallItemData.result[1]: ${fallItemData.result[1]}, ` +
        `this.pcMultiDragFlag: ${this.pcMultiDragCount}`);
    } catch (error) {
      log.showError(`calculateEmptyCount error: ${error}`);
    }
  }

  private showSqueezeContinueItem(item: GridLayoutItemInfo, curPage: number): void {
    if (item.page !== curPage) {
      animationContinueManager.show(GridLayoutUtil.generateUniqueKey(item));
    }
  }

  /**
   * notify moveItem stop by eventHub
   *
   * @param item
   * @param moveItem
   */
  private resetMoveItem(moveItem: MoveItem): void {
    log.showDebug('in resetMoveItem... moveItem keyName: %{public}s, appName: %{public}s, cardId: %{public}s, folderId: %{public}s',
      moveItem.keyName, moveItem.appName, moveItem.cardId, moveItem.folderId);
    DragEventManager.getInstance(launcherStatusUtil.getShowOutLauncherStatus()).cancelSqueezedInDesktop(this.getItemEventKey(moveItem),
      this.hasCancelSqueezeAnimation);
  }

  private judgeItem(item: GridLayoutItemInfo | MoveItem, targetItem: GridLayoutItemInfo | MoveItem): boolean {
    return GridLayoutUtil.checkGridItemEqual(item as GridLayoutItemInfo, targetItem as GridLayoutItemInfo);
  }

  private notifyGridWhiteEdgeShow(pageIndex: number, dragTranslate: number[]): void {
    if (!this.mEndPosition) {
      return;
    }
    let endPosition = {
      page: this.mEndPosition.page,
      row: this.mEndPosition.row,
      column: this.mEndPosition.column,
      x: dragTranslate[0],
      y: dragTranslate[1]
    } as DragItemPosition;
    // 针对折叠屏需要重新计算落位框的x轴偏移
    let foldStatus: boolean = this.isFoldExpandStatus();
    let offset: number = foldStatus ? this.mPaddingLeft - this.mPageDesktopStyleConfig.mMargin : 0;
    let count: number = PageInfoManager.getInstance().getDisplayCount();
    if (RTLUtil.isRTL() && foldStatus) {
      if (pageIndex % count === Math.floor(pageIndex / count)) {
        offset = 0;
      } else if (pageIndex % count < Math.floor(pageIndex / count)) {
        offset += this.mPageDesktopStyleConfig.mFoldPaddingSide;
      } else {
        offset -= this.mPageDesktopStyleConfig.mFoldPaddingSide;
      }
    };
    if (this.isPc && this.dragPageIndex === 0) {
      endPosition.y = endPosition.y + this.mPageDesktopStyleConfig.mWorkSpaceMarginTop;
    }
    if (this.isSuperFold) {
      if (this.dragPageIndex & 1) {
        if (this.isPortrait) {
          endPosition.y = this.isExpandStatus ? endPosition.y - this.mPageDesktopStyleConfig.mWorkSpaceHeight
            : endPosition.y - this.mPageDesktopStyleConfig.mWorkSpaceHeight -
            this.mPageDesktopStyleConfig.mFoldCreaseRegionHeight;
        } else {
          endPosition.x = RTLUtil.isRTL() ? endPosition.x - this.mPageDesktopStyleConfig.mGridWidth :
            endPosition.x - this.mPageDesktopStyleConfig.mGridWidth - this.mPageDesktopStyleConfig.mWorkSpacePadding;
          endPosition.y = endPosition.y + this.mPageDesktopStyleConfig.mWorkSpaceMarginTop;
        }
      } else {
        if (RTLUtil.isRTL() && !this.isPortrait) {
          endPosition.x = endPosition.x - this.mPageDesktopStyleConfig.mWorkSpacePadding;
        }
      }
    }
    endPosition.x = endPosition.x - offset;
    (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub.emit(`rect${pageIndex}`, true, endPosition);
    if (foldStatus) {
      let neighborPage = this.getNeighborPageForWhiteBox(pageIndex);
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub.emit(`rect${neighborPage}`, false, null);
    }
    log.showInfo(`notifyGridWhiteEdgeShow end: ${endPosition.x},${endPosition.y}`)
  }

  private notifyGridWhiteEdgeHide(pageIndex: number): void {
    (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub.emit(`rect${pageIndex}`, false, null);
    let foldStatus: boolean = this.isFoldExpandStatus();
    if (foldStatus) {
      let neighborPage = this.getNeighborPageForWhiteBox(pageIndex);
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub.emit(`rect${neighborPage}`, false, null);
    }
  }

  private getNeighborPageForWhiteBox(pageIndex: number): number {
    return pageIndex % StyleConstants.DEFAULT_2 === 0 ? pageIndex + StyleConstants.DEFAULT_1 :
      pageIndex - StyleConstants.DEFAULT_1;
  }

  private getDragItemArea(dragItemInfo: GridLayoutItemInfo): number[] | undefined {
    if (dragItemInfo.area) {
      return dragItemInfo.area;
    }
    switch (dragItemInfo.typeId) {
      case CommonConstants.TYPE_APP:
      case CommonConstants.TYPE_SHORTCUT_ICON:
      case CommonConstants.TYPE_FILE_FOLDER:
        return [1, 1];
      case CommonConstants.TYPE_FOLDER:
        return [EXPONENT_OF_BASE_TWO, EXPONENT_OF_BASE_TWO];
      case CommonConstants.TYPE_CARD:
        return FormManager.getInstance().getCardSize(dragItemInfo.cardDimension);
    }
    return undefined;
  }

  private getOriginPosition(dragItemInfo: GridLayoutItemInfo): DragItemPosition {
    const position: DragItemPosition = {
      page: dragItemInfo.page ?? -1,
      column: dragItemInfo.column ?? 0,
      row: dragItemInfo.row ?? 0,
      x: 0,
      y: 0,
    };
    return position;
  }

  private handleDropWhenLayoutLocked(x: number, y: number, dragItem: GridLayoutItemInfo, dragType: number): void {
    this.clearLastCoveredItemAnimation();
    this.resetMoveItemList();
    this.resetLastMoveItemList();
    if (dragType === CommonConstants.DRAG_FROM_DESKTOP || dragType === CommonConstants.DRAG_FROM_APP_ICON ||
      dragType === CommonConstants.DRAG_FROM_DOCK) {
      this.animationToOriginalPos(x, y, dragItem);
    } else if (dragType === CommonConstants.DRAG_FROM_SHORTCUT) {
      let dragDelegate: CellLayoutDragDelegate = this.getDragDelegate() as CellLayoutDragDelegate;
      let startPage: number = layoutLockUtil.getLockedPageNum(launcherStatusUtil.getShowOutLauncherStatus());
      // 找位成功时刷新布局，执行落位动效
      if (this.updateDragItemPosition([0, 0], [dragItem], dragDelegate, startPage, false)) {
        this.animationToOriginalPos(x, y, dragItem);
        setTimeout(() => {
          localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
        }, DELAY_TIME_FIFTY);
      }
    } else if (this.getDragFormTypes().includes(dragType)) {
      this.handleCreateCardAfterDragDrop(x, y, dragItem, dragType);
    }
  }

  private animationToOriginalPos(x: number, y: number, dragItem: GridLayoutItemInfo): boolean {
    let screenOffset: number = AppStorage.get<number>('translateXForScreenSplit') ?? 0 as number;
    let start: DragPosition = { x: x, y: y };
    let end: DragPosition = { x: screenOffset, y: 0 };
    let cached: GridLayoutItemInfo | undefined = LaunchLayoutCacheManager.getInstance().selectGridLayoutItemByItem(dragItem);
    if (cached) {
      // 当前元素位于桌面
      let center: number[] = GridLayoutUtil.getIconCenterPosition(cached.row, cached.column, cached.area, cached.page);
      let screenWidth: number = AppStorage.get<number>('screenWidth') as number;
      screenWidth *= editModeManager.isInEditMode() ? EditModeUtils.calSwiperScale(screenWidth) : 1;
      screenWidth += editModeManager.isInEditMode() ? EditModeUtils.getPrevNextMargin() : 0;
      let curPage: number = this.getDragPageIndex();
      let screenSpan: number = GridLayoutUtil.isLargeFoldExpanded() ?
        Math.floor(curPage / NUM_HALF) - Math.floor((cached.page ?? 0) / NUM_HALF) : curPage - (cached.page ?? 0);
      end.x += center[0] - screenSpan * screenWidth;
      end.y += center[1];
    } else {
      // 当前元素位于dock栏
      const startPosition: DragItemPosition = AppStorage.get<DragItemPosition>('startPosition') as DragItemPosition;
      if (!startPosition) {
        return false;
      }
      end.x += startPosition.x;
      end.y += startPosition.y;
    }
    if (this.animationFunc) {
      this.animationFunc(start, end, dragItem);
    }
    return true;
  }

  /**
   * 获取落位的位置中心点
   *
   * @param dropToDock 是否返回dock区
   * @param isRealCenter 获取宫格真正中心点
   * @returns 落位位置的中心点
   */
  public getFallPosition(dropToDock: boolean, isRealCenter?: boolean): number[] | undefined {
    if (dropToDock) {
      const startPosition: DragItemPosition = AppStorage.get<DragItemPosition>('startPosition') as DragItemPosition;
      if (CheckEmptyUtils.isEmpty(startPosition)) {
        return undefined;
      }
      return [startPosition.x, startPosition.y];
    }
    const lastDragItem: DragItem = AppStorage.get<DragItem>('lastDragItem') as DragItem;
    if (CheckEmptyUtils.isEmpty(lastDragItem) || !lastDragItem.data) {
      return undefined;
    }
    AppStorage.set<DragItem>('lastDragItem', new DragItem());
    let dropPosition: number[] = this.getItemDropPosition(lastDragItem.data);
    log.showInfo(`getFallPosition dropX: ${dropPosition[0]}, dropY: ${dropPosition[1]} dropPage ${dropPosition[2]}`);
    let column = dropPosition[0] ?? lastDragItem.result[0];
    let row = dropPosition[1] ?? lastDragItem.result[1];
    let page = dropPosition[2] ?? this.getCurrentPageIndex();
    if (this.isSuperFold && this.mPageDesktopViewModel.getKeyBoardStatus() === FeatureConstants.KEYBOARD_PAGE_C) {
      // 折叠产品滑动到C面，实际显示效果替换为page 0
      page = 0;
    }
    log.showInfo(`getFallPosition row: ${row}, column: ${column} page ${page}`);
    return GridLayoutUtil.getIconCenterPosition(row, column, lastDragItem.data.area, page, this.isPortrait, isRealCenter);
  }

  private updateInstalledDragItemInfo(dragItemInfo: GridLayoutItemInfo, item: DockItemInfo | GridLayoutItemInfo): void {
    dragItemInfo.keyName = item.keyName;
    dragItemInfo.appStatus = item.appStatus;
    dragItemInfo.abilityName = item.abilityName;
    dragItemInfo.moduleName = item.moduleName;
    dragItemInfo.appName = item.appName;
    dragItemInfo.isUninstallAble = item.isUninstallAble;
    dragItemInfo.appLabelId = item.appLabelId;
    dragItemInfo.appIconId = item.appIconId;
    log.showInfo(`refresh dragItemInfo ${dragItemInfo.keyName}`);
  }

  private updateDragItemInfo(dragItemInfo: GridLayoutItemInfo, deviceType: string, dragItemType: number): void {
    log.showInfo('onDragDropFromDock unInstall app');
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    if (!residentList) {
      return;
    }
    for (let i = 0; i < residentList.length; i++) {
      let dockItemInfo: DockItemInfo = residentList[i];
      if (dockItemInfo.bundleName === dragItemInfo.bundleName && dockItemInfo.appStatus === AppStatus.INSTALLED) {
        this.updateInstalledDragItemInfo(dragItemInfo, dockItemInfo);
        break;
      } else {
        if (dockItemInfo.layoutInfo && this.updateDragItemInfoDockFolder(dockItemInfo.layoutInfo, dragItemInfo)) {
          break;
        }
      }
    }
  }

  private updateDragItemInfoDockFolder(layoutInfo: Array<GridLayoutItemInfo[]>, dragItemInfo: GridLayoutItemInfo): boolean {
    let result: boolean = false;
    if (!layoutInfo) {
      return result;
    }
    outer: for (let i = 0; i < layoutInfo.length; i++) {
      if (!layoutInfo[i]) {
        continue;
      }
      for (let j = 0; j < layoutInfo[i].length; j++) {
        let item: GridLayoutItemInfo = layoutInfo[i][j];
        if (item.bundleName === dragItemInfo.bundleName && item.appStatus === AppStatus.INSTALLED) {
          this.updateInstalledDragItemInfo(dragItemInfo, item);
          result = true;
          break outer;
        }
      }
    }
    return result;
  }

  onDragDrop(x: number, y: number, event?: DragEvent, extraParams?: string): DesktopDragResult {
    Trace.start(Trace.CORE_METHOD_DRAG_DROP);
    log.showInfo('desktop drag in onDragDrop');
    this.updateFoldRelatedStatus(x, y);
    this.clearSwipeTimeout();
    this.resetSqueezeTimeout();

    let dragResult: DesktopDragResult = new DesktopDragResult();
    let dragItems: GridLayoutItemInfo[] | undefined = this.getDragItems();
    if (dragItems) {
      this.pcMultiDragCount = dragItems.length;
      const cache2Rdb = Cache2RdbHelper.getInstance();
      dragItems.forEach(item => cache2Rdb.addItem(CommonConstants.DRAG_RDB_EVENT, item));
      log.showInfo(`dragItemInfoList: ${this.pcMultiDragCount}`);
    }
    if (dragItems == null || dragItems[0] == null) {
      log.showError('invalid drag item');
      return dragResult;
    }
    let dragItemInfo: GridLayoutItemInfo = dragItems[0];

    const dragItemType: number = AppStorage.get<number>('dragItemType') as number;
    this.recordDragStartPage(dragItems, dragItemType);

    log.showInfo('onDragDrop dragItemInfo: bundleName: %{public}s, keyName: %{public}s, moduleName: %{public}s',
      dragItemInfo.bundleName, dragItemInfo.keyName, dragItemInfo.moduleName);
    if (!GridLayoutUtil.isValidLayoutItem(dragItemInfo)) {
      Trace.end(Trace.CORE_METHOD_DRAG_DROP);
      return dragResult;
    }
    const deviceType: string = AppStorage.get<string>('device') as string;
    const pageIndex = this.getCurrentPageIndex();
    log.showWarn(`desktop drag onDragDrop pageIndex: ${pageIndex}`);

    //如果是从dock区拖拽出来的应用,且在拖拽过程中从未安装状态变成已安装成功的状态了，需要特殊处理
    if (dragItemInfo.appStatus !== AppStatus.INSTALLED && deviceType === CommonConstants.DEFAULT_DEVICE_TYPE &&
      (dragItemType === CommonConstants.DRAG_FROM_DOCK || dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK)) {
      this.updateDragItemInfo(dragItemInfo, deviceType, dragItemType);
    }

    // 如果是dock拖拽出来的文件夹，且在缩放状态，需要刷新截图
    if (SmartDockZoomFeatureSwitch.isSupportZoom() && dragItemType === CommonConstants.DRAG_FROM_DOCK &&
      dragItemInfo.typeId === CommonConstants.TYPE_FOLDER) {
      FolderImageRegister.getInstance().notifyImageRefreshByFolderId(dragItemInfo.bundleName);
    }

    //如果是从文件夹拖拽出来的应用,且在拖拽过程中从未安装状态变成已安装成功的状态了，需要特殊处理
    if (dragItemInfo.appStatus !== AppStatus.INSTALLED && deviceType === CommonConstants.DEFAULT_DEVICE_TYPE &&
      dragItemType === CommonConstants.DRAG_FROM_FOLDER) {
      this.updateDragItemInfoInFolder(dragItemInfo);
    }

    // 拖拽堆叠展开态卡片无效落位
    if (this.isFormStackInnerCardDropInvalid(dragItemType, dragItemInfo.typeId ?? -1)) {
      return dragResult;
    }
    // 判断快捷方式是否能加桌
    if (dragItemType === CommonConstants.DRAG_FROM_SHORTCUT &&
      !ShortcutViewModel.getInstance().canAddShortcutByDrag(dragItemInfo)) {
      return dragResult;
    }

    // 判断门店样机预制锁定布局
    const msg: string = 'drop on desktop';
    if (this.isLockedLayout(pageIndex, dragItemInfo.page ?? 0, dragItemType, msg)) {
      this.deleteBlankPageAddByDragging(dragItemType);
      if (dragItems.length === 1) {
        this.handleDropWhenLayoutLocked(x, y, dragItemInfo, dragItemType);
      } else {
        MultiSelectManager.getInstance().startDrop(x, y, pageIndex);
      }
      return dragResult;
    }

    // dock appInfo has no location information.
    if (dragItemType === CommonConstants.DRAG_FROM_DOCK && deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_LAYOUT_CHANGE_EVENT, null);
    }
    const dragFormTypes = this.getDragFormTypes();
    // 落位时需要直接取消当前正在进行的挤位动效，避免位置刷新后元素仍具有挤位偏移量
    this.hasCancelSqueezeAnimation = false;
    let desktopDragResult: DesktopDragResult = this.onDragDropFinal(x, y, dragItems, pageIndex, deviceType,
      dragItemType, dragResult, dragFormTypes, event, extraParams);
    this.coverItem = new GridLayoutItemInfo();
    this.coveredItem = new GridLayoutItemInfo();
    this.hasCancelSqueezeAnimation = true;
    return desktopDragResult;
  }


  private updateDragItemInfoInFolder(dragItemInfo: GridLayoutItemInfo): void {
    let cacheItemList =
      this.mFolderCacheManager.selectFolderByGenerateUniqueKey(GridLayoutUtil.generateUniqueKey(dragItemInfo));
    if (cacheItemList.length > 0 && cacheItemList[0] && cacheItemList[0].appStatus === AppStatus.INSTALLED) {
      this.updateInstalledDragItemInfo(dragItemInfo, cacheItemList[0]);
    }
  }

  private isLockedLayout(curPage: number, startPage: number, dragType: number, msg?: string): boolean {
    if (layoutLockUtil.isLockedPage(curPage, msg, true)) {
      return true;
    }
    if (layoutLockUtil.isLockedPage(startPage, msg, true) && (dragType === CommonConstants.DRAG_FROM_DESKTOP ||
      dragType === CommonConstants.DRAG_FROM_APP_ICON)) {
      return true;
    }
    if (layoutLockUtil.isLocked(msg) && dragType === CommonConstants.DRAG_FROM_DOCK) {
      return true;
    }
    return false;
  }

  private recordDragStartPage(dragItems: GridLayoutItemInfo[], dragItemType: number): void {
    let mDragStartPage = new Set(dragItems.filter(item => {
      //兼容卡片
      if (this.getDragFormTypes().includes(dragItemType)) {
        return false;
      }
      return typeof item.container === 'undefined' || item.container === CommonConstants.CONTAINER_DESKTOP;
    }).map(item => {
      if (this.mLayoutCacheManager.selectGridLayoutItemByItem(item)?.page == null) {
        return -1;
      } else {
        return this.mLayoutCacheManager.selectGridLayoutItemByItem(item)?.page;
      }
    }));
    this.dragStartPage = mDragStartPage as Set<number>;
    MultiSelectManager.getInstance().getSelectedItemSortByFolder().forEach((selectItems, selectFolder) => {
      this.dragStartPage.add(selectFolder.page as number);
    });
    log.showInfo(`recordDragStartPage dragStartPage ${Array.from(this.dragStartPage)}`);
    Cache2RdbHelper.getInstance().setChangedPage(CommonConstants.DRAG_RDB_EVENT, this.dragStartPage);
  }

  /**
   * 获取拖拽元素数组，适配多选拖拽场景
   *
   * @returns 拖拽元素数组
   */
  public getDragItems(): GridLayoutItemInfo[] | undefined {
    let dragObj: Object | undefined = AppStorage.get<Object>('dragItemInfo');
    if (!dragObj) {
      log.showError(`drop without drag item`);
      return undefined;
    }
    let dragItems: GridLayoutItemInfo[];
    if (Array.isArray(dragObj)) {
      if (dragObj.length === 0) {
        log.showError(`drop with empty drag array`);
        return undefined;
      }
      dragItems = dragObj as GridLayoutItemInfo[];
    } else {
      dragItems = [dragObj as GridLayoutItemInfo];
    }
    return dragItems;
  }

  private onCreaseRegionDrag(dropY: number, fallItemData: DragItem, dragItemInfo: GridLayoutItemInfo,
    dragResult: DesktopDragResult): DesktopDragResult {
    if (!this.isSuperFold) {
      log.showInfo('not super fold leave swiperPage, drop return');
      return dragResult;
    }
    const swiperPageIndex: number = this.mPageDesktopViewModel.getKeyBoardStatus();
    if (swiperPageIndex !== FeatureConstants.NO_KEYBOARD) {
      log.showInfo(`keyBoardStatus ${swiperPageIndex} leave swiperPage, drop return`);
      return dragResult;
    }
    dragResult.needDropAnimation = true;
    // B面拖拽到中轴区上，直接回弹
    let page: number = 0;
    const screenHalfHeight = LayoutViewModel.getInstance().getScreenHeight() / 2;
    log.showInfo(`${dragItemInfo?.bundleName} ${dragItemInfo?.ino} drop on creaseRegion height ${screenHalfHeight}`);
    const dragCreaseHalfHeight = this.mDragCreaseHeight / 2;
    if (dragItemInfo.page === 0 && dropY < screenHalfHeight) {
      return dragResult;
    }
    // C面拖拽到中轴区下，直接回弹
    if (dropY > screenHalfHeight &&
      dropY < (screenHalfHeight + dragCreaseHalfHeight)) {
      if (dragItemInfo.page === 1) {
        return dragResult;
      }
      page = 1;
    }
    const endPos: number[] = this.getEndPosition(page, dragItemInfo);
    if (endPos.length === 0) {
      return dragResult;
    }
    fallItemData.result = endPos;
    this.updateMoveList(fallItemData);
    setTimeout(() => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
    }, DELAY_TIME_FIFTY);
    return dragResult;
  }

  private getEndPosition(page: number, dragItemInfo: GridLayoutItemInfo): number[] {
    let endPos: number[] = [];
    let outerLoop: boolean = true;
    if (!this.mGridConfig) {
      return endPos;
    }
    for (let y = 0; y < this.mGridConfig.column && outerLoop; y++) {
      for (let x = 0; x < this.mGridConfig.row; x++) {
        if (LaunchLayoutCacheManager.getInstance().isPositionValid(dragItemInfo, page, y, x)) {
          endPos = [y, x, page];
          outerLoop = false;
          break;
        }
      }
    }
    return endPos;
  }

  // 是否显示卡片达到上限的toast
  private isNeedShowCardExceedToast(dragItemType: number, dragItemInfo: GridLayoutItemInfo) {
    // 拖拽类型未卡片
    if (dragItemInfo.typeId !== CommonConstants.TYPE_CARD) {
      return false;
    }
    // 从加卡页或者负一屏拖拽过来
    if (dragItemType !== CommonConstants.DRAG_FROM_FORM_INTELLIGENT &&
      dragItemType !== CommonConstants.DRAG_FROM_FORM_SERVICE &&
      dragItemType !== CommonConstants.DRAG_FROM_MANAGE) {
      return false;
    }
    // 桌面卡片数量达到上限，总卡片限制80张
    return FormModel.getInstance().checkIfCardExceedLimit();
  }

  private onDragDropFinal(x: number, y: number, dragItems: GridLayoutItemInfo[], pageIndex: number, deviceType: string,
    dragItemType: number, dragResult: DesktopDragResult, dragFormTypes: number[],
    event?: DragEvent, extraParams?: string): DesktopDragResult {
    let dragItemInfo: GridLayoutItemInfo = dragItems[0];
    log.showInfo('onDragEnd pageIndex: %{public}d, dragItemInfo: bundleName: %{public}s, keyName: %{public}s, moduleName: %{public}s',
      pageIndex, dragItemInfo.bundleName, dragItemInfo.keyName, dragItemInfo.moduleName);
    // 元素大小判空
    if (!dragItemInfo.area) {
      let dragItemArea: number[] | undefined = this.getDragItemArea(dragItemInfo);
      if (!dragItemArea) {
        log.showError('dragItemInfo has no area');
        Trace.end(Trace.CORE_METHOD_DRAG_DROP);
        return dragResult;
      } else {
        dragItemInfo.area = dragItemArea;
      }
    }

    // 从卡片管理拖拽快捷图标加桌
    if (dragItemType === CommonConstants.DRAG_FROM_MANAGE && !CheckEmptyUtils.isEmpty(dragItemInfo.shortcutInfo)) {
      let checkResult: CheckResult = ShortcutViewModel.getInstance().checkShortcut(dragItemInfo.shortcutInfo);
      if (checkResult.code === ResultCode.FAILED_DUPLICATE_ID) {
        prompt.showToast({
          message: $r('app.string.add_exist_shortcut'),
          showMode: 2
        });
        return dragResult;
      }
    }
    // 卡片数量达到上限
    if (CheckEmptyUtils.isEmpty(dragItemInfo.shortcutInfo) && this.isNeedShowCardExceedToast(dragItemType, dragItemInfo)) {
      log.showError('card exceed limit');
      if (dragItemType === CommonConstants.DRAG_FROM_FORM_INTELLIGENT) {
        this.handleDragCardEventFromIntelligent(dragItemInfo.negativeId);
      }
      if (dragItemInfo.cardId && dragItemType !== CommonConstants.DRAG_FROM_FORM_INTELLIGENT) {
        log.showInfo('formManager delete card, cardId is: %{public}d, bundleName: %{public}s, ' +
          'abilityName: %{public}s, moduleName: %{public}s', dragItemInfo.cardId, dragItemInfo.bundleName,
          dragItemInfo.abilityName, dragItemInfo.moduleName);
        FormManager.getInstance().deleteCard(dragItemInfo.cardId);
      }
      FormModel.getInstance().showToastWhenCardExceed();
      Trace.end(Trace.CORE_METHOD_DRAG_DROP);
      return dragResult;
    }

    const originPosition: DragItemPosition = this.getOriginPosition(dragItemInfo);
    const startPosition: DragItemPosition | undefined = AppStorage.get<DragItemPosition>('startPosition');
    let endPosition: DragItemPosition | undefined = undefined;
    let dragDelegate: CellLayoutDragDelegate = this.getDragDelegate() as CellLayoutDragDelegate;
    let cellAndSpan: CellAndSpan = new CellAndSpan(x, y, dragItemInfo.area[0], dragItemInfo.area[1]);
    log.showDebug(`cellAndSpan:${cellAndSpan.toString()}`);
    let result: number[] = this.getNearestArea(dragDelegate, cellAndSpan);
    if (dragItemInfo.typeId !== CommonConstants.TYPE_CARD && !GridLayoutUtil.isRegionFolderType(dragItemInfo)) {
      this.updateDragEndPosition(result, x, y);
    }
    const fallItemData: DragItem = {
      x: x,
      y: y,
      data: dragItemInfo,
      result: result,
      eventType: 'fall_animation'
    };

    // 用于下次图标判断进场动效, 后面使用class替代AppStorage
    AppStorage.setOrCreate<DragItem>('lastDragItem', fallItemData);
    this.mEndPosition = {
      page: pageIndex,
      row: result[1],
      column: result[0],
      x: x,
      y: y
    };

    // 拖拽相关打点
    if (GridLayoutUtil.isIconType(dragItemInfo.typeId) &&
      deviceType === CommonConstants.DEFAULT_DEVICE_TYPE &&
      (dragItemType === CommonConstants.DRAG_FROM_DESKTOP || dragItemType === CommonConstants.DRAG_FROM_APP_ICON ||
        dragItemType === CommonConstants.DRAG_FROM_DOCK)) {
      this.reportDragSequence(dragItemInfo, this.mEndPosition);
    }
    if (GridLayoutUtil.isIconType(dragItemInfo.typeId) &&
      deviceType === CommonConstants.DEFAULT_DEVICE_TYPE &&
      dragItemType === CommonConstants.DRAG_FROM_FOLDER ||
      dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK) {
      // 拦截定制文件夹应用被异常拖出时的落位
      if (DeliverUtil.isDisableOperationsOnFolder(dragItemInfo.folderId, dragItemInfo.intent) ||
        (NotHarmonyUtil.isInNotHarmonyFolder(dragItemInfo) && dragItemInfo.appStatus === AppStatus.WAIT_FOR_HARMONY)) {
        log.showInfo('leave container folder, drop return');
        return dragResult;
      }
      // 文件夹打点 - 从文件夹中拖拽图标至桌面
      let lastOpenFolderData: GridLayoutItemInfo = AppStorage.get<GridLayoutItemInfo>('lastOpenFolderData') as GridLayoutItemInfo;
      FolderReporter.getInstance().reportDragIconFromFolder(dragItemInfo.bundleName, lastOpenFolderData);
    }
    log.showDebug('onDragEnd mEndPosition, row: %{public}d, column： %{public}d', this.mEndPosition.row, this.mEndPosition.column);
    endPosition = this.copyPosition(this.mEndPosition);

    let endLayoutInfo: GridLayoutItemInfo = this.getItemByPosition(this.mEndPosition) as GridLayoutItemInfo;
    this.updateCoverItemInfo(endLayoutInfo);

    const pointInfo: PointInfo = {
      x: x,
      y: y,
    };
    const positionInfo: PositionInfo = {
      startPosition: startPosition as DragItemPosition,
      endPosition: endPosition,
    };
    // 卡片形成堆叠
    if (!this.isStartToSqueeze && this.addToFormStack(pointInfo, dragItemInfo, endLayoutInfo, positionInfo, dragResult)) {
      // 从负一屏拖拽到桌面后移除负一屏的卡片
      if (dragItemType === CommonConstants.DRAG_FROM_FORM_INTELLIGENT) {
        this.removeIntelligentCard(dragItemInfo);
      }
      // 统一写库逻辑暂不适配生成卡片堆叠和加入卡片堆叠
      Cache2RdbHelper.getInstance().deleteItem(CommonConstants.DRAG_RDB_EVENT, dragItemInfo, 'formStack scene');
      fallItemData.result = [endLayoutInfo.column ?? 0, endLayoutInfo.row ?? 0];
      dragResult.needRender = true;
      dragResult.needDropAnimation = true;
      dragResult.dropToStackForm = true;
      return dragResult;
    } else if (endLayoutInfo !== undefined && endLayoutInfo.typeId === CommonConstants.TYPE_CARD) {
      // 第一次清理覆盖动效
      this.clearLastCoveredItemAnimation();
    }

    // pad产品需要同时判断横竖屏场景能不能落位
    if (DeviceHelper.isPad() && PadLaunchLayoutCacheManager.getInstance()
      .isNeedCheckDragAble(this.mPageDesktopViewModel.getIndex(), dragItemInfo, dragItemType)) {
      if (dragFormTypes.includes(dragItemType) && deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
        this.handleCreateCardAfterDragDrop(x, y, dragItemInfo, dragItemType);
      }
      log.showInfo('the area is not enough for portrait or landscape pad');
      Trace.end(Trace.CORE_METHOD_DRAG_DROP);
      return dragResult;
    }
    if (this.isPc && this.isLeaveSwiperPage) {
      return this.onCreaseRegionDrag(y, fallItemData, dragItemInfo, dragResult);
    }
    // 计算后面空间是否足够
    if (this.isPc) {
      this.calculateEmptyCount(fallItemData);
    }
    // 触发挤位
    if (endPosition && (deviceType === CommonConstants.DEFAULT_DEVICE_TYPE || this.isPc)) {
      let itemInfo: GridLayoutItemInfo = this.getItemByPosition(endPosition) as GridLayoutItemInfo;
      log.showWarn(`desktop drag flag updateGridList, currentItemInfo: ${DesktopUtils.desktopItemsToString(itemInfo)}, endPosition:${JSON.stringify(endPosition)}`);

      // 因为挤位定时器机制，需在落位时强行触发挤位场景：1.dragMove时无挤位但落位时有元素  2.dragMove时有挤位但落位位置有变化
      // 3. 云端2模式 落位不需要重新挤位
      let isNeedReSqueezeDrop = !LightOutdoorConfig.getInstance().isOnLightOutdoorMode() && (this.currentMoveItemList.length === 0 && itemInfo !== undefined) ||
        (this.currentMoveItemList.length > 0 && !this.isCorrectDropSolution(this.currentMoveItemList, fallItemData) && !this.isNearReArrangeSolutionSuccess);
      log.showWarn(`desktop drag isNeedReSqueezeDrop:${isNeedReSqueezeDrop}, currentMoveItemList:${this.currentMoveItemList.length}`);
      let isReSqueezeSuccess: boolean = false;
      if (isNeedReSqueezeDrop) {
        if (this.isPc) {
          let squeezeData = new SqueezeData();
          squeezeData.x = x;
          squeezeData.y = y;
          squeezeData.dragDelegate = dragDelegate;
          squeezeData.dragItemInfo = dragItemInfo;
          squeezeData.cellAndSpan = cellAndSpan;
          squeezeData.itemInfo = itemInfo;
          squeezeData.dragItemType = dragItemType;
          this.reSqueezeOnDropForPC(squeezeData);
        } else {
          this.reSqueezeOnDrop(dragItemInfo, itemInfo, dragItemType, deviceType, x, y, dragDelegate, cellAndSpan);
        }
        log.showInfo('SqueezeOnDrop end, dragDelegate: ' + dragDelegate.isReArrangeSolutionSuccess() + ' isSqueezeSuccess: ' + this.isSqueezeSuccess);
        isReSqueezeSuccess = dragDelegate.isReArrangeSolutionSuccess() || this.isSqueezeSuccess;
      }
      if (this.isPc && (!this.enoughToConDrop || (this.pcMultiDragCount > 1)) &&
        dragItemType !== CommonConstants.DRAG_FROM_REGION_FOLDER) {
        let squeezeData = new SqueezeData();
        squeezeData.x = x;
        squeezeData.y = y;
        squeezeData.dragDelegate = dragDelegate;
        squeezeData.dragItemInfo = dragItemInfo;
        squeezeData.cellAndSpan = cellAndSpan;
        squeezeData.itemInfo = itemInfo;
        squeezeData.dragItemType = dragItemType;
        this.multiReSqueezeOnDropForPC(squeezeData);
      }
      // 挤位成功或无需挤位后才更新布局，无法挤位场景则不需要更新
      if ((!isNeedReSqueezeDrop || isReSqueezeSuccess) && dragItemType !== CommonConstants.DRAG_FROM_REGION_FOLDER) {
        this.updateMoveList(fallItemData);
      }
    }

    endLayoutInfo = this.getItemByPosition(this.mEndPosition) as GridLayoutItemInfo;
    if (LightOutdoorConfig.getInstance().isOnLightOutdoorMode() && endLayoutInfo !== undefined) {
      log.showInfo('onLightOutdoorMode onDragDropFinal, not drop.');
      return dragResult;
    }
    let isDropdeliverFolder = DeliverUtil.isdeliverFolder(endLayoutInfo?.folderId);
    let isDropAbroadFolder = DeliverUtil.isAbroadFolder(endLayoutInfo?.folderId);
    if (dragItems.length > 1 && GridLayoutUtil.isIconType(endLayoutInfo?.typeId) &&
      !FolderViewModel.canFolderDropIn(endLayoutInfo, dragItems)) {
      // 多选超过文件夹容量上限的图标落位图标试图生成小文件夹时，阻止落位，走挤位
      log.showInfo(`dragTooManyApps`);
      endLayoutInfo = new GridLayoutItemInfo();
      this.clearLastCoveredItemAnimation();
    }
    if (endLayoutInfo?.typeId === CommonConstants.TYPE_FOLDER) {
      if (dragItems.length === 1 && !FolderViewModel.canDragIn(endLayoutInfo, dragItemInfo)) {
        log.showInfo('onDragDropFinal dest is full');
        this.refreshResident(dragItemInfo, dragItemType);
        return dragResult;
      }

      if (dragItems.length > 1 && !FolderViewModel.canFolderDropIn(endLayoutInfo, dragItems)) {
        // 满文件夹场景
        // 多选落位满文件夹被阻止后，重置落位信息以规避后续合并文件夹，走挤位失败逻辑
        log.showInfo(`FolderIsFullAfterAppsDropIn`);
        // 非鸿蒙化文件夹-提示不支持图标移入打点
        if (DeliverUtil.isContainerFolder(endLayoutInfo?.folderId)) {
          FolderReporter.getInstance()
            .reportDragIconIntoNotHarmonyFolder(dragItemInfo, endLayoutInfo, endLayoutInfo?.folderId);
        }
        endLayoutInfo = new GridLayoutItemInfo();
        this.clearLastCoveredItemAnimation();
      }

      let folderItems: GridLayoutItemInfo[] = endLayoutInfo.layoutInfo?.flat() ?? [];
      let folderAppCount: number = folderItems.length;
      let maxAppCount: number = FolderViewModel.getMaxAppCount();
      if (folderAppCount > 0 && folderItems[folderAppCount - 1]?.typeId === CommonConstants.TYPE_ADD) {
        folderAppCount -= 1;
      }
    }

    // 不让落位的定制布局
    let waitForHarmony: boolean =
      NotHarmonyUtil.isNotHarmonyApps(dragItems) && dragItemInfo.typeId === CommonConstants.TYPE_APP;
    let isMixedDropdeliver = isDropdeliverFolder && dragItems.length > 1 && !DeliverUtil.isAlldeliverApps(dragItems);
    if (GridLayoutUtil.isIconType(dragItemInfo?.typeId) &&
      (DeliverUtil.isDisableOperationsOnFolder(endLayoutInfo?.folderId, dragItemInfo.intent) ||
        (NotHarmonyUtil.isNotHarmonyFolderById(endLayoutInfo?.folderId) && !waitForHarmony) ||
        isMixedDropdeliver || isDropAbroadFolder)) {
      log.showInfo('cannot drag item to flod');
      if (isMixedDropdeliver) {
        prompt.showToast({
          message: ResourceManager.getInstance().getStringByName('only_deliver_app_can_add_to_fold')
        });
      } else {
        prompt.showToast({
          message: ResourceManager.getInstance().getStringByName('can_not_add_to_flod')
        });
      }

      // 非鸿蒙化文件夹-提示不支持图标移入打点
      FolderReporter.getInstance()
        .reportDragIconIntoNotHarmonyFolder(dragItemInfo, endLayoutInfo, endLayoutInfo?.folderId);
      this.refreshResident(dragItemInfo, dragItemType);
      if (MultiSelectManager.getInstance().isInMultiSelect) {
        // 多选落位定制文件夹被阻止后，重置落位信息以规避后续合并文件夹，走挤位失败逻辑
        endLayoutInfo = new GridLayoutItemInfo();
        this.clearLastCoveredItemAnimation();
      } else {
        Trace.end(Trace.CORE_METHOD_DRAG_DROP);
        return dragResult;
      }
    }

    // 编辑模式文件夹打开态，不可拖出元素落位兜底
    const openFolderData: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    let isNotAbleToDragOut: boolean = !DeliverUtil.canFolderItemDragOut(openFolderData.folderId, dragItemInfo.bundleName);
    if (dragItems.length === 1 && isNotAbleToDragOut) {
      Trace.end(Trace.CORE_METHOD_DRAG_DROP);
      return dragResult;
    }

    // 合并文件夹
    if (dragItems.length === 1 && this.addIconToFolder(x, y, dragItemType, deviceType, dragItemInfo,
      endLayoutInfo, startPosition, endPosition)) {
      ShortcutViewModel.getInstance().addShortcutToBMSByDrag(dragItemType, dragItemInfo);
      dragResult.needRender = true;
      dragResult.dropToFolder = true;
      Trace.end(Trace.CORE_METHOD_DRAG_DROP);
      return dragResult;
    }
    if (this.addToFolderWithMultiApp(x, y, deviceType, dragItems, endLayoutInfo, endPosition, dragItemType)) {
      this.clearLastCoveredItemAnimation();
      dragResult.needRender = true;
      Trace.end(Trace.CORE_METHOD_DRAG_DROP);
      this.isDropFileToDesktop = false;
      return dragResult;
    }
    if (this.addFileToFolder(x, y, dragItemInfo, event, extraParams)) {
      log.showInfo('desktop drag addFileToFolder done');
      this.clearLastCoveredItemAnimation();
      Trace.end(Trace.CORE_METHOD_DRAG_DROP);
      return dragResult;
    }
    // 没有合并文件夹，则正常播报落位位置
    this.textAnnouncedForDrop(dragItemInfo, dragItems);
    if (dragItemType === CommonConstants.DRAG_FROM_REGION_FOLDER) {
      if (!this.enableMultiDragFromRegionFolder(this.mEndPosition.row, this.mEndPosition.column)) {
        log.showWarn(`multi drag failed from regionFolder row ${this.mEndPosition.row}, col ${this.mEndPosition.column}`);
        return dragResult;
      }
    }
    // 是否有足够空间容纳拖拽的控件
    if (!this.hasFreeArea(dragDelegate, dragItemInfo) && !this.isNearReArrangeSolutionSuccess &&
      dragItems.length === 1) {
      if (dragFormTypes.includes(dragItemType) && deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
        this.handleCreateCardAfterDragDrop(x, y, dragItemInfo, dragItemType);
        Trace.end(Trace.CORE_METHOD_DRAG_DROP);
        return dragResult;
      }
      this.isShowNoFreeAreaToast(dragDelegate, dragItemInfo);
      if (deviceType !== CommonConstants.DEFAULT_DEVICE_TYPE) {
        if (FormModel.getInstance().checkIfCardExceedLimit() &&
          dragItemType === CommonConstants.DRAG_FROM_FORM_INTELLIGENT) {
          this.handleDragCardEventFromIntelligent(dragItemInfo.negativeId);
        }
        Trace.end(Trace.CORE_METHOD_DRAG_DROP);
        return dragResult;
      }
      if (dragItemType === CommonConstants.DRAG_FROM_DOCK) {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_REFRESH, dragItemInfo);
        Trace.end(Trace.CORE_METHOD_DRAG_DROP);
        dragResult.dropToDock = true;
        dragResult.needDropAnimation = true;
        return dragResult;
      }
      Trace.end(Trace.CORE_METHOD_DRAG_DROP);
      return dragResult;
    } else {
      if (dragItemInfo.typeId === CommonConstants.TYPE_FOLDER && deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
        let startPosition: DragItemPosition | undefined = AppStorage.get<DragItemPosition>('startPosition');
        const startIsInDockArea: boolean = FolderCommonUtil.isInDockArea(startPosition?.y);
        const endIsInDockArea: boolean = FolderCommonUtil.isInDockArea(this.mEndPosition?.y);
        FolderReporter.getInstance()
          .reportDragFolder(dragItemInfo, startPosition, this.mEndPosition, startIsInDockArea, endIsInDockArea);
      }
    }

    // 当挤位失败时，在本页就近寻位进行落位
    if (endLayoutInfo != null &&
      (deviceType === CommonConstants.DEFAULT_DEVICE_TYPE || dragFormTypes.includes(dragItemType))) {
      // 获取当前页上不含拖拽元素的元素集合，当前拖拽元素的原位置应该算为空位
      const currentPageLayoutInfo = this.getCurrentPageLayoutInfo(dragItemInfo);
      let gridOccupyStatus: GridOccupyStatus = dragDelegate.getGridOccupyStatus(currentPageLayoutInfo);
      cellAndSpan.setCellX(result[0]);
      cellAndSpan.setCellY(result[1]);
      let res = this.getNearestAreaTwo(dragDelegate, cellAndSpan, gridOccupyStatus);
      if (this.mIsPrintLog) {
        log.showInfo('findNearestAreaTwo: %{public}d, %{public}d', res[0], res[1]);
      }
      if (res[0] > -1 && res[1] > -1) {
        // 修改dragItemInfo中位置信息，以便后续执行落位动效
        dragItemInfo.row = res[1];
        dragItemInfo.column = res[0];
        result = res;
        // 挤位失败时，更新lastDragItem，避免PC端从卡片中心拖出时，获取不到正确的落位点导致落位动效异常
        fallItemData.result = res;
      }
    }

    if (dragItemType === CommonConstants.DRAG_FROM_DOCK || dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK &&
      deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
      this.deleteDockItem(dragItemInfo);
    }
    ShortcutViewModel.getInstance().addShortcutToBMSByDrag(dragItemType, dragItemInfo);

    // 堆叠卡片UE事件上报
    this.mFormStackViewModel.reportFormStackDragEvent(dragItemType, dragItemInfo, originPosition, this.mEndPosition);

    if (!this.isPc) {
      this.updateDragItemPosition(result, dragItems, dragDelegate, pageIndex, true);
    }
    this.isNearReArrangeSolutionSuccess = false;
    this.updateCurrentPage();

    if (!dragFormTypes.includes(dragItemType) && deviceType === CommonConstants.DEFAULT_DEVICE_TYPE &&
      dragItemInfo.typeId === CommonConstants.TYPE_CARD) {
      let moveFrom = [dragItemInfo.page, dragItemInfo.column, dragItemInfo.row];
      let moveTo = [this.mEndPosition.page, this.mEndPosition.column, this.mEndPosition.row];
      const event: MoveCardEvent = {
        packageName: dragItemInfo.bundleName,
        area: dragItemInfo.area,
        moveFrom: moveFrom.toString(),
        moveTo: moveTo.toString(),
        formId: dragItemInfo.cardId ?? '',
        moduleName: dragItemInfo.moduleName ?? '',
        formName: dragItemInfo.cardName ?? '',
        sourceType: Extend1Data.getCardSourceType(dragItemInfo.extend1),
      };
      FormHiSysEventReporter.reportMoveCard(event);
    }
    if (dragItemType === CommonConstants.DRAG_FROM_FOLDER ||
      dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK) {
      // 文件夹拖出逻辑需要在刷新当前页之后调用，避免文件夹的解散动效刷新之后丢失
      ContractedFolderCommonViewModel.getInstance().drop('drag from folder to desktop', this.mFolderMgr
        .getDragLeaveFolderId(), FolderDropType.DROP_TO_DESKTOP, DragViewModelUtil.getDragParams([dragItemInfo]));
    }
    if (dragFormTypes.includes(dragItemType)) {
      // 暂态卡片落位动效终点无法通过布局获取，需修改dragItemInfo中位置；endLayoutInfo不为空时就近寻位阶段已修改，此处不重复修改
      if (!endLayoutInfo) {
        dragItemInfo.column = this.mEndPosition.column;
        dragItemInfo.row = this.mEndPosition.row;
      }
      this.mPageDesktopViewModel.reportAddCardToScreenByDragEvent(dragItemInfo as Object as CardItemInfo, dragItemType,
        ResultType.SUCCESS);
      if (FormModel.getInstance().checkIfCardExceedLimit() &&
        dragItemType === CommonConstants.DRAG_FROM_FORM_INTELLIGENT) {
        this.handleDragCardEventFromIntelligent(dragItemInfo.negativeId);
        Trace.end(Trace.CORE_METHOD_DRAG_DROP);
        return dragResult;
      }
      dragItemInfo.page = pageIndex;
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD, dragItemInfo);
      if (dragItemType === CommonConstants.DRAG_FROM_FORM_INTELLIGENT) {
        this.removeIntelligentCard(dragItemInfo);
      }
    }
    // 先执行文件夹消失动效，再刷新页面
    if (BigFolderViewModel.getInstance().isFolderDisappearing()) {
      setTimeout(() => {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
      }, CommonConstants.FOLDER_MISSION_TIMEOUT);
    } else {
      // 延时50ms刷新全体布局，避免主线程被抢占导致动效不执行
      setTimeout(() => {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, pageIndex);
      }, DELAY_TIME_FIFTY);
    }
    let outerAppItem: GridLayoutItemInfo | undefined = AppStorage.get('OuterAppItem');
    if (outerAppItem && editModeManager.isInEditMode()) {
      HiEditModeEventUtils.reportAddAppToScreenByDrag(dragItemInfo, result[1], result[0], pageIndex);
    }

    dragResult.needRender = true;
    dragResult.needDropAnimation = this.isDragPaste ? false : true;
    Trace.end(Trace.CORE_METHOD_DRAG_DROP);
    return dragResult;
  }

  private enableMultiDragFromRegionFolder(row: number, column: number): boolean {
    const index: number = this.getIndexByRowAndColumn(row, column);
    const dropItem: GridLayoutItemInfo | undefined = this.getItemByIndex(index);
    if (this.pcMultiDragCount > 1 && dropItem) {
      return false;
    }
    return true;
  }

  private isShowNoFreeAreaToast(dragDelegate: CellLayoutDragDelegate, dragItemInfo: GridLayoutItemInfo): void {
    GlobalContext.getContext().eventHub.emit('myOnDragEnd');
    if (!this.isSuperFold || (this.isSuperFold && !this.isExpandStatus)) {
      prompt.showToast({
        message: $r('app.string.add_form_to_desktop_max')
      });
    } else {
      // 如果是super fold,且是展开态，还需要判断另一页是否有空间
      const tempPage: number = this.dragPageIndex === 0 ? 1 : 0;
      this.setDragPageIndex(tempPage);
      const hasEmptyArea: boolean = this.hasFreeArea(dragDelegate, dragItemInfo);
      this.setDragPageIndex(tempPage === 0 ? 1 : 0);
      if (!hasEmptyArea) {
        prompt.showToast({
          message: $r('app.string.add_form_to_desktop_max')
        });
      }
    }
  }
  private refreshResident(dragItem: GridLayoutItemInfo, dragType: number): void {
    if (dragType === CommonConstants.DRAG_FROM_DOCK) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_REFRESH, dragItem);
    }
  }

  private textAnnouncedForDrop(dragItemInfo: GridLayoutItemInfo, dragItems: GridLayoutItemInfo[]): void {
    if (this.finallyFallPosition[0] > 0 && this.finallyFallPosition[1] > 0) {
      if (dragItems.length > 1) {
        DragAccessibilityUtils.textAnnouncedForMultiDrop(dragItems.length);
      } else {
        this.dealAnnouncedForDrop(dragItemInfo);
      }
    }
  }

  private dealAnnouncedForDrop(dragItemInfo: GridLayoutItemInfo): void {
    let dragIconName: string = this.getAppName(dragItemInfo);
    if (dragItemInfo.typeId === CommonConstants.TYPE_FOLDER) {
      dragIconName = FolderCommonUtil.getRealFolderName(dragItemInfo.folderName);
    } else if (dragItemInfo.typeId === CommonConstants.TYPE_FORM_STACK) {
      if (dragItemInfo.layoutInfo) {
        dragIconName = this.getAppName(dragItemInfo.layoutInfo[0][dragItemInfo.layoutInfo[0].length - 1]);
      }
    }
    DragAccessibilityUtils.textAnnouncedForDrop(this.finallyFallPosition, dragIconName);
  }

  private deleteDockItem(dragItem: GridLayoutItemInfo): void {
    if (dragItem && dragItem.typeId === CommonConstants.TYPE_FOLDER && dragItem.folderId) {
      this.mFolderMgr.deleteFolderCache(`deleteDockFolder`, dragItem.folderId);
    }
    (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)
      .eventHub.emit(CommonConstants.DOCK_ITEM_SQUEEZE_CANCEL);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_DELETE, dragItem);
  }

  private updateDragEndPosition(position: number[], x: number, y: number): void {
    if (!position || position[0] == null || position[1] == null) {
      return;
    }
    if (this.needUpdateEndPosIfNSqueeze(x, y, position[1], position[0])) {
      position[1] += 1;
    }
  }

  private getDragEndPositionIndex(x: number, y: number, row?: number, column?: number): number {
    let index: number = this.getItemIndex(x, y);
    if (this.needUpdateEndPosIfNSqueeze(x, y, row, column)) {
      index += 1;
    }
    return index;
  }

  /**
   * N挤位中，落位点有元素且拖拽鼠标点在图标下方时，应落在下方宫格
   * @param pos
   * @param dragX
   * @param dragY
   */
  private needUpdateEndPosIfNSqueeze(dragX: number, dragY: number, row?: number, column?: number): boolean {
    if (this.zSqueeze) {
      return false;
    }
    if (dragX == null || dragY == null) {
      log.showWarn('needUpdateEndPosIfNSqueeze: drag pos invalid');
      return false;
    }
    let gridOfDragPos: DragGridPosition = this.isSuperFold ?
    GridLayoutUtil.getRowAndColumnAndPage(dragX, dragY, this.isPortrait) :
    GridLayoutUtil.getRowAndColumn(dragX, dragY, this.getCurrentPageIndex());
    if (!gridOfDragPos) {
      return false;
    }
    if (gridOfDragPos.row === (this.mGridConfig?.row ?? 0) - 1) {
      // 落点最后一行
      log.showWarn('needUpdateEndPosIfNSqueeze: last row');
      return false;
    }
    let dragInCurrentGrid: boolean = gridOfDragPos && gridOfDragPos.row === row && gridOfDragPos.column === column;
    if (row == null || column == null) {
      row = gridOfDragPos.row;
      column = gridOfDragPos.column;
      dragInCurrentGrid = true;
    } else {
      if (this.mStartPosition && this.mStartPosition.row === row && this.mStartPosition.column === column) {
        // 当前在起拖位置，不更新
        return false;
      }
    }
    const currItem: GridLayoutItemInfo | undefined = this.getItemByPos(row, column);
    const currItemPos: number[] = this.getPositionByRowAndColumn(row, column);
    log.showDebug(`needUpdateEndPosIfNSqueeze currItemPos: ${currItemPos}`);
    const currIconBottom: number =
      currItemPos[1] + this.mPageDesktopStyleConfig.mIconMarginVertical + StyleConstants.APPICON_BACKGROUND_HEIGHT;
    if (currItem && dragInCurrentGrid && dragY >= currIconBottom) {
      log.showDebug('needUpdateEndPosIfNSqueeze true');
      return true;
    }
    return false;
  }

  private getNearestArea(dragDelegate: CellLayoutDragDelegate, cellAndSpan: CellAndSpan): number[] {
    // dragDelegate中不方便直接获取图标size，因此从此处向其中传递
    if (!this.isPc) {
      const iconSize = LayoutViewModel.getInstance().calculateDesktop().mIconSize;
      dragDelegate.recordIconSize(iconSize);
    }
    let res: number[] = dragDelegate.findNearestArea(cellAndSpan);
    this.updatePositionByRTL(res, cellAndSpan.getSpanX());
    return res;
  }

  private getNearestAreaTwo(dragDelegate: CellLayoutDragDelegate | undefined, cellAndSpan: CellAndSpan,
    gridOccupyStatus: GridOccupyStatus | undefined): number[] {
    let tempLocation: number[] = [-1, -1];
    let direction: number[] = [0, 0];
    if (!dragDelegate || !gridOccupyStatus) {
      return tempLocation;
    }
    let res: number[] = dragDelegate.findNearestAreaTwo(cellAndSpan, direction, gridOccupyStatus, null, tempLocation);
    log.showInfo(`getNearestAreaTwo ${res}`);
    return res;
  }

  private updatePositionByRTL(position: number[], spanX: number): void {
    if (RTLUtil.isRTL()) {
      position[2] = position[0];
      position[0] = (this.mGridConfig?.column ?? 0) - spanX - position[0];
    }
  }

  private handleCreateCardAfterDragDrop(x: number, y: number, dragItemInfo: GridLayoutItemInfo, dragItemType: number): void {
    dragItemInfo.column = undefined;
    dragItemInfo.row = undefined;
    if (FormModel.getInstance().checkIfCardExceedLimit() &&
      dragItemType === CommonConstants.DRAG_FROM_FORM_INTELLIGENT) {
      this.handleDragCardEventFromIntelligent(dragItemInfo.negativeId);
    } else {
      // 从负一屏拖拽到桌面后移除负一屏的卡片
      if (dragItemType === CommonConstants.DRAG_FROM_FORM_INTELLIGENT) {
        this.removeIntelligentCard(dragItemInfo);
      }
      this.mPageDesktopViewModel.createCardWithAnimation(dragItemInfo as Object as CardItemInfo, dragItemType, x, y);
    }
  }

  private removeIntelligentCard(dragItemInfo: GridLayoutItemInfo): void {
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REMOVE_INTELLIGENT_CARD, {
      'id': dragItemInfo.negativeId
    });
  }

  private handleDragCardEventFromIntelligent(negativeId: number): void {
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_RESUME_INTELLIGENT_CARD, {
      'id': negativeId
    });
    // 桌面卡片超限时，负一屏拖拽到桌面场景当前在桌面落位时拦截，后续负一屏需求适配后，再删除该逻辑
    log.showInfo('current is drag from intelligent and card number in desktop exceed limit');
    this.deleteBlankPageAddByDragging(CommonConstants.DRAG_FROM_FORM_INTELLIGENT);
    return;
  }

  private isCorrectDropSolution(moveItemList: MoveItem[], fallItem: DragItem): boolean {
    if (!fallItem || !fallItem.data || !fallItem.data.area) {
      log.showError('isCorrectDropSolution param is invalid');
      this.resetMoveItemList();
      this.resetLastMoveItemList();
      return false;
    }

    let dragRect: RectItem = new RectItem(fallItem.result[0], fallItem.result[1],
      fallItem.result[0] + fallItem.data.area[0], fallItem.result[1] + fallItem.data.area[1]);
    let crossItems: Set<string> = this.getCrossItems(dragRect);
    // 已挤位，但拖拽元素最终落位与被挤位元素位置相同
    if (crossItems.size === 0 && moveItemList.length !== 0) {
      log.showWarn('The dragged element is in the same position as the squeezed element');
      return false;
    }
    // 移除重复元素中已触发过挤位的元素
    moveItemList.forEach((item: MoveItem) => crossItems.delete(this.getItemEventKey(item)));
    return crossItems.size === 0;
  }

  /**
   * 获取与拖拽元素交叉的所有元素
   */
  private getCrossItems(dragRect: RectItem): Set<string> {
    let crossItems: Set<string> = new Set();
    const pageIndex: number = this.getCurrentPageIndex();
    const layoutInfo = this.mLayoutCacheManager.selectGridLayoutItemsByPage(pageIndex);
    const dragItemInfoList: GridLayoutItemInfo[] = this.getDragItems() ?? [];
    let dragItems = new Set<string>();
    dragItemInfoList.forEach((item: GridLayoutItemInfo) => dragItems.add(GridLayoutUtil.generateUniqueKey(item)));
    layoutInfo.forEach((item: GridLayoutItemInfo) => {
      let itemKey: string = this.getItemEventKey(item);
      if (!item || item.column === undefined || item.row === undefined || !item.area) {
        return;
      }
      let itemRect: RectItem =
        new RectItem(item.column, item.row, item.column + item.area[0], item.row + item.area[1]);
      if (RectItem.intersects(dragRect, itemRect) && !dragItems.has(itemKey)) {
        crossItems.add(itemKey);
      }
    });
    return crossItems;
  }

  private reportDragSequence(dragItemInfo: GridLayoutItemInfo, endPosition: DragItemPosition): void {
    if (CheckEmptyUtils.isEmpty(dragItemInfo) || !this.mEndPosition) {
      return;
    }
    let itemInfo: GridLayoutItemInfo | undefined = this.getItemByPosition(endPosition);
    if (!itemInfo || itemInfo.typeId === CommonConstants.TYPE_FOLDER) {
      return;
    }
    let fromPosition: string = 'screenId:' + dragItemInfo.page + ',cellX:' + dragItemInfo.column + ',cellY:' + dragItemInfo.row;
    let toPosition: string = 'screenId:' + this.mEndPosition.page + ',cellX:' + this.mEndPosition.column + ',cellY:' + this.mEndPosition.row;
    let deviceState: DeviceState = AppStorage.get<DeviceState>('folderStatus') as DeviceState;
    let type: number = this.getReportDragBehaviorType(dragItemInfo);
    SCBHiSysEventUtil.reportDragIconAdjustmentSequence(fromPosition, toPosition, dragItemInfo.bundleName, deviceState,
      type, this.dragBehaviorMode, dragItemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON);
  }

  private getReportDragBehaviorType(dragItemInfo: GridLayoutItemInfo): number {
    const dragItemType: number = AppStorage.get<number>('dragItemType') as number;
    if (dragItemType === CommonConstants.DRAG_FROM_DOCK) {
      return DragBehaviorType.DRAG_FROM_DOCK_TO_DESKTOP;
    }
    if (dragItemInfo.page !== this.mEndPosition?.page) {
      return DragBehaviorType.DRAG_CROSS_DESKTOP_PAGE;
    }
    return DragBehaviorType.DRAG_IN_DESKTOP_PAGE;
  }

  private reSqueezeOnDrop(dragItemInfo: GridLayoutItemInfo, itemInfo: GridLayoutItemInfo, dragItemType: number, deviceType: string, x: number, y: number,
    dragDelegate: CellLayoutDragDelegate, cellAndSpan: CellAndSpan): void {
    if (lockLayoutManager.isLockLayout()) {
      return;
    }

    this.hasCancelSqueezeAnimation = true;
    this.resetMoveItemList();
    this.resetLastMoveItemList();
    this.hasCancelSqueezeAnimation = false;
    if ((GridLayoutUtil.isIconType(dragItemInfo.typeId) || GridLayoutUtil.isSmallFolder(dragItemInfo)) && itemInfo !== undefined &&
      ((GridLayoutUtil.isIconType(itemInfo.typeId) && !this.judgeItem(dragItemInfo, itemInfo)) ||
        itemInfo.typeId === CommonConstants.TYPE_FOLDER)) {
      // 图标和文件夹或者图标和图标处于相交但不合并时触发挤位
      if (!this.canCover(x, y, dragItemInfo, itemInfo)) {
        log.showDebug('squeeze state2, not InHotArea, then squeeze');
        this.clearLastCoveredItemAnimation();
        if ((GridLayoutUtil.isIconType(dragItemInfo.typeId) || GridLayoutUtil.isSmallFolder(dragItemInfo)) &&
          deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
          this.dragEndItemIndex = this.getItemIndex(x, y); // 获取当前拖拽元素的位置所在的元素index
          if (this.lastMovePageIndex === this.mEndPosition?.page && this.lastMoveItemIndex === this.dragEndItemIndex) {
            log.showDebug('not squeeze, keep shake');
            this.isSqueezeSuccess = true;
            return;
          }
          let oriItemInfo = this.getItemByIndex(this.getItemIndex(x, y));
          if (GridLayoutUtil.isIconType(oriItemInfo?.typeId) || GridLayoutUtil.isSmallFolder(oriItemInfo)) {
            if (!this.hasEnoughArea() && this.lastFoldStatus) {
              this.multiItemSqueeze(dragDelegate, dragItemInfo, cellAndSpan, true);
            } else {
              this.appDragMove(x, y, this.coverItemWidth, dragItemType);
            }
          } else {
            this.multiItemSqueeze(dragDelegate, dragItemInfo, cellAndSpan);
          }
        }
      } else {
        log.showInfo('squeeze state3, InHotArea');
        if (this.isStartToSqueeze) {
          log.showInfo('InHotArea StartToSqueeze');
          this.dragEndItemIndex = this.getItemIndex(x, y);
          if (!GridLayoutUtil.isSmallFolder(dragItemInfo) &&
            this.lastMovePageIndex === this.mEndPosition?.page && this.lastMoveItemIndex === this.dragEndItemIndex) {
            log.showInfo('not squeeze, keep shake');
            return;
          }

          // 上一次挤位后依然在热区内，则继续挤位
          let oriItemInfo = this.getItemByIndex(this.getItemIndex(x, y));
          if (GridLayoutUtil.isIconType(oriItemInfo?.typeId) || GridLayoutUtil.isSmallFolder(oriItemInfo)) {
            if (!this.hasEnoughArea() && this.lastFoldStatus) {
              this.multiItemSqueeze(dragDelegate, dragItemInfo, cellAndSpan, true);
            } else {
              this.appDragMove(x, y, this.coverItemWidth, dragItemType);
            }
          } else {
            this.multiItemSqueeze(dragDelegate, dragItemInfo, cellAndSpan);
          }
        }
        if (!this.isSqueezeSuccess) {
          log.showDebug('InHotArea,squeeze not success');
          // move beyond the 6*4 grid, e.g. the dock bar
          this.resetMoveItemList();
          this.resetLastMoveItemList();
        }
      }
    } else {
      // 1. app item in blank space; 2. other items is draging
      log.showInfo('squeeze state4, app item in blank space or other items');
      this.clearLastCoveredItemAnimation();
      this.resetMoveItemList();
      this.resetLastMoveItemList();
      if (itemInfo !== undefined) {
        // 落位位置上没有桌面元素则不需要挤位
        this.multiItemSqueeze(dragDelegate, dragItemInfo, cellAndSpan);
      }
    }
  }

  // 合并文件夹
  private addIconToFolder(x: number, y: number, dragItemType: number, deviceType: string,
    dragItemInfo: GridLayoutItemInfo, endLayoutInfo: GridLayoutItemInfo,
    startPosition: DragItemPosition | undefined, endPosition: DragItemPosition | undefined): boolean {
    let isSupport: boolean = this.checkSupportAdd(x, y, dragItemType, deviceType, dragItemInfo, endLayoutInfo);
    if (!isSupport) {
      return false;
    }
    const isAppInFolder = (dragItemInfo: GridLayoutItemInfo, endLayoutInfo: GridLayoutItemInfo): void => {
      let isAppExist: boolean = false;
      let folderItem: GridLayoutItemInfo | undefined =
        this.mFolderCacheManager.selectGridLayoutItemByFolderId(endLayoutInfo.folderId);
      folderItem?.layoutInfo?.flat().forEach((item1) => {
        if (item1.keyName === dragItemInfo.keyName) {
          isAppExist = true;
        }
      });
      log.showDebug(`addIconToFolder isAppExist:${isAppExist}`);
      if (!isAppExist) {
        this.mBigFolderViewModel.deleteAppFromOpenFolder(dragItemInfo);
      } else {
        // 本文件夹拖出&拖入，手动增加app进场开关和相关动效
        AppStorage.setOrCreate('dragAppBackToFolder', true);
      }
    };
    log.showWarn(`endLayoutInfo:${JSON.stringify(endLayoutInfo)}`);
    if (GridLayoutUtil.isIconType(dragItemInfo.typeId)) {
      if (endLayoutInfo !== undefined) {
        // 快捷方式图标写库
        ShortcutViewModel.getInstance().updateShortcutIcon(dragItemInfo);
        // add app to folder
        Cache2RdbHelper.getInstance().addItem(CommonConstants.DRAG_RDB_EVENT, dragItemInfo);
        const isFolder: boolean = endLayoutInfo.typeId === CommonConstants.TYPE_FOLDER;
        const isIcon: boolean = GridLayoutUtil.isIconType(endLayoutInfo.typeId);
        log.showWarn('add or create folder, isFolder: %{public}s isIcon: %{public}s', isFolder, isIcon);
        if (isFolder) {
          return this.dropToFolder(x, y, dragItemType, deviceType, dragItemInfo, endLayoutInfo, isAppInFolder);
        } else if (isIcon) {
          Cache2RdbHelper.getInstance().addItem(CommonConstants.DRAG_RDB_EVENT, endLayoutInfo);
          log.showWarn('%{public}s and %{public}s create folder', dragItemInfo.keyName, endLayoutInfo.keyName);
          if (dragItemInfo.keyName !== endLayoutInfo.keyName) {
            if (dragItemType === CommonConstants.DRAG_FROM_DOCK) {
              log.showInfo('addIconToFolder DRAG_FROM_DOCK');
              this.deleteDockItem(dragItemInfo);
            } else if ((dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK ||
              dragItemType === CommonConstants.DRAG_FROM_FOLDER) &&
              deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
              log.showInfo(`addIconToFolder DRAG_FROM_FOLDER`);
              const leaveFolderId: string = this.mFolderMgr.getDragLeaveFolderId();
              ContractedFolderCommonViewModel.getInstance().drop('drag to create folder', leaveFolderId,
                  FolderDropType.DROP_REFRESH_FOLDER, DragViewModelUtil.getDragParams([dragItemInfo]));
            }
            this.addToAppListInfo([dragItemInfo]);
            // 获取应用名
            let appNameStr: string = this.getAppName(endLayoutInfo);
            if (!CheckEmptyUtils.isEmpty(appNameStr)) {
              endLayoutInfo.appName = appNameStr;
            }
            appNameStr = this.getAppName(dragItemInfo);
            if (!CheckEmptyUtils.isEmpty(appNameStr)) {
              dragItemInfo.appName = appNameStr;
            }
            let coveredItemIndex = this.getItemIndex(x, y);
            log.showInfo('before addNewFolder, coveredItem: x: %{public}d, y: %{public}d, row: %{public}d, column: %{public}d', x, y, this.getRow(coveredItemIndex), this.getColumn(coveredItemIndex));
            this.dropToCreateFolder(x, y, dragItemType, deviceType, dragItemInfo, endLayoutInfo);
            return true;
          }
        }
      }
    }
    return false;
  }

  /**
   * 检查是否支持添加
   * @param x
   * @param y
   * @param dragItemType
   * @param deviceType
   * @param dragItemInfo
   * @param endLayoutInfo
   * @returns
   */
  private checkSupportAdd(x: number, y: number, dragItemType: number, deviceType: string,
    dragItemInfo: GridLayoutItemInfo, endLayoutInfo: GridLayoutItemInfo): boolean {
    if (lockLayoutManager.isLockLayout()) {
      return false;
    }
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return false;
    }
    if (AppStorage.get('device') !== CommonConstants.DEFAULT_DEVICE_TYPE) {
      return false;
    }
    if (!this.canCover(x, y, dragItemInfo, endLayoutInfo)) {
      log.showInfo('addIconToFolder, not in folderHotArea');
      return false;
    }
    if (!FolderViewModel.canDragIn(endLayoutInfo, dragItemInfo)) {
      log.showInfo('addIconToFolder endLayoutInfo is full');
      return false;
    }
    return true;
  }

  private dropToFolder(x: number, y: number, dragItemType: number, deviceType: string, dragItemInfo: GridLayoutItemInfo,
    endLayoutInfo: GridLayoutItemInfo, isAppInFolder: (dragItemInfo: GridLayoutItemInfo,
      endLayoutInfo: GridLayoutItemInfo) => void): boolean {
    log.showWarn('add %{public}s to folder %{public}s', dragItemInfo.keyName, endLayoutInfo.folderId);
    // 触发拖动app入文件夹动效
    this.setDragAppToFolderData(endLayoutInfo.folderId ?? '', dragItemInfo.keyName ?? '', x, y);

    if (dragItemType === CommonConstants.DRAG_FROM_FOLDER || dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK &&
      deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
      // 判断文件夹中是否有这个app
      const dragLeaveFolderId: string = this.mFolderMgr.getDragLeaveFolderId();
      if (dragLeaveFolderId !== endLayoutInfo.folderId) {
        ContractedFolderCommonViewModel.getInstance().drop('drop to folder refresh', dragLeaveFolderId,
          FolderDropType.DROP_REFRESH_FOLDER, DragViewModelUtil.getDragParams([dragItemInfo]));
      }
    }
    if (DeliverUtil.isdeliverApp(dragItemInfo.intent)) {
      log.showInfo(`clear deliver app folder cache: ${dragItemInfo.bundleName}`);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_FOLDER_APP_PACKAGE_CHANGED,
        dragItemInfo.bundleName);
    }
    ContractedFolderCommonViewModel.getInstance().drop('drag to folder', endLayoutInfo.folderId,
      FolderDropType.DROP_IN_FOLDER, DragViewModelUtil.getDragParams([dragItemInfo]));
    if (dragItemType === CommonConstants.DRAG_FROM_DOCK || dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK &&
      deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
      this.deleteDockItem(dragItemInfo);
    }
    // 文件夹打点 - 拖入图标进桌面文件夹
    FolderReporter.getInstance().reportDragIconIntoFolder(dragItemInfo, endLayoutInfo);
    // 落位点为文件夹，播报应用已放入文件夹
    let dragAppname: string = this.getAppName(dragItemInfo);
    const realFolderName: string = FolderCommonUtil.getRealFolderName(endLayoutInfo.folderName);
    DragAccessibilityUtils.textAnnouncedForDropToFolder(dragAppname, realFolderName);
    return true;
  }

  private dropToCreateFolder(x: number, y: number, dragItemType: number, deviceType: string,
    dragItemInfo: GridLayoutItemInfo, endLayoutInfo: GridLayoutItemInfo): void {
    const dragPara: FolderDragItem = DragViewModelUtil.getDragParams([dragItemInfo], endLayoutInfo, dragItemType, x, y);
    ContractedFolderCommonViewModel.getInstance().drop('drag oneApp', FolderCommonConstants.INVALID_FOLDER_ID,
      FolderDropType.DROP_CREATE_FOLDER, dragPara);
    if (dragItemType === CommonConstants.DRAG_FROM_DOCK && deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_REFRESH, dragItemInfo);
    }
  }

  private addFileToFolder(x: number, y: number, dragItemInfo: GridLayoutItemInfo,
    event?: DragEvent, extraParams?: string): boolean {
    log.showInfo('desktop drag addFileToFolder');
    if (!DeviceHelper.isPC()) {
      return false;
    }
    let dragX: number = this.isDropFileToDesktop && event ? event.getWindowX() : x;
    let dragY: number = this.isDropFileToDesktop && event ? event.getWindowY() : y;
    if (!dragItemInfo) {
      log.showError('dragItemInfo is inValid');
      return false;
    }
    let isCtrlKeyDown: boolean = false;
    let isAltKeyDown: boolean = false;
    let isShiftKeyDown: boolean = false;
    if (event && event.getModifierKeyState) {
      isCtrlKeyDown = event.getModifierKeyState(['ctrl']);
      isAltKeyDown = event.getModifierKeyState(['alt']);
      isShiftKeyDown = event.getModifierKeyState(['shift']);
    }
    if (this.mEndPosition) {
      this.coveredItem = this.getItemByPosition(this.mEndPosition);
    }
    const findDragItems: GridLayoutItemInfo[] | undefined = this.getDragItems();
    if (this.coveredItem && this.canFileCover(dragX, dragY, dragItemInfo, this.coveredItem)) {
      log.showInfo('desktop drag file to another file');
      const extraData = `{"isFileCover": true, "isCtrlKeyDown": ${isCtrlKeyDown}, "isAltKeyDown": ${isAltKeyDown},
       "isShiftKeyDown": ${isShiftKeyDown}, "column": 0, "row": 0}`;
      const isContainApp: boolean = findDragItems?.some((item: GridLayoutItemInfo) => {
        return item.typeId === CommonConstants.TYPE_APP || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON;
      }) ?? false;
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)
        .eventHub.emit(`dropFileToFolder${this.coveredItem.ino}`, event, extraParams, extraData, isContainApp);
      return true;
    } else {
      if (this.isDropFileToDesktop && event &&
        !FileFolderDragHandler.getInstance().isDragToCreateFile(event, extraParams)) {
        log.showInfo('desktop drag cut file to desktop');
        this.mPageDesktopViewModel.getFileInos(event).then((fileInfos) => {
          let x: number = event.getWindowX();
          let y: number = event.getWindowY();
          this.setDragItemPosition(fileInfos, x, y);
          this.mPageDesktopViewModel.dropFileToDesktop(event, extraParams);
          this.isDropFileToDesktop = false;
        }).catch((error: Error) => {
          log.showError(TAG, `desktop drag getFileInos error ${error?.message}`);
        });
      }
      if (event && FileFolderDragHandler.getInstance().isDragToCreateFile(event, extraParams)) {
        const isContainFile: boolean | undefined = findDragItems?.some((item: GridLayoutItemInfo) => {
          return item.typeId === CommonConstants.TYPE_FOLDER || item.typeId === CommonConstants.TYPE_FILE_FOLDER;
        });
        if (isContainFile && event) {
          log.showInfo('desktop drag create file to desktop');
          this.dragPasteFile(event, extraParams ?? '', isCtrlKeyDown, isAltKeyDown, isShiftKeyDown);
        }
      }
    }
    return false;
  }

  private addToFolderWithMultiApp(x: number, y: number, deviceType: string, dragItems: GridLayoutItemInfo[],
    endLayoutInfo: GridLayoutItemInfo, endPosition: DragItemPosition | undefined, dragItemType: number): boolean {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return false;
    }
    if (deviceType !== CommonConstants.DEFAULT_DEVICE_TYPE) {
      return false;
    }
    if (dragItems.length <= 1) {
      return false;
    }
    if (endLayoutInfo == null) {
      return false;
    }
    if (FolderViewModel.isFolderFull(endLayoutInfo)) {
      log.showInfo('addToFolderWithMultiApp folder full: ' + endLayoutInfo?.folderName);
      return false;
    }
    if (!this.canCover(x, y, dragItems[0], endLayoutInfo)) {
      log.showInfo('addToFolderWithMultiApp not in folderHotArea');
      return false;
    }
    if (endLayoutInfo.typeId === CommonConstants.TYPE_FOLDER) {
      // 多选落位动效入口
      this.mFolderMgr.setMultiDropFolderId(endLayoutInfo.folderId);
      MultiSelectManager.getInstance().startDropToFolder(x, y, endLayoutInfo);
      ContractedFolderCommonViewModel.getInstance().drop('drag multiApps to folder', endLayoutInfo.folderId,
        FolderDropType.DROP_IN_FOLDER, DragViewModelUtil.getDragParams(dragItems));
      return true;
    } else if (GridLayoutUtil.isIconType(endLayoutInfo.typeId)) {
      return this.createNewFolderWithMultiApps(x, y, dragItems, endLayoutInfo, endPosition, dragItemType);
    }
    return false;
  }

  private createNewFolderWithMultiApps(x: number, y: number, dragItems: GridLayoutItemInfo[],
    endLayoutInfo: GridLayoutItemInfo, endPosition: DragItemPosition | undefined, dragItemType: number): boolean {
    // create a new folder
    log.showInfo('create new folder with multi app');
    this.addToAppListInfo(dragItems);
    ContractedFolderCommonViewModel.getInstance().drop('drag multi-apps', FolderCommonConstants.INVALID_FOLDER_ID,
      FolderDropType.MULTI_DROP_CREATE, DragViewModelUtil.getDragParams(dragItems, endLayoutInfo, dragItemType, x, y));
    return true;
  }

  private addToAppListInfo(items: GridLayoutItemInfo[]): void {
    const appList: GridLayoutItemInfo[] = this.mSettingsModel.getAppListInfo();
    items.forEach((item: GridLayoutItemInfo) => {
      const index = appList.findIndex(value => {
        return value.keyName === item.keyName;
      });
      if (index === -1) {
        appList.push(item);
      }
    });
    this.mSettingsModel.setAppListInfo(appList);
  }

  private startFormStackAnimation(dragItemInfo: GridLayoutItemInfo, endLayoutInfo: GridLayoutItemInfo,
    isFormStackFirst: boolean, dragResult: DesktopDragResult): void {
    const desktopContext = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
    if (!desktopContext) {
      log.showError('fail to start form stack animate, desktopContext is invalid');
      return;
    }
    // 通知堆叠开始执行落位动效
    const dropToStackMsg: string = FormStackEventIdUtil.getDropStackCardEventId(endLayoutInfo.formStackId);
    const dropToCardMsg: string = `dropStackCard${endLayoutInfo.cardId}`;
    if (isFormStackFirst) {
      // 堆叠展开退出进行中，需要打断退出动效，抢占节点
      FormStackManager.getInstance().getBreakFormStackExpandAnimation()?.();
    }
    // 落位动效并行动效
    desktopContext.eventHub.emit(isFormStackFirst ? dropToCardMsg : dropToStackMsg, [dragItemInfo], dragResult);
    // 通知拖拽的卡片不可见，防止打断落位动效，会先出现再下树，闪跳
    desktopContext.eventHub.emit(`${dragItemInfo.bundleName}${dragItemInfo.typeId}${dragItemInfo.cardId}`, false);
    // 通知卡片已经堆叠，避免落位时卡片原地闪烁
    desktopContext.eventHub.emit(`dragItemCard${dragItemInfo.cardId}`, true);
  }

  private isLayoutInfoInvalid(gridItem: GridLayoutItemInfo): boolean {
    return CheckEmptyUtils.isEmpty(gridItem) || !gridItem.layoutInfo ||
    CheckEmptyUtils.isEmptyArr(gridItem.layoutInfo) || CheckEmptyUtils.isEmptyArr(gridItem.layoutInfo[0]) ||
    CheckEmptyUtils.isEmpty(gridItem.layoutInfo[0][0]);
  }

  // 卡片堆叠
  private addToFormStack(pointInfo: PointInfo, dragItemInfo: GridLayoutItemInfo, endLayoutInfo: GridLayoutItemInfo,
    positionInfo: PositionInfo, dragResult: DesktopDragResult): boolean {
    // 锁定布局时不允许形成卡片堆叠
    if (lockLayoutManager.isLockLayout()) {
      log.showWarn(`addToFormStack layout is locked`);
      return false;
    }
    // 过滤不能形成堆叠场景
    if (!this.isAddToFormStack(dragItemInfo, endLayoutInfo)) {
      return false;
    }
    let isOuter: boolean = false;
    if (endLayoutInfo.typeId === CommonConstants.TYPE_FORM_STACK) {
      isOuter = FormLayoutCacheManager.getInstance().checkIfFormInExternalScreen(endLayoutInfo.formStackId);
    } else if (endLayoutInfo.typeId === CommonConstants.TYPE_CARD) {
      isOuter = FormLayoutCacheManager.getInstance().checkIfFormInExternalScreen(endLayoutInfo.cardId);
    }

    // add card to formstack
    if (endLayoutInfo.typeId === CommonConstants.TYPE_FORM_STACK && !this.isLayoutInfoInvalid(endLayoutInfo) &&
    endLayoutInfo.layoutInfo && endLayoutInfo.layoutInfo[0][0].cardDimension === dragItemInfo.cardDimension) {
      // 先判断卡片是否还在热区内，再走添加卡片到堆叠流程
      if (!this.canCover(pointInfo.x, pointInfo.y, dragItemInfo, endLayoutInfo)) {
        log.showWarn('not in form stack hot area, then squeeze');
        return false;
      }

      if (!this.mFormStackViewModel.addCardsToFormStack(endLayoutInfo.formStackId, [dragItemInfo], undefined, isOuter)) {
        log.showWarn('add one form to formstack failed');
        return false;
      }
      this.startFormStackAnimation(dragItemInfo, endLayoutInfo, false, dragResult);
      // 无障碍朗读播报落位加入堆叠卡片
      let dragItemName = this.getAppName(dragItemInfo);
      let topCardName = this.getAppName(endLayoutInfo.layoutInfo[0][endLayoutInfo.layoutInfo[0].length - 1]);
      DragAccessibilityUtils.textAnnouncedForDropToFormStack(dragItemName, topCardName);
      return true;
    } else if (endLayoutInfo.typeId === CommonConstants.TYPE_CARD && endLayoutInfo.cardDimension === dragItemInfo.cardDimension &&
      endLayoutInfo.cardId !== dragItemInfo.cardId) {
      // create a new formstack
      if (this.canCover(pointInfo.x, pointInfo.y, dragItemInfo, endLayoutInfo) &&
        dragItemInfo.cardId !== endLayoutInfo.cardId) {
        const layoutInfoList: GridLayoutItemInfo[] = [endLayoutInfo];
        layoutInfoList.push(dragItemInfo);
        if (this.mFormStackViewModel === null) {
          log.showWarn('mFormStackViewModel is null');
          return false;
        }
        if (!this.mFormStackViewModel.addNewFormStack(layoutInfoList, endLayoutInfo, undefined, false, isOuter)) {
          log.showInfo('create new formStack faild');
          return false;
        }
        this.startFormStackAnimation(dragItemInfo, endLayoutInfo, true, dragResult);
        SceneIdentificationManager.notify(SceneState.FORM_STACK_BUILD);
        // 无障碍朗读播报落位形成堆叠卡片
        let dragItemName = this.getAppName(dragItemInfo);
        let cardName = this.getAppName(endLayoutInfo);
        DragAccessibilityUtils.textAnnouncedForDropMergeToFormStack(dragItemName, cardName);
        return true;
      }
    }
    log.showInfo('can not create new formstack');
    return false;
  }

  private isAddToFormStack(dragItemInfo: GridLayoutItemInfo, endLayoutInfo: GridLayoutItemInfo): boolean {
    if (!FormStackViewModel.isSupportFormStack() || dragItemInfo.typeId !== CommonConstants.TYPE_CARD ||
      dragItemInfo?.isTransparent || endLayoutInfo === undefined || endLayoutInfo?.isTransparent) {
      return false;
    }
    // 主题卡不支持堆叠
    let themeBundleName: string = CommonConstants.THEME_MANAGER_BUNDLE;
    if (dragItemInfo.bundleName === themeBundleName || endLayoutInfo.bundleName === themeBundleName) {
      return false;
    }
    if (dragItemInfo.cardDimension === CommonConstants.CARD_DIMENSION_6x4 ||
      endLayoutInfo.cardDimension === CommonConstants.CARD_DIMENSION_6x4) {
      return false;
    }

    // 游戏卡片不支持堆叠
    if (!this.isLiveFormSupportAddToStack(dragItemInfo.gameCardInfo) ||
      !this.isLiveFormSupportAddToStack(endLayoutInfo.gameCardInfo)) {
      this.reportPreventAddCardStackEvent(dragItemInfo);
      return false;
    }
    return true;
  }

  private reportPreventAddCardStackEvent(dragItemInfo: GridLayoutItemInfo): void {
    let mFormStyleConfig = FormViewModel.getInstance(this.singleContext).getFormStyleConfig();
    let cardDimension: string = String(dragItemInfo.cardDimension);
    let dpSize: string = `${mFormStyleConfig.mFormWidth?.get(
      cardDimension)}*${mFormStyleConfig.mFormHeight?.get(cardDimension)}`;
    const event: PreventAddCardStackEvent = {
      packageName: dragItemInfo.bundleName,
      cellSize: `${dragItemInfo.area?.[0]}*${dragItemInfo.area?.[1]}`,
      dpSize: dpSize,
      formId: dragItemInfo.cardId ?? '',
      moduleName: dragItemInfo.moduleName ?? '',
      formName: dragItemInfo.cardName ?? '',
      preventType: 0,
    };
    FormHiSysEventReporter.reportPreventAddCardStack(event);
  }

  private sendMessageToSinglePageWhenFoldExpandSqueezed(): void {
    // 发事件给singlePage，确保当前屏zIndex最高
    const desktopContext = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
    if (desktopContext && this.mEndPosition) {
      desktopContext.eventHub.emit(EditModeConstants.EVENT_FOLD_EXPAND_DUAL_SQUEEZED, this.mEndPosition.page);
    }
  }

  private tryFoldExpandDualSqueezed(dragDelegate: CellLayoutDragDelegate, dragItemInfo: GridLayoutItemInfo,
    cellAndSpan: CellAndSpan, curPageSqueezeItems: GridLayoutItemInfo[]): ItemConfiguration {
    this.sendMessageToSinglePageWhenFoldExpandSqueezed();
    let nearPageSqueezeItems: GridLayoutItemInfo[] = this.getPageLayoutInfo(this.getNearPage());
    let solution = dragDelegate.getNearReorderSolution(cellAndSpan, dragItemInfo, curPageSqueezeItems,
      nearPageSqueezeItems, new ItemConfiguration(0, 0, 0, 0));
    this.isNearReArrangeSolutionSuccess = dragDelegate?.isNearReArrangeSolutionSuccess() || false;
    return solution;
  }

  private getNearPage(): number {
    let pageIndex = this.getDragPageIndex();
    let count: number = PageInfoManager.getInstance().getDisplayCount();
    const leftPageIndex = Math.floor(pageIndex / count) * count;
    let nearPage: number = pageIndex;
    let foldStatus: boolean = this.isFoldExpandStatus() || this.isSuperFold;
    if (foldStatus) {
      const currentDisplayCount = PageInfoManager.getInstance().getDisplayCount();
      if (this.indexInFoldExpand % currentDisplayCount === 0) {
        nearPage = this.indexInFoldExpand + leftPageIndex + 1;
      } else if (this.indexInFoldExpand % currentDisplayCount === currentDisplayCount - 1) {
        nearPage = this.indexInFoldExpand + leftPageIndex - 1;
      } else {
        // 获取当前页上不含拖拽元素的元素集合，当前拖拽元素的原位置应该算为空位
        const currentPageLayoutInfo = this.getPageLayoutInfo(this.indexInFoldExpand + leftPageIndex - 1);
        const dragDelegate: CellLayoutDragDelegate | undefined = this.getDragDelegate();
        let gridOccupyStatus: GridOccupyStatus | undefined = dragDelegate?.getGridOccupyStatus(currentPageLayoutInfo);
        let res = this.getNearestAreaTwo(dragDelegate, this.cellAndSpan, gridOccupyStatus);
        if (res[0] > -1 && res[1] > -1) {
          nearPage = this.indexInFoldExpand + leftPageIndex - 1;
        } else {
          nearPage = this.indexInFoldExpand + leftPageIndex + 1;
        }
      }
    }
    if (this.isSuperFold) {
      return this.getCurrentPageIndex() ? 0 : 1;
    }
    log.showInfo(`getNearPage current ${this.indexInFoldExpand + pageIndex} target ${nearPage}`);
    return nearPage;
  }

  private getDragMoveItemTranslateOffset(nearPage: number): number {
    let offset: number = 0;
    if (!this.lastFoldStatus || !this.isNearReArrangeSolutionSuccess) {
      return 0;
    }
    let pageIndex = this.getDragPageIndex();
    const currentDisplayCount = PageInfoManager.getInstance().getDisplayCount();
    const leftPageIndex = Math.floor(pageIndex / currentDisplayCount) * currentDisplayCount;
    let screenWidth = AppStorage.get<number>('screenWidth') as number;
    if (nearPage > (this.indexInFoldExpand + leftPageIndex)) {
      offset = screenWidth / currentDisplayCount - this.mPageDesktopStyleConfig.mFoldPaddingSide;
    } else if (nearPage < (this.indexInFoldExpand + leftPageIndex)) {
      offset = -screenWidth / currentDisplayCount + this.mPageDesktopStyleConfig.mFoldPaddingSide;
    }
    offset *= EditModeUtils.getDesktopScale();
    if (RTLUtil.isRTL()) {
      offset = -offset;
    }
    return offset;
  }

  /**
   * 桌面满18屏时多选拖拽元素回到各自起始的文件夹中，文件夹不存在的新建文件夹
   *
   * @param apps 同一文件夹的多选拖拽的元素
   * @param folder 要回去的文件夹
   */
  private backToOriginFolderWhenNoSpaceToDrop(apps: GridLayoutItemInfo[], folder: GridLayoutItemInfo): void {
    if (folder && folder.layoutInfo && folder.layoutInfo.flat().length - 1 === apps.length) {
      let leftApp = folder.layoutInfo.flat().find(item => {
        let index = apps.findIndex(app => MultiSelectManager.getInstance().getUniqueId(app) ===
        MultiSelectManager.getInstance().getUniqueId(item));
        if (index === -1) {
          return true;
        } else {
          return false;
        }
      });
      let cached = this.mLayoutCacheManager.selectGridLayoutItemByItem(leftApp);
      ContractedFolderCommonViewModel.getInstance().createNewFolder('no space create folder', cached, apps);
    } else {
      this.mFolderMgr.addItemsToFolder('no space back to folder', apps, folder.folderId, false);
    }
  }

  // 更新拖拽元素的位置，无法找到空位时返回false
  private updateDragItemPosition(position: number[], dragItems: GridLayoutItemInfo[],
    dragDelegate: CellLayoutDragDelegate, page: number, canForward: boolean): boolean {
    let updateInfo: GridLayoutItemInfo[] = this.getUpdateInfo(position, dragItems, dragDelegate, page, canForward);
    let updateLength: number = updateInfo.length;
    if (updateLength === 0) {
      log.showInfo('can not find any blank position');
      // 多选时，若找不到落位位置，将拖拽元素按拖出文件夹插回去
      if (MultiSelectManager.getInstance().isInMultiSelect) {
        let allSelectedItems = MultiSelectManager.getInstance().getSelectedItemSortByFolder();
        allSelectedItems.forEach((apps, folder) => {
          this.backToOriginFolderWhenNoSpaceToDrop(apps, folder);
        });
      }
      return false;
    }
    let maxPage: number = this.mLayoutCacheManager.selectMaxPageCount();
    let pageCount: number = this.mLayoutCacheManager.selectPageCount();
    let lastUpdate: GridLayoutItemInfo = updateInfo[updateLength - 1];
    // 最后一个元素的页数在当前页前面说明已经找到最后一页并返回前面页来找了
    let updatePageCount: number = (lastUpdate.page ?? 0) < page ? maxPage : (lastUpdate.page ?? 0) + 1;
    if (updatePageCount > pageCount) {
      this.mLayoutCacheManager.updatePageCount(updatePageCount, BusinessType.BUSINESS_DRAG);
    }
    const cache2RdbEvent = Cache2RdbHelper.getInstance();
    for (let i = 0; i < updateLength; i++) {
      let item = updateInfo[i];
      // 卡片的添加场景需要发送EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD事件，不需要在此处添加
      if (item.typeId === CommonConstants.TYPE_CARD) {
        continue;
      }
      item.container = CommonConstants.CONTAINER_DESKTOP;
      item.areaType = CommonConstants.TYPE_AREA_DESKTOP;
      // 快捷方式图标写库
      ShortcutViewModel.getInstance().updateShortcutIcon(item);
      cache2RdbEvent.addItem(CommonConstants.DRAG_RDB_EVENT, item);
      let cached = this.mLayoutCacheManager.selectGridLayoutItemByItem(item);
      if (cached != null) {
        continue;
      }
      this.mLayoutCacheManager.insertGridLayoutItemInfo(item, BusinessType.BUSINESS_DRAG, false, undefined, this.singleContext);
    }
    this.mLayoutCacheManager.updateGridLayoutItemsPositionById(updateInfo, BusinessType.BUSINESS_DRAG, true, false,
      launcherStatusUtil.getShowOutLauncherStatus());
    if (updateLength < dragItems.length) {
      let overflowItems: GridLayoutItemInfo[] = dragItems.slice(updateLength);
      ContractedFolderCommonViewModel.getInstance().createNewFolder('update drag item', lastUpdate, overflowItems);
    }
    return true;
  }

  private getUpdateInfo(position: number[], dragItems: GridLayoutItemInfo[],
    dragDelegate: CellLayoutDragDelegate, page: number, canForward: boolean): GridLayoutItemInfo[] {
    let updateInfo: GridLayoutItemInfo[] = [];
    let column = position[0];
    let row = position[1];
    let param: FindPositionParam = new FindPositionParam(dragItems, updateInfo);
    if (!this.mGridConfig) {
      return updateInfo;
    }
    // 先从落点从左往右开始找空位
    if (this.findPositionStep(param, dragDelegate, page, [column, this.mGridConfig.column - 1], [row, row])) {
      return updateInfo;
    }
    // 对于非第一列的落点，从落点左侧从右往左开始找空位
    if (column > 0 && this.findPositionStep(param, dragDelegate, page, [column - 1, 0], [row, row])) {
      return updateInfo;
    }
    // 对于非最后一行的落点，从下方行开始从上往下找行，每一行从左往右找空位
    if (row < this.mGridConfig.row - 1 &&
    this.findPositionStep(param, dragDelegate, page, [0, this.mGridConfig.column - 1],
      [row + 1, this.mGridConfig.row - 1])) {
      return updateInfo;
    }
    // 对于非第一行的落点，从上方一行开始从下往上找行，每一行从左往右找空位
    if (row > 0 && this.findPositionStep(param, dragDelegate, page, [0, this.mGridConfig.column - 1], [row - 1, 0])) {
      return updateInfo;
    }
    // 从下一页开始从前往后找页直到最大页数，每一页从上往下找行，每一行从左往右找空位
    let maxPage = this.mLayoutCacheManager.selectMaxPageCount();
    for (let i = page + 1; i < maxPage; i++) {
      if (this.findPositionStep(param, dragDelegate, i, [0, this.mGridConfig.column - 1],
        [0, this.mGridConfig.row - 1])) {
        return updateInfo;
      }
    }
    if (canForward) {
      // 从第一页开始从前往后找页直到落点所在页，每一页从上往下找行，每一行从左往右找空位
      for (let i = 0; i < page; i++) {
        if (this.findPositionStep(param, dragDelegate, i, [0, this.mGridConfig.column - 1],
          [0, this.mGridConfig.row - 1])) {
          return updateInfo;
        }
      }
    }
    return updateInfo;
  }

  private findPositionStep(param: FindPositionParam, dragDelegate: CellLayoutDragDelegate, page: number,
    column: number[], row: number[]): boolean {
    if (param.page !== page) {
      param.page = page;
      param.gridOccupyStatus = this.getGridOccupyStatus(page, param.keySet, dragDelegate);
    }
    let rowIncrease: boolean = row[0] <= row[1];
    let columnIncrease: boolean = column[0] <= column[1];
    for (let i = row[0]; rowIncrease ? i <= row[1] : i >= row[1]; rowIncrease ? i++ : i--) {
      for (let j = column[0]; columnIncrease ? j <= column[1] : j >= column[1]; columnIncrease ? j++ : j--) {
        if (this.processPositionFound(param, j, i)) {
          return true;
        }
      }
    }
    return false;
  }

  private getGridOccupyStatus(page: number, keySet: Set<string>,
    dragDelegate: CellLayoutDragDelegate): GridOccupyStatus {
    let layoutInfo: GridLayoutItemInfo[] = this.mLayoutCacheManager.selectGridLayoutItemsByPage(page);
    layoutInfo = layoutInfo.filter((value: GridLayoutItemInfo) => !keySet.has(GridLayoutUtil.generateUniqueKey(value)));
    return dragDelegate.getGridOccupyStatus(layoutInfo);
  }

  // 根据找到的位置进行处理，若元素已经全部找到位置则返回true，否则返回false
  private processPositionFound(param: FindPositionParam, column: number, row: number): boolean {
    if (!param.gridOccupyStatus || !param.gridOccupyStatus.isFree(column, row)) {
      return false;
    }
    param.gridOccupyStatus.markStatus(column, row, GridOccupyStatusEnum.OCCUPIED);
    param.updateInfo.push(this.getNewDragItemInfo(param.dragItems[param.index], [column, row], param.page));
    if (param.index === param.dragItems.length - 1) {
      return true;
    } else {
      param.index++;
      return false;
    }
  }

  private getNewDragItemInfo(dragItemInfo: GridLayoutItemInfo, position: number[], page: number): GridLayoutItemInfo {
    let newDragItemInfo: GridLayoutItemInfo = ObjectCopyUtil.deepClone(dragItemInfo);
    newDragItemInfo.column = position[0];
    newDragItemInfo.row = position[1];
    newDragItemInfo.page = page;
    newDragItemInfo.container = CommonConstants.CONTAINER_DESKTOP;
    newDragItemInfo.areaType = CommonConstants.TYPE_AREA_DESKTOP;
    return newDragItemInfo;
  }

  /**
   * 用于计算拖拽元素大小大于1的元素在本页上是否有空间容纳
   */
  private hasFreeArea(dragDelegate: CellLayoutDragDelegate, dragItemInfo: GridLayoutItemInfo): boolean {
    const currentPageLayoutInfo = this.getCurrentPageLayoutInfo(dragItemInfo);
    let gridOccupyStatus: GridOccupyStatus = dragDelegate.getGridOccupyStatus(currentPageLayoutInfo);

    // 构造当前页矩阵
    let rows: number = gridOccupyStatus.getSizeY();
    let colum: number = gridOccupyStatus.getSizeX();
    let arrays: number[][] = [];
    for (let i = 0; i < rows; i++) {
      arrays[i] = [];
      for (let j = 0; j < colum; j++) {
        arrays[i][j] = 0;
      }
    }

    // 求出当前页每个宫格向下数最大的矩形大小
    for (let i = rows - 1; i >= 0; i--) {
      for (let j = 0; j < colum; j++) {
        if (gridOccupyStatus.isFree(j, i)) {
          arrays[i][j] = 1 + (i + 1 === rows ? 0 : arrays[i + 1][j]);
        } else {
          arrays[i][j] = 0;
        }
      }
    }

    // 根据拖拽元素的大小(w*h)，遍历每行是否有连续w个高度大于h的宫格，有则代表当前页能放下该元素，没有则无法放下
    let area: number[] | undefined = dragItemInfo.area;
    if (!area) {
      return false;
    }
    for (let i = 0; i < rows - area[1] + 1; i++) {
      let rowArrays: number[] = arrays[i];
      for (let j = 0; j < colum - area[0] + 1; j++) {
        let isFree: boolean = true;
        for (let k = 0; k < area[0]; k++) {
          isFree = isFree && (rowArrays[j + k] >= area[1]);
        }
        if (isFree) {
          return true;
        }
        isFree = true;
      }
    }

    // 当前屏幕无空间增加位置状态维测日志
    log.showInfo('not has free Area.');
    this.printCurrentPageItem(currentPageLayoutInfo);

    return false;
  }

  /**
   * 用于计算当前页是否有控件容纳1*1大小的拖拽元素
   *
   * @returns true:有空间，false无空间
   */
  private hasEnoughArea(): boolean {
    const dragItemInfoList: GridLayoutItemInfo[] = this.getDragItems() ?? [];
    let dragItemUniqueSet = new Set<string>();
    dragItemInfoList.forEach((item: GridLayoutItemInfo) => {
      if (GridLayoutUtil.isValidLayoutItem(item)) {
        dragItemUniqueSet.add(GridLayoutUtil.generateUniqueKey(item));
      }
    });
    if (dragItemUniqueSet.size === 0) {
      return false;
    }
    let pageIndex: number = this.getCurrentPageIndex();
    const layoutInfo = this.mLayoutCacheManager.selectGridLayoutItemsByPage(pageIndex);

    let occupies: number = 0;
    layoutInfo.forEach(item => {
      if (!dragItemUniqueSet.has(GridLayoutUtil.generateUniqueKey(item)) && item.area) {
        occupies += item.area[0] * item.area[1];
      }
    });
    if (this.mGridConfig && dragItemInfoList[0].area) {
      let frees = this.mGridConfig.column * this.mGridConfig.row - occupies;
      let dragAreas = dragItemInfoList[0].area[0] * dragItemInfoList[0].area[1];
      if (frees >= dragAreas) {
        return true;
      }
    }

    // 当前屏幕无空间增加位置状态维测日志
    log.showInfo('not hasEnoughArea.pageIndex:%{public}d, occupies: %{public}d', pageIndex, occupies, dragItemInfoList[0]);
    this.printCurrentPageItem(layoutInfo);

    return false;
  }

  private printCurrentPageItem(appListInfo: GridLayoutItemInfo[]): void {
    appListInfo?.forEach(item => {
      log.showInfo('item name=%{public}s, column= %{public}d, row= %{public}d, area=[%{public}d,%{public}d]',
        item.appName, item.column, item.row, item.area?.[0], item.area?.[1]);
    });
  }

  private updateCurrentPage(): void {
    let pageIndex: number = this.getCurrentPageIndex();
    let curPageInfo = this.mLayoutCacheManager.selectGridLayoutItemsByPage(pageIndex);
    // 先更新当前可见页布局触发动效，全布局刷新之后再执行
    (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub
      .emit(EventConstants.EVENT_UPDATE_CURRENT_PAGE, pageIndex, curPageInfo);

    // 折叠屏展开态下，需要刷新当前可见的两页
    let foldStatus: boolean = this.isFoldExpandStatus() || this.isSuperFold;
    if (foldStatus) {
      let nearPage = this.getNearPage();
      let nearPageInfo = this.mLayoutCacheManager.selectGridLayoutItemsByPage(nearPage);
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub
        .emit(EventConstants.EVENT_UPDATE_CURRENT_PAGE, nearPage, nearPageInfo);
    }
  }

  private printLayoutInfo(layoutInfo: GridLayoutItemInfo[]): void {
    // 桌面图标过多方法耗时，调试时需要请自行打开
    if (!this.mIsPrintLog) {
      return;
    }
    log.showDebug(`printLayoutInfo layoutInfo:${layoutInfo.length}`);
    layoutInfo.forEach(view => {
      log.showDebug('printLayoutInfo view bundleName: %{public}s, keyName: %{public}s, moduleName: %{public}s', view.bundleName, view.keyName, view.moduleName);
    });
  }

  /**
   * 拖拽中的item起托的位置是否因挤位被占了
   *
   * @param targetItemInfo 拖拽中的item
   * @returns true 表示被占了，false 表示没被占
   */
  public isPositionOccupied(targetItemInfo?: GridLayoutItemInfo): boolean {
    log.showInfo('start judge item is occupied.');
    if (!this.currentMoveItemList || this.currentMoveItemList.length === 0) {
      log.showInfo('currentMoveItemList is empty, item position is not occupied.');
      return false;
    }
    if (!targetItemInfo || !targetItemInfo.area || targetItemInfo.area.length <= 1 || targetItemInfo?.page === undefined) {
      log.showInfo('params is illegal.');
      return true;
    }
    let isSamePage: boolean = false;
    let currentPageIndex: number = desktopUtil.getPageIndexValue();
    if (this.isFoldExpandStatus()) {
      isSamePage = Math.floor(targetItemInfo.page / NUM_HALF) === Math.floor(currentPageIndex / NUM_HALF);
    } else {
      isSamePage = targetItemInfo.page === currentPageIndex;
    }
    if (!isSamePage) {
      log.showInfo('params is illegal.');
      return true;
    }
    let isPositionOccupied: boolean = false;
    try {
      const left = targetItemInfo.column ?? 0;
      const top = targetItemInfo.row ?? 0;
      const right = left + targetItemInfo.area[0];
      const bottom = top + targetItemInfo.area[1];
      log.showInfo(`left: ${left}, top: ${top}, right: ${right}, bottom: ${bottom}`);
      for (let i: number = 0; i < this.currentMoveItemList.length; i++) {
        const item = this.currentMoveItemList[i];
        if (item.area?.length <= 1) {
          continue;
        }
        // 通过判断2个矩形是否有交集部分来判断起拖位置是否被占用
        if (item.column >= right || item.row >= bottom || item.column + item.area[0] <= left || item.row + item.area[1] <= top) {
          isPositionOccupied = false;
        } else {
          isPositionOccupied = true;
          break;
        }
      }
    } catch (exception) {
      log.showError('judge isPositionOccupied occurs error');
      return true;
    }
    log.showInfo(`item position is occupied: ${isPositionOccupied}`);
    return isPositionOccupied;
  }

  /**
   * copy a new position object by original position
   *
   * @param position - original position
   */
  private copyPosition(position: DragItemPosition): DragItemPosition | undefined {
    if (CheckEmptyUtils.isEmpty(position)) {
      log.showError('copyPosition: position is empty');
      return undefined;
    }
    const directionPosition: DragItemPosition = {
      page: position.page,
      row: position.row,
      column: position.column,
      x: position.x,
      y: position.y
    };
    return directionPosition;
  }

  /**
   * 新的删除空白页逻辑， 保留startPosition参数是为了兼容， 减少修改量
   * @param endPosition
   * @param msg 调用方信息
   */
  public deleteBlankPageAfterDragging(endPosition?: DragItemPosition | null, msg: string = ''): void {
    const pageCount = this.mLayoutCacheManager.selectPageCount();
    // 拖拽过程中是否添加了空白页
    const isAddByDraggingFlag = this.mPageDesktopViewModel.isAddByDragging();

    const isExpand = this.isFoldExpandStatus();
    // 直板屏一次删一页， 折叠屏一次两页
    const adjustCount: number = isExpand ? FOLD_DEVICE_DELETE_PAGE : 1;
    // 当前流程中删除的页面
    const deletedPages: Set<number> = new Set();
    let logMsg: string = `deleteBlankPageAfterDragging by ${msg};`;
    // 拖拽中新增了页， 判断有没有用到
    if (isAddByDraggingFlag && !this.isMoveToLastPage(endPosition, pageCount)) {
      this.mLayoutCacheManager.updatePageCount(pageCount - adjustCount, BusinessType.BUSINESS_DRAG, true);
      logMsg += 'deleted added page; ';
      for (let i = 0; i < adjustCount; i++) {
        deletedPages.add(pageCount - 1 - i);
      }
    }

    // 删除起拖页 page页码 从大到小删
    let dragStartPageArr = Array.from(this.dragStartPage.values()).filter(x => typeof x === 'number');
    dragStartPageArr.sort((a, b) => b - a);
    logMsg += `dragStartPage ${dragStartPageArr.toString()};`;
    dragStartPageArr.forEach((pageIndex: number) => {
      if (deletedPages.has(pageIndex)) {
        return;
      }
      if (this.mPageDesktopModel.deleteBlankPageFromLayoutInfo(pageIndex)) {
        deletedPages.add(pageIndex);
        if (isExpand) {
          deletedPages.add(this.mPageDesktopModel.getNeighborPage(pageIndex));
        }
      }
    });

    logMsg += `deleted page ${Array.from(deletedPages.values()).join(',')};`;
    // 更新pageIndex
    if (endPosition) {
      const currentPageIndex = Math.floor(endPosition.page / adjustCount) * adjustCount;
      const newPageIndex =
        currentPageIndex - Array.from(deletedPages.values()).filter(pageIndex => pageIndex < currentPageIndex).length;
      AppStorage.setOrCreate(desktopUtil.getPageIndex(), newPageIndex);
      logMsg += `pageIndex change ${currentPageIndex} => ${newPageIndex};`;
    }
    log.showInfo(logMsg);
    this.mPageDesktopViewModel.setAddByDragging(false);
    if (deletedPages.size > 0) {
      this.dragStartPage.clear();
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
    }
  }

  /**
   * 删除拖拽过程中新建的空白页，仅针对落位dock栏等新建页不会被使用的场景
   */
  deleteBlankPageAddByDragging(dragItemType: number): void {
    let pageCount = this.mLayoutCacheManager.selectPageCount();
    const isAddByDragging: boolean = this.mPageDesktopViewModel.isAddByDragging();
    let isDeleteLastPage: boolean = false;
    let isCurLastPage: boolean = false;
    let curPageIndex: number = this.getCurrentPageIndex();
    let deletePageCount: number = this.isFoldExpandStatus() ? FOLD_DEVICE_DELETE_PAGE : 1;
    if (isAddByDragging) {
      log.showInfo('deleteBlankPageAddByDragging start, pageCount: %{public}d, curPageIndex: %{public}d', pageCount, curPageIndex);
      pageCount -= deletePageCount;
      isCurLastPage = pageCount <= curPageIndex;
      isDeleteLastPage = true;
    }
    this.mPageDesktopViewModel.setAddByDragging(false);
    if (isDeleteLastPage) {
      if (isCurLastPage) {
        this.mPageDesktopModel.setPageIndex(pageCount - deletePageCount);
      }
      this.mLayoutCacheManager.updatePageCount(pageCount, BusinessType.BUSINESS_DRAG, false);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
      log.showInfo('deleteBlankPageAddByDragging success');
    }
  }

  private isMoveToLastPage(endPosition: DragItemPosition | undefined | null, pageCount: number): boolean {
    if (this.isFoldExpandStatus()) {
      return !(endPosition && endPosition.page + NUM_HALF !== pageCount &&
        endPosition.page + 1 !== pageCount);
    } else {
      return !(endPosition && endPosition.page !== pageCount - 1);
    }
  }

  private getStartLayoutInfo(dragItemInfo: GridLayoutItemInfo): GridLayoutItemInfo | undefined {
    return this.mLayoutCacheManager.selectGridLayoutItemByItem(dragItemInfo);
  }

  /**
   *
   * @param pointInfo 拖动item的中心伪坐标
   * @param coveredRectLeftX 被覆盖item左边x轴坐标
   * @param coveredRectTopY 被覆盖item上边y轴坐标
   * @param height 卡片高
   * @param weight 卡片宽
   */
  private isInFormHotArea(pointInfo: PointInfo, rectInfo: RectInfo, height: number, width: number): boolean {
    let dragRectLeftX: number = pointInfo.x - width / NUM_HALF;
    let dragRectTopY: number = pointInfo.y - height / NUM_HALF;
    let overlapRectWidth: number = width - Math.abs(dragRectLeftX - rectInfo.left);
    let overlapRectHeight: number = height - Math.abs(dragRectTopY - rectInfo.top);
    if (overlapRectWidth > 0 && overlapRectHeight > 0) {
      return ((overlapRectWidth * overlapRectHeight) >= (width * height * 0.6));
    }
    return false;
  }

  /**
   * set AppData from app to Folder
   *
   * @param folderId - onDropFolderId
   * @param appBundleName - dragAppBundleName
   * @param appPositionX - onDropPositionX
   * @param appPositionY - onDropPositionY
   */
  private setDragAppToFolderData(folderId: string, appKeyName: string, appPositionX: number, appPositionY: number): void {
    const dragAppToFolderData: DragAppToFolderData = {
      folderId: folderId,
      appKeyName: appKeyName,
      appPositionX: appPositionX,
      appPositionY: appPositionY,
    };
    this.mFolderMgr.setDragAppToFolder(dragAppToFolderData);
  }

  appDragMove(x: number, y: number, appItemWidth: number, dragItemType: number): void {
    if (this.mBigFolderViewModel.getFolderAnimationCount() !== 0) {
      log.showInfo('inFolderAnimation, appDragMove interrupt');
      return;
    }
    log.showDebug('in appDragMove');
    // if finger doesn't change, don't shake again.
    if (CheckEmptyUtils.isEmpty(this.dragEndItemIndex) || !this.mEndPosition || appItemWidth === -1) {
      log.showDebug('appDragMove: dragEndItem is invalid');
      return;
    }
    // fingers not hovering
    let page = this.getCurrentPageIndex();
    if (RTLUtil.isRTL()) {
      if (page & 1) {
        page--;
      } else {
        page++;
      }
    }
    let centerX = this.getPositionByRowAndColumnWithoutRTL(this.mEndPosition.row, this.mEndPosition.originColumn ?? 0, page)[0];
    let isSqueezeBackwards = centerX + appItemWidth / HALF_OF_WIDTH_OR_WIDTH > x ? true : false;
    if (RTLUtil.isRTL()) {
      isSqueezeBackwards = !isSqueezeBackwards;
    }
    log.showInfo(`appDragMove x:%{public}d y:%{public}d centerX:%{public}d appItemWidth:%{public}d isSqueezeBackwards:%{public}s`,
      x, y, centerX, appItemWidth, isSqueezeBackwards);
    // calculate item position
    this.computeAppItemSqueezed(isSqueezeBackwards, x, y, dragItemType);
    // z字形挤位失败时，尝试反向挤位
    if (!this.isSqueezeSuccess) {
      this.computeAppItemSqueezed(!isSqueezeBackwards, x, y, dragItemType);
    }
    this.lastMoveItemIndex = this.dragEndItemIndex;
    this.lastMovePageIndex = this.mEndPosition.page;
  }

  computeAppItemNSqueezed(isSqueezeBackwards: boolean, x: number, y: number, dragItemType: number): void {
    log.showDebug('in computeAppItemNSqueezed isSqueezeBackwards: ' + isSqueezeBackwards + 'x: ' + x + 'y: ' + y + 'dragItemType: ' + dragItemType);
    this.currentMoveItemList = [];
    // get pageIndex
    if (!this.mStartPosition || !this.mEndPosition || CheckEmptyUtils.isEmpty(this.mStartPosition.page) ||
    CheckEmptyUtils.isEmpty(this.mEndPosition.page)) {
      log.showError('get page failed');
      return;
    }
    let startPageIndex = this.mStartPosition.page;
    let endPageIndex = this.mEndPosition.page;
    let isItemBackToFront: boolean = false;
    if (startPageIndex === endPageIndex) {
      this.dragStartItemIndex = this.getItemIndex(this.mStartPosition.x, this.mStartPosition.y);
      isItemBackToFront = this.dragEndItemIndex < this.dragStartItemIndex;
      log.showInfo(`desktop drag dragStartItemIndex:${this.dragStartItemIndex}, dragEndItemIndex:${this.dragEndItemIndex}, isBackToFront:${isItemBackToFront}`);
    } else {
      this.dragStartItemIndex = 0;
      log.showWarn('desktop drag startPageIndex not equal endPageIndex');
    }

    if (!this.calculateSqueezedBackwards(isItemBackToFront, x, y)) {
      log.showInfo('desktop drag calculateSqueezedMoveItemList squeeze fail');
      this.currentMoveItemList = [];
      return;
    }
    // notify last items (not contain current items) reset its position
    this.lastMoveItemList?.forEach(lastMoveItem => {
      this.resetMoveItem(lastMoveItem);
    });

    // send move and shake event
    let squeezeAnimationDelayCount: number = 0;
    this.currentMoveItemList.forEach(item => {
      log.showDebug(`need to emit, item:${item.appName}, isRepeat:${item.isRepeatItem}`);
      if (item.isRepeatItem) {
        return;
      }
      let direction: number = isSqueezeBackwards ?
        (item.position[1][0] - item.position[0][0] > 0 || item.position[1][1] - item.position[0][1] > 0 ? 1 : -1) :
        (item.position[1][0] - item.position[0][0] < 0 || item.position[1][1] - item.position[0][1] < 0 ? -1 : 1);
      item.shake = direction;
      if (GridLayoutUtil.isIconType(item.typeId) || item.typeId === CommonConstants.TYPE_FILE_FOLDER) {
        if (item.isShowSqueezeAnimation === false || !item.squeezeExtraParam) {
          return;
        }
        item.squeezeExtraParam.delayTime = squeezeAnimationDelayCount * DragConstants.SQUEEZED_DELAY_TIME_FOR_PC;
        if (squeezeAnimationDelayCount < DragConstants.SQUEEZED_DELAY_COUNT_FOR_PC) {
          // 前几个图标挤位时，通过添加不同的动画延迟来模拟“波浪型”挤位效果
          squeezeAnimationDelayCount++;
        }
        DragEventManager.getInstance(launcherStatusUtil.getShowOutLauncherStatus())
          .startSqueezedInDesktop(this.getItemEventKey(item), item.position, item.squeezeExtraParam);
      }
    });
    this.lastMoveItemList = [];
    this.lastMoveItemList = JSON.parse(JSON.stringify(this.currentMoveItemList));
    this.lastMoveItemIndex = this.getDragEndPositionIndex(this.mEndPosition.x, this.mEndPosition.y);
    this.isSqueezeSuccess = true;
    this.isStartToSqueeze = true;
    this.lastMovePageIndex = this.mEndPosition.page;
  }

  computeAppItemReNSqueezed(isSqueezeBackwards: boolean, x: number, y: number, dragItemType: number): void {
    log.showDebug('in computeAppItemReNSqueezed isSqueezeBackwards: ' + isSqueezeBackwards + 'x: ' + x + 'y: ' + y + 'dragItemType: ' + dragItemType);
    this.currentMoveItemList = [];
    if (!this.mStartPosition || !this.mEndPosition || CheckEmptyUtils.isEmpty(this.mStartPosition.page) ||
    CheckEmptyUtils.isEmpty(this.mEndPosition.page)) {
      log.showError('get page failed');
      return;
    }
    let startPageIndex = this.mStartPosition.page;
    let endPageIndex = this.mEndPosition.page;
    let isItemBackToFront: boolean = false;
    if (startPageIndex === endPageIndex) {
      this.dragStartItemIndex = this.getItemIndex(this.mStartPosition.x, this.mStartPosition.y);
      isItemBackToFront = this.dragEndItemIndex < this.dragStartItemIndex;
      log.showInfo(`desktop drag dragStartItemIndex:${this.dragStartItemIndex}, dragEndItemIndex:${this.dragEndItemIndex}, isBackToFront:${isItemBackToFront}`);
    } else {
      log.showInfo('startPageIndex not equal endPageIndex');
    }
    if (!this.calculateReSqueezedBackwards(isItemBackToFront, x, y)) {
      log.showInfo('desktop drag calculateSqueezedMoveItemList squeeze fail');
      this.currentMoveItemList = [];
      return;
    }
    this.lastMoveItemList?.forEach(lastMoveItem => {
      this.resetMoveItem(lastMoveItem);
    });
    this.currentMoveItemList.forEach(item => {
      log.showDebug(`need to emit, item:${item.appName}, isRepeat:${item.isRepeatItem}`);
      if (!item.isRepeatItem) {
        let direction: number = isSqueezeBackwards ?
          (item.position[1][0] - item.position[0][0] > 0 || item.position[1][1] - item.position[0][1] > 0 ? 1 : -1) :
          (item.position[1][0] - item.position[0][0] < 0 || item.position[1][1] - item.position[0][1] < 0 ? -1 : 1);
        item.shake = direction;
      }
    });
    this.lastMoveItemList = [];
    this.lastMoveItemList = JSON.parse(JSON.stringify(this.currentMoveItemList));
    this.lastMoveItemIndex = this.getDragEndPositionIndex(this.mEndPosition.x, this.mEndPosition.y);
    this.isSqueezeSuccess = true;
    this.isStartToSqueeze = true;
    this.lastMovePageIndex = this.mEndPosition.page;
  }

  private calculateSqueezedBackwards(isItemBackToFront: boolean, x: number, y: number): boolean {
    let tmpMoveItemList: MoveItem[] = JSON.parse(JSON.stringify(this.currentMoveItemList));
    if (!this.calculateSqueezedMoveItemList(true, isItemBackToFront, x, y)) {
      log.showInfo('desktop drag squeezed backwards not enough space, start forwards');
      // 后向空间不足，向前挤
      this.currentMoveItemList = tmpMoveItemList;
      return this.calculateSqueezedMoveItemList(false, isItemBackToFront, x, y);
    }
    return true;
  }

  private getExtraRowPosition(oldPosition: number[], isSqueezeBackwards: boolean, item: GridLayoutItemInfo): number[] {
    let positionY: number = 0;
    if (!this.mGridConfig) {
      return [oldPosition[0], positionY];
    }
    if (item.row === (this.mGridConfig.row - 1) || item.row === 0) {
      positionY = isSqueezeBackwards ? oldPosition[1] + this.mGridItemHeight : oldPosition[1] - this.mGridItemHeight;
      return [oldPosition[0], positionY];
    }
    const row: number = isSqueezeBackwards ? this.mGridConfig.row - 1 : 0;
    const squeezePosition = this.isSuperFold ? this.getPositionByRowAndColumn(row, 0, item.page) :
    this.getPositionByRowAndColumn(row, 0);
    positionY = isSqueezeBackwards ? squeezePosition[1] + this.mGridItemHeight :
      squeezePosition[1] - this.mGridItemHeight;
    return [oldPosition[0], positionY];
  }

  private calculateReSqueezedBackwards(isItemBackToFront: boolean, x: number, y: number): boolean {
    let tmpMoveItemList: MoveItem[] = JSON.parse(JSON.stringify(this.currentMoveItemList));
    const dropResult: boolean = this.calculateMultiItemDropResult(x, y);
    if (!dropResult) {
      log.showInfo('calculateReSqueezedBackwards, false');
      this.currentMoveItemList = tmpMoveItemList;
      return dropResult;
    }
    return true;
  }

  private calculateMultiItemDropResult(x: number, y: number): boolean {
    log.showInfo('squeezed backwards not enough space, start forwards');
    let dropPos: number[] = [];
    this.initDropPos(dropPos, x , y);
    const index: number = this.getIndexByRowAndColumn(dropPos[0], dropPos[1]);
    const dropItem: GridLayoutItemInfo | undefined = this.getItemByIndex(index);
    const hasItem: boolean = (dropItem && !this.multiDragItemPosMap.has(this.getItemEventKey(dropItem))) ?? false;
    if (hasItem) {
      log.showWarn(`calculateMultiItemDropResult failed: drop at pos: ${dropPos[0]}, ${dropPos[1]} has item`);
      return false;
    }
    log.showInfo(`calculateMultiItemDropResult: drop at pos: ${dropPos[0]}, ${dropPos[1]}`);
    let items: GridLayoutItemInfo[] | undefined = this.getDragItems();
    if (!items || CheckEmptyUtils.isEmptyArr(items) || !this.mGridConfig) {
      log.showWarn('calculateMultiItemDropResult items empty');
      return false;
    }
    let tempMoveItemList: MoveItem[] = [];
    let restItemList: GridLayoutItemInfo[] = [];
    let maxColumn: number = this.mGridConfig.column;
    let maxRow: number = this.mGridConfig.row;
    let extraRow: number = 0;
    let extraColumn: number = 0;
    // super fold展开态，计算相对位置时考虑落位的page
    if (this.isExpandStatus) {
      if (this.isPortrait) {
        extraRow = this.getDragPageIndex() * this.mGridConfig.row;
        maxRow = maxRow * 2;
      } else {
        extraColumn = this.getDragPageIndex() * this.mGridConfig.column;
        maxColumn = maxColumn * 2;
      }
    }
    // 存放已找到空位的index和元素
    let occupiedPosMap: Map<number, MoveItem> = new Map();
    for (let idx = 0; idx < items.length; idx++) {
      let key: string = this.getItemEventKey(items[idx]);
      let recordOriginPos: number[][] | undefined = this.multiDragItemPosMap.get(key);
      if (!recordOriginPos) {
        continue;
      }
      let itemNewPosRow: number = dropPos[0] + extraRow + recordOriginPos[1][0];
      let itemNewPosColumn: number = dropPos[1] + extraColumn + recordOriginPos[1][1];
      let itemNewPosPage: number = this.getDragPageIndex();
      const isOutOfBounds: boolean = itemNewPosRow < 0 || itemNewPosRow >= maxRow ||
        itemNewPosColumn < 0 || itemNewPosColumn >= maxColumn;
      if (isOutOfBounds) {
        // 无法放置,N序往后找位置放
        restItemList.push(items[idx]);
        log.showInfo(`calculateMultiItemDropResult exceed, newRow: ${itemNewPosRow}, newColumn: ${itemNewPosColumn}`);
        continue;
      }
      // super fold展开态，需要更新行列数
      if (this.isExpandStatus) {
        const itemNewPos: DragGridPosition | undefined = this.updateItemPosition(itemNewPosRow, itemNewPosColumn, itemNewPosPage);
        if (itemNewPos) {
          itemNewPosColumn = itemNewPos.column;
          itemNewPosRow = itemNewPos.row;
          itemNewPosPage = itemNewPos.page ?? 0;
        }
      }
      let newIndex: number = this.isSuperFold ? this.getItemIndexForSuperFold(itemNewPosColumn, itemNewPosRow, itemNewPosPage) :
        itemNewPosColumn * this.mGridConfig.row + itemNewPosRow;
      // 判断新位置是否有空
      const findItem: GridLayoutItemInfo | undefined = this.getItemByIndex(newIndex);
      log.showInfo(`calculateMultiItemDropResult, findItem: ${findItem?.bundleName}`);
      // 该位置为空或是被拖元素原位
      const isEmptyOrDragItem: boolean = !findItem ||
        (findItem && this.multiDragItemPosMap.has(this.getItemEventKey(findItem)));
      const occupiedByBro: boolean = occupiedPosMap.has(newIndex);
      log.showInfo(`calculateMultiItemDropResult, origin occupied: ${isEmptyOrDragItem}, new occupied: ${occupiedByBro}`);
      // 需要判断当前是否有重复元素,以及相同位置是否已占位其他元素
      if (isEmptyOrDragItem && !occupiedByBro) {
        // 合法落位
        let moveItem: MoveItem = this.transformItemToMoveItem(items[idx], itemNewPosRow, itemNewPosColumn, itemNewPosPage, true);
        tempMoveItemList.push(moveItem);
        occupiedPosMap.set(newIndex, moveItem);
        log.showInfo(`drop moveItem: row: ${moveItem.row}, column: ${moveItem.column}, index: ${newIndex}`);
      } else {
        // 无法放置,N序往后找位置放
        restItemList.push(items[idx]);
        log.showInfo(`calculateMultiItemDropResult, can not drop at: ${itemNewPosRow}, ${itemNewPosColumn}`);
      }
    }
    occupiedPosMap.clear();
    log.showInfo(`calculateMultiItemDropResult length: ${tempMoveItemList.length}, dragPaste: ${this.isDragPaste}`);
    if (this.isDragPaste) {
      // 拖拽复制场景，过滤出不需要移动的文件元素
      tempMoveItemList = tempMoveItemList.filter((moveItem: MoveItem) => {
        return moveItem.typeId !== CommonConstants.TYPE_FILE_FOLDER;
      })
      log.showInfo(`calculateMultiItemDropResult, no fileFolder length: ${tempMoveItemList.length}`);
    }
    const result: boolean = this.dropRestItem(restItemList, dropPos, tempMoveItemList);
    if (!result) {
      tempMoveItemList = [];
      log.showInfo(`can not drop`);
      return false;
    }
    this.currentMoveItemList.push(...tempMoveItemList);
    return true;
  }

  private initDropPos(dropPos: number[], x: number, y: number): void {
    if (this.mEndPosition) {
      dropPos[0] = this.mEndPosition.row;
      dropPos[1] = this.mEndPosition.column;
    } else {
      let dragPosition: DragGridPosition = GridLayoutUtil.getRowAndColumn(x, y, this.getCurrentPageIndex());
      dropPos[0] = dragPosition?.row;
      dropPos[1] = dragPosition?.column;
    }
  }

  private updateItemPosition(itemNewPosRow: number, itemNewPosColumn: number, itemNewPosPage: number): DragGridPosition | undefined {
    if (!this.mGridConfig) {
      return undefined;
    }
    if (this.isPortrait) {
      itemNewPosPage = itemNewPosRow >= this.mGridConfig.row ? 1 : 0;
      itemNewPosRow = itemNewPosPage === 1 ? itemNewPosRow - this.mGridConfig.row : itemNewPosRow;
    } else {
      itemNewPosPage = itemNewPosColumn >= this.mGridConfig.column ? 1 : 0;
      itemNewPosColumn = itemNewPosPage === 1 ? itemNewPosColumn - this.mGridConfig.column : itemNewPosColumn;
    }
    return { row: itemNewPosRow, column: itemNewPosColumn, page: itemNewPosPage };
  }

  private getIndexByRowAndColumn(row: number, column: number): number {
    return this.isSuperFold ? this.getItemIndexForSuperFold(column, row) :
      column * (this.mGridConfig?.row ?? 0) + row;
  }

  private dropRestItem(items: GridLayoutItemInfo[], dropPos: number[], tempMoveItemList: MoveItem[]): boolean {
    if (items.length === 0) {
      return true;
    }
    if (!this.mGridConfig) {
      return false;
    }
    const startIndex: number = this.isSuperFold ? this.getItemIndexForSuperFold(dropPos[1], dropPos[0]) :
      dropPos[1] * this.mGridConfig.row + dropPos[0];
    const endIndex: number = (this.isSuperFold && this.isExpandStatus) ? this.mGridConfig.row * this.mGridConfig.column * 2 - 1 :
      this.mGridConfig.row * this.mGridConfig.column - 1;
    log.showInfo(`dropRestItem startIndex: ${startIndex}, endIndex: ${endIndex}, length: ${items.length}`);

    // 拖拽元素要按拖拽前的顺序落位
    items.sort((a: GridLayoutItemInfo, b:GridLayoutItemInfo) => {
      const indexA: number = this.getIndexByRowAndColumn(a.row ?? 0, a.column ?? 0);
      const indexB: number = this.getIndexByRowAndColumn(b.row ?? 0, b.column ?? 0);
      return indexA - indexB;
    });

    // 向后放
    for (let i = startIndex; i <= endIndex; i++) {
      this.dropItem(items, i, tempMoveItemList);
      if (items.length === 0) {
        return true;
      }
    }

    // 向前放
    for (let i = startIndex - 1; i >= 0; i--) {
      this.dropItem(items, i, tempMoveItemList);
      if (items.length === 0) {
        return true;
      }
    }
    return true;
  }

  private dropItem(items: GridLayoutItemInfo[], i: number, tempMoveItemList: MoveItem[]): void {
    const findItem: GridLayoutItemInfo | undefined = this.getItemByIndex(i);
    if (!findItem ||
      (findItem && this.multiDragItemPosMap.has(this.getItemEventKey(findItem)))) {
      const findItem: MoveItem | undefined = tempMoveItemList.find((item: MoveItem) => {
        const index: number = this.isSuperFold ? this.getItemIndexForSuperFold(item.column, item.row) :
          item.column * (this.mGridConfig?.row ?? 0) + item.row;
        return index === i;
      });
      if (findItem) {
        log.showDebug(`dropItem failed, ${i} has item: ${findItem.row}, ${findItem.column}`);
        return;
      }
      const item: GridLayoutItemInfo | undefined = items.shift();
      const newPos: DragGridPosition = this.getItemByIndexForSuperFold(i);
      if (item && newPos) {
        let moveItem: MoveItem = this.transformItemToMoveItem(item, newPos.row, newPos.column, newPos.page ?? 0, true);
        tempMoveItemList.push(moveItem);
        log.showInfo('drop moveItem, keyName: %{public}s, row: %{public}d, column: %{public}d, page: %{public}d',
          moveItem.keyName, moveItem.row, moveItem.column, moveItem.page);
      }
    }
  }

  private transformItemToMoveItem(item: GridLayoutItemInfo, newRow: number, newColumn: number, newPage: number,
    isDrag: boolean = false): MoveItem {
    const oldPosition: number[] = this.getPositionByRowAndColumn(item.row ?? 0, item.column ?? 0);
    const newPosition: number[] = this.getPositionByRowAndColumn(newRow, newColumn);
    let translatePosition: number[][] = [oldPosition, newPosition];
    let moveItem: MoveItem = MoveItem.fromGridItem(item);
    moveItem.ino = item.ino;
    moveItem.row = newRow;
    moveItem.column = newColumn;
    moveItem.page = newPage;
    moveItem.position = translatePosition;
    moveItem.isDrag = isDrag;
    moveItem.isRepeatItem = this.isRepeatMoveItem(moveItem);
    return moveItem;
  }

  private calculateSqueezedItemPosition(isSqueezeBackwards: boolean, isShowSqueezeAnimation: boolean, index: number,
    item: GridLayoutItemInfo): boolean {
    let moveItem = MoveItem.fromGridItem(item);
    moveItem.squeezeExtraParam = {delayTime: 0, opacity: 1};
    let translatePosition: number[][] = [];
    const oldPosition = this.isSuperFold ? this.getPositionByRowAndColumn(item.row ?? 0, item.column ?? 0, item.page) :
    this.getPositionByRowAndColumn(item.row ?? 0, item.column ?? 0);
    translatePosition[0] = oldPosition;
    const newColAndRow: DragGridPosition = this.getItemByIndexForSuperFold(index);
    log.showDebug(`desktop drag index ${index}, item ${item.appName}, old row ${item.row}, old column ${item.column}
      , new row ${newColAndRow.row}, new column ${newColAndRow.column}`);
    moveItem.isShowSqueezeAnimation = isShowSqueezeAnimation;
    let newPosition: number[] = this.getPositionByRowAndColumn(newColAndRow.row, newColAndRow.column, newColAndRow.page);
    translatePosition[1] = newPosition;
    if (!this.isShowSqueezeAnimation(item, newColAndRow, isSqueezeBackwards)) {
      // PC挤位新效果：仅在当前列触发挤位动效，边界图标向上/下额外多挤一位，不再触发下一列的挤位动效。
      newPosition = this.getExtraRowPosition(oldPosition, isSqueezeBackwards, item);
      moveItem.squeezeExtraParam.opacity = DragConstants.SQUEEZED_EXTRA_OPACITY_FOR_PC;
      isShowSqueezeAnimation = false;
    }
    translatePosition[1] = newPosition;
    moveItem.ino = item.ino;
    moveItem.row = newColAndRow.row;
    moveItem.column = newColAndRow.column;
    moveItem.position = translatePosition;
    if (this.isSuperFold) {
      moveItem.page = newColAndRow.page ?? 0;
    }
    moveItem.isRepeatItem = this.isRepeatMoveItem(moveItem);
    this.currentMoveItemList.push(moveItem);
    return isShowSqueezeAnimation;
  }

  private calculateSqueezedMoveItemList(isSqueezeBackwards: boolean, isItemBackToFront: boolean, x: number, y: number): boolean {
    if (!this.mGridConfig) {
      return false;
    }
    let squeezeIndexList = this.initialSqueezeSequence(isSqueezeBackwards, isItemBackToFront);
    let startSqueezeIndex: number = squeezeIndexList[0];
    let endSqueezeIndex: number = squeezeIndexList[1];
    let isShowSqueezeAnimation: boolean = true;
    // 从前往后挤，不能挤出最后一个，从后往前挤，不能挤出第一个
    const minIndex: number = 0;
    const maxIndex: number = (this.isSuperFold && this.isExpandStatus) ? this.mGridConfig.row * this.mGridConfig.column * 2 - 1 :
      this.mGridConfig.row * this.mGridConfig.column - 1;
    let i = 0;
    log.showInfo(`desktop drag calculate Squeezed list ${isSqueezeBackwards}, start ${startSqueezeIndex}, end ${endSqueezeIndex}`);
    let dragItemList: Set<string> = new Set();
    this.getDragItems()?.forEach(item => {
      dragItemList.add(GridLayoutUtil.generateUniqueKey(item));
    });
    for (i = startSqueezeIndex; isSqueezeBackwards ? i <= endSqueezeIndex : i >= endSqueezeIndex; isSqueezeBackwards ? i++ : i--) {
      let thisItem = this.getItemByIndex(i);
      // determine whether this space is blank
      const key: string = GridLayoutUtil.generateUniqueKey(thisItem);
      if (!thisItem || dragItemList.has(key)) {
        endSqueezeIndex = isSqueezeBackwards ? i - 1 : i + 1;
        log.showInfo(`desktop drag thisItem is blank, index=${i}`);
        break;
      }
      // if appItem close to CARD or FOLDER, do not squeeze
      if (thisItem.typeId === CommonConstants.TYPE_CARD || thisItem.typeId === CommonConstants.TYPE_REGION_FOLDER) {
        log.showInfo('desktop drag calculateSqueezedMoveItemList, thisItem is card or regionFolder, index: ' + i);
        continue;
      }
      // 判断下一个位置元素是否为卡片
      const squeezeBackwardOrForward: number = isSqueezeBackwards ? 1 : -1;
      let tempItem = this.getItemByIndex(i + squeezeBackwardOrForward);
      while (tempItem &&
        (tempItem.typeId === CommonConstants.TYPE_CARD || tempItem.typeId === CommonConstants.TYPE_REGION_FOLDER)) {
        i = i + squeezeBackwardOrForward;
        tempItem = this.getItemByIndex(i + squeezeBackwardOrForward);
      }
      // 挤位后位置超过范围，认为挤位失败
      if ((isSqueezeBackwards && i + 1 > maxIndex) || (!isSqueezeBackwards && i - 1 < minIndex)) {
        log.showWarn(`desktop drag calculateSqueezedMoveItemList, out of desktop ${GridLayoutUtil.generateUniqueKey(tempItem)}`);
        return false;
      }
      if (thisItem.typeId === CommonConstants.TYPE_APP || thisItem.typeId === CommonConstants.TYPE_FILE_FOLDER ||
        thisItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        isShowSqueezeAnimation = isSqueezeBackwards ? this.calculateSqueezedItemPosition(isSqueezeBackwards, isShowSqueezeAnimation, i + 1, thisItem) :
        this.calculateSqueezedItemPosition(isSqueezeBackwards, isShowSqueezeAnimation, i - 1, thisItem);
      }
    }
    return true;
  }

  private isShowSqueezeAnimation(moveItem: GridLayoutItemInfo, newColAndRow: DragGridPosition, isSqueezeBackwards: boolean): boolean {
    if (!this.isSuperFold || (this.isSuperFold && !this.isExpandStatus)) {
      if (moveItem.column !== newColAndRow.column) {
        return false;
      }
      return true;
    }
    if (this.isExpandStatus && this.isPortrait) {
      if (moveItem.page !== newColAndRow.page && ((isSqueezeBackwards && moveItem.page === 1) ||
        (!isSqueezeBackwards && moveItem.page === 0))) {
        // fold pc挤位
        return false;
      }
      return true;
    } else {
      if (moveItem.page !== newColAndRow.page || moveItem.column !== newColAndRow.column) {
        return false;
      }
      return true;
    }
  }

  private initialSqueezeSequence(isSqueezeBackwards: boolean, isItemBackToFront: boolean): number[] {
    let startSqueezeIndex: number = 0;
    let endSqueezeIndex: number = 0;
    // calculate initial squeezing sequence, 拖拽图标dragStartItemIndex and 待落位dragEndItemIndex
    if (isSqueezeBackwards) {
      if (isItemBackToFront && !this.isDragPaste) {
        // index 11（dragStartItemIndex） 移至 2（dragEndItemIndex）  后向挤，原2-10
        startSqueezeIndex = this.dragEndItemIndex;
        endSqueezeIndex = this.dragStartItemIndex - 1;
      } else {
        // index 2（dragStartItemIndex） 移至 11（dragEndItemIndex）  后向挤位，原11-end
        startSqueezeIndex = this.dragEndItemIndex;
        if (this.mGridConfig) {
          endSqueezeIndex = this.isSuperFold ? this.mGridConfig.row * this.mGridConfig.column * 2 - 1 :
            this.mGridConfig.row * this.mGridConfig.column - 1;
        }
      }
    } else {
      if (isItemBackToFront || this.isDragPaste) {
        // 11（dragStartItemIndex） 移至 2（dragEndItemIndex） 前向挤，原0-2
        startSqueezeIndex = this.dragEndItemIndex;
        endSqueezeIndex = 0;
      } else {
        // index 2（dragStartItemIndex） 移至 11（dragEndItemIndex）  前向挤位，原3-11挤
        startSqueezeIndex = this.dragEndItemIndex;
        endSqueezeIndex = this.dragStartItemIndex;
      }
    }
    log.showDebug(`startSqueezeIndex:${startSqueezeIndex}, endSqueezeIndex:${endSqueezeIndex}`);
    return [startSqueezeIndex, endSqueezeIndex];
  }

  computeAppItemSqueezed(isSqueezeBackwards: boolean, x: number, y: number, dragItemType: number): void {
    log.showDebug('in computeSqueezed');
    this.currentMoveItemList = [];
    let startSqueezeIndex: number = 0;
    let endSqueezeIndex: number = 0;

    // calculate initial squeezing sequence, dragStartItemIndex and dragEndItemIndex
    if (isSqueezeBackwards) {
      startSqueezeIndex = this.dragEndItemIndex;
      if (this.mGridConfig) {
        endSqueezeIndex = this.mGridConfig.row * this.mGridConfig.column - 1;
      }
    } else {
      startSqueezeIndex = this.dragEndItemIndex;
      endSqueezeIndex = 0;
    }
    log.showWarn(`startSqueezeIndex:${startSqueezeIndex}, endSqueezeIndex:${endSqueezeIndex}`);
    this.computeAppItemSqueezedFinal(x, y, startSqueezeIndex, endSqueezeIndex, isSqueezeBackwards);
  }

  private computeAppItemSqueezedFinal(x: number, y: number, startSqueezeIndex: number, endSqueezeIndex: number,
    isSqueezeBackwards: boolean): void {
    // calculate final squeezing sequence and squeezing position
    let isNeedSqueezed = true;
    for (let i = startSqueezeIndex; isSqueezeBackwards ? i <= endSqueezeIndex : i >= endSqueezeIndex;
      isSqueezeBackwards ? i++ : i--) {
      let thisItem = this.getItemSqueezed(i);
      // determine whether this space is blank
      if (!thisItem) {
        endSqueezeIndex = isSqueezeBackwards ? i - 1 : i + 1;
        log.showDebug(`thisItem is blank, index=${i}`);
        break;
      }

      // 小元素挤位逻辑中跳过大元素
      if (thisItem.area && (thisItem.area[0] !== 1 || thisItem.area[1] !== 1)) {
        continue;
      }
      // 云端2小元素挤位需跳过不可拖拽的预制元素
      if (LightOutdoorConfig.getInstance().isOnLightOutdoorMode() &&
        !desktopItemDraggableManager.isItemDraggable(thisItem as Object as GridLayoutItemInfo)) {
        continue;
      }

      let itemRow = thisItem.row ?? 0;
      let itemColumn = thisItem.column ?? 0;
      let oldPosition: number[];
      let newPosition: number[];
      oldPosition = this.getPositionByRowAndColumn(itemRow, itemColumn);
      log.showDebug(`computeAppItemSqueezed, appName: %{public}s, oldRow: %{public}d, oldColumn: %{public}d, row: %{public}d,
        column: %{public}d`, thisItem.appName, itemRow, itemColumn, oldPosition[1], oldPosition[0]);
      if (!this.mGridConfig || !this.mEndPosition) {
        isNeedSqueezed = false;
        break;
      }
      const tempPosition: DragItemPosition = {
        page: this.mEndPosition.page, row: itemRow, column: itemColumn, x: x, y: y };
      let tempItemInfo = this.getItemByPosition(tempPosition);
      if (!tempItemInfo) {
        log.showDebug('tempItemInfo is invalid');
        return;
      }
      let count: number = 0;
      if (isSqueezeBackwards) {
        while (count === 0 || (tempItemInfo && ((LightOutdoorConfig.getInstance().isOnLightOutdoorMode() &&
          !desktopItemDraggableManager.isItemDraggable(tempItemInfo as Object as GridLayoutItemInfo)) || !this.isGridItem1x1(tempItemInfo)))) {
          if (itemColumn < this.mGridConfig.column - 1) {
            itemColumn = itemColumn + 1;
          } else {
            itemColumn = 0;
            itemRow = itemRow + 1;
          }
          tempPosition.row = itemRow;
          tempPosition.column = itemColumn;
          tempItemInfo = this.getItemByPosition(tempPosition);
          count += 1;
          log.showDebug(`count:${count}, row:${itemRow}, column:${itemColumn}`);
        }
        if (itemRow > this.mGridConfig.row - 1) {
          isNeedSqueezed = false;
          break;
        }
      } else {
        while (count === 0 || (tempItemInfo && ((LightOutdoorConfig.getInstance().isOnLightOutdoorMode() &&
          !desktopItemDraggableManager.isItemDraggable(tempItemInfo as Object as GridLayoutItemInfo)) || !this.isGridItem1x1(tempItemInfo)))) {
          if (itemColumn > 0) {
            itemColumn = itemColumn - 1;
          } else {
            itemColumn = this.mGridConfig.column - 1;
            itemRow = itemRow - 1;
          }
          tempPosition.row = itemRow;
          tempPosition.column = itemColumn;
          tempItemInfo = this.getItemByPosition(tempPosition);
          count += 1;
        }
        if (itemRow < 0) {
          isNeedSqueezed = false;
          break;
        }
      }
      newPosition = this.getPositionByRowAndColumn(itemRow, itemColumn);
      log.showDebug(`computeAppItemSqueezed, keyName: %{public}s, newRow: %{public}d, newColumn: %{public}d, newPosition: row: %{public}d,
        column: %{public}d`, thisItem.keyName, itemRow, itemColumn, newPosition[1], newPosition[0]);

      // get item's keyName and position
      let translatePosition: number[][] = [];
      translatePosition[0] = oldPosition;
      translatePosition[1] = newPosition;
      let moveItem = MoveItem.fromGridItem(thisItem);
      moveItem.row = itemRow;
      moveItem.column = itemColumn;
      moveItem.position = translatePosition;
      moveItem.isRepeatItem = this.isRepeatMoveItem(moveItem);
      this.currentMoveItemList.push(moveItem);
    }
    // determine whether to squeeze
    if (!isNeedSqueezed) {
      log.showDebug(`isNeedSqueezed:${isNeedSqueezed}`);
      this.currentMoveItemList = [];
      return;
    }
    // notify last items (not contain current items) reset its position
    this.lastMoveItemList?.forEach(lastMoveItem => {
      this.resetMoveItem(lastMoveItem);
    });

    // send move and shake event
    this.dealSqueeze(isSqueezeBackwards);

    this.isStartToSqueeze = true;
    this.isSqueezeSuccess = true;
    this.lastMoveItemList = [];
    this.lastMoveItemList = JSON.parse(JSON.stringify(this.currentMoveItemList));
  }

  private dealSqueeze(isSqueezeBackwards: boolean): void {
    this.currentMoveItemList.forEach(item => {
      log.showDebug(`need to emit, item:${item.appName}, isRepeat:${item.isRepeatItem}`);
      if (!item.isRepeatItem) {
        let direction: number = isSqueezeBackwards ?
          (item.position[1][0] - item.position[0][0] > 0 || item.position[1][1] - item.position[0][1] > 0 ? 1 : -1) :
          (item.position[1][0] - item.position[0][0] < 0 || item.position[1][1] - item.position[0][1] < 0 ? -1 : 1);
        item.shake = direction;
        if (this.isGridItem1x1(item)) {
          DragEventManager.getInstance(launcherStatusUtil.getShowOutLauncherStatus()).
            startSqueezedInDesktop(this.getItemEventKey(item), item.position);
        }
      }
    });
  }

  private getItemSqueezed(index: number): GridLayoutItemInfo | undefined {
    let item: GridLayoutItemInfo | undefined = this.getItemByIndex(index);
    let dragItems: GridLayoutItemInfo[] | undefined = this.getDragItems();
    if (!dragItems) {
      return item;
    }
    if (dragItems.some((value: GridLayoutItemInfo) => GridLayoutUtil.checkGridItemEqual(value, item))) {
      return undefined;
    }
    return item;
  }

  private isGridItem1x1(itemInfo: MoveItem | GridLayoutItemInfo): boolean {
    return GridLayoutUtil.isIconType(itemInfo.typeId) || GridLayoutUtil.isSmallFolder(itemInfo as GridLayoutItemInfo);
  }

  private computeMultiItemSqueezed(solution: ItemConfiguration): void {
    this.currentMoveItemList = [];
    // get squeeze items
    let intersectingViewTranslate: Map<DragGridItem, number[][]> = solution.getIntersectingViewsTranslate();
    let tempLastMoveList: MoveItem[] = [];
    if (intersectingViewTranslate && intersectingViewTranslate.size > 0) {
      let nearPage: number = this.getNearPage();
      // notify the corresponding item squeeze based on its typeId
      intersectingViewTranslate.forEach((value, key) => {
        if (CheckEmptyUtils.isEmpty(value)) {
          return;
        }
        let item: GridLayoutItemInfo = key as GridLayoutItemInfo;
        if (CheckEmptyUtils.isEmpty(item)) {
          return;
        }
        let moveItem = MoveItem.fromGridItem(item);
        moveItem.row = value[1][1];
        moveItem.column = value[1][0];
        if (this.isNearReArrangeSolutionSuccess) {
          moveItem.page = nearPage;
          this.setContinueData(item, moveItem);
        }
        moveItem.isRepeatItem = this.isRepeatMoveItem(moveItem);
        let translatePosition: number[][] = [];
        translatePosition[0] = this.getPositionByRowAndColumn(value[0][1], value[0][0]);
        translatePosition[1] = this.getPositionByRowAndColumn(value[1][1], value[1][0]);
        let offset: number = this.getDragMoveItemTranslateOffset(nearPage);
        log.showInfo(`computeMultiItemSqueezed translatePosition0 ${translatePosition[0]} translatePosition1 ${translatePosition[1]} offset ${offset}`);
        translatePosition[1][0] += offset;
        moveItem.position = translatePosition;
        tempLastMoveList.push(moveItem);
      });
      this.currentMoveItemList = tempLastMoveList;

      // notify last items (not contain current items) reset its position
      this.lastMoveItemList?.forEach(lastMoveItem => {
        this.resetMoveItem(lastMoveItem);
      });
      this.currentMoveItemList?.forEach(item => {
        if (!item.isRepeatItem) {
          DragEventManager.getInstance(launcherStatusUtil.getShowOutLauncherStatus()).startSqueezedInDesktop(this.getItemEventKey(item), item.position);
        }
      });

      // After delete items that are repeatedly moved, then stop last moveItems.
      this.lastMoveItemList = [];
      this.lastMoveItemList = JSON.parse(JSON.stringify(this.currentMoveItemList));
      this.isStartToSqueeze = true;
      this.isSqueezeSuccess = true;
      if (this.mEndPosition) {
        this.lastMoveItemIndex = this.getItemIndex(this.mEndPosition.x, this.mEndPosition.y);
        this.lastMovePageIndex = this.mEndPosition.page;
      }
    }
  }

  // 卡片跨屏挤位的场景在落位时卡片会在隔壁屏重建，此时需要在卡片位置设置截图避免闪烁
  private setContinueData(item: GridLayoutItemInfo, moveItem: MoveItem): void {
    if (item.typeId !== CommonConstants.TYPE_CARD || item.cardDimension == null) {
      return;
    }
    let formStyleConfig = FormViewModel.getInstance(this.singleContext).getFormStyleConfig();
    let width: number | undefined = formStyleConfig.mFormWidth.get(String(item.cardDimension));
    let height: number | undefined = formStyleConfig.mFormHeight.get(String(item.cardDimension));
    if (width == null || height == null) {
      return;
    }
    let key = GridLayoutUtil.generateUniqueKey(item);
    let position = GridLayoutUtil.getIconCenterPosition(moveItem.row, moveItem.column, item.area, moveItem.page);
    let translateX = position[0];
    let translateY = position[1];
    let continueData = animationContinueManager.getData(key);
    if (continueData != null) {
      continueData.translateX = translateX;
      continueData.translateY = translateY;
      return;
    }
    let viewData: AnimationViewData = new AnimationViewData(key);
    viewData.width = EditModeUtils.convertWithDesktopScale(width);
    viewData.height = EditModeUtils.convertWithDesktopScale(height);
    viewData.translateX = translateX;
    viewData.translateY = translateY;
    animationContinueManager.addData(viewData);
    this.snapshotForSqueezeCard(FormCommonUtil.getFormComponentId(item as Object as CardItemInfo), key);
  }

  private snapshotForSqueezeCard(id: string, key: string): void {
    log.showInfo(`snapshot for squeeze card id:${id}`);
    componentSnapshot.get(id, (err: Error, data: image.PixelMap) => {
      if (err) {
        log.error(`fail to get squeeze card snapshot for id:${id}`, err);
        return;
      }
      log.showInfo(`succeed to get squeeze card snapshot for id:${id}, data:${data?.getPixelBytesNumber()}`);
      let viewData: AnimationViewData | undefined = animationContinueManager.getData(key);
      if (viewData) {
        viewData.pixmap = data;
      } else {
        log.showWarn(`cannot find animation continue data of key:${key}`);
        data.release();
      }
    });
  }

  /**
   * Delete item that is repeatedly moved. (repeat move item only need to squeeze once)
   *
   * @param lastMoveItem
   */
  private isRepeatMoveItem(currentItem: MoveItem): boolean {
    if (!this.lastMoveItemList || this.lastMoveItemList.length === 0) {
      log.showDebug('lastMoveItemList do not have item');
      return false;
    }
    log.showDebug(`in deleteRepeatMoveItem, lastMoveItemList currentItem:${currentItem.appName}`);
    const index = this.lastMoveItemList?.findIndex(lastMoveItem => {
      return this.judgeItem(lastMoveItem, currentItem) && lastMoveItem.row === currentItem.row && lastMoveItem.column === currentItem.column;
    });
    log.showDebug(`isRepeatMoveItem, currentItem:${currentItem.appName}, findIndex:${index}`);
    if (index !== -1) {
      this.lastMoveItemList?.splice(index, 1);
      return true;
    }
    return false;
  }

  private updateLastPosition(): void {
    if (this.mLastPosition && !CheckEmptyUtils.isEmpty(this.mLastPosition.x) && !CheckEmptyUtils.isEmpty(this.mLastPosition.y)) {
      this.lastMoveItemIndex = this.getItemIndex(this.mLastPosition.x, this.mLastPosition.y);
      log.showDebug('lastMoveItemIndex: %{public}d, mLastPosition: row: %{public}d, column: %{public}d, page: %{public}d, x: %{public}d, y: %{public}d',
        this.lastMoveItemIndex, this.mLastPosition.row, this.mLastPosition.column, this.mLastPosition.page, this.mLastPosition.x, this.mLastPosition.y);
    }
  }

  public dealSwiperPageOnDragMove(event?: DragEvent, extraParams?: string): void {
    if ((this.isPhone || DeviceHelper.isPC()) && event) {
      let x: number;
      let y: number;
      if (this.isDropFileToDesktop) {
        x = event.getWindowX();
        y = event.getWindowY();
      } else {
        let rectangle = event.getPreviewRect();
        x = Number(rectangle.x) + Number(rectangle.width) / 2;
        y = Number(rectangle.y) + Number(rectangle.height) / 2;
      }
      // 记录拖拽方向
      if (this.avgVX.length >= DRAG_SAMPLE_FREQ) {
        this.avgVX.shift();
      }
      this.avgVX.push(event.getVelocityX());
      if (this.avgVY.length >= DRAG_SAMPLE_FREQ) {
        this.avgVY.shift();
      }
      this.avgVY.push(event.getVelocityY());
      this.onDragMove(x, y);
      if (DragAccessibilityUtils.isAccessibilityMode()) {
        this.textAnnouncedForNearScreen(event);
      }
    }
  }

  /**
   * 图标边缘靠近屏幕边缘时，进行屏幕朗读
   * @param event
   */
  public textAnnouncedForNearScreen(event: DragEvent): void {
    let screenWidth = AppStorage.get<number>('screenWidth') as number;
    let rectangle = event.getPreviewRect();
    let iconRightEdge = Number(rectangle.x) + Number(rectangle.width);
    let iconLeftEdge = Number(rectangle.x);
    let workSpaceMargin = this.mPageDesktopStyleConfig.mMargin + this.getFoldPadding();

    // 图标边缘与屏幕边缘的距离小于阈值，则进行播报
    if (screenWidth - iconRightEdge < workSpaceMargin * SCREEN_GREP_FACTOR) {
      if (!this.isAnnouncedForNearScreen) {
        this.isAnnouncedForNearScreen = true;
        DragAccessibilityUtils.textAnnouncedForNearRight();
      }
    } else if (iconLeftEdge < workSpaceMargin * SCREEN_GREP_FACTOR) {
      if (!this.isAnnouncedForNearScreen) {
        this.isAnnouncedForNearScreen = true;
        DragAccessibilityUtils.textAnnouncedForNearLeft();
      }
    } else {
      this.isAnnouncedForNearScreen = false;
    }
  }

  private getFoldPadding(): number {
    let foldPadding = 0;
    let deviceState: DeviceState | undefined = AppStorage.get<DeviceState>('folderStatus');
    if (deviceState !== DeviceState.DEFAULT_STATE) {
      foldPadding = this.mPageDesktopViewModel?.getPageDesktopStyleConfig().mFoldPaddingSide as number;
    }
    return foldPadding;
  }

  public getExtra(extraParams?: string): string {
    let extraInfo: string = '';
    if (extraParams) {
      let tempExtraInfo: string = '';
      try {
        tempExtraInfo = JSON.parse(extraParams).extraInfo;
      } catch (error) {
        log.showError(`get extra error ${error?.code}, ${error?.message}`);
      }
      if (tempExtraInfo !== undefined) {
        extraInfo = tempExtraInfo;
      }
    }
    return extraInfo;
  }

  public dealSwiperPageOnDragEnter(indexInSwiper: number | undefined, event?: DragEvent, extraParams?: string): void {
    const dragItemType: number = AppStorage.get('dragItemType') as number;
    log.showInfo(`${CommonConstants.SWIPER_GRID_WORKSPACE_TAG}${indexInSwiper} onDragEnter (type: ${dragItemType}, event: [${event?.getX()}, ${event?.getY()}])`);
    if (event) {
      if (this.isPc) {
        // 拖拽进桌面关闭节点组缓存
        (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub.emit(CommonConstants.DESKTOP_ITEM_ENABLE_RENDER_GROUP, false);
        const needWhiteBox = this.isNeedWhiteBox(extraParams);
        const isDragFromRegionFolder = dragItemType === CommonConstants.DRAG_FROM_REGION_FOLDER;
        log.showInfo(`desktop drag file—folder enter desktop: ${needWhiteBox},\
          drag item from region folder :${isDragFromRegionFolder}`);
        if (needWhiteBox) {
          this.isDropFileToDesktop = true;
          this.mPageDesktopViewModel.fileFolderEnterDesktop(event);
        }
        if (needWhiteBox || isDragFromRegionFolder) {
          const dragItems: GridLayoutItemInfo[] | undefined = this.getDragItems();
          this.pcMultiDragCount = dragItems?.length ?? 1;
          // pc外部应用拖入，默认起始点
          this.mStartPosition = {
            page: this.dragPageIndex,
            row: 0,
            column: 0,
            x: 0,
            y: 0,
          };
        }
      }
      this.onDragEnter(event.getWindowX(), event.getWindowY());
    }
  }

  public setSuperFoldStatus(isPortrait: boolean, isExpandStatus: boolean): void {
    if (this.mGridConfig) {
      CardSqueezer.getInstance().setSuperFoldStatus(isPortrait, isExpandStatus, this.mGridConfig);
    }
    this.isExpandStatus = isExpandStatus;
    this.isPortrait = isPortrait;
    log.showInfo(`superFold isExpandStatus ${this.isExpandStatus} isPortrait ${this.isPortrait}`);
  }

  private isNeedWhiteBox(extraParams?: string): boolean {
    if (!extraParams) {
      return false;
    }
    const extraInfo = this.getExtra(extraParams);
    return FileFolderDragHandler.getInstance().isNeedWhiteBox(extraInfo);
  }

  public setDragItemPosition(inos: string[], x: number, y: number): void {
    const dragDelegate: CellLayoutDragDelegate | undefined = this.getDragDelegate();
    if (!dragDelegate) {
      return;
    }
    const cellAndSpan: CellAndSpan = new CellAndSpan(x, y, 1, 1);
    let result: number[] = dragDelegate.findNearestArea(cellAndSpan);
    this.updateDragEndPosition(result, x, y);
    const index: number = this.getDragPageIndex();
    const items: Array<MultipleDragPosition> = inos.map((ino: string) => {
      let tmp: MultipleDragPosition = {
        ino: ino,
        position: {
          page: index,
          row: result[1],
          column: result[0],
          x: x,
          y: y,
        }
      };
      return tmp;
    });
    MultipleDragSettings.getInstance().addDragItems(items);
  }

  public dealSwiperPageOnDrop(indexInSwiper: number | undefined, event?: DragEvent, extraParams?: string,
    dropAnimation?: Function): void {
    performanceMonitor.end(HiSysEventUtil.DRAG_ITEM_ANI);
    TraceUtil.endTrace(DomainName.HOME, HiSysEventUtil.DRAG_ITEM_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    if (!event) {
      return;
    }
    const rect: Rectangle | undefined = event.getPreviewRect();
    log.showInfo('onDrop in swiper index %{public}d. event position is [%{public}d, %{public}d], ' +
      'preview rect is [x=%{public}d, y=%{public}d, width=%{public}d, height=%{public}d]', indexInSwiper,
      event.getWindowX(), event.getWindowY(), rect?.x, rect?.y, rect?.width, rect?.height);
    if (event.useCustomDropAnimation !== undefined && event.useCustomDropAnimation !== null) {
      log.showInfo(`useCustomDropAnimation: ${event.useCustomDropAnimation}`);
      event.useCustomDropAnimation = true;
    }
    if (!AppStorage.get<boolean>('isDrag')) {
      this.mPageDesktopViewModel.dropFileToDesktop(event, extraParams);
      log.showInfo('not dragging desktop component');
      return;
    }

    const dragItemType = AppStorage.get<number>('dragItemType') as number;
    const isDragFromFolder = dragItemType === CommonConstants.DRAG_FROM_FOLDER ||
      dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK;
    if (isDragFromFolder) {
      this.dealDragFromFolder(event, extraParams, dropAnimation);
      return;
    }
    if (extraParams) {
      this.dealSwiperPageOnDragDrop(event, extraParams, dropAnimation);
    }
  }

  private dealDragFromFolder(event?: DragEvent, extraParams?: string, dropAnimation?: Function): void {
    const onAnimateFinish = (): void => {
      log.showDebug('onDrop dragFromFolder dragOutFolderPending');
      if (event && extraParams) {
        this.dealSwiperPageOnDragDrop(event, extraParams, dropAnimation);
      }
      if (this.isPhone) {
        return;
      }
    };
    ContractedFolderCommonViewModel.getInstance().waitFolderAnimateFinish(onAnimateFinish);
  }

  private dragPasteFile(event: DragEvent, extraParams: string, isCtrlKeyDown: boolean, isAltKeyDown:boolean, isShiftKeyDown: boolean): void {
    log.showInfo(`dragPasteFile isDragPaste ${this.isDragPaste}, isCtrlKeyDown ${isCtrlKeyDown}`);
    const x: number = event.getWindowX();
    const y: number = event.getWindowY();
    const cellAndSpan: CellAndSpan = new CellAndSpan(x, y, 1, 1);
    let result: number[] | undefined = this.getDragDelegate()?.findNearestArea(cellAndSpan);
    if (!result) {
      return;
    }
    this.mEndPosition = {
      page: this.getCurrentPageIndex(),
      row: result[1],
      column: result[0],
      originColumn: result[2] ?? result[0],
      x: x,
      y: y
    };
    const extraData = `{"isFileCover": false, "isCtrlKeyDown": ${isCtrlKeyDown}, "isAltKeyDown": ${isAltKeyDown},
    "isShiftKeyDown": ${isShiftKeyDown}, "column": ${result[0]}, "row": ${result[1]}, "page": ${this.dragPageIndex}}`;
    this.mPageDesktopViewModel.dropFileToDesktop(event, extraParams, extraData);
  }

  private async dealSwiperPageOnDragDrop(event: DragEvent, extraParams: string, dropAnimation?: Function): Promise<void> {
    const dragItemType: number = AppStorage.get('dragItemType') as number;
    AppStorage.setOrCreate('dragItemTypeInfo', -1);
    log.showWarn(`onDrop event: [${event.getWindowX()}, ${event.getWindowY()}], dragItemType:${dragItemType}`);
    if (dragItemType === CommonConstants.DRAG_FROM_MANAGE && this.isPhone) {
      AppStorage.setOrCreate('undoDragFormVisible', false);
      if (!editModeManager.isInEditMode()) {
        ViewManagerPolicy.showView(ViewType.STATUS_BAR);
      }
    }
    const deviceAllowDragTypes = [
      CommonConstants.DRAG_FROM_DOCK,
      CommonConstants.DRAG_FROM_MANAGE,
      CommonConstants.DRAG_FROM_SWIPE_UP,
      CommonConstants.DRAG_FROM_FORM_SERVICE,
      CommonConstants.DRAG_FROM_FORM_INTELLIGENT,
      CommonConstants.DRAG_FROM_FORM_STACK,
    ];

    if (dragItemType === CommonConstants.DRAG_FROM_DESKTOP ||
      dragItemType === CommonConstants.DRAG_FROM_APP_ICON ||
      dragItemType === CommonConstants.DRAG_FROM_FOLDER ||
      dragItemType === CommonConstants.DRAG_FROM_REGION_FOLDER ||
      dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK ||
      dragItemType === CommonConstants.DRAG_FROM_FORM_SERVICE ||
      dragItemType === CommonConstants.DRAG_FROM_SHORTCUT ||
      dragItemType === CommonConstants.DRAG_FROM_MANAGE ||
      (deviceAllowDragTypes.includes(dragItemType) && this.isPhone)) {
      let dropX: number;
      let dropY: number;
      if (this.isDropFileToDesktop) {
        dropX = event.getWindowX();
        dropY = event.getWindowY();
      } else {
        let rectangle = event.getPreviewRect();
        dropX = Number(rectangle.x) + Number(rectangle.width) / 2;
        dropY = Number(rectangle.y) + Number(rectangle.height) / 2;
      }
      if (this.mPageDesktopViewModel.getIsChangingPage()) {
        log.showInfo(`dealSwiperPageOnDragDrop, IsChangingPage:${this.mPageDesktopViewModel.getIsChangingPage()}`);
        this.mPageDesktopViewModel.getSwiperController()?.finishAnimation(() => {
          log.showInfo(`dealSwiperPageOnDragDrop, swiperController finishAnimation`);
          this.dealDrop(dropX, dropY, event, extraParams, dropAnimation);
        });
      } else {
        this.dealDrop(dropX, dropY, event, extraParams, dropAnimation);
      }
    }
  }

  private dealDrop(dropX: number, dropY: number, event?: DragEvent, extraParams?: string, dropAnimation?: Function): void {
    let dragResult: DesktopDragResult = this.onDragDrop(dropX, dropY, event, extraParams);
    log.showInfo(`onDrop dragResult: ${JSON.stringify(dragResult)}`);
    if (dragResult.needDropAnimation) {
      // ArkUI会在结束拖拽前执行该落位动效，同步隐藏跟手图，尽可能保证两者衔接
      event?.executeDropAnimation(() => {
        dropAnimation?.(dropX, dropY, dragResult);
        this.onStartDrop();
      });
      return;
    }
    AppStorage.setOrCreate('selectAppIndex', null);
    if (dragResult.dropToFolder && this.mEndPosition) {
      let endLayoutInfo: GridLayoutItemInfo | undefined = this.getItemByPosition(this.mEndPosition);
      dropAnimation?.(dropX, dropY, dragResult, endLayoutInfo);
    }
    this.onStartDrop();
  }

  /**
   * 开始落位流程，后期收编dragEnd方法后此方法删除
   */
  public onStartDrop(): void {
    AppStorage.setOrCreate('isDrag', false);
    const dragItems = this.getDragItems() ?? [];
    if (!(dragItems.length > 1 && !this.isPc)) {
      DragEventManager.getInstance(launcherStatusUtil.getShowOutLauncherStatus()).startDrop(this.getItemEventKey(dragItems[0]));
      AppStorage.setOrCreate<Object>('dragItemInfo', {});
      this.mFolderMgr.setDragItemFolder(undefined);
    } else {
      log.showInfo('onStartDrop error');
    }
  }

  private isFormStackInnerCardDropInvalid(dragItemType: number, dragTypeId: number): boolean {
    if (dragItemType === CommonConstants.DRAG_FROM_FORM_STACK && dragTypeId === CommonConstants.TYPE_CARD) {
      let formStackId: string | undefined = AppStorage.get<string>('formStackId');
      if (CheckEmptyUtils.checkStrIsEmpty(formStackId)) {
        log.showError('drag card from formstack to drop, but formStackId is empty!');
        return true;
      }

      // 卡片落位时堆叠还未收起，不处理
      if (!AppStorage.get<boolean>('dragCardOfFormstackClosed')) {
        log.showWarn('drag card from formstack to drop, but formstack not be closed!');
        return true;
      }
    }

    return false;
  }

  public getSingleDragItemInfo(): GridLayoutItemInfo | undefined {
    return GridLayoutUtil.getSingleDragItemInfo();
  }

  public getItemByPos(row: number, column: number): GridLayoutItemInfo | undefined {
    if (!this.mGridConfig) {
      return undefined;
    }
    const index: number = this.isSuperFold ? this.getItemIndexForSuperFold(column, row) :
      this.mGridConfig.row * column + row;
    log.showInfo(`getItemByPos: row:${row}, column:${column}, index:${index}`);
    return this.getItemByIndex(index);
  }

  private getItemIndexForSuperFold(column: number, row: number, pageId?: number): number {
    let index: number = CommonConstants.INVALID_VALUE;
    if (!this.mGridConfig) {
      return index;
    }
    if (!this.isExpandStatus) {
      return this.mGridConfig.row * column + row;
    }
    const page = pageId ?? this.dragPageIndex;
    if (this.isPortrait) {
      index = (page === 0) ? column * this.mGridConfig.row * 2 + row :
        column * this.mGridConfig.row * 2 + row + this.mGridConfig.row;
    } else {
      index = (page === 0) ? column * this.mGridConfig.row + row :
        column * this.mGridConfig.row + row + this.mGridConfig.column * this.mGridConfig.row;
    }
    return index;
  }

  private getItemByIndexForSuperFold(index: number): DragGridPosition {
    let column: number = 0;
    let row: number = 0;
    let pageIndex: number = this.dragPageIndex;
    if (!this.mGridConfig) {
      return {column: column, row: row, page: pageIndex};
    }
    if (!this.isSuperFold || (this.isSuperFold && !this.isExpandStatus)) {
      column = Math.floor(index / this.mGridConfig.row);
      row = index % this.mGridConfig.row;
      return {column: column, row: row, page: pageIndex};
    }
    if (this.isPortrait) {
      column = Math.floor(index / (this.mGridConfig.row * 2));
      if (index - column * this.mGridConfig.row * 2 > this.mGridConfig.row - 1) {
        pageIndex = 1;
        row = index - column * this.mGridConfig.row * 2 - this.mGridConfig.row;
      } else {
        pageIndex = 0;
        row = index - column * this.mGridConfig.row * 2;
      }
    } else {
      const allGridCount = this.mGridConfig.row * this.mGridConfig.column;
      if (index > allGridCount - 1) {
        pageIndex = 1;
        column = Math.floor((index - allGridCount) / this.mGridConfig.row);
        row = (index - allGridCount) % this.mGridConfig.row;
      } else {
        pageIndex = 0;
        column = Math.floor(index / this.mGridConfig.row);
        row = index % this.mGridConfig.row;
      }
    }
    if (RTLUtil.isRTL() && !this.isPortrait) {
      pageIndex = pageIndex === 0 ? 1 : 0;
    }
    return {column: column, row: row, page: pageIndex};
  }

  private updateCoverItemInfo(coverItem: GridLayoutItemInfo): void {
    if (GridLayoutUtil.checkGridItemEqual(this.coverItem, coverItem)) {
      return;
    }

    this.coverItem = coverItem;
    if (GridLayoutUtil.isValidLayoutItem(coverItem)) {
      const page: number =
        (this.mPageDesktopViewModel.getKeyBoardStatus() === FeatureConstants.NO_KEYBOARD ? coverItem.page : 0) ?? 0;
      this.coverItemCenter = GridLayoutUtil.getIconCenterPosition(coverItem.row, coverItem.column,
        coverItem.area, page, this.isPortrait);
      if (!coverItem.area) {
        return;
      }
      this.coverItemWidth =
        FormViewModel.getInstance(this.singleContext).getFormStyleConfig().getSize(coverItem.area[0]);
      this.coverItemWidth *= EditModeUtils.getDesktopScale();
      this.coverItemHeight =
        FormViewModel.getInstance(this.singleContext).getFormStyleConfig().getSize(coverItem.area[1]);
      this.coverItemHeight *= EditModeUtils.getDesktopScale();
    }
  }

  private canCover(x: number, y: number, dragItem: GridLayoutItemInfo, coverItem: GridLayoutItemInfo): boolean {
    if (!dragItem || !coverItem || GridLayoutUtil.checkGridItemEqual(dragItem, coverItem)) {
      return false;
    }
    this.isJudgingIconCover = (GridLayoutUtil.isIconType(dragItem.typeId) || GridLayoutUtil.isSmallFolder(dragItem)) &&
      (GridLayoutUtil.isIconType(coverItem.typeId) || GridLayoutUtil.isSmallFolder(coverItem));
    // 已经触发过挤位，无法合并
    if (this.moveList.has(GridLayoutUtil.generateUniqueKey(coverItem))) {
      return false;
    }
    if (this.canIconCover(x, y, dragItem, coverItem)) {
      return true;
    }
    if (this.canFolderCover(x, y, dragItem, coverItem)) {
      return true;
    }
    if (this.canCardCover(x, y, dragItem, coverItem)) {
      return true;
    }
    if (this.canFileCover(x, y, dragItem, coverItem)) {
      return true;
    }
    return false;
  }

  private shouldSqueeze(index: number, coverItem: GridLayoutItemInfo | undefined): boolean {
    /**
     * 目标落点位置未变化且满足以下任一条件时，无需触发挤位
     * 1、下方落位无元素
     * 2、下方元素已挤位
     * 3、下方元素待挤位
     */
    const res: boolean = (index === this.squeezeIndex) &&
      (!coverItem || this.moveList.has(GridLayoutUtil.generateUniqueKey(coverItem)) ||
        this.squeezeTimeoutId !== CommonConstants.INVALID_VALUE);
    return !res;
  }

  /**
   * 判断拖拽图标是否位于中轴区
   * @param y 当前拖拽图标屏幕坐标y轴
   * @returns true:位于中轴区,false:不位于中轴区或非折叠屏折叠态
   */
  private isDragInCentral(y: number): boolean {
    if (this.isSuperFold && !this.isExpandStatus) {
      const bottom : number = LayoutViewModel.getInstance().getScreenHeight() / 2 + this.mDragCreaseHeight / 2;
      const top : number = bottom - this.mPageDesktopStyleConfig.mFoldCreaseRegionHeight;
      return y > top && y < bottom;
    }
    return false;
  }

  private canIconCover(x: number, y: number, dragItem: GridLayoutItemInfo, coverItem: GridLayoutItemInfo): boolean {
    // 当前设备不支持文件夹
    if (!this.isSupportFolder) {
      return false;
    }

    // 拖拽元素不为图标
    if (!GridLayoutUtil.isIconType(dragItem.typeId)) {
      return false;
    }
    // 覆盖元素不为图标
    if (!GridLayoutUtil.isIconType(coverItem.typeId) && !GridLayoutUtil.isSmallFolder(coverItem)) {
      return false;
    }
    const coverResult = GridLayoutUtil.canCreateFolder(
      this.coverItemWidth,
      [x, y],
      this.coverItemCenter,
      this.avgVX,
      this.avgVY
    );
    return coverResult;
  }

  private canFolderCover(x: number, y: number, dragItem: GridLayoutItemInfo, coverItem: GridLayoutItemInfo): boolean {
    // 拖拽元素不为图标
    if (!GridLayoutUtil.isIconType(dragItem.typeId)) {
      return false;
    }
    // 覆盖元素不为文件夹
    if (coverItem.typeId !== CommonConstants.TYPE_FOLDER) {
      return false;
    }
    // 下方文件夹已满
    if (!FolderViewModel.canDragIn(coverItem, dragItem)) {
      return false;
    }
    log.showInfo(`cover item center: ${this.coverItemCenter[0]}, ${this.coverItemCenter[1]},\
      width: ${this.coverItemWidth}, height: ${this.coverItemHeight}`);
    return (Math.abs(x - this.coverItemCenter[0]) < this.coverItemWidth / NUM_HALF) &&
      (Math.abs(y - this.coverItemCenter[1]) < this.coverItemHeight / NUM_HALF);
  }


  private canCardCover(x: number, y: number, dragItem: GridLayoutItemInfo, coverItem: GridLayoutItemInfo): boolean {
    // 当前设备不支持卡片堆叠
    if (!FormStackViewModel.isSupportFormStack()) {
      return false;
    }
    // 拖拽元素不为卡片
    if (dragItem.typeId !== CommonConstants.TYPE_CARD) {
      return false;
    }
    // 覆盖元素不为卡片和卡片堆叠
    if (coverItem.typeId !== CommonConstants.TYPE_CARD && coverItem.typeId !== CommonConstants.TYPE_FORM_STACK) {
      return false;
    }
    // 拖拽元素或者覆盖元素为透明卡片
    if (dragItem.isTransparent || coverItem.isTransparent) {
      return false;
    }
    // 4*6卡片不支持堆叠
    if (dragItem.cardDimension === CommonConstants.CARD_DIMENSION_6x4) {
      return false;
    }
    // 主题卡片不支持堆叠
    let themeBundleName: string = CommonConstants.THEME_MANAGER_BUNDLE;
    if (dragItem.bundleName === themeBundleName || coverItem.bundleName === themeBundleName) {
      return false;
    }
    // 游戏卡片不支持堆叠
    if (!this.isLiveFormSupportAddToStack(dragItem.gameCardInfo) ||
      !this.isLiveFormSupportAddToStack(coverItem.gameCardInfo)) {
      return false;
    }
    // 与下方卡片尺寸不一致
    if (coverItem.typeId === CommonConstants.TYPE_CARD &&
      dragItem.cardDimension !== coverItem.cardDimension) {
      return false;
    }
    // 与下方卡片堆叠尺寸不一致
    if (coverItem.typeId === CommonConstants.TYPE_FORM_STACK &&
      dragItem.cardDimension !== coverItem.layoutInfo?.[0]?.[0]?.cardDimension) {
      return false;
    }
    // 下方卡片堆叠已满
    if (coverItem.typeId === CommonConstants.TYPE_FORM_STACK &&
      (coverItem.layoutInfo?.[0]?.length ?? 0) >= FormStackStyleConstants.FORM_STACK_CARD_MAX_NUM) {
      return false;
    }
    return (1 - Math.abs(x - this.coverItemCenter[0]) / this.coverItemWidth) *
      (1 - Math.abs(y - this.coverItemCenter[1]) / this.coverItemHeight) > FORM_STACK_CREATE_FACTOR;
  }

  private canFileCover(x: number, y: number, dragItem: GridLayoutItemInfo, coverItem: GridLayoutItemInfo): boolean {
    if (!FileFolderConfig.getInstance().isFileFolderEnable()) {
      return false;
    }
    let dragItemInfo: GridLayoutItemInfo = dragItem;
    const findDragItems: GridLayoutItemInfo[] | undefined = this.getDragItems();
    if (findDragItems && findDragItems.length > 1) {
      dragItemInfo = findDragItems.find(item => item.typeId === CommonConstants.TYPE_FILE_FOLDER) ?? dragItemInfo;
    }
    // 拖拽元素或覆盖元素不支持落入
    if (!FileFolderDragHandler.getInstance().isSupportCover(dragItemInfo, coverItem)) {
      return false;
    }
    const isDragHorizontal: boolean = Math.abs(x - this.coverItemCenter[0]) > Math.abs(y - this.coverItemCenter[1]);
    const offset: number = isDragHorizontal ? N_SQUEEZE_HORIZONTAL_OFFSET : N_SQUEEZE_VERTICAL_OFFSET;
    const isInCoveredItem: boolean = Math.hypot(x - this.coverItemCenter[0], y - this.coverItemCenter[1]) <
      (this.coverItemWidth / NUM_HALF + offset);
    log.showDebug('canFileCover, isInCoveredItem: ' + isInCoveredItem);
    return isInCoveredItem;
  }

  private isLiveFormSupportAddToStack(gameCardInfo: GameCardInfo | undefined): boolean {
    if (!gameCardInfo) {
      return true;
    }
    if (gameCardInfo.extensionType === OverflowConstants.INTERACTION_TYPE ||
      gameCardInfo.gameType === OverflowConstants.QUICK_TYPE_GAMECARD) {
      return false;
    }
    return true;
  }

  private isDropPositionColumnChanged(lastIndex: number, currentIndex: number): boolean {
    if (!this.mGridConfig || !this.mGridConfig.row) {
      return true;
    }
    return Math.floor(lastIndex / this.mGridConfig.row) !== Math.floor(currentIndex / this.mGridConfig.row);
  }

  private setSqueezeTimeout(index: number, squeezeFunc: Function): void {
    log.showInfo('squeeze timer start');
    if (!this.zSqueeze && this.isDropPositionColumnChanged(this.squeezeIndex, index) && !this.isSqueezeSuccess) {
      this.resetMoveItemList();
      this.resetLastMoveItemList();
    }
    const squeezeDelayForZSqueeze = this.isJudgingIconCover ? ICON_SQUEEZE_DELAY : SQUEEZE_DELAY;
    this.resetSqueezeTimeout();
    this.clearLastCoveredItemAnimation();
    this.squeezeIndex = index;
    this.squeezeTimeoutId = setTimeout(() => {
      squeezeFunc();
      this.squeezeTimeoutId = CommonConstants.INVALID_VALUE;
    }, this.zSqueeze ? squeezeDelayForZSqueeze : N_SQUEEZE_DELAY);
  }

  public resetSqueezeTimeout(): void {
    this.squeezeIndex = CommonConstants.INVALID_VALUE;
    if (this.squeezeTimeoutId !== CommonConstants.INVALID_VALUE) {
      log.showInfo('squeeze timer clear');
      clearTimeout(this.squeezeTimeoutId);
      this.squeezeTimeoutId = CommonConstants.INVALID_VALUE;
    }
  }

  public setIsDragPaste(isDragPaste: boolean): void {
    this.isDragPaste = isDragPaste;
  }

  public getIsDragPaste(): boolean {
    return this.isDragPaste;
  }

  private resetSqueezeStatus(): void {
    this.resetSqueezeTimeout();
    this.resetMoveItemList();
    this.resetLastMoveItemList();
    this.clearLastCoveredItemAnimation();
  }

  private getIndexByPosition(row: number, column: number): number {
    if (!this.mGridConfig || row < 0 || row >= this.mGridConfig.row || column < 0 || column >= this.mGridConfig.column) {
      return CommonConstants.INVALID_VALUE;
    }
    if (this.isSuperFold && this.isExpandStatus) {
      return this.getItemIndexForSuperFold(column, row);
    }
    return this.zSqueeze ? row * this.mGridConfig.column + column : column * this.mGridConfig.row + row;
  }

  /**
   * 网格报告打点
   */
  public reportEmptyGridInfo(): void {
    const info: DefaultDesktopLayoutInfo = this.mLayoutCacheManager.getDesktopLayoutInfo('reportEmptyGridInfo');
    let dragDelegate: CellLayoutDragDelegate | undefined = this.getDragDelegate();
    ReportEmptyGridUtil.reportEmptyGridInfo(info, dragDelegate);
  }
}

class PointInfo {
  public x: number = 0;
  public y: number = 0;
}

class SqueezeData {
  public x: number = 0;
  public y: number = 0;
  public dragDelegate: CellLayoutDragDelegate | undefined;
  public dragItemInfo: GridLayoutItemInfo | undefined;
  public cellAndSpan: CellAndSpan | undefined;
  public itemInfo: GridLayoutItemInfo | undefined;
  public isSamePlace: boolean = false;
  public dragItemType: number = -1;
}

class PositionInfo {
  public startPosition: DragItemPosition | undefined;
  public endPosition: DragItemPosition | undefined;
}

class AppListInfo {
  public appGridInfo: GridLayoutItemInfo[][] = [];
  public waterfallItemListInfo: GridLayoutItemInfo[] = [];
}

export class MoveItem {
  public page: number = -1;
  public typeId: number = 0;
  public cardId: string = '';
  public folderId: string = '';
  public folderName: string = '';
  public formStackId: string = '';
  public appName: string = '';
  public keyName: string = '';
  public row: number = 0;
  public column: number = 0;
  public position: number[][] = [];
  public shake: number = 0;
  public abilityName: string = '';
  public moduleName?: string;
  public isRepeatItem: boolean = false;
  public area: number[] = [];
  public uri?: string;
  public ino?: string;
  public layoutInfo?: Array<GridLayoutItemInfo[]>;
  public infoId?: string;
  public bundleName: string = '';
  public appIndex?: number;
  public isDrag?: boolean;
  public shortcutId?: string;
  public isShowSqueezeAnimation?: boolean;
  public squeezeExtraParam?: SqueezeExtraParam;

  static fromGridItem(item: GridLayoutItemInfo): MoveItem {
    let moveItem = new MoveItem();
    moveItem.page = item.page ?? -1;
    moveItem.typeId = item.typeId ?? 0;
    moveItem.cardId = item.cardId ?? '';
    moveItem.folderId = item.folderId ?? '';
    moveItem.folderName = item.folderName ?? '';
    moveItem.formStackId = item.formStackId ?? '';
    moveItem.appName = item.appName ?? '';
    moveItem.keyName = item.keyName ?? '';
    moveItem.area = item.area ?? [];
    moveItem.uri = item.uri;
    moveItem.infoId = item.infoId;
    moveItem.ino = item.ino;
    moveItem.bundleName = item.bundleName;
    moveItem.appIndex = item.appIndex;
    moveItem.shortcutId = item.shortcutId;
    moveItem.abilityName = item.abilityName;
    moveItem.moduleName = item.moduleName;
    return moveItem;
  }
}

class FindPositionParam {
  public dragItems: GridLayoutItemInfo[];
  public updateInfo: GridLayoutItemInfo[];
  public page: number = -1;
  public gridOccupyStatus?: GridOccupyStatus;
  public index: number = 0;
  public keySet: Set<string>;

  constructor(dragItems: GridLayoutItemInfo[], updateInfo: GridLayoutItemInfo[]) {
    this.dragItems = dragItems;
    this.updateInfo = updateInfo;
    this.keySet = new Set<string>();
    this.dragItems.forEach((item: GridLayoutItemInfo) => this.keySet.add(GridLayoutUtil.generateUniqueKey(item)));
  }
}

interface PageCoordinateData {
  gridXAxis: number[];
  gridYAxis: number[];
}