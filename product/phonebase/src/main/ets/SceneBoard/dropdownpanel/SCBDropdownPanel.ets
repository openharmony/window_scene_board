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

import { CommonConstants } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { ColorModeViewData,
  ColorModeViewModel,
  EventBroadcast,
  OverlayAnimData,
  statusBarMaskManager,
  StatusBarType,
  SysUiWindowType } from '@ohos/systemuicommon/Index';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { CommonEventListener } from '@ohos/systemuicommon';
import { CommonEventSubscribeManager as CEBMgr, DarkModeState, MultimodalInputManager } from '@ohos/systemuicommon';
import parameter from '@ohos.systemParameterEnhance';
import {
  AppStorageUtil,
  CommonUtils,
  DataProperty,
  DomainName,
  LogDomain,
  LogHelper,
  TraceUtil,
} from '@ohos/basicutils';
import {
  ResUtils,
  SCBEventId,
  SCBOobeManager,
  SCBPropertyChangeReason,
  SCBScreenProperty,
  sSCBOobeManager,
  windowMgr,
} from '@ohos/windowscene';
import { VisualEffectConstants, WindowConstants } from '@ohos/commonconstants';
import { RotationConstants, DeviceModeEnum, FASlotName, } from '@ohos/commonconstants';
import { PerformanceReporter, CurrentMemScene, } from '@ohos/frameworkcommon';
import {
  AnimationType,
  themeWallpaperAniMgr
} from '@ohos/themeservice/src/main/ets/service/themeservice/ThemeWallpaperAnimationManager';
import {
  CEManager,
  DropDownEvent,
  DropDownStatus,
  EventConstants,
  EventManager,
  EvtBus,
  GlobalContext,
  obtainLocalEvent,
  RequestWindowEvent,
  sEventManager,
  START_ABILITY_EVENT,
  START_SERVICE_EXT_EVENT,
  StartSceneFromOtherEvent,
  TargetChangeState,
  TargetPanel,
  unsubscribe,
  ViewCallback,
  ViewManagerPolicy,
  viewMgrPolicy,
  ViewType,
  ConfigurationEvent,
  DropDownPanelManagerWrapper,
  DeviceHelper,
  RssNotifyEvent,
  AnimPolicyRegistry,
  CommonComponent,
  TrimLevel,
} from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager, SCBScreenSessionManager } from '@ohos/windowscene';
import { DropDownPanelManager,
  PanelDismissReason
} from '@ohos/systemuicommon/Index';
import { ScreenLockApi } from '@ohos/screenlockcommon/src/main/ets/api/ScreenLockApi';
import { ScreenLockStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockStateManager';
import { LockStateInfo } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockStateManager';
import { ScreenLockStateManager } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockStateManager';
import { DarkModeChangeHandler } from '@ohos/notificationcomponent/src/main/ets/common/ConfigurationChangeHandler';
import { notificationConfigManager } from '@ohos/notificationcomponent/';
import { NtfAnimateEvent } from '@ohos/notificationcomponent/';
import { NtfAnimateStatus } from '@ohos/notificationcomponent/';
import { NtfBrightnessMode } from '@ohos/notificationcomponent/';
import NtfListComponentVM from '@ohos/notificationcomponent/src/main/ets/model/NtfListComponentVM';
import { NtfListContentConfig } from '@ohos/notificationcomponent/src/main/ets/vm/config/NtfViewConfig';
import { ntfSettingsDC } from '@ohos/notificationcomponent/src/main/ets/controller/NtfSettingsDialogController';
import { ntfViewConfigManager } from '@ohos/notificationcomponent/';
import { pinTopLimitDC } from '@ohos/notificationcomponent/src/main/ets/controller/PinTopLimitDialogController';
import { silenceDialogDC } from '@ohos/notificationcomponent/src/main/ets/controller/SilenceDialogController';
import { NotificationSettingBtn } from '@ohos/notificationcomponent/src/main/ets/pages/common/NotificationSettingBtn';
import { NotificationType } from '@ohos/notificationcomponent/src/main/ets/common/NotificationType';
import ControlCenterComponent from './control';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import curves from '@ohos.curves';
import {
  ControlCenterData,
  SceneModule
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/Constants';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import lazy ControlCenterController
  from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlCenterController';
import { ControlCenterHiSysEventUtil }
  from '@ohos/controlcentercommon/src/main/ets/hiSysEvent/ControlCenterHiSysEventUtil';

import { ViewControllerUtils } from '@ohos/frameworkcommon/Index';
import { DropdownController } from '@ohos/systemuicommon/src/main/ets/template/DropdownController';
import pluginComponentManager from '@ohos.pluginComponent';

import Want from '@ohos.app.ability.Want';

import {
  sIOTSubPageLayoutController
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/IOTSubPageLayoutController';
import {
  sPrivacySubLayoutController
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/PrivacySubPageLayoutController';
import {
  sMultimediaSubPageLayoutController
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/MultimediaSubPageLayoutController';
import {
  soundSubPageController
} from '@ohos/controlcentercomponent';
import { DropdownBackPressEvent } from '@ohos/controlcentercomponent/index';
import {
  QuickToggleController
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/QuickToggleController';
import { PluginToggleController } from '@ohos/plugincomponent/src/main/ets/controller/PluginToggleController';
import CommonEventManager from '@ohos.commonEventManager';
import CommunicationUtil from '@ohos/mediacontrolcomponent/src/main/ets/default/Util/CommunicationUtil';

import {
  StartAbilityOverlayAnimate
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/viewModel/StartAbilityOverlayAnimate';
import {
  StartAbilityOverlayAnimateData
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/model/StartAbilityOverlayAnimateData';
import {
  BrightnessSharedViewData
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/viewModel/BrightnessViewModel';
import { BackgroundBlurOpacity } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/model/BrightnessViewData';
import { BlurButtonVM, blurButtonVM } from '@ohos/notificationcomponent';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import InputConsumer from '@ohos.multimodalInput.inputConsumer';
import { liveStartAnimMgr } from '@ohos/systemuicommon/Index'
import { FingerprintAction, FingerprintEvent } from '@ohos.multimodalInput.shortKey';
import { ConfigurationConstant } from '@kit.AbilityKit';
import uiEffect from '@ohos.graphics.uiEffect';
import { SNAPSHOT_COMPONENT_ID, StaticBlurController } from '@ohos/systemuicommon/src/main/ets/template/staticBlur/StaticBlurController'
import { StaticBlurViewData } from '@ohos/systemuicommon/src/main/ets/template/staticBlur/StaticBlurViewData'
import PluginCardController from '@ohos/plugincardcomponent/src/main/ets/default/controller/PluginCardController';
import {
  AccessibilityPageShowHide,
  AccessibilityUtil,
  DefaultPanelZIndex
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import {
  sBrightnessSubPageLayoutController
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/BrightnessSubPageLayoutController';
import {
  DISABLE_PIXEL_STRETCH_EFFECT,
  ANIMATION_BLUR_POLICY,
  ANIMATION_BLUR_STOP_TIME_NORMAL,
  ANIMATION_BLUR_STOP_TIME_ABNORMAL,
  ANIMATION_BLUR_CANCEL_THERMAL_LEVEL
} from '@ohos/systemuicommon/src/main/ets/template/common/SCBVisualEffectOption';
import { SliderButtonShareData } from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonViewData';
import { NtfListContentConfigPhone } from './ntf/NtfViewConfigPhone';
import { FlashlightTipsConstants } from '@ohos/screenlockcommon/src/main/ets/constants/FlashlightTipsConstants';
import { thermal } from '@kit.BasicServicesKit';
import { AccessibilityLevel } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityData';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import {
  SlMainStateType,
  SlStaticStateType,
  SlSubStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import { PowerStatusMonitor, PowerStatusEnum } from '@ohos/screenlockcommon/src/main/ets/monitor/PowerStatusMonitor';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { CellularDataVm, EnvVm } from '@ohos/systemuicommon/newIndex';
import lazy { NotificationPanelDc } from './view/NotificationPanelDc';
import { OuterHomeVm } from '@ohos/systemuicommon/Index';
import { EnterpriseConfig } from '@ohos/systemuicommon/src/main/ets/model/EnterpriseConfig';
import { DropdownVm } from '@ohos/systemuicommon/newIndex';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { StatusBarManager } from '@ohos/systemuicommon/src/main/ets/statusbar/manager/StatusBarManager';
import { call, observer } from '@kit.TelephonyKit';

const TAG = 'DropdownPanel-Index';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 窗口名
 */
const WINDOW_NAME = WindowConstants.WINDOW_NAME_DROPDOWN;

/**
 * 模糊参数
 */
const ALPHA_TOTALLY_BLUR = 200

/**
 * 缩放参数
 */
const DROPDOWN_SCALE = ResUtils.getNumber($r('app.float.dropdown_scale'));
const TRANSLATE_COEFFICIENT = 0.8;

interface PluginComponentTemplate {
  source: string; // 组件模板名
  ability: string; // 组件ability名
}
// 多模输入监听
interface CallbackTs {
  onPanelStateChange: (target: TargetPanel) => void
}

const MAX_FONT_SCALE: number = 1.15;


const VERTICAL_SWITCH_SPEED_THRESHOLD = 250;
const VERTICAL_SWITCH_DISTANCE_THRESHOLD = 100;
const STATUS_BAR_SHOW_DELAY = 500;
const SUBSCRIBE_KEY_COMBINATION_DELAY = 5000;

// 实时模糊最大可运行时间定义：2 * 60 * 60 * 1000
const ANIMATION_BLUR_STOP_TIME_MAX: number = 2 * 60 * 60 * 1000;

// 实时模糊可运行时间定义：30000
const ANIMATION_BLUR_STOP_TIME_30: number = 30000;

// 实时模糊可运行时间定义：15000
const ANIMATION_BLUR_STOP_TIME_15: number = 15000;

// 实时模糊可运行时间定义：10000
const ANIMATION_BLUR_STOP_TIME_10: number = 10000;

// 实时模糊可运行时间定义：7500
const ANIMATION_BLUR_STOP_TIME_7DOT5: number = 7500;

// 实时模糊可运行时间定义：5000
const ANIMATION_BLUR_STOP_TIME_5: number = 5000;

// 取消实时模糊温度档位：4
const ANIMATION_BLUR_STOP_THERMAL_LEVEL: number = 4;

// 下拉完成后关闭实时模糊
const ANIMATION_BLUR_CLOSE: number = 0;

// 实时模糊
const ANIMATION_BLUR_OPEN: number = 1;

// 定时实时模糊
const ANIMATION_BLUR_OPEN_TIMING: number = 2;

// 下拉时立即关闭实时模糊
const ANIMATION_BLUR_CLOSE_FROM_START: number = 3;

// DropDownPanel id
const SCB_DROPDOWN_PANEL_ID: string = 'SCBDropdownPanel';

// 清楚Lottie数据延迟20s
const DESTROY_LOTTIE_TIMEOUT: number = 20000;

// 跟手下拉单次刷新最大位移
const MAX_TOUCH_MOVE: number = 20;

@Component
export struct SCBDropdownPanel {
  /**
   * 下拉事件
   */
  @StorageLink('dropDownEvent')
  @Watch('onDropdownChanged')
  dropDownEvent: DropDownEvent = DropDownPanelManager.getDropDownEvent();

  @State darkModeData: DarkModeState = new DarkModeState();
  private dropdownCtrl: DropdownController = DropdownController.getInstance();
  private isFolded: boolean = !DeviceHelper.isFoldExpandedOrHalf();

  private darkModeChangedHandler = new DarkModeChangeHandler(TAG, (isDark: boolean) => {
    this.darkModeData.isDarkMode = isDark;
  })

  /**
   * 是否回收资源
   */
  @Provide trimMemory: boolean = false;
  /**
   * 主动触发下拉
   */
  @StorageLink('isAnimToHide') @Watch('animToHideActively') isAnimToHide: boolean = false;
  private dropDownStatus: DropDownStatus = DropDownPanelManager.getDropDownStatus();
  /**
   * 横竖屏切换事件
   */
  @StorageLink('isLandscape') @Watch('onOrientationChanged') isLandscape: boolean = false;
  @StorageLink('needReleaseToggleIcon') needReleaseToggleIcon: boolean = false;
  /**
   * 监听用户切换变化
   */
  @StorageProp('privacyIndicatorUserChangeKey') @Watch('refreshPrivacyStateChange')
  privacyIndicatorUserChangeKey?: boolean = AppStorage.get<boolean>('privacyIndicatorUserChangeKey');

  /**
   * 灰阶提亮参数
   */
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  /**
   * 事件统一管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  @State isShowNotification: boolean = false;
  @State isShowControlCenter: boolean = false;
  @State notificationZIndex: number = 1;
  @State controlZIndex: number = 1;
  @State statusBarLauncherOpacity: number = 1;
  @State statusBarKeyOpacity: number = 1;
  @State statusBarDropdownOpacity: number = 0;
  @State indexBackgroundColor: Resource = $r('app.color.statusbar_background_color_transparent');
  @State backdropBlurValue: number = 0;
  @State blurValue: number = 0;
  @State launcherOpacity: number = 1;
  @State dropdownOpacity: number = 0;
  @State keyguardOpacity: number = 0;
  persistentId: number = 0;
  private isDragDownFinishPrepared: boolean = false;
  @Provide microphoneDialogIsOpen: boolean = false;
  @Provide ntfSettingsDialogClose: boolean = true;
  @Provide closeNtfDialogClose: boolean = true;
  @Provide ntfSilenceDialogClose: boolean = true;
  @Provide pinTopLimitDialogClose: boolean = true;
  @Provide hwCastDialogIsOpen: boolean = false;
  @Provide superDeviceDialogIsOpen: boolean = false;
  @State @Watch('onControlCenterDataChanged') data: ControlCenterData = ControlCenterController.getData();
  /**
   * 桌面内缩，缩放参数
   */
  @State pixelStretch: number = 0
  @State windowBlurValue: number = 0;
  @ObjectLink screenProp: SCBScreenProperty;
  private windowWidth: number = 0;
  private windowHeight: number = 0;
  private isRealTimeBlur: boolean = true;
  /**
   * 面板触摸down点，全局Y轴点，-1无触摸
   */
  @Provide panelDownGlobalY: number = -1;

  // 面板触摸down点，全局X轴点，-1无触摸
  @Provide panelDownGlobalX: number = -1;

  @State isFreezeEffectComponent: boolean = false;
  /**
   * 监听集合
   */
  mClearCallbacks: unsubscribe[] | undefined = undefined;
  /**
   * 下拉事件进度
   */
  progress: number = 0;
  /**
   * 整个屏幕高度
   */
  displayHeight: number = 0;
  /**
   * 上一次手指的y值
   */
  lastY: number = 0;
  /**
   * 手指起始Y值
   */
  private startY: number = 0;
  /**
   * 手指抬手y值
   */
  private endY: number = 0;
  /**
   * Y轴手指移动速度
   */
  private speedY: number = 0;
  private target: TargetPanel = TargetPanel.NOTIFICATION_PANEL;
  private lastTarget: TargetPanel = TargetPanel.NOTIFICATION_PANEL;
  private blurCurves: curves.ICurve = curves.cubicBezierCurve(0.4, 0.0, 0.55, 1.0);
  private scaleCurves: curves.ICurve = curves.cubicBezierCurve(0.33, 0.2, 0.7, 1.0);
  private panelCurves: curves.ICurve = curves.cubicBezierCurve(0.33, 0, 0.67, 1);
  private screenRotateAngle: number = 0;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private currentMemScene: CurrentMemScene = CurrentMemScene.FREE;
  private blurRadius: number = ResUtils.getNumber($r('app.float.dropdown_panel_background_radius'));
  private saturation: number = ResUtils.getNumber($r('app.float.dropdown_panel_background_saturation'));
  private closeDropdownPanelEvent = (isClose: boolean): void => {
    log.showInfo(`close dropdown panel event: ${isClose}`);
    if (isClose) {
      DropDownPanelManager.hideWindowDirectly();
    }
  }

  /**
   * 是否在收起过程中
   */
  private isDismissing: boolean = false;
  @StorageLink('isSceneBoardNewStyle') isSceneBoardNewStyle: boolean = false;

  @StorageLink('isDropdownPanelStaticShow') isDropdownPanelStaticShow: boolean = true;
  /**
   * 背景模糊VM
   */
  @State blurButtonVM: BlurButtonVM = blurButtonVM;

  // 启动应用动效相关参数
  @State startAbilityAnimateData: StartAbilityOverlayAnimateData = new StartAbilityOverlayAnimateData();

  // 通知启动动效相关参数
  @State @Watch('overlayAnimDataChanged') overlayAnimData: OverlayAnimData = NtfListComponentVM.overlayAnimData;

  // 拖动亮度条相关动效参数
  @State sliderShareData: SliderButtonShareData = SliderButtonShareData.getInstance();
  @State @Watch('onBlurOpacityChanged') blurOpacity: BackgroundBlurOpacity =
    BrightnessSharedViewData.getInstance().getBlurOpacity();

  // 控制中心亮度条出现和隐藏时背板模糊和缩放的动效曲线
  private readonly brightnessAnimCurve = curves.cubicBezierCurve(0.33, 0.0, 0.67, 1.0);

  @StorageLink('controlCenterFontScale') controlCenterFontScale: number = 1;
  filter: uiEffect.Filter = uiEffect.createFilter();

  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;

  /**
   * 是否开启应急/热安全模式
   */
  @StorageProp('deviceModeState') @Watch('onChangeDataEmitter') deviceModeState: DeviceModeEnum =
    DeviceModeEnum.BASE_MODE;

  @State staticBlurViewData: StaticBlurViewData = new StaticBlurViewData();
  private staticBlurController: StaticBlurController = StaticBlurController.getInstance();
  // 扩展新形态小折叠产品适配双中心高度
  @State outerHeightOfNCAndCC: Length = ntfViewConfigManager.getListContentConfig().outerHeightOfNCAndCC;
  private listContentConfig: NtfListContentConfig = ntfViewConfigManager.getListContentConfig();
  private onOuterHeightOfNCAndCCChange: (outerHeightOfNCAndCC: Length) => void = (outerHeightOfNCAndCC: Length) => {
    this.outerHeightOfNCAndCC = outerHeightOfNCAndCC;
    log.showInfo(`outerHeightOfNCAndCC  ${this.outerHeightOfNCAndCC}`)
  }

  /**
   * 朗读模式是否开启
   */
  @StorageLink('isAccessibilityMode') isAccessibilityMode: boolean = false;

  /**
   * 是不是需要开启震感提示
   */
  private isStartVibration: boolean = false;


  private isFusionVar: boolean = false;

  // 默认实时模糊停止时间
  private animationBlurStopTime: number = ANIMATION_BLUR_STOP_TIME_10;

  // 低于37度实时模糊时间
  private animationBlurStopTimeBelow: number = ANIMATION_BLUR_STOP_TIME_10;

  // 超过37度以上实时模糊时间
  private animationBlurStopTimeOver:number = ANIMATION_BLUR_STOP_TIME_5;

  // 实时模糊定时器ID
  private animationBlurStopTimeTimeoutId: number = -1;

  // 是否已经停止实时模糊
  private hasAnimationBlurStoped: boolean = false;

  // 实时模糊取消温度档位
  private animationBlurStopThermalLevel: number = ANIMATION_BLUR_STOP_THERMAL_LEVEL;

  // 实时模糊类型
  private animationBlurPolicy: number = ANIMATION_BLUR_OPEN_TIMING;

  /**
   * 是否显示设置菜单
   */
  @State isShowSettingMenu: boolean = false;

  /**
   * 是否需要显示通知面板到锁屏上, 比如需要是非小折叠屏的设备且折叠态
   */
  @State isNeedPanelInScreenLock: boolean = false;

  /**
   * 面板是否是从锁屏上显示出来
   */
  @State isShowBannerFromScreenLock: boolean = false;

  /**
   * 是否进入锁屏
   */
  @State isLockScreen: boolean = false;

  /**
   * 是否锁屏锁定状态
   */
  @State isSecureAndLocked: boolean = false;
  public outerHomeVm: OuterHomeVm = OuterHomeVm.get();
  private destroyLottieTimeId: number = -1;

  overlayAnimDataChanged(): void {
    log.showInfo('onOverlayAnimDataChanged to %{public}s', this.overlayAnimData.toStr());
  }

  private onScreenLockStateChange: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === SlStaticStateType.SL_HOST_STATE) {
        this.updateLockScreenFlag();
        return;
      }
      if (subType === SlStaticStateType.SL_SECURE_LOCKED_STATE) {
        this.updateSecureAndLockedFlag();
        return;
      }
    }
  };

  private readonly _lockStateChangeListener: ScreenLockStateChangeListener = {
    onLockStateChange: (lockStateInfo: LockStateInfo): void => {
      const isLocked: boolean = lockStateInfo.isLocked;
      log.showInfo(`onLockStateChange, lockStateInfo.isLocked: ${isLocked}`);
      if (isLocked) {
        DropDownPanelManager.updateControlCenterDownInLockEnable();
      } else {
        // 灭屏亮屏事件在多用户存在情况下，会发送给前台用户导致灭屏状态未回置，此处通过锁屏解锁事件兜底
        DropDownPanelManager.setScreenOff(false);
      }
    }
  };

  // 拖动的时候模糊恢复清晰并且桌面恢复缩放，松手之后桌面从清晰到模糊，并还原缩放
  onBlurOpacityChanged() {
    if (this.blurOpacity.blurOpacity === 0) {
      log.showInfo('start onDragging');
      log.showInfo('onBlurOpacityChanged, CONTROL_CENTER_SHOW_HIDE_BAR false');
      this.staticBlurController.hideSnapShot();
      sEventManager.publish(obtainLocalEvent(EventConstants.CONTROL_CENTER_SHOW_HIDE_BAR, false));
      this.isDropdownPanelStaticShow = false;
      // 如果开启了实时模糊，后台播放视频时，取消定时任务，防止显示截屏照片导致视频播放暂停
      this.deleteAnimationBlurStopTimeOut();
      animateTo({
        curve: this.brightnessAnimCurve,
        duration: 150,
      }, () => {
        this.pixelStretch = 0;
        this.windowBlurValue = 0;
      })
    } else {
      log.showInfo('onBlurOpacityChanged, CONTROL_CENTER_SHOW_HIDE_BAR true');
      // 判定是否开启实时模糊
      if (!this.isRealTimeBlur) {
        this.setAnimationBlurStop();
      } else if (this.animationBlurPolicy === ANIMATION_BLUR_CLOSE ||
        this.animationBlurPolicy === ANIMATION_BLUR_CLOSE_FROM_START) {
        // 关闭实时模糊
        this.staticBlurController.showSnapShot();
      } else {
        // 定时实时模糊
        if (this.animationBlurPolicy === ANIMATION_BLUR_OPEN_TIMING) {
          // 判定实时模糊是否停止，停止显示静态模糊图片
          if (this.hasAnimationBlurStoped) {
            // 定时任务已经完成，并已经停止实时模糊
            this.staticBlurController.showSnapShot();
          } else {
            // 播放视频返回时，或者滚动条切换视频快速返回切换到控制中心界面，如果以前定时任务不存在重新建立定时任务
            this.setAnimationBlurStopTimeOut();
          }
        }
      }
      if (this.data.state === ControlCenterState.MAIN_LAYOUT) {
        sEventManager.publish(obtainLocalEvent(EventConstants.CONTROL_CENTER_SHOW_HIDE_BAR, true));
      }
      let scaleIndex = (DROPDOWN_SCALE - 1) / 2;
      animateTo({
        curve: this.brightnessAnimCurve,
        duration: 100,
        onFinish: () => {
          this.isDropdownPanelStaticShow = true;
        }
      }, () => {
        this.pixelStretch = scaleIndex;
        this.windowBlurValue = 1;
      })
    }
  }

  private setAnimationBlurStop(): void {
    this.hasAnimationBlurStoped = true;
    this.staticBlurController.showSnapShot();
  }

  private dropDownCallback: ViewCallback = {
    onHide: (): void => {
      this.dropDownViewHide()
      let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
      systemSceneSession?.setWaterMarkFlag(false);
      DropDownPanelManager.onHide();
    },
    onShow: (): void => {
      this.dropDownViewShow()
      let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
      systemSceneSession?.setWaterMarkFlag(true);
      this.refreshToggleImage(false);
    },
    onTrimMemory: (level: TrimLevel): void => {
      switch (level) {
        case TrimLevel.LIGHT:
          this.trimMemory = true;
          break;
        case TrimLevel.CRITICAL:
          this.refreshToggleImage(true);
          CommunicationUtil.doLocalEventNotify('onStaticMemory', true);
          break;
      }
    },
  };

  /**
   * 是否释放快捷开关的lottie资源和图片资源
   *
   * @param isRelease
   */
  refreshToggleImage(isRelease: boolean) {
    if (isRelease && !windowMgr.isShowing(WindowConstants.WINDOW_NAME_DROPDOWN)) {
      // 清除所有开关lottie数据
      QuickToggleController.getInstance().allTogglesControllerMap.forEach((viewModel) => {
        viewModel.removeAllLottieData();
      })
      QuickToggleController.getInstance().releaseToggleController(FASlotName.NEAR_LINK);
      QuickToggleController.getInstance().removeSliderButtonLottieData();
      // 所有开关图标下树
      this.needReleaseToggleIcon = true
      return;
    }
    if (this.needReleaseToggleIcon) {
      // 加载所有开关lottie数据
      QuickToggleController.getInstance().refreshToggleData();
      setTimeout(() => {
        this.needReleaseToggleIcon = false;
      }, 20);
    }
  }

  onBackPress(): boolean | void {
    log.showInfo(`onBackPress isShowNotification: ${this.isShowNotification}, ` +
      `isShowControlCenter: ${this.isShowControlCenter}`);
    if (DropDownPanelManager.checkBackPressCallback()) {
      return true;
    }
    if (this.needHideSubpage()) {
      return;
    }
    if (this.needCloseDialog()) {
      return;
    }
    if (this.isShowNotification) {
      this.dropDownDismissByAnimation();
      return true;
    }
    if (this.isShowControlCenter) {
      log.showInfo('isShowControlCenter onBackPress: ' + this.data.state);
      if (this.sliderShareData.isDragging) {
        log.showInfo('slider is dragging, not deal back gesture');
        return;
      }
      if (this.data.state == ControlCenterState.TOGGLE_EDIT) {
        EvtBus.post(DropdownBackPressEvent, DropdownBackPressEvent.getInstance());
        return true;
      }
      if (this.data.state == ControlCenterState.MAIN_LAYOUT && !ControlCenterController.getBackPressEnable()) {
        log.showInfo('from media center back, disable back press 1 second');
        ControlCenterController.setBackPressEnable(true);
      } else {
        StatusBarManager.getInstance()?.getMoveDownVM().resetMoveDown();
        DropDownPanelManager.setDismissReason(PanelDismissReason.SLIDE_HORIZONTAL);
        this.dropDownDismissByAnimation();
        return true;
      }
    }
    return false;
  }

  needCloseDialog(): boolean {
    if (this.microphoneDialogIsOpen) {
      this.microphoneDialogIsOpen = false;
      return true;
    }
    if (SystemUICcmConfig.instance.isEnabledNotification2) {
      if (!DropdownVm.instance.ntfSettingsDialogClose) {
        log.showInfo(`reset DropdownVm ntfSettingsDialogClose: ${DropdownVm.instance.ntfSettingsDialogClose}`);
        DropdownVm.instance.ntfSettingsDialogClose = true;
        return true;
      }
    } else {
      if (!this.ntfSettingsDialogClose) {
        log.showInfo(`reset ntfSettingsDialogClose: ${this.ntfSettingsDialogClose}`);
        this.ntfSettingsDialogClose = true;
        return true;
      }
    }
    if (!this.closeNtfDialogClose) {
      log.showInfo(`reset closeNtfDialogClose: ${this.closeNtfDialogClose}`);
      this.closeNtfDialogClose = true;
      return true;
    }
    if (!this.ntfSilenceDialogClose) {
      log.showInfo(`reset ntfSilenceDialogClose: ${this.ntfSilenceDialogClose}`);
      this.ntfSilenceDialogClose = true;
      return true;
    }
    if (!this.pinTopLimitDialogClose) {
      log.showInfo(`reset pinTopLimitDialogClose: ${this.pinTopLimitDialogClose}`);
      this.pinTopLimitDialogClose = true;
      return true;
    }
    if (this.hwCastDialogIsOpen) {
      log.showInfo(`reset hwCastDialogIsOpen: ${this.hwCastDialogIsOpen}`);
      this.hwCastDialogIsOpen = false;
      return true;
    }
    if (this.superDeviceDialogIsOpen) {
      log.showInfo(`reset superDeviceDialogIsOpen: ${this.superDeviceDialogIsOpen}`);
      this.superDeviceDialogIsOpen = false;
      return true;
    }
    return false;
  }

  private needHideSubpage(): boolean {
    return sToggleSubWindowController.onBackPress() ||
    sIOTSubPageLayoutController.onBackPress() ||
    sPrivacySubLayoutController.onBackPress() ||
    sMultimediaSubPageLayoutController.onBackPress() ||
    soundSubPageController.onBackPress() ||
    sBrightnessSubPageLayoutController.onBackPress();
  }

  private onNtfAnimateEvent = (event: NtfAnimateEvent): void => {
    if (NtfAnimateEvent.EXIT_NC === event.eventType) {
      this.isFreezeEffectComponent = event.status == NtfAnimateStatus.START ? true : false;
      log.showInfo(`refresh isFreezeEffectComponent:${this.isFreezeEffectComponent}`);
    }
  };

  private initNtfListContentConfig():void{
    const ntfListContentConfig = new NtfListContentConfigPhone();
    ntfListContentConfig.outerHeightOfNCAndCCChangeSet.add(this.onOuterHeightOfNCAndCCChange);
    ntfViewConfigManager.setListContentConfig(ntfListContentConfig);
    this.listContentConfig = ntfListContentConfig;
    this.outerHeightOfNCAndCC = ntfListContentConfig.outerHeightOfNCAndCC;
    log.showInfo(`Init ntf list config success, height is ${this.outerHeightOfNCAndCC}`);
  }

  aboutToAppear() {
    this.overlayAnimData.setTag(TAG);
    this.isFusionVar = this.isFusionOpen();
    this.initNtfListContentConfig();
    this.subscribeCallStateChange();
    this.dropdownCtrl.updateId(this.persistentId);
    log.showInfo(`SCBDropdownPanel aboutToAppear, start persistentId: ${this.persistentId}`);
    this.staticBlurController.init(this.staticBlurViewData, this.persistentId);
    AppStorage.setOrCreate('Notification_DarkModeModel_DarkModeStatus', this.darkModeData);
    viewMgrPolicy.registerViewController(ViewType.DROPDOWN, this.dropdownCtrl);
    viewMgrPolicy.registerViewCallback(ViewType.DROPDOWN, this.dropDownCallback);
    CellularDataVm.instance.init();

    // 监听请求窗口show/hide
    this.eventMgr.on(RequestWindowEvent, (event: RequestWindowEvent): void => {
      this.onRequestWindowEvent(event)
    })
      .on(StartSceneFromOtherEvent, (event: StartSceneFromOtherEvent): void => {
        this.onStartSceneFromOtherEvent(event)
      })
      .on(ConfigurationEvent, (event: ConfigurationEvent) => {
        this.controlCenterFontScale = Math.min(MAX_FONT_SCALE, event?.config?.fontSizeScale ?? 1);
        this.darkModeChangedHandler.handle(event);
      })
      .on(NtfAnimateEvent, this.onNtfAnimateEvent)
      .on(RssNotifyEvent, this.handleRssNotifyEvent);

    this.listenEvent();
    CEBMgr.getInstance().subscribe(CEBMgr.HIDE_DROPDOWN_PANEL_COMMON_EVENT, this.hideDropdownWindowCEListener);
    pluginComponentManager.on('push', this.onPushListener);
    let callback: CallbackTs = {
      onPanelStateChange: (target: TargetPanel): void => this.onPanelStateChange(target),
    };
    // 错峰订阅全局组合按键
    setTimeout(() => {
      MultimodalInputManager.registerControlListener(callback);
      MultimodalInputManager.registerNotificationListener(callback);
    }, SUBSCRIBE_KEY_COMBINATION_DELAY);

    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks((screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
        // 横竖屏切换
        this.isLandscape = screenProperty.rotation === RotationConstants.ROTATION_90 ||
          screenProperty.rotation === RotationConstants.ROTATION_270;
        ArkUIAdapter.runWithScope(() => {
          this.dropdownCtrl.updateRect({
            left: 0,
            top: 0,
            width: px2vp(screenProperty.width),
            height: px2vp(screenProperty.height)
          });
        })
        this.screenRotateAngle = screenProperty?.rotation;
      }, undefined, true, this.persistentId);
    this.viewMgrPolicyGestureCallback();
    // 初始化跳转应用overlay动效的viewModel
    StartAbilityOverlayAnimate.getInstance().initData(this.startAbilityAnimateData);
    this.registerAccessibilityService();
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (systemSceneSession) {
      systemSceneSession.registerContextTransparentCallback(() => {
        log.showInfo(`${ViewType.DROPDOWN} is transparency!!`);
      });
      systemSceneSession.setSkipEventAndShowOnVirtualScreen(true);
    }

    // 监听收起面板事件
    GlobalContext.getContext().eventHub.on(FlashlightTipsConstants.CLOSE_DROPDOWN_PANEL_EVENT
      , this.closeDropdownPanelEvent);
    // 监听锁屏下拉控制中心配置
    DropDownPanelManager.registerControlCenterDownInLockEnable();
    // 获取实时模糊策略
    this.getAnimationBlurPolicy();
    this.updateRealtimeBlurPolicy(AnimPolicyRegistry.getRssPolicy());
    if (this.animationBlurPolicy === ANIMATION_BLUR_OPEN_TIMING) {
      // 开启实时模糊
      // 初始化实时模糊时间
      this.initAnimationBlurStopCcmSettingData();
      // 初始化实时模糊
      this.hasAnimationBlurStoped = false;
    } else if (this.animationBlurPolicy === ANIMATION_BLUR_CLOSE ||
      this.animationBlurPolicy === ANIMATION_BLUR_CLOSE_FROM_START) {
      // 关闭定时模糊
      this.hasAnimationBlurStoped = true;
    } else {
      // 一直打开定时模糊
      this.hasAnimationBlurStoped = false;
    }

    this.isNeedPanelInScreenLock = false;

    // 企业设备的企业应用加载配置
    EnterpriseConfig.loadConfig(GlobalContext.getContext());
    ScreenLockStateManager.getInstance().registerObserver(this._lockStateChangeListener);
    PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.END_DISPLAY_ON, this.onScreenOn);
    PowerStatusMonitor.getInstance().subscribe(PowerStatusEnum.BEGIN_DISPLAY_OFF, this.onScreenOff);
    let initToggleDataBridger = GlobalContext.getInstance().getObject('initToggleDataBridger');
    if (initToggleDataBridger) {
      (initToggleDataBridger as Function)();
    }
    log.showDebug(`aboutToAppear, end`);
  }

  private onFoldStateChangeCallback = (): void => {
    this.isNeedPanelInScreenLock = !DeviceHelper.isFoldExpandedOrHalf();
    this.isFolded = !DeviceHelper.isFoldExpandedOrHalf();
    this.outerHomeVm.changeIgnoreFontScaleState(!DeviceHelper.isFoldExpandedOrHalf());
    log.showInfo(`isNeedPanelInScreenLock update to: ${this.isNeedPanelInScreenLock}`);
  }

  private handleRssNotifyEvent = (event: RssNotifyEvent): void => {
    this.updateRealtimeBlurPolicy(event?.component);
    log.showInfo('isRealtimeBlur:' + this.isRealTimeBlur);
    if (!this.isRealTimeBlur) {
      this.hasAnimationBlurStoped = true;
      if (DropDownPanelManager.isPanelShowing()) {
        this.staticBlurController.showSnapShot();
      }
    }
  };

  private updateRealtimeBlurPolicy(policy: CommonComponent | null): void {
    if (policy === null) {
      return;
    }
    try {
      const temp = policy as SceneModule;
      let isRealTimeStr = temp?.sceneboard?.controlCenter?.isRealtimeBlur;
      if (isRealTimeStr === undefined) {
        log.showError(`RssPolicy isRealtimeBlur undefined`);
        return;
      }
      this.isRealTimeBlur = isRealTimeStr === 'true';
    } catch (error) {
      log.showError(`RssPolicy isRealtimeBlur error: ${error}`);
    }
  }

  private updateLockScreenFlag() {
    this.isLockScreen = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)
    ?.getSlState(SlStaticStateType.SL_HOST_STATE) as boolean ?? true;
    log.showInfo(`update lock screen flag: ${this.isLockScreen}`);
  }

  private updateSecureAndLockedFlag() {
    this.isSecureAndLocked = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)
    ?.getSlState(SlStaticStateType.SL_SECURE_LOCKED_STATE) as boolean ?? false;
    log.showInfo(`update lock status flag: ${this.isSecureAndLocked}`);
  }

  private hideDropdownWindowCEListener: CommonEventListener = (data: CommonEventManager.CommonEventData): void => {
    if (!data) {
      log.showWarn(`data undefined!`);
      return;
    }
    const isAnimate: number | undefined = data.parameters?.isAnimate;
    // 边界状态，Beta日志打印
    log.showWarn(`hideDropdownWindowCEListener ${isAnimate} `);
    // 根据传递的动效入参： 0：带动效退场  1：不带动效退场
    if (isAnimate === 1) {
      log.showInfo(`hideDropdownWindowCEListener hideWindowDirectly `);
      DropDownPanelManager.hideWindowDirectly();
    } else if (isAnimate === 0 || data.code === 0) {
      log.showInfo(`hideDropdownWindowCEListener dropDownDismissByAnimation `);
      this.dropDownDismissByAnimation();
    } else {
      log.showWarn('OnHideDropdownWindowCommonEvent. code is %{public}d', data.code);
    }
  }

  // 10009, eg KEYCODE_NOTIFICATION
  private notifyOption: InputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: 10009,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  // 10010, eg KEYCODE_CONTROL
  private controlOption: InputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: 10010,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  private registerAccessibilityService(): void {
    InputConsumer.on('key', this.notifyOption, callback => {
      log.showInfo('notifyOption AccessibilityService');
      if (sSCBOobeManager.isEnable() || SCBOobeManager.isOobeActivated()) {
        log.showInfo('In OOBE Not allow into NC');
        return;
      }
      if (!DropDownPanelManager.checkKioskPanelEnable(TargetPanel.NOTIFICATION_PANEL)) {
        return;
      }
      // 解锁后才能通过手势打开通知中心
      if (!ScreenLockApi.getLock()) {
        DropDownPanelManagerWrapper.getInstance().showWindowDirectly(TargetPanel.NOTIFICATION_PANEL);
        statusBarMaskManager.setStatusBarMaskState(false);
      }
    });

    InputConsumer.on('key', this.controlOption, callback => {
      log.showInfo('controlOption AccessibilityService');
      if (sSCBOobeManager.isEnable() || SCBOobeManager.isOobeActivated()) {
        log.showInfo('In OOBE Not allow into CC');
        return;
      }
      if (!DropDownPanelManager.checkKioskPanelEnable(TargetPanel.CONTROL_CENTER_PANEL)) {
        log.showInfo('Kiosk mode disable into CC!');
        return;
      }
      // 控制是否允许锁屏时通过手势打开控制中心
      if (ScreenLockApi.getLock() && !DropDownPanelManager.getControlCenterDownInLockEnable()) {
        log.showInfo('isControlCenterDownInLockEnable false, not allow into CC in lock');
        return;
      }
      DropDownPanelManagerWrapper.getInstance().showWindowDirectly(TargetPanel.CONTROL_CENTER_PANEL);
      AccessibilityUtil.sendControlCenterAccessibility(AccessibilityPageShowHide.SHOW);
      statusBarMaskManager.setStatusBarMaskState(false);
    });
  }

  private unregisterAccessibilityService(): void {
    log.showInfo('unregisterAccessibilityService');
    InputConsumer.off('key', this.notifyOption);
    InputConsumer.off('key', this.controlOption);
  }

  private viewMgrPolicyGestureCallback() {
    viewMgrPolicy.onGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId,
      () => {
        log.showInfo('send back to drop down window ' + GlobalContext.getInstance().getObject('isMediaCenterShow'));
        AppStorage.setOrCreate('controlBack', true);
        if (GlobalContext.getInstance().getObject('isMediaCenterShow')) {
          // 性能打点，退出播控
          performanceMonitor.begin('EXIT_CC_MEDIA_ANI', performanceMonitor.ActionType.LAST_UP);
          log.showInfo('send back to media playback..');
          CommunicationUtil.prepareExitState = 'quit';
          CommunicationUtil.doRemoteEventNotify();
          CEManager.publishCommentEvent('MediaControlEvent', {
            data: 'true'
          });
        } else {
          if (windowMgr.isShowing(WindowConstants.WINDOW_NAME_DROPDOWN)) {
            log.showInfo('send back to drop down window');
            this.onBackPress();
          }
        }
      });

    let backToHome = (event: string) => {
      log.info('on %{public}s', event);
      if (GlobalContext.getInstance().getObject('isMediaCenterShow')) {
        // 性能打点，退出播控
        performanceMonitor.begin('EXIT_CC_MEDIA_ANI', performanceMonitor.ActionType.LAST_UP);
        log.showInfo('send back to media playback..');
        CommunicationUtil.prepareExitState = 'quit';
        CommunicationUtil.doRemoteEventNotify();
        CEManager.publishCommentEvent('MediaControlEvent', {
          data: 'true'
        });
      }
      if (windowMgr.isShowing(WindowConstants.WINDOW_NAME_DROPDOWN)) {
        this.hideDropDownWindow(false);
      }
    };
    viewMgrPolicy.onGestureCallback(SCBEventId.HOME_GESTURE_EVENT, this.persistentId, () => {
      backToHome('HOME_GESTURE_EVENT');
    });
    viewMgrPolicy.onGestureCallback(SCBEventId.ENTER_RECENT_EVENT, this.persistentId, () => {
      backToHome('ENTER_RECENT_EVENT');
    });
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear`)
    this.eventMgr.offAll();
    this.staticBlurController.unRegisterAll();
    MultimodalInputManager.unregisterListener();
    this.mClearCallbacks?.forEach((mClearCallback: Function | undefined) => {
      if (mClearCallback != undefined) {
        mClearCallback()
      }
      mClearCallback = undefined
    })
    CEBMgr.getInstance().unsubscribe(CEBMgr.HIDE_DROPDOWN_PANEL_COMMON_EVENT, this.hideDropdownWindowCEListener);
    this.mClearCallbacks = undefined
    viewMgrPolicy.unRegisterViewCallback(ViewType.DROPDOWN, this.dropDownCallback);
    this.unregisterAccessibilityService();
    this.listContentConfig.outerHeightOfNCAndCCChangeSet.delete(this.onOuterHeightOfNCAndCCChange);
    // 注销监听收起控制中心事件
    GlobalContext.getContext().eventHub.off(FlashlightTipsConstants.CLOSE_DROPDOWN_PANEL_EVENT);
    // 注销监听锁屏下拉控制中心配置
    DropDownPanelManager.unRegisterControlCenterDownInLockEnable();
    // 删除实时模糊定时器
    this.deleteAnimationBlurStopTimeOut();
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    systemSceneSession?.setSkipEventAndShowOnVirtualScreen(false);
    ScreenLockStateManager.getInstance().unRegisterObserver(this._lockStateChangeListener);
    PowerStatusMonitor.getInstance().unsubscribe(PowerStatusEnum.END_DISPLAY_ON, this.onScreenOn);
    PowerStatusMonitor.getInstance().unsubscribe(PowerStatusEnum.BEGIN_DISPLAY_OFF, this.onScreenOff);
    log.showDebug(`aboutToDisappear, end`);
    this.unSubscribeCallStateChange();
  }

  private listenEvent() {
    this.mClearCallbacks = [];
    this.mClearCallbacks.push(
      sEventManager.subscribe(START_ABILITY_EVENT, () => this.onRequestHidePanel(false)));
    sEventManager.subscribe(START_SERVICE_EXT_EVENT, () => this.onRequestHidePanel(true));
    this.mClearCallbacks.push(
      sEventManager.subscribe(EventConstants.CONTROL_CENTER_BACK, () => this.onBackPress()));
    this.mClearCallbacks.push(
      sEventManager.subscribe(EventConstants.STATUS_BAR_DROPDOWN_TOUCH, (event: TouchEvent) => {
        this.onStatusBarTouchEvent(event);
      })
    );
    this.mClearCallbacks.push(
      sEventManager.subscribe(EventConstants.STATUS_BAR_DROPDOWN_PAN, (data: Record<string, Object>) => {
        if (data.action === 'onActionStart') {
          this.onActionStart(data.event as GestureEvent);
        } else {
          this.onActionUpdate(data.event as GestureEvent);
        }
      })
    );
  }

  animToHideActively(): void {
    if (this.isAnimToHide) {
      DropDownPanelManager.animToDismiss();
      this.isAnimToHide = false;
    }
  }

  /**
   * 监听下拉面板隐藏事件
   */
  private dropDownViewHide(): void {
    log.showInfo('dropDownViewHide, notify other status bar show');
    // 删除实时模糊定时器
    this.deleteAnimationBlurStopTimeOut();
    this.blurButtonVM?.unblur();
    this.isDismissing = true;
    sEventManager.publish(obtainLocalEvent('DropdownEvent', false));
    AppStorage.setOrCreate('dropDownPanelHide', true);
    StatusBarManager.getInstance()?.setStatusBarType();
    setTimeout(() => {
      sEventManager.publish(obtainLocalEvent(EventConstants.CONTROL_CENTER_SHOW_HIDE_BAR, true));
    }, STATUS_BAR_SHOW_DELAY);
    PerformanceReporter.getInstance()
      .reportExitMemScene(CurrentMemScene.SCENE_NOTIFICATION | CurrentMemScene.SCENE_CONTROL_CENTER);
    EvtBus.post(NtfAnimateEvent, new NtfAnimateEvent(NtfAnimateEvent.EXIT_NC, NtfAnimateStatus.END));
  }

  /**
   * 监听下拉面板显示事件
   */
  private dropDownViewShow(): void {
    log.showInfo('dropDownViewShow, notify other status bar hide');
    TraceUtil.startTrace(DomainName.CC, TraceUtil.DROPDOWN_VIEW_SHOW_CALLBACK);

    DropdownVm.instance.setVisibility(Visibility.Visible);

    if (this.windowWidth == 0) {
      this.windowWidth = px2vp(this.screenProp.width);
      this.windowHeight = px2vp(this.screenProp.height);
    }
    themeWallpaperAniMgr.sendAnimationInfo2Wallpaper({
      animationType: AnimationType.WALLPAPER_STOP_PAD
    });
    AppStorageUtil.setOrCreate('contract', true, new DataProperty(true, false));
    this.desktopContext?.eventHub.emit(CommonConstants.DESKTOP_INVISIBLE_STATE);
    sEventManager.publish(obtainLocalEvent('DropdownEvent', true));
    this.isDismissing = false;
    AppStorage.setOrCreate('dropDownPanelHide', false);
    StatusBarManager.getInstance()?.setStatusBarType(EnvVm.instance.isLockAndNotEditor()
      ? StatusBarType.TYPE_MAIN_PHONE_KEYGUARD : StatusBarType.TYPE_MAIN_PHONE_LAUNCHER,
      !ScreenLockApi.getLock());
    this.updateShowBannerFlag();
    TraceUtil.endTrace(DomainName.CC, TraceUtil.DROPDOWN_VIEW_SHOW_CALLBACK);
  }

  private updateShowBannerFlag() {
    return;
  }

  /**
   * 横竖屏切换回调
   */
  private onOrientationChanged() {
    log.showInfo('onOrientationChanged');
    windowMgr.setWindowBgBlurRadius(WINDOW_NAME, this.dropDownEvent.progress * ALPHA_TOTALLY_BLUR);
  }

  private onControlCenterDataChanged() {
    if (this.data.state == ControlCenterState.SUB_PANEL ||
      this.data.state == ControlCenterState.IOT_SUB_PAGE ||
      this.data.state == ControlCenterState.MEDIA_CENTER ||
      this.data.state === ControlCenterState.SOUND_SUB_PAGE ||
      this.data.state === ControlCenterState.BRIGHTNESS_SUBPAGE ||
      this.data.state == ControlCenterState.PRIVACY_SUB_PAGE ||
      this.data.state === ControlCenterState.MULTIMEDIA_SUB_PAGE ||
      this.data.state == ControlCenterState.TOGGLE_EDIT) {
      log.showInfo(`onControlCenterDataChanged, CONTROL_CENTER_SHOW_HIDE_BAR false, state = ${this.data?.state}`);
      sEventManager.publish(obtainLocalEvent(EventConstants.CONTROL_CENTER_SHOW_HIDE_BAR, false));
      return;
    }
    log.showInfo(`onControlCenterDataChanged, CONTROL_CENTER_SHOW_HIDE_BAR true, state = ${this.data?.state}`);
    sEventManager.publish(obtainLocalEvent(EventConstants.CONTROL_CENTER_SHOW_HIDE_BAR, true));
  }

  /**
   * 下拉事件参数改变回调
   */
  private updateProgress() {
    if (this.progress !== 1) {
      // 下拉不放或者下拉撤回时，删除实时模糊定时器
      this.deleteAnimationBlurStopTimeOut();
    }
    if (this.dropDownEvent.progress == this.progress) {
      log.showInfo(`dropdownChanged.progress is no change, progress: ${this.progress}`)
      return;
    }
    if (this.animationBlurPolicy === ANIMATION_BLUR_CLOSE_FROM_START) {
      log.showInfo('ANIMATION_BLUR_CLOSE_FROM_START, show snapshot');
      this.staticBlurController.showSnapShot();
    }
    this.progress = this.dropDownEvent.progress;
    this.windowBlurValue = this.blurCurves.interpolate(this.progress);
    let scaleValue: number = this.scaleCurves.interpolate(this.progress);
    log.showDebug(`onDropdownChanged, targetChanged: ${this.dropDownEvent.targetChanged} target: ${this.dropDownEvent.target}` +
      `moveY=${this.dropDownEvent.moveY}, progress: ${this.dropDownEvent.progress}, this.windowBlurValue: ${this.windowBlurValue}`);
    let scaleIndex = scaleValue * (DROPDOWN_SCALE - 1) / 2;
    this.pixelStretch = scaleIndex;
    if (this.progress === 1) {
      log.showInfo(`onDropdownChanged, progress = 1, stopTime animationBlurPolicy: ${this.animationBlurPolicy}`);
      if (!this.isRealTimeBlur) {
        this.setAnimationBlurStop();
        return;
      }
      // 判定是否开启了实时模糊
      if (this.animationBlurPolicy === ANIMATION_BLUR_CLOSE) {
        this.staticBlurController.showSnapShot();
      } else {
        // 设置了定时模糊
        if (this.animationBlurPolicy === ANIMATION_BLUR_OPEN_TIMING) {
          // 设置了实时模糊时长，启动实时模糊
          // 新增(重置)实时模糊定时器
          this.setAnimationBlurStopTimeOut();
          // 重置实时模糊控制
          this.hasAnimationBlurStoped = false;
        }
      }
    }
  }

  /**
   * 下拉事件参数改变回调
   */
  private onDropdownChanged() {
    this.updateProgress();
    let isShowPanelContent: boolean = this.dropDownEvent.targetChanged == TargetChangeState.HORIZONTAL ||
      this.dropDownEvent.targetChanged == TargetChangeState.HORIZONTAL_UP_BACK ||
      this.dropDownEvent.targetChanged == TargetChangeState.VERTICAL_FLING;
    if (!isShowPanelContent) {
      this.blurButtonVM.unblur();
    }
    let isCurrentShowNotification: boolean =
      this.dropDownEvent.target == TargetPanel.NOTIFICATION_PANEL || isShowPanelContent;
    let isCurrentShowControlCenter: boolean =
      this.dropDownEvent.target == TargetPanel.CONTROL_CENTER_PANEL || isShowPanelContent;
    // 不打印重复日志
    if (this.isShowNotification !== isCurrentShowNotification ||
      this.isShowControlCenter != isCurrentShowControlCenter) {
      log.showInfo(`isShowPanelContent: ${isShowPanelContent}, old isShowNotification: ${this.isShowNotification}, oldisShowControlCenter: ${this.isShowControlCenter}` +
        `new isShowNotification: ${isCurrentShowNotification}, new isShowControlCenter: ${isCurrentShowControlCenter}`);
    }
    this.isShowNotification = isCurrentShowNotification;
    if (this.isShowNotification && !this.overlayAnimData.ntfPanelOpacity) {
      log.showInfo(`reset overlayAnimData, opacity: ${this.overlayAnimData.ntfPanelOpacity}, scale: ${this.overlayAnimData.ntfPanelScale}`);
      this.overlayAnimData.ntfPanelOpacity = 1;
      this.overlayAnimData.ntfPanelScale = 1;
    }
    this.isShowControlCenter = isCurrentShowControlCenter;
    this.refreshPerformanceScene(isCurrentShowNotification, isCurrentShowControlCenter);
  }

  private refreshPerformanceScene(isShowNotification: boolean, isShowControlCenter: boolean) {
    let enterScene = CurrentMemScene.FREE;
    let exitScene = CurrentMemScene.FREE;
    if (isShowNotification) {
      enterScene |= CurrentMemScene.SCENE_NOTIFICATION;
    } else {
      exitScene |= CurrentMemScene.SCENE_NOTIFICATION;
    }
    if (isShowControlCenter) {
      enterScene |= CurrentMemScene.SCENE_CONTROL_CENTER;
    } else {
      exitScene |= CurrentMemScene.SCENE_CONTROL_CENTER;
    }
    if (this.currentMemScene !== enterScene) {
      this.currentMemScene = enterScene;
      PerformanceReporter.getInstance().reportExitMemScene(exitScene);
      PerformanceReporter.getInstance().reportEnterMemScene(enterScene);
    }
  }

  /**
   * 处理收起面板事件
   */
  onRequestHidePanel(isAnim: boolean) {
    log.showDebug(`onRequestHidePanel`);
    StatusBarManager.getInstance()?.setStatusBarType(EnvVm.instance.isLockAndNotEditor()
      ? StatusBarType.TYPE_MAIN_PHONE_KEYGUARD : StatusBarType.TYPE_MAIN_PHONE_LAUNCHER);
    if (DropDownPanelManager.isPanelShowing()) {
      log.showInfo(`setDropdownOnly, close panel`);
      DropdownVm.instance.setDropdownOnly(true)
    }
    if (this.startAbilityAnimateData.shouldInterceptHideAnim) {
      log.showInfo('startAbility overlay animation is doing, just return');
      return;
    }
    // 提前隐藏弹框
    ntfSettingsDC.hideDialog(NotificationType.TYPE_PHONE_DROPDOWN);
    this.hideDropDownWindow(isAnim);
  }

  /**
   * 处理面板状态改变事件
   */
  private onPanelStateChange(target: TargetPanel) {
    log.showDebug(`onPanelStateChange, target: ${target}`)
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      return;
    }
    AppStorage.setOrCreate('isShortcutKeyPanelShow', false);
    if (DropDownPanelManager.getCurrentTargetPanel() === target) {
      this.hideDropDownWindow(true);
    } else {
      DropDownPanelManager.animToShow(target);
    }
  }

  /**
   * reset opacity when screen unlock
   */
  private resetOpacityWhenUnlock(): void {
    if (!ScreenLockApi.getLock()) {
      if (this.keyguardOpacity === 1) {
        this.launcherOpacity = 1;
        this.dropdownOpacity = 0;
        this.keyguardOpacity = 0;
      }
    } else {
      if (this.launcherOpacity === 1) {
        this.launcherOpacity = 0;
        this.dropdownOpacity = 0;
        this.keyguardOpacity = 1;
      }
    }
  }

  /**
   * StartSceneFromOther事件
   *
   * @param event 事件
   */
  private onStartSceneFromOtherEvent(event: StartSceneFromOtherEvent): void {
    this.microphoneDialogIsOpen = false;
    let isPanelShowing = ViewManagerPolicy.isViewShowing(ViewType.DROPDOWN);
    if (!event || !isPanelShowing) {
      log.showWarn(`onStartSceneFromOtherEvent return. event: ${event?.bundleName} isViewShowing:${isPanelShowing}`);
      return;
    }
    if (GlobalContext.getInstance().getObject('isMediaCenterShow')) {
      this.postHideMediaControlEvent();
    }
    if (this.startAbilityAnimateData.shouldInterceptHideAnim || DropDownPanelManager.isPanelDismissing()) {
      log.showInfo('startAbility overlay animation is doing, just return');
      return;
    }
    if (DropdownVm.instance.oneMirrorAnimating) {
      log.showInfo('StartAppOneMirrorAnimation is executing, will not hide dropdown panel');
      return;
    }
    if (liveStartAnimMgr.isStartingByNtfItemClick()) {
      log.showInfo('OnStartSceneFromOtherEvent. for %{public}s isStartingByNtfItemClick', event?.bundleName);
    } else {
      notificationConfigManager.isSystem(event?.bundleName).then((isSystemApp) => {
        if (!isSystemApp) {
          log.showWarn(`onStartSceneFromOtherEvent. for ${event?.bundleName} return:${isSystemApp}`);
          return;
        }
        this.hideDropDownWindow(false, true);
        ControlCenterHiSysEventUtil.reportCCNCAutoHide({
          BUNDLENAME: event.bundleName,
          ABILITYNAME: event.abilityName,
        })
        log.showInfo(`hideDropDownWindow for StartSceneFromOtherEvent: ${event.bundleName} + ${event.abilityName}`);
      });
    }
  }

  /**
   * 发送播控中心收起事件
   */
  postHideMediaControlEvent(): void {
    try {
      CommonEventManager.publish('HideMediaControl', (err) => {
        if (err) {
          log.showError('Publish hidMediaControlMessage failed');
        }
      });
    } catch (error) {
      log.showError('Publish hidMediaControlMessage failed');
    }
  }

  /**
   * 请求窗口show/hide事件
   *
   * @param event 事件
   */
  private onRequestWindowEvent(event: RequestWindowEvent): void {
    if (event.windowName != WINDOW_NAME) {
      return;
    }
    // 请求隐藏窗口
    if (event.isRequestHide()) {
      this.hideDropDownWindow(event.hasWindowAnim);
    }
  }

  private refreshPrivacyStateChange(): void {
    log.showInfo('user changed, updateControlCenterDownInLockEnable');
    DropDownPanelManager.updateControlCenterDownInLockEnable();
    ControlCenterController.updateBrightnessUiValue();
  }

  private getNtfBackgroundEffect(): BackgroundEffectOptions | undefined {
    if (ntfViewConfigManager.getListContentConfig().brightnessMode === NtfBrightnessMode.Centralized) {
      return {
        policy: 1,
        radius: 0,
        saturation: this.darkModeData.isDarkMode ? 1.2 : 1.5,
        brightness: this.darkModeData.isDarkMode ? 0.9 : 1.1,
        color: this.darkModeData.isDarkMode ? '#4D000000' : '#AFFFFFFF'
      }
    }
    return undefined;
  }

  private onScreenOn = (): void => {
    log.showInfo('receive onScreen on');
    DropDownPanelManager.setScreenOff(false);
  }

  private onScreenOff = (): void => {
    // 熄屏隐藏弹框和面板
    log.showInfo('receive onScreen off');
    this.microphoneDialogIsOpen = false;
    ntfSettingsDC.hideDialog(NotificationType.TYPE_PHONE_DROPDOWN);
    silenceDialogDC.hideDialog(NotificationType.TYPE_PHONE_DROPDOWN);
    pinTopLimitDC.hideDialog(NotificationType.TYPE_PHONE_DROPDOWN);
    sToggleSubWindowController.onScreenOff();
    sIOTSubPageLayoutController.onScreenOff();
    sPrivacySubLayoutController.onScreenOff();
    sMultimediaSubPageLayoutController.onScreenOff();
    soundSubPageController.onScreenOff();
    PluginCardController.getInstance().onScreenOff();
    sBrightnessSubPageLayoutController.onScreenOff();
    if (this.superDeviceDialogIsOpen) {
      this.superDeviceDialogIsOpen = false;
    }
    // 灭屏时重置面板层级，防止面板层级异常时无法恢复
    let viewController = viewMgrPolicy?.getViewController(ViewType.DROPDOWN);
    if (viewController?.getZIndex() !== DefaultPanelZIndex.PANEL_DROPDOWN) {
      viewController?.setZIndex(DefaultPanelZIndex.PANEL_DROPDOWN);
    }
    this.hideDropDownWindow(false);
    DropDownPanelManager.setScreenOff(true);
  }

  private updateVisibleAreaChange = (isVisible: boolean, currentRatio: number) => {
    if (isVisible && currentRatio >= 0.9 && this.isShowControlCenter) {
      EventBroadcast.broadcastEvent(SysUiWindowType.WINDOW_CTR_CENTER, true);
      log.showInfo(`${SysUiWindowType.WINDOW_CTR_CENTER} show`);
      if (!focusControl.requestFocus('Ctrl.HeaderLayout_Image_edit_btn')) {
        focusControl.requestFocus('control_center_media_card_previous')
      }
      // 初始化开关Lottie资源
      if (this.destroyLottieTimeId !== -1) {
        clearTimeout(this.destroyLottieTimeId);
        this.destroyLottieTimeId = -1;
      } else {
        log.showInfo('updateVisibleAreaChange initALlLottieData');
        QuickToggleController.getInstance().loadAllLottieData();
      }
    }
    if (!isVisible && currentRatio <= 0.1 && !this.isShowControlCenter) {
      EventBroadcast.broadcastEvent(SysUiWindowType.WINDOW_CTR_CENTER, false);
      log.showInfo(`${SysUiWindowType.WINDOW_CTR_CENTER} hide`);
      this.destroyLottieTimeId = setTimeout(() => {
        log.showInfo('updateVisibleAreaChange removeAllLottieData');
        QuickToggleController.getInstance().removeAllLottieData();
        this.destroyLottieTimeId = -1;
      }, DESTROY_LOTTIE_TIMEOUT);
    }
  }

  build() {
    Stack() {
      if (this.isSnapShotExist() &&
        (this.isStaticBlurActive() || this.isTransitionAnimRunning())) {
        Column() {
          Image(this.staticBlurViewData.getSnapShot())
            .width('100%')
            .height('100%')
            .syncLoad(true)
            .id(SNAPSHOT_COMPONENT_ID)
            .onAppear(() => {
              log.showInfo('backgroundImage appear');
            })
            .onDisAppear(() => {
              log.showWarn('backgroundImage disappear')
            })
        }
        .width('100%')
        .height('100%')
        .accessibilityLevel('no')
        .transition(DropdownVm.instance.oneMirrorAnimating ? TransitionEffect.IDENTITY : undefined)
      }

      this.buildBackgroundLayout();

      /* 1、EffectComponent组件用于解决卡片堆叠时透出的问题。 */
      EffectComponent() {
        this.buildPanelContent();
      }
      .backgroundEffect(this.getNtfBackgroundEffect(), { disableSystemAdaptation: true })
      .alwaysSnapshot(ntfViewConfigManager.getListContentConfig().brightnessMode !== NtfBrightnessMode.Centralized)
      .height(DropdownVm.instance.effectComponentHeight)
      .width('100%')
      .freeze(this.isFreezeEffectComponent)
      .accessibilityLevel(this.getAccessibilityLevel());

      NotificationSettingBtn({
        type: NotificationType.TYPE_PHONE_DROPDOWN
      })

      if (this.dropDownEvent.eventType === TouchType.Move) {
        Column() {
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          log.showInfo('Click the drop-down overlay panel');
        })
        .backgroundColor(Color.Transparent)
      }

    }
    .visibility(DropdownVm.instance.visibility)
    .accessibilityLevel('no')
    .width('100%')
    .height('100%')
    .keyboardShortcut(FunctionKey.ESC, [], () => {
      log.showInfo('Pressed the ESC key');
      this.onBackPress();
    })
    .id(SCB_DROPDOWN_PANEL_ID)
  }

  private isStaticBlurActive(): boolean {
    let shouldShowSnapShot: boolean = this.staticBlurViewData.getShouldShowSnapShot();
    log.showWarn(`shouldShowSnapShot is ${shouldShowSnapShot}, hasAnimationBlurStoped is ${this.hasAnimationBlurStoped}`);
    return shouldShowSnapShot && this.hasAnimationBlurStoped;
  }

  private isSnapShotExist() {
    let snapshot = this.staticBlurViewData.getSnapShot();
    log.showWarn('snapshot is ' + ((snapshot == null) ? 'null' : 'not null'));
    return snapshot;
  }

  private isTransitionAnimRunning() {
    log.showWarn(`shouldCoverBelow is ${this.startAbilityAnimateData.shouldCoverBelow}, isAnimating is ${this.overlayAnimData.isAnimating} dropdownVm oneMirrorAnimating ${DropdownVm.instance.oneMirrorAnimating}`);
    return this.startAbilityAnimateData.shouldCoverBelow || this.overlayAnimData.isAnimating ||
    DropdownVm.instance.oneMirrorAnimating;
  }

  /**
   * 订阅通话状态变化事件
   */
  private subscribeCallStateChange(): void {
    log.showInfo('subscribe call state change event');
    try {
      observer.on('callStateChange', this.callStateChangeCallback);
    } catch (err) {
      log.showError(`subscribe call state observer, err: ${err?.code}, err: ${err?.message}`);
    }
  }

  /**
   * 取消订阅通话状态变化事件
   */
  private unSubscribeCallStateChange(): void {
    log.showInfo('unsubscribe call state change event');
    try {
      observer.off('callStateChange', this.callStateChangeCallback);
    } catch (err) {
      log.showError(`unsubscribe call state observer, err: ${err?.code}, err: ${err?.message}`);
    }
  }

  private callStateChangeCallback: (data: observer.CallStateInfo) => void = (data: observer.CallStateInfo) => {
    log.showInfo(`on callStateChange，data: ${data?.state}`);
    if (data?.state === call.CallState.CALL_STATE_RINGING) {
      // 来电时退出下拉框
      setTimeout(()=>{
        this.hideDropDownWindow(true);
      },1000);
    }
  }

  @Builder
  buildPanelContent() {
    Column() {
      this.buildNCAndCC();
    }
    .accessibilityLevel('no')
    .width('100%')
    .height('100%')
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.displayHeight = Number(newValue.height);
      this.dropdownCtrl.updateArea(ViewControllerUtils.convertArea(newValue));
    })
    .foregroundBlurStyle(this.blurButtonVM.getIsButtonClick() ? BlurStyle.BACKGROUND_ULTRA_THICK : BlurStyle.NONE, {
      colorMode: ThemeColorMode.LIGHT,
      adaptiveColor: AdaptiveColor.DEFAULT,
      scale: 0.1,
      blurOptions: {
        grayscale: this.blurButtonVM.getIsButtonClick() ? this.getGrayscaleByColorMode() : [0, 0]
      }
    }, { disableSystemAdaptation: true })
    .animation({
      duration: this.blurButtonVM.getIsButtonClick() ? 250 : 100,
      curve: this.panelCurves,
      onFinish: () => {
        if (!this.blurButtonVM.getIsButtonClick()) {
          this.blurButtonVM.setShouldBlur(false);
        }
      }
    })
  }


  @Builder
  buildNCAndCC() {
    Stack({ alignContent: Alignment.Bottom }) {
      NotificationPanelDc({
        contentZIndex: $notificationZIndex,
        isShowNotification: $isShowNotification,
      })
        .width('100%')
        .visibility(this.isShowNotification ? Visibility.Visible : Visibility.Hidden)
        .zIndex(this.notificationZIndex)

      ControlCenterComponent({ contentZIndex: $controlZIndex })
        .width('100%')
        .height('100%')
        .onVisibleAreaChange([0.0, 1.0], this.updateVisibleAreaChange)
        .visibility(this.isShowControlCenter ? Visibility.Visible : Visibility.Hidden)
        .zIndex(this.controlZIndex)
        .scale({
          x: this.startAbilityAnimateData.mainLayoutScale,
          y: this.startAbilityAnimateData.mainLayoutScale
        })
        .opacity(this.startAbilityAnimateData.mainLayoutOpacity)
    }
    .accessibilityLevel('no')
    .height('100%')
    .width('100%')
    .scale(this.blurButtonVM.getIsButtonClick() ? { x: 0.97, y: 0.97 } : { x: 1, y: 1 })
    .animation({
      duration: this.blurButtonVM.getIsButtonClick() ? 350 : 100,
      curve: this.panelCurves
    })
  }

  private getGrayscaleByColorMode(): [number, number] {
    const grayscale =
      this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? 70 * this.windowBlurValue : 38 *
      this.windowBlurValue;
    return [grayscale, grayscale];
  }

  private onTouchEnd(): void {
    if (this.isPanelDismissing()) {
      return;
    }
    // 判断是否为交替下拉抛滑反悔
    if (this.speedY < DropDownPanelManager.getVerticalFlingSpeed() &&
      this.dropDownEvent.targetChanged === TargetChangeState.VERTICAL) {
      log.showInfo(`DropdownPanel status bar onTouchEnd fling to ${this.lastTarget}.`)
      log.showInfo('DropdownEvent.targetChanged1: VERTICAL_FLING');
      DropDownPanelManager.setVerticalBackStatus(true);
      this.dropDownEvent.speedY = this.speedY;
      this.dropDownEvent.targetChanged = TargetChangeState.VERTICAL_FLING;
      return;
    }

    // 判断是否为速度阈值达到，距离阈值未达到，
    if (this.speedY > VERTICAL_SWITCH_SPEED_THRESHOLD &&
      this.endY - this.startY <= VERTICAL_SWITCH_DISTANCE_THRESHOLD &&
      this.dropDownEvent.targetChanged === TargetChangeState.PRE_VERTICAL) {
      log.showInfo(`DropdownPanel status bar onTouchEnd fling switch to ${this.lastTarget}.`)
      if (DropDownPanelManager.getCurrentTargetPanel() !== this.target) {
        this.dropDownEvent.targetChanged = TargetChangeState.VERTICAL_FLING_SWITCH;
        DropDownPanelManager.setTargetPanel(this.target);
        DropDownPanelManager.switchPanel4VerticalFling();
        return;
      }
    }

    log.showInfo('DropdownEvent.targetChanged2: NONE');
    this.dropDownEvent.targetChanged = TargetChangeState.NONE;
    this.dropDownEvent.targetChangedMove = 0;
    if (this.endY - this.startY > VERTICAL_SWITCH_DISTANCE_THRESHOLD) {
      log.showInfo(`DropdownPanel status bar onTouchEnd swipe to ${this.target}, moveY:${this.dropDownEvent.moveY}`);
      if (DropDownPanelManager.getCurrentTargetPanel() != this.target) {
        DropDownPanelManager.setTargetPanel(this.target);
        log.showInfo('DropdownEvent.targetChanged3: VERTICAL');
        this.dropDownEvent.targetChanged = TargetChangeState.VERTICAL;
        this.dropDownEvent.moveY = Math.max(0, this.dropDownEvent.moveY);
      }
      DropDownPanelManager.touchEndCheckAnim();
    }
  }

  /**
   * 交替下拉事件处理
   *
   * @param event Touch事件
   */
  public onStatusBarTouchEvent(event: TouchEvent): void {
    log.showDebug(`touchEvent, type: ${event.type}}`);
    this.updatePanelDownGlobalY(event);
    if (this.isPanelDismissing()) {
      return;
    }
    let targetPanel: TargetPanel = DropDownPanelManager.checkTargetPanelByEvent(event);
    if (targetPanel === TargetPanel.CONTROL_CENTER_PANEL) {
      if (ScreenLockApi.getLock() && !DropDownPanelManager.getControlCenterDownInLockEnable()) {
        log.showInfo('isControlCenterDownInLockEnable false, not allow into CC in lock');
        return;
      }
      if (!DropDownPanelManager.isControlCenterKioskAllow()) {
        log.showInfo('Kiosk mode disable into CC!');
        return;
      }
    } else if (!DropDownPanelManager.checkKioskPanelEnable(targetPanel)) {
      return;
    }
    switch (event.type) {
      case TouchType.Down:
        DropDownPanelManager.setStartFromPanelStatusBar(true);
        // 记录Down点
        this.startY = event.changedTouches[0].y;
        this.target = DropDownPanelManager.checkTargetPanelByEvent(event);
        this.lastTarget = DropDownPanelManager.getCurrentTargetPanel();
        this.dropDownStatus.isTouchingStatusBar = true;
        if (this.lastTarget === TargetPanel.NONE) {
          this.lastTarget = TargetPanel.NOTIFICATION_PANEL;
        }
        this.dropDownEvent.source = this.lastTarget;
        DropDownPanelManager.setVerticalBackStatus(false);
        log.showInfo(`onStatusBarTouchEvent Down to lastTarget:${this.lastTarget} target:${this.target}.`);
        this.lastY = this.startY;
        this.dropDownEvent.translateY = 0;
        this.speedY = 0;
        break;
      case TouchType.Move:
        this.statusBarTouchMove(event);
        if (!this.isDragDownFinishPrepared) {
          this.isDragDownFinishPrepared = true;
        }
        DropDownPanelManager.updateMoveDown(this.dropDownEvent.moveY);
        break;
      case TouchType.Up:
        this.endY = event.changedTouches[0].y;
        this.dropDownStatus.isTouchingStatusBar = false;
        DropDownPanelManager.endMoveDown();
        if (!this.isShowNotificationPanel()) {
          return;
        }
        log.showInfo(`touch up, isDragDownStart is ${this.isDragDownFinishPrepared} ${this.speedY} ${this.endY - this.startY}`);
        if (this.isDragDownFinishPrepared) {
          this.onTouchEnd();
          this.isDragDownFinishPrepared = false;
        }
        break;
      case TouchType.Cancel:
        log.showInfo(`Touch cancel, target is ${this.target}`);
        this.endY = event.changedTouches[0].y;
        this.dropDownStatus.isTouchingStatusBar = false;
        if (this.target === TargetPanel.NOTIFICATION_PANEL) {
          DropDownPanelManager.touchEndCheckAnim();
        }
        DropDownPanelManager.endMoveDown();
        break;
    }
  }

  private onActionStart(_: GestureEvent): void {
    this.dropDownEvent.speedY = 0
  }

  private onActionUpdate(event: GestureEvent): void {
    this.speedY = event.velocityY
    this.dropDownEvent.speedY = this.speedY;
  }

  private updatePanelDownGlobalY(event: TouchEvent): void {
    if (event.type == TouchType.Down) {
      this.panelDownGlobalY = event.changedTouches[0].screenY;
    } else if (event.type == TouchType.Up || event.type == TouchType.Cancel) {
      this.panelDownGlobalY = -1;
    }
  }

  private updatePanelDownGlobalYByFingerPrint(event: FingerprintEvent): void {
    if (event.action === FingerprintAction.DOWN) {
      this.panelDownGlobalY = 0 - event.distanceY;
    } else {
      this.panelDownGlobalY = -1;
    }
  }

  private isPanelDismissing(): boolean {
    if (this.isDismissing || DropDownPanelManager.isPanelDismissing()) {
      log.showWarn('panel is dismissing, ignore events');
      this.isDismissing = true;
      return true;
    }
    return false;
  }

  private getTouchMoveY(touchMoveY: number): number {
    if (this.colorModeViewData.isUseSolidColor()) {
      return MAX_TOUCH_MOVE * (1 - Math.exp(-Math.abs(touchMoveY) / MAX_TOUCH_MOVE)) * Math.sign(touchMoveY);
    } else {
      return touchMoveY;
    }
  }

  private statusBarTouchMove(event: TouchEvent): void {
    let moveY = event.changedTouches[0].y;
    let targetChanged: TargetChangeState = this.dropDownEvent.targetChanged;
    if (!this.isShowNotificationPanel()) {
      return;
    }
    if (targetChanged == TargetChangeState.HORIZONTAL || targetChanged == TargetChangeState.HORIZONTAL_REVERSES) {
      this.dropDownEvent.moveY = 0;
      this.dropDownEvent.translateY = 0;
      return;
    }
    this.dropDownEvent.moveY = moveY - this.startY - VERTICAL_SWITCH_DISTANCE_THRESHOLD;
    if (this.dropDownEvent.moveY > 0) {
      // 达到阈值
      log.showDebug(`onStatusBarTouchEvent swipe to lastTarget:${this.lastTarget} target:${this.target}  `)
      let lastTranslateY = this.dropDownEvent.translateY;
      let newTranslateY = lastTranslateY + this.getTouchMoveY(moveY - this.lastY) * TRANSLATE_COEFFICIENT;
      this.dropDownEvent.translateY = newTranslateY > 0 ? newTranslateY : 0;
      if (DropDownPanelManager.getCurrentTargetPanel() !== this.target) {
        DropDownPanelManager.setTargetPanel(this.target);
        log.showInfo(`DropdownEvent.targetChanged4: VERTICAL, target = ${this.target}`);
        this.dropDownEvent.targetChanged = TargetChangeState.VERTICAL;
        this.dropDownEvent.targetChangedMove = 0;
      }
    } else {
      // 未达到阈值
      this.dropDownEvent.translateY = 0;
      this.dropDownEvent.targetChangedMove = Math.abs(moveY - this.startY) / VERTICAL_SWITCH_DISTANCE_THRESHOLD;
      if (DropDownPanelManager.getCurrentTargetPanel() !== this.lastTarget) {
        DropDownPanelManager.setTargetPanel(this.lastTarget);
        log.showInfo(`DropdownEvent.targetChanged5: PRE_VERTICAL, lastTarget = ${this.lastTarget}`);
        this.dropDownEvent.targetChanged = TargetChangeState.PRE_VERTICAL;
      }
    }
    this.lastY = moveY;
    if (this.dropDownEvent.targetChanged === TargetChangeState.VERTICAL_FLING) {
      return;
    }
    if (DropDownPanelManager.getCurrentTargetPanel() != this.target) {
      log.showInfo(`DropdownEvent.targetChanged6: PRE_VERTICAL`);
      this.dropDownEvent.targetChanged = TargetChangeState.PRE_VERTICAL;
      this.dropDownEvent.targetChangedMove = Math.abs(moveY - this.startY) / VERTICAL_SWITCH_DISTANCE_THRESHOLD;
    }
  }


  private isShowNotificationPanel(): boolean {
    if (ScreenLockApi.getLock() && this.target === TargetPanel.NOTIFICATION_PANEL) {
      log.showDebug(`do not show dropDownPanel`);
      return false;
    }
    return true;
  }

  /**
   * 隐藏下拉窗口
   *
   * @param isAnim 是否动画
   */
  private hideDropDownWindow(isAnim: boolean, isHide?: boolean): void {
    // 当前有弹窗，不收起
    if (ntfSettingsDC.isShowing(NotificationType.TYPE_PHONE_DROPDOWN) && !isHide) {
      log.showError('hideDropDownWindow NtfSettingsDialog show return');
      return;
    }
    if (isAnim) {
      this.dropDownDismissByAnimation();
    } else {
      DropDownPanelManager.hideWindowDirectly();
    }
  }

  private dropDownDismissByAnimation(): void {
    if (DropDownPanelManager.getCurrentTargetPanel() == TargetPanel.NOTIFICATION_PANEL) {
      DropDownPanelManager.animDelayToDismiss(0);
    } else {
      DropDownPanelManager.animToDismiss();
    }
  }

  private onPushListener = (source: Want,
    template: PluginComponentTemplate,
    data: pluginComponentManager.KVObject,
    extraData: pluginComponentManager.KVObject): void => {
    if (CommonUtils.isEmpty(source.abilityName)) {
      log.showInfo(`abilityName is null: ${source.abilityName}`);
      return;
    }
    if (source.abilityName == 'ServiceExtAbility') {
      switch (data.action) {
        case 'HIDE_PANEL':
          this.onRequestHidePanel(true);
          break;
        case 'UNLOCK_CLICK': {
          let controller: PluginToggleController =
            QuickToggleController.getInstance().allTogglesControllerMap?.get(data.slot as string) as PluginToggleController;
          if (controller?.handleClickWithScreenLock) {
            controller.handleClickWithScreenLock(() => {
              log.showInfo('UNLOCK_CLICK unlocked');
              controller.updatePluginData('CLICKED');
            });
          } else {
            log.showError('UNLOCK_CLICK invalid controller');
          }
        }
          break;
        case 'LONG_CLICK': {
          let controller: PluginToggleController =
            QuickToggleController.getInstance().allTogglesControllerMap?.get(data.slot as string) as PluginToggleController;
          if (controller?.handleOnControlCenterWithScreenLock) {
            controller.handleOnControlCenterWithScreenLock(() => {
              log.showInfo('LONG_CLICK unlocked');
              controller.handleLongClick();
            });
          } else {
            log.showError('LONG_CLICK invalid controller');
          }
        }
          break;
        default:
          log.showInfo(`action is not permit: ${data.action}`);
          break;
      }
    }
  }

  private getCompositingFilter(): Filter {
    this.filter = uiEffect.createFilter();
    return this.filter.pixelStretch((DISABLE_PIXEL_STRETCH_EFFECT ||
      this.animationBlurPolicy === ANIMATION_BLUR_CLOSE_FROM_START ? [0, 0, 0, 0] : [
      this.pixelStretch,
      this.pixelStretch,
      this.pixelStretch,
      this.pixelStretch]),
      uiEffect.TileMode.MIRROR);
  }

  private getBackgroundEffect(): BackgroundEffectOptions {
    return {
      policy: 1,
      // Gradient by windowBlurValue, the dark mode is the same as the light mode.
      // BackgroundThick blur radius: pad 29  phone 45
      radius: this.blurRadius * this.windowBlurValue,
      // BackgroundThick saturation: pad 1.1  phone 1.2
      saturation: (1 + this.saturation * this.windowBlurValue),
      // BackgroundThick brightness: 1
      brightness: 1,
      // BackgroundThick color: #33808080, opacity: 20%
      blurOptions: { grayscale: [38 * this.windowBlurValue, 38 * this.windowBlurValue] }
    };
  }

  /**
   * 下拉过程中，先模糊再内缩。
   * 下拉过程完成后，先内缩再模糊。
   */
  @Builder
  buildBackgroundLayout() {
    if (this.isFusionVar) {
      Column() {
      }
      .accessibilityLevel('no')
      .width('100%')
      .height('100%')
      .compositingFilter(this.getCompositingFilter())
      .backgroundEffect(this.getBackgroundEffect(), { disableSystemAdaptation: true })
    } else {
      if (this.isDropdownPanelStaticShow) {
        Column() {
        }
        .accessibilityLevel('no')
        .width('100%')
        .height('100%')
        .compositingFilter(this.getCompositingFilter())

        Column() {
        }
        .accessibilityLevel('no')
        .width('100%')
        .height('100%')
        .backgroundEffect(this.getBackgroundEffect(), { disableSystemAdaptation: true })
      } else {
        Column() {
        }
        .accessibilityLevel('no')
        .width('100%')
        .height('100%')
        .compositingFilter(this.getCompositingFilter())
        .backgroundEffect(this.getBackgroundEffect(), { disableSystemAdaptation: true })
      }
    }
  }

  isFusionOpen(): boolean {
    return parameter.getSync('controlCenter.isFusionOpen', 'true') == 'true';
  }

  /**
   * 先退出通知中心,规避模式切换时复杂的动画、弹窗场景
   */
  onChangeDataEmitter(): void {
    this.dropDownDismissByAnimation();
  }

  /**
   * 设定实时模糊停止定时器
   */
  private setAnimationBlurStopTimeOut(): void {
    if (this.animationBlurStopTimeTimeoutId === -1) {
      // 获取实时模糊可运行时间
      this.animationBlurStopTime = this.getAnimationBlurStopTimeByThermalLevel();
      log.showInfo(`setAnimationBlurStopTimeOut stopTime = ${this.animationBlurStopTime}`);
      // 如果定时器不存在进行新增定时，存在无视
      this.animationBlurStopTimeTimeoutId = setTimeout(() => {
        this.hasAnimationBlurStoped = true;
        this.staticBlurController.showSnapShot();
        this.animationBlurStopTimeTimeoutId = -1;
      }, this.animationBlurStopTime);
    }
  }

  /**
   * 删除实时模糊停止定时器
   */
  private deleteAnimationBlurStopTimeOut(): void {
    // 如果定时器存在进行删除，不存在无视
    if (this.animationBlurStopTimeTimeoutId !== -1) {
      log.showInfo(`deleteAnimationBlurStopTimeOut animationBlurStopTimeTimeoutId = ${this.animationBlurStopTimeTimeoutId}`);
      clearTimeout(this.animationBlurStopTimeTimeoutId);
      this.animationBlurStopTimeTimeoutId = -1;
      // 重置实时模糊
      this.hasAnimationBlurStoped = false;
    }
  }

  /**
   * 根据温控获取实时模糊停止时间
   */
  private getAnimationBlurStopTimeByThermalLevel(): number {
    // 根据热档位信息，设备类型等获取实时视频设置数据
    let thermalLevel = ANIMATION_BLUR_STOP_THERMAL_LEVEL;
    try {
      thermalLevel = thermal.getThermalLevel();
    } catch (err) {
      log.showError(`getAnimationBlurStopTimeByThermalLevel failed.`);
    }
    if (thermalLevel === thermal.ThermalLevel.COOL || thermalLevel === thermal.ThermalLevel.NORMAL) {
      // 设备处于清凉状态，设备温度正常
      log.showInfo(`getAnimationBlurStopTimeByThermalLevel thermalLevel = ${thermalLevel}, stopTime = ${this.animationBlurStopTimeBelow}`);
      return this.animationBlurStopTimeBelow;
    } else if (thermalLevel < this.animationBlurStopThermalLevel) {
      // 设备高于常温，低于温控阈值时
      log.showInfo(`getAnimationBlurStopTimeByThermalLevel thermalLevel = ${thermalLevel}, stopTime = ${this.animationBlurStopTimeOver}`);
      return this.animationBlurStopTimeOver;
    } else {
      // 设备超过温控阈值
      log.showInfo(`getAnimationBlurStopTimeByThermalLevel thermalLevel = ${thermalLevel}, stopTime = 0`);
      return 0;
    }
  }

  /**
   * 初始化实时模糊停止时间
   */
  private initAnimationBlurStopCcmSettingData(): void {
    // 初始化常温以下时间
    this.initAnimationBlurStopBelow();
    // 超温情况下 初始化
    this.initAnimationBlurStopOver();
    // 取消实时模糊视频温度档位
    this.initAnimationBlurStopThermalLevel();
  }

  /**
   * 获取实时模糊策略
   */
  private getAnimationBlurPolicy(): void {
    let animationBlurPolicy = '';
    try {
      animationBlurPolicy = ANIMATION_BLUR_POLICY === undefined ? '' : ANIMATION_BLUR_POLICY;
      if (animationBlurPolicy === '') {
        animationBlurPolicy = parameter.getSync(VisualEffectConstants.CC_ANIMATION_BLUR_POLICY);
        log.showInfo(`getAnimationBlurPolicy animation_blur_policy = ${animationBlurPolicy}`);
      }
    } catch (err) {
      log.showError(`init animation_blur_policy failed.`);
    }
    if (animationBlurPolicy !== null && animationBlurPolicy.length > 0) {
      try {
        this.animationBlurPolicy = Number.parseInt(animationBlurPolicy);
        if (Number.isNaN(this.animationBlurPolicy)) {
          this.animationBlurPolicy = ANIMATION_BLUR_OPEN_TIMING;
        }
      } catch (err) {
        log.showError(`getAnimationBlurPolicy animation_blur_policy failed.`);
      }
    }
    if (!this.isAnimationBlurPolicyAvailable()) {
      // 非法设值时，按照默认值处理
      this.animationBlurPolicy = ANIMATION_BLUR_OPEN_TIMING;
    }
  }

  /**
   * 判断实时模糊策略合法性
   */
  private isAnimationBlurPolicyAvailable(): boolean {
    if (this.animationBlurPolicy !== ANIMATION_BLUR_OPEN_TIMING &&
      this.animationBlurPolicy !== ANIMATION_BLUR_OPEN &&
      this.animationBlurPolicy !== ANIMATION_BLUR_CLOSE &&
      this.animationBlurPolicy !== ANIMATION_BLUR_CLOSE_FROM_START) {
      return false;
    }
    return true;
  }

  /**
   * 初始化常温(37度)以下的实时模糊时长
   */
  private initAnimationBlurStopBelow(): void {
    // 低温情况下 初始化
    let stopTime = '';
    try {
      stopTime = ANIMATION_BLUR_STOP_TIME_NORMAL === undefined ? '' : ANIMATION_BLUR_STOP_TIME_NORMAL;
      if (stopTime === '') {
        stopTime = parameter.getSync(VisualEffectConstants.CC_ANIMATION_BLUR_STOP_TIME_NORMAL);
        log.showInfo(`initAnimationBlurStopCcmSettingData animation_blur_stop_time_normal stopTime = ${stopTime}`);
      }
    } catch (err) {
      log.showError(`init animation_blur_stop_time_normal failed.`);
    }
    if (stopTime !== null && stopTime.length > 0) {
      // CCM已配置情况下，以CCM为准
      try {
        this.animationBlurStopTimeBelow = Number.parseInt(stopTime);
        if (Number.isNaN(this.animationBlurStopTimeBelow)) {
          this.animationBlurStopTimeBelow = 0;
        }
      } catch (err) {
        log.showError(`init animation_blur_stop_time_normal failed.`);
        // 设置为非法值时，不启动实时模糊
        this.animationBlurStopTimeBelow = 0;
      }
      if (this.animationBlurStopTimeBelow > ANIMATION_BLUR_STOP_TIME_MAX) {
        // 超过最大值时，改为默认值
        this.animationBlurStopTimeBelow = ANIMATION_BLUR_STOP_TIME_MAX;
      }
      if (this.animationBlurStopTimeBelow < 0) {
        // 如果设置为负值，等同于不开启实时模糊，转换为0
        this.animationBlurStopTimeBelow = 0;
      }
    } else {
      log.showInfo(`initAnimationBlurStopCcmSettingData animation_blur_stop_time_normal DeviceHelper.DEVICE_TYPE ${DeviceHelper.DEVICE_TYPE}`);
      // CCM未配置情况下，以设备类型为准
      if (DeviceHelper.isFold()) {
        // 折叠屏
        this.animationBlurStopTimeBelow = ANIMATION_BLUR_STOP_TIME_15;
        log.showInfo(`initAnimationBlurStopCcmSettingData animation_blur_stop_time_normal DeviceHelper.isFold  stopTime = ${stopTime}`);
      } else if (DeviceHelper.isPhone()) {
        // 直屏机
        this.animationBlurStopTimeBelow = ANIMATION_BLUR_STOP_TIME_30;
        log.showInfo(`initAnimationBlurStopCcmSettingData animation_blur_stop_time_normal DeviceHelper.isPhone  stopTime = ${stopTime}`);
      } else if (DeviceHelper.isPad()) {
        // 平板
        this.animationBlurStopTimeBelow = ANIMATION_BLUR_STOP_TIME_10;
        log.showInfo(`initAnimationBlurStopCcmSettingData animation_blur_stop_time_normal DeviceHelper.isPad  stopTime = ${stopTime}`);
      }
    }
  }

  /**
   * 初始化高温（37度）以上的实时模糊时长
   */
  private initAnimationBlurStopOver(): void {
    let stopTime = '';
    try {
      stopTime = ANIMATION_BLUR_STOP_TIME_ABNORMAL === undefined ? '' : ANIMATION_BLUR_STOP_TIME_ABNORMAL;
      if (stopTime === '') {
        stopTime = parameter.getSync(VisualEffectConstants.CC_ANIMATION_BLUR_STOP_TIME_ABNORMAL);
        log.showInfo(`initAnimationBlurStopCcmSettingData animation_blur_stop_time_abnormal stopTime = ${stopTime}`);
      }
    } catch (err) {
      log.showError(`init animation_blur_stop_time_abnormal failed.`);
    }
    if (stopTime !== null && stopTime.length > 0) {
      // CCM已配置情况下，以CCM为准
      try {
        this.animationBlurStopTimeOver = Number.parseInt(stopTime);
        if (Number.isNaN(this.animationBlurStopTimeOver)) {
          this.animationBlurStopTimeOver = 0;
        }
      } catch (err) {
        log.showError(`init animation_blur_stop_time_abnormal failed.`);
        // 设置为非法值时，不启动实时模糊
        this.animationBlurStopTimeOver = 0;
      }
      if (this.animationBlurStopTimeOver > ANIMATION_BLUR_STOP_TIME_MAX) {
        // 超过最大值时，改为默认值
        this.animationBlurStopTimeOver = ANIMATION_BLUR_STOP_TIME_MAX;
      }
      if (this.animationBlurStopTimeOver < 0) {
        // 如果设置为负值，转换为0
        this.animationBlurStopTimeOver = 0;
      }
    } else {
      if (DeviceHelper.isFold()) {
        // 折叠屏
        this.animationBlurStopTimeOver = ANIMATION_BLUR_STOP_TIME_7DOT5;
        log.showInfo(`initAnimationBlurStopCcmSettingData animation_blur_stop_time_abnormal DeviceHelper.isFold  stopTime = ${stopTime}`);
      } else if (DeviceHelper.isPhone()) {
        // 直屏机
        this.animationBlurStopTimeOver = ANIMATION_BLUR_STOP_TIME_15;
        log.showInfo(`initAnimationBlurStopCcmSettingData animation_blur_stop_time_abnormal DeviceHelper.isPhone  stopTime = ${stopTime}`);
      } else if (DeviceHelper.isPad()) {
        // 平板
        this.animationBlurStopTimeOver = ANIMATION_BLUR_STOP_TIME_5;
        log.showInfo(`initAnimationBlurStopCcmSettingData animation_blur_stop_time_abnormal DeviceHelper.isPad  stopTime = ${stopTime}`);
      }
    }
  }

  /**
   * 初始化取消实时模糊视频温度档位
   */
  private initAnimationBlurStopThermalLevel(): void {
    let thermalLevel = '';
    try {
      thermalLevel = ANIMATION_BLUR_CANCEL_THERMAL_LEVEL === undefined ? '' : ANIMATION_BLUR_CANCEL_THERMAL_LEVEL;
      if (thermalLevel === '') {
        thermalLevel = parameter.getSync(VisualEffectConstants.CC_ANIMATION_BLUR_CANCEL_THERMAL_LEVEL);
        log.showInfo(`init animation_blur_cancel_thermal_level thermalLevel = ${thermalLevel}`);
      }
    } catch (err) {
      log.showError(`init animation_blur_cancel_thermal_level failed.`);
    }
    if (thermalLevel !== null && thermalLevel.length > 0) {
      try {
        this.animationBlurStopThermalLevel = Number.parseInt(thermalLevel);
        if (Number.isNaN(this.animationBlurStopThermalLevel)) {
          this.animationBlurStopThermalLevel = ANIMATION_BLUR_STOP_THERMAL_LEVEL;
        }
      } catch (err) {
        log.showError(`initAnimationBlurStopCcmSettingData animation_blur_cancel_thermal_level failed.`);
        // 设置为非法值时，设定为默认值4
        this.animationBlurStopThermalLevel = ANIMATION_BLUR_STOP_THERMAL_LEVEL;
      }
    }
  }

  private getAccessibilityLevel(): string {
    if (!this.isAccessibilityMode) {
      return AccessibilityLevel.AUTO;
    }
    // 通知设置展示时，不聚焦底下通知内容
    return this.blurButtonVM.shouldBlur ? AccessibilityLevel.NO_HIDE_DESCENDANTS :
      AccessibilityLevel.AUTO;
  }

}
