/**
 * Copyright (c) 2021-2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  AppGalleryDownloadManager,
  AppModel,
  Cache2RdbHelper,
  CommonConstants,
  DefaultDesktopLayoutInfo,
  DeliverUtil,
  DesktopDragResult,
  DesktopLayoutState,
  DesktopManager,
  DesktopUtils,
  DeviceState,
  DockItemInfo,
  EditModeConstants,
  editModeManager,
  EditModePageUtil,
  EditModeState,
  EditModeUtils,
  EditModeViewState,
  EventConstants,
  folderLayoutUtil,
  FolderOperationFlag,
  FormCenterViewManager,
  FormModel,
  GridLayoutItemInfo,
  GridLayoutUtil,
  keyEventManager,
  LauncherAnimUtil,
  LaunchLayoutCacheManager,
  layoutLockUtil,
  LayoutViewModel,
  ListenerItemType,
  lockLayoutManager,
  MultiSelectListenerType,
  multiSelectListenManger,
  MultiSelectManager,
  ReceiveEventInfo,
  ResidentLayoutCacheMgr,
  SmartDockZoomFeatureSwitch,
  StyleConstants,
  SwiperLoadManager,
  FolderManager,
  ContractedFolderCommonViewModel,
  PageInfoManager,
  FolderDropType,
  DragViewModelUtil,
  SwiperPageType,
  LiveFormSupportMgr,
  AdaptiveIconManager
} from '@ohos/launchercommon';
import { EditModeStyleConfig } from '@ohos/launchercommon/src/main/ets/editmode/data/PageEditData';
import lazy { pocketPreferenceUtil } from '@ohos/launchercommon/src/main/ets/utils/PocketPreferenceUtil';
import {
  AnimateToScheduleUtils,
  ArrayUtils,
  CheckEmptyUtils,
  DomainName,
  LanguageUtils,
  LogDomain,
  LogHelper,
  TraceUtil,
  SingleContext,
  OutdoorConfig
} from '@ohos/basicutils';
import {
  settingsDataManager,
  AccessibilityManager,
  ApsUtils,
  DeviceHelper,
  GlobalContext,
  GlobalSearchConstants,
  HiSysEventUtil,
  localEventManager,
  SCBDesktopCacheManager,
  ScreenState,
  sOutSideWindowMgr,
  ViewController,
  ViewManagerPolicy,
  ViewType,
  LightOutdoorConfig
} from '@ohos/frameworkwrapper';
import {
  animationContinueManager,
  DropAnimationCancelReason,
  DropAnimationDestination,
  DropAnimationListener,
  dropAnimationObserver,
  DropAnimationParam,
  DropAnimationScene
} from '@ohos/componentanimator';
import { AnimationType, DynamicWallPaperState, themeWallpaperAniMgr } from '@ohos/themeservice';
import { SwiperLoadData } from '@ohos/swiperdata';
import { desktopUtil, DragAccessibilityUtils, RTLUtil } from '@ohos/componenthelper';
import { DragBehaviorMode, DragConstants } from '@ohos/commonconstants';
import { DragPosition, DragEventManager, DragType } from '@ohos/componentdrag';
import { FormViewModel } from '@ohos/form';

import {
  DisplayEvent,
  EventType,
  launcherStatusUtil,
  ResUtils,
  SCBExpandController,
  SCBFoldController,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  SCBTransitionManager,
  ScenePanelState
} from '@ohos/windowscene';
// import apsManager from '@ohos.graphic.apsManager';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import FeatureConstants from '../constants/FeatureConstants';
import { BigFolderViewModel } from '@ohos/bigfolder/src/main/ets/default/viewmodel/BigFolderViewModel';
import curves from '@ohos.curves';
import { SwiperGestureHandler } from '../SwiperGestureHandler';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { PageDesktopViewModel } from '../viewmodel/PageDesktopViewModel';
import { PageDesktopDragHandler } from '../PageDesktopDragHandler';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import SinglePage from './SingePage';
import SwiperIndicator, { IndicatorController } from './SwiperIndicator';
import {
  EditModeBlankAnimatePageData,
  EditModeDragPageData,
  EditModeEditPageData,
  EditModePageActionEnum,
  launcherVisualEffectMgr,
  PageDragManager,
  pageEditManager,
  PageEditViewModel,
  FoldExpandAnimUtils,
  FoldAnimationConstants,
  SwiperPageManager,
} from '@ohos/launchercommon/Index';
import FolderChangeComponent from './folder/FolderChangeComponent';
import FormConstants from '@ohos/form/src/main/ets/default/common/constants/FormConstants';
import { DesktopAccessibilityUtils } from '../../common/DesktopAccessibilityUtils';
import { PreferenceStore } from '../dao/PreferenceStore';
import { DesktopParamPreference } from '../dao/DesktopParamPreference';
import displaySync from '@ohos.graphics.displaySync';
import componentUtils from '@ohos.arkui.componentUtils';
import { BusinessError, Callback } from '@ohos.base';
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import appManager from '@ohos.app.ability.appManager';
import systemParameter from '@ohos.systemparameter';
import { editModeViewManager } from '@ohos/desktopedit/src/main/ets/default/manager/EditModeViewManager';
import { EditModeGridSwiperViewData } from '@ohos/desktopedit/src/main/ets/default/data/EditModeGridSwiperViewData';
import { EditModeViewEvent } from '@ohos/desktopedit/src/main/ets/default/viewmodel/EditModeViewEvent';
import { GlobalSearchLocationHandler } from '../viewmodel/GlobalSearchLocationHander';
import { BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import {
  dropAnimationManager,
  ForceType,
  GravityAnimationConfig,
  GravityAnimationManager
} from '@ohos/componentanimator/Index';
import { GridOperationCallBack } from '@ohos/launchercommon/src/main/ets/cache/layout/SwiperLoadManager';
import { AppListInfo } from '../dao/AppListInfo';
import lazy { OverflowViewModel } from './liveform/viewmodel/OverflowViewModel';
import lazy OverflowFormUtils, { DisableGesture } from './liveform/common/OverflowFormUtils';
import {
  scbEventExclusiveManager
} from '@ohos/windowscene/src/main/ets/gesturenavigation/gestureignore/SCBEventExclusiveManager';
import { FormStackViewModel } from '@ohos/formstack/src/main/ets/viewmodel/FormStackViewModel';
import { formStackSnapShowManager } from '@ohos/formstack/src/main/ets/common/FormStackSnapShowManager';
import { ADMIN_USERID } from '@ohos/windowscene/src/main/ets/oobe/BaseOobeManager';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { CardSqueezer } from '../CardSqueezer';
import OpenFolderDragHandler from '@ohos/bigfolder/src/main/ets/default/common/OpenFolderDragHandler';
import { GridlayoutMemoryListener, MemoryManager } from '@ohos/frameworkcommon';
import { EditModeAddPage, EditModeAnimateBlankPage, } from '@ohos/desktopedit/index';
import { GridSwiperWallpaperViewModel } from '../viewmodel/GridSwiperWallpaperViewModel';
import { LengthMetrics, window } from '@kit.ArkUI';
import screenSessionManager from '@ohos.screenSessionManager';
import { editModeGuideManager } from '../EditModeGuideManager';
import lazy { outerAddAppIconManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAddAppIconManager';
import lazy {
  SCBTripleStateChange,
  TripleFoldExpandAnimUtils,
} from '@ohos/launchercommon/src/main/ets/utils/TripleFoldExpandAnimUtils';
import lazy { SCBTripleController } from '@ohos/windowscene/src/main/ets/animation/SCBTransitionController';
import { DisplayCountViewModel } from '@ohos/launchercommon/src/main/ets/displaycount/DisplayCountViewModel';
import { DisplayCountData } from '@ohos/launchercommon/src/main/ets/displaycount/DisplayCountData';
import { BlankPageViewModel } from '../viewmodel/BlankPageViewModel';
import { UIExceptionDetection } from '@ohos/windowscene/Index';
import { EditModeAccessibilityUtil } from '@ohos/launchercommon/src/main/ets/editmode/utils/EditModeAccessibilityUtil';
import { FormCenterViewModel } from '@ohos/form/src/main/ets/formcenter/viewmodel/FormCenterViewModel';
import { formZoomController } from './formAdjust/viewModel/FormZoomController';
import { FormZoomDragEvtParams, FormZoomDragEvtType } from './formAdjust/common/FormZoomCommonType';
import { AppStatusNameMapping } from '@ohos/launchercommon/src/main/ets/appinstall/AppStatusNameMapping';
import { ExposureManager } from '@ohos/launchercommon/src/main/ets/manager/ExposureManager';
import lazy PageEditTips from './PageEditTips';
import { LauncherStartup, StartupStep } from '@ohos/launchercommon/src/main/ets/tools/LauncherStartup';
import { DoubleClickLockScreenModel } from '@ohos/launchercommon/src/main/ets/pagedesktop/viewmodel/DoubleClickLockScreenModel';
import { PreLoadViewModel } from '../viewmodel/PreLoadViewModel';

const TAG = 'GridSwiper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const FOLD_EXPAND_MARGIN: number = 3;
const OUT_OF_SCREEN_RATIO: number = 4;
const THRESHOLD_SWIPER_SPEED = 40;
const KEYCODE_SEARCH: number = 9;

/**
 * 上滑滑动最小值
 */
const UP_PAN_GESTURE_MIN_DISTANCE = 6;

/**
 * 单页预加载时间间隔
 */
const SINGLE_PAGE_PRELOAD_TIME_INTERVAL: number = 100;

const EXPANDING_FOLD_OUTER_MARGIN_BOTTOM_OF_INDICATOR: number = 9.5;
// 扩展新形态小折叠产品 systemUI高度未适配临时方案
const EXPANDING_FOLD_SYSTEM_UI_TOP_HEIGHT = 28;
const OUTER_EDIT_MODE_MARGIN_BOTTOM_OF_INDICATOR: number = 46;
export enum AppStateStatus {
  FOREGROUND = 2,
  FOCUS = 3
}
const FOREGROUND_STATUS_LIST = [AppStateStatus.FOREGROUND, AppStateStatus.FOCUS];
const BUNDLE_NAME_LIST = [
  'com.ohos.sceneboard',
  'com.ohos.superhub',
  'com.openharmony.ohos.screenrecorder',
  'com.ohos.inputmethod',
  'com.ohos.hisearch',
  'com.ohos.hiwrite'
];
const MAX_RE_PRELOAD_SWIPER_COUNT: number = 5;
const MEM_STATIC_TEST = 'mem_static_test';

