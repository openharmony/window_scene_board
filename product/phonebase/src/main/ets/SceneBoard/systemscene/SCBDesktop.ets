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

import display from '@ohos.display';
import { AppItemToDeskAnimationComponent } from '@ohos/desktopedit/src/main/ets/default/view/AppItemToDeskAnimationComponent';
import dataStorage from '@ohos.data.storage';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import {
  AdaptiveIconManager,
  BaseConfig,
  BigFolderStyleConfig,
  CommonConstants,
  ContractedFolderCommonViewModel,
  ContractedFolderLayoutViewModel,
  desktopFontScaleManager,
  DesktopManager,
  DesktopMode,
  DesktopParam,
  DesktopStatusBarHelper,
  DeviceState,
  editModeManager,
  EditModeState,
  EditModeUtils,
  EditModeViewData,
  EventConstants,
  FolderActionLifeCycleEvent,
  FolderActionLifeCycleEventManager,
  FolderConstants,
  FolderDataModelManager,
  folderGesData,
  folderLayoutUtil,
  FolderLifeCyclePriority,
  FolderManager,
  FolderModel,
  FolderOperationFlag,
  FolderStyleManager,
  FormCenterViewManager,
  GridLayoutItemInfo,
  HiEditModeDataExitType,
  LayoutViewModel,
  MultiSelectManager,
  OpenFolderStyleConfig,
  PageDesktopModel,
  PageInfoManager,
  ReceiveEventInfo,
  SCBHiSysEventUtil,
  ShowNameState,
  SmallFolderConstants,
  SmallFolderStyleConfig,
  ThemeStyleCallback,
  ThemeStyleManager,
  ThemeStylePreviewManager,
  UninstallDialogStatus,
  ViewManager,
  WeeklyReporter
} from '@ohos/launchercommon';
import {
  DesktopSettingsPerefrence,
  DesktopSettingUtils,
  DisplayCountViewModel,
  FormBuildItem,
  formStackItemViewManager,
  FormStackItemViewType,
  launcherVisualEffectMgr,
  MultiSelectAnimationView,
  PageDesktopOneShotManager,
  PageEditViewModel
} from '@ohos/launchercommon/Index';
import {
  EventType,
  launcherStatusUtil,
  ResUtils,
  SCBDesktopEventId,
  scbEventExclusiveManager,
  SCBEventId,
  SCBPropertyChangeReason,
  SCBScenePanelManager,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBTransitionManager,
  SCBSystemSceneSession
} from '@ohos/windowscene';
import {
  BreakpointManager,
  bundleManagerFwk,
  ConfigurationEvent,
  DeviceHelper,
  DockAvgColorChangeEvent,
  EventManager,
  EvtBus,
  GlobalContext,
  GlobalSearchStatus,
  HiSysEventUtil,
  IconResourceManager,
  LightOutdoorConfig,
  localEventManager,
  NegativeScreenConstants,
  obtainLocalEvent,
  onLineThemeUtil,
  ResourceManager,
  SCBDesktopCacheManager,
  SCBWallPaperChangeEvent,
  ScreenOrientation,
  ScreenState,
  ScreenStateModel,
  ScreenStateMonitor,
  sEventManager,
  EventConstants as CommonEventConstants,
  sOutSideWindowMgr,
  sSettingsUtil,
  TrimLevel,
  ViewArea,
  ViewCallback,
  ViewController,
  viewMgrPolicy,
  ViewType,
  WallpaperChangeListener,
  WallpaperColorManager,
  WallpaperManager,
  WallpaperType,
  WeekSchedulerReporterEvent,
  WorkSchedulerManager
} from '@ohos/frameworkwrapper';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  AnimateToScheduleUtils,
  AppStorageUtil,
  CheckEmptyUtils,
  CommonUtils,
  CompanionIconInfo,
  DomainName,
  LogDomain,
  LogHelper,
  SingleContext,
  singleManager,
  Trace,
  TraceUtil,
  UIContextHelper,
} from '@ohos/basicutils';
import { BaseViewController, MemoryManager } from '@ohos/frameworkcommon';
import { CoreEventType, SceneBoardStateManager } from '@ohos/frameworkwrapper/Index';
import { SCBConstants, VisualEffectConstants, WallpaperConstants } from '@ohos/commonconstants';
import { desktopUtil, RTLUtil, StateEx } from '@ohos/componenthelper';
import { SmartDock } from '@ohos/smartdock/src/main/ets/default/layout/SmartDock';
import { PageDesktopLayout } from '@ohos/pagedesktop/src/main/ets/default/layout/PageDesktopLayout';
import UndoDragForm from '@ohos/pagedesktop/src/main/ets/default/common/components/UndoDragForm';
import { OpenFolderComponent } from '@ohos/bigfolder/src/main/ets/default/view/OpenFolderComponent';
import { FormZoomComponent } from '@ohos/pagedesktop/src/main/ets/default/common/components/formAdjust/view/FormZoomComponent';
import curves from '@ohos.curves';
import { BigFolderViewModel, FolderCloseType, OpenFolderAppBubbleNodeManager } from '@ohos/bigfolder';
import { ScenePanelState } from '../scenemanager/SCBScenePanel';
import { PhoneLayoutRulesController } from '../controllers/SceneDesktopController/PhoneLayoutRulesController';
import { SimplePhoneLayoutRulesController } from '../controllers/SceneDesktopController/SimplePhoneLayoutRulesController';
import { FormStyleConfig } from '@ohos/form';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import PhonePageDesktopGridStyleConfig from '../../common/PhonePageDesktopGridStyleConfig';
import { SmartDockStyleConfig } from '@ohos/smartdock/src/main/ets/default/common/SmartDockStyleConfig';
import { FoldPhoneLayoutRulesController } from '../controllers/SceneDesktopController/FoldPhoneLayoutRulesController';
import type ctx from '@ohos.app.ability.common';
import { editModeViewManager } from '@ohos/desktopedit/src/main/ets/default/manager/EditModeViewManager';
import { EditModeViewEvent, PinchGestureActionType } from '@ohos/desktopedit/src/main/ets/default/viewmodel/EditModeViewEvent';
import { FormStackExpandView } from '@ohos/formstack/src/main/ets/view/FormStackExpandView';
import { FormStackSnapView } from '@ohos/formstack/src/main/ets/view/FormStackSnapView';
import { FormStackEventReporter } from '@ohos/formstack/src/main/ets/common/FormStackEventReporter';
import { FormHiSysEventUtil } from '@ohos/form/src/main/ets/default/util/FormHiSysEventUtil';
import { StatusBarSysEventUtil, } from '@ohos/systemuicommon/src/main/ets/statusbar/StatusBarSysEventUtil';
import { baseStateMgr } from '@ohos/systemuicommon';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { PadLayoutRulesController } from '../controllers/SceneDesktopController/PadLayoutRulesController';
import { HorizontalFoldPhoneLayoutRulesController } from '../controllers/SceneDesktopController/HorizontalFoldPhoneLayoutRulesController';
import parameter from '@ohos.systemparameter';
import { DesktopInformationReporter } from '../desktopReporter/DesktopInformationReporter';
import ReportWorkSchedulerExtensionAbility from '../desktopReporter/ReportWorkSchedulerExtensionAbility';
import { EditModeButtonDock, EditModeRemoveBar } from '@ohos/desktopedit';
import EditModeExtensionUI from '@ohos/desktopedit/src/main/ets/uiExtension/view/EditModeExtensionUI';
import EditModeStyleConstants from '@ohos/desktopedit/src/main/ets/default/common/constants/EditModeStyleConstants';
import { PageDesktopDragHandler, PageDesktopGridStyleConfig, PageDesktopViewModel, SCBDesktopAddViewModel, SwiperPageFocusManager } from '@ohos/pagedesktop';
import { VerticalPadLayoutRulesController } from '../controllers/SceneDesktopController/VerticalPadLayoutRulesController';
import { AnimationContinueItem, DropAnimationItem } from '@ohos/componentanimator/Index';
import { ThemeActivationEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import GlobalSearchLocationApp from '@ohos/pagedesktop/src/main/ets/default/common/components/GlobalSearchLocationApp';
import lazy { multiInputManager, MultiInputViewModel } from '@ohos/multiinput';
import { text } from '@kit.ArkGraphics2D';
import SmartDockConstants from '@ohos/smartdock/src/main/ets/default/common/constants/SmartDockConstants';
import lazy StatusBarServiceEventMgr from '@ohos/smartdock/src/main/ets/default/manager/StatusBarServiceEventMgr';
import { AttributeUpdater } from '@ohos.arkui.modifier';
import lazy { OuterPhoneLayoutRulesController } from '../controllers/SceneDesktopController/OuterPhoneLayoutRulesController';
import { folderLayout } from '@ohos/pagedesktop/src/main/ets/default/common/components/folder/viewmodel/FolderLayout';
import { EditModeSingePageViewData } from '@ohos/desktopedit/src/main/ets/default/data/EditModeSingePageViewData';
import IndicatorConstants from '@ohos/pagedesktop/src/main/ets/default/common/constants/IndicatorConstants';
import { EditModeGridSwiperViewData } from '@ohos/desktopedit/src/main/ets/default/data/EditModeGridSwiperViewData';
import { DesktopLayoutState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { SCBUnlockSpaceAniListener, SCBUnlockTransitionController } from '@ohos/windowscene/src/main/ets/animation/SCBTransitionManager';
import { SCBDesktopViewModel } from './viewmodel/SCBDesktopViewModel';
import lazy { CloudChangeStatus, CloudExpandDialogMgr } from '../cloudmode/CloudExpandDialogMgr';
import lazy { ThreeFoldRotateViewModel } from './threefold/ThreeFoldRotateViewModel';
import { BaseQuitAppRect, QuitAppRectViewModel } from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/QuitAppRectViewModel';
// import apsManager from '@ohos.graphic.apsManager';
import lazy { OuterIconCenterViewManager } from '@ohos/launchercommon/src/main/ets/manager/OuterIconCenterViewManager';
import { ThemeServiceHelper } from '@ohos/wallpapercomponent/src/main/ets/themeassistant/ThemeServiceHelper';
import { SpaceAnimationUtils } from '@ohos/launchercommon/src/main/ets/animation/SpaceAnimationUtils';
import { ScreenLockState, ScreenLockStateListener, screenLockStateManager } from '@ohos/screenlockcommon';
import { GameEventListener } from '@ohos/launchercommon/src/main/ets/listener/GameEventListener';
import { BlurEffectType } from '@ohos/commonconstants/src/main/ets/constants/VisualEffectConstants';
import { ThreeFoldPhoneLayoutRulesController, } from '../controllers/SceneDesktopController/ThreeFoldPhoneLayoutRulesController';
import { HorizontalThreeFoldPhoneLayoutRulesController } from '../controllers/SceneDesktopController/HorizontalThreeFoldPhoneLayoutRulesController';
import lazy {
  SCBSingleHandController,
  SingleHandAnimationFinishCallBack,
  SingleHandMode,
  SingleHandStatusChangeCallback
} from '../scenemanager/onehandmode/SCBSingleHandController';
import { AppIconConfigManager } from '@ohos/launchercommon/src/main/ets/manager/AppIconConfigManager';
import { EditModeGuidePage } from '@ohos/pagedesktop/src/main/ets/default/common/components/EditModeGuidePage';
import { editModeGuideManager } from '@ohos/pagedesktop/src/main/ets/default/common/EditModeGuideManager';
import { ThemeActivationTarget } from '@ohos/themeservicekit';
import lazy { RecentDockAnimationEvent } from '@ohos/launchercommon/src/main/ets/events/RecentDockEvents';
import { ContinueItemAnimationEvent } from '@ohos/launchercommon/src/main/ets/events/ContinueItemAnimationEvent';
import { DeviceTypeIconAnimationEvent } from '@ohos/launchercommon/src/main/ets/events/DeviceTypeIconAnimationEvent';
import { SCBDesktopViewData } from './viewmodel/SCBDesktopViewData';
import { AppInstallRegister } from '@ohos/appinstall';
import { PhoneFolderViewModelLoader } from '../folder/viewmodel/PhoneFolderViewModelLoader';
import { PhoneFolderConfig } from '../folder/config/PhoneFolderConfig';
import { openCloseAniMgr } from '@ohos/bigfolder/src/main/ets/default/viewmodel/openclose/OpenCloseActionManager';
import { OpenFolderGridSwiperLayout } from '@ohos/bigfolder/src/main/ets/default/viewmodel/OpenFolderGridSwiperLayout';
import { openFolderLayout } from '@ohos/bigfolder/src/main/ets/default/viewmodel/OpenFolderLayout';
import { ExposureManager } from '@ohos/launchercommon/src/main/ets/manager/ExposureManager';
import { DailyScheduledReporter } from '@ohos/launchercommon/src/main/ets/hisysevent/DailyScheduledReporter';
import lazy { SCBSceneWindowAiSplitSwitchUtils } from '@ohos/windowscene/src/main/ets/scene/utils/SCBSceneWindowAiSplitSwitchUtils';
import lazy { ThreeFoldExpandViewModel } from './threefold/ThreeFoldExpandViewModel';
import lazy { ThreeFoldUtils } from './threefold/ThreeFoldUtils';
import lazy { ShieldAnimParam, ShieldAnimViewModel } from './viewmodel/ShieldAnimViewModel';
import { LauncherStartup, StartupStep } from '@ohos/launchercommon/src/main/ets/tools/LauncherStartup';
import { AppGalleryListener } from '@ohos/appinstall/src/main/ets/default/listener/AppGalleryListener';

const TAG = 'SCBDesktop';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const THEME_FINISH_LOADING_EVENT = 'ThemeFinishLoading';
const DYNAMIC_WALLPAPER_RENDER_EVENT = 'DynamicWallpaperRender';
const CUSTOM_EVENT_RECENT_CLEAR_EVENT = 'custom.event.RECENT_CLEAR_EVENT';
const IMAGE_ANIMATOR_HEIGHT: number = 450;
const IMAGE_ANIMATOR_WIDTH: number = 450;
const IMAGE_ANIMATOR_BOTTOM: number | string = 130;
const IMAGE_ANIMATOR_DURATION: number = 1000;
const DEFAULT_SCALE: number = 1;

class SCBDesktopScaleModifier extends AttributeUpdater<CommonAttribute> {
  private onInit: ((instance: CommonAttribute) => void) | undefined;

  constructor(onInit: (instance: CommonAttribute) => void) {
    super();
    this.onInit = onInit;
  }

  initializeModifier(instance: CommonAttribute) {
    this.onInit?.(instance);
  };
}

class OneStepSplitData {
  public splitStatus: number = 0; // 待分屏状态
  public direction: number = 4; //  分屏方向
  public distance: number = 0; // 避让距离
  public needAnim: boolean = true;
}

interface LauncherCommonBuilderParam {
  isOuterDesktop: boolean;
}

@Component
export struct SCBDesktop {
  @Link screenProp: SCBScreenProperty;
  @State singleContext?: SingleContext = { extendScreenId: this.screenProp.screenId };
  // geometry transition of big folder
  @Provide('openFolderFlag') openFolderFlag: boolean = false;
  @Provide('openFormStackFlag') openFormStackFlag: boolean = false;
  @Provide('convertFolderId') convertFolderId: string = '-1';
  // geometry transition of small folder
  @StorageLink('openSmallFolderFlag') openSmallFolderFlag: boolean = false;
  @Provide('isSmallFolderImage') isSmallFolderImage: boolean = false;
  @Provide('openSmallFolderBackgroundFlag') openSmallFolderBackgroundFlag: boolean = false;
  @Provide('clearDesktopMemory') clearDesktopMemory: boolean = false;
  @Provide('releaseDesktopMemory') releaseDesktopMemory: boolean = false;
  @Provide('startConvert') startConvert: number = CommonConstants.DEFAULT_CONVERT;
  @Provide('startToSmall') startToSmall: number = CommonConstants.DEFAULT_CONVERT;
  @Provide('bigFolderDisappear') bigFolderDisappear: boolean = false;
  @Provide('convertToSmallFolder') isConvertToSmallFolder: boolean = false;
  @Provide('isFromDock') isFromDock: boolean = false;
  private animateScale: number = 1.0;
  @Provide('isFoldProductFold') isFoldProductFold: boolean = launcherStatusUtil.getShowOutLauncherStatus();
  @State blurRatio: number = 0;
  @State isWallpaperBlurEffect: StateEx<boolean> = launcherVisualEffectMgr.isWallpaperBlurEffect;
  @State launcherOpacity: StateEx<number> = launcherVisualEffectMgr.launcherOpacity;
  @State wallpaperBlurOpacity: StateEx<number> = launcherVisualEffectMgr.wallpaperBlurOpacity;
  @State isShowMask: StateEx<boolean> = launcherVisualEffectMgr.isShowMask;
  @State maskColor: StateEx<string> = launcherVisualEffectMgr.maskColor;
  @State isShowFolderBlurEffect: StateEx<boolean> = launcherVisualEffectMgr.isShowFolderBlurEffect;
  @State isDesktopFreeze: boolean = false;
  @State workSpaceWidth: number = 0;
  @State workSpaceHeight: number = 0;
  @State dockHeight: number = 0;
  @State device: string = 'phone';
  @State blurScale: number = 0;
  @State blurStyle: number = BlurStyle.BACKGROUND_REGULAR;
  @State negativeProgress: number = 0;
  @State globalSearchProgress: number = 0;
  @State viewController: BaseViewController = new BaseViewController(ViewType.DESKTOP);
  @Provide('globalSearchTranslateY') globalSearchTranslateY: number = 0;
  @State isHidingGlobalSearch: boolean = false;
  @State dockOpacity: number = 1;
  @State showNameState: ShowNameState = editModeManager.getShowNameState();
  @State isFreeze: boolean = false;
  @State mBackgroundBrightness: number = 1;
  @State isShowPcDockInPad: boolean = SCBSceneSessionManager.getInstance().isPcMode();
  @State isHideDesktop: boolean = false;
  @State editModeSingePageViewData: EditModeSingePageViewData = editModeViewManager.getEditModeSingePageViewData();
  @State editModeGridSwiperViewData: EditModeGridSwiperViewData = editModeViewManager.getEditModeGridSwiperViewData();
  @State gridSwiperLayout: OpenFolderGridSwiperLayout = openFolderLayout.getGridSwiperLayout();
  @Provide isDesktopEnabled: boolean = true;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @StorageLink('screenWidth') screenWidth: number = 0;
  @StorageLink('screenHeight') @Watch('updateScreenInfo') screenHeight: number = 0;
  @StorageLink('assistantIsOn') @Watch('assistantButtonChange') assistantIsOn: boolean = true;
  @StorageProp('themeStyle') @Watch('onThemeChange') themeStyle: string = '';
  @StorageLink('folderAppList') folderAppList: Object[] = [];
  @StorageLink('globalSearchLocationAppShow') globalSearchLocationAppShow: boolean = false;
  @StorageLink('isExclusiveDesktopEvent') isExclusiveDesktopEvent: boolean = false;
  @Watch('handleEditModeChange') @State editModeState: EditModeState = editModeManager.getEditModeState();
  @State editModeViewData: EditModeViewData = editModeManager.getEditModeViewData();
  @Provide isShowingUninstallDialog: number = UninstallDialogStatus.INITIAL_STATE;
  @Provide dragToUninstallItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
  @StorageLink('scenePanelState') @Watch('onScenePanelStateChange') scenePanelState: ScenePanelState = ScenePanelState.HOME;
  @StorageLink('isDeskSwipe') isDeskSwipe: boolean = false;
  @StorageLink('currColorMode') @Watch('onColorModeChange') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
  @Provide companionIconInfo: CompanionIconInfo | null = null;
  @StorageLink('globalSearchAnimation')@Watch('onGlobalSearchAnimationChange') isInglobalSearchAnimation: boolean = false;
  @State isFolderOpened: boolean = false;
  @State translateXForScreenSplit: number = 0;
  @StorageLink('folderStatus') @Watch('folderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  @StorageLink('isBeginSleepStart') @Watch('setIsBaseDeskPageStatus') private isBeginSleepStart: boolean = false;
  @StorageLink('isShowEditModeGuidePage') isShowEditModeGuidePage: boolean = false;
  @StorageLink('formStackEditShow') mIsFormStackExpand: boolean = false;
  private isBlurColumnAppear: boolean = false;
  private isLock: boolean = false;
  private isNewStyle: boolean = true;
  private isEnableBlur: boolean = true;
  private isPreLoadEnable: boolean = false;
  private desktopTextShadow: boolean = true;
  private enableBrightness: boolean = true;
  private mViewManager: ViewManager = ViewManager.getInstance();
  private appIconConfigManager: AppIconConfigManager = AppIconConfigManager.getInstance();
  private mBigFolderViewModel: BigFolderViewModel | null = null;
  private mFolderModel: FolderModel | null = null;
  private foldStatus: number = DeviceState.FOLDED_STATE;
  private foldStatusForOuterScreen: number = DeviceState.EXPAND_STATE;//默认扩展
  private mLayoutViewModel: LayoutViewModel | null = null;
  private navigationBarStatus: string | undefined = '0';
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private editModeViewEvent: EditModeViewEvent = editModeViewManager.getEditModeViewEvent();
  private pageDesktopGridStyleConfig?: PageDesktopGridStyleConfig;
  private mMultiInputViewModel: MultiInputViewModel | null = null;
  private hideDesktopTimeoutId: number | null = null;
  private mDesktopViewModel: SCBDesktopViewModel =
    singleManager.get<SCBDesktopViewModel>(SCBDesktopViewModel, this.singleContext);
  private mCloudExpandDialogMgr: CloudExpandDialogMgr | null = null;
  @State mDesktopViewData: SCBDesktopViewData = this.mDesktopViewModel.getDesktopViewData();
  private isFolderClosing: boolean = false;
  private isSmallFoldDeviceExpand: boolean = false;
  @StorageLink('isScreenSplit') isScreenSplit: boolean = false;
  @State isScreenLockForegroundBlurFinished: boolean = false;
  @State isOuterDesktop: boolean = false;
  //桌面坚盾动效
  private shieldAnimViewModel: ShieldAnimViewModel | undefined = undefined;
  @State shieldAnimParam: ShieldAnimParam | undefined  = undefined;
  private latestScreenProperty: SCBScreenProperty = new SCBScreenProperty();
  private latestFoldState: number = DeviceState.DEFAULT_STATE;
  private latestPortrait: boolean = false;
  private unLockTransitionController: SCBUnlockTransitionController = {
    name: '',
    onLock: (): void => {
      throw new Error('Function not implemented.');
    },
    onUnlock: (): void => {
      throw new Error('Function not implemented.');
    }
  };
  // 待分屏状态事件ID
  public readonly EVENT_ONE_STEP_SPLIT: string = 'multiwindow.event.EVENT_ONE_STEP_SPLIT';
  private mDesktopContext: ServiceExtensionContext = GlobalContext.getContext(); //获取全局对象
  private desktopParam: DesktopParam = DesktopManager.getInstance().getDesktopParam();
  private preSplitStatus = -1;
  private preDirection = -1;
  private preDistance = -1;
  private mWallpaperSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private foldAngle: number = 0;
  private setFreezeReadyTimerId: number = -1;
  private mPageDesktopDragHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance();
  private lastDesktopRotation: number = 0;
  private curTripleFoldState: ScreenStateModel = ScreenStateMonitor.getInstance()
    .getScreenStateModel(BreakpointManager.getInstance().getCurrentBreakpointData());
  private lastTripleFoldState: ScreenStateModel = this.curTripleFoldState;

  private initWallpaperSubscriber(): void {
    try {
      // 初始化壁纸类型
      SCBDesktopCacheManager.getInstance().updateWallPaperType();
      let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
        events: [THEME_FINISH_LOADING_EVENT, DYNAMIC_WALLPAPER_RENDER_EVENT, CUSTOM_EVENT_RECENT_CLEAR_EVENT],
        publisherBundleName: 'com.ohos.sceneboard'
      };

      commonEventManager.createSubscriber(subscribeInfo).then((res) => {
        this.mWallpaperSubscriber = res;
        commonEventManager.subscribe(this.mWallpaperSubscriber, this.wallpaperEventCallback);
      });
    } catch (e) {
      log.showError(TAG, `FreezeTrack commonEventManager createSubscriber error ${e}`);
    }
  }

  private wallpaperEventCallback = (err: BusinessError, eventData: commonEventManager.CommonEventData): void => {
    if (err) {
      log.showError(`wallpaperEventCallback failed, code:${err.code}, message:${err.message}`);
      return;
    }
    if (!eventData) {
      log.showError('wallpaperEventCallback failed, eventData is empty');
      return;
    }
    log.showInfo(`wallpaperEventCallback event: ${eventData.event}, data: ${eventData.data}`);
    if (eventData.event === DYNAMIC_WALLPAPER_RENDER_EVENT) {
      // script壁纸动效开始和结束
      if (eventData.data === 'start') {
        SCBDesktopCacheManager.getInstance().setWallPaperEvent(SCBWallPaperChangeEvent.WALLPAPER_SCRIPT);
        SCBDesktopCacheManager.getInstance().resetFreezeStateAndReady('scriptStart');
      } else if (eventData.data === 'end') {
        SCBDesktopCacheManager.getInstance().removeWallPaperEvent(SCBWallPaperChangeEvent.WALLPAPER_SCRIPT);
        SCBDesktopCacheManager.getInstance().setWallPaperFreezeReady(true, 'scriptEnd');
      } else if (eventData.data === 'restart') {
        SCBDesktopCacheManager.getInstance().resetFreezeStateOnly('restart');
      }
    } else if (eventData.event === THEME_FINISH_LOADING_EVENT) {
      // 壁纸切换完成
      SCBDesktopCacheManager.getInstance().updateWallPaperType();
      SCBDesktopCacheManager.getInstance().wallpaperChanging(false);
      SCBDesktopCacheManager.getInstance().removeWallPaperEvent(SCBWallPaperChangeEvent.WALLPAPER_CHANGE);
      EvtBus.post(DockAvgColorChangeEvent,
        { dockAvgColor: WallpaperColorManager.getInstance().getBackPlaneColor(), isWallpaperChange: true });
    } else if (eventData.event === CUSTOM_EVENT_RECENT_CLEAR_EVENT) {
      // 清除多任务场景，只用unFreeze
      SCBDesktopCacheManager.getInstance().resetFreezeStateOnly('RecentClearAllView');
    }
  };

  private async updateDockBackPlane(): Promise<void> {
    await WallpaperColorManager.getInstance().handleDockBackPlaneColor();
    EvtBus.post(DockAvgColorChangeEvent,
      { dockAvgColor: WallpaperColorManager.getInstance().getBackPlaneColor(), isWallpaperChange: true });
  }

  private destroyWallpaperSubscriber(): void {
    if (this.mWallpaperSubscriber) {
      try {
        commonEventManager.unsubscribe(this.mWallpaperSubscriber);
        this.mWallpaperSubscriber = null;
      } catch (e) {
        log.showError(TAG, `FreezeTrack commonEventManager unsubscribe error ${e}`);
      }
    }
  }

  private pageDesktopScaleModifier = new SCBDesktopScaleModifier((instance: CommonAttribute) => {
    instance.scale({
      x: 1.0,
      y: 1.0,
      centerX: this.screenWidth / 2,
      centerY: this.screenHeight / 2
    });
  });

  private smartDockScaleModifier = new SCBDesktopScaleModifier((instance: CommonAttribute) => {
    instance.scale({
      x: 1.0,
      y: 1.0,
      centerX: this.screenWidth / 2,
      centerY: -this.screenHeight / 2
    });
  });

  private unLockSpaceAniListener: SCBUnlockSpaceAniListener = {
    onFinish: (): void => {
      throw new Error('Function not implemented.');
    }
  };

  private handleEditModeChange(): void {
    if (this.editModeState.isInEditMode()) {
      this.publishEvent('desktopEdit', 'enter'); // 给主题引擎发进入桌面编辑模式消息
      return;
    }
    this.publishEvent('desktopEdit', 'exit'); // 给主题引擎发退出桌面编辑模式消息
    if (this.isDesktopFreeze) {
      SCBDesktopCacheManager.getInstance().setDesktopCacheState(false, CommonConstants.EVENTHUB_THEME_EDIT);
    }
    PageEditViewModel.getInstance().recoverPageScale();
  }

  private publishEvent(type: string, stage: string): void {
    const publishData: commonEventManager.CommonEventPublishData = {
      subscriberPermissions: ['ohos.permission.ACTIVATE_THEME_PACKAGE'],
      parameters: { 'clickType': type, 'stage': stage },
    }
    try {
      commonEventManager.publish('editToolClickType', publishData, () => {
        log.info(TAG, `successful to publish message, stage = ${stage}`);
      });
    } catch (err) {
      log.showError(TAG, `Publish message error about desktop edit, code = ${err?.code}`);
    }
  }

  private onGlobalSearchAnimationChange() {
    log.showInfo(`onGlobalSearchAnimationChange:${this.isInglobalSearchAnimation}`)
  }

  /**
   * 多事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  private keyguardViewCallback: ViewCallback = {
    onHide: (): void => this.onkeyguardViewHide(),
    onShow: (): void => this.onkeyguardViewShow()
  };
  private themeEditViewCallback: ViewCallback = {
    onHide: (): void => {
      ThemeStylePreviewManager.getInstance().clearPreviewResources();
    },
  };
  private desktopFocusCallback: ViewCallback = {
    onGainFocus: (): void => {
      log.showInfo(`Desktop focus`);
      DesktopStatusBarHelper.ensureVisibleOnDesktop('SCBDesktop.onGainFocus');
      PageDesktopViewModel.getInstance().setIsChangingPage(false);
      this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_FOCUS_CHANGE, true);
      AppStorage.setOrCreate('onDeskTop', true);
      AppStorage.setOrCreate('onDeskTopState', this.scenePanelState);
      ExposureManager.getInstance().handleDesktopGainFocus();
      sOutSideWindowMgr.setGlobalSearchStatus(GlobalSearchStatus.HIDE);
      sEventManager.publish(obtainLocalEvent(CommonEventConstants.CONTROL_CENTER_SHOW_HIDE_BAR, true));
    },
    onLoseFocus: (): void => {
      log.showInfo(`Desktop lose focus, the scenePanelState is ${this.scenePanelState}`);
      this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_FOCUS_CHANGE, false);
      AppStorage.setOrCreate('onDeskTop', false);
      AppStorage.setOrCreate('onDeskTopState', this.scenePanelState);
      ExposureManager.getInstance().handleDesktopLoseFocus();
      if (this.isNeedKeepEditMode()) {
        return;
      }
      if (editModeManager.isInEditMode()) {
        editModeManager.changeDesktopMode(DesktopMode.NORMAL_MODE, HiEditModeDataExitType.EXIT_FULLY_OCCLUSION);
      }
    }
  };

  private registerUnlockSpaceAniListener(): void {
    if (!SpaceAnimationUtils.isForegroundEffectSupport()) {
      return;
    }
    this.unLockSpaceAniListener = {
      onFinish: (): void => this.onUnLockReceivedWithSpaceAni(),
    }
    SCBTransitionManager.getInstance().registerUnlockSpaceAniListener(this.unLockSpaceAniListener);
  }

  private onUnLockReceivedWithSpaceAni() {
    log.showInfo(' desktop onUnLockReceivedWithSpaceAni ');
    if (!this.mDesktopViewModel.isUnlockToHome()) {
      return;
    }
    this.blurRatio = 1;
    animateTo({
      duration: 250,
      onFinish: () => {
        log.showInfo('doBlurAnimation finish');
        this.blurRatio = 0;
        this.isScreenLockForegroundBlurFinished = true;
        SCBScenePanelManager.getInstance().setForegroundBlurActive(false);
        Trace.end(Trace.CORE_METHOD_EXIT_KEYGUARD);
      }
    }, () => {
      SCBScenePanelManager.getInstance().setForegroundBlurActive(true);
      this.blurRatio = 0.2;
    })
  }

  private desktopClearCallback: ViewCallback = {
    onTrimMemory: (level: TrimLevel): void => {
      switch (level) {
        case TrimLevel.LIGHT:
          this.clearDesktopMemory = !this.clearDesktopMemory;
          break;
        case TrimLevel.COMPLETE:
          this.releaseDesktopMemory = !this.releaseDesktopMemory;
          break;
        case TrimLevel.CRITICAL:
          AdaptiveIconManager.getInstance().clearIconResources('release desktop memory');
          ResourceManager.getInstance().clearAppAllResourceCache();
          IconResourceManager.getInstance().clearCachedIconFromMemoryCache(`phonebase ${TAG} TrimLevel.CRITICAL`);
          text.FontCollection.getGlobalInstance().clearCaches();
          OpenFolderAppBubbleNodeManager.getInstance().clear();
          this.getUIContext()?.clearResourceCache();
          break;
      }
    },
  };

  private mOpenCloseCallback: FolderActionLifeCycleEvent = {
    description: TAG,
    priority: FolderLifeCyclePriority.LOW,
    onOpeningFolder: (folder: GridLayoutItemInfo) => {
      this.isFolderClosing = false;
      SceneBoardStateManager.getInstance().consumeEvent(CoreEventType.OPEN_DESKTOP_FOLDER);
      ContractedFolderLayoutViewModel.getInstance()
        .updateOpenFolderStatus(CommonConstants.OPEN_FOLDER_STATUS_TRANSITION_START);
      log.showInfo('folder on open');
      // 打开文件夹时，文件夹背景模糊效果禁用，改为壁纸模糊生效
      if (launcherVisualEffectMgr.triggerFolderFullBlurEvent(true)) {
        log.showInfo('folder on open disable blur effect');
        return;
      }
      if (!editModeManager.isInEditMode()) {
        animateTo({
          duration: 500,
          curve: Curve.Friction
        }, () => {
          this.onDesktopAnimateScaleChanged(CommonConstants.OPEN_FOLDER_ANIMATE_SCALE, 'openingFolderCallback');
        });
      }
      this.blurAnim(false);
    },
    onOpenedFolder: (folder: GridLayoutItemInfo) => {
      this.isFolderOpened = true;
      ContractedFolderLayoutViewModel.getInstance()
        .updateOpenFolderStatus(CommonConstants.OPEN_FOLDER_STATUS_TRANSITION_END);
    },
    onClosingFolder: (folder: GridLayoutItemInfo) => {
      log.showInfo('folder on close');
      this.isFolderOpened = false;
      this.isFolderClosing = true;
      // 关闭文件夹时，壁纸模糊失效
      if (launcherVisualEffectMgr.triggerFolderFullBlurEvent(false)) {
        log.showInfo('folder on close disable blur effect');
        if (!CommonUtils.equals(this.blurScale, 0.0)) {
          this.blurScale = 0.0;
          this.onDesktopAnimateScaleChanged(1.0, 'closingFolderCallback');
        }
        return;
      }
      if (!editModeManager.isInEditMode()) {
        animateTo({
          duration: 500,
          curve: Curve.Friction
        }, () => {
          this.onDesktopAnimateScaleChanged(1.0, 'closingFolderCallback');
        });
      }
      this.blurAnim(true);
    },
    onClosedFolder: (folder: GridLayoutItemInfo) => {
      this.isFolderOpened = false;
      this.isFolderClosing = false;
      this.isSmallFolderImage = true;
      this.openFolderFlag = false;
      this.openSmallFolderFlag = false;
      this.openSmallFolderBackgroundFlag = false;
      if (this.blurScale != 0.0) {
        log.showInfo('clear desktop blur on folder closed');
        this.blurScale = 0.0;
      }
      if (!SCBSceneSessionManager.getInstance().isResetDesktopScale()) {
        this.onDesktopAnimateScaleChanged(1.0, 'closedFolderCallback');
      }
      if (launcherVisualEffectMgr.isBlurEffectEnabledByType(BlurEffectType.FOLDER)) {
        // 解决未关闭文件夹的时候，直接锁屏，解锁后无法进入桌面的问题
        this.desktopContext?.eventHub.emit(VisualEffectConstants.FOLDER_BLUR_EFFECT, false, true);
        log.showInfo('reset wallpaper blur');
      }
      if (launcherVisualEffectMgr.isBlurEffectEnabledByType(BlurEffectType.EDIT_MODE_FOLDER)) {
        // 解决在编辑模式下，未关闭文件夹的时候，直接锁屏，解锁后进入编辑模式无法进入桌面的问题
        launcherVisualEffectMgr.updateBlurEffect(false, BlurEffectType.EDIT_MODE_FOLDER);
        AppStorage.setOrCreate('editModeFolderBlurEffect', false);
        log.showInfo('reset edit mode folder blur');
      }
      SceneBoardStateManager.getInstance().consumeEvent(CoreEventType.CLOSE_DESKTOP_FOLDER);
    }
  };

  private themeStyleCallback: ThemeStyleCallback = {
    onStyleChanged:(isIconActive: boolean): void => {
      PhonePageDesktopGridStyleConfig.getInstance().initConfig();
      BigFolderStyleConfig.setInPreviewMode(false);
      SmallFolderStyleConfig.setInPreviewMode(false);
      SmartDockStyleConfig.getInstance().initConfig();
      FormStyleConfig.getInstance().initConfig();
      OpenFolderStyleConfig.getInstance().initConfig();
    }
  }

  /**
   * 监听周期调度发送的打点数据通知，然后执行周报上传
   *
   * @param WeekSchedulerReporterEvent 事件
   */
  private weekSchedulerReporterEvent = (event: WeekSchedulerReporterEvent): void => {
    // execute 周报上传
    WorkSchedulerManager.getInstance().executeReport();
  }

  private reportInformation = () => {
    DesktopInformationReporter.getInstance().getDesktopInformation().then(status => {
      HiSysEventUtil.reportDesktopInformation(status);
    });
  }
  private reportFolderInformation = () => {
    SCBHiSysEventUtil.folderStateInfoMethod();
  }

  /**
   * 桌面_每一屏的大于1*1空网格种类及对应个数(状态点,周报,周日报)
   */
  private reportEmptyGridInfo = () => {
    this.mPageDesktopDragHandler.reportEmptyGridInfo();
  }
  /**
   * 桌面图标位置状(状态点,周报,周日报)
   */
  private reportIconGridInfo = () => {
    SCBHiSysEventUtil.reportIconGridInfo();
  }

  /**
   *
   * 快捷方式状态点,周报
   */
  private reportShortcutInfo = () => {
    SCBHiSysEventUtil.reportShortcutInfo();
  }

  /**
   * 0层组件状态点，周报
   */
  private reportSystemSceneState = () => {
    viewMgrPolicy.reportSystemSceneState();
  };

  /**
   * 亮灭屏事件
   *
   * @param event 事件
   */
  private screenLockListener: ScreenLockStateListener = {
    onEnterHost: (preState: ScreenLockState, isSaveConfig: boolean) => {
      SCBDesktopCacheManager.getInstance().resetFreezeStateAndReady('ScreenLock');
      this.closedEditModeGuidePage();
      SCBDesktopAddViewModel.getInstance().closeDesktopAddDialog();
    }
  }

  private onFoldAngleChange: (angles: number[]) => void = (angles: number[]): void => {
    if (CheckEmptyUtils.isEmptyArr(angles)) {
      log.showWarn('FreezeTrack onFoldAnglesChange angles is empty');
      return;
    }
    this.foldAngle = angles[0];
    if (!this.isFoldAngleChangeEnd()) {
      SCBDesktopCacheManager.getInstance().setWallPaperEvent(SCBWallPaperChangeEvent.SCREEN_FOLD_OR_EXPAND);
      SCBDesktopCacheManager.getInstance().setWallPaperFreezeState(false,
        `onFoldAngleChange start, angle: ${this.foldAngle}`);
      SCBDesktopCacheManager.getInstance().setWallPaperFreezeReady(false,
        `onFoldAngleChange start, angle: ${this.foldAngle}`);
    } else {
      this.setFreezeReadyWithTimeout();
    }
  };

  private onConfigurationEvent = () => {
    PhonePageDesktopGridStyleConfig.getInstance().initConfig();
    BigFolderStyleConfig.getInstance().initConfig();
    SmallFolderStyleConfig.getInstance().initConfig();
    SmartDockStyleConfig.getInstance().initConfig();
    FormStyleConfig.getInstance().initConfig();
    if (ThemeStyleManager.getInstance().isStyleChangedFromThemeEvent) {
      log.showWarn('onConfigurationEvent: theme changed to refresh');
      ThemeStyleManager.getInstance().isStyleChangedFromThemeEvent = false;
      let theme = ThemeStyleManager.getInstance().loadThemeStyle(true);
      AppStorage.setOrCreate<string>('themeStyle', theme);
    }
  }

  private eventListener() {
    this.eventMgr
      .on(WeekSchedulerReporterEvent, this.weekSchedulerReporterEvent)
      .on(ConfigurationEvent, this.onConfigurationEvent);
    screenLockStateManager.registerScreenLockState(this.screenLockListener);
  }
  persistentId: number = 0;

  private setIsBaseDeskPageStatus(): void {
    PageDesktopOneShotManager.getInstance().setIsBaseDeskPage();
  };

  private onSingleHandStatusChange: SingleHandStatusChangeCallback = {
    // 开始进入或退出单手模式时，解除freeze避免桌面模糊显示异常
    onSingleHandEntered: (mode: SingleHandMode): void => {
      log.showWarn('onSingleHandEntered');
      SCBDesktopCacheManager.getInstance().resetFreezeStateOnly('onSingleHandEntered');
    },
    onSingleHandExited: (): void => {
      log.showWarn('onSingleHandExited');
      SCBDesktopCacheManager.getInstance().resetFreezeStateOnly('onSingleHandExited');
    }
  };

  private onSingleHandAnimationFinishCallBack: SingleHandAnimationFinishCallBack = {
    // 进入和退出单手模式动效结束后，解除freeze避免桌面模糊显示异常
    onEnterSingleHandAnimationFinish: (): void => {
      log.showWarn('onEnterSingleHandAnimationFinish');
      SCBDesktopCacheManager.getInstance().resetFreezeStateOnly('onEnterSingleHandAnimationFinish');
    },
    onExitSingleHandAnimationFinish: (): void => {
      log.showWarn('onExitSingleHandAnimationFinish');
      SCBDesktopCacheManager.getInstance().resetFreezeStateOnly('onExitSingleHandAnimationFinish');
    }
  };

  /**
   关闭编辑模式提示动画页面
   */
  private closedEditModeGuidePage(): void {
    if (this.isShowEditModeGuidePage) {
      this.isShowEditModeGuidePage = false;
    }
  }

  private initCloudExpandDialogMgr(): void {
    if (DeviceHelper.isFold()) {
      this.mCloudExpandDialogMgr = CloudExpandDialogMgr.getInstance(this.singleContext);
    }
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    let area: ViewArea = {
      left: 0,
      top: 0,
      width: px2vp(this.screenProp.width),
      height: px2vp(this.screenProp.height),
    };
    this.viewController.updateArea(area);
    LauncherStartup.getInstance().passStep(StartupStep.SCB_DESKTOP);
    // 异步加载持久化的主屏下标
    PageInfoManager.getInstance().readHomePageIndex();
    UIContextHelper.setContext(this.screenProp?.screenId, this.getUIContext());
    this.registerUnlockTransitionController();
    this.mDesktopViewModel.initFirstPage();
    this.mDesktopViewData.launcherModel = this.mDesktopViewModel.getDesktopModel();
    this.isPreLoadEnable = parameter.getSync('persist.resourceschedule.app.preload.enable', '1') === '1';
    this.desktopContext?.eventHub.on(SCBConstants.DESKTOP_IS_FREEZE, (value: boolean) => {
      log.showWarn(`FreezeTrack DESKTOP_IS_FREEZE old: ${this.isFreeze}, new: ${value}`);
      if (this.isFreeze === value) {
        return;
      }
      this.isFreeze = value;
    });
    this.initWallpaperSubscriber();
    AppInstallRegister.register('phone');
    this.lastDesktopRotation = this.screenProp.rotation;
    this.isNewStyle = parameter.getSync('sceneboard.isNewStyle', 'true') === 'true';
    this.isEnableBlur = parameter.getSync('sceneboard.isEnableBlur', 'true') === 'true';
    this.desktopTextShadow = parameter.getSync('sceneboard.desktopTextShadow', 'true') === 'true';
    this.enableBrightness = parameter.getSync('sceneboard.enableBrightness', 'true') === 'true';
    launcherVisualEffectMgr.initParams();
    AppStorage.setOrCreate('desktopNewStyle', this.isNewStyle);
    AppStorage.setOrCreate('desktopTextShadow', this.desktopTextShadow);
    AppStorage.setOrCreate('isPreLoadEnable', this.isPreLoadEnable);
    viewMgrPolicy.registerViewController(ViewType.DESKTOP, this.viewController);
    this.viewController.updateId(this.persistentId);
    this.viewController.show();
    this.registerUnlockSpaceAniListener();
    // 更新亮度初始值
    this.updateBrightness(false);
    // 初始化文件夹加载的适配器
    new PhoneFolderViewModelLoader().loadCommonConfig()
      .loadViewModelConfig(PhoneFolderConfig.modelConfig)
      .loadFolderStyle()
      .loadAnimationEvent() as PhoneFolderViewModelLoader;

    this.updateFoldStatusParam(SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus() ?
    DeviceState.EXPAND_STATE : DeviceState.FOLDED_STATE);
    log.showInfo(`foldStatus is ${this.foldStatus}, isPortrait is ${this.isPortrait(this.screenProp?.screenId)}`);
    if (desktopUtil.isFold()) {
      AppStorage.setOrCreate<number>('folderStatus', this.foldStatus);
    }
    AppStorage.setOrCreate<number>('foldStatusForOuterScreen', this.foldStatusForOuterScreen);
    AppStorage.setOrCreate<boolean>('isPortrait', this.isPortrait(this.screenProp?.screenId));
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(
      this.screenPropertyChangeCallbackFunc, undefined, false, this.persistentId);
    WorkSchedulerManager.getInstance().registerReport(this.reportInformation);
    WorkSchedulerManager.getInstance().registerReport(this.reportFolderInformation);
    WorkSchedulerManager.getInstance().registerReport(this.reportEmptyGridInfo);
    WorkSchedulerManager.getInstance().registerReport(this.reportIconGridInfo);
    WorkSchedulerManager.getInstance().registerReport(this.reportShortcutInfo);
    WorkSchedulerManager.getInstance().registerReport(this.reportSystemSceneState);
    WorkSchedulerManager.registerDelayTask(ReportWorkSchedulerExtensionAbility.getWorkInfo());
    this.eventListener();

    this.registerGestureCallback();
    if (desktopUtil.isSupportSimpleMode()) {
      this.mDesktopViewModel.registerLauncherModelChangeListener();
    }
    viewMgrPolicy.registerViewCallback(ViewType.DESKTOP, this.desktopFocusCallback);
    viewMgrPolicy.registerViewCallback(ViewType.DESKTOP, this.desktopClearCallback);
    AppStorageUtil.setOrCreate('device', this.device);

    // init layout config
    this.mLayoutViewModel = LayoutViewModel.getInstance(this.singleContext);
    this.mBigFolderViewModel = BigFolderViewModel.getInstance();
    this.mFolderModel = FolderModel.getInstance();
    let baseConfig = this.mLayoutViewModel.getBaseConfig();
    let isThreeFoldDevice = DeviceHelper.isThreeFoldProduct();
    if (isThreeFoldDevice) {
      this.registerScreenStateMonitor();
    }
    log.showInfo(`aboutToAppear, isFoldExpandStatus: ${desktopUtil.isFoldExpandStatus()}`);
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.mLayoutViewModel.setLayoutRulesController(OuterPhoneLayoutRulesController.getInstance(baseConfig, this.singleContext));
    } else if (desktopUtil.isFoldExpandStatus()) {
      //三折设备，G态采用对应的布局器， M态可共用之前的布局器
      if (isThreeFoldDevice && DeviceHelper.isGState()) {
        let horizontalThreeFoldRulesController =
          HorizontalThreeFoldPhoneLayoutRulesController.getInstance(baseConfig, this.singleContext);
        this.mLayoutViewModel.setLayoutRulesController(horizontalThreeFoldRulesController);
      } else {
        this.mLayoutViewModel.setLayoutRulesController(FoldPhoneLayoutRulesController.getInstance(baseConfig, this.singleContext));
      }
    } else if (DeviceHelper.isPhone()) {
      this.mLayoutViewModel.setLayoutRulesController(this.mDesktopViewModel.getDesktopModel() ===
        DesktopLayoutState.SIMPLE_LAUNCHER_MODEL ? SimplePhoneLayoutRulesController.getInstance(baseConfig, this.singleContext) :
        PhoneLayoutRulesController.getInstance(baseConfig, this.singleContext));
    } else {
      this.updatePadLayoutRulesController(baseConfig);
    }
    this.getWindowSize();
    this.updateScreenSize();
    // 初始化三级缓存默认图标资源大小为标准模式（折叠态）下图标大小
    bundleManagerFwk.initIconSizeOfGrid(
      PhoneLayoutRulesController.getInstance(baseConfig, this.singleContext).calculateDesktop().mIconSize ?? 0);
    // 快捷键注册
    if (DeviceHelper.isPad() || DeviceHelper.isThreeFoldProduct()) {
      this.mMultiInputViewModel = MultiInputViewModel.getInstance();
      multiInputManager.registerPadInputEvent();
    }
    if (DeviceHelper.isPad()) {
      // pc应用上pad一步直达应用接入监听
      StatusBarServiceEventMgr.getInstance().registerStatusBarServiceEventListener();
    }
    if (DeviceHelper.is2In1DevicePcType()) {
      DesktopSettingUtils.enableDesktopSettingsSearchItems();
    }
    this.registerPageDesktopEvent(this.mLocalEventListener);
    this.registerDesktopLongPressIconMenuShowEvent(this.mIconMenuEventListener);
    SCBTransitionManager.getInstance().registerGlobalTransitionController({
      appData: {
        bundleName: '',
        abilityName: '',
        appIconId: `${TAG}Global`,
        appIconNumber: 0,
        iconRadius: 0
      },
      onActive: (): void => this.onActive(),
      onInactive: (infoMsg: string = '', delayTime: number = 0): void => this.onInactive(infoMsg, delayTime),
      onActiveWithNoAnim: (): void => this.onActiveWithNoAnim()
    });

    SCBTransitionManager.getInstance().registerTransitionCallback(SCBDesktopEventId.SWIPE_UP_FROM_HOME,
      (scale: number) => {
        this.doFollowAnimate(scale);
      })
    SCBTransitionManager.getInstance().registerTransitionCallback(SCBDesktopEventId.SWIPE_UP_BACK_HOME_FROM_HOME,
      (scale: number) => {
        this.doBackHomeAnimate(scale);
      })
    viewMgrPolicy.registerViewCallback(ViewType.KEYGUARD, this.keyguardViewCallback);
    ThemeStyleManager.getInstance().registerThemeEvent(this.themeEventCallBack);
    ThemeStyleManager.getInstance().registerThemeCallBack(this.themeStyleCallback);
    this.editModeViewEvent.registerEvent();
    viewMgrPolicy.registerViewCallback('SCBThemeEditor', this.themeEditViewCallback);
    FormStackEventReporter.getInstance().startReportAlarm();
    FormHiSysEventUtil.getInstance().startReportAlarm();
    // 设置_通知和状态栏_设置状态点周报
    StatusBarSysEventUtil.getInstance().startReportAlarm();
    let desktopIconChangeSize: string = sSettingsUtil.getSecureValue('desktopIconChangeSize');
    this.changeDesktopIconSize(desktopIconChangeSize);
    QuitAppRectViewModel.getInstance().registerFolderStyleListener();
    this.pageDesktopGridStyleConfig = PageDesktopViewModel.getInstance().getPageDesktopStyleConfig();
    // 10s后执行投票
    PageDesktopViewModel.getInstance().scheduleVoteTimeout();
    new DesktopSettingsPerefrence(getContext()?.getApplicationContext() || GlobalContext.getContext(),
      'DesktopSetting');
    editModeManager.initIsShowAppName();
    DesktopManager.getInstance().registerInitCallback(this.initDesktopParam);
    folderLayoutUtil.initFolderLayoutConfig();
    // 壁纸切换事件注册
    WallpaperManager.getInstance().addWallpaperChangeListener(this.wallPaperChange);
    this.registerHideDesktop();
    this.registerCacheDesktop();
    AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);

    formStackItemViewManager.registerFormStackItemView(FormStackItemViewType.FORM_COMPONENT, new FormBuildItem());

    folderLayout.registerFolderActionCallback();
    FolderActionLifeCycleEventManager.getInstance().register(this.mOpenCloseCallback);
    openCloseAniMgr.setComponentUtils(this.getUIContext());
    folderGesData.registerCallback();
    this.onEventHub();
    WeeklyReporter.getInstance().init();
    DailyScheduledReporter.getInstance().init();
    GameEventListener.getInstance().initGameEventListener();
    launcherVisualEffectMgr.registerRecentBlurEvent();
    launcherVisualEffectMgr.registerFolderFullBlurEvent();
    launcherVisualEffectMgr.registerIconStartExitBlurEvent();
    SCBSingleHandController.getInstance().registerSingleHandStatusChangeCallback(TAG, this.onSingleHandStatusChange);
    if (DeviceHelper.isFold()) {
      try {
        display.on('foldAngleChange', this.onFoldAngleChange);
      } catch (err) {
        log.showError(`on foldAngleChange error, code:${err?.code}, message:${err?.message}`);
      }
    }
    SCBSingleHandController.getInstance().registerSingleHandStatusChangeCallback(TAG, this.onSingleHandStatusChange);
    SCBSingleHandController.getInstance().registerSingleHandAnimationFinishCallBack(TAG,
      this.onSingleHandAnimationFinishCallBack);
    this.appIconConfigManager.registerBadgeKeyObserver();
    this.appIconConfigManager.initShowDesktopBadges();
    this.registerUpdateFontColor();
    this.initCloudExpandDialogMgr();
    this.mCloudExpandDialogMgr?.startCloudDialog(CloudChangeStatus.CLOUD_TO_APPEAR);
    this.mCloudExpandDialogMgr?.registerCloudModeMonitor();
    this.registerLightOutdoorListener();
  }

  /**
   * 注册云端2模式切换监听
   */
  private registerLightOutdoorListener(): void {
    if (LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      AppGalleryListener.getInstance().destroy();
    }
    LightOutdoorConfig.getInstance().registerLightOutdoorModeChangeListener(TAG, (action: number) => {
      if (action == 0) {
        SCBDesktopViewModel.getInstance().exitLightOutdoorMode();
        AppGalleryListener.getInstance().init();
      } else {
        SCBDesktopViewModel.getInstance().enterLightOutdoorMode();
        AppGalleryListener.getInstance().destroy();
      }
    });
  }
  // 折叠屏50~176度之间壁纸会做动效
  private isFoldAngleChangeEnd(): boolean {
    return (this.foldAngle < 50.0) || (this.foldAngle > 176.0);
  }

  private setFreezeReadyWithTimeout(): void {
    if (this.setFreezeReadyTimerId !== -1) {
      clearTimeout(this.setFreezeReadyTimerId);
    }
    this.setFreezeReadyTimerId = setTimeout(() => {
      // 折叠完成后延迟1S，等壁纸开合动效结束后再恢复FreezeReady状态，
      if (this.isFoldAngleChangeEnd()) {
        SCBDesktopCacheManager.getInstance().removeWallPaperEvent(SCBWallPaperChangeEvent.SCREEN_FOLD_OR_EXPAND);
        SCBDesktopCacheManager.getInstance().setWallPaperFreezeReady(true,
          `onFoldAngleChange end, angle: ${this.foldAngle}`);
      }
      this.setFreezeReadyTimerId = -1;
    }, 1000);
  }

  private registerScreenStateMonitor(): void {
    ThreeFoldRotateViewModel.getInstance().registerThreeFoldRotateCallback();
    ScreenStateMonitor.getInstance().registerScreenStateChangeListener(TAG, (old: ScreenStateModel,
      newData: ScreenStateModel) => {
      log.showWarn(`recevie screenState, old: ${old.screenState}, orientation: ${old.orientation}, w: ${
      old.width}, h: ${old.height}; new: ${newData.screenState}, orientation: ${newData.orientation}, w: ${
      newData.width}, h: ${newData.height}`);
      SCBDesktopCacheManager.getInstance().resetFreezeStateOnly('BREAK_POINT');
    });
  }

  public foldOrExpandDesktopForThreeFold(): void {
    if (this.curTripleFoldState.screenState === ScreenState.F) {
      this.latestFoldState = DeviceState.FOLDED_STATE;
    } else {
      this.latestFoldState = DeviceState.EXPAND_STATE;
    }
    // 记忆能力仅用于MG状态切换
    if (this.curTripleFoldState.screenState !== ScreenState.F && this.lastTripleFoldState.screenState !== ScreenState.F) {
      let isSkipAnimation : boolean = this.skipFoldExpandAnimation();
      // 无动效开合场景：如负一屏场景开合，不做延迟下树处理
      if (!isSkipAnimation) {
        ThreeFoldExpandViewModel.getInstance().threeFoldExpandBefore();
      }
    }
    ThreeFoldUtils.setGTFPreNextMargin(this.curTripleFoldState.screenState, this.lastTripleFoldState.screenState);
    log.showInfo(`foldOrExpandDesktop: state: ${this.curTripleFoldState.screenState}, orientation: ${
      this.curTripleFoldState.orientation}`);
    Trace.start(Trace.CORE_METHOD_BREAKPOINT_CHANGE_DESKTOP);
    this.processFoldOrExpandByBreakpoint(this.curTripleFoldState.width, this.curTripleFoldState.height,
      this.curTripleFoldState.orientation === ScreenOrientation.PORTRAIT);

    setTimeout(() => {
      ContextMenu.close();
    }, 0);
    // 关闭卡片中心
    FormCenterViewManager.getInstance().closeFormCenterView();
    if (AppStorage.get('showUninstallDialog')) {
      AppStorage.setOrCreate('showUninstallDialog', false);
    }
    Trace.end(Trace.CORE_METHOD_BREAKPOINT_CHANGE_DESKTOP);
  }

  private registerHideDesktop(): void {
    this.desktopContext?.eventHub.on(CommonConstants.HIDE_DESKTOP_EVENT, (value: boolean) => {
      this.isHideDesktop = value;
      log.info('hide desktop ' + value);

      if (this.isHideDesktop) {
        this.hideDesktopTimeoutId = setTimeout(() => {
          this.isHideDesktop = false;
          log.info('hide desktop timeout restore');
        }, 800);
      } else {
        log.info('hide desktop restore' + this.hideDesktopTimeoutId);
        if (this.hideDesktopTimeoutId != null) {
          clearTimeout(this.hideDesktopTimeoutId);
          this.hideDesktopTimeoutId = null;
        }
      }
    });
  }

  private unregisterHideDesktop(): void {
    this.desktopContext?.eventHub.off(CommonConstants.HIDE_DESKTOP_EVENT);
  }

  private registerCacheDesktop(): void {
    this.desktopContext?.eventHub.on(CommonConstants.EVENTHUB_THEME_EDIT, (value: boolean) => {
      this.isDesktopFreeze = value;
      log.info(`THEME_EDIT, desktop cache = ${value}`);
    });
    this.desktopContext?.eventHub.on(CommonConstants.EVENTHUB_MARK_DESKTOP_FREEZE, (value: boolean) => {
      if (value && !editModeManager.isInEditMode()) {
        log.info('desktop cache only use in edit mode');
        return;
      }
      this.isDesktopFreeze = value;
      log.info(`desktop cache = ${value}`);
    });
  }

  private unregisterCacheDesktop(): void {
    this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_THEME_EDIT);
    this.desktopContext?.eventHub.off(CommonConstants.EVENTHUB_MARK_DESKTOP_FREEZE);
  }

  private updateFontColorCB = (): void => {
    DesktopManager.getInstance().saveDesktopParam();
  }

  private registerUpdateFontColor(): void {
    this.desktopContext?.eventHub.on(SCBConstants.EVENT_UPDATE_FONT_COLOR, this.updateFontColorCB);
  }

  private unregisterUpdateFontColor(): void {
    this.desktopContext?.eventHub.off(SCBConstants.EVENT_UPDATE_FONT_COLOR, this.updateFontColorCB);
  }

  private onThemeChange(): void {
    this.mDesktopViewModel.closeFolderImmediately();
  }

  private initDesktopParam: () => void = () => {
    if (!this.pageDesktopGridStyleConfig) {
      return;
    }
    this.desktopParam.rows = this.pageDesktopGridStyleConfig.mRows;
    this.desktopParam.columns = this.pageDesktopGridStyleConfig.mColumns;
    this.desktopParam.iconSize = this.pageDesktopGridStyleConfig.mIconSize;
    this.desktopParam.gridWidth = this.pageDesktopGridStyleConfig.mGridWidth;
    this.desktopParam.gridHeight = this.pageDesktopGridStyleConfig.mGridHeight;
    this.desktopParam.nameFontColor = this.pageDesktopGridStyleConfig.mNameFontColor;
    this.desktopParam.marginBottomOfIndicator = this.pageDesktopGridStyleConfig.mMarginBottomOfIndicator;
    this.desktopParam.columnGaps = this.pageDesktopGridStyleConfig.mColumnsGap;
    this.desktopParam.rowGaps = this.pageDesktopGridStyleConfig.mRowsGap;
    this.desktopParam.filesDir = this.desktopContext?.filesDir ?? '';
    this.desktopParam.cacheDir = this.desktopContext?.cacheDir ?? '';
    this.desktopParam.nameSize = this.pageDesktopGridStyleConfig.mNameSize;
    this.desktopParam.nameLines = this.pageDesktopGridStyleConfig.mNameLines;
    this.desktopParam.nameMarginTop = this.pageDesktopGridStyleConfig.mIconNameMargin +
    this.pageDesktopGridStyleConfig.mIconNameMarginTop;
    this.desktopParam.spaceOfRow = this.pageDesktopGridStyleConfig.mSpaceOfRow;
    this.desktopParam.spaceOfColumn = this.pageDesktopGridStyleConfig.mSpaceOfColumn;
    this.desktopParam.iconRadius = this.pageDesktopGridStyleConfig.mIconRadius;
    this.desktopParam.iconMarginVertical = this.pageDesktopGridStyleConfig.mIconMarginVertical;
    this.desktopParam.curColorMode = this.currColorMode;
    this.desktopParam.enableBlur = this.isEnableBlur;
    this.desktopParam.enableBrightness = this.enableBrightness;
    this.desktopParam.backgroundBrightness = this.mBackgroundBrightness;
    this.desktopParam.isDarkMode = baseStateMgr.isDarkMode().valueOf();
    this.desktopParam.wallpaperType = WallpaperColorManager.getInstance().mTextColor?.mWallpaperType ?? 0;
    this.desktopParam.screenHeight = this.screenHeight;
    this.desktopParam.screenWidth = this.screenWidth;
    this.desktopParam.statusBarHeight = viewMgrPolicy.getViewController(ViewType.STATUS_BAR)?.getArea()?.height ?? 0;
    this.desktopParam.fontSizeScale = AppStorage.get<number>('fontSizeScale') as number || 1;
    const isNewStyle = AppStorage.get<boolean>('desktopNewStyle') ?? true;
    const desktopTextShadow = AppStorage.get<boolean>('desktopTextShadow') ?? true;
    this.desktopParam.isNeedAppNameShadow = isNewStyle && desktopTextShadow;
    this.desktopParam.singlePageFoldScreenWidth = LayoutViewModel.getInstance(this.singleContext).getScreenWidth();
    this.desktopParam.isAccessibilityMode = AppStorage.get<boolean>('isAccessibilityMode') as boolean || false;
    this.desktopParam.mMargin = this.pageDesktopGridStyleConfig.mMargin;
    this.desktopParam.isRTL = RTLUtil.isRTL();
    this.desktopParam.isSimpleMode = LayoutViewModel.getInstance(this.singleContext).isSimpleLauncherMode();
    this.desktopParam.displayCount = DisplayCountViewModel.getInstance().getDisplayCount();
    this.desktopParam.foldPaddingSide = this.pageDesktopGridStyleConfig.mFoldPaddingSide ?? 0;
    this.desktopParam.isOnlineTheme = onLineThemeUtil.isOnlineTheme() ?? false;
  }

  private screenPropertyChangeCallbackFunc = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo('registerScreenPropertyChangeCallbacks screen width: %{public}d, screen height: %{public}d, ' +
      'reason: %{public}d', screenProperty.width, screenProperty.height, reason);
    if (this.mLayoutViewModel === null) {
      log.showError(TAG, 'mLayoutViewModel is null');
      return;
    }
    let isPortrait: boolean = this.isPortrait(screenProperty.screenId);
    this.latestScreenProperty = screenProperty;
    this.latestPortrait = isPortrait;
    Trace.start(Trace.CORE_METHOD_SCREEN_PROPERTY_CHANGE_DESKTOP);
    let currentDesktopRotation = this.getDesktopRotation();
    switch (reason) {
      case SCBPropertyChangeReason.FOLD_LANDSCAPE_START:
        break;
      case SCBPropertyChangeReason.FOLD_TO_EXPAND:
        // 折叠到展开
        break;
      case SCBPropertyChangeReason.EXPAND_TO_FOLD:
        // 展开到折叠
        break;
      case SCBPropertyChangeReason.CHANGE_MODE:
        // 模式切换：分辨率切换等
        this.updateDesktopLayout(screenProperty.width, screenProperty.height, isPortrait);
        break;
      case SCBPropertyChangeReason.FOLD_SCREEN_ROTATION:
      case SCBPropertyChangeReason.PAGE_ROTATION:
        // 无动效转屏场景
        log.showInfo(`PAGE_ROTATION isPortrait:${isPortrait}, current: ${currentDesktopRotation}, last: ${this.lastDesktopRotation};`);
        this.updateDesktopLayout(screenProperty.width, screenProperty.height, isPortrait);
        this.mDesktopViewModel.screenChangeRotationNoAnim(isPortrait, this.lastDesktopRotation !== currentDesktopRotation);
        this.setRotationFocusComponent();
        DesktopManager.getInstance().saveDesktopParam();
        break;
      default:
        break;
    }
    setTimeout(() => {
      ContextMenu.close();
    }, 0);
    if (AppStorage.get('showUninstallDialog')) {
      AppStorage.setOrCreate('showUninstallDialog', false);
    }
    this.lastDesktopRotation = screenProperty.rotation;
    Trace.end(Trace.CORE_METHOD_SCREEN_PROPERTY_CHANGE_DESKTOP);
  }

  private getDesktopRotation(): number {
    let desktopSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.viewController.getId(), this.screenProp.screenId);
    return desktopSceneSession ? desktopSceneSession.rotation : this.screenProp.rotation;
  }

  private setRotationFocusComponent(): void {
    SwiperPageFocusManager.getInstance().setFocusComponentIdAfterRotation();
  }

  private processFoldOrExpandProChange(foldState: DeviceState, screenProperty: SCBScreenProperty,
    isPortrait: boolean): void {
    if (DeviceHelper.isThreeFoldProduct()) {
      this.foldOrExpandDesktopForThreeFold();
      return;
    }
    this.isDeskSwipe = false;
    let isStatusChange: boolean = this.foldStatusForOuterScreen !== foldState;
    this.updateFoldStatusParam(foldState);
    this.updateDesktopLayout(screenProperty.width, screenProperty.height, isPortrait);
    this.mDesktopViewModel.screenChangeExpandOrFold(foldState, isPortrait, isStatusChange);
    log.showInfo(`processFoldOrExpandProChange foldState = ${foldState}`);
    if (foldState === DeviceState.EXPAND_STATE) {
    }
    this.runFoldOrExpandAnimation(foldState);
  }

  private processFoldOrExpandByBreakpoint(width: number, height: number,
    isPortrait: boolean): void {
    this.isDeskSwipe = false;
    let isStatusChange: boolean = this.foldStatusForOuterScreen !== this.latestFoldState;
    this.updateFoldStatusParam(this.latestFoldState);
    this.updateDesktopLayout(width, height, isPortrait);
    this.mDesktopViewModel.screenChangeExpandOrFold(this.latestFoldState, isPortrait, isStatusChange);
    this.runTripleAnimation(this.lastTripleFoldState.screenState, this.curTripleFoldState.screenState);
  }

  private runTripleAnimation(oldState: ScreenState, newState: ScreenState) {
    let isSkipAnimation : boolean = this.skipFoldExpandAnimation();
    log.showInfo(`triple Animation: Desktop triple state change from ${oldState} to ${newState}
      isSkipAnimation: ${isSkipAnimation}`);
    localEventManager.sendLocalEventAsync(EventConstants.EVENT_BREAK_SLIDE_SWIPER_PAGE);
    // 三折叠产品，处理开合AI多窗逻辑
    SCBSceneWindowAiSplitSwitchUtils.getInstance().AiSplitSwitchByStateChange(oldState, newState);
    if (isSkipAnimation) {
      // just record swiper page location data
      SCBTransitionManager.getInstance().runTripleAnimationCallback(oldState, newState, false);
      ThreeFoldUtils.resetPreNextMargin();
    } else {
      // Complete the layout update.
      animateTo({}, () => {
      });
      SCBTransitionManager.getInstance().runTripleAnimationCallback(oldState, newState, true);
      let recentDockAnimationEvent: RecentDockAnimationEvent =
        new RecentDockAnimationEvent(oldState, newState);
      EvtBus.post<RecentDockAnimationEvent>(RecentDockAnimationEvent, recentDockAnimationEvent);
      let continueItemAnimationEvent: ContinueItemAnimationEvent =
        new ContinueItemAnimationEvent(this.lastTripleFoldState.screenState, this.curTripleFoldState.screenState);
      EvtBus.post<ContinueItemAnimationEvent>(ContinueItemAnimationEvent, continueItemAnimationEvent);
      let deviceTypeIconAnimationEvent: DeviceTypeIconAnimationEvent = new DeviceTypeIconAnimationEvent();
      EvtBus.post<DeviceTypeIconAnimationEvent>(DeviceTypeIconAnimationEvent, deviceTypeIconAnimationEvent);
    }
    localEventManager.sendLocalEvent(EventConstants.EVENT_UPDATE_SCREEN_DATA);
    // 记忆能力仅用于MG状态切换
    if (this.curTripleFoldState.screenState !== ScreenState.F && this.lastTripleFoldState.screenState !== ScreenState.F) {
      let isSkipAnimation : boolean = this.skipFoldExpandAnimation();
      // 无动效开合场景，如负一屏开合，不做延迟下树处理
      if (!isSkipAnimation) {
        ThreeFoldExpandViewModel.getInstance().threeFoldExpandAfter();
      }
    }
  }

  private runFoldOrExpandAnimation(foldState: DeviceState): void {
    if (!this.skipFoldExpandAnimation()) {
      //Complete the layout update.
      animateTo({}, () => {
      });
      // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, StyleConstants.DEFAULT_1);
      if (foldState === DeviceState.EXPAND_STATE) {
        performanceMonitor.begin('FOLD_TO_EXPAND_DOCK_BACKGROUND_SCALE_TWO', performanceMonitor.ActionType.LAST_UP);
        SCBTransitionManager.getInstance().runExpandAnimationCallback();
      } else {
        performanceMonitor.begin('EXPAND_TO_FOLD_INDICATOR', performanceMonitor.ActionType.LAST_UP);
        SCBTransitionManager.getInstance().runFoldAnimationCallback();
      }
    }
  }

  // 刷新桌面布局
  private updateDesktopLayout(width: number, height: number, isPortrait: boolean): void {
    const isFoldStatus = (this.foldStatus === DeviceState.EXPAND_STATE);
    // 对于手机设备，强制使用竖屏尺寸进行布局计算
    let adjustedWidth = width;
    let adjustedHeight = height;
    if (DeviceHelper.isPhone() && width > height) {
      // 交换宽度和高度，确保使用竖屏尺寸
      adjustedWidth = height;
      adjustedHeight = width;
      log.showInfo(`updateDesktopLayout Phone device detected, swapping screen dimensions: width=${width},
        height=${height} -> adjustedWidth=${adjustedWidth}, adjustedHeight=${adjustedHeight}`);
    }
    //更新LayoutViewModel中的屏幕宽、高、展开状态信息，避免在LayoutRulesController中使用异常数据。
    LayoutViewModel.getInstance(this.singleContext).getBaseConfig().resetScreenSize(adjustedWidth, adjustedHeight, this.foldStatus);
    let layoutRulesController: PhoneLayoutRulesController = this.getLayoutController(isPortrait, isFoldStatus);
    if (launcherStatusUtil.getShowOutLauncherStatus() && this.mLayoutViewModel) {
      layoutRulesController = OuterPhoneLayoutRulesController.getInstance(this.mLayoutViewModel.getBaseConfig(), this.singleContext);
    }
    this.setDesktopWithScreenChange(layoutRulesController, adjustedWidth, adjustedHeight, this.foldStatus, isPortrait);
  }

  // 根据横竖屏方向，以及折叠状态，获取布局器
  private getLayoutController(isPortrait: boolean, isFoldStatus: boolean): PhoneLayoutRulesController {
    if (this.mLayoutViewModel === null) {
      log.showWarn(TAG, 'mLayoutViewModel is null');
      this.mLayoutViewModel = LayoutViewModel.getInstance(this.singleContext);
    }
    if (this.mDesktopViewModel.isPadUiType()) {
      if (isPortrait) {
        return VerticalPadLayoutRulesController.getInstance(this.mLayoutViewModel?.getBaseConfig(), this.singleContext);
      }
      return PadLayoutRulesController.getInstance(this.mLayoutViewModel?.getBaseConfig(), this.singleContext);
    }
    let isThreeFoldProduct = DeviceHelper.isThreeFoldProduct();
    let isGState = false;
    if (isThreeFoldProduct) {
      isGState = this.curTripleFoldState.screenState === ScreenState.G;
    }
    log.showInfo(`isExpand: ${isFoldStatus}, isThreeFoldProduct: ${isThreeFoldProduct}, isGState: ${
      isGState}, isPortrait: ${isPortrait}`);
    if (isFoldStatus) {
      if (isGState) {
        if (isPortrait) {
          log.showInfo(`useLayoutController --------> ThreeFoldPhoneLayoutRulesController`);
          return ThreeFoldPhoneLayoutRulesController.getInstance(this.mLayoutViewModel.getBaseConfig(), this.singleContext);
        }
        log.showInfo(`useLayoutController --------> HorizontalThreeFoldPhoneLayoutRulesController`);
        return HorizontalThreeFoldPhoneLayoutRulesController.getInstance(this.mLayoutViewModel.getBaseConfig(), this.singleContext);
      } else {
        if (isPortrait) {
          log.showInfo(`useLayoutController --------> FoldPhoneLayoutRulesController`);
          return FoldPhoneLayoutRulesController.getInstance(this.mLayoutViewModel.getBaseConfig(), this.singleContext);
        }
        log.showInfo(`useLayoutController --------> HorizontalFoldPhoneLayoutRulesController`);
        return HorizontalFoldPhoneLayoutRulesController.getInstance(this.mLayoutViewModel.getBaseConfig(), this.singleContext);
      }
    }
    log.showInfo(`useLayoutController --------> PhoneLayoutRulesController`);
    return PhoneLayoutRulesController.getInstance(this.mLayoutViewModel.getBaseConfig(), this.singleContext);
  }

  private updatePadLayoutRulesController(baseConfig: BaseConfig): void {
    if (this.isShowPcDockInPad) {
      this.mLayoutViewModel?.setLayoutRulesController(PadLayoutRulesController.getInstance(baseConfig, this.singleContext));
    } else {
      if (this.isPortrait(this.screenProp?.screenId)) {
        this.mLayoutViewModel?.setLayoutRulesController(VerticalPadLayoutRulesController.getInstance(baseConfig, this.singleContext));
      } else {
        this.mLayoutViewModel?.setLayoutRulesController(PadLayoutRulesController.getInstance(baseConfig, this.singleContext));
      }
    }
  }

  private onDockModeChange(): void {
    if (DeviceHelper.isThreeFoldProduct()) {
      this.mLayoutViewModel?.setLayoutRulesController(
        HorizontalThreeFoldPhoneLayoutRulesController
          .getInstance(LayoutViewModel.getInstance(this.singleContext).getBaseConfig()));
    } else {
      this.updatePadLayoutRulesController(LayoutViewModel.getInstance(this.singleContext).getBaseConfig());
    }
    SmartDockStyleConfig.getInstance().initConfig();
    if (!this.isShowPcDockInPad) {
      this.desktopContext?.eventHub.emit(SmartDockConstants.MULTI_WINDOW_EXIT_TRIGGER_RESHAPE_EVENT);
      log.showInfo(`MULTI_WINDOW_EXIT_TRIGGER_RESHAPE_EVENT emit`);
    }
  }

  /**
   * 折叠屏展开态下的是否竖屏判断，不使用 display.orientation 的原因，后者的状态刷新速度会慢一点
   * @param screenId
   * @returns isPortrait
   */
  private isPortrait(screenId: number): boolean {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenId);
    if (!screenSession) {
      log.showError('processOrientationUnrelatedToSensor screenSession is null');
      return true;
    }
    if (DeviceHelper.isPad()) {
      return SCBScreenSessionManager.getInstance().isScreenVertical(screenId);
    }
    // 非折叠屏展开态直接返回true
    if (!screenSession.isFoldablePhoneExpandStatus()) {
      return true;
    }
    return SCBScreenSessionManager.getInstance().isScreenVertical(screenId);
  }

  private skipFoldExpandAnimation(): boolean {
    // 锁屏显示、下拉搜索显示非滑动唤醒状态、窗口显示场景不走桌面开合动画，但是要记录位置
    if (viewMgrPolicy.isViewShowing(ViewType.KEYGUARD)) {
      log.showInfo('skipFoldExpandAnimation as ViewType.KEYGUARD is showing');
      return true;
    }
    if (this.scenePanelState === ScenePanelState.FULLSCENE) {
      log.showInfo('skipFoldExpandAnimation as ScenePanelState is FULLSCENE');
      return true;
    }
    let isExitNegativeScreen = sOutSideWindowMgr.getIsExitNegativeScreen();
    let isDoneShowingNegativeScreen =
      viewMgrPolicy.isViewShowing(ViewType.NEGATIVE_SCREEN) && sOutSideWindowMgr.isShowNegative() &&
        !isExitNegativeScreen;
    if (isDoneShowingNegativeScreen) {
      log.showInfo('skipFoldExpandAnimation because Negative Screen is done showing');
      return true;
    }
    let globalSearchStatus = sOutSideWindowMgr.getGlobalSearchStatus();
    let isShouldSkipGlobalSearch = viewMgrPolicy.isViewShowing(ViewType.GLOBAL_SEARCH) &&
      globalSearchStatus !== GlobalSearchStatus.WAKING &&
      globalSearchStatus !== GlobalSearchStatus.BACK_OUT && globalSearchStatus !== GlobalSearchStatus.HIDE;
    if (isShouldSkipGlobalSearch) {
      log.showInfo('skipFoldExpandAnimation when showing GlobalSearch');
      return true;
    }
    // 三屏桌面场景，手机竖屏情况下开合时，由于不涉及页面之间的变化，不应该走三屏
    if (PageInfoManager.getInstance().getMaxDisplayCount() === 3 && this.isNotExecuteThreeFoldExpandBefore()) {
      return true;
    }
    return false;
  }

  private isNotExecuteThreeFoldExpandBefore(): boolean {
    if (this.lastTripleFoldState.screenState === ScreenState.M && this.curTripleFoldState.screenState === ScreenState.G &&
      this.curTripleFoldState.orientation === ScreenOrientation.PORTRAIT) {
      return true;
    }
    if (this.lastTripleFoldState.screenState === ScreenState.G && this.curTripleFoldState.screenState === ScreenState.M &&
      this.lastTripleFoldState.orientation === ScreenOrientation.PORTRAIT) {
      return true;
    }
    return false;
  }

  private formRecycleHandlerWhenAppStart(sceneState: ScenePanelState): void {
    if (sceneState === ScenePanelState.FULLSCENE) {
      log.showInfo(`updateScenePanelState, sceneState:${sceneState}`);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_FORM_RECYCLE, true);
    } else if (sceneState === ScenePanelState.HOME ||
      sceneState === ScenePanelState.FLOAT_SCENE ||
      sceneState === ScenePanelState.SPLIT) {
      log.showInfo(`updateScenePanelState, sceneState:${sceneState}`);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_FORM_RECYCLE, false);
    }
  }

  private windowSceneStateChange(): void {
    ThemeServiceHelper.getInstance().onWindowSceneStateChange(this.scenePanelState);
  }

  private onScenePanelStateChange(): void {
    AppStorage.setOrCreate('onDeskTopState', this.scenePanelState);
    AppStorage.setOrCreate('showUninstallDialog', false);
    log.showInfo(`scenePanelState change ${this.scenePanelState}`);
    this.windowSceneStateChange();
    this.formRecycleHandlerWhenAppStart(this.scenePanelState);
    this.mViewManager.closeFormServiceAndManagerView();
    // 切换到主页和多任务之外的页面时退出编辑模式
    if (this.scenePanelState !== ScenePanelState.HOME && this.scenePanelState !== ScenePanelState.RECENT) {
      if (editModeManager.isInEditMode()) {
        editModeManager.changeDesktopMode(DesktopMode.NORMAL_MODE, HiEditModeDataExitType.EXIT_FULLY_OCCLUSION);
      }
      localEventManager.sendLocalEventAsync(EventConstants.EVENT_EDIT_MODE_TOUCH_DOWN_ITEM);
    }
    // 非主页场景，重置空间感模糊拦截
    if (this.scenePanelState !== ScenePanelState.HOME) {
      SCBScenePanelManager.getInstance().setForegroundBlurActive(false);
      this.closedEditModeGuidePage();
    }
  }

  private setDesktopWithScreenChange(layoutRulesController: PhoneLayoutRulesController,
    width: number, height: number, foldStatus: number, isPortrait: boolean): void {
    // 对于手机设备，强制使用竖屏尺寸
    let adjustedWidth = width;
    let adjustedHeight = height;
    if (DeviceHelper.isPhone() && width > height) {
      // 交换宽度和高度，确保使用竖屏尺寸
      adjustedWidth = height;
      adjustedHeight = width;
      log.showInfo(`setDesktopWithScreenChange Phone device detected, swapping screen dimensions in setDesktopWithScreenChange: width=${width},
        height=${height} -> adjustedWidth=${adjustedWidth}, adjustedHeight=${adjustedHeight}`);
    }

    log.showInfo(`screenChange isExpand ${foldStatus}  width  ${adjustedWidth}  screen height ${adjustedHeight} `);
    let area: ViewArea = {
      left: 0,
      top: 0,
      width: px2vp(adjustedWidth),
      height: px2vp(adjustedHeight),
    };
    this.viewController.updateRect(area);
    this.viewController.updateArea(area);
    // Quit edit mode when fold status change
    if (editModeManager.isInEditMode()) {
      editModeManager.changeDesktopMode(DesktopMode.NORMAL_MODE, HiEditModeDataExitType.EXIT_SCREEN_CHANGE);
    }
    if (!this.isOuterDesktop) {
      folderLayoutUtil.initFolderLayoutConfig();
    }
    this.mLayoutViewModel?.setLayoutRulesController(layoutRulesController);
    this.mLayoutViewModel?.refreshConfig(adjustedWidth, adjustedHeight, foldStatus, isPortrait, this.mDesktopViewModel?.getDesktopModel());
    this.getWindowSize(adjustedWidth, adjustedHeight);
    this.updateScreenInfo();
    this.updateDesktopFontSize();
  }

  private updateDesktopFontSize(): void {
    desktopFontScaleManager.setRealDesktopFontScale();
  }

  private isNeedKeepEditMode(): boolean {
    return !editModeManager.isInEditMode() || ScenePanelState.HOME === this.scenePanelState ||
      ScenePanelState.SPLIT === this.scenePanelState || ScenePanelState.FLOAT_SCENE === this.scenePanelState;
  }

  private homeGestureHandler(): void {
    log.showInfo('desktopProcess  HOME_GESTURE_EVENT this.persistentId =' + this.persistentId);
    // 打断添加卡片动效
    this.desktopContext?.eventHub.emit(CommonConstants.CANCEL_ADD_FORM_ANIMATION);
    if (this.mViewManager.isDesktopNeedProcessGesture()) {
      if (this.openFolderFlag || this.openSmallFolderFlag) {
        const openFolderId: string = AppStorage.get('openFolderId') as string;
        this.mBigFolderViewModel?.getFolderAppList(openFolderId).then(() => {
          if (!this.mFolderModel) {
            return;
          }
        });
      }
      this.mBigFolderViewModel?.setCloseType(FolderCloseType.HOME_GESTURE);
      log.showInfo('raiseAnimateToSchedulePriority:close folder start');
      AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
      this.mViewManager.closeOpenFolderStatus();
      this.mViewManager.closeFormStackEditView();
      this.mViewManager.closeOuterStackMenu();
      SCBDesktopAddViewModel.getInstance().closeDesktopAddDialog();
    }
    FormCenterViewManager.getInstance().formCenterHomeGestureHandler();
    if (editModeManager.isInEditMode() && !MultiSelectManager.getInstance().getStatus().inGatherOrDragOrDrop) {
      editModeManager.changeDesktopMode(DesktopMode.NORMAL_MODE, HiEditModeDataExitType.EXIT_GESTURE);
    }
    // 上滑手势关闭文件夹+弹窗
    localEventManager.sendLocalEventAsync(EventConstants.EVENT_EDIT_MODE_TOUCH_DOWN_ITEM);
    this.closedEditModeGuidePage();
  }

  private backGestureHandler(): void {
    // 打断添加卡片动效
    this.desktopContext?.eventHub.emit(CommonConstants.CANCEL_ADD_FORM_ANIMATION);
    const isOpenFolder: boolean = FolderManager.getInstance().isFolderOpen();
    const isAddDialogOpening: boolean = folderGesData.isAddDialogOpening();
    if (!OuterIconCenterViewManager.getInstance().isOuterIconCenterViewShowing() &&
      !isOpenFolder && !isAddDialogOpening &&
      !AppStorage.get('formManageShow') &&
      !AppStorage.get('formServiceShow') &&
      !FormCenterViewManager.getInstance().isFormCenterViewShowing() &&
      editModeManager.isInEditMode()) {
      if (this.isShowingUninstallDialog === UninstallDialogStatus.CONFIRM_STATE) {
        this.desktopContext?.eventHub.emit('EditMode_Close_Dialog');
        return;
      }
      this.editModeViewEvent.backGestureHandler();
    } else {
      log.showInfo(
        `openFolderStatus: ${AppStorage.get('openFolderStatus') === CommonConstants.OPEN_FOLDER_STATUS_CLOSE} ` +
        `formManageShow: ${AppStorage.get('formManageShow')} ` +
        `formServiceShow: ${AppStorage.get('formServiceShow')} ` +
        `isFormManagerViewShowing: ${FormCenterViewManager.getInstance().isFormManagerViewShowing()} ` +
        `isFormCenterViewShowing： ${!FormCenterViewManager.getInstance().isFormCenterViewShowing()} ` +
        `isInEditMode:${editModeManager.isInEditMode()} `
      )
    }
    if (this.mViewManager.isDesktopNeedProcessGesture()) {
      log.showInfo('desktopProcess BACK_GESTURE_EVENT');
      this.mBigFolderViewModel?.setCloseType(FolderCloseType.BACK_GESTURE);
      AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
      this.mViewManager.closeOpenFolderStatus();
      this.mViewManager.closeFormStackEditView();
      this.mViewManager.closeOuterStackMenu();
    }
      FormCenterViewManager.getInstance().formCenterBackGestureHandler();
    AppStorage.setOrCreate('overlayMode', CommonConstants.OVERLAY_TYPE_HIDE);
    this.closedEditModeGuidePage();
    SCBDesktopAddViewModel.getInstance().closeDesktopAddDialog();
  }

  /**
   * 进入多任务页面后事件处理
   */
  private enterRecentHandler(): void {
    log.showInfo('desktopProcess  ENTER_RECENT_EVENT');
    AppStorage.setOrCreate('createNewFolder', false);
    localEventManager.sendLocalEvent(EventConstants.EVENT_FOLDER_ADD_SHEET_REQUEST_CLOSE);
    if (this.mViewManager.isDesktopNeedProcessGesture()) {
      this.mViewManager.closeFormStackEditView();
    }
    if (!editModeManager.isInEditMode()) {
      FormCenterViewManager.getInstance().formCenterHomeGestureHandler();
    }
    this.closedEditModeGuidePage();
  }

  registerGestureCallback() {
    viewMgrPolicy.onGestureCallback(SCBEventId.HOME_GESTURE_EVENT, this.persistentId,
      () => this.homeGestureHandler());
    viewMgrPolicy.onGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId,
      () => this.backGestureHandler());
    viewMgrPolicy.onGestureCallback(SCBEventId.ENTER_RECENT_EVENT, this.persistentId,
      () => this.enterRecentHandler());

    sOutSideWindowMgr.registerDesktopPageChangeListener(TAG, this);
    sOutSideWindowMgr.registerDesktopParamListener(TAG, this);
    sOutSideWindowMgr.registerNegativeProgressListener(TAG, this);
  }

  onDesktopAnimateScaleChanged(scale: number, msg: string): void {
    log.showWarn(`onDesktopAnimateScaleChanged changeScale to ${scale}, due to:${msg}`);
    this.pageDesktopScaleModifier.attribute?.scale({
      x: scale,
      y: scale,
      centerX: this.screenWidth / 2,
      centerY: this.screenHeight / 2
    });
    this.smartDockScaleModifier.attribute?.scale({
      x: scale,
      y: scale,
      centerX: this.screenWidth / 2,
      centerY: -this.screenHeight / 2
    });
    this.animateScale = scale;
  }

  getAnimateScale(): number {
    return this.animateScale;
  }

  onDesktopEnableChanged(enabled: boolean, tag?: string): void {
    if (this.isDesktopEnabled !== enabled) {
      log.showInfo(`onDesktopEnableChanged setDesktopEnabled:${enabled} from ${tag}`);
      this.isDesktopEnabled = enabled;
    }
  }

  onProgressChange(progress: number): void {
    this.negativeProgress = progress;
  }

  onGlobalSearchTranslateYChange(translateY: number): void {
    log.showInfo(`onGlobalSearchTranslateYChange translateY: ${translateY}`);
    this.globalSearchTranslateY = translateY;
  }

  onIsHidingGlobalSearchChange(isHidingGlobalSearch: boolean): void {
    log.showInfo(`onIsHidingGlobalSearchChange isHidingGlobalSearch: ${isHidingGlobalSearch}`);
    this.isHidingGlobalSearch = isHidingGlobalSearch;
  }

  getValueWithProgress(progress: number, startValue: number, endValue: number): number {
    if (progress < 0) {
      return startValue;
    }
    return startValue + (endValue - startValue) * progress;
  }

  private needZoomIn(): boolean {
    if (sOutSideWindowMgr.isShowGlobalSearch()) {
      log.showDebug('onActive, Global search showing return.');
      return false;
    }
    if (sOutSideWindowMgr.isShowNegative()) {
      log.showInfo('negative showing. return');
      return false;
    }
    if (!this.isCouldChangePageScale()) {
      return false;
    }
    if (screenLockStateManager.currentState !== ScreenLockState.EXIT_KEYGUARD) {
      log.showInfo('in screenLock. return');
      return false;
    }
    return true;
  }

  private onActive(): void {
    if (!this.needZoomIn()) {
      return;
    }
    if (CommonUtils.equals(this.animateScale, CommonConstants.DESKTOP_ANIMATE_SCALE)) {
      log.showInfo(`onActive the animateScale is ${CommonConstants.DESKTOP_ANIMATE_SCALE} return`);
      return;
    }
    // 解决响应时延问题，取消桌面缩放动效
    // animateTo({
    //   curve: curves.springMotion(0.26, 1.157, 0),
    // }, () => {
      this.onDesktopAnimateScaleChanged(CommonConstants.DESKTOP_ANIMATE_SCALE, 'onActive');
    // })
  }

  private onInactive(infoMsg: string = '', delayTime: number = 0): void {
    SCBDesktopCacheManager.getInstance().checkRotation();
    if (sOutSideWindowMgr.isShowGlobalSearch()) {
      log.showInfo('onInactive, Global search showing. return');
      return;
    }
    if (sOutSideWindowMgr.isShowNegative()) {
      log.showInfo('negative showing. return');
      return;
    }
    if (!this.isCouldChangePageScale()) {
      return;
    }
    this.getUIContext().animateTo({
      curve: curves.springMotion(0.5, 0.825, 0),
      delay: delayTime
    }, () => {
      this.onDesktopAnimateScaleChanged(1.0, 'onInactive');
    })
  }

  private onActiveWithNoAnim(): void {
    if (!this.needZoomIn()) {
      return;
    }
    log.showDebug('onActiveWithNoAnim');
    this.onDesktopAnimateScaleChanged(CommonConstants.DESKTOP_ANIMATE_SCALE, 'onActiveWithNoAnim');
  }

  // listening the keyguard hide event
  private onkeyguardViewHide(): void {
    log.showInfo('onkeyguardViewHide');
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE, true);
    if (this.isCouldChangePageScale() && this.scenePanelState !== ScenePanelState.FULLSCENE) {
      this.onDesktopAnimateScaleChanged(1.0, 'onkeyguardViewHide');
    }
    log.showInfo(TraceUtil.CORE_METHOD_INTO_LAUNCHER);
    performanceMonitor.end(HiSysEventUtil.INTO_HOME_ANI);
    TraceUtil.traceOnce(DomainName.HOME, TraceUtil.CORE_METHOD_INTO_LAUNCHER);
    HiSysEventUtil.reportUnlockEnterDesktop(HiSysEventUtil.INTO_HOME_KEY,
      PageDesktopModel.getInstance().getPageIndex());
  }

  // listening the keyguard show event
  private onkeyguardViewShow(): void {
    log.showInfo('onkeyguardViewShow');
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE, false);
    AppStorage.setOrCreate('lockReceived', Date.now());
    if (editModeManager.isInEditMode()) { //锁屏退出编辑模式
      editModeManager.changeDesktopMode(DesktopMode.NORMAL_MODE, HiEditModeDataExitType.EXIT_SCREEN_OFF);
      editModeViewManager.notifyWhiteBoxShowOrHide(true);
    }
    let scenePanelState: ScenePanelState | undefined = AppStorage.get('scenePanelState');
    if (scenePanelState === ScenePanelState.HOME) {
      log.showInfo('onkeyguardViewShow scenePanelState is home');
      ContractedFolderCommonViewModel.getInstance()
        .closeFolder('close folder by lock screen', FolderOperationFlag.IMMEDIATELY);
      // 锁屏关闭文件夹+弹窗
      localEventManager.sendLocalEventAsync(EventConstants.EVENT_EDIT_MODE_TOUCH_DOWN_ITEM);
    }
    this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_INVISIBLE_STATE);
  }

  // obtain whether assistant is on from local storage
  getAssistantFlagFromStore(): void {
    let context = getContext()?.getApplicationContext() || GlobalContext.getContext();
    const storage = dataStorage.getStorageSync(context?.databaseDir + '/LauncherPreference');
    const assistantIsOnInStore = storage.getSync('assistantIsOn', 1);
    this.assistantIsOn = assistantIsOnInStore !== 0;
  }

  registerPageDesktopEvent(listener: Object): void {
    localEventManager.registerEventListener(listener, [EventConstants.EVENT_NAVIGATOR_BAR_STATUS_CHANGE,
      EventConstants.EVENT_FLOAT_ON_FOCUS, EventConstants.EVENT_EDIT_MODE_EXIT, 'desktopIconChangeSize',
      EventConstants.EVENT_PC_DOCK_CONVERT_TO_BIG_STATUS_CHANGE,
      EventConstants.EVENT_PC_DOCK_CONVERT_TO_BIG_FOLDER_ID_CHANGE,
      EventConstants.EVENT_DESKTOP_MODE_CHANGE
    ]);
  }

  private readonly mLocalEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: string) => {
      log.showWarn(`receive event: ${event}, params: ${params}`);
      if (event === EventConstants.EVENT_NAVIGATOR_BAR_STATUS_CHANGE) {
        this.navigationBarStatus = params;
        this.updateScreenInfo();
      } else if (event === EventConstants.EVENT_FLOAT_ON_FOCUS) {
        log.showError(`receive event: ${event}, params: ${params}`);
        AppStorage.setOrCreate('showUninstallDialog', false);
        ContextMenu.close();
      } else if (event === EventConstants.EVENT_EDIT_MODE_EXIT) {
        if (editModeManager.isInEditMode()) {
          editModeManager.changeDesktopMode(DesktopMode.NORMAL_MODE, HiEditModeDataExitType.EXIT_BLANK_CLICKED);
        }
      } else if (event === 'desktopIconChangeSize') {
        this.changeDesktopIconSize(params);
      } else if (event === EventConstants.EVENT_PC_DOCK_CONVERT_TO_BIG_STATUS_CHANGE) {
        if (params === undefined || params === null) {
          return;
        }
        try {
          this.startConvert = parseInt(params);
        } catch (error) {
          log.showError(`parseInt params: ${params} error`);
        }
      } else if (event === EventConstants.EVENT_PC_DOCK_CONVERT_TO_BIG_FOLDER_ID_CHANGE) {
        if (params === undefined || params === null) {
          return;
        }
        this.convertFolderId = params;
      } else if (event === EventConstants.EVENT_DESKTOP_MODE_CHANGE && this.mLayoutViewModel) {
        if (params === undefined || params === null) {
          return;
        }
        let layoutRulesController: PhoneLayoutRulesController = (Number(params) === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) ?
          SimplePhoneLayoutRulesController.getInstance(this.mLayoutViewModel.getBaseConfig(), this.singleContext) :
          PhoneLayoutRulesController.getInstance(this.mLayoutViewModel.getBaseConfig(), this.singleContext);
        this.mLayoutViewModel.setLayoutRulesController(layoutRulesController);
        this.setDesktopWithScreenChange(layoutRulesController, this.screenProp.width, this.screenProp.height, this.foldStatus, true);
      }
    }
  };

  registerDesktopLongPressIconMenuShowEvent(listener: Object): void {
    localEventManager.registerEventListener(listener, [EventConstants.EVENT_DESKTOP_MENU_EVENT]);
  }

  changeDesktopIconSize(params: string) {
    AppStorage.setOrCreate<number>('settingIconChange', Number(params));
    desktopFontScaleManager.setRealDesktopFontScale();
    this.mLayoutViewModel?.refreshConfigOnIconChange();
    this.updateScreenSize();
    PhonePageDesktopGridStyleConfig.getInstance().initConfig();
    FormStyleConfig.getInstance().initConfig();
    FolderStyleManager.getInstance().initConfig();
    SmartDockStyleConfig.setInPreviewMode(false);
    OpenFolderStyleConfig.getInstance().initConfig();
    folderLayoutUtil.initFolderLayoutConfig();
    if (this.pageDesktopGridStyleConfig) {
      this.desktopParam.iconSize = this.pageDesktopGridStyleConfig.mIconSize;
    }
    log.showInfo('changeDesktopIconSize desktopIconChange');
    AppStorage.setOrCreate<number>('desktopIconChange', Number(params));
    (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).eventHub.emit(
      SmartDockConstants.ICON_SIZE_CHANGE_EVENT);

    QuitAppRectViewModel.getInstance().initSwiperParam(this.screenWidth);
    let pageDesktopViewModel = PageDesktopViewModel.getInstance();
    BaseQuitAppRect.getInstance().initGridParamDesktop(pageDesktopViewModel.getPageDesktopStyleConfig(),
      pageDesktopViewModel.getGridConfig());
    BaseQuitAppRect.getInstance().initGridParamOpenFolder(this.screenWidth,
      this.screenHeight, FolderStyleManager.getInstance().getFolderStyleConfig());
    this.desktopContext?.eventHub.emit(FolderConstants.OPEN_FOLDER_ICON_RADIUS_CHANGE,
      BigFolderStyleConfig.getInstance().mFolderIconRadius);
  }

  private readonly mIconMenuEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: number) => {
      log.showInfo(`receive event: ${event}, params: ${params}`);
      if (event === EventConstants.EVENT_DESKTOP_MENU_EVENT) {
        this.doDesktopScaleAnimate(params);
      }
    }
  };

  /**
   * EventHub
   * 订阅EVENT_ONE_STEP_SPLIT事件
   */
  onEventHub() {
    log.showInfo(`listen on screen split`);
    this.mDesktopContext.eventHub.on(this.EVENT_ONE_STEP_SPLIT,
      (onestepsplitData: OneStepSplitData): void => this.handleStepSplit(onestepsplitData));
  }

  /**
   * 亮灭屏事件
   */
  private registerUnlockTransitionController(): void {
    this.unLockTransitionController = {
      name: ``,
      onLock: (): void => this.onLockReceived(),
      onUnlock: (): void => this.onUnLockReceived(),
      onUnlockStartScene: (): void => this.onUnLockReceivedPrepare(),
    }
    SCBSceneSessionManager.getInstance().registerUnlockTransitionCallback(this.unLockTransitionController);
  }

  private onUnLockReceivedPrepare = () => {
    // 前台没有应用且桌面scale不为1时，提前将桌面scale还原
    if (this.animateScale !== DEFAULT_SCALE && this.scenePanelState !== ScenePanelState.FULLSCENE) {
      this.onDesktopAnimateScaleChanged(1.0, 'onUnLockReceivedPrepare');
    }
  };

  private onLockReceived = () => {
    this.isLock = true;
    this.handleStepSplit(new OneStepSplitData());
  };

  private onUnLockReceived = () => {
    if (AppStorage.get<boolean>('shieldAnim') ?? false) {
      this.shieldAnimViewModel = new ShieldAnimViewModel();
      this.shieldAnimParam = this.shieldAnimViewModel.getShieldAnimParam();
      this.shieldAnimViewModel.onUnLockReceived();
    } else {
      this.shieldAnimViewModel = undefined;
      this.shieldAnimParam = undefined;
    }
    this.isLock = false;
    SCBTransitionManager.getInstance().setStartExitAnimationCount(0, 'unLock init');
    if (!this.needZoomIn()) {
      return;
    }
    if (SCBSceneSessionManager.getInstance().isResetDesktopScale()) {
      this.onDesktopAnimateScaleChanged(CommonConstants.DESKTOP_ANIMATE_SCALE, 'onUnLockReceived');
    }
  };

  /**
   * 处理EventHub事件
   */
  handleStepSplit(onestepsplitData: OneStepSplitData) {
    let splitStatus: number = onestepsplitData.splitStatus;
    let direction: number = onestepsplitData.direction;
    let distance: number = onestepsplitData.distance;
    let needAnim: boolean = onestepsplitData.needAnim;
    log.showInfo(`OneStepSplitData start: ${splitStatus}, ${direction}, ${distance}, ${needAnim}`);
    if (direction !== CommonConstants.SPLIT_LEFT_DIRECTION || this.isLock) {
      distance = 0;
    }
    if (this.preSplitStatus === splitStatus && this.preDirection === direction && this.preDistance === distance) {
      log.showInfo(`handleStepSplitData is the same as before;`);
      return;
    }
    if (distance > 0) {
      this.isScreenSplit = true;
      AppStorage.setOrCreate('isScreenSplit', true);
    } else {
      this.isScreenSplit = false;
      AppStorage.setOrCreate('isScreenSplit', false);
    }
    if ((AppStorage.get('folderStatus') ?? DeviceState.DEFAULT_STATE) as number === DeviceState.DEFAULT_STATE) {
      return;
    }
    this.preSplitStatus = splitStatus;
    this.preDirection = direction;
    this.preDistance = distance;
    this.doSplitAvoid(distance, needAnim);
  }

  private folderStatusChange(): void {
    log.showInfo(`isScreenSplit = ${this.isScreenSplit}`);
    if (!this.isScreenSplit) {
      return;
    }
    if ((AppStorage.get('folderStatus') ?? DeviceState.DEFAULT_STATE) as number === DeviceState.DEFAULT_STATE) {
      this.doSplitAvoid(CommonConstants.SPLIT_FOLDED_DISTANCE)
    } else {
      this.doSplitAvoid(CommonConstants.SPLIT_EXPAND_DISTANCE);
    }
  }

  private doSplitAvoid(distance: number, needAnim: boolean = true) {
    if (needAnim) {
       animateTo({
         curve: Curve.Friction,
         duration: 400
       }, () => {
         this.translateXForScreenSplit = distance + CommonConstants.SPLIT_LEFT_PADDING - px2vp(96) > 0 ?
           distance + CommonConstants.SPLIT_LEFT_PADDING - px2vp(96) : 0;
       })
    } else {
      this.translateXForScreenSplit = distance + CommonConstants.SPLIT_LEFT_PADDING - px2vp(96) > 0 ?
        distance + CommonConstants.SPLIT_LEFT_PADDING - px2vp(96) : 0;
    }
    AppStorage.setOrCreate('translateXForScreenSplit', this.translateXForScreenSplit);
    log.showInfo(`OneStepSplitData end:  ${this.translateXForScreenSplit}`);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    UIContextHelper.delContext(this.screenProp?.screenId);
    this.mDesktopViewModel.closeFolderImmediately();
    this.desktopContext?.eventHub.off(SCBConstants.DESKTOP_IS_FREEZE);
    this.destroyWallpaperSubscriber();
    SCBSceneSessionManager.getInstance().unregisterUnlockTransitionCallback(this.unLockTransitionController);
    viewMgrPolicy.unRegisterViewCallback(ViewType.KEYGUARD, this.keyguardViewCallback);
    viewMgrPolicy.unRegisterViewCallback(ViewType.DESKTOP, this.desktopFocusCallback);
    viewMgrPolicy.unRegisterViewCallback('SCBThemeEditor', this.themeEditViewCallback);
    viewMgrPolicy.unregisterViewController(ViewType.DESKTOP);
    viewMgrPolicy.unRegisterViewCallback(ViewType.DESKTOP, this.desktopClearCallback);
    localEventManager.unregisterEventListener(this.mLocalEventListener)
    localEventManager.unregisterEventListener(this.mIconMenuEventListener);
    ThemeStyleManager.getInstance().unregisterThemeEvent();
    ThemeStyleManager.getInstance().unRegisterThemeCallBack();
    if (desktopUtil.isSupportSimpleMode()) {
      this.mDesktopViewModel.unRegisterLauncherModelChangeListener();
    }
    this.editModeViewEvent.unRegisterEvent();
    WorkSchedulerManager.getInstance().unRegisterReport(this.reportInformation);
    WorkSchedulerManager.getInstance().unRegisterReport(this.reportFolderInformation);
    WorkSchedulerManager.getInstance().unRegisterReport(this.reportEmptyGridInfo);
    WorkSchedulerManager.getInstance().unRegisterReport(this.reportIconGridInfo);
    WorkSchedulerManager.getInstance().unRegisterReport(this.reportShortcutInfo);
    WorkSchedulerManager.getInstance().unRegisterReport(this.reportSystemSceneState);
    WorkSchedulerManager.unRegisterDelayTask(ReportWorkSchedulerExtensionAbility.getWorkInfo());
    if (DeviceHelper.isPad() || DeviceHelper.isThreeFoldProduct()) {
      this.mMultiInputViewModel?.unregisterEventListener();
      multiInputManager.unRegisterPadInputEvent();
    }
    if (DeviceHelper.isPad()) {
      StatusBarServiceEventMgr.getInstance().unregisterStatusBarServiceEventListener();
    }
    this.eventMgr.offAll();
    WallpaperManager.getInstance().removeWallpaperChangeListener(this.wallPaperChange);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(
      this.screenPropertyChangeCallbackFunc, undefined, false, this.persistentId);
    this.unregisterHideDesktop();
    this.unregisterCacheDesktop();

    formStackItemViewManager.unregisterFormStackItemView(FormStackItemViewType.FORM_COMPONENT);

    FolderActionLifeCycleEventManager.getInstance().unregister(this.mOpenCloseCallback);
    folderGesData.unregisterCallback();
    this.mDesktopContext.eventHub.off(this.EVENT_ONE_STEP_SPLIT);
    SCBTransitionManager.getInstance().unRegisterUnlockSpaceAniListener();
    SCBSceneSessionManager.getInstance().unregisterExternalScreenInterceptorCallback();
    GameEventListener.getInstance().destroySubscribe();
    AppInstallRegister.unRegister('phone');
    launcherVisualEffectMgr.unRegisterRecentBlurEvent();
    launcherVisualEffectMgr.unRegisterFolderFullBlurEvent();
    launcherVisualEffectMgr.unRegisterIconStartExitBlurEvent();
    screenLockStateManager.unregisterScreenLockState(this.screenLockListener);
    if (DeviceHelper.isFold()) {
      try {
        display.off('foldAngleChange', this.onFoldAngleChange);
      } catch (err) {
        log.showError(`off foldAngleChange error, code:${err?.code}, message:${err?.message}`);
      }
    }
    this.unRegisterScreenStateMonitor();
    SCBSingleHandController.getInstance().unregisterSingleHandStatusChangeCallback(TAG);
    SCBSingleHandController.getInstance().unregisterSingleHandAnimationFinishCallBack(TAG);
    this.appIconConfigManager.unregisterBadgeKeyObserver();
    DesktopManager.getInstance().unregisterInitCallback();
    this.unregisterUpdateFontColor();
    this.mCloudExpandDialogMgr?.unregisterCloudModeMonitor();
    LightOutdoorConfig.getInstance().unRegisterLightOutdoorModeChangeListener(TAG);
  }

  private unRegisterScreenStateMonitor(): void {
    if (DeviceHelper.isThreeFoldProduct()) {
      ThreeFoldRotateViewModel.getInstance().unRegisterThreeFoldRotateCallback();
      ScreenStateMonitor.getInstance().unRegisterScreeStateChangeListener(TAG);
    }
}

  private updateScreenInfo(): void {
    log.showDebug('updateScreenInfo');
    if (this.screenWidth !== 0 && this.screenHeight !== 0) {
      this.mLayoutViewModel?.initScreen(this.navigationBarStatus);
      if (!this.isOuterDesktop) {
        SmartDockStyleConfig.getInstance().initConfig();
      }
      PhonePageDesktopGridStyleConfig.getInstance().initConfig();
      FormStyleConfig.getInstance().initConfig();
      if (!this.isOuterDesktop) {
        OpenFolderStyleConfig.getInstance().initConfig();
        FolderStyleManager.getInstance().initConfig();
      }
      if (editModeManager.isInEditMode()) {
        editModeManager.changeDesktopMode(DesktopMode.NORMAL_MODE, HiEditModeDataExitType.EXIT_SCREEN_CHANGE);
      }
      this.updateScreenSize();
      this.onDesktopAnimateScaleChanged(this.animateScale, 'updateScreenInfo');
    }
  }

  private getWindowSize(width?: number, height?: number): void {
    try {
      let realWidth = width ? width : this.screenProp.width;
      let realHeight = height ? height : this.screenProp.height;

      // 对于手机设备，强制使用竖屏尺寸
      if (DeviceHelper.isPhone() && realWidth > realHeight) {
        // 交换宽度和高度，确保使用竖屏尺寸
        const temp = realWidth;
        realWidth = realHeight;
        realHeight = temp;
        log.showInfo(`getWindowSize Phone device detected, swapping screen dimensions in getWindowSize: width=${width},
          height=${height} -> realWidth=${realWidth}, realHeight=${realHeight}`);
      }

      this.screenWidth = this.getUIContext().px2vp(realWidth);
      this.screenHeight = this.getUIContext().px2vp(realHeight);
      log.showInfo(`screenWidth: ${this.screenWidth}, screenHeight: ${this.screenHeight}`);
      AppStorage.setOrCreate('recentScreenWidth', this.screenWidth);
      AppStorage.setOrCreate('recentScreenHeight', this.screenHeight);
      AppStorage.setOrCreate('screenWidth', this.screenWidth);
      AppStorage.setOrCreate('screenHeight', this.screenHeight);
    } catch (error) {
      log.showError(`getWindowWidth or getWindowHeight error: ${error}`);
      AppStorage.setOrCreate('screenWidth', 0);
      AppStorage.setOrCreate('screenHeight', 0);
    }
  }

  private updateScreenSize(): void {
    this.workSpaceWidth = this.screenWidth;
    if (this.mLayoutViewModel) {
      this.workSpaceHeight = this.mLayoutViewModel.getWorkSpaceHeight();
      log.showInfo(`mLayoutViewModel workSpaceHeight:${this.workSpaceHeight}`);
      this.dockHeight = this.mLayoutViewModel.getDockHeight();
    }
    AppStorage.setOrCreate('workSpaceWidth', this.workSpaceWidth);
    AppStorage.setOrCreate('workSpaceHeight', this.workSpaceHeight);
    AppStorage.setOrCreate('dockHeight', this.dockHeight);
    this.desktopParam.dockHeight = this.dockHeight;
    this.desktopParam.workSpaceHeight = this.workSpaceHeight;
    this.desktopParam.workSpaceWidth = this.workSpaceWidth;
    log.showInfo(' updateScreenSize screenWidth: ' + this.screenWidth +
      ', screenHeight: ' + this.screenHeight + ', workSpaceWidth: ' + this.workSpaceWidth + ', workSpaceHeight: ' +
      this.workSpaceHeight + ', dockHeight: ' + this.dockHeight);
  }

  private doFollowAnimate(scale: number): void {
    if (sOutSideWindowMgr.isShowGlobalSearch() || sOutSideWindowMgr.isShowNegative()) {
      log.showInfo('doFollowAnimate, Global search or Negative Screen showing return.');
      return;
    }
    if (editModeViewManager.isDisableFollowAnimateInEditMode()) {
      log.showInfo('doFollowAnimate, editMode modal dialog showing return.');
      return;
    }
    if (!this.isCouldChangePageScale()) {
      return;
    }
    if (!CommonUtils.equals(this.animateScale, scale)) {
      log.showInfo('doFollowAnimate scale:%{public}d', scale);
      animateToImmediately({
        curve: curves.springMotion(0.15, 0.86, 0.25)
      }, () => {
        this.onDesktopAnimateScaleChanged(scale, 'doFollowAnimate');
      })
    }
  }

  private doBackHomeAnimate(scale: number): void {
    if (sOutSideWindowMgr.isShowGlobalSearch()) {
      log.showInfo('doFollowAnimate, Global search showing return.');
      return;
    }
    if (!this.isCouldChangePageScale()) {
      return;
    }
    if (!CommonUtils.equals(this.animateScale, scale)) {
      log.showInfo('doBackHomeAnimate scale:%{public}d', scale);
      animateTo({
        curve: curves.springMotion(0.55, 0.99, 0.25)
      }, () => {
        this.onDesktopAnimateScaleChanged(scale, 'doBackHomeAnimate');
      })
    }
  }

  // desktop animation: long press to show menu
  private doDesktopScaleAnimate(scale: number): void {
    log.showInfo(`doDesktopScaleAnimate, scale: ${scale}`);
    if (!this.isCouldChangePageScale()) {
      return;
    }
    if (!DeviceHelper.isPhone()) {
      return;
    }
    if (this.animateScale === scale) {
      return;
    }
    animateTo({
      duration: 250,
      curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1),
    }, () => {
      this.onDesktopAnimateScaleChanged(scale, 'long press to show menu');
    })
  }

  private isCouldChangePageScale(): boolean {
    if (FolderManager.getInstance().isFolderOpen()) {
      log.showWarn('opening folder. do not change page scale');
      return false;
    }
    return true;
  }

  // listen the assistant status
  assistantButtonChange(): void {}

  private themeEventCallBack(isIconsActivate: boolean): void {
    if (!isIconsActivate) {
      log.showWarn('ThemeEventCallBack no icons or home activate.');
      return;
    }

    let theme = ThemeStyleManager.getInstance().loadThemeStyle();
    ThemeStyleManager.getInstance().setIconThemeInfo();
    ThemeStyleManager.getInstance().isStyleChangedFromThemeEvent = true;
    PhonePageDesktopGridStyleConfig.getInstance().initConfig();
    BigFolderStyleConfig.setInPreviewMode(false);
    SmallFolderStyleConfig.setInPreviewMode(false);
    SmartDockStyleConfig.setInPreviewMode(false);
    FormStyleConfig.getInstance().initConfig();
    OpenFolderStyleConfig.getInstance().initConfig();
    AppStorage.setOrCreate<string>('themeStyle', theme);
  }

  private wallPaperChange: WallpaperChangeListener = {
    registeredTag: TAG,
    listenerType: WallpaperType.ALL,
    onWallPaperChange: (event: ThemeActivationEvent) => {
      log.showInfo(`WallPaper Change target:${event.target}`);
      this.updateBrightness(true);
      if (event.target & ThemeActivationTarget.HOME) {
        SCBDesktopCacheManager.getInstance().wallpaperChanging(true);
        SCBDesktopCacheManager.getInstance().removeWallPaperEvent(SCBWallPaperChangeEvent.WALLPAPER_CHANGE);
      }
      // 切换主题时，发送事件通知大文件截图
      localEventManager.sendLocalEvent(EventConstants.EVENT_CHANGE_THEME_BIG_FOLDER_PIC);
    }
  };

  public async updateBrightness(updateCache: boolean): Promise<void> {
    let degree = await this.getDegree(updateCache);
    // 1-极浅壁纸；2-浅色壁纸；3-深色壁纸；4-极深壁纸；5-普通花壁纸；6-极花壁纸
    log.showInfo(`updateBrightness Degree=${degree} and colorMode=${this.currColorMode}`);
    if (this.currColorMode === SmallFolderConstants.DARK_COLOR_MODE &&
      degree === WallpaperConstants.WALLPAPER_TYPE_FOUR) {
      // 1、深色模式 极深壁纸 brightness设置1.15
      this.mBackgroundBrightness = SCBConstants.BACK_PLANE_BRIGHTNESS_UP_FIFTEEN_PERCENT;
    } else if (this.currColorMode === SmallFolderConstants.LIGHT_COLOR_MODE &&
      degree !== WallpaperConstants.WALLPAPER_TYPE_ONE) {
      // 2、浅色模式 非极浅壁纸 brightness设置1.05
      this.mBackgroundBrightness = SCBConstants.BACK_PLANE_BRIGHTNESS_UP_FIVE_PERCENT;
    } else if (this.currColorMode === SmallFolderConstants.LIGHT_COLOR_MODE &&
      degree === WallpaperConstants.WALLPAPER_TYPE_ONE) {
      // 3、浅色模式 极浅壁纸 brightness设置0.92
      this.mBackgroundBrightness = SCBConstants.BACK_PLANE_BRIGHTNESS_DOWN_EIGHT_PERCENT;
    } else if (this.currColorMode === SmallFolderConstants.DARK_COLOR_MODE &&
      degree === WallpaperConstants.WALLPAPER_TYPE_ONE) {
      // 4、深色模式 极浅壁纸 brightness设置1
      this.mBackgroundBrightness = SCBConstants.BACK_PLANE_BRIGHTNESS_DEFAULT;
    } else {
      // 5、深色模式 非极深极浅壁纸 brightness设置0.95
      this.mBackgroundBrightness = SCBConstants.BACK_PLANE_BRIGHTNESS_DOWN_FIVE_PERCENT;
    }
    FolderStyleManager.getInstance().setBackgroundBrightness(this.mBackgroundBrightness);
    this.desktopParam.backgroundBrightness = this.mBackgroundBrightness;
    log.showInfo(`updateBrightness mBackgroundBrightness=${this.mBackgroundBrightness} and this.enableBrightness is ${this.enableBrightness}`);
  }

  private async getDegree(updateCache: boolean): Promise<number> {
    let degree = FolderDataModelManager.getInstance().getDegree();
    if (updateCache || degree === 0) {
      degree = await WallpaperColorManager.getInstance().getDegree();
      FolderDataModelManager.getInstance().setDegree(degree);
      return degree;
    }
    return degree;
  }

  private onColorModeChange(): void {
    this.desktopParam.curColorMode = this.currColorMode;
    this.updateBrightness(false);
    SCBDesktopCacheManager.getInstance().resetFreezeStateOnly('onColorModeChange');
    this.mDesktopContext.eventHub.emit('onColorModeChange', this.currColorMode);
    this.updateDockBackPlane();
    launcherVisualEffectMgr.updateColorMode(this.currColorMode);
  }

  @Styles
  commonBuilderStyles() {
    .id(TAG + '_Flex_Desktop')
    .accessibilityLevel((this.isFolderOpened || this.mIsFormStackExpand) && this.isAccessibilityMode ?
      'no-hide-descendants' : 'no')
  }

  @Styles
  openFolderBgBlurStyle() {
    .width(this.editModeState.isInEditMode() ? EditModeUtils.getFolderBackgroundWidth() : '100%')
    .height(this.editModeState.isInEditMode() ?
    EditModeUtils.getBackgroundHeight(this.screenHeight, this.screenWidth, this.workSpaceHeight) : '100%')
    .borderRadius(this.editModeState.isInEditMode() ? EditModeUtils.getBgBorderRadius(this.screenWidth) : 0)
    .translate({ y: this.editModeState.isInEditMode() ? EditModeUtils.getFolderBackgroundTranslateY(
      this.dockHeight, (this.pageDesktopGridStyleConfig?.mMarginBottomOfIndicator ?? 0) +
    IndicatorConstants.HEIGHT_OF_NEGATIVE_SCREEN_INDICATOR,
      SmartDockStyleConfig.getInstance().mSmartDockMarginTop) : 0 })
    .scale({
      x: this.editModeViewData.getScale(),
      y: this.editModeViewData.getScale()
    })
    .backgroundBlurStyle(this.blurStyle, {
      policy: 1,
      scale: this.blurScale,
      blurOptions: { grayscale: [this.blurScale * 38, this.blurScale * 26] }}, { disableSystemAdaptation: true })
    .focusable(false)
    .enabled(false)
    .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
    .id(TAG + `_Column_placeHolder`)
  }

  private blurAnim(isClosing: boolean): void {
    if (!this.isBlurColumnAppear) {
      return;
    }

    // 开启文件夹展开模糊动效
    animateTo({
      duration: 350,
      curve: curves.springMotion(0.424, 1),
    }, () => {
      this.blurScale = isClosing ? 0.0 : 1.0;
    });
  }

  @Builder
  openFolderBgBlurBuilder() {
    if (!this.isShowFolderBlurEffect.value) {
      if (this.isFolderOpened) {
        // 仅在展开之后文件夹背板使用EffectComponent做模糊
        EffectComponent() {
          Column()
            .width('100%')
            .height('100%')
            .useEffect(true)
            .borderRadius(this.editModeState.isInEditMode() ? EditModeUtils.getBgBorderRadius(this.screenWidth) : 0)
        }
        .openFolderBgBlurStyle()
        .freeze(this.isFreeze)
      } else if (this.gridSwiperLayout.isShowOpenFolder) {
        Column()
          .openFolderBgBlurStyle()
          .onAppear(() => {
            this.isBlurColumnAppear = true;
            this.blurAnim(this.isFolderClosing);
          })
          .onDisAppear(() => {
            this.isBlurColumnAppear = false;
          })
      }
    }
  }

  private buildLog(): boolean {
    log.showWarn('the launcher model is error of %{public}d', this.mDesktopViewData.launcherModel);
    return true;
  }

  build() {
    EffectComponent() {
      Stack() {
        if (this.isWallpaperBlurEffect.value) {
          this.CustomBlurEffectBuilder();
        }
        if (this.mDesktopViewData.launcherModel === DesktopLayoutState.HOME_LAUNCHER_MODE
          || this.mDesktopViewData.launcherModel === DesktopLayoutState.OUTDOOR_MODE
          || this.mDesktopViewData.launcherModel === DesktopLayoutState.LIGHT_OUTDOOR_MODE) {
          this.UniHomeLauncherBuilder();
        } else if (this.mDesktopViewData.launcherModel === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) {
          this.SimpleHomeLauncherBuilder();
        } else {
          if (this.buildLog()) {
          }
        }

        if (this.shieldAnimParam?.startShieldAnim) {
          this.ShieldAnimBuilder();
        }
      }
      .width('100%')
      .height('100%')
      .foregroundEffect(this.getBlurRadius())
      .onChildTouchTest(() => {
        //  文件夹关闭过程中，事件透传给桌面组件
        if (this.isFolderClosing) {
          return { id: 'SCBDesktop_Flex_Desktop', strategy: TouchTestStrategy.FORWARD_COMPETITION }
        }
        return { strategy: TouchTestStrategy.DEFAULT }
      })
    }
    .hitTestBehavior(this.isInglobalSearchAnimation ? HitTestMode.Block : HitTestMode.Default)
    .freeze(this.isFreeze)
    .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
    .backgroundEffect({
      radius: this.isEnableBlur ? ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_radius')) : 0,
      saturation: this.isEnableBlur ? ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_saturation')) : 0,
      brightness: this.enableBrightness ? this.mBackgroundBrightness : 0,
      color: $r('app.color.back_plane_bg_color')
    }, { disableSystemAdaptation: true })
    .width('100%')
    .height('100%')
    .id(`${TAG}_Image_container`)
    .visibility(this.isHideDesktop ? Visibility.Hidden : Visibility.Visible)
  }

  private getBlurRadius(): ForegroundEffectOptions | null {
    if (!SpaceAnimationUtils.isForegroundEffectSupport()) {
      return null;
    }
    return CommonUtils.equals(this.blurRatio, 0) ? null : { radius: this.blurRatio * 29 };
  }

  private updateFoldStatusParam(foldState: number) {
    log.showInfo('updateFoldStatusParam ' + foldState);
    this.foldStatus = foldState;
    log.info(`isSmallFoldDeviceExpand = %{public}s`, this.isSmallFoldDeviceExpand);
  }

  /**
   * ButtonDock位置的偏移量，区分扩展新形态小折叠产品产品外屏和其他产品
   *
   * @returns ButtonDock位置的偏移量
   */
  private getButtonDockPosition(): number {
    return this.dockHeight;
  }

  @Builder
  LauncherCommonBuilderHighLayer() {
    DropAnimationItem();
  }

  @Builder
  FormLauncherBuilderHighLayer() {
    FormZoomComponent()
  }

  @Builder
  LauncherCommonBuilder(launcherCommonBuilderParam: LauncherCommonBuilderParam) {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Column() {
        UndoDragForm()
        PageDesktopLayout({
          device: 'phone',
          screenId: this.screenProp?.screenId,
          singleContext: this.singleContext,
        }).visibility(launcherCommonBuilderParam.isOuterDesktop ? Visibility.None : Visibility.Visible);
      }
      .onAccessibilityHover((isHover, event) => {
        if (!isHover) {
          return;
        }
        AppStorage.setOrCreate<boolean>('hadFocusDock', false);
        AppStorage.setOrCreate<string>('accessibility_dock', `${ResourceManager.getInstance().getStringByName('accessibility_dock')},`);
      })
      .id(TAG + '_Column_PageDesktopLayout')
      .height(this.workSpaceHeight)
      .attributeModifier(this.pageDesktopScaleModifier)
      .translate({
        y: this.globalSearchTranslateY,
      })
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)

      // 动效节点
      Column() {
        if (!this.isShowPcDockInPad) {
          SmartDock({
            singleContext: this.singleContext
          })
        }
      }
      .renderGroup(false)
      .clip(this.isDeskSwipe)
      .height(this.dockHeight)
      .margin({ top: SmartDockStyleConfig.getInstance().mSmartDockMarginTop })
      .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
      .attributeModifier(this.smartDockScaleModifier)
      .id(TAG + `_Column_smartDock`)
      .translate({
        y: this.globalSearchTranslateY,
      })
      .transition(
        this.isShowPcDockInPad ? undefined :
        TransitionEffect.asymmetric(
          this.isSmallFoldDeviceExpand ? TransitionEffect.IDENTITY : TransitionEffect.OPACITY.animation({
            duration: EditModeStyleConstants.DOCK_TRANSITION_DURATION,
            curve: Curve.Friction,
            delay: EditModeStyleConstants.DOCK_TRANSITION_DELAY,
          }).combine(TransitionEffect.translate({ y: this.dockHeight })),
          TransitionEffect.OPACITY.animation({
            duration: EditModeStyleConstants.DOCK_TRANSITION_DURATION,
            curve: Curve.Friction
          }).combine(TransitionEffect.translate({ y: this.dockHeight })),
        ), () => {
          this.isSmallFoldDeviceExpand = false;
          log.info(`isSmallFoldDeviceExpand = %{public}s`, this.isSmallFoldDeviceExpand);
        }
      )
      .opacity(this.dockOpacity)
      .visibility((this.isFoldProductFold === true) ? Visibility.None :
        this.editModeState.isInEditMode() ?
        Visibility.Hidden : this.isShowPcDockInPad ? Visibility.None : Visibility.Visible)

      if (this.isShowEditModeGuidePage) {
        EditModeGuidePage().position({ x: 0, y: 0 })
      }
    }
    .commonBuilderStyles()
    .opacity(this.launcherOpacity.value)
    .freeze(this.isDesktopFreeze)
    .hitTestBehavior(this.isExclusiveDesktopEvent ? HitTestMode.Block : HitTestMode.Default)
    .onTouch((event: TouchEvent) => {
      log.showDebug(`TextAnnounced event = ${event.type}`);
      if (event?.type === TouchType.Down) {
        localEventManager.sendLocalEventAsync(EventConstants.EVENT_EDIT_MODE_TOUCH_DOWN_ITEM);
        if (event?.touches.length === 1 && this.isExclusiveDesktopEvent) {
          scbEventExclusiveManager.restoreAllEventExclusive(EventType.DESKTOP_ALLEVENT);
        }
        MemoryManager.getInstance().gridLayoutOptimizer.cancel('scbDesktop_touchDown');
      }
    })
    .scale({
      x: this.getValueWithProgress(this.negativeProgress, 1, NegativeScreenConstants.DESKTOP_INSIDE_SCALE_SHOW),
      y: this.getValueWithProgress(this.negativeProgress, 1, NegativeScreenConstants.DESKTOP_INSIDE_SCALE_SHOW),
      centerX: NegativeScreenConstants.DESKTOP_INSIDE_SCALE_CENTER,
      centerY: NegativeScreenConstants.DESKTOP_INSIDE_SCALE_CENTER,
    })
    .priorityGesture(
      PinchGesture()
        .onActionStart((event: GestureEvent) => {
          this.editModeViewEvent.doPinchGestureEvent(event, PinchGestureActionType.ACTION_START);
        })
        .onActionUpdate((event: GestureEvent) => {
          this.editModeViewEvent.doPinchGestureEvent(event, PinchGestureActionType.ACTION_UPDATE);
        })
        .onActionEnd((event: GestureEvent) => {
          this.editModeViewEvent.doPinchGestureEvent(event, PinchGestureActionType.ACTION_END);
        })
        .onActionCancel(() => {
          log.showInfo('pinch gesture cancel.');
        })
    )
    .gesture(LongPressGesture({ repeat: false })
      .onAction(() => {
        editModeGuideManager.openEditModeGuideByLongClick();
      })
    )
    .translate({ x: this.translateXForScreenSplit, y: 0 })

    // 堆叠卡片动效过渡截图视图
    FormStackSnapView()

    if (this.isEnableBlur) {
      this.openFolderBgBlurBuilder()
    } else {
      Column()
        .width(this.editModeState.isInEditMode() ? EditModeUtils.getFolderBackgroundWidth() : '100%')
        .height(this.editModeState.isInEditMode() ?
        EditModeUtils.getBackgroundHeight(this.screenHeight, this.screenWidth, this.workSpaceHeight) : '100%')
        .borderRadius(this.editModeState.isInEditMode() ? EditModeUtils.getBgBorderRadius(this.screenWidth) : 0)
        .translate({ y: this.editModeState.isInEditMode() ? EditModeUtils.getFolderBackgroundTranslateY(
          this.dockHeight, (this.pageDesktopGridStyleConfig?.mMarginBottomOfIndicator ?? 0) +
        IndicatorConstants.HEIGHT_OF_NEGATIVE_SCREEN_INDICATOR,
          SmartDockStyleConfig.getInstance().mSmartDockMarginTop) : 0 })
        .scale({
          x: this.editModeViewData.getScale(),
          y: this.editModeViewData.getScale()
        })
        .backgroundColor(Color.Gray)
        .opacity(this.blurScale)
        .focusable(false)
        .enabled(false)
        .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'auto')
        .id(TAG + `_Column_placeHolder`)
    }
    AppItemToDeskAnimationComponent()
    OpenFolderComponent()
    if (this.editModeState.isInEditMode()) {
      EditModeButtonDock({
        singleContext: this.singleContext
      })
        .position({
          y: this.editModeButtonDockPositionY()
        })
        .transition(
          TransitionEffect.asymmetric(
            TransitionEffect.OPACITY.animation({
              duration: EditModeStyleConstants.DOCK_TRANSITION_DURATION,
              curve: Curve.Friction,
              delay: EditModeStyleConstants.DOCK_TRANSITION_DELAY
            }).combine(TransitionEffect.translate({ y: EditModeStyleConstants.DOCK_TRANSLATE_Y })),
            TransitionEffect.OPACITY.animation({
              duration: EditModeStyleConstants.DOCK_TRANSITION_DURATION,
              curve: Curve.Friction
            }).combine(TransitionEffect.translate({ y: EditModeStyleConstants.DOCK_TRANSLATE_Y })),
          )
        )
      EditModeExtensionUI()
      EditModeRemoveBar({
        singleContext: this.singleContext
      })
    }
    MultiSelectAnimationView()
    AnimationContinueItem()
    if (this.globalSearchLocationAppShow) {
      GlobalSearchLocationApp()
    }
  }

  private editModeButtonDockPositionY(): number {
    if (this.isOuterDesktop) {
      return this.screenHeight - EditModeStyleConstants.OUTER_EDIT_MODE_DOCK_TRANSLATE;
    } else {
      return this.screenHeight - this.dockHeight -20;
    }
  }

  @Builder
  CustomBlurEffectBuilder() {
    Stack() {
      if (this.isShowMask.value) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor(this.maskColor.value)
      }
    }
    .width('100%')
    .height('100%')
    .useEffect(launcherVisualEffectMgr.isUseEffect)
    .opacity(this.wallpaperBlurOpacity.value)
    .focusable(false)
    .enabled(false)
  }

  @Builder
  UniHomeLauncherBuilder() {
    this.LauncherCommonBuilder({ isOuterDesktop: this.isOuterDesktop });
    this.FormLauncherBuilder();
    this.LauncherCommonBuilderHighLayer();
    this.FormLauncherBuilderHighLayer();
  }

  @Builder
  SimpleHomeLauncherBuilder() {
    this.LauncherCommonBuilder({ isOuterDesktop: this.isOuterDesktop });
    if (this.isOuterDesktop) {
      this.FormLauncherBuilder();
    }
    this.LauncherCommonBuilderHighLayer();
    if (this.isOuterDesktop) {
      this.FormLauncherBuilderHighLayer();
    }
  }

  @Builder
  FormLauncherBuilder() {
    FormStackExpandView({ isOuterDesktop: this.isOuterDesktop });
  }

  @Builder
  ShieldAnimBuilder() {
    EffectComponent() {
      Stack() {
        Stack() {
          ImageAnimator()
            .images(this.shieldAnimViewModel?.getWhiteImages())
            .draggable(false)
            .state(AnimationStatus.Running)
            .height(IMAGE_ANIMATOR_HEIGHT)
            .width(IMAGE_ANIMATOR_WIDTH)
            .duration(IMAGE_ANIMATOR_DURATION)
          Column() {
          }
          .useEffect(true)
          .blendMode(BlendMode.SRC_IN, BlendApplyType.FAST)
          .width('100%')
          .height('100%')
        }
        .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)

        ImageAnimator()
          .images(this.shieldAnimViewModel?.getImages())
          .draggable(false)
          .state(AnimationStatus.Running)
          .height(IMAGE_ANIMATOR_HEIGHT)
          .width(IMAGE_ANIMATOR_WIDTH)
          .duration(IMAGE_ANIMATOR_DURATION)
      }
      .scale({ x: this.shieldAnimParam?.imagesScale, y: this.shieldAnimParam?.imagesScale })
      .opacity(this.shieldAnimParam?.imagesOpacity)
    }
    .backgroundEffect({
      radius: this.isEnableBlur ? ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_radius')) : 0
    })
    .margin({ bottom: IMAGE_ANIMATOR_BOTTOM })
  }
}
