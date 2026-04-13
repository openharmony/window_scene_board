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
  ResUtils,
  SCBExpandController,
  SCBFoldController,
  SCBPropertyChangeReason,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBSystemBarProperty,
  SCBSystemSceneSession,
  SCBTransitionManager,
  sSCBOobeManager,
  windowMgr,
  SCBSessionRect,
  SCBOobeManager,
  SCBUnlockTransitionController,
  scbEventExclusiveManager,
  EventType,
  DisplayMgr
} from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import {
  ApsUtils,
  DropDownEvent,
  DropDownStatus,
  EventManager,
  EvtBus,
  HiSysEventUtil,
  localEventManager,
  ViewArea as ScreenRect,
  TargetPanel,
  TargetChangeState,
  ViewCallback,
  viewMgrPolicy,
  ViewType,
  WindowEvent,
  ConfigurationEvent,
  SolidColorEvent,
  unsubscribe,
  sEventManager,
  EventConstants as CommonEventConstants,
  obtainLocalEvent,
  ViewManagerPolicy,
  SCBWindowSceneConfig,
  WallpaperType,
  ScreenState,
  DropDownPanelManagerWrapper,
} from '@ohos/frameworkwrapper';
import lazy { SCBTriFoldManager } from '@ohos/frameworkwrapper/src/main/ets/utils/SCBTriFoldManager';
import {
  AppStorageUtil,
  DataProperty,
  DomainName,
  LogDomain,
  LogHelper,
  Trace,
  TraceUtil,
  AnimateToScheduleUtils,
  RectInfo,
  PixelMapUtil,
} from '@ohos/basicutils'
import { RotationConstants, SCBConstants } from '@ohos/commonconstants';
import { DesktopModeEnum } from '@ohos/launchercommon/src/main/ets/desktopmode/statemanager/DesktopMode';
import { DesktopModeManager } from '@ohos/launchercommon/src/main/ets/desktopmode/statemanager/DesktopModeManager';
import { EventConstants } from '@ohos/launchercommon/src/main/ets/constants/EventConstants';
import { ReceiveEventInfo } from '@ohos/launchercommon/src/main/ets/bean/ReceiveEventInfo';
import {
  bannerMgr,
  BannerPanelType,
  BannerPanelTypeState,
  BannerState,
  ForegroundAppEvent,
  NotificationSysEventReporter,
  ScreenRecordCapsuleEvent,
  crossModuleCallUtil,
  MouseClickDropDownEvent,
  LogWithHa,
  VibratorUtil
} from '@ohos/systemuicommon';
import {
  scbStatusBarStatusManager,
  SingleHandModeChangeEvent,
  StatusBarEventType,
  statusBarMaskManager,
  StatusBarMaskState,
  StatusBarType,
  RegisterAPIProtector,
} from '@ohos/systemuicommon/Index';
import {
  DropDownPanelManager,
  DropDownPanelConstants,
  SystemUIStatusBarVm,
  ColorModeViewModel,
  ColorModeViewData,
  sharedData
} from '@ohos/systemuicommon/Index';
import { StatusBarController } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarController';
import display from '@ohos.display';
import curves from '@ohos.curves';
import { ScenePanelState } from '../scenemanager/SCBScenePanel';
import { ScreenLockApi } from '@ohos/screenlockcommon/src/main/ets/api/ScreenLockApi';
import { SystemBarChangeType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { baseStateMgr } from '@ohos/systemuicommon';
import { FoldExpandAnimUtils } from '@ohos/launchercommon/src/main/ets/utils/FoldExpandAnimUtils';
import { FoldAnimationConstants } from '@ohos/launchercommon/src/main/ets/constants/FoldAnimationConstants';
import taskpool from '@ohos.taskpool';
import { BusinessError } from '@ohos.base';
import lazy Controller from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlCenterController';
import {
  SnapshotAndDegree,
  getSnapshotAndDegree
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ConcurrentController';
import { ScreenLockState } from '@ohos/screenlockcommon/src/main/ets/base/ScreenLockInnerStateManager';
import { ScreenLockStateListener } from '@ohos/screenlockcommon/src/main/ets/base/ScreenLockInnerStateManager';
import { screenLockInnerStateManager as screenLockStateManager } from '@ohos/screenlockcommon/src/main/ets/base/ScreenLockInnerStateManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { image } from '@kit.ImageKit';
// import { getWithRange } from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubGetWithRange';
import {
  BlurButtonVM,
  blurButtonVM,
} from '@ohos/notificationcomponent/src/main/ets/vm/BlurButtonVM';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SystemParameterHelper } from '@ohos/systemuicommon/src/main/ets/utils/SystemParameterHelper';
import commonEventManager from '@ohos.commonEventManager';
import { PowerStatusEnum, PowerStatusMonitor } from '@ohos/screenlockcommon/src/main/ets/monitor/PowerStatusMonitor';
import {StatusBarTint} from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarTint';
import { AccessibilityUtil } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { scbStatusBarVM } from './viewmodel/SCBStatusBarVM';
import { StatusBarStatus } from './viewmodel/StatusBarStatus';
import { StaticBlurController } from '@ohos/systemuicommon/src/main/ets/template/staticBlur/StaticBlurController'
import { MmiTestRunningManager } from './common/MmiTestRunningManager';
import { osAccount } from '@kit.BasicServicesKit';
import { editModeManager } from '@ohos/launchercommon/src/main/ets/editmode/model/EditModeManager';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import {
  ABLE_DROPDOWN_PANEL_ROTATION,
  ENABLE_FORCE_CLOSE_HDR
} from '@ohos/systemuicommon/src/main/ets/template/common/SCBVisualEffectOption';
import lazy { BannerVm, EnvVm, LiveHeadsUpShowEvent, DropdownVm } from '@ohos/systemuicommon/newIndex';
import lazy { StatusBarBridgeView } from './view/StatusBarBridgeView';
import lazy {
  SingleHandStatusChangeCallback,
  SCBSingleHandController,
  SingleHandMode,
  SingleHandRect
} from '../scenemanager/onehandmode/SCBSingleHandController';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import { StatusBarHeightVm } from '@ohos/systemuicommon/src/main/ets/statusbar/vm/StatusBarHeightVm';
import { InnerEventUtil, NotificationDataManager } from '@ohos/systemuicommon/newTsIndex';
import { OneMirrorService } from '@ohos/screenlockcomponent/src/main/ets/onemirror/service/OneMirrorService';
import { MultiInputViewModel } from '@ohos/multiinput/src/main/ets/default/common/viewmodel/MultiInputViewModel';
import lazy { SCBTripleController } from '@ohos/windowscene/src/main/ets/animation/SCBTransitionController';
import lazy {
  UltraScreenExpandAnimUtils,
  SCBTripleStateChange,
} from '@ohos/launchercommon/src/main/ets/utils/UltraScreenExpandAnimUtils';
import lazy {
  UltraScreenAnimationConstants
} from '@ohos/launchercommon/src/main/ets/constants/UltraScreenAnimationConstants';
import { ColorModeLiveViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeLiveViewData';
import { effectKit } from '@kit.ArkGraphics2D';
import { ColorModeNCViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeNCViewData';
import { getAvgColor } from '@ohos/systemuicommon/src/main/ets/utils/ColorInvertTool';
import {
  StatusBarManager,
  HideStatusBarScene,
  IStatusBarManager
} from '@ohos/systemuicommon/src/main/ets/statusbar/manager/StatusBarManager';
import { ResponseRegionsClipType, TitleBarType } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarEnum';
import { SnapshotType, SystemUIColorVm } from '@ohos/systemuicommon/src/main/ets/vm/SystemUIColorVm';
import { ForbiddenGestureVm } from './viewmodel/ForbiddenGestureVm';
import { StatusBarColorData } from '@ohos/statusbarcomponent/src/main/ets/viewmodel/StatusBarColorData'
import { NtfCenterDropDownEvent } from '@ohos/systemuicommon/src/main/ets/event/NotificationEvent';
import { statusBarVMV2 } from '@ohos/statusbarcomponent/src/main/ets/viewmodel/StatusBarVMV2';
import { CAPSULE_RIGHT_X } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusbarConstants';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { StatusBarMaintenanceErrorCode } from '@ohos/systemuicommon/src/main/ets/maintenance/statusbar/StatusBarMaintenanceErrorCode';
import { StatusBarMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/statusbar/StatusBarMaintenance';
import { StatusBarExceptionCode } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarExceptionCode';

const TAG = 'StatusBar-Index'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;

/**
 * 窗口名
 */
const WINDOW_NAME = WindowConstants.WINDOW_NAME_STATUS_BAR;

const DROP_DOWN_MIN_FRACTION = 0.3;

const CHECK_DISMISS: number = 20;
const STYLUS_SLIDE_RESET_DELAY: number = 25;

const CHECK_AWAKE_DISMISS: number = 2250;

const TOUCH_EVENT_TOOL_TYPE_PEN: number = 2;
const MAX_TOUCH_MOVE: number = 20;

const MIN_SPEED_VALUE: number = 250;

const TITLE_RESPONSE_WIDTH = 64;
const PANEL_TYPE = 'notification';

// 手机titleBar热区宽度
const PHONE_TITLE_RESPONSE_WIDTH = 96;
// 点击手机titleBar呼出menu热区宽度
const PHONE_TITLE_MENU_RESPONSE_WIDTH = 224;

// 应用内通知中心下拉显示
const DOWN_IN_APP: string = 'DOWN_IN_APP';
// 桌面通知中心下拉显示
const DOWN_IN_DESKTOP: string = 'DOWN_IN_DESKTOP';
// 锁屏通知中心下拉显示
const DOWN_IN_LOCK: string = 'DOWN_IN_LOCK';

// 状态栏点击公共事件广播一
const ACTION_CLICK_STATUSBAR = 'com.openharmony.intent.action.CLICK_STATUSBAR';
// 状态栏点击公共事件广播二
const EVENT_CLICK_STATUSBAR = 'usual.event.CLICK_STATUSBAR';

// 组件截图起终点
const SNAPSHOT_START_NODE: string = 'OneHandModeBox';
const SNAPSHOT_END_NODE: string = 'StatusBarBox';

@Component
export struct SCBStatusBar {
  @State viewController: StatusBarController = new StatusBarController();
  @State controlStatusBarVisible: boolean = true;
  @State keyguardStatusBarAnimationOpacity: number = 1;
  @StorageLink('isInStylusInwardSlideGesture') isInStylusInwardSlideGesture: boolean = false;
  @Link screenProp: SCBScreenProperty;
  @State statusBarStatus: StatusBarStatus = scbStatusBarVM.getStatusBarStatus();
  @StorageLink('scenePanelState') scenePanelState: ScenePanelState = ScenePanelState.HOME;
  @StorageLink('isPwdVisible') isPwdVisible: boolean = false;
  @StorageLink('playPwdBack') @Watch('onPlayPwdBackChange')playPwdBack: boolean = false;
  @StorageLink('enableControllerCenter') enableControllerCenter: boolean = true;
  @Prop @Watch('onIsKeyguardViewHideChange') isKeyguardHide: Boolean = true;
  @StorageLink('screenLockMoveEvent') screenMoveEvent: TouchEvent | null = null;
  @State statusBarMaskState: StatusBarMaskState = statusBarMaskManager.getStatusBarMaskState();
  /**
   * 下拉事件
   */
  @StorageLink('dropDownEvent') @Watch('onDropDownEventChange') targetDropDownEvent: DropDownEvent = DropDownPanelManager.getDropDownEvent();

  /**
   * banner面板类型状态
   */
  @State @Watch('onBannerPanelTypeStateChange') bannerPanelTypeState: BannerPanelTypeState = bannerMgr.getBannerState().bannerPanelType;

  @State @Watch('onBannerPanelTypeChange') bannerPanelType: BannerPanelType = BannerPanelType.TYPE_NONE;

  persistentId: number = sharedData.statusBarPersistentId;
  startX: number = 0
  startY: number = 0
  startEvent: TouchEvent | null = null;
  speed: number = 0
  lastX: number = 0
  lastY: number = 0
  displayHeight: number = 0
  rotateAngle: number = 0;
  // 最近的状态栏点击输入设备是否是手写笔
  currentTouchIsStylus: boolean = false;
  // 当前是否为先显示状态栏
  private isCurrShowStatusBar: boolean = false;
  private isCurrSwitchCenter: boolean = false;
  onHidingAnimation: boolean = false;

  /**
   * 判断设备是否为折叠态（直板机状态为非折叠态）
   */
  @Provide isFolded: boolean = this.getFolded(display.getFoldStatus());
  /**
   * 超大屏设备屏幕显示状态
   */
  @Provide ultraScreenDisplayMode: XTLayoutType = LayoutUtils.getFoldDisplayModeByStatus(display.getFoldStatus());

  // titleBar显示类型
  private titleBarType: TitleBarType = TitleBarType.NONE;

  /**
   * 下拉事件
   */
  private dropDownEvent: DropDownEvent = DropDownPanelManager.getDropDownEvent();
  private dropDownStatus: DropDownStatus = DropDownPanelManager.getDropDownStatus();
  private isShowWindow: boolean = false;
  private isShowTargetPanel: boolean = false;
  private isEnable: boolean = false
  private isNeedShowBySpeed: boolean = false;
  private isFirstShowDropDown: boolean = false;
  private delayCheckDismiss: number = 0;
  private delayCheckAwakeDismiss?: number;
  private notificationAPSTaskId: number | undefined = undefined;
  private viewCallback?: ViewCallback;
  private unLockTransitionController: SCBUnlockTransitionController = {
    name: `${TAG}`,
    onLock: ():void => this.onKeyguardViewShow(),
    onUnlock: (): void =>this.onKeyguardViewHide(),
  };
  private touchEventIsDropdown = StatusBarManager.getInstance()?.isDropdown() ?? false;
  /**
   * banner、实况窗口状态管理
   */
  private bannerState: BannerState = bannerMgr.getBannerState();
  /**
   * 触摸滑动状态栏锁
   */
  private touchOperLock: boolean = false;
  // 判断应用是否在前台，仅用于扩展新形态小折叠产品设备
  private isAppForegroundForOuterHome: boolean = false;
  // 判断是否来自TopBar onTouch下拉双中心面板事件，仅用于扩展新形态小折叠产品折叠外屏
  private isFoldOuterFromTopBar: boolean | undefined = false;
  private screenId: number = 0;
  /**
   * onTouch事件当前起作用的手指id
   */
  private currentTouchId?: number;
  // 当前是否在锁屏编辑器
  private isLockEditor: boolean = false;
  // 窗口显示时屏幕Sensor/旋转锁定状态
  private showWindowSensorScreen?: number;
  private showWindowIsLocked?: boolean;
  // 窗口收起时屏幕Sensor/旋转锁定状态
  private hideWindowSensorScreen?: number;
  private hideWindowIsLocked?: boolean;
  /**
   * 进入锁屏编辑器延时设置状态栏类型定时器
   */
  private statusbarTypeTimer: number | undefined = undefined;

  private systemUIStatusBarVm: SystemUIStatusBarVm = SystemUIStatusBarVm.get();
  /**
   * 设置隐私按钮热区后，如果是特殊titleBar热区，需恢复titleBar热区
  */
  private specialResponseRegion: ResponseRegionsClipType = ResponseRegionsClipType.NO_CLIP;
  /**
   * 隐私按钮特殊热区
   */
  private specialResponseRegionForPrivacy: ResponseRegionsClipType = ResponseRegionsClipType.NO_CLIP;
  /**
   * 胶囊右侧x
   */
  private capsuleRightX: number = 0;

  private screenlockStateListener: ScreenLockStateListener = {
    // 进入锁屏编辑器
    onEnterThemeEditor: (preState: ScreenLockState) => {
      this.handleEnterLockEditor();
    },
    // 进入锁屏
    onEnterHost: (preState: ScreenLockState, isSaveConfig: boolean) => {
      this.handleEnterLockScreen();
    }
  }

  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  private readonly localEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: number): void => {
      log.showInfo(`receive SYSTEM_BAR_CHANGE event, params=${params}`);
      switch (event) {
        case EventConstants.SYSTEM_BAR_CHANGE:
        // 沉浸式场景，导航条与状态栏默认同步显隐。导航条touch down时，通知状态栏清除计时任务，直到up/cancel再开启计时
          if (params === SystemBarChangeType.CANCEL_TASK) {
            this.clearDelayAwakeDismiss();
          } else if (params === SystemBarChangeType.SET_TASK) {
            this.setDelayAwakeDismiss();
          }
          break;
        default:
          break;
      }
    }
  };
  private foldController?: SCBFoldController;
  private expandController?: SCBExpandController;
  private tripleController?: SCBTripleController;

  private colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private colorModeLiveViewData: ColorModeLiveViewData = ColorModeViewModel.getInstance().getLiveViewData();
  private colorModeNCViewData: ColorModeNCViewData = ColorModeViewModel.getInstance().getNCViewData();

  /**
   * 事件取消订阅集合
   */
  clearCallbacks: unsubscribe[] = [];

  // 是否已经截图
  private hasScreenShot: boolean = false;
  private hasUpdateDropDownStatusBarColor: boolean = false;
  /**
   * 背景模糊VM
   */
  @State blurButtonVM: BlurButtonVM = blurButtonVM;
  /**
   * 是否进入热安全模式
   */
  private isInThermalSafeMode: boolean = false;
  /**
   * 是否进入应急模式
   */
  private isInEmergencyMode: boolean = false;
  /**
   * DFX-DFM产线模式
   */
  private isDFXDFMLineMode: boolean = false;

  private mmiTestRunningManager: MmiTestRunningManager = new MmiTestRunningManager();

  /**
   * 是否为隐私按钮设置过热区
   */
  private isSetHotRegionForPrivacy: boolean = false;

  private targetPanelByTouchX: TargetPanel = TargetPanel.NONE;
  /**
   * 当前系统账号是否已认证解锁
   */
  private isOsAccountUnlocked: boolean = false;
  /**
   * 是否在应用前台（小外屏折叠态）
   */
  private isAppForegroundForVerde: boolean = false;
  /**
   * 是否通知中心发送的隐藏状态栏
   */
  private isHideAppFromNtf: boolean = false;

  /**
   *  上一次状态栏属性
   */
  private lastSystemBarProperty?: SCBSystemBarProperty;
  /**
   * 保存取得的平均色
   */
  private averageColor?: effectKit.Color;
  /**
   * 控制中心本次取色已完成
   */
  private isCCPickColorUpdated: boolean = false;
  /**
   * 通知中心本次取色已完成
   */
  private isNCPickColorUpdated: boolean = false;
  /**
   * 取得的平均色准备就绪
   */
  private isPickColorReady: boolean = false;
  /**
   * 当前的dropDownPanel面板
   */
  private currentDropDownPanel: TargetPanel = TargetPanel.NONE;

  private systemUIColorVm: SystemUIColorVm = SystemUIColorVm.instance;

  /**
   * touch事件中途被禁用，那此次touch事件结束
   */
  private isEndTouch: boolean = false;

  onBackPress(): boolean {
    return true;
  }

  /**
   * 属性变更回调
   */
  private handleConfigurationEvent = (event: ConfigurationEvent) => {
    if (!event) {
      log.showInfo('ConfigurationEvent undefined or null');
      return;
    }

    const darkMode: ConfigurationConstant.ColorMode = event.config?.colorMode ??
      ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET;
    if (darkMode === ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET) {
      log.showInfo('ConfigurationEvent colorMode not set.');
      return;
    }
    const isDark = (darkMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) ?? false;
    log.showInfo('handleConfigurationEvent isDark: ' + isDark);
    this.updateAppDefaultSystemBarContentColor(isDark);
  }

  private beforeScreenPropertyChangeCallback: Callback<display.FoldStatus> = (foldStatus: display.FoldStatus): void => {
    this.folderStatusChangeCallbackForOuterHome(foldStatus);
  };

  private updateAppDefaultSystemBarContentColor(isDarkMode: boolean) {
    log.showInfo(`updateAppDefaultSystemBarContentColor(isDarkMode ${isDarkMode}).`);
    const appDefaultSystemBarProperty: SCBSystemBarProperty = SCBSceneSessionManager.getInstance()
      .getAppDefaultSystemBarProperty();
    if (appDefaultSystemBarProperty) {
      SCBSceneSessionManager.getInstance().setAppDefaultSystemBarProperty(
        new SCBSystemBarProperty(appDefaultSystemBarProperty.type, appDefaultSystemBarProperty.enable,
          appDefaultSystemBarProperty.backgroundcolor, isDarkMode ? '#FFFFFFFF' : '#FF000000'));
    } else {
      SCBSceneSessionManager.getInstance().setAppDefaultSystemBarProperty(
        new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_STATUS_BAR, true,
          '#00FFFFFF', isDarkMode ? '#FFFFFFFF' : '#FF000000'));
    }
  }

  private handleEnterLockEditor(): void {
    this.isLockEditor = true;
    EnvVm.instance.isLockEditor = true;
    // 隐藏状态栏的动效消失后再置状态栏类型
    this.statusbarTypeTimer = setTimeout(() => {
      if (!ScreenLockApi.getLock()) {
        this.isKeyguardHide = true;
      }
    }, StatusBarManager.getInstance()?.getStatusBarOpacityDuration() ?? 0)
  }

  private handleEnterLockScreen(): void {
    if (this.isLockEditor) {
      // 应急或热安全模式，锁屏显示白色状态栏，否则恢复锁屏本身的颜色
      let color: string =
        (this.isInEmergencyMode || this.isInThermalSafeMode) ? StatusBarTint.CONTENT_COLOR_OPAQUE_WHITE :
        StatusBarColorData.instance().getContentColor(StatusBarType.TYPE_MAIN_PHONE_KEYGUARD);
      scbStatusBarVM.showStatusbarLockEditor(color);
      this.isLockEditor = false;
      EnvVm.instance.isLockEditor = false;
    }

    this.isKeyguardHide = false;
  }

  /**
   * 下拉时相应面板事件
   */
  onDropDownEventChange(): void {
    if (this.isPickColorReady) {
      this.setPickColor(this.averageColor as effectKit.Color);
    }
    if (this.targetDropDownEvent.target === this.currentDropDownPanel) {
      return;
    }
    this.currentDropDownPanel = this.targetDropDownEvent.target;
    const isNeedSetHotRegion: boolean = this.isDisplayLand() &&
      this.targetDropDownEvent.target === TargetPanel.CONTROL_CENTER_PANEL && uiType !== SCBConstants.UITYPE_PAD;
    // 设置横屏隐私指示器热区
    if (isNeedSetHotRegion) {
      this.setHotRegionForPrivacy(true);
      return;
    }
    // 下拉恢复状态栏整热区
    if (this.targetDropDownEvent.target !== TargetPanel.NONE) {
      this.resetHotRegion();
      return;
    }
    // 处理收起面板热区
    this.setHotRegionForPrivacy(false);
  }

  /**
   * 通过事件判断双中心显示的面板，隔离取色逻辑
   */
  private setPickColor(color: effectKit.Color): void {
    let isShowPanelContent: boolean = this.dropDownEvent.targetChanged === TargetChangeState.HORIZONTAL ||
      this.dropDownEvent.targetChanged === TargetChangeState.HORIZONTAL_UP_BACK ||
      this.dropDownEvent.targetChanged === TargetChangeState.VERTICAL_FLING;
    let isCurrentShowCC: boolean = isShowPanelContent ||
      this.targetDropDownEvent.target === TargetPanel.CONTROL_CENTER_PANEL;
    let isCurrentShowNC: boolean = isShowPanelContent ||
      this.targetDropDownEvent.target === TargetPanel.NOTIFICATION_PANEL;
    if (isCurrentShowCC && !this.isCCPickColorUpdated) {
      log.showInfo('update control center pickColor');
      if (this.dropDownEvent.progress === 1) {
        animateToImmediately({
          duration: 100,
          curve: Curve.Friction,
        }, () => {
          Controller.setPickColor(color);
        });
      } else {
        Controller.setPickColor(color);
      }
      this.isCCPickColorUpdated = true;
    } else if (isCurrentShowNC && !this.isNCPickColorUpdated) {
      if (this.colorModeViewData.isSolidEnable() && !ScreenLockApi.getLock()) {
        log.showInfo(`update notification2 pickColor ${color?.red} ${color?.green} ${color?.blue}`);
        this.systemUIColorVm.getAverageColor(SnapshotType.Dropdown, color);
        this.isNCPickColorUpdated = true;
      }
    }
  }

  /**
   * 为隐私按钮设置热区
   * @param isSet 设置或者恢复
   */
  private setHotRegionForPrivacy = (isSet: boolean): void => {
    log.showInfo(`set hot region for privacy ${isSet}, ${this.specialResponseRegionForPrivacy}`);
    if (isSet) {
      this.specialResponseRegionForPrivacy = ResponseRegionsClipType.PRIVACY_BUTTON;
    } else {
      this.specialResponseRegionForPrivacy = ResponseRegionsClipType.NO_CLIP;
    }
    this.refreshStatusBarResponseRegion();
  }

  getResponseRegionHeight() {
    let regionHeight = this.getHeightByDevice();
    return regionHeight;
  }

  getHeightByDevice(source?: SCBPropertyChangeReason): number {
    // 应对折叠展开事件后于屏幕属性变化事件
    if (source === SCBPropertyChangeReason.FOLD_TO_EXPAND && !LayoutUtils.isXTProductType()) {
      this.isFolded = false;
    } else if (source === SCBPropertyChangeReason.EXPAND_TO_FOLD && !LayoutUtils.isXTProductType()) {
      this.isFolded = true;
    }

      return ResUtils.getNumber($r('app.float.status_bar_phone_height'));
  }

  /**
   * 根据旋转角度和下拉状态栏更新热区
   */
  private updateHotRegionByRotateAngle(): void {
    const isNeedSetHotRegion: boolean = this.isDisplayLand() &&
      this.targetDropDownEvent.target === TargetPanel.CONTROL_CENTER_PANEL;
    this.setHotRegionForPrivacy(isNeedSetHotRegion);
  }

  private onIsKeyguardViewHideChange() {
    const statusbarManager = StatusBarManager.getInstance();
    if (statusbarManager !== undefined) {
      statusbarManager.isKeyguardHide = this.isKeyguardHide.valueOf();
    }

    const isDropDown = ViewManagerPolicy.isViewShowing(ViewType.DROPDOWN)
    log.showInfo(`on is keyguard view hide flag change ${this.isKeyguardHide},  isDropdown is ${StatusBarManager.getInstance()?.isDropdown()} isDropDown: ${isDropDown}`);
    // 判断双中心是否是下拉状态  是： 不更新状态栏类型， 不是： 更新状态栏类型
    if (!isDropDown) {
      StatusBarManager.getInstance()?.setStatusBarType(this.isKeyguardHide
        ? StatusBarType.TYPE_MAIN_PHONE_LAUNCHER : StatusBarType.TYPE_MAIN_PHONE_KEYGUARD);
    } else {
      StatusBarManager.getInstance()?.setStatusBarType(StatusBarType.TYPE_MAIN_PHONE_DROPDOWN);
    }
  }

  private onPlayPwdBackChange() {
  }

  private onBannerPanelTypeStateChange(): void {
    if (this.bannerPanelTypeState.bannerPanelType !== this.bannerPanelType) {
      this.bannerPanelType = this.bannerPanelTypeState.bannerPanelType;
    }
  }

  private onBannerPanelTypeChange(): void {
    log.showInfo(`onBannerPanelTypeChange banner panel type is ${this.bannerPanelType}`);
    if (this.bannerPanelType === BannerPanelType.TYPE_LIVE_LIST && !this.isSystemBarEnable()) {
      log.showInfo('live list is showing, so show status bar.');
      this.clearDelayAwakeDismiss();
      scbStatusBarVM.animateStatusBarOpacity(false);
    }
    if (this.bannerPanelType === BannerPanelType.TYPE_NONE || !this.colorModeViewData.isSolidEnable()) {
      return;
    }
    let screenId: number = 0;
    if (SCBScreenSessionManager.getInstance().getMainScreenSession()?.session) {
      screenId = SCBScreenSessionManager.getInstance().getMainScreenSession().session.screenId;
    }
    const hasPrivateWindow = display.hasPrivateWindow(screenId);
    log.showInfo(`hasPrivateWindow: ${hasPrivateWindow}`, hasPrivateWindow);
    if (!hasPrivateWindow) {
      if (this.bannerPanelType === BannerPanelType.TYPE_LIVE_LIST) {
        this.handleAverageColor(screenId);
      } else if (this.bannerPanelType === BannerPanelType.TYPE_HEADS_UP) {
        this.getAverageColor(screenId);
      }
    }
  }

  private getAverageColor(screenId: number): void {
    getAvgColor(screenId, 0.2).then((averageColor: effectKit.Color | undefined) => {
      log.info('Get Average Color');
      if (!averageColor) {
        return;
      }
      this.setNtfLiveColor(averageColor);
      this.setNCColor(averageColor);
      EvtBus.post(SolidColorEvent, new SolidColorEvent(SolidColorEvent.TOP20));
    })
      .catch((error: Error) => {
        log.error('Get AvgColor failed:', error.message);
      });
  }

  private isHideStatusbar(scene: HideStatusBarScene, statusbarType?: StatusBarType): boolean {
    if (!this.isFolded) {
      return false;
    }

    // 通知中心进应用直接隐藏（优先级高）
    if (this.isHideAppFromNtf && !this.isEnable) {
      log.showInfo(`need to hide statusbar, from ntf`);
      this.isHideAppFromNtf = false;
      return true;
    }

    // 下拉收回场景 不在应用内 不隐藏
    if (scene === HideStatusBarScene.FROM_DROPDOWN && !this.isAppForegroundForVerde) {
      log.showInfo('not in app, need not hide statusbar');
      return false;
    }

    // 多任务/锁屏编辑器/桌面编辑器下拉收回时不直接隐藏
    let isEditMode: boolean = editModeManager.isInEditMode();
    if (this.scenePanelState === ScenePanelState.RECENT || this.isLockEditor || isEditMode) {
      log.showInfo('need not hide statusbar');
      return false;
    }

    statusbarType = statusbarType ?? StatusBarManager.getInstance()?.getStatusBarType();
    // 常驻下拉面板 不隐藏
    if (viewMgrPolicy.isViewShowing(ViewType.DROPDOWN) && statusbarType === StatusBarType.TYPE_MAIN_PHONE_DROPDOWN) {
      log.showInfo('dropdown, need not hide statusbar');
      return false;
    }

    log.showInfo(`current isEnable is: ${this.isEnable}`);
    return !this.isEnable;
  }

  public hideStatusbar = (scene: HideStatusBarScene, statusbarType?: StatusBarType) => {
    if (this.isHideStatusbar(scene, statusbarType)) {
      scbStatusBarVM.onIsBarShow(false, false);
      statusbarType = statusbarType ?? StatusBarManager.getInstance()?.getStatusBarType();
      if (statusbarType !== StatusBarType.TYPE_MAIN_PHONE_KEYGUARD) {
        bannerMgr.releasePanelCapsuleList();
      }
      return true;
    }
    return false;
  }

  private systemBarPropertyCallback = (property: SCBSystemBarProperty) => {
    log.showInfo(`registerSystemBarPropertyCallbacks, enable: ${property.enable}, enableAnimation:` +
      `${property.enableAnimation}, scenePanelState: ${this.scenePanelState}`);
    if (this.lastSystemBarProperty) {
      this.lastSystemBarProperty.enableAnimation = property.enableAnimation;
    }
    if (this.lastSystemBarProperty && this.lastSystemBarProperty.equals(property)) {
      log.showInfo(`systemBarPropertyCallback, same as last, prop:${property?.toString()}`);
      return;
    }

    // 状态栏暂显场景下需要常显时及时重置暂显状态并清除定时器
    if (property.enable) { // 标识状态栏可见的
      SCBSceneSessionManager.getInstance().setIsShowStatusBarTemporary(false);

      if (this.viewController.isShowing()) { // 状态栏可用（没被隐藏）
        scbStatusBarVM.animateStatusBarOpacity(property.enableAnimation);
      } else {
        const isExitRecentTask = SCBSceneSessionManager.getInstance().isInRecentOutProcess;
        scbStatusBarVM.onIsBarShow(true, property.enableAnimation, isExitRecentTask);
      }
    } else if (
      this.viewController.isShowing() &&
        !viewMgrPolicy.isViewShowing(ViewType.DROPDOWN) &&
        !bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_LIST) &&
        !this.enableStatusBarKeepShowing()
    ) { // 处于下拉状态不能隐藏状态栏
      log.showInfo('Hide status bar');
      scbStatusBarVM.onIsBarShow(false, property.enableAnimation);
    }
    if (this.isEnable != property.enable) {
      this.notifyNextAvoidRectInfo();
    }

    this.isEnable = property.enable;
    this.hideStatusbar(HideStatusBarScene.NORMAL);
    log.showWarn(`isEnable changed: ${this.isEnable}, statusBarOpacity is ${this.statusBarStatus.getStatusBarOpacity()}, ` +
      `immersive is ${baseStateMgr.isImmersive()}, enable animation: ${property.enableAnimation}`);
    this.lastSystemBarProperty = property?.clone();
  }

  aboutToAppear() {
    this.viewCallback = {
      onShow: this.onViewShow,
      onHide: this.onViewHide
    };
    StatusBarHeightVm.getInstance()
      .injectStatusBarViewController(this.getUIContext(), this.refreshStatusBarResponseRegion, this.refreshStatusBarRegion);

    this.viewController.registerCallback(this.viewCallback);
    viewMgrPolicy.registerViewController(ViewType.STATUS_BAR, this.viewController);
    this.viewController.updateId(this.persistentId);
    this.viewController.show();
    scbStatusBarVM.init();

    // loadContent之前vp2px无效，此处更新窗口高度
    let winRect = windowMgr.getWindowPosition(WINDOW_NAME);
    winRect.height = vp2px(ResUtils.getNumber($r('app.float.status_bar_phone_height')));
    winRect.width = this.screenProp.width;
    windowMgr.updateWindowPosition(WINDOW_NAME, winRect);
    windowMgr.startBindWinAnimOnFrame(WINDOW_NAME);

    // 设置状态栏避让区高度
    this.refreshStatusBarRect(this.screenProp.width);

    // set Cast+ projection filter. The window will not show on virtual display.
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (systemSceneSession) {
      systemSceneSession.setSkipEventAndShowOnVirtualScreen(true);
    }
    SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks(this.systemBarPropertyCallback);
    // 平板的titleBar回调
    SCBSceneSessionManager.getInstance().registerFullScreenTitleBarAppearCallback(() => {
      log.showInfo('registerFullScreenTitleBarAppearCallback');
      this.titleBarType = TitleBarType.PAD;
      this.updateHotRegion();
    });
    // 折叠屏的titleBar回调 titleBar和menu互斥
    SCBSceneSessionManager.getInstance().registerFullScreenMenuVisibleCallback(this.fullScreenMenuVisibleCallback);
    // 智慧多窗退出 状态栏恢复回调
    SCBSceneSessionManager.getInstance().registerHotRegionStateChangeCallback(() => {
      log.showInfo('registerHotRegionStateChangeCallback');
      this.titleBarType = TitleBarType.NONE;
      this.updateHotRegion();
    });
    this.initDisplayHeight();
    this.rotateAngle = SCBScreenSessionManager.getInstance().getScreenRotation() ?? 0;
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks((screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
        log.showInfo(`screenId: ${screenProperty.screenId}`);
        this.checkScreenWidthIsValid(screenProperty);
        this.screenId = screenProperty.screenId;
        try {
          this.getUIContext().runScopedTask(() => {
            this.onScreenPropertyChange(screenProperty, reason);
          });
        } catch (e) {
          new StatusBarMaintenance().reportStatusBarInfo(StatusBarMaintenanceErrorCode.REFRESH_AREA_FAL);
          log.error(`on screen property change error`, e);
        }
      }, undefined, true, this.persistentId);
    this.registerWindowEventHandler();
    this.registerStatusBarEventHandler();
    this.registerScreenChangeTransitionController();
    this.registerLiveHeadsUpEventHandler();
    scbStatusBarStatusManager.registerStatusBarEnabledChange();
    if (ScreenLockApi.getLock()) {
      this.isKeyguardHide = false;
    }
    SCBTransitionManager.getInstance().registerUnlockTransitionController(this.unLockTransitionController, false);
    screenLockStateManager.registerScreenLockState(this.screenlockStateListener);
    localEventManager.registerEventListener(this.localEventListener, [EventConstants.SYSTEM_BAR_CHANGE]);
    //控制中心显隐事件
    this.clearCallbacks.push(
      sEventManager.subscribe(CommonEventConstants.CONTROL_CENTER_SHOW_HIDE_BAR, (event: boolean) => {
        this.onControlCenterDataChanged(event);
      })
    );
    SCBScreenSessionManager.getInstance()
      .registerBeforeScreenPropertyChangeCallbacks(this.beforeScreenPropertyChangeCallback, this.screenId);
    this.setAppOverrideStatusBarProperty();
    sEventManager.subscribe(CommonEventConstants.GESTURE_TOP_BAR_DROPDOWN_PAN, (event: TouchEvent) => {
      this.onTouchEvent(event, true);
    })
    // fold screen animation
    this.registerFoldExpandAnimationController();
    // fold screen animation in triple fold product
    this.registerTripleAnimationController();

    // 状态栏智能反色
    this.registerConfigurationEvent();
    // DFX-DFM产线模式
    this.checkDFXDFMLineMode();
    // 监听热安全模式
    this.registerThermalMode();
    // 状态栏下拉手势自愈订阅
    scbEventExclusiveManager.registerEventExclusive(EventType.GESTURE_STATUS_BAR, this.gestureEventExclusive);
    // 状态栏内部组件的touch事件如果中断状态栏的touch事件，需要调用‘END_STATUSBAR_TOUCH_EVENT’事件闭合状态栏touch事件
    sEventManager.subscribe('END_STATUSBAR_TOUCH_EVENT', this.endStatusBarTouchEvent);
    DisplayMgr.setUiContext(this.getUIContext());
    // 订阅状态栏隐藏事件
    sEventManager.subscribe(StatusBarEventType.STATUS_BAR_HIDE_IN_APP, this.hideStatusBarInAppFromNtf);
    this.registerForegroundEvent();
    StatusBarManager.setInstance(statusBarVMV2 as IStatusBarManager);
    StatusBarManager.getInstance()?.registerStatusbarHideEvent(this.hideStatusbar);
    SCBSingleHandController.getInstance().registerSingleHandStatusChangeCallback(TAG, this.onSingleHandStatusChange);
    // 鼠标事件样式可用时注册
    if (this.isEnableMouseTypeStyle()) {
      crossModuleCallUtil.register('onMouseStyleEvent', this.onMouseStyleEvent);
      this.eventMgr.on(MouseClickDropDownEvent, this.handleMouseClickDropDownEvent);
    }
    MultiInputViewModel.getInstance().registerStatusBarVisibleCallback(this.statusBarVisibleCallback);
    // 订阅capsuleRightX变化事件
    sEventManager.subscribe(CAPSULE_RIGHT_X, this.capsuleRightXChange);
  }

  private fullScreenMenuVisibleCallback = (isMenuVisible: boolean) => {
    log.showInfo(`registerFullScreenMenuVisibleCallback, ${isMenuVisible}`);
    this.titleBarType = isMenuVisible ? TitleBarType.FOLD_MENU : TitleBarType.FOLD;
    this.updateHotRegion();
  }

  private capsuleRightXChange = (capsuleRightX: number) => {
    if (capsuleRightX === this.capsuleRightX) {
      return;
    }
    this.capsuleRightX = capsuleRightX;
    const UPDATE_REGION_SCENE = [
      TitleBarType.PAD,
      TitleBarType.FOLD,
      TitleBarType.FOLD_MENU,
    ];
    if (UPDATE_REGION_SCENE.indexOf(this.titleBarType) !== -1){
      log.showInfo(`capsule right changed, update region`);
      this.updateHotRegion();
    }
  }

  private onSingleHandStatusChange: SingleHandStatusChangeCallback = {
    onSingleHandEntered: (mode: SingleHandMode): void => {
      log.showInfo('onSingleHandEntered');
      this.handleSingleHandStatusChange(mode, true);
    },
    onSingleHandExited: (): void => {
      log.showInfo('onSingleHandExited');
      this.handleSingleHandStatusChange(SingleHandMode.MIDDLE, false);
    }
  };

  private handleSingleHandStatusChange(mode: SingleHandMode, isSingleHandMode: boolean): void {
    try {
      let currentSingleHandRect: SingleHandRect = SCBSingleHandController.getInstance().GetCurrentSingleHandRect();
      let event = new SingleHandModeChangeEvent();
      event.isSingleHandMode = isSingleHandMode;
      event.mode = mode;
      event.scale = currentSingleHandRect.scale;
      event.singleHandX = currentSingleHandRect.singleHandX;
      event.singleHandY = currentSingleHandRect.singleHandY;
      event.singleHandW = currentSingleHandRect.singleHandW;
      event.singleHandH = currentSingleHandRect.singleHandH;
      EvtBus.post(SingleHandModeChangeEvent, event);
    } catch (error) {
      log.showError(`get singleHandMode info failed: ${error?.code}, message: ${error?.message}`);
    }
  }

  private folderStatusChangeCallback = (newFoldStatus: display.FoldStatus) => {
    if (LayoutUtils.isXTProductType()) {
      this.ultraScreenDisplayMode = LayoutUtils.getFoldDisplayModeByStatus(newFoldStatus);
      log.showInfo(`folderStatusChangeCallback ultraScreenDisplayMode is ${this.ultraScreenDisplayMode}`);
      return;
    }
    this.isFolded = this.getFolded(newFoldStatus);
    this.systemUIStatusBarVm.changeIsShowNCAfterUnlock(false, 'screen fold stage change');
    log.showInfo(`folderStatusChangeCallback isFolded is ${this.isFolded}, isEnable: ${this.isEnable}` +
      `, scenePanelState: ${this.scenePanelState}, isAppForegroundForOuterHome: ${this.isAppForegroundForOuterHome}`);
    this.setAppOverrideStatusBarProperty();
  };

  private folderStatusChangeCallbackForOuterHome(foldStatus: display.FoldStatus): void {
    this.isFolded = foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED;
    log.showInfo(`beforeScreenPropertyChange isFolded is ${this.isFolded}, isEnable: ${this.isEnable}` +
      `, scenePanelState: ${this.scenePanelState}, isAppForegroundForOuterHome: ${this.isAppForegroundForOuterHome}`);
    this.setAppOverrideStatusBarProperty();
  };

  /**
   * 小外屏接收通知中心的消息隐藏状态栏
   */
  private hideStatusBarInAppFromNtf = (event: boolean) => {
    this.isHideAppFromNtf = event;
    this.hideStatusbar(HideStatusBarScene.NORMAL);
  }

  private registerForegroundEvent(): void {
    this.eventMgr.on(ForegroundAppEvent, this.onForegroundAppEvent);
  }

  /**
   * 应用前台
   */
  private onForegroundAppEvent = (event?: ForegroundAppEvent): void => {
      return;
  }

  /**
   * 设置小外屏应用内状态栏属性
   */
  private setAppOverrideStatusBarProperty() {
      return;
  }

  private gestureEventExclusive = () => {
    log.showInfo(`getEventExclusiveByCaller: ${scbEventExclusiveManager.getEventExclusiveByCaller(EventType.GESTURE_STATUS_BAR)}`);
    if (scbEventExclusiveManager.getEventExclusiveByCaller(EventType.GESTURE_STATUS_BAR)) {
      scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_STATUS_BAR, false);
    }
  }

  /**
   * 根据titleBar判断热区设置
   */
  private updateHotRegion() {
    if (this.titleBarType === TitleBarType.PAD) {
      this.specialResponseRegion = ResponseRegionsClipType.PAD_TITLE_BAR;
    } else if (this.titleBarType === TitleBarType.FOLD) {
      this.specialResponseRegion = ResponseRegionsClipType.PHONE_TITLE_BAR;
    } else if (this.titleBarType === TitleBarType.FOLD_MENU) {
      this.specialResponseRegion = ResponseRegionsClipType.PHONE_MENU;
    } else {
      this.specialResponseRegion = ResponseRegionsClipType.NO_CLIP;
    }
    this.checkResponseRegion();
    this.refreshStatusBarResponseRegion();
  }

  private checkResponseRegion() {
    // titleBar/menu的x
    let titleBarOrMenuX: number = 0;
    let screenWidth = ArkUIAdapter.px2vp(sharedData.statusBarWidth);
    if (this.specialResponseRegion === ResponseRegionsClipType.PAD_TITLE_BAR) {
      titleBarOrMenuX = (screenWidth - TITLE_RESPONSE_WIDTH) / 2;
    } else if (this.specialResponseRegion === ResponseRegionsClipType.PHONE_TITLE_BAR) {
      titleBarOrMenuX = (screenWidth - PHONE_TITLE_RESPONSE_WIDTH) / 2;
    } else if (this.specialResponseRegion === ResponseRegionsClipType.PHONE_MENU) {
      titleBarOrMenuX = (screenWidth - PHONE_TITLE_MENU_RESPONSE_WIDTH) / 2;
    }
    log.showInfo(`checkResponseRegion, capsuleRightX: ${this.capsuleRightX}, titleBarOrMenuX: ${titleBarOrMenuX}`);
    if (this.capsuleRightX - titleBarOrMenuX > 0) {
      this.specialResponseRegion = ResponseRegionsClipType.NO_CLIP;
    }
  }
  /**
   * 刷新状态栏高度相关数据
   * 否则 避障和显示高度分别计算
   */
  private refreshStatusBarRect(screenWidth: number, reason?: SCBPropertyChangeReason) {
    // 状态栏避障高度
    const tempAvoidHeight = this.getHeightByDevice(reason);
    log.showInfo(`refreshStatusBarRect Height: ${tempAvoidHeight} newScreenWidth ${screenWidth} ${this.screenProp.width}`);
    StatusBarHeightVm.getInstance().setAvoidHeight(this.screenId, tempAvoidHeight);
    const moveDownVm = StatusBarManager.getInstance()?.getMoveDownVM();
    moveDownVm?.changeAvoidInfo(tempAvoidHeight);
    this.refreshStatusBarRegion();
    this.updateHotRegion();
  }

  private checkScreenWidthIsValid(screenProperty: SCBScreenProperty) {
    if (screenProperty.width !== this.screenProp.width) {
      log.showWarn(`refreshStatusBarRect screenWidth ${screenProperty.width} is not equal screen property width(${this.screenProp.width}).`);
      new StatusBarMaintenance().reportStatusBarInfo(StatusBarMaintenanceErrorCode.SCREEN_WIDTH_EXCEPTION,
        { areaStr: `${screenProperty.left}_${screenProperty.top}_${screenProperty.width}_${screenProperty.height}` });
    }
  }

  private notifyNextAvoidRectInfo() {
    log.showInfo(`notifyNextAvoidRectInfo`)
    try {
      const sessionType: sceneSessionManager.SessionType = sceneSessionManager.SessionType.TYPE_STATUS_BAR;
      const curDisplay: display.Display = display.getDefaultDisplaySync();
      const statusBarHeight: number = vp2px(StatusBarHeightVm.getInstance().getAvoidHeight());
      log.showInfo(`notifyNextAvoidRectInfo ${this.persistentId} ${curDisplay.width} ${curDisplay.height}`)
      const isLandSpace = this.isDisplayLand();
      const portraitRect: RectInfo = new RectInfo();
      portraitRect.left = 0;
      portraitRect.top = 0;
      portraitRect.right = isLandSpace ? curDisplay.height : curDisplay.width;
      portraitRect.bottom = statusBarHeight;
      const landspaceRect: RectInfo = new RectInfo();
      landspaceRect.left = 0;
      landspaceRect.top = 0;
      landspaceRect.right = isLandSpace ? curDisplay.width : curDisplay.height;
      landspaceRect.bottom = statusBarHeight;
      log.showInfo(`Rect ${portraitRect.right} ${landspaceRect.right} `)
      sceneSessionManager.notifyNextAvoidRectInfo(sessionType, this.screenId, portraitRect, landspaceRect);
    } catch (error) {
      log.showError(`getDefaultDisplaySync code: ${error?.code}, msg: ${error?.message}`);
    }
  }

  /**
   * 超大屏应用在前台场景，处理F与M态状态栏动效
   * @returns
   */
  private isUltraScreenFMSwitch(): boolean {
    if (!DeviceHelper.isUltraScreenProduct()) {
      return false;
    }
    const currentTripleState = SCBTriFoldManager.getInstance().getCurTriFoldState();
    const prevTripleState = SCBTriFoldManager.getInstance().getPrevTriFoldState();
    const stateChange = UltraScreenExpandAnimUtils.getTripleStateChange(currentTripleState, prevTripleState);
    if (stateChange === SCBTripleStateChange.F_TO_M || stateChange === SCBTripleStateChange.M_TO_F) {
      return true;
    }
    return false;
  }

  private onScreenPropertyChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) {
    const oldArea: ScreenRect = this.viewController.getArea();
    const newAreaWidth: number = screenProperty.width;
    this.rotateAngle = screenProperty?.rotation;
    log.showInfo('rotateAngle is ' + this.rotateAngle + ', ' + screenProperty?.width);
    // 状态栏显示高度和避障高度刷新
    this.refreshStatusBarRect(newAreaWidth, reason);

    if (this.screenProp.width > 0) {
      this.displayHeight = Number(newAreaWidth) * this.screenProp.height / this.screenProp.width;
    }
    this.updateHotRegionByRotateAngle();
    if (this.titleBarType) {
      this.updateHotRegion();
    }
    if ((reason === SCBPropertyChangeReason.FOLD_TO_EXPAND || reason === SCBPropertyChangeReason.EXPAND_TO_FOLD) &&
      this.scenePanelState === ScenePanelState.FULLSCENE && !ScreenLockApi.getLock() &&
      this.isUltraScreenFMSwitch()) {
      this.StatusBarFoldOrExpandAnimation(reason);
    }
    log.showInfo('onScreenPropertyChange old width:' + oldArea.width + 'new width:' + newAreaWidth);
  }

  private initDisplayHeight() {
    if (this.screenProp.width <= 0) {
      log.showError(`screen prop width(${this.screenProp.width}) is invalid.`);
      return;
    }
    try {
      this.displayHeight = display.getDefaultDisplaySync().width * this.screenProp.height / this.screenProp.width;
    } catch (err) {
      log.showError('err');
    }
  }

  private registerFoldExpandAnimationController(): void {
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId)
    this.foldController = {
      itemId: `${TAG}_${systemSceneSession?.name}_${systemSceneSession?.id}`,
      onFoldAnimation: () => this.foldedAnimation(),
    };
    this.expandController = {
      itemId: `${TAG}_${systemSceneSession?.name}_${systemSceneSession?.id}`,
      onExpandAnimation: () => this.expandedAnimation(),
    };
    SCBTransitionManager.getInstance().registerFoldAnimationController(this.foldController);
    SCBTransitionManager.getInstance().registerExpandAnimationController(this.expandController);
  }

  private registerWindowEventHandler(): void {
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      log.showInfo('registerWindowEventHandler windowName is : ' + event.windowName);
      if (event.windowName === WindowConstants.WINDOW_NAME_DROPDOWN) {
        log.showInfo('WindowConstants.WINDOW_NAME_DROPDOWN');
        this.handleDropDownWindowEvent(event);
        this.dropDownWindowEventNotifyApsManager(event);
      }
      if (event.windowName === WindowConstants.WINDOW_NAME_LIVEVIEW &&
        event.eventType === WindowEvent.EVENT_TYPE_HIDE && !this.isSystemBarEnable()) {
        log.showInfo('liveViewPanel close, delay close current bar')
        if (ViewManagerPolicy.isViewShowing(ViewType.STATUS_BAR)) {
          this.setDelayAwakeDismiss();
        }
      }
    });
  }

  private registerTripleAnimationController(): void {
    if (!DeviceHelper.isUltraScreenProduct()) {
      return;
    }
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    this.tripleController = {
      itemId: `${TAG}_${systemSceneSession?.name}_${systemSceneSession?.id}`,
      onTripleAnimation: (oldState: ScreenState, newState: ScreenState,
        isNeedAnimation: boolean) => this.tripleAnimation(oldState, newState, isNeedAnimation),
    };
    SCBTransitionManager.getInstance().registerTripleAnimationController(this.tripleController);
  }

  private registerLiveHeadsUpEventHandler(): void {
    InnerEventUtil.on(LiveHeadsUpShowEvent, (event: LiveHeadsUpShowEvent) => {
      log.showInfo('registerLiveHeadsUpEventHandler headUpStatus is: ' + event.headUpStatus);
      if (event.headUpStatus === LiveHeadsUpShowEvent.EVENT_SHOW_BANNER) {
        scbStatusBarVM.animateStatusBarOpacity(false);
      }
    });
  }

  /**
   * 双中心下拉窗口出现隐藏事件通知ApsManager
   */
  private dropDownWindowEventNotifyApsManager(event: WindowEvent) {
    // 展开窗口时通知ApsManager
    if (event.isWindowShow()) {
      // ApsUtils.setApsScene(apsManager.SceneAnimation.S_DDN, 1);
      if (this.notificationAPSTaskId === undefined) {
        this.notificationAPSTaskId = setInterval(() => {
          // ApsUtils.setApsScene(apsManager.SceneAnimation.S_DDN, 1);
        }, 2000);
      }
    }

    // 隐藏窗口时通知ApsManager
    if (event.isWindowHide()) {
      if (this.notificationAPSTaskId !== undefined) {
        clearInterval(this.notificationAPSTaskId);
        this.notificationAPSTaskId = undefined;
      }
      // ApsUtils.setApsScene(apsManager.SceneAnimation.S_DDN, 2);
    }
  }

  private registerConfigurationEvent(): void {
    this.eventMgr.on(ConfigurationEvent, this.handleConfigurationEvent);
  }

  /**
   * 处理下拉窗口出现隐藏事件
   */
  private handleDropDownWindowEvent(event: WindowEvent) {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    // 隐藏下拉窗口
    if (event.eventType === WindowEvent.EVENT_TYPE_HIDE) {
      log.showInfo(`close dropDownPanel, isFoldOuterFromTopBar: ${this.isFoldOuterFromTopBar}, scenePanelState: ${this.scenePanelState}`);
      if (!ABLE_DROPDOWN_PANEL_ROTATION) {
        screenSession?.setEnableRotate(true, WindowConstants.WINDOW_NAME_DROPDOWN);
        this.handleDropDownWindowHideScreenSensor();
      }
      if (ENABLE_FORCE_CLOSE_HDR) {
        SCBScreenSessionManager.getInstance().setForceCloseHdr(false);
      }
      // 解冻壁纸引擎
      scbStatusBarVM.unfreezeThemeEngine();
      statusBarMaskManager.setStatusBarMaskState(false);
      DropdownVm.instance.setDropdownOnly(false);

      if (!this.isSystemBarEnable() && !bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_LIST)) {
        if (SCBSceneSessionManager.getInstance().isPcMode()) {
          log.showInfo('dropDownPanel collapsed, freeMultiWindowMode delay close current bar');
          this.setDelayAwakeDismiss();
        } else {
          log.showInfo('dropDownPanel collapsed, close current bar');
          scbStatusBarVM.onIsBarShow(false, true);
        }
        return;
      }

      // 多任务列表下隐藏状态栏
      if (this.scenePanelState === ScenePanelState.RECENT &&
        !bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_LIST)) {
        viewMgrPolicy.hideView(ViewType.STATUS_BAR);
        return;
      }
      return;
    }

    // 展开下拉窗口
    if (event.eventType === WindowEvent.EVENT_TYPE_SHOW) {
      this.interruptStatusBarTypeTimer();
      if (!ABLE_DROPDOWN_PANEL_ROTATION) {
        this.showWindowSensorScreen = screenSession?.sensorScreenProperty.rotation;
        this.showWindowIsLocked = SCBScreenSessionManager.getInstance().getScreenOrientationLocked();
        screenSession?.setEnableRotate(false, WindowConstants.WINDOW_NAME_DROPDOWN);
      }
      // 冻结壁纸引擎
      scbStatusBarVM.freezeThemeEngine();
      statusBarMaskManager.setStatusBarMaskState(true);
      log.showInfo(`dropdown Show setStatusBarMaskState(true). isFoldOuterFromTopBar: ${this.isFoldOuterFromTopBar}` +
        `, isAppForegroundForOuterHome: ${this.isAppForegroundForOuterHome}`);
      // 多任务列表状态下需要显示下拉框 处于沉浸式且窗口已下拉但状态栏未展示需要显示下拉框
      if (this.scenePanelState === ScenePanelState.RECENT ||
        (!this.isSystemBarEnable() && !this.viewController.isShowing())) {
        viewMgrPolicy.showView(ViewType.STATUS_BAR);
      }

      scbStatusBarVM.animateStatusBarOpacity(false);
    }
  }

  /**
   * 进入锁屏编辑器，状态栏隐藏动效还未做完时下拉双中心，中断延迟设置状态栏类型定时器
   */
  private interruptStatusBarTypeTimer(): void {
    if (!this.isLockEditor || !this.statusbarTypeTimer) {
      return;
    }
    this.clearStatusbarTypeTimer();
  }

  clearStatusbarTypeTimer(): void {
    clearTimeout(this.statusbarTypeTimer);
    this.statusbarTypeTimer = undefined;
    StatusBarManager.getInstance()?.setStatusBarType(StatusBarType.TYPE_MAIN_PHONE_LAUNCHER);
  }

  /**
   * 处理DropDownPanel收起后触发屏幕旋转sensor
   */
  private handleDropDownWindowHideScreenSensor(): void {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    this.hideWindowSensorScreen = screenSession?.sensorScreenProperty.rotation;
    this.hideWindowIsLocked = SCBScreenSessionManager.getInstance().getScreenOrientationLocked();
    if (SCBScreenSessionManager.getInstance().resetRotationHandleDropDownWindowHideScreenSensor(screenSession)) {
      log.showInfo('handleDropDownWindowHideScreenSensor resetRotationHandleDropDownWindowHideScreenSensor true,' +
        ' not need rotationChangeEntry');
      return;
    }
    // 如果 设备角度发生变化|| (控制中心开关状态发生变化 && 当前应用受旋转开关影响) 触发sensor旋转
    if (this.hideWindowSensorScreen !== this.showWindowSensorScreen ||
      (this.hideWindowIsLocked !== this.showWindowIsLocked &&
      !SCBSceneSessionManager.getInstance().isRotateLockedUnrelatedSessionActive(
        screenSession.scbScreenProperty.screenId))) {
      screenSession?.rotationChangeEntry(screenSession?.sensorScreenProperty.rotation, 'unlock dropdown panel rotation');
    }
  }

  private registerStatusBarEventHandler(): void {
    sEventManager.subscribe(StatusBarEventType.STATUS_BAR_HIDE, (needAnimation?: boolean) => {
      if (!this.viewController.isShowing()) {
        log.showInfo('status bar is not showing, no need to hide');
        return;
      }
      if (this.delayCheckAwakeDismiss) {
        log.showInfo('delay awake dismiss exist, not hide immediately');
        return;
      }
      if (this.isSystemBarEnable()) {
        log.showInfo('status bar is enabled, no need to hide');
        return;
      }
      // 手指长按状态栏的时候，不能关闭，否则会闪
      if (needAnimation && !this.dropDownStatus.isTouchingStatusBar) {
        log.showInfo('receive status bar hide event, need animation');
        scbStatusBarVM.onIsBarShow(false, true);
        return;
      }
      log.showInfo('receive status bar hide event, hide immediately');
      this.viewController.hide();
    });
  }

  private StatusBarFoldOrExpandAnimation(reason: SCBPropertyChangeReason): void {
    if (reason === SCBPropertyChangeReason.EXPAND_TO_FOLD) {
      this.windowsFoldedAnimation();
    }
    if (reason === SCBPropertyChangeReason.FOLD_TO_EXPAND) {
      this.windowsExpandedAnimation();
    }
  }

  private windowsFoldedAnimation(): void {
    log.showInfo('statusbar execute foldedAnimation in windows scene');
    let systemSceneSession: SCBSystemSceneSession =
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (!systemSceneSession) {
      log.showError('err: System Session is null');
      return;
    }
    systemSceneSession.translateX =
      FoldExpandAnimUtils.getStatusBarTranslateX(FoldAnimationConstants.STATUS_FOLD_FACTOR, px2vp(this.screenProp.width));
    systemSceneSession.opacity = FoldExpandAnimUtils.getStatusBarStartOpacity();
    animateTo({
      curve: FoldAnimationConstants.SYSTEM_TRANSLATE_CURVES,
    }, () => {
      if (systemSceneSession) {
        systemSceneSession.translateX = 0;
      }
    })
    animateTo({
      curve: FoldAnimationConstants.ALPHA_CURVES,
    }, () => {
      if (systemSceneSession) {
        systemSceneSession.opacity = 1;
      }
    })
  }

  private windowsExpandedAnimation(): void {
    log.showInfo('statusbar execute expandedAnimation in windows scene');
    let systemSceneSession: SCBSystemSceneSession =
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (!systemSceneSession) {
      log.showError('err: System Session is null');
      return;
    }
    systemSceneSession.translateX =
      FoldExpandAnimUtils.getStatusBarTranslateX(FoldAnimationConstants.EXPAND_FACTOR, px2vp(this.screenProp.width));
    systemSceneSession.opacity = FoldExpandAnimUtils.getStatusBarStartOpacity();
    animateTo({
      curve: FoldAnimationConstants.SYSTEM_TRANSLATE_CURVES,
    }, () => {
      if (systemSceneSession) {
        systemSceneSession.translateX = 0;
      }
    })
    animateTo({
      curve: FoldAnimationConstants.ALPHA_CURVES,
    }, () => {
      if (systemSceneSession) {
        systemSceneSession.opacity = 1;
      }
    })
  }

  // fold screen animation
  private foldedAnimation(): void {
    log.showInfo('statusbar execute foldedAnimation');
    let systemSceneSession: SCBSystemSceneSession =
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (systemSceneSession) {
      systemSceneSession.translateX =
        FoldExpandAnimUtils.getStatusBarTranslateX(FoldAnimationConstants.FOLD_FACTOR, px2vp(this.screenProp.width));
      systemSceneSession.opacity = 0;
    }
    animateTo({
      curve: FoldAnimationConstants.TRANSLATE_CURVES,
    }, () => {
      if (systemSceneSession) {
        systemSceneSession.translateX = 0;
      }
    })
    animateTo(FoldExpandAnimUtils.getStatusBarAlphaAnimParam(), () => {
      if (systemSceneSession) {
        systemSceneSession.opacity = 1;
      }
    })
  }

  private expandedAnimation(): void {
    log.showInfo('statusbar execute expandedAnimation');
    let systemSceneSession: SCBSystemSceneSession =
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (systemSceneSession) {
      systemSceneSession.translateX =
        FoldExpandAnimUtils.getStatusBarTranslateX(FoldAnimationConstants.EXPAND_FACTOR, px2vp(this.screenProp.width));
      systemSceneSession.opacity = 0;
    }
    animateTo({
      curve: FoldAnimationConstants.TRANSLATE_CURVES,
    }, () => {
      if (systemSceneSession) {
        systemSceneSession.translateX = 0;
      }
    })
    animateTo(FoldExpandAnimUtils.getStatusBarAlphaAnimParam(), () => {
      if (systemSceneSession) {
        systemSceneSession.opacity = 1;
      }
    })
  }

  private tripleAnimation(oldState: ScreenState, newState: ScreenState, isNeedAnimation: boolean): void {
    if (!isNeedAnimation) {
      log.showInfo(`statusbar noneed tripleAnimation`);
      return;
    }
    log.showInfo(`statusbar execute tripleAnimation, oldState is ${oldState}, newState is ${newState}`);
    let systemSceneSession: SCBSystemSceneSession =
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    let stateChange: SCBTripleStateChange = UltraScreenExpandAnimUtils.getTripleDesktopStateChange(newState, oldState);
    if (stateChange === SCBTripleStateChange.INVALID) {
      log.showWarn('get stateChange invalid, return;');
      return;
    }
    if (systemSceneSession) {
      systemSceneSession.translateX =
        UltraScreenExpandAnimUtils.initTripleStatusBarTransX(px2vp(this.screenProp.width), stateChange);
    }
    animateTo({
      curve: UltraScreenAnimationConstants.TRANSLATE_CURVES,
      duration: UltraScreenAnimationConstants.ANIMATION_DURATION,
    }, () => {
      if (systemSceneSession) {
        systemSceneSession.translateX = 0;
      }
    });
  }

  private registerScreenChangeTransitionController(): void {
    // beginScreenOn --> BEGIN_DISPLAY_ON
    PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.BEGIN_DISPLAY_ON, this.beginDisplayOn);
    // endScreenOn --> END_DISPLAY_ON
    PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.END_DISPLAY_ON, this.endDisplayOn);
    // screenOff - BEGIN_DISPLAY_OFF -END_DISPLAY_OFF
    PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.BEGIN_DISPLAY_OFF, this.beginDisplayOff);
  }

  private beginDisplayOn = () => {
    log.showInfo('statusBar BEGIN_DISPLAY_ON');
    if (!StatusBarManager.getInstance()?.isDropdown()) {
      StatusBarManager.getInstance()?.setStatusBarType(this.isKeyguardHide
        ? StatusBarType.TYPE_MAIN_PHONE_LAUNCHER : StatusBarType.TYPE_MAIN_PHONE_KEYGUARD);
    }
  }

  private endDisplayOn = () => {
    log.showInfo('statusBar END_DISPLAY_ON');
    // 亮屏时重新注册失败的API
    RegisterAPIProtector.get().retryFailedAPIs();
    this.statusBarScreenOnAnimation();
  }

  private beginDisplayOff = () => {
    log.showInfo('statusBar BEGIN_DISPLAY_OFF');
    this.statusBarScreenOffAnimation();
    this.systemUIStatusBarVm.changeIsShowNCAfterUnlock(false, 'BEGIN_DISPLAY_OFF');
  }

  private statusBarScreenOffAnimation(): void {
    log.showInfo('statusBar offScreenAnimation start');
    if (!OneMirrorService.getInstance().isConfigSupportToEnd()) {
      this.keyguardStatusBarAnimationOpacity = 0;
      if (!StatusBarManager.getInstance()?.isDropdown()) {
        StatusBarManager.getInstance()?.setStatusBarType(this.isKeyguardHide
          ? StatusBarType.TYPE_MAIN_PHONE_LAUNCHER : StatusBarType.TYPE_MAIN_PHONE_KEYGUARD);
      }
      log.showDebug('AOD is not enabled, statusBar no animation');
      return;
    }
    animateTo({
      duration: StatusBarManager.getInstance()?.getStatusBarOpacityDuration() ?? 0,
      onFinish: () => {
        log.showInfo('statusBar offScreenAnimation finish');
      }
    }, () => {
      this.keyguardStatusBarAnimationOpacity = 0;
      if (!StatusBarManager.getInstance()?.isDropdown()) {
        StatusBarManager.getInstance()?.setStatusBarType(this.isKeyguardHide
          ? StatusBarType.TYPE_MAIN_PHONE_LAUNCHER : StatusBarType.TYPE_MAIN_PHONE_KEYGUARD);
      }
    })
  }

  private statusBarScreenOnAnimation(): void {
    log.showInfo(`statusBar screenOnAnimation start`);
    animateTo({
      duration: StatusBarManager.getInstance()?.getStatusBarOpacityDuration() ?? 0,
      onFinish: () => {
        log.showInfo('statusBar screenOnAnimation finish');
      }
    }, () => {
      this.keyguardStatusBarAnimationOpacity = 1;
      if (!StatusBarManager.getInstance()?.isDropdown()) {
        StatusBarManager.getInstance()?.setStatusBarType(this.isKeyguardHide
          ? StatusBarType.TYPE_MAIN_PHONE_LAUNCHER : StatusBarType.TYPE_MAIN_PHONE_KEYGUARD);
      }
    })
  }

  private isSystemBarEnable(): boolean {
    return this.isEnable;
  }

  /**
   * 是否横屏
   *
   * @return true横屏
   */
  private isDisplayLand(): boolean {
    return this.rotateAngle === RotationConstants.ROTATION_90 || this.rotateAngle === RotationConstants.ROTATION_270;
  }

  /**
   * 通知中心下拉打点场景获取
   *
   * @return DOWN_IN_APP表示应用内下拉，DOWN_IN_DESKTOP表示桌面下拉，DOWN_IN_LOCK表示锁屏下拉
   */
  private getScenarios(): string {
    let onDeskTop: boolean = AppStorage.get<boolean>('onDeskTop') as boolean;
    let scenarios = DOWN_IN_APP;
    log.showInfo('notification hide name type : ' + onDeskTop + ' ,lock : ' +
    SCBSceneSessionManager.getInstance().isScreenLocked());
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      scenarios = DOWN_IN_LOCK;
    }
    if (onDeskTop) {
      scenarios = DOWN_IN_DESKTOP;
    }
    return scenarios;
  }

  /**
   * 坐标大小是否反转
   *
   * @return true反转
   */
  private isDisplayReverse(): boolean {
    return this.rotateAngle === RotationConstants.ROTATION_180 || this.rotateAngle === RotationConstants.ROTATION_270;
  }

  private onViewShow = (): void => {
    let enable = this.isSystemBarEnable();
    log.showInfo(`onViewShow is coming, enable: ${enable} `);
    if (!enable) {
      // 沉浸式场景呼出状态栏，通知导航条也显示出来
      localEventManager.sendLocalEvent(EventConstants.SYSTEM_BAR_CHANGE, SystemBarChangeType.SHOW_BAR);
      this.setDelayAwakeDismiss();
    }
    BannerVm.instance.updateImmersiveStateBreak(true);
    baseStateMgr.updateImmersiveStateBreak(true);
    viewMgrPolicy.hideView(ViewType.GESTURE_TOP_BAR);
    scbStatusBarVM.onStatusBarViewChange(true);
  }
  private onViewHide = (): void => {
    log.showInfo('onHide is coming');
    this.clearDelayAwakeDismiss();
    BannerVm.instance.updateImmersiveStateBreak(false);
    baseStateMgr.updateImmersiveStateBreak(false);
    if (!SCBSceneSessionManager.getInstance().isPcMode() ||
      AppStorage.get('pcmodeScenePanelState') !== ScenePanelState.RECENT) {
      viewMgrPolicy.showView(ViewType.GESTURE_TOP_BAR);
    }
    localEventManager.sendLocalEvent(EventConstants.SYSTEM_BAR_CHANGE, SystemBarChangeType.HIDE_BAR);
    scbStatusBarVM.onStatusBarViewChange(false);
  }

  // listening the keyguard hide event
  private onKeyguardViewHide(): void {
    log.showInfo('onKeyguardViewHide ' + this.isEnable);
    if (this.isKeyguardHide) {
      this.onIsKeyguardViewHideChange();
    }
    this.isKeyguardHide = true;
    this.keyguardStatusBarAnimationOpacity = 1;
    if (this.isEnable && !(this.viewController.isShowing())) {
      this.viewController.show();
    } else if ((!this.isEnable) && this.viewController.isShowing() && !viewMgrPolicy.isViewShowing(ViewType.DROPDOWN)) {
      this.viewController.hide();
    }
    this.checkStatusBarShowException();
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
  }

  // listening the keyguard show event
  private onKeyguardViewShow(): void {
    log.showInfo('onKeyguardViewShow' + this.isEnable);
    this.isKeyguardHide = false;
    // 小外屏应用内不显示状态栏
    if (!this.isFolded || !this.isAppForegroundForVerde) {
      this.viewController.show();
    }
    //锁屏后touchId恢复初始化
    this.currentTouchId = undefined;
    // 防止下拉过程中按电源键锁屏，导致touch事件未闭环
    this.statusBarTouchUpOrCancel('onKeyguardViewShow');
    this.checkStatusBarShowException();
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    this.systemUIStatusBarVm.changeIsShowNCAfterUnlock(false, 'screen locked');
  }

  private checkStatusBarShowException(): void {
    if (!this.controlStatusBarVisible) {
      LogWithHa.warn(log,
        `status bar visible exception, control status bar visible(${this.controlStatusBarVisible}) to cause.`,
        StatusBarExceptionCode.CONTROL_HIDE_STATUS_BAR_FAIL);
    }

    if (this.isKeyguardHide) {
      const statusBarOpacity: number = this.statusBarStatus.getStatusBarOpacity();
      if (statusBarOpacity !== 1) {
        LogWithHa.warn(log,
          `status bar opacity exception, status bar opacity(${statusBarOpacity}) to cause.`,
          StatusBarExceptionCode.LAUNCHER_OPACITY_FAIL);
      }
    } else {
      if (DropdownVm.instance.isDropdownOnly) {
        DropdownVm.instance.setDropdownOnly(false);
        LogWithHa.warn(log, `isDropdownOnly error`, StatusBarExceptionCode.IS_ONLY_DROPDOWN);
      }
      if (this.keyguardStatusBarAnimationOpacity !== 1) {
        LogWithHa.warn(log,
          `status bar opacity exception, status bar opacity(${this.keyguardStatusBarAnimationOpacity}) to cause.`,
          StatusBarExceptionCode.KEYGUARD_OPACITY_ANIM_FAIL);
      }
    }
  }

  /**
   * 控制中心展示内容
   */
  private onControlCenterDataChanged(visible: boolean) {
    log.showWarn(`onControlCenterDataChanged visible = ${visible}`);
    this.controlStatusBarVisible = visible;
    if (visible) {
      StatusBarHeightVm.getInstance().forcedSetHeight(false);
    } else {
      StatusBarHeightVm.getInstance().forcedSetHeight(true);
    }
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.eventMgr.offAll();
    this.clearCallbacks.forEach(fn => fn());
    screenLockStateManager.unregisterScreenLockState(this.screenlockStateListener);
    localEventManager.unregisterEventListener(this.localEventListener);
    SCBTransitionManager.getInstance().unRegisterFoldAnimationController(this.foldController);
    SCBTransitionManager.getInstance().unRegisterExpandAnimationController(this.expandController);
    if (DeviceHelper.isUltraScreenProduct()) {
      SCBTransitionManager.getInstance().unRegisterTripleAnimationController(this.tripleController);
    }
    SCBTransitionManager.getInstance().unRegisterUnlockTransitionController(this.unLockTransitionController, false);
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (systemSceneSession) {
      systemSceneSession.setSkipEventAndShowOnVirtualScreen(false);
    }

    // 取消状态栏下拉自愈订阅
    scbEventExclusiveManager.unRegisterEventExclusive(EventType.GESTURE_STATUS_BAR);
    // 取消亮灭屏事件订阅
    this.unRegisterScreenChangeTransitionController();
    scbStatusBarVM.unInit();
    sEventManager.off('END_STATUSBAR_TOUCH_EVENT', this.endStatusBarTouchEvent);
    // 取消状态栏隐藏事件
    sEventManager.off(StatusBarEventType.STATUS_BAR_HIDE_IN_APP, this.hideStatusBarInAppFromNtf);
    sEventManager.off(CAPSULE_RIGHT_X, this.capsuleRightXChange);
    //注销折叠屏状态监听
      try {
        display.off('foldStatusChange', this.folderStatusChangeCallback);
      } catch (error) {
        log.showError(`unRegister fold change listener failed: ${error?.code}`);
      }

    SCBSingleHandController.getInstance().unregisterSingleHandStatusChangeCallback(TAG);
    if (this.isEnableMouseTypeStyle()) {
      crossModuleCallUtil.unregister('onMouseStyleEvent');
      EvtBus.off(MouseClickDropDownEvent, this.handleMouseClickDropDownEvent);
    }
    MultiInputViewModel.getInstance().unregisterStatusBarVisibleCallback(this.statusBarVisibleCallback);
    SCBSceneSessionManager.getInstance().unregisterFullScreenMenuVisibleCallback(this.fullScreenMenuVisibleCallback);
  }

  statusBarVisibleCallback = (isShow: boolean): void => {
    if (!SCBSceneSessionManager.getInstance().isPcMode()) {
      return;
    }
    if (isShow) {
      this.viewController.show();
    } else {
      this.playHidenAnimation();
    }
  }

  private playHidenAnimation(): void {
    this.onHidingAnimation = true;
    let statusBar = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR);
    if (!statusBar) {
      log.showError('Failed to get systemSceneSession of the statusBar');
      return;
    }
    log.showInfo('statusbar playHidenAnimation is called.');
    this.getUIContext()?.animateTo({
      duration: 400,
      curve: curves.cubicBezierCurve(0.0, 0.0, 0.20, 1.0),
      onFinish: () => {
        if (this.onHidingAnimation) {
          this.viewController.hide();
          this.onHidingAnimation = false;
          SCBSceneSessionManager.getInstance().resetLastStatusBarProperty();
          statusBar?.setTranslate(0, 0, 0);
        }
      }
    }, () => {
      let statusBarHeight: number = vp2px(ResUtils.getNumber($r('app.float.status_bar_phone_height')));
      statusBar?.setTranslate(0, -statusBarHeight, 0);
    })
  }

  private unRegisterScreenChangeTransitionController() {
    // 取消亮灭屏事件订阅
    PowerStatusMonitor.getInstance().unsubscribe(PowerStatusEnum.BEGIN_DISPLAY_ON, this.beginDisplayOn);
    PowerStatusMonitor.getInstance().unsubscribe(PowerStatusEnum.END_DISPLAY_ON, this.endDisplayOn);
    PowerStatusMonitor.getInstance().unsubscribe(PowerStatusEnum.BEGIN_DISPLAY_OFF, this.beginDisplayOff);
  }

  /**
   * 是否启用鼠标悬浮、点击样式
   * @returns
   */
  private isEnableMouseTypeStyle(): boolean {
    // 2in1设备的pad模式要开启
    if (DeviceHelper.is2In1DevicePadType()) {
      return true;
    }
    return false;
  }

  private handleMouseClickDropDownEvent = (): void => {
    this.clearDelayRunnable();
  }

  build() {
    Stack({ alignContent: Alignment.Top }) { // 状态栏高度会动态变化、下方内容会默认居中显示，会导致显示异常
      StatusBarBridgeView({
        isVisible: this.viewController.isShowing() && (this.isPwdVisible || this.controlStatusBarVisible),
        statusBarComponentOpacity: this.statusBarStatus.getStatusBarOpacity() * this.keyguardStatusBarAnimationOpacity,
        onTouchEvent: this.onTouchEvent,
        onClickEvent: this.onClickEvent,
        onActionStartGestureEvent: (event: GestureEvent) => this.onPanGesture(event, 'onActionStart'),
        onActionUpdateGestureEvent: (event: GestureEvent) => this.onPanGesture(event, 'onActionUpdate'),
        onSwipeGestureActionEvent: (event?: GestureEvent) => {
          this.onSwipeGesture(event);
        },
        isEnableMouseTypeStyle: this.isEnableMouseTypeStyle(),
      })

      // 遮罩，用于防止下拉窗口未消失时再度触发事件
      this.buildTouchOverlay()

      if (this.blurButtonVM.getIsButtonClick()) {
        this.buildFuzzyLayer();
      }
    }
    .width('100%')
  }

  @Builder
  buildTouchOverlay() {
    Column() {}
    .width('100%')
    .height('100%')
    .hitTestBehavior(HitTestMode.Block)
    .visibility(this.statusBarMaskState.showAnimatingMaskLayer ? Visibility.Visible : Visibility.None)
  }

  @Builder
  buildFuzzyLayer() {
    Column() {}
    .width('100%')
    .height('100%')
    .backgroundBlurStyle(BlurStyle.BACKGROUND_THICK, {
      policy: 1,
      colorMode: ThemeColorMode.LIGHT,
      adaptiveColor: AdaptiveColor.DEFAULT,
      scale: 0.1
    })
    .onTouch((event?: TouchEvent) => {
      if (event?.type === TouchType.Up) {
        this.blurButtonVM.unblur();
      }
    })
  }

  private clearDelayRunnable(): void {
    log.showInfo('clearDelayRunnable');
    clearTimeout(this.delayCheckDismiss);
  }

  private setDelayAwakeDismiss(): void {
    this.clearDelayAwakeDismiss();
    log.showInfo('setDelayAwakeDismiss');
    this.delayCheckAwakeDismiss = setTimeout(() => {
      this.clearDelayAwakeDismiss();
      if (SCBSceneSessionManager.getInstance().isPcMode() &&
        MultiInputViewModel.getInstance().isPreventHideTitleBarStatusBar()) {
        // consume click title before hide status bar
        MultiInputViewModel.getInstance().setPreventHideTitleBarStatusBar(false);
        this.setDelayAwakeDismiss();
        return;
      }
      log.showInfo(`not receive touch during last ${CHECK_AWAKE_DISMISS} ms, dismiss panel`);
      SCBSceneSessionManager.getInstance().setIsShowStatusBarTemporary(false);

      if (!this.isSystemBarEnable() && !ViewManagerPolicy.isViewShowing(ViewType.DROPDOWN) &&
        !bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_LIST)) {
        scbStatusBarVM.onIsBarShow(false, true);
      }
    }, CHECK_AWAKE_DISMISS);
  }

  private clearDelayAwakeDismiss(): void {
    log.showInfo('clearDelayAwakeDismiss');
    clearTimeout(this.delayCheckAwakeDismiss);
    this.delayCheckAwakeDismiss = undefined;
  }

  hideSelf() {
    log.showDebug('hideSelf');
    this.postDropdownShowEvent(false);
    viewMgrPolicy.hideView(ViewType.DROPDOWN);
  }

  /**
   * 胶囊抢占态，状态栏常驻
   */
  private enableStatusBarKeepShowing(): boolean {
    return scbStatusBarStatusManager.getNeedStatusBarKeepShowing();
  }

  /**
   * 触摸事件处理
   *
   * @param event 事件
   */
  private onTouchEvent = (event?: TouchEvent, isFoldOuterFromTopBar?: boolean): void => {
    if (!event) {
      log.showInfo(`onTouchEvent event is invalid, isFoldOuterFromTopBar: ${isFoldOuterFromTopBar}`);
      return;
    }
    this.dropDownEvent.eventType = event.type;
    if (event.type === TouchType.Down) {
      this.touchOperLock = true;
      log.showInfo(`isEndTouch is false`)
      this.isEndTouch = false;
      this.currentTouchIsStylus = event.sourceTool === TOUCH_EVENT_TOOL_TYPE_PEN;
      scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_STATUS_BAR, true);
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      this.touchOperLock = false;
      scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_STATUS_BAR, false);
    }

    // 分发事件
    if (event.type === TouchType.Down) {
      const hasDropDownPanel = ViewManagerPolicy.isViewShowing(ViewType.DROPDOWN);
      const isDropDown = StatusBarManager.getInstance()?.isDropdown() ?? false;
      this.touchEventIsDropdown = isDropDown && hasDropDownPanel;
    }

    // 检查事件id（多个手指触发的事件互斥）
    if (!this.checkTouchEvent(event)) {
      return;
    }

    // 手写笔事件内滑笔势，禁用下拉双中心
    if (this.checkStylusInwardSlideGesture(event)) {
      this.statusBarTouchUpOrCancel('checkStylusInwardSlideGesture', event);
      return;
    }

    // 双中心互切statusbar不做处理 分发给dropdown 处理
    if (this.touchEventIsDropdown) {
      sEventManager.publish(obtainLocalEvent(CommonEventConstants.STATUS_BAR_DROPDOWN_TOUCH, event));
      return;
    }

    // 手势防误触开启时，屏蔽手写笔的状态栏下拉
    if (event.sourceTool === SourceTool.Pen && ForbiddenGestureVm.instance.isForbiddenGestureEnable()) {
      this.statusBarTouchUpOrCancel('isForbiddenGestureEnable', event);
      return;
    }

    if (!this.isTouchEnable(event) || this.isEndTouch) {
      // 避免下拉过程中禁用状态栏touch事件，导致touch事件中断，无法闭环会拉出来一个透明面板
      this.statusBarTouchUpOrCancel('onTouchEvent->untouchable', event);
      log.showInfo(`isEndTouch is true`)
      this.isEndTouch = true;
      return;
    }

    switch (event.type) {
      case TouchType.Down:
        Trace.start(Trace.CORE_METHOD_START_TOUCH_EVENT);
        this.hasScreenShot = false;
        this.hasUpdateDropDownStatusBarColor = false;
        // 更新isOsAccountUnlocked标志位
        this.refreshOsAccountUnlockedFlag();
        this.hasUpdateDropDownStatusBarColor = false
        // DOWN事件初始化事件
        DropDownPanelManager.clearState();
        this.clearDelayAwakeDismiss();
        this.dropDownStatus.isTouchingStatusBar = true;
        this.isShowWindow = false;
        this.isCCPickColorUpdated = false;
        this.isNCPickColorUpdated = false;
        this.isPickColorReady = false;
        this.isShowTargetPanel = false;
        // 记录Down点
        this.startEvent = event;
        this.startX = event.changedTouches[0].screenX;
        this.startY = event.changedTouches[0].screenY;
        this.lastX = this.startX;
        this.lastY = this.startY;
        this.isNeedShowBySpeed = false;
        this.isFoldOuterFromTopBar = isFoldOuterFromTopBar;
        this.targetPanelByTouchX = DropDownPanelManager.checkTargetPanelByTouchX(this.startX);
        log.showWarn(`onTouchEvent touchStart, startX: ${this.startX}, startY: ${this.startY}`);
        StatusBarManager.getInstance()?.getMoveDownVM().startMoveDown();
        AppStorage.setOrCreate('touchStatusBar', true);
        AppStorage.setOrCreate('touchStatusBarToCloseOuterCardMenu', true);
        break;
      case TouchType.Move:
        this.statusBarTouchMove(event, isFoldOuterFromTopBar);
        break;
      case TouchType.Up:
      case TouchType.Cancel:
        this.statusBarTouchUpOrCancel('onTouchEvent->up or cancel', event);
        break;
    }
  }

  /**
   * 检查触摸事件
   *
   * @param event 事件
   */
  checkTouchEvent(event: TouchEvent): boolean {
    const changedTouchId = event.changedTouches[0].id;

    // 屏幕朗读时不做事件限制
    if (AccessibilityUtil.isAccessibilityMode()) {
      this.currentTouchId = undefined;
      return true;
    }
    this.dropDownEvent.eventType = event.type;
    switch (event.type) {
      case TouchType.Down:
        if (this.currentTouchId === undefined && this.isTouchEnable(event)) {
          this.currentTouchId = event.changedTouches[0].id;
          log.showWarn(`down currentTouchId = ${this.currentTouchId}`);
        }
        break;
      case TouchType.Up:
      case TouchType.Cancel:
        if (changedTouchId === this.currentTouchId) {
          log.showInfo(`Up or Cancel currentTouchId = ${this.currentTouchId}`);
          this.currentTouchId = undefined;
          return true;
        }
        break;
    }

    if (changedTouchId !== this.currentTouchId) {
      log.showWarn(`changedTouchId: ${event.changedTouches[0].id} currentTouchId:${this.currentTouchId}`);
      return false;
    }

    return true;
  }

  private statusbarCommonEnable(event?: TouchEvent): boolean {
    // DFX-DFM产线模式下禁止下拉双中心
    if (this.isDFXDFMLineMode) {
      log.showInfo('now is isDFXDFMLineMode, disable the drop-down status bar!');
      return false;
    }

    // 灭屏场景禁止下拉控制中心
    if (DropDownPanelManager.isCurScreenOff()) {
      log.showInfo('current screen is off');
      return false;
    }

    if (this.mmiTestRunningManager.checkIsMmiTestRunningForbidden(event, 'statusBarOnTouch')) {
      return false;
    }

    // 热安全模式下禁止下拉双中心
    if (this.isInThermalSafeMode) {
      log.showInfo('now is isInThermalSafeMode, onTouchEvent event is invalid!');
      return false;
    }

    // 置顶应用达到限制弹窗出现禁止下拉双中心
    if (DropDownPanelManager.checkDropdownCallback()) {
      log.showDebug(`PinTopLimitDialog or NtfCloseDialog is showing.`);
      return false;
    }

    // oobe intercept
    if (sSCBOobeManager.isEnable() || SCBOobeManager.isOobeActivated()) {
      log.showInfo('SCBOobeManager is Enable');
      return false;
    }
    // 检查状态栏是否被禁用（其他模块会调用接口禁用状态栏）
    if (!scbStatusBarStatusManager.isStatusBarEnable()) {
      log.showInfo('statusbar is not enable');
      return false;
    }
    return true;
  }

  /**
   * mouse 悬浮、点击状态栏 是否可用
   * @param leftArea 鼠标在左区域
   */
  private onMouseStyleEvent = (leftArea: boolean, rightArea: boolean): boolean => {
    // 手指touch、鼠标click公共能力判断
    if (!this.statusbarCommonEnable()) {
      return false;
    }
    if (ScreenLockApi.getLock()) {
      if (this.isPwdVisible) {
        return false;
      }
      if (!this.enableControllerCenter) {
        log.showInfo('controllerCenter disable pull-down');
        return false;
      }
      // 锁屏不允许下拉通知中心
      if (leftArea) {
        return false;
      }
      if (rightArea && !DropDownPanelManager.getControlCenterDownInLockEnable()) {
        return false;
      }
    }
    return true;
  }

  /**
   * Touch 事件是否可用
   */
  private isTouchEnable(event: TouchEvent): boolean {
    // 手指touch、鼠标click公共能力判断
    if (!this.statusbarCommonEnable(event)) {
      return false;
    }

    // 手势互斥
    if (scbEventExclusiveManager.isExclusive(EventType.GESTURE_STATUS_BAR)) {
      // 单指操作，如果存在手势互斥，通知相应的模块去关闭相应的手势
      if (event.touches?.length === 1) {
        scbEventExclusiveManager.restoreAllEventExclusive(EventType.GESTURE_STATUS_BAR);
      }
      log.showInfo('statusbar gesture ignore');
      return false;
    }

    // 从双中心进入应用，不允许立即下拉
    if (DropdownVm.instance.isDropdownOnly) {
      log.showInfo('isDropdownOnly is true, not allow touch');
      return false;
    }
    return true;
  }

  private statusBarTouchUpOrCancel(info?: string, event?: TouchEvent) {
    StatusBarManager.getInstance()?.getMoveDownVM().endMoveDown();
    this.touchOperLock = false;
    // 增加调用者信息日志
    log.showWarn('onTouchEvent touchEnd, progress : ' + this.dropDownEvent.progress + ` info: ${info}`);
    // 沉浸式下， 手指离开状态栏重新进入2.25秒的倒计时，并且点击胶囊显示横幅，状态栏不消失
    if (!this.isSystemBarEnable() && !ViewManagerPolicy.isViewShowing(ViewType.NOTIFICATION_BANNER)) {
      this.setDelayAwakeDismiss()
    }
    scbEventExclusiveManager.setEventExclusive(EventType.GESTURE_STATUS_BAR, false);
    // event 不存在销毁 DropDownPanel
    if (!event) {
      DropDownPanelManager.hideWindowDirectly();
      log.showWarn(`hideWindowDirectly`);
      return;
    }
    this.touchEventIsDropdown = this.dropDownEvent.progress === 1;
    if (this.touchEventIsDropdown) {
      if (StatusBarManager.getInstance()?.isDropdown()) {
        log.showInfo(`isDropdown = ${StatusBarManager.getInstance()?.isDropdown()}`);
        statusBarMaskManager.setStatusBarMaskState(false);
      } else {
        setTimeout(() => {
          statusBarMaskManager.setStatusBarMaskState(false);
        }, DropDownPanelConstants.NOTIFICATION_TIME_VIEW_SHOW_DELAY);
      }
    }
    this.dropDownStatus.isTouchingStatusBar = false;
    let targetPanel: TargetPanel = this.targetPanelByTouchX;
    if (targetPanel === TargetPanel.CONTROL_CENTER_PANEL && !DropDownPanelManager.isControlCenterKioskAllow()) {
      log.showInfo('Kiosk mode disable into CC!');
      if (ScreenLockApi.getLock()) {
        this.screenMoveEvent = event;
      }
      return;
    }
    // 直接下拉密码界面
    if (ScreenLockApi.getLock() &&
      ((targetPanel !== TargetPanel.CONTROL_CENTER_PANEL) ||
        (targetPanel === TargetPanel.CONTROL_CENTER_PANEL && !DropDownPanelManager.getControlCenterDownInLockEnable()) ||
        (targetPanel === TargetPanel.CONTROL_CENTER_PANEL && !this.isOsAccountUnlocked))) {
      this.screenMoveEvent = event;
      log.showWarn(`touch ScreenLock`);
    } else {
      this.dropDownProgressCheck(targetPanel);
      // 检测回弹动效
      DropDownPanelManager.touchEndCheckAnim();
    }
  }

  private dropDownProgressCheck(targetPanel: TargetPanel) {
    if (this.dropDownEvent.progress < 1) {
      log.showWarn(`dropDownProgressCheck`);
      this.isNeedShowBySpeed = !this.isEndTouch;
      // 抬手时若面板未显示需要清理蒙层，避免无面板执行消失逻辑导致蒙层不消失
      if (!ViewManagerPolicy.isViewShowing(ViewType.DROPDOWN)) {
        statusBarMaskManager.setStatusBarMaskState(false);
      } else {
        this.delayCheckDismiss = setTimeout(() => {
          log.showInfo('not receive speed, dismiss panel');
          if (targetPanel !== TargetPanel.NOTIFICATION_PANEL) {
            AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
          }
          DropDownPanelManager.animToDismiss();
        }, CHECK_DISMISS);
      }
    } else {
      this.isNeedShowBySpeed = false;
    }
  }

  private onPanGesture(event: GestureEvent, action: string): void {
    if (!StatusBarManager.getInstance()?.isDropdown()) {
      return;
    }

    sEventManager.publish(obtainLocalEvent(CommonEventConstants.STATUS_BAR_DROPDOWN_PAN, { event, action }));
  }

  private onSwipeGesture(event?: GestureEvent) {
    if (!event) {
      log.showInfo('SwipeGesture event is invalid');
      return;
    }
    if (!this.swipeGestureEnable(event)) {
      return;
    }
    let isTouchpadDevice: boolean = event.sourceTool === SourceTool.TOUCHPAD;
    if (StatusBarManager.getInstance()?.isDropdown()) {
      // 下拉后，在状态栏触控板双指上划可以支持收起面板
      if (event.speed > MIN_SPEED_VALUE && event.angle < 0 && isTouchpadDevice) {
        log.showInfo(`already dropdown: Swipe speed${event.speed}, swipe angle${event.angle}`);
        this.clearDelayRunnable();
        DropDownPanelManager.animToDismiss();
      }
      return;
    }

    if (event.speed > MIN_SPEED_VALUE && event.angle > 0) {
      // 不满足下拉高度阈值，满足滑动阈值，展开面板
      let targetPanel: TargetPanel;
      if (isTouchpadDevice) {
        targetPanel = DropDownPanelManager.checkTargetPanelByTouchX(event?.fingerList[0].localX ?? 0);
      } else {
        targetPanel = DropDownPanelManager.checkTargetPanelByEvent(this.startEvent);
        if (targetPanel === TargetPanel.NONE) {
          log.showInfo('targetPanel = NONE');
          return;
        }
      }
      if (!DropDownPanelManager.checkKioskPanelEnable(targetPanel)) {
        return;
      }
      if (ScreenLockApi.getLock()) {
        if (targetPanel === TargetPanel.NOTIFICATION_PANEL ||
          (targetPanel === TargetPanel.CONTROL_CENTER_PANEL && this.isPwdVisible) ||
          (targetPanel === TargetPanel.CONTROL_CENTER_PANEL && !this.enableControllerCenter) ||
          (targetPanel === TargetPanel.CONTROL_CENTER_PANEL && !this.isOsAccountUnlocked) ||
          (targetPanel === TargetPanel.CONTROL_CENTER_PANEL &&
          !DropDownPanelManager.getControlCenterDownInLockEnable())) {
          return;
        }
      }
      this.clearDelayRunnable();
      log.showInfo(`isShowTargetPanel= ${this.isShowTargetPanel}, targetPanel = ${targetPanel},
      currentTargetPanel = ${DropDownPanelManager.getCurrentTargetPanel()}`)
      if (isTouchpadDevice) {
        DropDownPanelManager.animToShow(targetPanel);
      } else {
        DropDownPanelManager.animToShow(this.isShowTargetPanel ? DropDownPanelManager.getCurrentTargetPanel()
          : targetPanel);
      }
      setTimeout(() => {
        statusBarMaskManager.setStatusBarMaskState(false);
      }, DropDownPanelConstants.NOTIFICATION_TIME_VIEW_SHOW_DELAY);
    } else {
      this.clearDelayRunnable();
      let targetPanel: TargetPanel = DropDownPanelManager.checkTargetPanelByEvent(this.startEvent);
      if (targetPanel === TargetPanel.NOTIFICATION_PANEL) {
        AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
      }

      // 不满足下拉条件，隐藏模糊背景
      DropDownPanelManager.animToDismiss();
    }
  }

  private swipeGestureEnable(event?: GestureEvent): boolean {
    // DFX-DFM产线模式下禁止下拉双中心
    if (this.isDFXDFMLineMode) {
      log.showInfo('now is isDFXDFMLineMode, disable the drop-down status bar!');
      return false;
    }

    if (this.mmiTestRunningManager.checkIsMmiTestRunningForbidden(undefined, 'statusbarSwipeGesture')) {
      return false;
    }

    // 热安全模式下禁止下拉双中心
    if (this.isInThermalSafeMode) {
      log.showInfo('now is isInThermalSafeMode, onTouchEvent event is invalid!');
      return false;
    }
    // 手写笔事件内滑笔势，禁用下拉双中心
    if (this.isInStylusInwardSlideGesture) {
      log.showInfo('now is isInStylusInwardSlideGesture, disable the drop-down status bar!');
      return false;
    }
    // oobe intercept
    if (sSCBOobeManager.isEnable()) {
      log.showInfo('SCBOobeManager is Enable');
      return false;
    }
    // 检查状态栏是否被禁用（其他模块会调用接口禁用状态栏）
    if (!scbStatusBarStatusManager.isStatusBarEnable()) {
      log.showInfo('statusbar is not enable');
      return false;
    }
    if (DropDownPanelManager.isCurScreenOff()) {
      log.showInfo('current screen is off');
      return false;
    }
    log.showInfo(`SwipeGesture speed: ${event?.speed} angle: ${event?.angle} isNeedShowBySpeed : ${this.isNeedShowBySpeed}`);
    if (!this.isNeedShowBySpeed && event?.sourceTool !== SourceTool.TOUCHPAD) {
      return false;
    }
    if (scbEventExclusiveManager.isExclusive(EventType.GESTURE_STATUS_BAR)) {
      return false;
    }
    // 手写笔禁用时忽略手写笔的下拉速度
    if (this.currentTouchIsStylus && ForbiddenGestureVm.instance.isForbiddenGestureEnable()) {
      log.showInfo('ForbiddenStylus');
      return false;
    }
    return true;
  }

  private statusBarTouchMove(event: TouchEvent, isFoldOuterFromTopBar?: boolean): void {
    let newY = event.changedTouches[0].screenY;
    let startY = this.startY;
    let lastY = this.lastY;
    let moveY = newY - startY;
    // 滑动距离过小
    if (moveY < DropDownPanelManager.getTouchSlop()) {
      return;
    }
    let targetPanel: TargetPanel = this.targetPanelByTouchX;
    if (!DropDownPanelManager.checkKioskPanelEnable(targetPanel)) {
      if (ScreenLockApi.getLock()) {
        this.screenMoveEvent = event;
      }
      return;
    }
    if (ScreenLockApi.getLock()) {
      if (this.isPwdVisible) {
        return;
      }
      if (!this.enableControllerCenter) {
        log.showInfo('controllerCenter disable pull-down');
        return;
      }
      if (targetPanel === TargetPanel.NOTIFICATION_PANEL) {
        this.screenMoveEvent = event;
        this.systemUIStatusBarVm.changeIsShowNCAfterUnlock(true, 'DROPDOWN NC ON SCREENLOCK');
        log.showInfo('move by slice left of status bar on screenlock');
        return;
      }
      if (targetPanel === TargetPanel.CONTROL_CENTER_PANEL &&
        !DropDownPanelManager.getControlCenterDownInLockEnable()) {
        this.screenMoveEvent = event;
        log.showInfo('move by slice right of status bar on screenlock');
        return;
      }
      if (targetPanel !== TargetPanel.CONTROL_CENTER_PANEL) {
        log.showInfo('TargetPanel is CONTROL_CENTER_PANEL');
        return;
      }
      if (targetPanel === TargetPanel.CONTROL_CENTER_PANEL && !this.isOsAccountUnlocked) {
        this.screenMoveEvent = event;
        log.showInfo('isOsAccountUnlocked is false');
        return;
      }
    }
    // 满足最小滑动距离后的第一次move，显示窗口
    if (this.dropDownEvent.moveY === 0 && !this.isShowWindow) {
      DropDownPanelManager.setIsNtfPanel(targetPanel === TargetPanel.NOTIFICATION_PANEL);
        this.showDropdownWindow(targetPanel);
      return;
    }
    if (!this.isShowWindow) {
      return;
    }
    // moveY从0开始
    moveY = moveY - DropDownPanelManager.getTouchSlop();
    this.dropDownEvent.progress = Math.min(moveY / DropDownPanelManager.getPanelShowDistance(), 1);
    if (!this.isShowTargetPanel && moveY > DropDownPanelManager.getPanelShowDistance() / 2) {
      // 计算下拉目标面板
      DropDownPanelManager.setTargetPanel(this.targetPanelByTouchX);
      this.isShowTargetPanel = true;
      log.showInfo('isShowTargetPanel set true');
    }
    StatusBarManager.getInstance()?.getMoveDownVM().refreshMoveDisByDropDown(moveY);
    if (moveY < DropDownPanelManager.getPanelShowDistance()) {
      return;
    }
    if (this.isFirstShowDropDown) {
      this.dropDownEvent.pullFraction = DROP_DOWN_MIN_FRACTION;
      this.isFirstShowDropDown = false;
    }
    this.dropDownEvent.moveY = moveY - DropDownPanelManager.getPanelShowDistance();
    let newTranslateY = this.dropDownEvent.translateY + Math.exp(DropDownPanelConstants.FINGER_BEHAVIOR_K *
    this.dropDownEvent.moveY / this.displayHeight) * this.getTouchMoveY(newY - lastY) * this.dropDownEvent.pullFraction *
    this.dropDownEvent.progress; // 增加因子和进度，因子控制内容进入前后跟手幅度，进度限定幅度变化在下拉到达阈值前有效（阈值后为1）
    this.dropDownEvent.translateY = this.dropDownEvent.moveY > 0 && newTranslateY > 0 ? newTranslateY : 0;

    this.lastX = event.changedTouches[0].screenX;
    this.lastY = event.changedTouches[0].screenY;

    log.showDebug(`onTouchEvent Move dropDownEvent in statusBar: ${this.dropDownEvent?.translateY}`);
  }

  private getTouchMoveY(touchMoveY: number): number {
    if (this.colorModeViewData.isUseSolidColor()) {
      return MAX_TOUCH_MOVE * (1 - Math.exp(-Math.abs(touchMoveY) / MAX_TOUCH_MOVE)) * Math.sign(touchMoveY);
    } else {
      return touchMoveY;
    }
  }

  private reportTrace(targetPanel: TargetPanel) {
    Trace.end(Trace.CORE_METHOD_START_TOUCH_EVENT)
    Trace.start(Trace.CORE_METHOD_START_DROP_DOWN_PANEL);
    if (targetPanel === TargetPanel.CONTROL_CENTER_PANEL) {
      TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_SHOW);
      let screenInfo = DropDownPanelManager.getScreenInfo();
      HiSysEventUtil.reportControlCenterShow({
        POINTX: this.startX,
        POINTY: this.startY,
        RESOLUTION: `${screenInfo.width}x${screenInfo.height}`,
        TIMESTAMP: `${DropDownPanelManager.updateDropDownTime()}`,
        ORIENTATION: this.isDisplayLand() ? 1 : 0,
        LOCKSTATUS: AppStorage.get('lockStatus'),
        QUICKTOGGLEDATA: DropDownPanelManager.getQuickToggleData(),
        SCREENTYPE: 0,
      });
    } else if (targetPanel === TargetPanel.NOTIFICATION_PANEL) {
      TraceUtil.startTrace(DomainName.NC, Trace.CORE_METHOD_NOTIFICATION_PANEL_SHOW);
      let screenInfo = DropDownPanelManager.getScreenInfo();
    }
  }

  private getCurrentNtfCount(): number {
    return NotificationDataManager.instance.ntfMap.size;
  }

  private getCurrentMainNtfCount(): number {
    return this.getCurrentNtfCount() - this.getCurrentMoreNtfCount();
  }

  private getCurrentMoreNtfCount(): number {
    let moreNtfNum: number = 0;
    NotificationDataManager.instance.ntfMap.forEach((ntf) => {
      if (ntf.isMoreNtf()) {
        moreNtfNum++;
      }
    });
    return moreNtfNum;
  }

  private showDropdownWindow(targetPanel: TargetPanel) {
    this.reportTrace(targetPanel);
    if (targetPanel === TargetPanel.NOTIFICATION_PANEL) {
      // 下拉通知中心打断铃声和振动
      InnerEventUtil.post(NtfCenterDropDownEvent, new NtfCenterDropDownEvent());
    }
    this.updateDropDownStatusBarContentColor();
    AppStorage.setOrCreate('isInScreenSnapshot', true);
    if (!this.hasScreenShot) {
      let screenId: number = 0;
      if (SCBScreenSessionManager.getInstance().getMainScreenSession()?.session) {
        screenId = SCBScreenSessionManager.getInstance().getMainScreenSession().session.screenId;
      }
      const hasPrivateWindow = display.hasPrivateWindow(screenId);
      log.showInfo('hasPrivateWindow: %{public}b', hasPrivateWindow);
      if (!hasPrivateWindow) {
        this.getSnapshotAndDegree(screenId);
      }
    }
    if (ENABLE_FORCE_CLOSE_HDR) {
      SCBScreenSessionManager.getInstance().setForceCloseHdr(true);
    }
    AppStorageUtil.setOrCreate('isMarkingRenderGroup', true, new DataProperty(true, false));
    this.isFirstShowDropDown = true;
    this.postDropdownShowEvent(true);
    if (targetPanel === TargetPanel.NOTIFICATION_PANEL) {
      AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START, systemUIWorkerManager.tid);
    }
    TraceUtil.startTrace(DomainName.CC, TraceUtil.SHOW_DROPDOWN_PANEL);
    viewMgrPolicy.showView(ViewType.DROPDOWN); // 下拉面板
    TraceUtil.endTrace(DomainName.CC, TraceUtil.SHOW_DROPDOWN_PANEL);
    this.isShowWindow = true;
  }

  private handleAverageColor(screenId: number) {
    try {
      TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_SCREEN_SHOT);
      /*getWithRange(this.getUIContext().getComponentSnapshot(), SNAPSHOT_START_NODE, SNAPSHOT_END_NODE, true,
        { scale: 0.5 }).then((pixMap: image.PixelMap) => {
          TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_SCREEN_SHOT);
          PixelMapUtil.addName(pixMap, `${TAG}_sceneBoardScreenShot_handleAverageColor`);
          taskpool.execute(getSnapshotAndDegree, screenId, Controller.backgroundType, pixMap, this.rotateAngle)
            .then((res: Object) => {
              const averageColor = (res as SnapshotAndDegree).averageColor;
              if (averageColor && averageColor !== this.colorModeLiveViewData.livePickColor) {
                this.colorModeLiveViewData.livePickColor = averageColor;
                this.colorModeLiveViewData.liveListBgColor =
                  this.colorModeViewData.calcPrimarySolidColor(this.colorModeViewData.liveListItemBgColor,
                    this.colorModeViewData.bannerCardOption, averageColor);

                this.colorModeLiveViewData.liveBgPickColor =
                  this.colorModeViewData.convertResourceColorToEffectColor(this.colorModeLiveViewData.liveListBgColor);
              }
            }).catch((err: BusinessError) => {
              log.error('taskpool.execute error', err);
            }).finally(() => {
              pixMap?.release();
          });
        }).catch((err: Error) => {
          log.showError(`getComponentSnapshot error: ${err}`);
      })*/
    } catch (error) {
      log.error('getSnapshotAndDegree error', error);
    }
    this.hasScreenShot = true;
  }

  private setNtfLiveColor(averageColor: effectKit.Color) {
    if (averageColor && averageColor !== this.colorModeLiveViewData.livePickColor) {
      this.colorModeLiveViewData.livePickColor = averageColor;
    }
  }

  private setNCColor(averageColor: effectKit.Color) {
    if (averageColor && averageColor !== this.colorModeNCViewData.pickColor) {
      this.colorModeNCViewData.pickColor = averageColor;
    }
  }

  private getSnapshotAndDegree(screenId: number) {
    try {
      TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_SCREEN_SHOT);
      /*getWithRange(this.getUIContext().getComponentSnapshot(), SNAPSHOT_START_NODE, SNAPSHOT_END_NODE, true,
        { scale: 0.5 }).then((pixMap: image.PixelMap) => {
          TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_SCREEN_SHOT);
          PixelMapUtil.addName(pixMap, `${TAG}_sceneBoardScreenShot_getSnapshotAndDegree`);
          taskpool.execute(getSnapshotAndDegree, screenId, Controller.backgroundType, pixMap, this.rotateAngle)
            .then((res: Object) => {
              let degree = (res as SnapshotAndDegree).degree;
              let averageColor = (res as SnapshotAndDegree).averageColor;
              let snapshot = (res as SnapshotAndDegree).snapshot;
              log.showInfo('getDegree: %{public}d in main thread', degree);
              Controller.setWallerPaperType(degree);
              Controller.updateLabelColor();
              this.setPickColor(averageColor);
              this.averageColor = averageColor;
              this.isPickColorReady = true;
              if (snapshot) {
                StaticBlurController.getInstance().saveSnapShot(snapshot);
              } else {
                log.error('snapshot is empty');
              }
            }).catch((err: BusinessError) => {
              log.error('taskpool.execute error', err);
          }).finally(() => {
            pixMap?.release();
          });
        }).catch((err: Error) => {
          log.showError(`getComponentSnapshot error: ${err}`);
      })*/
    } catch (error) {
      log.error('getSnapshotAndDegree error', error);
    }
    this.hasScreenShot = true;
  }

  private postDropdownShowEvent(isShow: boolean): void {
    let event = new WindowEvent();
    event.windowName = WindowConstants.WINDOW_NAME_DROPDOWN;
    event.eventType = isShow ? WindowEvent.EVENT_TYPE_SHOW : WindowEvent.EVENT_TYPE_HIDE;
    event.eventState = WindowEvent.EVENT_STATE_START;
    EvtBus.post(WindowEvent, event);
  }

  private updateDropDownStatusBarContentColor(): void {
    log.showInfo(`isKeyguardHide is ${this.isKeyguardHide}, scenePanelState is ${this.scenePanelState},` +
      `hasUpdateDropDownStatusBarColor is ${this.hasUpdateDropDownStatusBarColor}`);
    if (!this.hasUpdateDropDownStatusBarColor) {
      this.hasUpdateDropDownStatusBarColor = true;
    }
  }

  private checkStylusInwardSlideGesture(event: TouchEvent): boolean {
    log.showDebug('check stylus inward slide gesture');
    if (event.sourceTool !== TOUCH_EVENT_TOOL_TYPE_PEN) {
      log.showDebug('not stylus event, return');
      this.isInStylusInwardSlideGesture = false;
      return false;
    }

    switch (event.type) {
      case TouchType.Down:
        let screenWidth: number = this.screenProp.width;
        let statusBarHeight: number = vp2px(ResUtils.getNumber($r('app.float.status_bar_phone_height')));
        let hotArea: SCBSessionRect =
          new SCBSessionRect(screenWidth - 2 * statusBarHeight, 0, 2 * statusBarHeight, statusBarHeight);
        let downX: number = event.changedTouches[0].screenX;
        let downY: number = event.changedTouches[0].screenY;
        if (hotArea.contains(vp2px(downX), vp2px(downY))) {
          log.showInfo('stylus down hit inward-slide hot area');
          this.isInStylusInwardSlideGesture = true;
        }
        break;
      case TouchType.Up:
      case TouchType.Cancel:
        if (this.isInStylusInwardSlideGesture) {
          setTimeout(() => {
            this.isInStylusInwardSlideGesture = false;
          }, STYLUS_SLIDE_RESET_DELAY);
          return true;
        }
        break;
      default:
        break;
    }
    if (this.isInStylusInwardSlideGesture) {
      return true;
    }
    return false;
  }

  /**
   * 判断设备是否是折叠状态
   */
  private getFolded(foldStatus: display.FoldStatus): boolean {
    if (foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED) {
      return true;
    }
    return false;
  }

  private registerThermalMode(): void {
    DesktopModeManager.getInstance()
      .registerModeChangeCallback(TAG, (preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum) => {
        log.showInfo(`notify preDesktopMode: ${preDesktopMode}, targetDesktopMode: ${targetDesktopMode}`);
        this.updateInThermalSafeMode(targetDesktopMode);
        this.updateInEmergencyMode(targetDesktopMode);
      });
  }

  private updateInThermalSafeMode(targetDesktopMode: DesktopModeEnum): void {
    if (targetDesktopMode === DesktopModeEnum.THERMAL_SAFE_MODE) {
      this.isInThermalSafeMode = true;
    } else {
      this.isInThermalSafeMode = false;
    }
  }

  private updateInEmergencyMode(targetDesktopMode: DesktopModeEnum): void {
    if (targetDesktopMode === DesktopModeEnum.EMERGENCY_MODE) {
      this.isInEmergencyMode = true;
    } else {
      this.isInEmergencyMode = false;
    }
  }

  private checkDFXDFMLineMode(): void {
    try {
      const isFactoryMode: boolean = SystemParameterHelper.getCompareResult('const.runmode', 'normal', 'factory');
      this.isDFXDFMLineMode = isFactoryMode;
      log.showInfo(`isFactoryMode : ${isFactoryMode} ,isDFXDFMLineMode: ${this.isDFXDFMLineMode}`);
    } catch (error) {
      log.error('handleDFXDFMLineMode error', error);
      this.isDFXDFMLineMode = false;
    }
  }

  /**
   * click事件处理
   * @param event
   */
  private onClickEvent = (event: ClickEvent): void => {
    if (this.bannerPanelType === BannerPanelType.TYPE_LIVE_LIST) {
      log.showInfo(`live list panel is show!`);
      return;
    }

    log.showInfo(`statusBar click com.openharmony.intent.action.CLICK_STATUSBAR and usual.event.CLICK_STATUSBAR`)
    try {
      log.showInfo(`statusBar click publish displayX = ${event.displayX}, displayY = ${event.displayY}`);
      let publishCallBack = ((err : BusinessError) => {
        if (err) {
          log.showError(` statusBar click publish failed, code = ${err.code}, message = ${err.message}`);
        } else {
          log.showInfo(`statusBar click publish success`);
        }
      });
      commonEventManager.publish(ACTION_CLICK_STATUSBAR, publishCallBack);
      commonEventManager.publish(EVENT_CLICK_STATUSBAR, publishCallBack);
    } catch (error) {
      log.showError('statusBar click failed', error);
    }
  }

  /**
   * 获取是否橫屏
   * HeadsUpCallback
   *
   * @return 获取是否橫屏
   */
  getIsWidestScreen(): boolean {
    log.showDebug(`isWidestScreen:  ${this.bannerState.displaySizeState.isWidestScreen()}`)
    return this.bannerState.displaySizeState.isWidestScreen();
  }

  private endStatusBarTouchEvent = () => {
    this.currentTouchId = undefined;
    this.statusBarTouchUpOrCancel('endStatusBarTouchEvent');
  }

  /**
   * 检查当前系统账号是否已认证解锁(开机后首次解锁前为false，之后为true)
   */
  private refreshOsAccountUnlockedFlag(): void {
    if (this.isOsAccountUnlocked) {
      return;
    }
    let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
    try {
      accountManager.isOsAccountUnlocked().then((isVerified: boolean) => {
        log.showInfo(`isOsAccountUnlocked successfully, isVerified=${isVerified}`);
        this.isOsAccountUnlocked = isVerified;
      }).catch((err: BusinessError) => {
        log.showError(`isOsAccountUnlocked failed, error code=${err?.code}`);
      });
    } catch (err) {
      log.showError(`refreshOsAccountUnlockedFlag failed, error code=${err?.code}`);
    }
  }

  /**
   * 设置状态栏显示区域
   */
  private refreshStatusBarRegion = (): void => {
    // 状态栏显示区域更新
    ArkUIAdapter.runWithScope(() => {
      let area: ScreenRect = {
        left: 0,
        top: 0,
        width: px2vp(this.screenProp.width),
        height: StatusBarHeightVm.getInstance().getShowHeight()
      };
      this.viewController.updateArea(area);
      this.viewController.updateRect(area);
      log.showInfo(`refreshStatusBarRegion width ${area.width} height ${area.height}`);
      new StatusBarMaintenance().reportStatusBarInfo(undefined, {
        areaStr: `${area.left}_${area.top}_${area.width}_${area.height}`
      });
    })
  }

  /**
   * 设置状态栏的热区计算逻辑
   */
  private refreshStatusBarResponseRegion = (): void => {
    // 隐私指示器热区优先级最高
    if (this.setPrivateHotRegion()) {
      return;
    }
    // titleBar和menu同等优先级
    if (this.setTitleBarHotRegion()) {
      return;
    }
    this.resetHotRegion();
  }

  private setPrivateHotRegion(): boolean {
    log.showInfo(`specialResponseRegionForPrivacy: ${this.specialResponseRegionForPrivacy}`);
    if (this.specialResponseRegionForPrivacy) {
      let responseRegions: Array<Rectangle> = [];
      const statusBarCurHeight = vp2px(StatusBarHeightVm.getInstance().getHotAreaHeight());
      let privacyMaxWidth = vp2px(ResUtils.getNumber($r('app.float.status_bar_privacy_max_width')));
      let leftRegion: Rectangle = {
        x: 0,
        y: 0,
        width: (this.screenProp.width - privacyMaxWidth) / 2,
        height: statusBarCurHeight
      };
      responseRegions.push(leftRegion);
      let center: Rectangle = {
        x: (this.screenProp.width - privacyMaxWidth) / 2,
        y: 0,
        width: privacyMaxWidth,
        height: vp2px(ResUtils.getNumber($r('app.float.status_bar_default_height')))
      };
      responseRegions.push(center);
      let rightRegion: Rectangle = {
        x: (this.screenProp.width - privacyMaxWidth) / 2 + privacyMaxWidth,
        y: 0,
        width: (this.screenProp.width - privacyMaxWidth) / 2,
        height: statusBarCurHeight
      };
      responseRegions.push(rightRegion);
      this.viewController.setResponseRegion(responseRegions);
      return true;
    }
    return false;
  }

  private setTitleBarHotRegion(): boolean {
    let leftRegion: Rectangle;
    let rightRegion: Rectangle;
    let responseRegions: Array<Rectangle> = [];
    const statusBarCurHeight = vp2px(StatusBarHeightVm.getInstance().getHotAreaHeight());
    log.showInfo(`specialResponseRegion: ${this.specialResponseRegion}`);
    if (this.specialResponseRegion === ResponseRegionsClipType.PAD_TITLE_BAR) {
      leftRegion = {
        x: 0,
        y: 0,
        width: (this.screenProp.width - vp2px(TITLE_RESPONSE_WIDTH)) / 2,
        height: statusBarCurHeight
      };
      responseRegions.push(leftRegion);
      rightRegion = {
        x: (this.screenProp.width + vp2px(TITLE_RESPONSE_WIDTH)) / 2,
        y: 0,
        width: this.screenProp.width - (this.screenProp.width + vp2px(TITLE_RESPONSE_WIDTH)) / 2,
        height: statusBarCurHeight
      };
      responseRegions.push(rightRegion);
      this.viewController.setResponseRegion(responseRegions);
      return true;
    } else if (this.specialResponseRegion === ResponseRegionsClipType.PHONE_TITLE_BAR) {
      leftRegion = {
        x: 0,
        y: 0,
        width: (this.screenProp.width - vp2px(PHONE_TITLE_RESPONSE_WIDTH)) / 2,
        height: statusBarCurHeight
      };
      responseRegions.push(leftRegion);
      rightRegion = {
        x: (this.screenProp.width + vp2px(PHONE_TITLE_RESPONSE_WIDTH)) / 2,
        y: 0,
        width: this.screenProp.width - (this.screenProp.width + vp2px(PHONE_TITLE_RESPONSE_WIDTH)) / 2,
        height: statusBarCurHeight
      };
      responseRegions.push(rightRegion);
      this.viewController.setResponseRegion(responseRegions);
      return true;
    } else if (this.specialResponseRegion === ResponseRegionsClipType.PHONE_MENU) {
      leftRegion = {
        x: 0,
        y: 0,
        width: (this.screenProp.width - vp2px(PHONE_TITLE_MENU_RESPONSE_WIDTH)) / 2,
        height: statusBarCurHeight
      };
      responseRegions.push(leftRegion);
      rightRegion = {
        x: (this.screenProp.width + vp2px(PHONE_TITLE_MENU_RESPONSE_WIDTH)) / 2,
        y: 0,
        width: this.screenProp.width - (this.screenProp.width + vp2px(PHONE_TITLE_MENU_RESPONSE_WIDTH)) / 2,
        height: statusBarCurHeight
      };
      responseRegions.push(rightRegion);
      this.viewController.setResponseRegion(responseRegions);
      return true;
    } else {
      return false;
    }
  }

  private resetHotRegion(): void {
    let responseRegions: Array<Rectangle> = [];
    log.showInfo(`reset hot region, specialResponseRegion: ${this.specialResponseRegion}`);
    const statusBarCurHeight = vp2px(StatusBarHeightVm.getInstance().getHotAreaHeight());
    let responseRegion: Rectangle = {
      x: 0,
      y: 0,
      width: this.screenProp.width,
      height: statusBarCurHeight
    };
    responseRegions.push(responseRegion);
    this.viewController.setResponseRegion(responseRegions);
  }
}