@Component
export default struct GridSwiper {
  @Prop singleContext?: SingleContext;
  @Prop gridConfig: string | undefined;
  @Prop screenId: number | undefined;
  @StorageLink('NavigationBarStatusValue') navigationBarStatusValue: boolean = false;
  @StorageLink('isDesktopLoadFinished') desktopLoadFinished: boolean = false;
  @StorageLink('isFolderChange') isFolderChange: boolean = false;
  @StorageLink('pageIndex') @Watch('updatePageIndexShow') pageIndex: number = 0;
  @StorageLink('outerPageIndex') @Watch('updatePageIndexShow') outerPageIndex: number = 0;
  @Consume('clearDesktopMemory') @Watch('trimGridSwiper') trimGridSwiperMemory: boolean;
  @Consume('releaseDesktopMemory') @Watch('releaseGridSwiper') releaseGridSwiperMemory: boolean;
  @Provide('toBigTranslateX') toBigTranslateX: number = 0;
  @Provide('toBigTranslateY') toBigTranslateY: number = 0;
  @Consume('convertFolderId') convertFolderId : string;
  @Consume('isFromDock') isFromDock: boolean;
  @StorageLink('isConvertFromDock') isConvertFromDock: boolean = false;
  @Provide('startPositionX') startPositionX: number = 0;
  @Provide('startPositionY') startPositionY: number = 0;
  @Provide('formStackTouchStatus') isFormStackTouch: boolean = false;
  @StorageLink('isDeskSwipe') isDeskSwipe: boolean = false;
  @State pageIndexShowed: number = 0;
  @StorageLink('showFirstPageFlag') @Watch('showFirstPageFlagChange') showFirstPageFlag: boolean = false;
  // 是否操作了跳转主页
  private isJumpToHomePage: boolean = false;
  private mPageDesktopViewModel?: PageDesktopViewModel;
  private mOverflowViewModel?: OverflowViewModel;
  @StorageLink('appListInfo') appListInfo: AppListInfo = new AppListInfo();
  //若有多个SwiperPage在全选时需要共享同一个List
  @StorageLink('selectedItemList') selectedItemList: string[] = [];
  @StorageLink('outerAppListInfo') outerAppListInfo: AppListInfo = new AppListInfo();
  @State @Watch('onPagesChange') pages: number[] = [];
  private oldPages: number[] = [];
  @State pagesLength: number = 0;
  // 主页唯一标志
  @State homeSwiperKey: number = 0;
  @State isEditMode: boolean = false;
  @State updateCachedCountFlag: boolean = false;
  private loadInstance: SwiperLoadManager = SwiperLoadManager.getInstance();
  private loadData: SwiperLoadData = SwiperLoadData.getInstance();
  private swiperController: SwiperController = new SwiperController();
  private mPageDesktopStyleConfig: PageDesktopGridStyleConfig = PageDesktopGridStyleConfig.getInstance();
  private mFormModel: FormModel = FormModel.getInstance();
  private mFormStackViewModel: FormStackViewModel = new FormStackViewModel();
  // 主屏相关属性至刷新一次
  private isFirstIn: boolean = true;
  private isPhone: boolean = false;
  private isPC: boolean = false;
  private isSuperFold: boolean = false;
  @State workSpaceHeight: number = 0;
  @StorageLink('isExecuteSearchGesture') isExecuteSearchGesture: boolean = false;
  private mPageDesktopDragHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance(this.singleContext);
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private ifSkipAnimationInEditMode: boolean = false;
  private isGestureSwipeHandled: boolean = false;
  @StorageLink('dragItemInfo') @Watch('onDragItemInfoChange') dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
  @StorageLink('convertItemInfo') convertItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
  @StorageLink('isExclusiveSwiperElementsEvent') isExclusiveSwiperElementsEvent: boolean = false;
  @StorageProp('isDrag') @Watch('onDragChange') isDrag: boolean = false;
  @StorageLink('folderStatus') @Watch('folderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageLink('foldStatusForOuterScreen') @Watch('folderStatusChange') foldStatusForOuterScreen: number = DeviceState.DEFAULT_STATE;
  @StorageLink('isPortrait') @Watch('onPortraitStatusChange') isPortrait: boolean = true;
  @StorageLink('screenWidth') @Watch('onScreenWidth') screenWidth: number = 0;
  @StorageProp('screenHeight') screenHeight: number = 0;
  @StorageLink('systemLanguage') @Watch('onLanguageChange') language: string = '';
  @State editModeGridSwiperViewData: EditModeGridSwiperViewData = editModeViewManager.getEditModeGridSwiperViewData();
  @Consume isDesktopEnabled: boolean;
  @StorageLink('dragItemFromFolder') dragItemFromFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
  @State indicatorAlpha: number = 1;
  @State indicatorTranslateX: number = 0;
  @State indicatorTranslateY: number = -10;
  @State indicatorScale: number = 1;
  @State marginBottomOfIndicator: number = 0;
  private foldController?: SCBFoldController;
  private expandController?: SCBExpandController;
  private tripleController?: SCBTripleController;
  private indicatorController: IndicatorController = new IndicatorController();
  @State hiSearchStatus: boolean = true;
  private isFactoryMode: boolean = systemParameter.getSync('const.runmode', 'default') === 'factory';
  private preferenceStore: PreferenceStore = new PreferenceStore(getContext()?.getApplicationContext() || GlobalContext.getContext(), 'DesktopSetting');
  @State swiperCurve: Curve | string | ICurve = launcherVisualEffectMgr.isLauncherSwiperCustomEnabled() ?
    Curve.Friction : curves.interpolatingSpring(-1, 1, 328, 34);
  @State duration:number = 350;
  private displayCountViewModel: DisplayCountViewModel = DisplayCountViewModel.getInstance();
  @State displayCountData: DisplayCountData = this.displayCountViewModel.getDisplayCountData();
  @Prop scaleCenterY: number = 1;
  @State editModeState: EditModeState = editModeManager.getEditModeState();
  private lastUpdateTime: number = new Date().getTime();
  private globalSearchLocationHandler: GlobalSearchLocationHandler = GlobalSearchLocationHandler.getInstance(this.singleContext);
  private delegateMove: Function = (event: DragEvent, extraParams?: string) => {
    this.dealDragMoveEvent(event, extraParams);
  }
  private delegateDrop: Function = (event: DragEvent, extraParams?: string) => {
    this.dealDropEvent(event, extraParams);
  }
  private foldCreaseRegionHeightChangeEvent: Function = (isExpandStatus: boolean, workSpaceHeight: number,
    foldCreaseRegionHeight: number): void =>
  this.superFoldStatusChange(foldCreaseRegionHeight, isExpandStatus, workSpaceHeight);
  private styleChangeEvent: Function = (): void => this.initWorkSpaceHeight();

  //手势起点坐标
  private startX:number = 0
  private startY:number = 0
  private showPageIndex: number = 0;
  private isNeedPreload: boolean = true;
  private isNewStyle: boolean = AppStorage.get<boolean>('desktopNewStyle') ?? true;
  private swiperEffect: EdgeEffect = EdgeEffect.Spring;
  private isDesktopLayout: boolean = true;
  private showFirstPageFlagCurves = curves.interpolatingSpring(0, 1, 130, 22);
  private onDesktopModeChangeEvent: Function = (): void => this.editModeStateChange();
  private onOpenEditPageEvent: Function = (isOpen: boolean): void => this.onOpenEditPage(isOpen);
  @StorageLink('formStackEditShow') mIsFormStackExpand: boolean = false;
  private desktopMarginTop = LayoutViewModel.getInstance(this.singleContext).calculateDesktop().mDesktopMarginTop as number;
  @State sysUITopHeight: number =
    false ? EXPANDING_FOLD_SYSTEM_UI_TOP_HEIGHT : LayoutViewModel.getInstance(this.singleContext).getSysUITopHeight();
  private allItem?: GridLayoutItemInfo[];

  // 页面编辑函数管理类
  private pageEditViewModel: PageEditViewModel = PageEditViewModel.getInstance();
  //2x4大文件夹使用引导弹窗:是否是通过滑动来翻页标志,全搜,添加卡片等场景触发的翻页不使能引导弹窗
  private afterGestureSwipe: boolean = false;
  private bigFolderUseGuidanceDialogController?: CustomDialogController;
  @State editModeBlankAnimatePageData: EditModeBlankAnimatePageData = pageEditManager.editModeBlankAnimatePageData;
  @State editModeDragPageData: EditModeDragPageData = pageEditManager.dragPageData;
  @State editModeEditPageData: EditModeEditPageData = pageEditManager.editModeEditPageData;
  // 页面拖拽提示文本框显隐事件计时器
  private dragPageTipAnimateTimer: number = 0;
  @State foldCreaseRegionHeight: number = 0;
  private onEditModeAnimationFinishEvent: Function = (): void => this.doUpdateCachedCountFlag();
  private desktopSwiperCallback: Function = (showPageIndex: number): void => {
    this.desktopSwiperCallbackEvent(showPageIndex);
  }
  private stopSwiperCallback: Function = (): void => this.stopSwiperCallbackEvent();
  private editModeViewEvent: EditModeViewEvent = editModeViewManager.getEditModeViewEvent();
  private singleHandChange: () => void = () => this.folderStatusChange();
  private editModeStyleConfig: EditModeStyleConfig = editModeManager.getEditModeStyleConfig();
  @Watch('onActiveFormChanged') @StorageLink('activeForm') activeForm: GridLayoutItemInfo | undefined = undefined;

  @State showDrawerModeEntryIcon: boolean = true;
  private showDrawerModeEntryIconId: number = 0

  onScreenWidth() {
    SwiperGestureHandler.getInstance().setWindowWidth(this.screenWidth);
  }

  /**
   * pages发生变化时，发页面获焦事件
   */
  private onPagesChange(): void {
    // 先对比长度
    let isChanged: boolean = this.oldPages.length !== this.pages.length;
    // 长度一致对比内容
    if (!isChanged) {
      for (let i = 0; i < this.pages.length; i++) {
        if (this.oldPages[i] !== this.pages[i]) {
          isChanged = true;
          break;
        }
      }
    }
    // 发生变化，发送事件
    if (isChanged) {
      this.oldPages = [...this.pages];
      this.desktopContext?.eventHub.emit(EventConstants.EVENT_UPDATE_PAGE_FOCUS);
    }
  }

  private superFoldStatusChange(foldCreaseRegionHeight: number, isExpandStatus: boolean,
    workSpaceHeight: number): void {
    log.showInfo(`superFoldStatusChange ${this.foldCreaseRegionHeight} ${foldCreaseRegionHeight},
      ${this.isPortrait}, ${workSpaceHeight}, ${isExpandStatus}`);
    this.mPageDesktopDragHandler.setSuperFoldStatus(this.isPortrait, isExpandStatus);
    if (foldCreaseRegionHeight === undefined) {
      if (this.workSpaceHeight !== workSpaceHeight) {
        this.workSpaceHeight = workSpaceHeight;
      }
      return;
    }
    if (this.foldCreaseRegionHeight !== foldCreaseRegionHeight || this.workSpaceHeight !== workSpaceHeight) {
      animateTo({
        duration: 400,
        curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1)
      }, () => {
        this.workSpaceHeight = workSpaceHeight;
        this.foldCreaseRegionHeight = foldCreaseRegionHeight ?? 0;
      });
    }
  }

  private endDragPage = (): void => {
    log.showInfo(`gridSwiper endDragPage`);
    this.pageEditViewModel.endDragPage();
    PageDragManager.getInstance().onCancelSqueezeEvent(false);
    PageDragManager.getInstance().onDragEndEvent();
    // 落位时显示页面拖拽提示文本框，重置显隐事件计时器
    this.pageEditViewModel.dragPageTipShowOrHideAnimate(this.editModeStyleConfig.dragPageTipOpacity, () => {
      this.dragPageTipAnimateTimer = setTimeout(() => {
        this.pageEditViewModel.dragPageTipShowOrHideAnimate(0);
        clearTimeout(this.dragPageTipAnimateTimer);
      }, EditModeConstants.HIDE_DRAG_PAGE_TIP_TIME);
    });
  }

  private startDragPage = (swiperKey: number): void => {
    log.showInfo(`startDragPage`)
    this.editModeEditPageData.canAddPageShow = pageEditManager.canAddPageShow();
    clearTimeout(this.dragPageTipAnimateTimer);
    this.pageEditViewModel.dragPageTipShowOrHideAnimate(0);
  }

  private editBlankPageWithAnimate = (action: number, swiperKey?: number, index?: number): void => {
    if (!launcherStatusUtil.isCurrentDesktopVisible(false)) {
      log.showWarn('current desktop is not visible');
      return;
    }
    if (action === EditModePageActionEnum.ADDING_BLANK_PAGE &&
      !this.editModeBlankAnimatePageData.showBlankAnimatePage) {
      log.showInfo(`ADDING_BLANK_PAGE`);
      this.editModeEditPageData.handleEditPageState = EditModePageActionEnum.ADDING_BLANK_PAGE;
      PageDragManager.getInstance().onEditSqueezeEvent(0, false);
      return;
    }
    if (action === EditModePageActionEnum.DELETEING_BLANK_PAGE &&
      !this.editModeBlankAnimatePageData.showBlankAnimatePage) {
      log.showInfo(`DELETEING_BLANK_PAGE`);
      // 删除空白页事件将可能未及时更新的index替换为唯一值swiperKey，确保删除正确
      if (swiperKey !== undefined && swiperKey !== null) {
        let realIndex = this.pages.indexOf(swiperKey);
        log.showInfo(`pages: ${this.pages}, trueIndex: ${realIndex}, index: ${index}`);
        if (realIndex < 0) {
          log.showWarn(`not find Deleting swiperKey: ${swiperKey}`);
          return;
        }
        PageDragManager.getInstance().initDragInfo(realIndex);
        this.editModeEditPageData.handleEditPageState = EditModePageActionEnum.DELETEING_BLANK_PAGE;
        this.editModeEditPageData.deletingLastBlankPage =
          PageEditViewModel.getInstance().isDeletingLastPage(false);
        log.showInfo('page: %{public}s is dragging', PageDragManager.getInstance().getDraggingPage());
        PageDragManager.getInstance().onEditSqueezeEvent(realIndex, true);
      }
      return;
    }
    if (action === EditModePageActionEnum.EXITING_BLANK_PAGE) {
      this.exitEditModeInAddPage();
      return;
    }
  }

  exitEditModeInAddPage() {
    this.swiperController.changeIndex(this.pages.length - 1, false);
    setTimeout(() => {
      editModeManager.clickBlankSpace()
    }, EditModeConstants.PAGE_EDIT_DELETE_ANIMATE_DELAY_TIME);
  }

