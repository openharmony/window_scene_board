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

import PluginCardController, { DeviceItem } from '../controller/PluginCardController';
import DeviceContentItem from './DeviceContentItem'
import StyleConfiguration, { PluginCardComponentStyle, } from '../common/model/StyleConfiguration';
import { ContinuityState } from '../common/model/ContinuityState';
import { DeviceShowInfo } from '../common/model/DeviceShowInfo';
import {
  LogHelper,
  LogDomain,
} from '@ohos/basicutils';
import {
  DeviceHelper,
  EventManager,
  EvtBus,
  PluginCardChangeEvent,
  WindowEvent,
  PluginSlot,
  GlobalContext,
  DropDownEvent,
  TargetPanel,
  ConfigurationEvent,
} from '@ohos/frameworkwrapper';
import {
  FASlotName,
  HoverConstants,
} from '@ohos/commonconstants';
import curves from '@ohos.curves';
import { ColorModeViewData, ColorModeViewModel, DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { FontViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/LabelViewData';
import { DeviceType } from '../common/model/DeviceType';
import { DfxSceneBoard, BizScene, BizStage, StageRes, BizState, DfxReportSceneInfo } from '../DFX/DfxUtils';
import common from '@ohos.app.ability.common';
import accessibility from '@ohos.accessibility';
import I18n from '@ohos.i18n';
import { AlertDialog } from '@ohos.arkui.advanced.Dialog'
import Constants, { ControlCenterState, ServerConnectState } from '../common/model/Constants';
import { PageMode, SuperDeviceController } from '../controller/SuperDeviceController';
import { AccountStateManager } from '../common/model/AccountStateManager';
import { DarkModeEvent, SymbolIconUtil } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import {
  ControlCenterAccessibilityDataModel
} from '@ohos/controlcentercommon/src/main/ets/accessibility/AccessibilityDataModel';
import lazy { CommonConstants } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import lazy { DeviceState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { StorageAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/StorageAdapter';
import { VibratorManagerAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/VibratorManagerAdapter';
import { SettingsDataUtils } from '../common/utils/SettingsDataUtils';
import { emitter } from '@kit.BasicServicesKit';
import { pluginCardReportUtil } from '../common/PluginCardReportUtil';
import { LengthMetrics } from '@kit.ArkUI';
import sDropDownPanelManager from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';

const TAG: string = 'PluginCardComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const MAX_FONT_SCALE: number = 1.15;
const THRESHOLD_SLIDE: number = 5;
const MAX_DEVICE_NUM: number = 2;
const TOAST_DELAY: number = 200;
const AUDIO_DEVICE: string = 'AUDIO';
const ENGLISH_PREFIX: string = 'en-Latn-';
const ACCESS_FOCUS_ICON: string = 'transition_toggle';
const ICON_TEXT_OPACITY: number = 0.7;

// PC模式资源参数
const SUPER_DEVICE_ICON_SIZE: string = '28vp';
const TOP_OTHER_BUTTON_FONT_SIZE: number = 14;
const TOP_PC_BUTTON_FONT_SIZE: number = 15;
const SUPER_DEVICE_TITLE_LINE_HEIGHT: number = 0;
const SUPER_DEVICE_TEXT_MARGIN_LEFT: string = '14VP';
const SUPER_DEVICE_TEXT_WIDTH: string = '94vp';

// 雷达图标子组件
@Component
struct RadarIconComponent {
  @Prop @Watch('onDeviceNumberUpdate') deviceNumber: number = 0;
  @State style: PluginCardComponentStyle = StyleConfiguration.getPluginCardComponentStyle();
  @StorageLink('currColorMode') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
  @StorageLink('isMarkingRenderGroupOfControl') isMarkingRenderGroupOfControl: boolean = false;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State isGalaxyShowed: boolean = false;
  @State isGalaxyChange: boolean = true;
  @State xScale: number = 1;
  @State yScale: number = 1;
  // 变化之前的设备数量
  @State beforeIconNum: number = 0
  @State beforeIconNumber: number = 0;
  private controller: PluginCardController = PluginCardController.getInstance();

  // @Watch 回调
  onDeviceNumberUpdate(): void {
    this.isGalaxyChange = true;
    if (this.deviceNumber > this.beforeIconNum) {
      animateTo({ duration: 200, curve: Curve.EaseIn }, () => {
        this.xScale = 1.1;
        this.yScale = 1.1;
      })
      setTimeout(() => {
        animateTo({ duration: 250, curve: Curve.EaseOut }, () => {
          this.xScale = 1;
          this.yScale = 1;
        })
      }, 200)
    }
    this.beforeIconNum = this.deviceNumber;
  }

  aboutToAppear(): void {
    // 首次进入触发雷达图标缩放
    if (this.beforeIconNumber !== this.deviceNumber) {
      animateTo({ duration: 200, curve: Curve.EaseIn }, () => {
        this.xScale = 1.1;
        this.yScale = 1.1;
      })
      setTimeout(() => {
        animateTo({ duration: 250, curve: Curve.EaseOut }, () => {
          this.xScale = 1;
          this.yScale = 1;
        })
      }, 200)
    }
    this.beforeIconNumber = this.deviceNumber;
  }

  aboutToDisappear(): void {
    this.isGalaxyShowed = false;
  }

  build() {
    // 雷达图标显示
    Row() {
      Image($r('app.media.svg24'))
        .width(ControlCenterPluginMgr.isPcMode ? SUPER_DEVICE_ICON_SIZE : $r('app.float.super_device_icon_size'))
        .height(ControlCenterPluginMgr.isPcMode ? SUPER_DEVICE_ICON_SIZE : $r('app.float.super_device_icon_size'))
        .fillColor(this.colorModeViewData.commonIconOffColor)
        .foregroundBrightness(this.colorModeViewData.getBrightnessOption(
          this.colorModeViewData.getPrimaryFgOption(false)))
        .objectFit(ImageFit.Contain)
        .draggable(false)
        .scale({ x: this.xScale, y: this.yScale })
        .key('superDeviceRadarIcon')
    }
  }
}

@Component
export struct PluginCardComponent {
  @State style: PluginCardComponentStyle = StyleConfiguration.getPluginCardComponentStyle();
  @StorageLink('isLandscape') isLandscape: boolean = false;
  @StorageLink('deviceNumber') @Watch('deviceNumUpdate') deviceNum: number = 0;
  @StorageLink('isMarkingRenderGroupOfControl') isMarkingRenderGroupOfControl: boolean = false; // 增加UI缓存，防止丢帧
  @StorageLink('dropDownPanelHide') @Watch('onPluginCardHide') isDropDownPanelHide: boolean = true;
  @StorageLink('currColorMode') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @Provide isHover: boolean = false;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private controller: PluginCardController = PluginCardController.getInstance();
  private eventMgr: EventManager | undefined = undefined;
  @State flexMr: string = 'app.float.capsulePr';
  @StorageLink('controlCenterFontScale') controlCenterFontScale: number = 1;
  @State toggleScale: number = 1;
  @State longPressCanceled: boolean = true;
  private startY: number = 0;
  @State isRTL: boolean = false;
  @State isPluginCardHide: boolean = false;
  private context: common.Context = GlobalContext.getContext() as common.Context;
  private originState: ContinuityState = ContinuityState.IDLE;
  private map: Map<string, string> = new Map();
  @StorageProp('superDeviceDialogCode') @Watch('updateDialogType') superDeviceDialogCode: number =
    Constants.DIALOG_DEFAULT;
  @State dialogTitle: Resource | undefined = $r('app.string.super_device_title_open_wlan_and_bluetooth');
  @State dialogMessage: Resource = $r('app.string.text_open_wlan_and_bluetooth_account');
  @State confirmBtn: Resource = $r('app.string.button_enable');
  @State cancelBtn: Resource = $r('app.string.cancel');
  @State isPluginCardHover: boolean = false;
  @StorageLink('dropDownEvent') @Watch('onDropdownChanged')
  dropDownEvent: DropDownEvent = DropDownPanelManager.getDropDownEvent();
  @State viewData: FontViewData = new FontViewData();
  private systemLanguage: string = '';
  private isReset: boolean = false;
  @Consume @Watch('refreshCloseDialog') superDeviceDialogIsOpen: boolean;
  private previousPage: number | undefined = undefined;
  @StorageLink('isToggleLightEnabled') isToggleLightEnabled: boolean = true;
  @StorageLink('foldStatusForOuterScreen') @Watch('onFoldStatusChange') foldStatus: number = AppStorage.get<number>('foldStatusForOuterScreen') as number;
  @StorageLink('ControlCenterState') @Watch('onControlCenterStateChange') controlCenterState: ControlCenterState = ControlCenterState.MAIN_LAYOUT;
  @State isSmallFoldOuterScreen: boolean = false;
  private isBussinessStyle: boolean = false;
  private isDarkModeState: boolean = false;
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: AlertDialog({
      primaryTitle: this.dialogTitle,
      content: this.dialogMessage,
      primaryButton: {
        value: this.cancelBtn,
        fontColor: $r('sys.color.ohos_id_color_text_primary_activated'),
        action: () => {
          this.superDeviceDialogIsOpen = false;
        },
      },
      secondaryButton: {
        value: this.confirmBtn,
        fontColor: $r('sys.color.ohos_id_color_text_primary_activated'),
        action: () => {
          SuperDeviceController.getInstance().confirmClick(this.superDeviceDialogCode);
          this.superDeviceDialogIsOpen = false;
        }
      },
    }),
    cancel: () => {
      log.info(`dialogController cancel`);
      this.superDeviceDialogIsOpen = false;
    },
    autoCancel: true,
    alignment: DialogAlignment.Center
  });
  /**
   * 长按振动类型
   */
  private vibrationEffectId: string = CommonConstants.VIBRATION_EFFECT_MEDIUM;

  onDropdownChanged() {
    if (this.dropDownEvent.target !== TargetPanel.CONTROL_CENTER_PANEL) {
      this.dialogController.close();
      this.superDeviceDialogIsOpen = false;
    }
  }

  private onFoldStatusChange() {
      return;
  }

  private onControlCenterStateChange() {
    log.info(TAG, `controll center state change: ${this.controlCenterState ?? ''},
    is panel showing? ${sDropDownPanelManager.isPanelShowing() ?? false}`);
    if (this.controlCenterState === ControlCenterState.MAIN_LAYOUT && sDropDownPanelManager.isPanelShowing()) {
      this.onPluginCardShow();
      SuperDeviceController.getInstance().setPageMode(PageMode.NONE);
    }
    if (this.controlCenterState === ControlCenterState.TOGGLE_EDIT) {
      SuperDeviceController.getInstance().setPageMode(PageMode.EDIT);
      this.controller.beAbleUnsubscribe();
    }
  }

  refreshCloseDialog(): void {
    if (!this.superDeviceDialogIsOpen) {
      this.dialogController.close();
      AppStorage.setOrCreate<number>('superDeviceDialogCode', Constants.DIALOG_DEFAULT);
    }
  }

  private updateHoverStatus(isShowOfWindow: boolean) {
    this.isHover = isShowOfWindow;
    this.isPluginCardHover = isShowOfWindow;
  }

  updateDialogType(): void {
    log.showInfo(`superDeviceDialogCode: ${this.superDeviceDialogCode}`);
    if (this.superDeviceDialogCode === Constants.DIALOG_DEFAULT) {
      log.warn('not phone or dialog code default');
      return;
    }
    switch (this.superDeviceDialogCode) {
      case Constants.DIALOG_WIFI_BLUETOOTH:
      case Constants.PHONE_DIALOG_WIFI:
      case Constants.PHONE_DIALOG_WIFI_LIST:
        this.dialogTitle = $r('app.string.super_device_title_open_wlan_and_bluetooth');
        this.dialogMessage = $r('app.string.text_open_wlan_and_bluetooth_account');
        this.confirmBtn = $r('app.string.button_enable');
        break;
      case Constants.DIALOG_ACCOUNT:
        this.dialogTitle = $r('app.string.title_login_hw_account');
        this.dialogMessage = $r('app.string.text_open_wlan_and_bluetooth_account');
        this.confirmBtn = $r('app.string.account_button_login');
        break;
      case Constants.DIALOG_SWITCH_STATUS:
        this.dialogTitle = undefined;
        this.dialogMessage = $r('app.string.super_device_disabled');
        this.confirmBtn = $r('app.string.button_enable');
        break;
      default:
        this.dialogTitle = $r('app.string.super_device_title_open_wlan_and_bluetooth');
        this.dialogMessage = $r('app.string.text_open_wlan_and_bluetooth_account');
        this.confirmBtn = $r('app.string.button_enable');
        break;
    }
    this.dialogController.open();
    this.superDeviceDialogIsOpen = true;
  }

  private transitionEffect: TransitionEffect =
    TransitionEffect.translate({ x: 30 })
      .animation({
        duration: 150,
        delay: 100,
        curve: curves.interpolatingSpring(0, 1, 200, 23)
      })
      .combine(TransitionEffect.asymmetric(TransitionEffect.scale({ x: 0.3, y: 0.3 })
        .animation({
          curve: curves.interpolatingSpring(0, 1, 200, 23),
          duration: 150,
          delay: 100
        }), TransitionEffect.scale({
        x: 0.3,
        y: 0.3
      }).animation({ curve: Curve.LinearOutSlowIn, duration: 150, delay: 100 })))
      .combine(TransitionEffect.opacity(0)
        .animation({ duration: 150, delay: 100 }));

  // 超级终端字样动效
  @State effect: TransitionEffect | undefined = this.transitionEffect;
  // 第一个设备图标动效
  private iconEffect: TransitionEffect =
    TransitionEffect.asymmetric(TransitionEffect.translate({ x: -80 })
      .animation({
        duration: 200,
        curve: curves.interpolatingSpring(0, 1, 200, 23),
        delay: 100
      }), TransitionEffect.translate({ x: 0 }))
      .combine(TransitionEffect.asymmetric(TransitionEffect.opacity(0)
        .animation({ curve: Curve.Sharp, duration: 200, delay: 100 }), TransitionEffect.opacity(0)))
      .combine(TransitionEffect.scale({ x: 0, y: 0 })
        .animation({ duration: 200, delay: 100, curve: curves.interpolatingSpring(0, 1, 200, 23) }));
  // 第二个图标动画
  private secondIconEffect: TransitionEffect =
    TransitionEffect.asymmetric(TransitionEffect.translate({ x: -25 })
      .animation({
        duration: 200,
        curve: curves.interpolatingSpring(0, 1, 200, 23),
        delay: 170
      }), TransitionEffect.translate({ x: 0 }))
      .combine(TransitionEffect.asymmetric(TransitionEffect.opacity(0)
        .animation({ curve: Curve.Sharp, duration: 200, delay: 200 }), TransitionEffect.opacity(0)))
      .combine(TransitionEffect.scale({ x: 0, y: 0 })
        .animation({ duration: 200, delay: 170, curve: curves.interpolatingSpring(0, 1, 200, 23) }));

  // 判断使用的是哪个动效
  getTransitionEffect(index: number, deviceNum: number, isRefresh: boolean): TransitionEffect | undefined {
    if (isRefresh) {
      return;
    }
    if (index === 0) {
      return this.iconEffect;
    } else if (index === 1) {
      return this.secondIconEffect;
    } else {
      return;
    }
  }

  deviceNumUpdate(): void {
    this.effect = this.transitionEffect; // 超级终端字样动效
    if (this.deviceNum === 2) {
      animateTo({
        duration: 270,
        delay: 100,
        curve: curves.interpolatingSpring(0, 1, 200, 23),
        onFinish: () => {
          log.showInfo(`DeviceNum: ${this.deviceNum} animation execution ends`);
        }
      }, () => {
        this.flexMr = 'app.float.capsuleUpdatedPr';
      })
    } else {
      animateTo({
        duration: 200,
        delay: 170,
        curve: curves.interpolatingSpring(0, 1, 200, 23),
        onFinish: () => {
          log.showInfo(`DeviceNum: ${this.deviceNum} animation execution ends`);
        }
      }, () => {
        this.flexMr = 'app.float.capsulePr';
      })
    }
  }

  getRightAreaWidth(): Resource {
    if (DeviceHelper.isPhone() || DeviceHelper.isPad()) {
      return $r('app.float.phone_left_width');
    } else {
      return $r('app.float.pc_left_width');
    }
  }

  aboutToAppear(): void {
    log.warn('app aboutToAppear');
    SuperDeviceController.getInstance().setPageMode(PageMode.NONE);
    this.previousPage = SuperDeviceController.getInstance().getPageMode();
    SettingsDataUtils.getInstance().initSettings(this.context);
    this.onFoldStatusChange();

    this.effect = undefined; // 超级终端字样动效
    this.map = this.initDeviceArray();
    if (this.eventMgr === undefined) {
      this.eventMgr = EvtBus.createEventManager();
    }
    // 监听手机控制中心下划
    this.eventMgr.on(PluginCardChangeEvent, (event: PluginCardChangeEvent) => {
      if (event.status === PluginCardChangeEvent.PLUGIN_CARD_SHOW) {
        this.onPluginCardShow();
      }
      log.warn('plugin card show event');
    });
    // 监听PC控制中心显示
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      if (event.isMatchName(PluginSlot.SLOT_STATUS_CONTROL_CENTER) && event.isWindowStartShow()) {
        this.onPluginCardShow();
      }
    });
    // 监听PC控制中心收起
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      if (event.isMatchName(PluginSlot.SLOT_STATUS_CONTROL_CENTER) && event.isWindowEndHide()) {
        log.warn('plugin card hide');
        this.isPluginCardHide = true;
        SuperDeviceController.getInstance().setPageMode(PageMode.OTHER);
        this.controller.beAbleUnsubscribe();
        this.updateHoverStatus(event?.isWindowShow());
      }
    });
    AccountStateManager.getInstance().getAccountState();
    AccountStateManager.getInstance().registerAccountStateListener();
    ControlCenterAccessibilityDataModel.getInstance().set(FASlotName.SUPER_DEVICE, $r('app.string.app_name_desc'));

    let innerEvent: emitter.InnerEvent = {
      eventId: Constants.CONTROLLER_INIT_EVENT,
    };

    emitter.on(innerEvent, () => {
      this.controller = PluginCardController.getInstance();
    })

    this.eventMgr.on(DarkModeEvent, (event: DarkModeEvent) => {
      this.isDarkModeState = event.isDarkMode;
      log.showInfo(`change dark mode: ${this.isDarkModeState}`)
    });

    // 监听语言切换
    this.eventMgr.on(ConfigurationEvent, this.languageChangeListener);

    if (!DeviceHelper.isPC() &&
      this.controller?.getServerConnectedState() === ServerConnectState.DISCONNECTED) {
      this.controller.retrySubscribe();
    }
  }

  aboutToDisappear(): void {
    log.warn('app aboutToDisappear');
    if (this.eventMgr !== undefined) {
      this.eventMgr.offAll();
    }
    emitter.off(Constants.CONTROLLER_INIT_EVENT);
  }

  private onPluginCardShow(): void {
    log.warn('plugin card show');
    this.effect = undefined;
    SuperDeviceController.getInstance().setPageMode(PageMode.NONE);
    // 注册账号监听
    AccountStateManager.getInstance().getAccountState();
    AccountStateManager.getInstance().registerAccountStateListener();
    this.controller = PluginCardController.getInstance();
    this.controller.registerSettingDataChange();

    if (SettingsDataUtils.isSwitchOff()) {
      log.showInfo('switch is off');
      return;
    }
    this.controller.init();
    this.onFoldStatusChange();
  }

  public languageChangeListener = (event: ConfigurationEvent): void => {
    let newLanguage: string = event?.config?.language ?? this.systemLanguage;
    if (newLanguage !== this.systemLanguage || !this.isReset) {
      this.systemLanguage = newLanguage;
      this.resetFontSize();
      log.showInfo(`language changed to: ${this.systemLanguage}`);
    }
  }

  /**
   * 重新设置语言
   */
  resetFontSize(): void {
    this.isReset = true;
    log.showInfo(`now systemLanguage is ${this.systemLanguage}`)
    this.viewData.isUyghurMode = false;
    this.viewData.isEnglishMode = false;
    this.viewData.isTibetanMode = false;
    if (this.systemLanguage === 'ug-CN' || this.systemLanguage === 'ug') {
      this.viewData.isUyghurMode = true;
    }
    if (this.systemLanguage.startsWith(ENGLISH_PREFIX)) {
      this.viewData.isEnglishMode = true;
      return
    }
    if (this.systemLanguage === 'bo-CN' || this.systemLanguage === 'bo') {
      this.viewData.isTibetanMode = true;
      return;
    }
  }

  // 监听手机控制中心收起
  onPluginCardHide(): void {
    log.warn('plugin card hide');
    if (!AppStorage.get('dropDownPanelHide')) {
      log.warn('plugin card hide ignore');
      return;
    }
    this.isPluginCardHide = true;
    this.effect = undefined;

    this.controller.beAbleUnsubscribe();
  }

  getFlexMl(): Resource {
    if (DeviceHelper.isPhone()) {
      return $r('app.float.flex_area_phone_rp');
    } else {
      return $r('app.float.flex_area_pc_rp');
    }
  }

  getStateInfo(state: ContinuityState, type: string, deviceName: string,
    deviceShowInfo?: DeviceShowInfo, deviceIndex?: number): string {
    if (state === ContinuityState.CONNECTING) {
      log.showInfo('deviceState--CONNECTING  ' + ' The device status is： ' + state);
      return this.context.resourceManager.getStringSync($r('app.string.appSateCollaborating').id);
    } else if (state === ContinuityState.CONNECTED) {
      log.showInfo(`deviceState--CONNECTED, the device status is： ${state}`);
      return this.context.resourceManager.getStringSync($r('app.string.device_connected_msg').id);
    } else if (state === ContinuityState.DISCONNECTING) {
      log.showInfo('deviceState--DISCONNECTING  ' + ' The device status is： ' + state);
      return this.context.resourceManager.getStringSync($r('app.string.appSateCancel').id);
    } else {
      return '';
    }
  }

  stateChange(type: string, state: ContinuityState, deviceName: string,
    deviceShowInfo?: DeviceShowInfo, deviceIndex?: number): void {
    log.showInfo('stateChange, Enter stateChange.');
    if (state === this.originState) {
      log.showInfo('stateChange, No change in status' + state);
      return;
    }
    this.originState = state;
    if (this.previousPage === PageMode.LIST) {
      this.previousPage = PageMode.NONE;
      return;
    }

    let eventInfo: accessibility.EventInfo = ({
      type: 'announceForAccessibility',
      bundleName: 'com.ohos.sceneboard',
      triggerAction: 'click',
      textAnnouncedForAccessibility: this.getStateInfo(state, type, deviceName ?? '', deviceShowInfo, deviceIndex)
    });
    accessibility.sendAccessibilityEvent(eventInfo).then(() => {
      console.info(`stateChange, eventInfo is ${JSON.stringify(eventInfo)}`);
    });
  }

  private initDeviceArray(): Map<string, string> {
    let phone = this.context.resourceManager.getStringSync($r('app.string.Phone').id);
    let PC = this.context.resourceManager.getStringSync($r('app.string.Laptop').id);
    let TABLET = this.context.resourceManager.getStringSync($r('app.string.tablet').id);
    let AUDIO = this.context.resourceManager.getStringSync($r('app.string.audio').id);
    let SMART_CAR = this.context.resourceManager.getStringSync($r('app.string.Car').id);
    let map = new Map<string, string>([['PHONE', phone], ['PC', PC], ['2IN1', PC], ['PAD', TABLET], ['AUDIO', AUDIO], ['CAR', SMART_CAR]]);
    return map;
  }

  private getDeviceName(deviceName: string, type: string, state: ContinuityState,
    deviceShowInfo?: DeviceShowInfo, deviceIndex?: number): string | undefined {
    log.showInfo('getDeviceName ' + 'The device status is： ' + type + ' The device state is： ' + state);
    this.stateChange(type, state, deviceName, deviceShowInfo, deviceIndex);
    return this.map.has(type) ? this.map.get(type) + deviceName : deviceName;
  }

  touchAction = (event: TouchEvent) => {
    switch (event.type) {
      case TouchType.Down:
        this.longPressCanceled = false;
        this.scaleDecrease();
        this.startY = event.touches[0].y;
        break;
      case TouchType.Up:
      case TouchType.Cancel:
        this.scaleIncrease();
        break;
      case TouchType.Move:
        if (Math.abs(event.touches[0].y - this.startY) > THRESHOLD_SLIDE) {
          this.longPressCanceled = true;
          this.scaleIncrease();
        }
        break;
      default:
        break;
    }
  }

  /**
   * 卡片缩小到90%
   */
  scaleDecrease() {
    animateTo({
      curve: curves.springMotion(0.31, 0.94)
    }, () => {
      this.toggleScale = 0.9;
    })
  }

  /**
   * 卡片恢复到100%
   */
  scaleIncrease() {
    animateTo({
      curve: curves.springMotion(0.31, 0.94),
      finishCallbackType: FinishCallbackType.LOGICALLY,
    }, () => {
      this.toggleScale = 1;
    })
  }

  /**
   * 开关长按事件
   *
   * @param event 事件
   */
  onLongPressGesture = (event?: GestureEvent) => {
    VibratorManagerAdapter.startVibration(this.vibrationEffectId,
      CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    if (this.longPressCanceled) {
      log.showDebug('long press canceled');
      return;
    }
    log.showInfo('LongPressGesture to enter the list');
    this.effect = undefined;
    SuperDeviceController.getInstance().handleClick();
    pluginCardReportUtil.reportUEEnterListPageEvent(Constants.REPORT_LONG_CLICK_DEVICE_EVENT,
      this.controller.getRadarAllDevices().length > 0 ?
      Constants.REPORT_HAS_DEVICE : Constants.REPORT_HAS_NOT_DEVICE);
  }

  pluginCardPadding(): Padding {
    this.isRTL = I18n.isRTL(I18n.System.getSystemLocale());
    if (this.isRTL) {
      return {
        left: this.deviceNum === 0 ? $r('app.float.list_padding_right') : $r('app.float.list_padding_right1'),
        right: $r('app.float.list_padding_right')
      }
    } else {
      return {
        left: $r('app.float.list_padding_left'),
        right: this.deviceNum === 0 ? $r('app.float.list_padding_right') : $r('app.float.list_padding_right1')
      }
    }
  }

  devicePadding(): Padding {
    if (this.deviceNum === 2) {
      this.flexMr = 'app.float.capsuleUpdatedPr';
    }
    if (this.isRTL) {
      return {
        right: this.getFlexMl(),
        left: $r(this.flexMr)
      }
    } else {
      return {
        right: $r(this.flexMr),
        left: this.getFlexMl()
      }
    }
  }

  private onClickEvent = () => {
    log.showInfo('Click to enter the list');
    this.effect = undefined;
    SuperDeviceController.getInstance().handleClick();
    pluginCardReportUtil.reportUEEnterListPageEvent(Constants.REPORT_CLICK_SUPER_DEVICE_ITEM,
      this.controller.getRadarAllDevices().length > 0 ?
      Constants.REPORT_HAS_DEVICE : Constants.REPORT_HAS_NOT_DEVICE);
  }

  private onDeviceClick = (showInfo: DeviceShowInfo, index: number) => {
    if (this.isListExistSameDevice(showInfo)) {
      log.showInfo('Same device, Click to enter the collaboration');
      SuperDeviceController.getInstance().handleClick();
      pluginCardReportUtil.reportUEEnterListPageEvent(Constants.REPORT_CLICK_SAME_DEVICE,
        this.controller.getRadarAllDevices().length > 0 ?
        Constants.REPORT_HAS_DEVICE : Constants.REPORT_HAS_NOT_DEVICE);
    } else if (!SuperDeviceController.getInstance().checkWifi() && showInfo.deviceType !== Constants.AUDIO &&
      this.controller.getCurrentState(showInfo) === ContinuityState.IDLE) {
      log.info('open wifi dialog');
      AppStorage.setOrCreate('sceneBoardUniqueId', showInfo.uniqueId);
      if (DeviceHelper.isPC()) {
        SuperDeviceController.getInstance().publishCommonEvent(Constants.OPEN_WLAN_DIALOG, showInfo.uniqueId);
      } else {
        SuperDeviceController.getInstance().handleOnControlCenterWithScreenLock((): void => {
          SuperDeviceController.getInstance().publishDialogEvent(Constants.PHONE_DIALOG_WIFI);
        }, false);
      }
    } else {
      SuperDeviceController.getInstance().onUserClickEvent(showInfo, index);
    }
  }

  private getDeviceItemAccessText(item: DeviceItem, index: number): string {
    let deviceName: string = this.getDeviceName(item.showInfo.deviceName ?? '', item.showInfo.deviceType,
      this.controller.getCurrentState(item.showInfo), item.showInfo, index) ?? '';
    let state: string = this.getStateInfo(this.controller.getCurrentState(item.showInfo), item.showInfo.deviceType ?? '',
      item.showInfo.deviceName ?? '') ?? '';
    return deviceName + state;
  }

  build() {
    Stack() {
      Row()
        .backgroundColor(this.colorModeViewData.getSolidColor(
          this.colorModeViewData.commonBgOffColor, this.colorModeViewData.mainCardOption))
        .backgroundBrightnessInternal(this.colorModeViewData.getBrightnessOption(
          this.colorModeViewData.mainCardOption))
        .borderRadius($r('app.float.Control_center_long_button_radius'))
        .height('100%')
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .pointLight({
          illuminated: this.isToggleLightEnabled ? IlluminatedType.BORDER_CONTENT : IlluminatedType.NONE,
        })
        .shadow({
          radius: this.style.toggleIconShadowRadius,
          color: this.style.toggleIconShadowColor,
          offsetY: this.style.toggleIconShadowOffsetY,
        })
        .useEffect(DeviceHelper.isPC() ? true : false)

      Row() {
        // 雷达图图标显示
        RadarIconComponent({ deviceNumber: this.deviceNum })
          .onClick(this.onClickEvent)
          .accessibilityLevel('no')
          .opacity(this.setOpacity(ICON_TEXT_OPACITY))
        Row() {
          if (this.deviceNum === 0) {
            if (this.isBussinessStyle) {
              Text($r('app.string.app_name_desc'))
                .draggable(false)
                .fontFamily($r('app.string.Control_center_long_button_font_family'))
                .fontColor(this.colorModeViewData.wifiOffTextColor)
                .fontWeight(this.style.topButtonFontWeight)
                .foregroundBrightness(this.colorModeViewData.getBrightnessOption(
                  this.colorModeViewData.getPrimaryFgOption(false)))
                .fontSize((this.viewData.isEnglishMode || this.viewData.isTibetanMode || this.viewData.isUyghurMode) ?
                  (ControlCenterPluginMgr.isPcMode ? TOP_OTHER_BUTTON_FONT_SIZE :
                    this.style.topOtherButtonFontSize) * this.controlCenterFontScale + 'vp' :
                  (ControlCenterPluginMgr.isPcMode ? TOP_PC_BUTTON_FONT_SIZE :
                    this.style.topPcButtonFontSize) * this.controlCenterFontScale + 'vp')
                .maxLines(2)
                .height('100%')
                .lineHeight(
                  ControlCenterPluginMgr.isPcMode ? SUPER_DEVICE_TITLE_LINE_HEIGHT :
                    (this.style.lineHeight * this.controlCenterFontScale + 'vp'))
                .width(ControlCenterPluginMgr.isPcMode ? SUPER_DEVICE_TEXT_WIDTH : $r('app.float.super_device_text_width'))
                .wordBreak(WordBreak.BREAK_WORD)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .padding({
                  left: this.isRTL ? 0 :
                    (ControlCenterPluginMgr.isPcMode ? SUPER_DEVICE_TEXT_MARGIN_LEFT : $r('app.float.super_device_text_margin_left')),
                  right: this.isRTL ?
                    (ControlCenterPluginMgr.isPcMode ? SUPER_DEVICE_TEXT_MARGIN_LEFT : $r('app.float.super_device_text_margin_left')) : 0
                })
                .transition(this.effect)
                .opacity(this.setOpacity(ICON_TEXT_OPACITY))
            } else {
              Text($r('app.string.app_name_desc'))
                .draggable(false)
                .fontFamily($r('app.string.Control_center_long_button_font_family'))
                .fontColor(this.colorModeViewData.wifiOffTextColor)
                .fontWeight(this.style.topButtonFontWeight)
                .foregroundBrightness(this.colorModeViewData.getBrightnessOption(
                  this.colorModeViewData.getPrimaryFgOption(false)))
                .maxFontSize(Constants.MAX_FONT_SIZE * this.controlCenterFontScale + 'vp')
                .minFontSize(Constants.MIN_FONT_SIZE * this.controlCenterFontScale + 'vp')
                .maxLines(2)
                .height(36)
                .lineHeight(this.style.lineHeight * this.controlCenterFontScale + 'vp')
                .width(this.style.buttonLabelWidth * this.controlCenterFontScale + 'vp')
                .wordBreak(WordBreak.BREAK_WORD)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({
                  left: this.isRTL ? 0 : $r('app.float.super_device_text_margin_left'),
                  right: this.isRTL ? $r('app.float.super_device_text_margin_left') : 0
                })
                .transition(this.effect)
                .onClick(this.onClickEvent)
                .accessibilityLevel('no')
                .opacity(this.setOpacity(ICON_TEXT_OPACITY))
            }
          } else {
            Flex({
              alignItems: ItemAlign.Center,
              justifyContent: FlexAlign.SpaceBetween,
              direction: this.isBussinessStyle && this.deviceNum === 2 ? FlexDirection.Row : FlexDirection.RowReverse,
            }) {
              LazyForEach(this.controller, (item: DeviceItem, index: number) => {
                DeviceContentItem({
                  deviceType: item.showInfo.deviceType,
                  serviceUniqueId: item.showInfo.uniqueId,
                  state: this.controller.getCurrentState(item.showInfo),
                  records: this.controller.getLottieRecords(),
                  isPluginCardHide: this.isPluginCardHide,
                  isRefresh: item.isRefresh,
                  deviceName: item.showInfo.deviceName,
                  brMac: item.showInfo.brMac,
                  extra: item.showInfo.extraInfo,
                  onIconClick: this.onDeviceClick,
                  showInfo: item.showInfo,
                  index: index,
                  accessText: this.getDeviceItemAccessText(item, index)
                })
                  .transition(this.getTransitionEffect(index, this.deviceNum, item.isRefresh))
                  .key(`superDeviceIcon${index}`)
              }, (item: DeviceItem, index: number) => item.getItemKey(index))
            }
            .padding(this.devicePadding())
            .height('100%')
            .width(this.isSmallFoldOuterScreen ? $r('app.float.fold_outer_left_width') : this.getRightAreaWidth())
            .transition(this.effect)
          }
        }
        .width(this.isSmallFoldOuterScreen ? $r('app.float.fold_outer_left_width') : this.getRightAreaWidth())
        .height('100%')
        .alignItems(VerticalAlign.Center)
      }
      .alignItems(VerticalAlign.Center)
      .padding(this.pluginCardPadding())
      .borderRadius($r('app.float.Control_center_long_button_radius'))
      .clip(true)
      .height('100%')
      .width('100%')
      .onHover((isHover?: boolean) => {
        if (isHover !== undefined) {
          this.isHover = isHover;
        }
      })

      if (this.isBussinessStyle && this.isPluginCardHover) {
        SymbolGlyph($r('sys.symbol.small_triangle_arrow_down_right_fill'))
          .draggable(false)
          .fontSize($r('app.float.Control_center_top_toggle_bussiness_style_symbol_width'))
          .fontColor(AppStorage.get('currColorMode') ?
            [Color.Black] : [Color.White])
          .position({
            bottom: LengthMetrics.vp(this.style.symbolMarginBottom),
            end: LengthMetrics.vp(this.style.symbolMarginBottom),
          })
          .opacity(0.4)
          .zIndex(-1)
      }
    }
    .focusable(!(this.isBussinessStyle && this.deviceNum === 0))
    .id('super_device_toggle')
    .onClick(this.onClickEvent)
    .onTouch(this.touchAction)
    .scale({x: this.toggleScale, y: this.toggleScale })
    .gesture(LongPressGesture({ repeat: false })
      .onAction(this.onLongPressGesture))
    .alignContent(Alignment.Center)
    .onHover(this.onPluginCardHoverChanged)
    .accessibilityText(this.context.resourceManager.getStringSync($r('app.string.app_name_desc').id))
    .id(this.isAccessibilityMode ? ACCESS_FOCUS_ICON + FASlotName.SUPER_DEVICE : '')
  }

  private onPluginCardHoverChanged = (isHover?: boolean) => {
    if (isHover === undefined || isHover === null) {
      return;
    }
    this.isPluginCardHover = isHover;
    animateTo({
      duration: HoverConstants.HOVER_ANIMATE_DURATION,
      curve: Curve.Sharp
    }, () => {
      let scaleSize = DeviceHelper.isPC() ? HoverConstants.HOVER_MEDIA_CARD_SCALE :
      HoverConstants.HOVER_QUICK_BTN_SCALE;
      this.toggleScale = isHover ? scaleSize : HoverConstants.HOVER_DEFAULT_SCALE;
    });
  }

  private isListExistSameDevice(deviceItemClick: DeviceShowInfo): boolean {
    let allDevices = this.controller.getRadarAllDevices();
    for (let i = 0; i < allDevices.length - 1; i++) {
      for (let j = i + 1; j < allDevices.length; j++) {
        let iconClick = this.getDeviceIcon(deviceItemClick.deviceType, deviceItemClick.extraInfo);
        let iconList = this.getDeviceIcon(allDevices[i].deviceType, allDevices[i].extraInfo);
        if (iconClick !== iconList) {
          log.showInfo('The device type is not clicked');
          continue;
        }

        if (this.isSameDevice(allDevices[i], allDevices[j])) {
          return true;
        }
      }
    }

    return false;
  }

  private isSameDevice(deviceItemLeft: DeviceShowInfo, deviceItemRight: DeviceShowInfo): boolean {
    let iconLeft = this.getDeviceIcon(deviceItemLeft.deviceType, deviceItemLeft.extraInfo);
    let iconRight = this.getDeviceIcon(deviceItemRight.deviceType, deviceItemRight.extraInfo);
    if (iconLeft !== iconRight) {
      log.showInfo('The icon of the two devices are different');
      return false;
    }

    let stateLeft = this.controller.getCurrentState(deviceItemLeft);
    let stateRight = this.controller.getCurrentState(deviceItemRight);
    if (stateLeft !== stateRight) {
      log.showInfo('The state of the two devices are different');
      return false;
    }

    return true;
  }

  private getDeviceIcon(type: string, extraInfo: string) {
    if (type === DeviceType.PHONE) {
      return 'app.media.ic_public_devices_phone_filled';
    } else if (type === DeviceType.LAPTOP) {
      return 'app.media.svgic_device_matebook_filled';
    } else if (type === DeviceType.TWO_IN_ONE) {
      return 'app.media.svgic_device_matebook_filled';
    } else if (type === DeviceType.TABLET) {
      return 'app.media.svgic_device_pad_filled';
    } else if (type === DeviceType.AUDIO_DEVICE) {
      return this.parseIconRes(extraInfo);
    } else if (type === DeviceType.SMART_CAR) {
      return 'sys.symbol.car_fill';
    } else {
      // default
      return 'app.media.svgic_device_pad_filled';
    }
  }

  private parseIconRes(extra: string): string {
    let audioStr = '';
    try {
      audioStr = JSON.parse(extra)['iconRes'];
      if (audioStr.length >= 0) {
        return audioStr;
      }
    } catch (e) {
      log.showError(`parse extra error, extra:${extra}`);
    }
    return `sys.symbol.earphone_bluetooth`;
  }

  private setOpacity(opacity: number): number {
    return (this.colorModeViewData.isUseDefaultColor() || this.isDarkModeState) ? 1 : opacity;
  }
}