  private hosKeySearchOption: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KEYCODE_SEARCH,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };
  private hosKeySearchCallback: Callback<inputConsumer.KeyOptions> = (keyOptions: inputConsumer.KeyOptions) => {
    log.showInfo('hosKeySearchCallback keyOptions is ' + keyOptions?.finalKey +
      `isShowGlobalSearch:${sOutSideWindowMgr.isShowGlobalSearch()}`);
    if (sOutSideWindowMgr.isShowGlobalSearch()) {
      sOutSideWindowMgr.hideGlobalSearch(false);
    } else {
      this.handSearchKeyEvent();
    }
  }
  private dropAnimationListener: DropAnimationListener = {
    onDropAnimationEnd: (target: DropAnimationDestination, param: DropAnimationParam) => {
      log.showInfo(`onDropAnimationEnd target:${target} key:${param.key}`);
      DragEventManager.getInstance(false).dropEnd(param.key);
      MultiSelectManager.getInstance().finishSingleDrag();
      animationContinueManager.releaseAll();
      if (this.pageEditViewModel.isDragingPage() && launcherStatusUtil.isCurrentDesktopVisible(false)) {
        this.endDragPage();
        // 拖拽起始页
        const oldPageIndex: number = this.pages.indexOf(this.editModeDragPageData.startDragPageSwiperKey);
        // 拖拽落位页
        const newPageIndex: number = PageDesktopDragHandler.getInstance(this.singleContext).getPageDragDropIndex();
        // 更新桌面缓存、数据库
        pageEditManager.handleDragPage(oldPageIndex, newPageIndex, false);
      }
    }
  };

  private multiSelectListener: MultiSelectListenerType = {
    id: multiSelectListenManger.getListenerId(ListenerItemType.GRID_SWIPER, '', false),
    beforeGather: () => {
      this.createDragCache2RdbEvent();
    },
    onCustomDrop: (touchPos: Position) => {
      this.dealDrop(Number(touchPos.x), Number(touchPos.y));
    },
    onFinish: (): void => {
      animationContinueManager.releaseAll();
      PageDesktopDragHandler.getInstance().resetPageDesktopStatus();
    }
  }

  private createDragCache2RdbEvent(): void {
    Cache2RdbHelper.getInstance().createEvent(CommonConstants.DRAG_RDB_EVENT)
  }

  private onDragChange(): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible(false)) {
      return;
    }
    if (DeviceHelper.isPhone() || DeviceHelper.isPad()) {
      scbEventExclusiveManager.setEventExclusive(EventType.DESKTOP_DRAG, this.isDrag);
    }
    if (this.isDrag) {
      this.createDragCache2RdbEvent();
    } else {
      Cache2RdbHelper.getInstance().executeEvent(CommonConstants.DRAG_RDB_EVENT, false, this.singleContext);
    }
    if (this.isDrag || dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP) ||
      dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_MULTI_SELECT) ||
      MultiSelectManager.getInstance().getStatus().inGatherOrDragOrDrop
    ) {
      return;
    }
    log.showInfo('drag end without drop animation');
    this.dragItemInfo = PageDesktopDragHandler.getInstance(this.singleContext).getSingleDragItemInfo() as GridLayoutItemInfo;
    if (!editModeManager.getIsShowingUninstallDialog()) {
      // 删除框展示时不删除空白页、交给删除框自己处理
      PageDesktopDragHandler.getInstance(this.singleContext).resetPageDesktopStatus();
    }
    this.dragFormStackBack();
    DragEventManager.getInstance().dropEnd(GridLayoutUtil.generateUniqueKey(this.dragItemInfo));
    // 无动效完成拖拽场景，闭环单选拖拽状态
    MultiSelectManager.getInstance().finishSingleDrag();
    dropAnimationManager.clear();
    animationContinueManager.releaseAll();
    if (this.pageEditViewModel.isDragingPage()) {
      this.endDragPage();
    }
  }

  onLanguageChange(): void {
    AppStatusNameMapping.getInstance().init();
  }

  onPortraitStatusChange() {
    log.showInfo(`onPortraitStatusChange isPortrait: ${this.isPortrait}`);
    scbEventExclusiveManager.setEventExclusive(EventType.DESKTOP_SWIPER, false);
    this.marginBottomOfIndicator = this.mPageDesktopStyleConfig.mMarginBottomOfIndicator;
    this.globalSearchLocationHandler.stopGlobalSearchProcess();
    if (!this.isPC) {
      folderLayoutUtil.initFolderLayoutConfig();
    }
    this.setFoldDsCount('onPortraitStatusChange');
    pageEditManager.updateBlankPageList(false);
  }

  private editModeStateChange(): void {
    // 升级或克隆后，HomePageIndex刷新了，但是homeSwiperKey可能没刷新，这里需要刷新一下
    this.homeSwiperKey = this.pages[PageInfoManager.getInstance().getHomePageIndex()];
    if (editModeManager.isInEditMode()) {
      // 进入编辑模式时设置页面拖拽提示文本框显示，并设置计时器，5秒后隐藏文本
      clearTimeout(this.dragPageTipAnimateTimer);
      this.pageEditViewModel.dragPageTipShowOrHideAnimate(this.editModeStyleConfig.dragPageTipOpacity, () => {
        this.dragPageTipAnimateTimer = setTimeout(() => {
          this.pageEditViewModel.dragPageTipShowOrHideAnimate(0);
          clearTimeout(this.dragPageTipAnimateTimer);
        }, EditModeConstants.HIDE_DRAG_PAGE_TIP_TIME);
      });
      // 进入编辑模式时更新背板Y轴坐标，用于计算文本位置
      this.pageEditViewModel.updateEditModeBackGroundWidthAndHeight();
      this.pageEditViewModel.updateEditModeBackGroundPointY(
        editModeViewManager.getEditModeSingePageViewData().getEditModeBgTranslateY(),
        this.editModeGridSwiperViewData.getGridSwiperScale(),
        editModeViewManager.getEditModeSingePageViewData().getSingePageSwiperScale(),
        false
      );
      if (AccessibilityManager.getInstance().getIsAccessibilityMode()) {
        this.desktopContext?.eventHub.emit(EventConstants.EVENT_UPDATE_PAGE_FOCUS);
      }
    }
    if (this.pageEditViewModel.isDragingPage()) {
      this.endDragPage();
    }
    this.editModeEditPageData.canAddPageShow = pageEditManager.canAddPageShow();
    if (!this.isPC) {
      // pc当前不支持大文件夹
      folderLayoutUtil.initFolderLayoutConfig();
    }
    // 退出编辑模式时，若在加号页，则回到最后一页
    if (!editModeManager.isInEditMode() && this.pageIndexShowed >= this.pages.length && this.pages.length > 0) {
      this.setPageIndex(this.pages.length - 1);
      log.showInfo(`editModeStateChange pageIndexShowed changed to: ${this.pageIndexShowed}`);
    }
    if (!editModeManager.isInEditMode()) {
      this.indicatorAlpha = 1;
    }
    this.changeOuterAddIconVisible();
    animateTo({ duration: 300, curve: Curve.EaseInOut }, () => {
      this.isEditMode = editModeManager.isInEditMode();
    });
  }

  doUpdateCachedCountFlag(): void {
    this.updateCachedCountFlag = editModeManager.isInEditMode();
  }

  private onOpenEditPage(isOpen: boolean): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible()) {
      return;
    }
    animateTo({
      delay: isOpen ? 0 : 150,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
    }, () => {
      this.indicatorAlpha = isOpen ? 0 : 1;
    })
  }

  private trimGridSwiper(): void {
    log.showInfo(' trim GridSwiper ')
  }

  private releaseGridSwiper(): void {
    log.showInfo(' release GridSwiper')
  }

  private onDragItemInfoChange(): void {
    if (!this.dragItemInfo || !launcherStatusUtil.isCurrentDesktopVisible()) {
      return;
    }

    log.showWarn(`onDragItemInfoChange dragItemInfo:${DesktopUtils.desktopItemsToString(this.dragItemInfo)}`);
    CardSqueezer.getInstance(this.singleContext).onDragItemChange();
    if (JSON.stringify(this.dragItemInfo) === '{}' || CheckEmptyUtils.checkStrIsEmpty(this.dragItemInfo.bundleName)) {
      this.dragItemFromFolder.folderId = '';
      this.dragItemFromFolder.keyName = '';
    }
  }

  updatePageIndexShow() {
    if (this.showFirstPageFlag || !launcherStatusUtil.isCurrentDesktopVisible()) {
      log.showInfo('inChangeIndexToZero return');
      return;
    }
      this.pageIndexShowed = this.pageIndex;
      this.mPageDesktopDragHandler.setDragPageIndex(this.pageIndex);
  }

  private getPageIndex() {
    return this.pageIndex;
  }

  private setPageIndex(index: number) {
    return (this.pageIndex = index);
  }

  folderStatusChange(): void {
    this.isDeskSwipe = false;
    this.mPageDesktopViewModel?.setIsChangingPage(false);
    this.setFoldDsCount('folderStatusChange:' + this.folderStatus);
    if (PageInfoManager.getInstance().getMaxDisplayCount() === StyleConstants.DEFAULT_3) {
      pageEditManager.onFoldStatusChange(true);
    } else {
      if (this.folderStatus === DeviceState.DEFAULT_STATE) {
        this.deleteLastBlankPage();
        pageEditManager.onFoldStatusChange(false);
      } else {
        this.addLastBlankPage();
        pageEditManager.onFoldStatusChange(true);
      }
    }
    this.appListInfoChange();
    this.mPageDesktopViewModel?.folderStatusChange(this.getPageIndex());
    this.marginBottomOfIndicator = this.mPageDesktopStyleConfig.mMarginBottomOfIndicator;
    this.globalSearchLocationHandler.stopGlobalSearchProcess();
    if (!this.isPC) {
      folderLayoutUtil.initFolderLayoutConfig();
    }
    OpenFolderDragHandler.getInstance().onFolderStatusChange();
  }

  private checkNewPagesAdded(oldPages: number[], newPages: number[]): boolean {
    let result: boolean = false;
    newPages.forEach((pageKey: number) => {
      if (oldPages.indexOf(pageKey) === -1) {
        result = true;
      }
    });
    return result;
  }

  appListInfoChange(): void {
    SwiperLoadData.getInstance().refreshPages(this.getAppListInfo().appGridInfo.length);
    // 如果有新添加页，需要走预加载流程预加载添加的页面
    if (this.checkNewPagesAdded(this.pages, SwiperLoadData.getInstance().getPages())) {
      log.showWarn('GridSwiper preload pages again. old page:%{public}d -> newPages:%{public}d',
        this.pages.length, SwiperLoadData.getInstance().getPages().length);
      this.isNeedPreload = true;
    }
    this.pages = SwiperLoadData.getInstance().getPages().slice(0);
    // 异步获取主屏下标已经完成，此处给展示页pageIndexShowed及主页Key赋值
    let homePageIndex: number = PageInfoManager.getInstance().getHomePageIndex();
    if (this.isFirstIn) {
      this.homeSwiperKey = this.pages[homePageIndex];
      this.pageIndexShowed = homePageIndex;
      this.isFirstIn = false;
    }
    if (this.isNeedPreload) {
      let userId: number = AppModel.getInstance().getUserId();
      // 主用户才需要swiper预加载
      if (userId === ADMIN_USERID) {
        // 初始化加载队列
        PageInfoManager.getInstance().initPreloadQueue(this.pages.length);
        new PreLoadViewModel(this.swiperController, this.pages.length).preloadNextPage(PageInfoManager.getInstance()
          .getNextPreload());
        this.isNeedPreload = false;
      }
    }
    log.showInfo(`pages length: ${this.pages.length}, pages: ${JSON.stringify(this.pages)}`);
    this.pagesLength = this.pages.length;
    SwiperLoadManager.getInstance().loadIndicator();
    if (this.pages.length > 0) {
      this.indicatorController.updateValues(0);
    }
    pageEditManager.updateBlankPageList();
    this.editModeEditPageData.canAddPageShow = pageEditManager.canAddPageShow();
  }


  /**
   * 编辑模式切换时,改变加号显隐状态
   */
  private changeOuterAddIconVisible(): void {
  }

  private getAppListInfo() {
    return this.appListInfo;
  }

  deleteLastBlankPage() {
    let appGridInfoLength = this.getAppListInfo().appGridInfo.length;
    if (appGridInfoLength > 0 && appGridInfoLength % StyleConstants.DEFAULT_2 === 0 &&
    CheckEmptyUtils.isEmptyArr(this.getAppListInfo().appGridInfo[appGridInfoLength - 1])) {
      log.showInfo(`deleteLastBlankPage, appGridInfo.length:${appGridInfoLength}`)
      this.getAppListInfo().appGridInfo.pop();
      LaunchLayoutCacheManager.getInstance()
        .updatePageCount(this.getAppListInfo().appGridInfo.length, BusinessType.BUSINESS_BASIC_DESKTOP, true);
    }
  }

  addLastBlankPage() {
    let appGridInfoLength = this.getAppListInfo().appGridInfo.length;
    if (appGridInfoLength % StyleConstants.DEFAULT_2 === 1) {
      log.showInfo(`addLastBlankPage, appGridInfo.length:${appGridInfoLength}`);
      this.getAppListInfo().appGridInfo.push([]);
      LaunchLayoutCacheManager.getInstance()
        .updatePageCount(this.getAppListInfo().appGridInfo.length, BusinessType.BUSINESS_BASIC_DESKTOP, true,
          );
    }
  }

  private showFirstPageFlagChange(): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible()) {
      return;
    }
    const lastDuration: number = this.duration;
    this.duration = 1000;
    AppStorage.setOrCreate('showDesktopPageFlag', this.showFirstPageFlag);
    this.swiperController.finishAnimation();
    log.showInfo(`showFirstPageFlagChange is:${this.showFirstPageFlag}, PageIndex is:${this.getPageIndex()}`);
    let homePageIndex: number = PageInfoManager.getInstance().getHomePageIndex();
    let displayCount: number = this.displayCountData.getDisplayCount();
    if (this.showFirstPageFlag && this.getPageIndex() != homePageIndex) {
      dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_DESKTOP);
      this.swiperCurve = this.showFirstPageFlagCurves;
      this.setPageIndex(homePageIndex);
      this.swiperController.changeIndex(homePageIndex, true);
      this.isJumpToHomePage = true;
      DesktopAccessibilityUtils.textAnnouncedWhenJumpToHomePage(Math.ceil((homePageIndex + 1) / displayCount),
        Math.ceil(this.pages.length / displayCount));
      log.showInfo('changeIndex to homepage');
    } else {
      this.showFirstPageFlag = false;
    }
    this.duration = lastDuration;
  }

  private desktopSwiperCallbackEvent(showPageIndex: number): void {
    const lastDuration: number = this.duration;
    this.duration = 0;
    this.swiperController.finishAnimation();
    log.showInfo(`showPageIndexChange is:${showPageIndex}, PageIndex is:${this.getPageIndex()}`);
    if (showPageIndex !== this.getPageIndex()) {
      this.setPageIndex(showPageIndex);
      this.swiperController.changeIndex(this.getPageIndex(), false);
      log.showInfo('desktop changeIndex to showPageIndex');
    }
    this.duration = lastDuration;
  }

  private stopSwiperCallbackEvent(): void {
    log.showInfo('stop swiper animation');
    this.swiperController?.finishAnimation();
  }

  aboutToAppear(): void {
    this.gridSwiperLoadInit();
    DesktopManager.getInstance().registerScreenChangeListener(this.singleHandChange);
    this.mFormModel = FormModel.getInstance();
    if (this.mPageDesktopViewModel && launcherStatusUtil.isCurrentDesktopVisible()) {
      this.mPageDesktopViewModel.setSwiperController(this.swiperController);
    }
    this.desktopContext?.eventHub.on(CommonConstants.GRID_SWIPER_DELEGATE_TO_MOVE, this.delegateMove);
    this.desktopContext?.eventHub.on(CommonConstants.GRID_SWIPER_DELEGATE_TO_DROP, this.delegateDrop);
    this.desktopContext?.eventHub.on(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    this.desktopContext?.eventHub.on(EventConstants.EVENT_OPEN_ICON_EDIT_PAGE, this.onOpenEditPageEvent);
    this.desktopContext?.eventHub.on(EventConstants.EVENT_SUPER_FOLD_CONFIG_CHANGE,
      this.foldCreaseRegionHeightChangeEvent);
    this.desktopContext?.eventHub.on(EventConstants.EVENT_WORKSPACE_POSITION_CHANGE,
      this.styleChangeEvent);
    this.desktopContext?.eventHub.on(CommonConstants.EVENTHUB_DRAG_LEAVE_FROM_SMALL_FOLDER_ADVANCE,
      (event: DragEvent, extraParams: string) => {
        this.onDragDrop(event, extraParams);
      }
    );
    this.desktopContext?.eventHub.on(EventConstants.EDIT_BLANK_PAGE_IN_EDIT_MODE, this.editBlankPageWithAnimate);
    this.desktopContext?.eventHub.on(EventConstants.END_DRAG_PAGE_IN_EDIT_MODE, this.endDragPage);
    this.desktopContext?.eventHub.on(EventConstants.PRE_DRAG_PAGE_IN_EDIT_MODE, this.startDragPage);
    this.desktopContext?.eventHub.on(EventConstants.EVENT_CHANGE_CHANGE_EDIT_MODE_ANIMATION_FINISH,
      this.onEditModeAnimationFinishEvent);
    this.marginBottomOfIndicator = this.mPageDesktopStyleConfig.mMarginBottomOfIndicator;
    let tempFolderStatus: number | undefined = AppStorage.get<number>('folderStatus');
    if (tempFolderStatus !== undefined) {
      this.folderStatus = tempFolderStatus;
    }
    let device: string = AppStorage.get('device') as string;
    this.isPhone = (device === CommonConstants.DEFAULT_DEVICE_TYPE);
    this.isPC = DeviceHelper.isPC();
    this.isSuperFold = DeviceHelper.isSuperFoldMachine();
    this.swiperEffect = this.isPC ? EdgeEffect.None : EdgeEffect.Spring;
    this.registerControllers();
    this.folderStatus = (AppStorage.get('folderStatus') ?? DeviceState.DEFAULT_STATE) as number;
    if (this.folderStatus === DeviceState.DEFAULT_STATE) {
      pageEditManager.onFoldStatusChange(false);
    } else {
      pageEditManager.onFoldStatusChange(true);
    }
    this.setFoldDsCount('aboutToAppear');
    log.showInfo('dsCount:%{public}d folderStatus:%{public}d isFactoryMode:%{public}s',
      this.displayCountData.getDisplayCount(), this.folderStatus, this.isFactoryMode);
    this.initPageCallBack();
    settingsDataManager.setValue(null, 'isFirstPageLoaded', 'false');
    SwiperPageManager.getInstance().registerSwiperPageCallback(SwiperPageType.DESKTOP_SWIPER,
      this.desktopSwiperCallback);
    SwiperPageManager.getInstance()
      .registerSwiperPageCallback(SwiperPageType.STOP_SWIPER, this.stopSwiperCallback)

    this.preferenceStore = new PreferenceStore(getContext()?.getApplicationContext() || GlobalContext.getContext(), 'DesktopSetting');
    new DesktopParamPreference(getContext()?.getApplicationContext() || GlobalContext.getContext());
    this.registerMultiSelectListener();
    pageEditManager.getBlankPageListFromRdb();
    this.initWorkSpaceHeight();
    this.registerMemoryOptimizer();
    this.mFormModel?.registerGetFromRectInfoCallback();
    if (LiveFormSupportMgr.getInstance().isSupportGameCard() || LiveFormSupportMgr.getInstance().isSupportLiveForm()) {
      this.mOverflowViewModel = OverflowViewModel.getInstance();
    }
    this.mOverflowViewModel?.registerOverflowCallback();
    this.mOverflowViewModel?.registerClearOverflowLinkedListListener();
    localEventManager.registerEventListener(this.mSwiperPageSlideListener, [
      EventConstants.EVENT_BREAK_SLIDE_SWIPER_PAGE,
    ]);
    DoubleClickLockScreenModel.getInstance().onStart();
  }

  private readonly mSwiperPageSlideListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string) => {
      log.showInfo('mSwiperPageSlideListener receive event: %{public}s', event);
      if (event === EventConstants.EVENT_BREAK_SLIDE_SWIPER_PAGE) {
        this.stopSwiperCallbackEvent();
      }
    }
  };

  private setFoldDsCount(reason: string): void {
    log.showInfo('setFoldDsCount reason: %{public}s', reason);
    if (this.isSuperFold) {
      // 折叠pc展开态下一屏放两个
      this.displayCountData.setDisplayCount(StyleConstants.DEFAULT_2);
      PageInfoManager.getInstance().setDisplayCount(StyleConstants.DEFAULT_2);
      return;
    }
    this.displayCountViewModel.calculate(this.isPortrait, this.folderStatus as DeviceState);
    this.desktopContext?.eventHub.emit(EventConstants.EVENT_CHANGE_DESKTOP_DISPLAY_COUNT);
    if (PageInfoManager.getInstance().getMaxDisplayCount() === StyleConstants.DEFAULT_3) {
      BlankPageViewModel.getInstance().dealBlankPage(this.appListInfo, this.folderStatus);
      pageEditManager.onFoldStatusChange(true);
      SwiperLoadData.getInstance().refreshPages(this.getAppListInfo().appGridInfo.length);
      this.pages = SwiperLoadData.getInstance().getPages().slice(0);
      this.pagesLength = this.pages.length;
      SwiperLoadManager.getInstance().loadIndicator();
      if (this.pages.length > 0) {
        this.indicatorController.updateValues(0);
      }
      this.mPageDesktopViewModel?.folderStatusChange(this.getPageIndex());
    }
  }

  private initWorkSpaceHeight(): void {
    log.showInfo('initWorkSpaceHeight');
    if (!this.isSuperFold) {
      return;
    }
    let isExpandStatus: boolean = false;
    try {
      isExpandStatus = screenSessionManager.SuperFoldStatus.SUPER_FOLD_STATUS_EXPANDED ===
        screenSessionManager.getSuperFoldStatus();
    } catch (error) {
      log.showError(`can not get fold status ${error?.code}, ${error?.message}`);
    }
    let mGridHeight: number = 0;
    let marginTop: number = 0;
    let paddingTop: number = 0;
    if (this.mPageDesktopViewModel) {
      const pageDesktopStyleConfig: PageDesktopGridStyleConfig =
        this.mPageDesktopViewModel?.getPageDesktopStyleConfig();
      mGridHeight = pageDesktopStyleConfig.mGridHeight as number;
      marginTop = pageDesktopStyleConfig.mDesktopMarginTop as number;
      paddingTop = pageDesktopStyleConfig.mWorkSpacePaddingTop as number;
    }
    let extraHeight: number = (marginTop + paddingTop) * 2;
    log.showInfo(`init config isExpandStatus ${isExpandStatus}, mGridHeight ${mGridHeight}, marginTop ${marginTop},
      paddingTop ${paddingTop}`);
    const mFoldCreaseRegionHeight: number = this.mPageDesktopStyleConfig.mFoldCreaseRegionHeight;
    // 如果是竖屏展开态，就是两个工作区加两个边距，如果是折叠态，还需加中轴区高度
    if (isExpandStatus) {
      this.foldCreaseRegionHeight = 0;
      if (this.isPortrait) {
        this.workSpaceHeight = extraHeight + mGridHeight * 2;
      } else {
        this.workSpaceHeight = paddingTop + mGridHeight;
      }
    } else {
      this.foldCreaseRegionHeight = mFoldCreaseRegionHeight;
      this.workSpaceHeight = extraHeight + mGridHeight * 2 + mFoldCreaseRegionHeight;
    }
    log.showInfo(`initWorkSpaceHeight workSpaceHeight: ${this.workSpaceHeight}`);
    this.mPageDesktopDragHandler.setSuperFoldStatus(this.isPortrait, isExpandStatus);
  }

  private onActiveFormChanged(): void {
    log.showInfo('onActiveFormChanged, this.activeForm is %{public}s ', this.activeForm);
    if (!this.activeForm) {
      this.mOverflowViewModel?.clearAllRequestOverflowTimer();
    }
  }

  private initPageCallBack(): void {
    let pageCallBack: GridOperationCallBack = {
      refreshPageDesktop: (): void => {
        this.appListInfoChange();
        let turnToPage: number = SwiperLoadManager.getInstance().getPageTurn();
        if (turnToPage !== -1) {
          log.showInfo('initPageCallBack,index:' + turnToPage);
          setTimeout(() => {
            this.swiperController.changeIndex(turnToPage, true);
            SwiperLoadManager.getInstance().clearPageTurn();
          }, 50);
        }
      },
      clearSwiperPages: () => {
        log.showWarn('clearSwiperPages pages=[]');
        SwiperLoadData.getInstance().clearSwiperPages();
        this.pages = [];
        this.pagesLength = 0;
      }
    }
    SwiperLoadManager.getInstance().setGridOperation(pageCallBack);
  }

  registerControllers(): void {
    this.desktopContext?.eventHub.on(EditModeConstants.EVENT_EDIT_MODE_COMPONENT_DROP,
      (event?: DragEvent, extraParams?: string, ifSkipAnimationInEditMode?: boolean): void => {
        if (!launcherStatusUtil.isCurrentDesktopVisible()) {
          return;
        }
        this.ifSkipAnimationInEditMode = ifSkipAnimationInEditMode ?? false;
        this.mPageDesktopDragHandler.onDragLeave(event?.getWindowX() ?? 0, event?.getWindowY() ?? 0);
        this.dealDragEnterEvent(event, extraParams);
        this.dealDropEvent(event, extraParams);
      });

    // fold screen animation
    this.foldController = {
      itemId: `${TAG}_Indicator`,
      onFoldAnimation: () => this.foldedAnimation(),
    };
    this.expandController = {
      itemId: `${TAG}_Indicator`,
      onExpandAnimation: () => this.expandedAnimation(),
    };
    SCBTransitionManager.getInstance().registerFoldAnimationController(this.foldController);
    SCBTransitionManager.getInstance().registerExpandAnimationController(this.expandController);
    if (DeviceHelper.isThreeFoldProduct()) {
      this.tripleController = {
        itemId: `${TAG}_Indicator`,
        onTripleAnimation: (oldState: ScreenState, newState: ScreenState, isNeedAnimation: boolean) =>
        this.tripleAnimation(oldState, newState, isNeedAnimation),
      };
      SCBTransitionManager.getInstance().registerTripleAnimationController(this.tripleController);
    }
    inputConsumer.on('key', this.hosKeySearchOption, this.hosKeySearchCallback);
    dropAnimationObserver.registerDropAnimationListener(this.dropAnimationListener);
  }

  unRegisterControllers(): void {
    this.desktopContext?.eventHub.off(EditModeConstants.EVENT_EDIT_MODE_COMPONENT_DROP);
    this.desktopContext?.eventHub.off(FormConstants.EVENTHUB_FORM_MANAGER_UNDO_HOT_AREA);
    SCBTransitionManager.getInstance().unRegisterFoldAnimationController(this.foldController);
    SCBTransitionManager.getInstance().unRegisterExpandAnimationController(this.expandController);
    if (DeviceHelper.isThreeFoldProduct()) {
      SCBTransitionManager.getInstance().unRegisterTripleAnimationController(this.tripleController);
    }
    inputConsumer.off('key', this.hosKeySearchOption);
    dropAnimationObserver.unregisterDropAnimationListener(this.dropAnimationListener);
  }

  private gridSwiperLoadInit(): void {
    this.isNewStyle = AppStorage.get<boolean>('desktopNewStyle') ?? true;
    this.setSwiperAnimationCurve();

    if (this.mPageDesktopViewModel) {
      this.mPageDesktopStyleConfig = this.mPageDesktopViewModel.getPageDesktopStyleConfig();
    }
  }

  private setSwiperAnimationCurve() {
    if (this.isNewStyle) {
      this.swiperCurve = launcherVisualEffectMgr.isLauncherSwiperCustomEnabled() ? Curve.Friction :
        curves.interpolatingSpring(-1, 1, 328, 34);
      this.duration = 350;
    } else {
      this.swiperCurve = Curve.Linear;
      this.duration = 350;
    }
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');

    this.mPageDesktopViewModel?.setPageIndex();
    DesktopManager.getInstance().unregisterScreenChangeListener(this.singleHandChange);
    this.unRegisterControllers();
    this.desktopContext?.eventHub.off(CommonConstants.GRID_SWIPER_DELEGATE_TO_MOVE, this.delegateMove);
    this.desktopContext?.eventHub.off(CommonConstants.GRID_SWIPER_DELEGATE_TO_DROP, this.delegateDrop);
    this.desktopContext?.eventHub.off(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopModeChangeEvent);
    this.desktopContext?.eventHub.off(EventConstants.EVENT_OPEN_ICON_EDIT_PAGE, this.onOpenEditPageEvent);
    this.desktopContext?.eventHub.off(EventConstants.EVENT_SUPER_FOLD_CONFIG_CHANGE,
      this.foldCreaseRegionHeightChangeEvent);
    this.desktopContext?.eventHub.off(EventConstants.EVENT_WORKSPACE_POSITION_CHANGE,
      this.styleChangeEvent);
    this.desktopContext?.eventHub.off(EventConstants.EDIT_BLANK_PAGE_IN_EDIT_MODE, this.editBlankPageWithAnimate);
    this.desktopContext?.eventHub.off(EventConstants.END_DRAG_PAGE_IN_EDIT_MODE, this.endDragPage);
    this.desktopContext?.eventHub.off(EventConstants.PRE_DRAG_PAGE_IN_EDIT_MODE, this.startDragPage);
    settingsDataManager.setValue(null, 'isFirstPageLoaded', 'false');
    this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_DRAG_LEAVE_FROM_SMALL_FOLDER_ADVANCE);
    SwiperPageManager.getInstance().unRegisterSwiperPageCallback(SwiperPageType.DESKTOP_SWIPER,
      this.desktopSwiperCallback);
    SwiperPageManager.getInstance().unRegisterSwiperPageCallback(SwiperPageType.STOP_SWIPER,
      this.stopSwiperCallback);
    this.unRegisterMultiSelectListener();
    scbEventExclusiveManager.unRegisterEventExclusive(EventType.DESKTOP_SWIPER);
    this.desktopContext?.eventHub.off(EventConstants.EVENT_CHANGE_CHANGE_EDIT_MODE_ANIMATION_FINISH,
      this.onEditModeAnimationFinishEvent);
    this.unregisterMemoryOptimizer();
    this.mFormModel?.unregisterGetFromRectInfoCallback();
    this.mOverflowViewModel?.unregisterClearOverflowLinkedListListener();
    this.mOverflowViewModel?.unregisterOverflowCallback();
    this.mOverflowViewModel?.unregisterOverflowGrayAppEventListener();
    DoubleClickLockScreenModel.getInstance().onStop();
  }

  private registerMultiSelectListener(): void {
    multiSelectListenManger.register(this.multiSelectListener);
  }

  private unRegisterMultiSelectListener(): void {
    multiSelectListenManger.unregister(this.multiSelectListener);
  }

  // fold screen animation
  private foldedAnimation(): void {
    log.showInfo('indicator execute foldedAnimation');
    let delayTime: number = 0;
    this.indicatorAlpha = 0;
    if (FoldExpandAnimUtils.isSupportProduct) {
      this.indicatorTranslateX = FoldExpandAnimUtils.initIndicatorTransX(this.screenWidth, false);
      this.indicatorScale = FoldAnimationConstants.START_SCALE;
      animateTo({
        curve: FoldAnimationConstants.INDICATOR_CURVE,
      }, () => {
        this.indicatorScale = 1;
      })
    } else {
      this.indicatorTranslateX = FoldAnimationConstants.FOLD_FACTOR * this.screenWidth;
      delayTime = FoldAnimationConstants.FOLD_DELAY / 2;
    }
    animateTo({
      curve: FoldExpandAnimUtils.getIndicatorTranslateCurve(),
      delay: delayTime,
      onFinish: () => {
        performanceMonitor.end('EXPAND_TO_FOLD_INDICATOR');
        // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, StyleConstants.DEFAULT_0);
      }
    }, () => {
      this.indicatorTranslateX = 0;
    })
    animateTo(FoldExpandAnimUtils.getIndicatorAlphaAnimParam(delayTime), () => {
      this.indicatorAlpha = 1;
    })
  }

  private expandedAnimation(): void {
    log.showInfo('indicator execute expandedAnimation');
    animateTo({
      duration: 0,
    }, () => {
      this.indicatorAlpha = 0;
      this.indicatorTranslateX = FoldExpandAnimUtils.initIndicatorTransX(this.screenWidth);
      this.indicatorTranslateY = FoldExpandAnimUtils.initIndicatorTransY(this.screenHeight);
      this.indicatorScale = FoldExpandAnimUtils.initIndicatorScale();
    })
    let delayTime: number = FoldExpandAnimUtils.getIndicatorAnimDelay();
    animateTo(FoldExpandAnimUtils.getIndicatorExpandAnimParam(delayTime), () => {
      this.indicatorTranslateX = 0;
      this.indicatorTranslateY = 0;
      this.indicatorScale = 1;
    })
    animateTo(FoldExpandAnimUtils.getIndicatorAlphaAnimParam(delayTime), () => {
      this.indicatorAlpha = 1;
    })
  }

  private tripleAnimation(oldState: ScreenState, newState: ScreenState, isNeedAnimation: boolean): void {
    if (!isNeedAnimation) {
      log.showInfo(`indicator noneed tripleAnimation`);
      return;
    }
    log.showInfo(`indicator execute tripleAnimation, oldState is ${oldState}, newState is ${newState}`);
    let stateChange: SCBTripleStateChange = TripleFoldExpandAnimUtils.getTripleDesktopStateChange(newState, oldState);
    this.indicatorAlpha = 0;
    this.indicatorTranslateX = TripleFoldExpandAnimUtils.initTripleIndicatorTransX(this.screenWidth, stateChange);
    let traceName: string = 'Desktop-TripleFoldExpandAnimation_' + TripleFoldExpandAnimUtils.getTraceName(stateChange);
    performanceMonitor.begin(traceName, performanceMonitor.ActionType.LAST_UP);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, 1);
    animateTo(TripleFoldExpandAnimUtils.getIndicatorExpandAnimParam(stateChange), () => {
      this.indicatorTranslateX = 0;
    });
    animateTo({
      curve: Curve.Friction,
    }, () => {
      this.indicatorAlpha = 1;
    });
  }

  private closeConvertAnimate() {
    if (this.isFromDock || this.isConvertFromDock) {
      this.convertFolderId = CommonConstants.DEFAULT_ID;
      this.isFromDock = false;
      this.isConvertFromDock = false;
      let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      let index = residentList.findIndex((item) => item.typeId === CommonConstants.TYPE_FOLDER &&
        item.keyName === this.convertItemInfo.folderId);
      this.convertItemInfo = new GridLayoutItemInfo();
      if (index >= 0) {
        residentList.splice(index, 1);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems(TAG.concat('_close'), residentList, false);
      }
      log.showInfo('closeConvertAnimate index: %{public}d', index);
    }
  }


  private onDragDrop(event: DragEvent, extraParams?: string): void {
    dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
    const dragItemType: number = AppStorage.get('dragItemType') as number;
    log.showWarn(`onDrop event: [${event.getWindowX()}, ${event.getWindowY()}], dragItemType:${dragItemType}`);
    if (this.isPhone && (dragItemType === CommonConstants.DRAG_FROM_SWIPE_UP ||
      dragItemType === CommonConstants.DRAG_FROM_FORM_SERVICE ||
      dragItemType === CommonConstants.DRAG_FROM_MANAGE ||
      dragItemType === CommonConstants.DRAG_FROM_FORM_INTELLIGENT)) {
      AppStorage.setOrCreate('undoDragFormVisible', false);
      // 如果是扩展新形态小折叠产品外屏或者智慧屏且是编辑模式不显示状态栏
      if (!(this.isEditMode)) {
        ViewManagerPolicy.showView(ViewType.STATUS_BAR);
      }
    }

    const deviceAllowDragTypes = [
    CommonConstants.DRAG_FROM_DOCK,
    CommonConstants.DRAG_FROM_MANAGE,
    CommonConstants.DRAG_FROM_SWIPE_UP,
    CommonConstants.DRAG_FROM_FORM_SERVICE,
    CommonConstants.DRAG_FROM_FORM_INTELLIGENT,
    CommonConstants.DRAG_FROM_FORM_STACK
    ];

    if (dragItemType === CommonConstants.DRAG_FROM_DESKTOP ||
      dragItemType === CommonConstants.DRAG_FROM_APP_ICON ||
      dragItemType === CommonConstants.DRAG_FROM_FOLDER ||
      dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK ||
      dragItemType === CommonConstants.DRAG_FROM_FORM_SERVICE ||
      dragItemType === CommonConstants.DRAG_FROM_SHORTCUT ||
      (deviceAllowDragTypes.includes(dragItemType) && this.isPhone)) {
      let rectangle = event.getPreviewRect();
      let dropX: number;
      let dropY: number;
      if (this.isSuperFold && this.mPageDesktopDragHandler.isDragLeaveSwiperPage()) {
        dropX = event.getWindowX() ?? 0;
        dropY = event.getWindowY() ?? 0;
      } else {
        dropX = Number(rectangle.x) + Number(rectangle.width) / 2;
        dropY = Number(rectangle.y) + Number(rectangle.height) / 2;
      }
      if (this.mPageDesktopViewModel?.getIsChangingPage()) {
        this.swiperController.finishAnimation(() => {
          log.showInfo(`onDragDrop, swiperController finishAnimation`);
          this.dealDrop(dropX, dropY, event);
        });
      } else {
        this.dealDrop(dropX, dropY, event);
      }
    }
  }

  private dealDrop(dropX: number, dropY: number, event?: DragEvent): void {
    let dragResult: DesktopDragResult = this.mPageDesktopDragHandler.onDragDrop(dropX, dropY);
    log.showInfo(`onDrop dragResult: ${JSON.stringify(dragResult)}`);
    if (dragResult.needDropAnimation && !this.ifSkipAnimationInEditMode) {
      if (event) {
        event.executeDropAnimation(() => {
          this.doDropAnimation(dropX, dropY, dragResult, event);
          this.finishDrop();
        });
      } else {
        // 多选汇聚过程中松手时，不存在event，直接执行落位动效
        this.doDropAnimation(dropX, dropY, dragResult, event);
        this.finishDrop();
      }
      return;
    }
    this.finishDrop();
  }

  private finishDrop(): void {
    this.ifSkipAnimationInEditMode = false;
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_PAGEDESK_DROP_FINISHED, null);
    AppStorage.setOrCreate('selectAppIndex', null);
    PageDesktopDragHandler.getInstance(this.singleContext).onStartDrop();
  }

  private doDropAnimation(dropX: number, dropY: number, dragResult: DesktopDragResult, event?: DragEvent): void {
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE, true);
    let dragItems = PageDesktopDragHandler.getInstance(this.singleContext).getDragItems() ?? [];
    if (dragItems.length > 1 && !this.isPC) {
      MultiSelectManager.getInstance().startDrop(
        dropX, dropY, PageDesktopDragHandler.getInstance(this.singleContext).getCurrentPageIndex()
      );
    } else {
      const dropParam = this.dropAnimation(dropX, dropY, dragResult, event);
      if (dragResult.dropToDock) {
        return;
      }
      const dragItemInfo: GridLayoutItemInfo = dragItems[0];
      let size = dragItemInfo.area as number[];
      setTimeout(() => {
        if (dropParam) {
          log.showInfo('trigger gravity animation with item drop on grid swiper');
          /* pageIndex切换的时候，元素会重建，会在aboutToAppear里添加新的元素，所以不需要更新indexInSwiper */
          GravityAnimationManager.getInstance().run(SwiperLoadData.getInstance()
            .getSwiperKeyByIndex(this.pageIndexShowed),
            dropParam.endX, dropParam.endY, ForceType.REPULSION, size);
        }
      }, GravityAnimationConfig.getDelayOnDrop());
    }
  }

  private animationToOriginalPos(start: DragPosition, end: DragPosition, dragItem: GridLayoutItemInfo): void {
    let itemKey: string = GridLayoutUtil.generateUniqueKey(dragItem);
    let param: DropAnimationParam = new DropAnimationParam(itemKey, start.x, start.y, end.x, end.y);
    let screenHeight: number = LayoutViewModel.getInstance(this.singleContext).getScreenHeight();
    let dockHeight: number = LayoutViewModel.getInstance(this.singleContext).getDockHeight();
    let toDesktop: boolean = end.y < screenHeight - dockHeight;
    dropAnimationManager.startDropAnimation(
      toDesktop ? DropAnimationDestination.DESKTOP : DropAnimationDestination.DOCK, param);
    if (toDesktop) {
      setTimeout(() => {
        if (param) {
          log.showInfo('trigger gravity animation with item drop on grid swiper');
          GravityAnimationManager.getInstance().run(SwiperLoadData.getInstance()
            .getSwiperKeyByIndex(this.pageIndexShowed),
            param.endX, param.endY, ForceType.REPULSION, dragItem.area);
        }
      }, GravityAnimationConfig.getDelayOnDrop());
    }
  }

  dropAnimation(dropX: number, dropY: number, dragResult: DesktopDragResult,
    event?: DragEvent): DropAnimationParam | null {
    let dragItemInfo: GridLayoutItemInfo =
      PageDesktopDragHandler.getInstance(this.singleContext).getSingleDragItemInfo() as GridLayoutItemInfo;
    if (!dragItemInfo) {
      log.showError('dragItemInfo is undefined');
      return null;
    }
    let fallPosition: number[] | undefined =
      PageDesktopDragHandler.getInstance(this.singleContext).getFallPosition(dragResult.dropToDock,
        dragItemInfo.isFormDimension1x4);
    if (!fallPosition || fallPosition.length < 2) {
      log.showError('fall position is null');
      return null;
    }
    let translateXForScreenSplit: number = AppStorage.get<number>('translateXForScreenSplit') ?? 0 as number;
    let param = new DropAnimationParam(GridLayoutUtil.generateUniqueKey(dragItemInfo),
      dropX, dropY, fallPosition[0] + translateXForScreenSplit, fallPosition[1]);
    if (event) {
      let previewRect = event.getPreviewRect();
      param.startWidth = Number(previewRect.width);
      param.startHeight = Number(previewRect.height);
      // dock缩放后，图标大小与桌面不一致
      const dragItemType: number = AppStorage.get('dragItemType') as number;
      if (dragItemType === DragType.DRAG_FROM_DOCK && !dragResult.dropToDock &&
      SmartDockZoomFeatureSwitch.isSupportZoom()) {
        param.endWidth = this.mPageDesktopStyleConfig.mIconSize;
        param.endHeight = this.mPageDesktopStyleConfig.mIconSize;
        param.endRadius = this.mPageDesktopStyleConfig.mIconRadius;
      }
    }
    let dragItemType: number = AppStorage.get<number>('dragItemType') as number;
    if (dragItemType === CommonConstants.DRAG_FROM_FORM_SERVICE) {
      let formStyleConfig = FormViewModel.getInstance().getFormStyleConfig();
      param.endWidth = EditModeUtils.convertWithDesktopScale(
        formStyleConfig.mFormWidth.get(String(dragItemInfo.cardDimension)) ?? 0);
      param.endHeight = EditModeUtils.convertWithDesktopScale(
        formStyleConfig.mFormHeight.get(String(dragItemInfo.cardDimension)) ?? 0);
      param.endRadius =
        EditModeUtils.convertWithDesktopScale(formStyleConfig.getFormBorderRadius(dragItemInfo.cardDimension));
      param.endScaleX = 1;
      param.endScaleY = 1;
    }
    if (dragItemType === CommonConstants.DRAG_FROM_FORM_INTELLIGENT) {
      let formStyleConfig = FormViewModel.getInstance(this.singleContext).getFormStyleConfig();
      param.endWidth = formStyleConfig.mFormWidth.get(String(dragItemInfo.cardDimension)) ?? 0;
      param.endHeight = formStyleConfig.mFormHeight.get(String(dragItemInfo.cardDimension)) ?? 0;
      param.endRadius = formStyleConfig.getFormBorderRadius(dragItemInfo.cardDimension);
    }
    dropAnimationManager.startDropAnimation(DropAnimationDestination.DESKTOP, param);
    return param;
  }

  isDisableSwiperToIntelligent(): boolean {
    // 编辑模式与拖拽为交集关系,需要分开判断.只有拖拽卡片时可以横滑进入负一屏
    if (editModeManager.isInEditMode()) {
      return true;
    }

    // 未拖拽时，可以横滑进负一屏
    if (!this.isDrag) {
      return false;
    }
    // 拖拽时，仅卡片可以进负一屏
    return !this.isCardDragging();
  }

  /**
   * 拖拽过程中仅卡片(不包括语音助手建议)能拖入负一屏
   */
  private isCardDragging(): boolean {
    return !CheckEmptyUtils.isEmpty(this.dragItemInfo) && this.dragItemInfo.typeId === CommonConstants.TYPE_CARD;
  }

  /**
   * 编辑模式翻页热区
   */
  private getEditmodeResponseRegion(): Rectangle {
		return {
      x: -((this.screenWidth / this.editModeGridSwiperViewData.getGridSwiperScale() - this.screenWidth) / 2),
      y: 0,
      width: this.screenWidth / this.editModeGridSwiperViewData.getGridSwiperScale(),
      height: '100%'
    };
	}

  /**
   * 单击空白处退出编辑模式
   */
  public exitEditModeByclickBlankSpace(): void {
    if (!launcherStatusUtil.getShowOutLauncherStatus()) {
      log.showWarn(`is not ShowOutLauncher, cannot exit editmode.` );
      return;
    }
    if (editModeManager.isInNormalMode()) {
      return;
    }
    if (this.pageEditViewModel.isDragingPage()) {
      log.showWarn(`is draging page, cannot exit editmode.` );
      return;
    }
    if (pageEditManager.editModeEditPageData.handleEditPageState !== EditModePageActionEnum.WAITTING_ACTION) {
      log.showWarn(`is in add or delete page animation, cannot exit editmode.`);
      return;
    }
    if (!this.editModeViewEvent.canExitEditMode()) {
      log.showWarn(`touchDistance is too far, cannot exit editmode.`);
      return;
    }
    log.showInfo('EditMode back plane onclick');
    editModeManager.clickBlankSpace();
  }

  private getAddBlankTranslate(): string {
    if (this.displayCountData.getDisplayCount() === StyleConstants.DEFAULT_3) {
      return StyleConstants.PERCENTAGE_NEGATIVE_200;
    } else if (this.displayCountData.getDisplayCount() === StyleConstants.DEFAULT_2) {
      return StyleConstants.PERCENTAGE_NEGATIVE_100;
    } else {
      return '0';
    }
  }

  @Styles
  gridSwiperStyle() {
    .clip(CommonConstants.DEFAULT_CLIP_FALSE)
    .height(this.isSuperFold ? this.workSpaceHeight : StyleConstants.PERCENTAGE_100)
    .width(StyleConstants.PERCENTAGE_100)
    .accessibilityLevel('no')
    .onDragEnter((event?: DragEvent, extraParams?: string) => {
      this.dealDragEnterEvent(event, extraParams);
    })
    .onDrop((event?: DragEvent, extraParams?: string) => {
      log.showInfo(`gridSwiper onDrop`);
      performanceMonitor.end(HiSysEventUtil.DRAG_ITEM_ANI);
      TraceUtil.endTrace(DomainName.HOME, HiSysEventUtil.DRAG_ITEM_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
      this.dealDropEvent(event, extraParams);
    })
    .onDragMove((event: DragEvent, extraParams?: string) => {
      this.dealDragMoveEvent(event, extraParams);
    })
    .onDragLeave((event: DragEvent, extraParams?: string) => {
      log.showWarn('onDragLeave event:[%{public}d, %{public}d], pageIndex: %{public}d',
      event.getWindowX(), event.getWindowY(), desktopUtil.getPageIndexValue());
      if (editModeManager.isInEditMode()) {
        // 编辑模式不触发dragLeave事件
        return;
      }
      this.mPageDesktopDragHandler.onDragLeave(event.getWindowX(), event.getWindowY());
      this.mPageDesktopDragHandler.clearSwipeTimeout();
    })
    .onKeyEvent((event: KeyEvent) => {
      if (!DeviceHelper.isPC()) {
        return;
      }
      // 避免单击手势消费键盘事件导致键盘事件停止冒泡，提前处理
      if (event.keyCode === KeyCode.KEYCODE_ENTER || event.keyCode === KeyCode.KEYCODE_SPACE) {
        keyEventManager.dispatchKeyEvent(event);
      }
    })
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down && this.needResetFocusWhenTouchDown()) {
        PageDesktopViewModel.getInstance().restoreAll();
      }
      this.editModeViewEvent.calTouchDistance(event);
    })
    // 编辑模式需要并发识别手势，互斥手势同时存在单击、双击手势时，识别单击手势会有300ms延迟
    .gesture(GestureGroup(GestureMode.Parallel,
      // 双击处理逻辑中无手机相关场景，则对于手机都按照单击注册，避免双击手势影响点击打开应用的手势识别
      TapGesture({ count: CommonConstants.GESTURE_DOUBLE_CLICK })
        .onAction((event?: GestureEvent) => {
          log.showInfo('onClick desktop double');
          DoubleClickLockScreenModel.getInstance().sendDoubleClicked(TAG, event);
          if (DeviceHelper.isPcNot2in1Device()) {
            log.showInfo('pc double click to send animation info to wallpaper');
            if (dropAnimationManager.isInDropAnimation(DropAnimationScene.SCENE_DESKTOP)) {
              log.showWarn('drag item is doing drop animation, do not double click.');
              return;
            }
            themeWallpaperAniMgr.reqPlayWallpaperAnimation({
              curState: DynamicWallPaperState.DOUBLE_CLICK,
              tarState: DynamicWallPaperState.DESKTOP,
              isOffScreenSupportAod: false,
              onFinish: () => {},
              isPlayingAnimation: true,
            });
          } else if (DeviceHelper.isPad()) {
            log.showInfo('pad double click to send animation info to wallpaper');
            themeWallpaperAniMgr.sendAnimationInfo2Wallpaper({
              animationType: AnimationType.WALLPAPER_DOUBLE_CLICK_PAD
            });
            GridSwiperWallpaperViewModel.getInstance(this.singleContext).sendDoubleClicked(this.isEditMode);
          } else if (DeviceHelper.isPhone()) {
            log.showInfo('phone double click to send interactive event to wallpaper');
            GridSwiperWallpaperViewModel.getInstance(this.singleContext).sendDoubleClicked(this.isEditMode);
          }
        }),
      TapGesture({ count: CommonConstants.GESTURE_SINGLE_CLICK})
        .onAction((event?: GestureEvent) => {
          log.showInfo('onClick desktop single');
          GridSwiperWallpaperViewModel.getInstance(this.singleContext).sendSingleClicked(this.isEditMode);
          if (DeviceHelper.isPhone()) {
            AppStorage.setOrCreate('selectDesktopAppItem', null);
            AppStorage.setOrCreate('selectItem', '');
            PageDesktopViewModel.getInstance(this.singleContext).initSelectStatus();
          }
          this.exitEditModeByclickBlankSpace();
        }),
    ))
  }

  build() {
    if (this.desktopLoadFinished) {
      if (this.isEditMode) {
        PageEditTips()
      }
      Stack({ alignContent: Alignment.Bottom }) {
        Swiper(this.swiperController) {
          ForEach(this.pages, (item: number, index: number) => {
            if (!this.hiddenForOptimize(index)) {
              SinglePage({
                singleContext: this.singleContext,
                index: index,
                swiperKey: item,
                homeSwiperKey: this.homeSwiperKey,
                mPageDesktopViewModel: this.mPageDesktopViewModel,
                gridConfig: this.gridConfig,
                isDisableSwiperToIntelligent: (): boolean => {
                  return this.isDisableSwiperToIntelligent();
                },
                isDesktopLayout: this.isDesktopLayout,
                pagesLength: this.pagesLength,
                displayCountData: this.displayCountData,
              })
            } else {
              Stack()
            }
          }, (item: object, index: number) => {
            return JSON.stringify(item);
          })
          // 编辑模式未满18屏可在右侧添加一页空白页
          if (this.editModeEditPageData.canAddPageShow) {
            EditModeAddPage({
              singleContext: this.singleContext,
              indexInSwiper: this.pagesLength,
            })
              .translate({ x: RTLUtil.isRTL() ? this.getAddBlankTranslate() : 0 })
          }
        }
        .accessibilityScrollTriggerable(false)
        .id(TAG + '_Stack_Swiper')
        .responseRegion(this.getEditmodeResponseRegion())
        .vertical(this.isSuperFold ? this.isPortrait : false)
        .itemSpace(this.isSuperFold ? this.foldCreaseRegionHeight : 0)
        .displayCount(this.displayCountData.getDisplayCount(), true)
        .scale({
          x: this.editModeGridSwiperViewData.getGridSwiperScale(),
          y: this.editModeGridSwiperViewData.getGridSwiperScale(),
          centerX: StyleConstants.PERCENTAGE_50,
          centerY: this.scaleCenterY,
        })
        .prevMargin(this.editModeGridSwiperViewData.getPrevNextMargin() + this.displayCountData.getPreMargin())
        .nextMargin(this.editModeGridSwiperViewData.getPrevNextMargin() + this.displayCountData.getNextMargin())
        .clip(CommonConstants.DEFAULT_CLIP_FALSE)
        .margin({ top: this.isPC ? 0 : this.sysUITopHeight})
        .effectMode(this.swiperEffect)
        .index(this.pageIndexShowed)
        .curve(this.swiperCurve)
        .duration(this.duration)
        .indicator(false)
        .cachedCount(this.getCachedCount(), editModeManager.isInEditMode() || this.displayCountData.getCacheCount() > 0)
        .accessibilityLevel('no')
        .hitTestBehavior(this.isExclusiveSwiperElementsEvent ? HitTestMode.Block : HitTestMode.Default)
        .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
          log.showWarn(`onAnimationStart targetIndex: ${targetIndex}, index: ${index}`);
          // desktopUtil.setApsSceneWindowCheck(apsManager.SceneAnimation.SLIDE_DESKTOP, 1);
          GridSwiperWallpaperViewModel.getInstance(this.singleContext).sendMovedEnd(index, targetIndex, this.isEditMode);
          this.mPageDesktopDragHandler.setDragPageIndex(targetIndex);
          dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_DESKTOP);
          SCBTransitionManager.getInstance().cancelCloseAppAnimate();
          formStackSnapShowManager.cancelSnapViewShow();
          if (FolderManager.getInstance().isFolderClosing()) {
            // 桌面翻页不打断文件夹打开动效，避免因为误触影响文件夹的正常打开
            ContractedFolderCommonViewModel.getInstance()
              .closeFolder('close folder by grid swiper', FolderOperationFlag.IMMEDIATELY);
          }
          AppStorage.setOrCreate('isInGridSwiperGesture', false);
          scbEventExclusiveManager.setEventExclusive(EventType.DESKTOP_SWIPER, false);
          log.showInfo('swiper change to page index= ' + index + ' PageIndex= ' + this.getPageIndex());
          LauncherAnimUtil.setIsUIBusy(TAG, true);
          AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
          this.mPageDesktopViewModel?.setIsChangingPage(true);
          let controller = SCBTransitionManager.getInstance().getCurrentTransitionController();
          if (controller?.updateAnimSwipeEnd &&
            this.editModeEditPageData.handleEditPageState === EditModePageActionEnum.WAITTING_ACTION &&
            !SCBTransitionManager.getInstance().isExitSwipeIng) {
            SCBTransitionManager.getInstance().handleSwipeToEnd(targetIndex, index);
          }
          SCBTransitionManager.getInstance().setLastSwipeOffset(0);
          SCBTransitionManager.getInstance().setLastSwipeOffsetChanged(0);
          if (this.isNewStyle && !this.showFirstPageFlag &&
            this.editModeEditPageData.handleEditPageState === EditModePageActionEnum.WAITTING_ACTION) {
            this.handOffIndicatorAnimation(extraInfo, targetIndex !== index);
          }
          if (index === targetIndex) {
            performanceMonitor.begin('LAUNCHER_SPRINGBACK_SCROLL', performanceMonitor.ActionType.FIRST_MOVE);
          } else {
            performanceMonitor.begin('LAUNCHER_OVER_SCROLL', performanceMonitor.ActionType.FIRST_MOVE);

            // 文件夹内app长按菜单卡片中，添加卡片触发桌面滑动到新一页，立即关闭文件夹，以修复文件夹关闭落位动效
            ContractedFolderCommonViewModel.getInstance().closeFolder('swiper close', FolderOperationFlag.IMMEDIATELY);
          }
          editModeGuideManager.openEditModeGuideBySwipe(index, targetIndex, extraInfo, this.pages.length);
          if (this.editModeDragPageData.dragPageState === EditModePageActionEnum.DRAG_PAGE_MOVING) {
            log.showWarn(`onAnimationStart return DRAG_PAGE_MOVING`);
            return;
          }
          if (targetIndex >= this.pages.length) {
            log.showWarn(`onAnimationStart return targetIndex overRange`);
            return;
          }
          if (this.editModeDragPageData.dragPageState === EditModePageActionEnum.START_DRAG_PAGE &&
            targetIndex !== index
          ) {
            // 设置handleDragPageState值，用于阻拦动效完成前的冗余触发
            this.editModeDragPageData.dragPageState = EditModePageActionEnum.DRAG_PAGE_MOVING;
            PageDragManager.getInstance().onDragSqueezeEvent(targetIndex);
          }
          // 拖拽中滑动翻页支持新建一页
          let isDrag = AppStorage.get<boolean>('isDrag');
          if (!isDrag) {
            log.showDebug('swiper not in drag or switching page');
            return;
          }
          if (extraInfo.currentOffset >= 0 || (Math.abs(extraInfo.velocity) < THRESHOLD_SWIPER_SPEED)) {
            log.showDebug('swiper to left or swiper velocity slow, not process!');
            return;
          }
          if (index !== targetIndex) {
            this.mPageDesktopDragHandler.setDragBehaviorMode(DragBehaviorMode.DRAG_BY_SWIPER);
          }
          if (index === targetIndex && targetIndex === this.pages.length - this.displayCountData.getDisplayCount()) {
            this.mPageDesktopDragHandler.setDragBehaviorMode(DragBehaviorMode.DRAG_BY_SWIPER);
            const dragItemInfo: GridLayoutItemInfo = AppStorage.get('dragItemInfo') as GridLayoutItemInfo;
            const dragItemType: number = AppStorage.get('dragItemType') as number;
            let dragItemInfoPage = dragItemInfo.page ?? 0;
            this.dealMoveNextPage(index, dragItemInfoPage, dragItemType, PageDesktopViewModel.getInstance(this.singleContext));
          }
        })
        .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent) => {
          // desktopUtil.setApsSceneWindowCheck(apsManager.SceneAnimation.SLIDE_DESKTOP, 0);
          if (Math.abs(extraInfo.currentOffset) <= 1) {
            this.mPageDesktopViewModel?.setIsChangingPage(false);
          } else {
            log.warn(TAG, `extraInfo.currentOffset : ${extraInfo.currentOffset}`);
          }
          AppStorage.setOrCreate('isInGridSwiperGesture', false);
          scbEventExclusiveManager.setEventExclusive(EventType.DESKTOP_SWIPER, false);
          this.isGestureSwipeHandled = false;
          this.isDeskSwipe = false;
          LauncherAnimUtil.setIsUIBusy(TAG, false);
          performanceMonitor.end('LAUNCHER_OVER_SCROLL');
          performanceMonitor.end('LAUNCHER_SPRINGBACK_SCROLL');
          if (!this.showFirstPageFlag) {
            this.onAnimationEndNotShowFirstPageFlag(extraInfo);
          } else {
            this.showFirstPageFlag = false;
            this.setSwiperAnimationCurve();
            this.setPageIndex(index);
          }
          this.mPageDesktopDragHandler.setDragPageIndex(index);
          if (GlobalSearchLocationHandler.getInstance(this.singleContext).getGlobalSearchAnimation()) {
            this.desktopContext?.eventHub.emit(`globalSearchLocationSwitchToPage`);
          }
          if (this.editModeDragPageData.dragPageState === EditModePageActionEnum.DRAG_PAGE_MOVING) {
            this.editModeDragPageData.dragPageState = EditModePageActionEnum.START_DRAG_PAGE;
          }
        })
        .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
          log.showInfo(`onSizeChange`);
          this.mPageDesktopViewModel?.setIsChangingPage(false);
        })
        .loop(false)
        .onTouch((event?: TouchEvent) => {
          if (event?.type === TouchType.Down) {
            log.showInfo(`onTouch down desktop`);
            UIExceptionDetection.getInstance().restoreUIException();
            PageDesktopDragHandler.getInstance(this.singleContext).setDragStartSourceType(event.source);
            log.showInfo(`${event?.touches.length} && ${this.isExclusiveSwiperElementsEvent}`);
            if (event?.touches.length === 1 && this.isExclusiveSwiperElementsEvent) {
              scbEventExclusiveManager.restoreAllEventExclusive(EventType.DESKTOP_ALL_NOTGRIDSWIPER, event.source, event.changedTouches[0].id);
              SCBTransitionManager.getInstance().setIsExclusiveSwiperElementsCancelAnimate(true);
              SCBTransitionManager.getInstance().cancelCloseAppAnimate();
            }
            GridSwiperWallpaperViewModel.getInstance(this.singleContext).updateTouchEventDown(event, this.isEditMode);
          }
          if (event?.type === TouchType.Up || event?.type === TouchType.Cancel) {
            if (DeviceHelper.isPC()) {
              AppStorage.setOrCreate('isInGridSwiperGesture', false);
              this.isDeskSwipe = false;
              scbEventExclusiveManager.setEventExclusive(EventType.DESKTOP_SWIPER, false);
            }
            GridSwiperWallpaperViewModel.getInstance(this.singleContext).updateTouchEventUp(event, this.isEditMode);
          }
        })
        .onChange((index) => {
          AppStorage.setOrCreate('isInGridSwiperGesture', false);
          scbEventExclusiveManager.setEventExclusive(EventType.DESKTOP_SWIPER, false);
          ExposureManager.getInstance().handleDesktopExposureTimeEnd(this.getPageIndex(), index).then(() => {
            ExposureManager.getInstance().handleDesktopExposureTimeStart();
          });
          this.isGestureSwipeHandled = false;
          this.setPageIndex(index);
          this.pageIndexShowed = index;
          this.indicatorController.updateValues(0);
          this.mPageDesktopViewModel?.changeIndexOnly(this.getPageIndex());
          if (AccessibilityManager.getInstance().getIsAccessibilityMode()) {
            this.desktopContext?.eventHub.emit(EventConstants.EVENT_UPDATE_PAGE_FOCUS);
          }
          let disEvent = new DisplayEvent();
          HiSysEventUtil.reportSnapToPage(true, disEvent.isLand() ? 0 : 1, 0, this.getPageIndex(), index);
          if (AccessibilityManager.getInstance().getIsAccessibilityMode() && !this.isFolderChange) {
            // 无障碍模式下，文件夹大小转换跨页找位时不需要播报页数，否则会打断文件夹大小转换的播报
            if (this.pageEditViewModel.isDragingPage()) {
              // 拖拽起始页
              const oldPageIndex: number = this.pages.indexOf(this.editModeDragPageData.startDragPageSwiperKey);
              EditModeAccessibilityUtil.textAnnouncedForDragSqueezePageToSwipe(oldPageIndex, index);
            } else if (this.isEditMode && index >= this.pages.length) {
              // 进入加号页时，不进行翻页播报，仅依赖加号页的聚焦进行播报，以避免重复播报
              log.showInfo('enter addPage');
            } else {
              const displayCnt: number = this.displayCountViewModel.getDisplayCount();
              const realCurrentPageIndex: number = Math.floor(this.getPageIndex() / displayCnt) + 1;
              const realTotalPages: number = Math.ceil(this.pages.length / displayCnt);
              if (this.isJumpToHomePage) {
                this.isJumpToHomePage = false;
              } else {
                DesktopAccessibilityUtils.textAnnouncedForCurrentPage(realCurrentPageIndex, realTotalPages);
              }
            }
          }
          if (DeviceHelper.isThreeFoldProduct()) {
            TripleFoldExpandAnimUtils.updateCurrentMainIndex();
          }
        })
        .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
          this.afterGestureSwipe = true;
          const currentOffset = extraInfo?.currentOffset;
          GridSwiperWallpaperViewModel.getInstance(this.singleContext)
            .sendMoveStart(currentOffset, SCBTransitionManager.getInstance().getLastSwipeOffset(), this.isEditMode);
          AppStorage.setOrCreate('isInGridSwiperGesture', true);
          scbEventExclusiveManager.setEventExclusive(EventType.DESKTOP_SWIPER, true);
          if (FolderManager.getInstance().isFolderClosing()) {
            ContractedFolderCommonViewModel.getInstance()
              .closeFolder('close folder by grid swiper gesture', FolderOperationFlag.BREAK);
          }
          SCBTransitionManager.getInstance().updateCloseAppAnimate(currentOffset);
          let now: number = new Date().getTime();
          if (Math.abs(now - this.lastUpdateTime) > 10) {
            this.indicatorController.updateValues(currentOffset - this.editModeGridSwiperViewData.getPrevNextMargin());
            this.lastUpdateTime = now;
          }
        })
        .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
          if (DeviceHelper.isPC()) {
            return GestureJudgeResult.REJECT;
          }
          GridSwiperWallpaperViewModel.getInstance(this.singleContext).openSendMoveEnable(this.isEditMode);
          sOutSideWindowMgr.setDesktopEnabled(true, TAG);
          if (scbEventExclusiveManager.isExclusive(EventType.DESKTOP_SWIPER)) {
            if (event.fingerList.length === 1) {
              scbEventExclusiveManager.restoreAllEventExclusive(EventType.DESKTOP_SWIPER,
                event.source, event.fingerList[0].id);
            }
            return GestureJudgeResult.REJECT;
          }
          if (this.editModeEditPageData.handleEditPageState !== EditModePageActionEnum.WAITTING_ACTION) {
            log.showInfo('adding or deleting blank page');
            return GestureJudgeResult.REJECT;
          }
          if (gestureInfo.type === GestureControl.GestureType.PAN_GESTURE && this.isFormStackTouch) {
            // 滑动手势触发在堆叠卡片上，则桌面默认不响应此次滑动手势事件
            log.showInfo('sliding on form stack, global search need not response');
            return GestureJudgeResult.REJECT;
          }
          if (gestureInfo.type === GestureControl.GestureType.PAN_GESTURE && OverflowFormUtils.getActiveFormTouch() &&
          OverflowFormUtils.isBehaviorDisabled(DisableGesture.PULL_DOWN_SEARCH,
            AppStorage.get<GridLayoutItemInfo>('activeForm'))) {
            // 滑动手势触发在激活态的游戏卡片上，则桌面默认不响应此次滑动手势事件
            log.showInfo('sliding on active form, global search need not response');
            return GestureJudgeResult.REJECT;
          }
          if (this.editModeDragPageData.dragPageState === EditModePageActionEnum.DRAG_PAGE_MOVING) {
            log.showWarn(`return onGestureJudgeBegin due to DRAG_PAGE_MOVING`);
            return GestureJudgeResult.REJECT;
          }
          let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
          SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'onGestureJudgeBegin', false, expandStatus);
          sOutSideWindowMgr.setIsHidingGlobalSearch(false);
          AppStorage.setOrCreate('isInGlobalSearchAnimate', false);
          if (gestureInfo.type !== GestureControl.GestureType.PAN_GESTURE) {
            this.isDeskSwipe = true;
            this.closeConvertAnimate();
            this.desktopContext?.eventHub.emit(`appIconLongPressEffectCancel`);
            this.desktopContext?.eventHub.emit(`otherIconLongPressEffectCancel`);
            this.desktopContext?.eventHub.emit(`cancelExitNegativeScreenAnimation`);
            dropAnimationManager.cancelDropAnimation(DropAnimationCancelReason.SWIPE_DESKTOP);
            formStackSnapShowManager.cancelSnapViewShow();
          }

          if (gestureInfo.type !== GestureControl.GestureType.PAN_GESTURE && gestureInfo.isSystemGesture) {
            LauncherAnimUtil.setIsUIBusy(TAG, true);
            AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
          }
          log.showWarn(`GestureJudgeResult.CONTINUE`);
          return GestureJudgeResult.CONTINUE;
        })

        if ((DeviceHelper.isPhone() || DeviceHelper.isPad())
          && this.isNewStyle) {
          SwiperIndicator({
            singleContext: this.singleContext,
            controller: this.indicatorController,
          })
            .enabled(this.isDesktopEnabled)
            .margin({
              bottom: this.marginBottomOfIndicator
            })
            .scale({
              x: this.indicatorScale,
              y: this.indicatorScale,
              centerX: '50%',
              centerY: '50%'
            })
            .translate({
              x: this.indicatorTranslateX,
              y: (this.isEditMode ? -20 : this.indicatorTranslateY)
            })
            .opacity(this.indicatorAlpha)
        }
        if (this.isFolderChange) {
          FolderChangeComponent({
            item: this.convertItemInfo,
            mPageDesktopViewModel: this.mPageDesktopViewModel,
            mNameLines: this.mPageDesktopStyleConfig.mNameLines,
            mMaxNameLines: this.mPageDesktopStyleConfig.mMaxNameLines,
            isPad: DeviceHelper.isPad(),
            mPageDesktopStyleConfig: this.mPageDesktopStyleConfig
          }).id(TAG + '_Stack_FolderChangeComponent')
        }
      }
      .gridSwiperStyle()
      .focusBox({strokeWidth: new LengthMetrics(0)})
      // 暂时屏蔽折叠屏展开态场景
      if (this.editModeEditPageData.handleEditPageState !== EditModePageActionEnum.WAITTING_ACTION &&
      launcherStatusUtil.isCurrentDesktopVisible()
      ) {
        EditModeAnimateBlankPage({
          singleContext: this.singleContext,
        })
          .onAppear(() => {
            this.editModeBlankAnimatePageData.showBlankAnimatePage = true;
            if (this.editModeEditPageData.handleEditPageState === EditModePageActionEnum.ADDING_BLANK_PAGE) {
              log.showInfo(`EditModeAnimateBlankPage addBlankPageCurrentPageAnimate`);
              this.pageEditViewModel.addBlankPageCurrentPageAnimate();
              return;
            }
            if (this.editModeEditPageData.handleEditPageState === EditModePageActionEnum.DELETEING_BLANK_PAGE) {
              PageDragManager.getInstance().getDraggingPage().forEach((index: number) => {
                DragEventManager.getInstance()
                  .dragStartInDesktop(PageDragManager.getInstance().getPageUniqueKey(index));
              });
              log.showInfo(`EditModeAnimateBlankPage deleteBlankPageCurrentPageAnimate`);
              this.pageEditViewModel.deleteBlankPageCurrentPageAnimate(false);
              return;
            }
          })
          .onDisAppear(() => {
            this.editModeBlankAnimatePageData.showBlankAnimatePage = false;
            log.showInfo('EditModeAnimateBlankPage aboutToDisappear');
          })
          .opacity(this.editModeBlankAnimatePageData.blankAnimatePageOpacity)
          .scale({
            x: this.editModeBlankAnimatePageData.blankAnimatePageScale,
            y: this.editModeBlankAnimatePageData.blankAnimatePageScale
          })
          .position({
            x: 0,
            y: 0
          })
          .hitTestBehavior(HitTestMode.Transparent)
      }
    }
  }

  private isSupportGlobalSearch(): boolean {
    if (OutdoorConfig.getInstance().isInOutdoorMode()) {
      log.showInfo('unSupportGlobalSearch due to OutdoorMode');
      return false;
    }
    return true;
  }

  private needResetFocusWhenTouchDown(): boolean {
    if (!DeviceHelper.isPC()) {
      return false;
    }
    return !AppStorage.get<boolean>('isShiftKeyDown') &&
      !AppStorage.get<boolean>('isCtrlKeyDown') &&
      !(this.isSuperFold && AppStorage.get<boolean>('isRectSelecting'));
  }

  private isGlobalSearchKeyEnabled(): boolean {
    // 锁屏，双中心
    let isKeyGuard: Boolean = ViewManagerPolicy.isViewShowing(ViewType.KEYGUARD);
    let isStatusBarVisible: Boolean = ViewManagerPolicy.isViewShowing(ViewType.DROPDOWN);
    log.showInfo(`isStatusBarVisible :${isStatusBarVisible}. isKeyGuard:${isKeyGuard}`);
    if (isKeyGuard || isStatusBarVisible) {
      return false;
    }

    // 长按应用图标,大小文件夹，打开快捷菜单
    let existFloatingWindow: Boolean =
      SCBSceneSessionManager.getInstance().isDesktopNeedProcessFloatWindow(this.screenId);
    let isIconTouch = AppStorage.get<boolean>('isIconTouch') as boolean;

    // 进入大小文件夹
    let openFolderStatus: number = AppStorage.get<number>('openFolderStatus') as number;
    log.showInfo(`openFolderStatus :${openFolderStatus}. existFloatingWindow:${existFloatingWindow}`);
    if (openFolderStatus !== CommonConstants.OPEN_FOLDER_STATUS_CLOSE || existFloatingWindow || isIconTouch) {
      return false;
    }

    // 卡片管理半模态, 卡片堆叠展开
    let formManageShow: boolean = AppStorage.get<boolean>('formManageShow') as boolean;
    let formStackOpen: boolean = AppStorage.get<boolean>('formStackEditShow') as boolean;
    let isFormManagerViewShowing: boolean = FormCenterViewManager.getInstance().isFormManagerViewShowing();
    let isFormCenterViewShowing: boolean = FormCenterViewManager.getInstance().isFormCenterViewShowing();
    log.showInfo(`formManageShow :${formManageShow}.formStackOpen :${formStackOpen}.isFormManagerViewShowing :${isFormManagerViewShowing}.isFormCenterViewShowing :${isFormCenterViewShowing}.`);
    if (formManageShow || formStackOpen || isFormManagerViewShowing || isFormCenterViewShowing) {
      return false;
    }

    // 长按编辑模式
    let isInEditMode: boolean = editModeManager.isInEditMode();
    this.hiSearchStatus = this.preferenceStore?.getHiSearchStatus();
    log.showInfo(`isInEditMode :${isInEditMode}. hiSearchStatus:${this.hiSearchStatus}`);
    if (isInEditMode || !this.hiSearchStatus) {
      return false;
    }
    // 多任务列表
    let scenePanelState: Boolean =
      SCBSceneSessionManager.getInstance().isScenePanelInState(this.screenId, ScenePanelState.RECENT);
    log.showInfo(`current scene panel state is ${scenePanelState}`);
    if (scenePanelState) {
      return false;
    }

    // 应用图标拖拽、桌面滑动、双中心下滑
    let isDrag = AppStorage.get<boolean>('isDrag') as boolean;
    let isInGridSwiperGesture = AppStorage.get<boolean>('isInGridSwiperGesture') as boolean;
    let isInStatusBarGesture = AppStorage.get<boolean>('isInStatusBarGesture') as boolean;
    let isSwipeToNegativePage = SwiperGestureHandler.getInstance().isBeginSwipeToNegativePage();
    let isNegativeScrollGesture = AppStorage.get<boolean>('isNegativeScrollGesture') as boolean;
    log.showInfo(`isInGridSwiperGesture :${isInGridSwiperGesture}. isDrag:${isDrag}. ` +
      `isInStatusBarGesture:${isInStatusBarGesture},  swipeToNegativePage:${isSwipeToNegativePage},` +
      `isNegativeScrollGesture:${isNegativeScrollGesture}`);
    if (isInGridSwiperGesture || isDrag || isInStatusBarGesture ||
      isSwipeToNegativePage || isNegativeScrollGesture) {
      return false;
    }

    if (sOutSideWindowMgr.isShowGlobalSearch()) {
      log.showInfo('gs global search has shown already. exit.');
      return false;
    }

    return true;
  }

  private handSearchKeyEvent(): void {
    log.showInfo('handSearchKeyEvent');
    if (!this.isGlobalSearchKeyEnabled()) {
      log.showInfo('handSearchKeyEvent end by isGlobalSearchKeyEnabled');
      return;
    }

    window.getVisibleWindowInfo().then((data) => {
      let isMultiWindowMode: boolean = SCBSceneSessionManager.getInstance().isPcMode();
      let isNoWindow = CheckEmptyUtils.isEmptyArr(data?.filter(item => item));
      log.showInfo(`handSearchKeyEvent visibleWindows: ${isNoWindow}, ismultiWindowMode: ${isMultiWindowMode}`);
      if (isNoWindow || isMultiWindowMode) {
        // 开启自由多窗或者无可见窗口时,打开全搜
        let isChangingPage = this.mPageDesktopViewModel?.getIsChangingPage() as boolean;
        SwiperGestureHandler.getInstance().globalSearchKeyAction(isChangingPage);
      } else if (!isNoWindow) {
        log.showInfo(`handSearchKeyEvent end by visibleWindows: ${isNoWindow}`);
        data?.forEach(windowInfo => {
          log.showWarn(`handSearchKeyEvent visibleWindow: bundleName:${windowInfo.bundleName
          }|windowId:${windowInfo.windowId}|abilityName:${windowInfo.abilityName}|isFocused:${windowInfo.isFocused
          }|windowStatusType:${windowInfo.windowStatusType}`);
        })
      } else {
        log.showWarn(`handSearchKeyEvent visibleWindows&&ismultiWindowMode: ${isNoWindow}&&${isMultiWindowMode}`);
      }
    }).catch((err: BusinessError) => {
      log.showError(`handSearchKeyEvent error: ${err.code}, ${err.message} `);
    });
  }

  /**
   * 动画结束回调是动画停止时页面相对布局起点的偏移，一般正常归位结束的动画回调extraInfo.currentOffset是0，
   * 被打断的话就回调被打断时节点的位置
   * 三折屏在双屏或三屏场景，旋转屏幕立马翻页，extraInfo.currentOffset有值，是因为旋转的时候会有翻页
   * 这个时候立马翻页，extraInfo.currentOffset会有值，导致导航点会有偏移
   * 本处暂时对三折屏做隔离，不设置偏移
   */
  private onAnimationEndNotShowFirstPageFlag(extraInfo: SwiperAnimationEvent): void {
    if (!this.isEditMode && PageInfoManager.getInstance().getMaxDisplayCount() === StyleConstants.DEFAULT_3 &&
      this.displayCountViewModel.getDisplayCount() !== 1) {
      this.indicatorController.updateValues(0);
    } else {
      this.indicatorController.updateValues(extraInfo?.currentOffset -
      this.editModeGridSwiperViewData.getPrevNextMargin());
    }
  }

  private dealDropEvent(event?: DragEvent, extraParams?: string): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible()) {
      return;
    }
    if (event) {
      event.useCustomDropAnimation = true;
    }
    if (!AppStorage.get<boolean>('isDrag')) {
      log.showInfo('not dragging desktop component');
      event?.setResult(DragResult.DRAG_FAILED);
      return;
    }
    const rect: Rectangle | undefined = event?.getPreviewRect();
    log.showWarn('onDrop event position is [%{public}d, %{public}d], preview rect is [x=%{public}d, y=%{public}d, ' +
      'width=%{public}d, height=%{public}d]', event?.getWindowX(), event?.getWindowY(), rect?.x, rect?.y, rect?.width,
      rect?.height);
    if (this.pageEditViewModel.isDragingPage()) {
      if (event) {
        this.mPageDesktopDragHandler.clearSwipeTimeout();
        this.pageEditViewModel.dropPageAnimate(event, false);
      }
      return;
    }
    const dragItemType: number = AppStorage.get('dragItemType') as number;
    // 编辑模式下，如果从文件夹拖出图标至文件夹宫格外，文件夹还没关闭就松手，图标落回原位而不是落到桌面
    if (dragItemType === CommonConstants.DRAG_FROM_FOLDER && FolderManager.getInstance().isFolderOpen()) {
      log.showWarn(`Folder is not closed, can't drop to desktop`);
      return;
    }
    // 如果从文件夹拖出，直接找位
    if (dragItemType === CommonConstants.DRAG_FROM_FOLDER ||
      dragItemType === CommonConstants.DRAG_FROM_FOLDER_IN_DOCK) {
      ContractedFolderCommonViewModel.getInstance().waitFolderAnimateFinish(() => {
        log.showInfo('onDrop dragFromFolder add to desktop dragOutFolderPending');
        if (event && extraParams) {
          this.onDragDrop(event, extraParams);
        }
      });
      return;
    }
    if (event) {
      this.onDragDrop(event);
    }
  }

  private dealDragEnterEvent(event?: DragEvent, extraParams?: string): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible()) {
      return;
    }
    log.showWarn('onDragEnter event: [%{public}d, %{public}d]', event?.getWindowX(), event?.getWindowY());
    if (event && !DeviceHelper.isPC()) {
      this.mPageDesktopDragHandler.onDragEnter(event.getWindowX(), event.getWindowY());
    }
    dropAnimationManager.prepareDropItem(DropAnimationDestination.DESKTOP);
  }

  private dealDragMoveEvent(event: DragEvent, extraParams?: string): void {
    if (formZoomController.isMenuPreviewDragging(extraParams)) {
      const dragStartPos: Position | undefined = formZoomController.getDragStartPos();
      if (!dragStartPos) {
        formZoomController.setDragStartPos({ x: event.getWindowX(), y: event.getWindowY() });
        return;
      }
      const offsetX: number = event.getWindowX() - (dragStartPos.x as number);
      const offsetY: number = event.getWindowY() - (dragStartPos.y as number);
      log.showInfo(`formZoom menuPreviewDragging info: ${this.pageIndex} ${offsetX} ${offsetY}`);
      const params: FormZoomDragEvtParams = {
        type: FormZoomDragEvtType.DRAG_MOVE,
        offsetX,
        offsetY,
      };
      formZoomController.handleDragFormZoom(params);
      return;
    }
    if (!launcherStatusUtil.isCurrentDesktopVisible()) {
      return;
    }
    if (this.editModeDragPageData.dragPageState === EditModePageActionEnum.DRAG_PAGE_MOVING) {
      log.showWarn(`return dealDragMoveEvent due to DRAG_PAGE_MOVING`);
      return;
    }
    const isDrag: boolean = AppStorage.get('isDrag') as boolean;
    if (!isDrag) {
      log.showInfo('dealDragMoveEvent isDrag: %{public}s', isDrag);
      return;
    }
    log.showDebug('onDragMove event: [%{public}d, %{public}d]', event.getWindowX(), event.getWindowY());
    if ((this.isPhone || this.isPC) && event) {
      this.itemMove(event.getWindowX(), event.getWindowY());
      let rectangle = event.getPreviewRect();
      let x: number = 0;
      let y: number = 0;
      if (this.isSuperFold && this.mPageDesktopDragHandler.isDragLeaveSwiperPage()) {
        x = event.getWindowX() ?? 0;
        y = event.getWindowY() ?? 0;
      } else {
        x = Number(rectangle.x) + Number(rectangle.width) / 2;
        y = Number(rectangle.y) + Number(rectangle.height) / 2;
      }
      this.mPageDesktopDragHandler.onDragMove(x, y);
      if (DragAccessibilityUtils.isAccessibilityMode()) {
        this.mPageDesktopDragHandler.textAnnouncedForNearScreen(event);
      }
    }
  }

  private getNeighborPage(page: number): number {
    if (page % StyleConstants.DEFAULT_2 === 0) {
      return page + StyleConstants.DEFAULT_1;
    } else {
      return page - StyleConstants.DEFAULT_1;
    }
  }

  private handOffIndicatorAnimation(extraInfo: SwiperAnimationEvent, pageChange: boolean) {
    animateTo({
      duration: 250,
      curve: Curve.Linear,
      onFinish: () => {
      }
    }, () => {
      if (pageChange) {
        if (extraInfo?.currentOffset - extraInfo?.targetOffset > 0) {
          this.indicatorController.updateValues(extraInfo?.currentOffset - extraInfo?.targetOffset + 2 *
          this.editModeGridSwiperViewData.getPrevNextMargin());
        } else {
          this.indicatorController.updateValues(extraInfo?.currentOffset - extraInfo?.targetOffset - 2 *
          this.editModeGridSwiperViewData.getPrevNextMargin());
        }
      } else {
        this.indicatorController.updateValues(extraInfo?.currentOffset - extraInfo?.targetOffset);
      }
    })
  }

  itemMove(moveX: number, moveY: number): void {
    if (this.mIsFormStackExpand) {
      log.showInfo(`itemMove return, fsExpandShow: ${this.mIsFormStackExpand}`);
      return;
    }
    let curPageIndex: number = PageDesktopDragHandler.getInstance(this.singleContext).getCurrentPageIndex();
    const dragItemInfo = PageDesktopDragHandler.getInstance(this.singleContext).getSingleDragItemInfo();
    if (!dragItemInfo) {
      return;
    }
    const dragItemType: number = AppStorage.get('dragItemType') as number;
    // 编辑模式下，可拖出预置布局页图标进入宫格范围，该场景不能触发翻页
    if (dragItemType === CommonConstants.DRAG_FROM_FOLDER && FolderManager.getInstance().isFolderOpen()) {
      const openFolder: GridLayoutItemInfo = FolderManager.getInstance().getOpenedFolder();
      const curPage: number = openFolder.page ?? CommonConstants.INVALID_VALUE;
      if (layoutLockUtil.isLockedPage(curPage, 'itemMove on GridSwiper')) {
        return;
      }
      if (!DeliverUtil.canFolderItemDragOut(openFolder.folderId, dragItemInfo.bundleName)) {
        return;
      }
    }

    let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance(this.singleContext);
    let margin: number = this.mPageDesktopStyleConfig.mMargin as number;
    let gridSpaceWidth: number = Number(pageDesktopViewModel.getWorkSpaceWidth()) - margin;
    let iconSize: number = this.mPageDesktopStyleConfig.mIconSize as number;
    let gridSpaceHeight: number = pageDesktopViewModel.getWorkSpaceHeight() as number;
    let dragItemInfoPage = dragItemInfo.page ?? 0;
    if (SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()) {
      gridSpaceWidth = gridSpaceWidth - FOLD_EXPAND_MARGIN;
      margin = margin + FOLD_EXPAND_MARGIN;

      // 获取折叠屏展开态下右半屏的页数
      dragItemInfoPage = 2 * Math.floor(dragItemInfoPage / 2) + 1;
    }

    if (moveY >= gridSpaceHeight) {
      this.mPageDesktopDragHandler.clearSwipeTimeout();
      return;
    }
    const isMovingLeft: boolean = (moveX - iconSize / OUT_OF_SCREEN_RATIO) < margin;
    const isMovingRight: boolean = (moveX + iconSize / OUT_OF_SCREEN_RATIO) > gridSpaceWidth;
    const isMovingNext: boolean = RTLUtil.isRTL() ? isMovingLeft : isMovingRight;
    const isMovingPrevious: boolean = RTLUtil.isRTL() ? isMovingRight : isMovingLeft;
    if (isMovingPrevious && curPageIndex > 0) {
      const callback = () => {
        // 拖拽页面时阻挡冗余的翻页触发
        if (this.editModeDragPageData.dragPageState !== EditModePageActionEnum.DRAG_PAGE_MOVING) {
          pageDesktopViewModel.showPrevious();
        }
      };
      this.mPageDesktopDragHandler.setSwipeTimeout(callback);
    } else if (isMovingNext) {
      const callback = () => {
        // 拖拽页面时阻挡冗余的翻页触发
        if (this.editModeDragPageData.dragPageState !== EditModePageActionEnum.DRAG_PAGE_MOVING) {
          this.dealMoveNextPage(curPageIndex, dragItemInfoPage, dragItemType, pageDesktopViewModel);
        }
      };
      this.mPageDesktopDragHandler.setSwipeTimeout(callback);
    } else {
      this.dealDragToIntelligent(dragItemInfo, isMovingPrevious, curPageIndex, moveY);
    }
  }

  private dealDragToIntelligent(dragItemInfo: GridLayoutItemInfo, isMovingPrevious: boolean,
    curPageIndex: number, moveY: number): void {
    if (dragItemInfo.typeId === CommonConstants.TYPE_CARD && isMovingPrevious && curPageIndex === 0) {
      const callback = (): void => {
        this.dealMoveCard(dragItemInfo, curPageIndex, moveY);
      };
      this.mPageDesktopDragHandler.setSwipeTimeout(callback);
    } else {
      this.mPageDesktopDragHandler.clearSwipeTimeout();
    }
  }

  private dealMoveNextPage(curPageIndex: number, dragItemInfoPage: number, dragItemType: number,
                           pageDesktopViewModel: PageDesktopViewModel): void {
    let cachePageIndex: number = pageDesktopViewModel.getGridPageCount();
    log.showInfo(`cachePageIndex ${cachePageIndex}, curPageIndex ${curPageIndex}`);
    if ((curPageIndex >= cachePageIndex - this.displayCountData.getDisplayCount())) {
      // 有加号页时可以向右拖拽到加号页上
      if (curPageIndex < cachePageIndex &&
        curPageIndex >= cachePageIndex - this.displayCountData.getDisplayCount() &&
        this.editModeEditPageData.canAddPageShow) {
        pageDesktopViewModel.showNext();
        return;
      }
      if (pageDesktopViewModel.isBlankPage(curPageIndex)) {
        return;
      }
      if (dragItemInfoPage === curPageIndex && (dragItemType === CommonConstants.DRAG_FROM_DESKTOP ||
        dragItemType === CommonConstants.DRAG_FROM_APP_ICON) && pageDesktopViewModel.isSingleItemPage(curPageIndex)) {
        log.showInfo('itemMove isSingleItemPage return, curPageIndex: %{public}d, dragItemInfoPage: %{public}d, dragItemType: %{public}d',
          curPageIndex, dragItemInfoPage, dragItemType);
        return;
      }
      // 非编辑模式可以向右正常加页
      if (!editModeManager.isInEditMode()) {
        pageDesktopViewModel.addBlankPage(true);
        setTimeout(() => {
          const addPageSet: Set<number> = new Set();
          addPageSet.add(curPageIndex + this.displayCountData.getDisplayCount());
          Cache2RdbHelper.getInstance().setChangedPage(CommonConstants.DRAG_RDB_EVENT, addPageSet);
          pageDesktopViewModel.showNext();
        }, SINGLE_PAGE_PRELOAD_TIME_INTERVAL);
        log.showInfo('add blank page, current page: %{public}d pageCount: %{public}d', curPageIndex, cachePageIndex);
      }
    } else if (curPageIndex < cachePageIndex - this.displayCountData.getDisplayCount()) {
      log.showInfo(`dealMoveNextPage normal showNext`);
      pageDesktopViewModel.showNext();
    } else {
      log.showInfo('itemMove not showNext, curPageIndex: %{public}d, dragItemInfoPage: %{public}d cachePageIndex: %{public}d, isBlankPage: %{public}s',
        curPageIndex, dragItemInfoPage, cachePageIndex, pageDesktopViewModel.isBlankPage(curPageIndex));
    }
  }

  private dealMoveCard(dragItemInfo: GridLayoutItemInfo, curPageIndex: number, moveY: number): void {
    if (editModeManager.isInEditMode()) {
      log.showInfo('itemMove isInEditMode');
      return;
    }
    if (LayoutViewModel.getInstance().isSimpleLauncherMode()) {
      log.showInfo('isSimpleLauncherMode');
      return;
    }
    if (!FormCenterViewModel.getInstance().getNegativeAddCardStatus()) {
      // 桌面支持卡片可以往负一屏拖拽卡片
      log.showInfo('intelligent not support add card');
      return;
    }
    log.showInfo('showNegativePage.curPageIndex=%{public}d', curPageIndex);
    if (!sOutSideWindowMgr.getNegativeAnimateEnd()) {
      return;
    }
    let screenWidth = AppStorage.get('screenWidth') as number;
    sOutSideWindowMgr.setNegativeOffset(LanguageUtils.isMirrorLanguage() ? screenWidth : -screenWidth);
    sOutSideWindowMgr.setNegativeDesktopProgress(0);
    sOutSideWindowMgr.setNegativeScreenVisible(true);
    SwiperGestureHandler.getInstance().intoNegativeAnimation();
    PageDesktopDragHandler.getInstance(this.singleContext).notifyIntelligentDragEnter();
    this.mPageDesktopDragHandler.onDragLeave(0, 0);
  }

  /**
   * 堆叠内卡片落位异常时放回堆叠
   */
  private dragFormStackBack(): void {
    const dragItemType: number = AppStorage.get<number>('dragItemType') as number;
    const createFormId: string = AppStorage.get<string>('createFormId') as string;
    const isFormStackClosed: boolean = AppStorage.get<boolean>('dragCardOfFormstackClosed') as boolean;
    if (dragItemType === CommonConstants.DRAG_FROM_FORM_STACK && CheckEmptyUtils.checkStrIsEmpty(createFormId) &&
      isFormStackClosed) {
      // 从堆叠中拖出落位加桌失败，回退到原堆叠
      log.showWarn('drag card to desktop fail from formstack, put it back!');
      this.mFormStackViewModel.dragCardBackToFormStack();
    }
  }

  private getCachedCount(): number {
    let cacheCount = 0;
    let userId: number = AppModel.getInstance().getUserId();

    // 主用户才需要swiper预加载
    if (userId === ADMIN_USERID) {
      if (this.updateCachedCountFlag) {
        cacheCount = 2;
      } else {
        cacheCount = 1;
      }
    }

    if (PageInfoManager.getInstance().getMaxDisplayCount() === StyleConstants.DEFAULT_3 &&
      cacheCount < this.displayCountData.getCacheCount()) {
      cacheCount = this.displayCountData.getCacheCount();
    }
    log.showInfo(`cachedCount userId: ${userId}, cacheCount: ${cacheCount}`);
    return cacheCount;
  }

  /** gridSwiper 是否启用内存优化 */
  @State enabledOptimize: boolean = false;

  private memoryOptimizerListener: GridlayoutMemoryListener = {
    onOptimize: (): void => {
      log.showWarn('MemoryOptimizer onOptimize');
      this.enabledOptimize = true;
      AdaptiveIconManager.getInstance().clearIconResources('GridSwiper optimize');
    },
    onRecover: (): void => {
      log.showWarn('MemoryOptimizer onRecover');
      this.enabledOptimize = false;
    }
  }

  private registerMemoryOptimizer(): void {
    if (!DeviceHelper.isPhone() || DeviceHelper.isFold()) {
      return;
    }
    MemoryManager.getInstance().gridLayoutOptimizer.register('gridSwiper', this.memoryOptimizerListener);
  }

  private unregisterMemoryOptimizer(): void {
    MemoryManager.getInstance().gridLayoutOptimizer.unregister(`gridSwiper`);
  }

  private hiddenForOptimize(pageIndex: number) {
    return this.enabledOptimize && (pageIndex !== this.pageIndex);
  }
}

export class TranslatePosition {
  public x: number = 0;
  public y: number = 0;
}
