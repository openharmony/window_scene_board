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

import BatteryInfo from '@ohos.batteryInfo';
import mBatteryModel, { BatterySocVm } from '../batteryModel';
import { LogDomain, LogHelper, AppStorageUtil } from '@ohos/basicutils';
import {
  DeviceHelper,
  DropDownEvent,
  GlobalContext,
  PluginSlot,
  sEventManager,
  viewMgrPolicy,
  ViewType } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import {
  SingleHandModeChangeEvent,
  StatusBarStyleChangeEvent,
  StyleConfigurationCommon,
  CommonStyle,
} from '@ohos/systemuicommon/Index';
import StyleConfiguration from '../common/StyleConfiguration';
import { LogWithHa, baseStateMgr } from '@ohos/systemuicommon';
import { BatteryComponentStyle } from '../common/StyleConfiguration';
import charger from '@ohos.charger';
import Constants, {
  COMPONENT_ID_BATTERY_BORDER,
  COMPONENT_ID_BATTERY_CHARGING,
  COMPONENT_ID_BATTERY_ICON,
  COMPONENT_ID_BATTERY_PROGRESS,
  COMPONENT_ID_BATTERY_SOC,
  COMPONENT_ID_POWER_SAVE_MODE,
  TAG
} from '../common/constants';
import { AbsResourceManager as ResourceManager, EventManager, EvtBus, EventConstants} from '@ohos/frameworkwrapper';
import {
  BatteryStage,
  PrivacyIndicatorViewModel,
  circleSize,
  getBatteryHeight,
  productSeries,
} from '../common/privacyIndicatorModel';
// import privacyIndicatorManager from '@hms.security.privacyIndicatorManager';
import display from '@ohos.display';
import { curves, LengthMetrics } from '@kit.ArkUI';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import {
  StatusBarMoveDownVmV1,
  StatusBarMoveDownVmV2
} from '@ohos/systemuicommon/src/main/ets/statusbar/vm/StatusBarMoveDownVm';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { StatusBarExceptionCode } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarExceptionCode';
import { AccessibilityVm, ResourceVm } from '@ohos/systemuicommon/newIndex';

// instrument ignore file
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const ANIMATE_FROM_BIG_TO_SMALL = 2;
const ANIMATE_FROM_SMALL_TO_BIG = 1;
const NO_ANIMATE = 0;
const BREATH_WAITING_TIME = 3500;
const CURVE_BREATH: curves.ICurve = curves.cubicBezierCurve(0.2, 0, 0.4, 1);
type unsubscribe = () => void;

interface IconConfig {
  showBatterySoc: boolean
}

@Component
export default struct BatteryIcon {
  private mViewModel: PrivacyIndicatorViewModel | null = null;
  private socVm: BatterySocVm = new BatterySocVm();
  private resourceMgr: ResourceManager | null = null;
  private batteryHeight: number = 16;
  private batteryWidth: number = 24;
  private circleTranslate: number = 0;
  private cameraReOpenFlag: boolean = false;
  private microphoneReOpenFlag: boolean = false;
  private iconStayTime: number = 500;
  private eventMgr: EventManager = EvtBus.createEventManager();
  private orientation = 0;
  private moveDownVmV2: StatusBarMoveDownVmV2 = StatusBarMoveDownVmV2.getInstance();
  private moveDownVmV1: StatusBarMoveDownVmV1 = StatusBarMoveDownVmV1.getInstance();

  @State mIconConfig: IconConfig = {
    showBatterySoc: true,
  };
  @State @Watch('dropDownMoveYChange') dropDownEvent: DropDownEvent = DropDownPanelManager.getDropDownEvent();
  @StorageLink('batterySoc') batterySoc: number = 100;
  @StorageLink('batteryCharging') @Watch('batteryChargingChange') batteryCharging: boolean = false;
  @StorageLink('batteryPluggedType') batteryPluggedType: BatteryInfo.BatteryPluggedType = 0;
  @StorageLink('chargerType') chargerType: charger.ChargeType = charger.ChargeType.NONE;
  @StorageLink('powerSaveMode') powerSaveMode: number = Constants.POWER_SAVE_MODE_OFF;
  @StorageProp('executeBatteryStageQueue') @Watch('refreshPrivacyStage') executeBatteryStageQueue: BatteryStage[] = [];
  @StorageProp('fakeLightIsShow') fakeLightIsShow: boolean | undefined = AppStorage.get<boolean>('fakeLightIsShow');
  @StorageProp('cacheCameraLightStatus') @Watch('watchCamera') cacheCameraLightStatus: boolean | undefined =
    AppStorage.get<boolean>('cacheCameraLightStatus');
  @StorageProp('cacheMicroPhoneLightStatus') @Watch('watchMicroPhone') cacheMicroPhoneLightStatus: boolean | undefined =
    AppStorage.get<boolean>('cacheMicroPhoneLightStatus');
  @State isClip: boolean = false;
  @State style: BatteryComponentStyle = StyleConfiguration.getBatteryComponentStyle();
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @Consume statusBarPaddingRight: string;
  @Consume statusBarPaddingTop: string;
  /**
   * 沉浸式内容颜色
   */
  @Consume contentColor: string;
  // 防抖，当前是否在执行动效阶段
  @State isCurAnimating: boolean = false;
  // 动效执行阶段
  private batteryStage: BatteryStage = BatteryStage.initStage;
  // 电池动效属性初始化
  @State batteryTranslateX: number = 0;
  @State batteryOpacity: number = 1;
  @State batteryScale: number = 1;
  @StorageProp('isSystemLanguageRTL') @Watch('refreshRTLLanguageStateChange') isSystemLanguageRTL: boolean | undefined =
    AppStorage.get<boolean>('isSystemLanguageRTL');
  // 相机动效属性初始化
  @State privacyCameraTranslateX: number = -this.batteryWidth;
  @State privacyCameraOpacity: number = 0;
  @State privacyCameraScale: number = 0.5;
  // 相机圆点动效属性
  @State privacyCameraCircleTranslateX: number = 0;
  @State privacyCameraCircleOpacity: number = 0;
  @State privacyCameraCircleScale: number = 1;
  // 麦克风动效属性初始化
  @State privacyMicrophoneTranslateX: number = -this.batteryWidth;
  @State privacyMicrophoneOpacity: number = 0;
  @State privacyMicrophoneScale: number = 0.5;
  // 麦克风圆点动效属性
  @State privacyMicrophoneCircleTranslateX: number = 0;
  @State privacyMicrophoneCircleOpacity: number = 0;
  @State privacyMicrophoneCircleScale: number = 1;
  @State mMarginRight: number = this.getMMarginRight();
  // 监听用户切换变化
  @StorageProp('privacyIndicatorUserChangeKey') @Watch('refreshPrivacyStateChange') privacyIndicatorUserChangeKey: boolean | undefined =
    AppStorage.get<boolean>('privacyIndicatorUserChangeKey');
  private checkTimerId: number = -1;
  /**
   * 事件取消订阅集合
   */
  clearCallbacks: unsubscribe[] = [];


  aboutToAppear() {
    mBatteryModel.initBatteryModel();
    this.style.initStyle();
    this.socVm.init(this);
    this.mViewModel = new PrivacyIndicatorViewModel();
    this.mViewModel.setCallback((batteryStage: BatteryStage) => {
      log.showInfo(`add stage is ${batteryStage}`);
      this.executeBatteryStageQueue.push(batteryStage);
    });
    this.mViewModel.registerPrivacyStateChangeListener();
    this.mViewModel?.setStatusBarPaddingRight(this.mMarginRight);
    this.mViewModel.setStatusBarPaddingTop(this.statusBarPaddingTop);
    this.refreshPrivacyStateChange();
    this.eventMgr.on(SingleHandModeChangeEvent, this.handleSingleHandModeChangeEvent);
    this.eventMgr.on(StatusBarStyleChangeEvent, this.statusbarStyleChange);
    this.clearCallbacks.push(
      sEventManager.subscribe(EventConstants.CONTROL_CENTER_SHOW_HIDE_BAR, (event: boolean) => {
        this.exitCCSecondPanel(event);
      }))
    log.showInfo(`aboutToAppear, mIconConfig: ${this.mIconConfig?.showBatterySoc}`);
  }

  aboutToDisappear() {
    this.socVm.destroy();
    this.mViewModel?.unregisterPrivacyStateChangeListener();
    this.mViewModel = null;
    this.eventMgr.offAll();
    log.showInfo('aboutToDisappear');
  }

  initStyle(): void {
    this.styleCommon.statusBarMarginLeftRight = ResUtils.getNumberFromLength(this.styleCommon.statusBarMarginLeftRight);
  }

  private statusbarStyleChange = async (event: StatusBarStyleChangeEvent): Promise<void> => {
    if (event && this.mViewModel) {
      this.mMarginRight = this.getMMarginRight(event.statusBarPaddingRight)
      this.mViewModel.setStatusBarPaddingRight(this.mMarginRight);
      this.mViewModel.setStatusBarPaddingTop(event.statusBarPaddingTop);
      const isDiffPos: boolean = this.mViewModel.isSameLightPosition();
      if (isDiffPos || this.orientation != event.orientation) {
        this.orientation = event.orientation;
        await this.closeAllLight();
        await this.reopenAllLight();
      }
    }
  }

  private exitCCSecondPanel(exitCCPanel: boolean) {
    if (!viewMgrPolicy.isViewShowing(ViewType.DROPDOWN)) {
      return;
    }
    if (!this.checkMoveDown()) {
      return;
    }
    log.showWarn(`onControlCenterDataChanged exitCCPanel = ${exitCCPanel}`);
    if (exitCCPanel) {
      this.closeAllLight();
    } else {
      this.reopenAllLightNoAnimation(true);
    }
  }

  private checkMoveDown(): boolean {
    const isLiveV2 = SystemUICcmConfig.instance.isEnabledLive2;
    if (isLiveV2) {
      return this.moveDownVmV2.checkNeedMoveDown();
    } else {
      return this.moveDownVmV1.checkNeedMoveDown();
    }
  }

  private batteryChargingChange() {
    log.showInfo(`batteryCharging : ${this.batteryCharging} ,showBatterySoc : ${this.mIconConfig?.showBatterySoc}`);
  }

  private checkFakeLightNeedOnTheTree(): void {
    let showFakeLight = false;
    if (!this.moveDownVmV2.checkNeedMoveDown()) {
      // 不下沉的设备不需要显示假灯
      showFakeLight = false;
    } else if (this.cacheCameraLightStatus || this.cacheMicroPhoneLightStatus) {
      showFakeLight = true;
    }
    if (showFakeLight !== this.moveDownVmV2.fakeLightShow) {
      log.showInfo(`check fake light change ${showFakeLight}`)
      this.moveDownVmV2.fakeLightShow = showFakeLight;
    }
  }

  /**
   * 下拉变化时触发，用户检查隐私指示器的开关
   */
  private dropDownMoveYChange() {
    this.checkFakeLightNeedOnTheTree();
    if (!this.checkMoveDown()) {
      if (this.fakeLightIsShow) {
        this.reopenAllLightNoAnimation();
        AppStorageUtil.setOrCreate<boolean>('fakeLightIsShow', false);
        if (this.mViewModel) {
          this.mViewModel.fakeLightIsShow = false;
        }
      }
      return;
    }
    if (this.dropDownEvent.progress > 0) { // 下拉进度改变，打开假灯，并清理恢复的定时器
      if (this.checkTimerId) {
        clearInterval(this.checkTimerId);
        this.checkTimerId = -1;
      }
      if (!this.fakeLightIsShow) {
        AppStorageUtil.setOrCreate<boolean>('fakeLightIsShow', true); // 假灯立即开启
        if (this.mViewModel) {
          this.mViewModel.fakeLightIsShow = true;
        }
        log.showInfo(`fakeLightIsShow closeAllLight`);
        this.closeAllLight();
      }
    } else if (this.checkTimerId == -1) { // 进度等于0 创建一个定时器1秒后恢复真的灯
      this.checkTimerId = setTimeout(() => {
        this.reopenAllLightNoAnimation();
        log.showInfo(`fakeLightIsShow reopenAllLightNoAnimation`);
        AppStorageUtil.setOrCreate<boolean>('fakeLightIsShow', false); // 关闭假灯
        if (this.mViewModel) {
          this.mViewModel.fakeLightIsShow = false;
        }
      }, 600)
    }
  }

  /**
   * 电池图标边框
   */
  @Builder
  batteryIconBorder() {
    Image($r('app.media.ic_statusbar_battery_border'))
      .matchTextDirection(true)
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.style.statusBarBatteryWidth)
      .height(this.style.statusBarBatteryHeight)
      .translate({ x: this.batteryTranslateX })
      .opacity(this.batteryOpacity)
      .scale({ x: this.batteryScale, y: this.batteryScale })
      .fillColor(this.contentColor)
      .id(COMPONENT_ID_BATTERY_BORDER)
  }

  /**
   * 电池电量填充占比
   */
  @Builder
  batteryLevelPadding() {
    Image(this.getPaddingImage())
      .matchTextDirection(true)
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.style.statusBarBatteryWidth)
      .height(this.style.statusBarBatteryHeight)
      .translate({ x: this.batteryTranslateX })
      .opacity(this.batteryOpacity)
      .scale({ x: this.batteryScale, y: this.batteryScale })
      .fillColor(this.getBatteryLevelProgressColor())
      .id(COMPONENT_ID_BATTERY_PROGRESS)
  }

  /**
   * 电池电量文本
   */
  @Builder
  batteryLevelText() {
    Text(ResourceVm.instance.formatNumber(this.batterySoc))
      .draggable(false)
      .width(this.style.statusBarBatteryWidth)
      .height(this.style.statusBarBatteryHeight)
      .margin({ end: LengthMetrics.vp(3), top: LengthMetrics.vp(1) })
      .textAlign(TextAlign.Center)
      .align(Alignment.Center)
      .translate({ x: this.batteryTranslateX })
      .opacity(this.batteryOpacity)
      .scale({ x: this.batteryScale, y: this.batteryScale })
      .fontColor(this.contentColor)
      .fontWeight(FontWeight.Bold)
      .fontSize('11vp')
      .id(COMPONENT_ID_BATTERY_SOC)
  }

  /**
   * 显示在电池图标里面的充电图标
   */
  @Builder
  chargingIconInner() {
    Image(this.getChargingImage())
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.style.statusBarBatteryWidth)
      .height(this.style.statusBarBatteryHeight)
      .translate({ x: this.batteryTranslateX })
      .opacity(this.batteryOpacity)
      .scale({ x: this.batteryScale, y: this.batteryScale })
      .visibility(this.batteryCharging ? Visibility.Visible : Visibility.Hidden)
      .fillColor(this.contentColor)
      .id(COMPONENT_ID_BATTERY_CHARGING)
  }

  /**
   * 显示在电池图标外面的充电图标
   */
  @Builder
  chargingIconBeside() {
    Image(this.getChargingImage())
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.style.statusBarBatteryChargingWidth)
      .height(this.style.statusBarBatteryChargingHeight)
      .visibility(this.batteryCharging ? Visibility.Visible : Visibility.Hidden)
      .translate({ x: this.batteryTranslateX })
      .opacity(this.batteryOpacity)
      .scale({ x: this.batteryScale, y: this.batteryScale })
      .fillColor(this.contentColor)
      .id(COMPONENT_ID_BATTERY_CHARGING)
  }

  /**
   * 电池图标内的省电模式图标
   */
  @Builder
  powerSaveModeIconInner() {
    Image(this.getImageByLanguage($r('app.media.ic_statusbar_battery_powersaving_figure_inner'), $r('app.media.ic_statusbar_battery_powersaving_figure_inner_rtl')))
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.style.statusBarBatteryWidth)
      .height(this.style.statusBarBatteryHeight)
      .translate({ x: this.batteryTranslateX })
      .opacity(this.batteryOpacity)
      .scale({ x: this.batteryScale, y: this.batteryScale })
      .fillColor(this.contentColor)
      .id(COMPONENT_ID_POWER_SAVE_MODE)
  }

  /**
   * 电池图标外的省电模式图标
   */
  @Builder
  powerSaveModeIconBeside() {
    Image($r('app.media.ic_statusbar_battery_powersaving_figurein'))
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.style.statusBarPowerSaveWidth)
      .height(this.style.statusBarPowerSaveHeight)
      .translate({ x: this.batteryTranslateX })
      .opacity(this.batteryOpacity)
      .scale({ x: this.batteryScale, y: this.batteryScale })
      .fillColor(this.contentColor)
      .id(COMPONENT_ID_POWER_SAVE_MODE)
  }

  /**
   * 麦克风图标
   */
  @Builder
  microphoneIcon() {
    Image($r('app.media.microphone'))
      .opacity(this.privacyMicrophoneOpacity)
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.batteryHeight)
      .height(this.batteryHeight)
      .translate({ x: this.privacyMicrophoneTranslateX })
      .scale({ x: this.privacyMicrophoneScale, y: this.privacyMicrophoneScale })
      .id('privacy_microphone_icon')
  }

  /**
   *  麦克风圆点
   */
  @Builder
  microphoneCircle() {
    Circle()
      .draggable(false)
      .opacity(this.privacyMicrophoneCircleOpacity)
      .width(this.batteryHeight)
      .height(this.batteryHeight)
      .scale({ x: this.privacyMicrophoneCircleScale, y: this.privacyMicrophoneCircleScale })
      .fill($r('app.color.microphone_circle'))
      .translate({ x: this.privacyMicrophoneCircleTranslateX })
      .zIndex(0)
      .id('privacy_microphone_circle')
  }

  /**
   *  相机图标
   */
  @Builder
  cameraIcon() {
    Image($r('app.media.camera'))
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .opacity(this.privacyCameraOpacity)
      .width(this.batteryHeight)
      .height(this.batteryHeight)
      .translate({ x: this.privacyCameraTranslateX })
      .scale({ x: this.privacyCameraScale, y: this.privacyCameraScale })
      .id('privacy_camera_icon')
  }

  /**
   *  相机圆点
   */
  @Builder
  cameraCircle() {
    Circle()
      .draggable(false)
      .opacity(this.privacyCameraCircleOpacity)
      .width(this.batteryHeight)
      .height(this.batteryHeight)
      .scale({ x: this.privacyCameraCircleScale, y: this.privacyCameraCircleScale })
      .fill($r('app.color.battery_component_pic_level_low_color'))
      .translate({ x: this.privacyCameraCircleTranslateX })
      .zIndex(1)
      .id('privacy_camera_circle')
  }

  build() {
    if (DeviceHelper.isPhone() || DeviceHelper.isPad()) {
      Row() {
        Stack({}) {
          if (this.isCurAnimating) {
            // 麦克风图标
            this.microphoneIcon()
            // 相机图标
            this.cameraIcon()
            // 相机圆点
            this.cameraCircle()
            // 麦克风圆点
            this.microphoneCircle()
          }
          // border
          this.batteryIconBorder()

          //padding
          if (!(this.mIconConfig.showBatterySoc && this.batteryCharging)) { // 显示电量并在充电中，不需要padding
            this.batteryLevelPadding()
          }
          if (this.mIconConfig.showBatterySoc) { // 显示电池电量文本
            this.batteryLevelText()
          }
          if (!this.mIconConfig.showBatterySoc && this.batteryCharging) { // charging inner
            this.chargingIconInner()
          }
          if (!this.mIconConfig.showBatterySoc && !this.batteryCharging &&
            this.powerSaveMode === Constants.POWER_SAVE_MODE_ON) { // 电池图标内的内省电模式图标
            this.powerSaveModeIconInner()
          }
        }
        .width(this.style.statusBarBatteryWidth)

        if (this.batteryCharging && this.mIconConfig.showBatterySoc) { // charging beside
          this.chargingIconBeside()
        }
        if (!this.batteryCharging && this.mIconConfig.showBatterySoc &&
          this.powerSaveMode === Constants.POWER_SAVE_MODE_ON) { // 电池图标外的内省电模式图标
          this.powerSaveModeIconBeside();
        }
      }
      .height('100%')
      .opacity($r('app.float.icon_component_opacity'))
      .margin(SystemUICcmConfig.instance.isEnabledLive2 ? undefined : { end: LengthMetrics.vp(this.mMarginRight) })
      .clip(this.isClip)
      .justifyContent(FlexAlign.Center)
      .accessibilityGroup(AccessibilityVm.instance.isEnabled)
      .accessibilityLevel('yes')
      .accessibilityText(this.getAccessibilityText())
      .id(COMPONENT_ID_BATTERY_ICON)
    }
  }


  /**
   * 填充电池颜色
   * @returns string
   */
  private getBatteryLevelProgressColor(): string {
    if (!this.batteryCharging) {
      if (this.batterySoc <= 10) {
        return Constants.BATTERY_RED;
      }
      if (this.batterySoc <= 20) {
        return Constants.BATTERY_ORANGE;
      }
    }
    return this.contentColor;
  }

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    const res = GlobalContext.getContext()?.resourceManager;

    if (!this.batteryCharging) {
      if (this.powerSaveMode === Constants.POWER_SAVE_MODE_ON) {
        return `${res.getStringByNameSync('accessibility_battery_level', this.batterySoc + '%')} ${res.getStringByNameSync('accessibility_battery_power_saving')}`;
      }
      return res.getStringByNameSync('accessibility_battery_level', this.batterySoc + '%');
    }

    switch (this.chargerType) {
      case charger.ChargeType.WIRED_QUICK:
      case charger.ChargeType.WIRELESS_QUICK:
        return res.getStringByNameSync('accessibility_battery_charge_double', this.batterySoc + '%');
      case charger.ChargeType.WIRED_SUPER_QUICK:
      case charger.ChargeType.WIRELESS_SUPER_QUICK:
        return res.getStringByNameSync('accessibility_battery_supercharge', this.batterySoc + '%');
      default:
        return res.getStringByNameSync('accessibility_battery_charge', this.batterySoc + '%');
    }
  }

  private getChargingImage() {
    if (this.mIconConfig.showBatterySoc) {
      if (this.batteryPluggedType == BatteryInfo.BatteryPluggedType.WIRELESS) {
        switch (this.chargerType) {
          case charger.ChargeType.WIRELESS_QUICK:
            return $r('app.media.ic_statusbar_battery_charge_double_figure');
          case charger.ChargeType.WIRELESS_SUPER_QUICK:
            return $r('app.media.ic_statusbar_battery_supercharge_figure');
          default:
            return $r('app.media.ic_statusbar_battery_charge_figure');
        }
      } else {
        switch (this.chargerType) {
          case charger.ChargeType.WIRED_QUICK:
          case charger.ChargeType.WIRELESS_QUICK:
            return $r('app.media.ic_statusbar_battery_charge_double_figure_beside');
          case charger.ChargeType.WIRED_SUPER_QUICK:
          case charger.ChargeType.WIRELESS_SUPER_QUICK:
            return $r('app.media.ic_statusbar_battery_supercharge_figure_beside');
          default:
            return $r('app.media.ic_statusbar_battery_charge_figure_beside');
        }
      }
    } else {
      if (this.batteryPluggedType == BatteryInfo.BatteryPluggedType.WIRELESS) {
        switch (this.chargerType) {
          case charger.ChargeType.WIRELESS_QUICK:
            return this.getImageByLanguage($r('app.media.ic_statusbar_battery_charge_double'), $r('app.media.ic_statusbar_battery_charge_double_rtl'));
          case charger.ChargeType.WIRELESS_SUPER_QUICK:
            return this.getImageByLanguage($r('app.media.ic_statusbar_battery_supercharge'), $r('app.media.ic_statusbar_battery_supercharge_rtl'));
          default:
            return this.getImageByLanguage($r('app.media.ic_statusbar_battery_charge'), $r('app.media.ic_statusbar_battery_charge_rtl'));
        }
      } else {
        switch (this.chargerType) {
          case charger.ChargeType.WIRED_QUICK:
          case charger.ChargeType.WIRELESS_QUICK:
            return this.getImageByLanguage($r('app.media.ic_statusbar_battery_charge_double_figure_inner'), $r('app.media.ic_statusbar_battery_charge_double_figure_inner_rtl'));
          case charger.ChargeType.WIRED_SUPER_QUICK:
          case charger.ChargeType.WIRELESS_SUPER_QUICK:
            return this.getImageByLanguage($r('app.media.ic_statusbar_battery_supercharge_figure_inner'), $r('app.media.ic_statusbar_battery_supercharge_figure_inner_rtl'));
          default:
            return this.getImageByLanguage($r('app.media.ic_statusbar_battery_charge_figure_inner'), $r('app.media.ic_statusbar_battery_charge_figure_inner_rtl'));
        }
      }
    }
  }

  getImageByLanguage(lResource: Resource, rResource: Resource): Resource {
    if (ResourceVm.instance.isRTL) {
      return rResource;
    } else {
      return lResource;
    }
  }

  private getPaddingImage(): Resource {
    let trans = this.mIconConfig.showBatterySoc || this.batteryCharging ||
      this.powerSaveMode === Constants.POWER_SAVE_MODE_ON;
    if (this.batterySoc <= 5) {
      return this.getImageWithLowBattery(trans, 5);
    } else if (this.batterySoc <= 10) {
      return this.getImageWithLowBattery(trans, 10);
    } else if (this.batterySoc <= 20) {
      return this.getImageWithLowBattery(trans, 20);
    } else if (this.batterySoc <= 30) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_30') : $r('app.media.ic_statusbar_battery_solid_30');
    } else if (this.batterySoc <= 40) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_40') : $r('app.media.ic_statusbar_battery_solid_40');
    } else if (this.batterySoc <= 50) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_50') : $r('app.media.ic_statusbar_battery_solid_50');
    } else if (this.batterySoc <= 60) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_60') : $r('app.media.ic_statusbar_battery_solid_60');
    } else if (this.batterySoc <= 70) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_70') : $r('app.media.ic_statusbar_battery_solid_70');
    } else if (this.batterySoc <= 80) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_80') : $r('app.media.ic_statusbar_battery_solid_80');
    } else if (this.batterySoc <= 90) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_90') : $r('app.media.ic_statusbar_battery_solid_90');
    } else if (this.batterySoc <= 95) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_95') : $r('app.media.ic_statusbar_battery_solid_95');
    } else {
      return trans ? $r('app.media.ic_statusbar_battery_soc_100') : $r('app.media.ic_statusbar_battery_solid_100');
    }
  }

  getImageWithLowBattery(trans: boolean, batterySoc: number) {
    if (this.batteryCharging) {
      return $r(`app.media.ic_statusbar_battery_soc_charging_${batterySoc}`);
    }
    return trans ? $r(`app.media.ic_statusbar_battery_soc_${batterySoc}`) : $r(`app.media.ic_statusbar_battery_solid_${batterySoc}`);
  }

  onBatterySoc(showBatterySoc: boolean) {
    log.showInfo(`onBatterySoc ${showBatterySoc}`);
    this.mIconConfig.showBatterySoc = showBatterySoc;
  }

  /**
   * 隐私指示器相机动效
   */
  private cameraAppear() {
    this.isClip = true;
    // stage1.电池消失，图标出现
    animateTo({
      duration: 500,
      curve: Curve.Friction,
      expectedFrameRateRange: { min: 30, max: 30, expected: 30 },
      onFinish: () => {
        this.isClip = false;
        // 如果已经存在了麦克风，麦克风圆点关掉真正的灯，使用自己的灯过渡
        this.mViewModel?.getActivePrivacyIndicator().then((data:ESObject) => {
          /*if (data.includes(privacyIndicatorManager.PrivacySensorType.MICROPHONE)) {
            this.microphoneReOpenFlag = true;
            this.privacyMicrophoneCircleTranslateX =
              this.isSystemLanguageRTL ? -this.circleTranslate : this.circleTranslate;
            this.privacyMicrophoneCircleOpacity = 1;
            this.privacyMicrophoneCircleScale = circleSize.width / this.batteryHeight;
            try {
              privacyIndicatorManager.turnOffIndicator(ANIMATE_FROM_BIG_TO_SMALL,
                privacyIndicatorManager.PrivacySensorType.MICROPHONE);
            } catch (err) {
              LogWithHa.error(log, `turnOffIndicator MICROPHONE error`,
                StatusBarExceptionCode.PRIVACY_INDICATOR_FAIL, err, TAG);
            }
          }*/
        }).catch((err: Error) => {
          LogWithHa.error(log, `getActivePrivacyIndicator error`,
            StatusBarExceptionCode.PRIVACY_INDICATOR_FAIL, err, TAG);
        })
        // stage2 电池隐藏
        animateTo({
          duration: 50, curve: Curve.Friction, onFinish: () => {
            // stage3.图标消失，电池出现
            /*setTimeout(() => {
              this.stage3Animate(privacyIndicatorManager.PrivacySensorType.CAMERA);
            }, BREATH_WAITING_TIME);*/
          }
        }, () => { // stage2
          // 电池隐藏
          this.batteryTranslateX = this.isSystemLanguageRTL ? this.circleTranslate : -this.circleTranslate;
          this.batteryOpacity = 0;
          this.batteryScale = 0.8;
        })
      }
    }, () => { // stage1
      // 电池变化
      this.batteryTranslateX = this.isSystemLanguageRTL ? -this.batteryWidth : this.batteryWidth;
      this.batteryOpacity = 0;
      this.batteryScale = 0.8;
      // 麦克风图片变化
      this.privacyCameraTranslateX = 0;
      this.privacyCameraOpacity = 1;
      this.privacyCameraScale = 1;
    })
  }

  private cameraStage3() {
    // stage3.图标消失，电池出现
    log.showInfo('cameraStage3 icon disappear');
    setTimeout(() => {
      animateTo({
        duration: 550,
        curve: Curve.Friction,
        expectedFrameRateRange: { min: 30, max: 30, expected: 30 },
        onFinish: () => {
          // 开灯
          log.showInfo('cameraStage3 icon disappear animateTo 550');
          this.privacyCameraCircleOpacity = 1;
          // this.mViewModel?.turnOnIndicator(privacyIndicatorManager.PrivacySensorType.CAMERA, NO_ANIMATE);
          AppStorageUtil.setOrCreate<boolean>('cacheCameraLightStatus', true);
          if (this.microphoneReOpenFlag) {
            // this.mViewModel?.turnOnIndicator(privacyIndicatorManager.PrivacySensorType.MICROPHONE, NO_ANIMATE);
            // 麦克风圆点初始化
            setTimeout(() => {
              // 状态初始化
              this.privacyMicrophoneCircleOpacity = 0;
              this.privacyMicrophoneCircleScale = 1;
              this.privacyMicrophoneCircleTranslateX = 0;
            }, 50);
            this.microphoneReOpenFlag = false;
          }
          // 设置延时，防止圆点和开灯切换时跳变
          setTimeout(() => {
            // 状态初始化
            this.privacyCameraCircleOpacity = 0;
            this.privacyCameraCircleScale = 1;
          }, 50)
          // 延时，防止左移时有模糊
          setTimeout(() => {
            // 动效结束 状态置为false，删除头部元素触发下一次动效
            this.isCurAnimating = false;
            this.executeBatteryStageQueue.shift();
            this.privacyCameraCircleTranslateX = 0;
            this.privacyCameraTranslateX = this.isSystemLanguageRTL ? this.batteryWidth : -this.batteryWidth;
          }, 100);
        }
      }, () => { // stage3
        // 电池最终状态
        this.batteryTranslateX = 0;
        this.batteryOpacity = 1;
        this.batteryScale = 1;
        // 图标最终状态
        this.privacyCameraTranslateX = this.isSystemLanguageRTL ? -this.circleTranslate : this.circleTranslate;
        this.privacyCameraScale = circleSize.width / this.batteryHeight; // 同步变化成圆点大小否则会突变
        // 圆点偏移和缩放
        this.privacyCameraCircleTranslateX = this.isSystemLanguageRTL ? -this.circleTranslate : this.circleTranslate;
        this.privacyCameraCircleScale = circleSize.width / this.batteryHeight;
      })
      // 图标透明度变化
      animateTo({
        duration: 100,
        curve: Curve.Friction,
        onFinish: () => {
          // 图标初始化
          this.privacyCameraScale = 0.5;
          this.privacyCameraCircleOpacity = 1;
          this.privacyCameraOpacity = 0;
        }
      }, () => { // stage3
        this.privacyCameraOpacity = 0.8;
      })
    }, this.iconStayTime);
  }

  /**
   * 隐私指示器麦克风动效
   */
  private microphoneAppear() {
    this.isClip = true;
    log.showInfo('microphoneAppear icon disappear');
    // stage1.电池消失，图标出现
    animateTo({
      duration: 500,
      curve: Curve.Friction,
      expectedFrameRateRange: { min: 30, max: 30, expected: 30 },
      onFinish: () => {
        log.showInfo('microphoneAppear icon disappear animateTo 550');
        this.isClip = false;
        // 如果已经存在了相机，相机圆点需要变大再变小动效，关掉真正的灯，使用自己的加灯
        this.mViewModel?.getActivePrivacyIndicator().then((data:ESObject) => {
          /*if (data.includes(privacyIndicatorManager.PrivacySensorType.CAMERA)) {
            this.cameraReOpenFlag = true;
            this.privacyCameraCircleTranslateX =
              this.isSystemLanguageRTL ? -this.circleTranslate : this.circleTranslate;
            this.privacyCameraCircleOpacity = 1;
            this.privacyCameraCircleScale = circleSize.width / this.batteryHeight;
            try {
              privacyIndicatorManager.turnOffIndicator(ANIMATE_FROM_BIG_TO_SMALL,
                privacyIndicatorManager.PrivacySensorType.CAMERA);
            } catch (err) {
              LogWithHa.error(log, `turnOffIndicator CAMERA error`,
                StatusBarExceptionCode.PRIVACY_INDICATOR_FAIL, err, TAG);
            }
          }*/
        }).catch((err: Error) => {
          LogWithHa.error(log, `getActivePrivacyIndicator error`,
            StatusBarExceptionCode.PRIVACY_INDICATOR_FAIL, err, TAG);
        })
        // stage2 电池隐藏
        animateTo({
          duration: 50, curve: Curve.Friction, onFinish: () => {
            // stage3.图标消失，电池出现 type 0:相机 1：麦克风
            /*setTimeout(() => {
              this.stage3Animate(privacyIndicatorManager.PrivacySensorType.MICROPHONE);
            }, BREATH_WAITING_TIME);*/
          }
        }, () => { // stage2
          // 电池隐藏
          this.batteryTranslateX = this.isSystemLanguageRTL ? this.circleTranslate : -this.circleTranslate;
          this.batteryOpacity = 0;
          this.batteryScale = 0.8;
        })
      }
    }, () => { // stage1
      // 电池变化
      this.batteryTranslateX = this.isSystemLanguageRTL ? -this.batteryWidth : this.batteryWidth;
      this.batteryOpacity = 0;
      this.batteryScale = 0.8;
      // 麦克风图片变化
      this.privacyMicrophoneTranslateX = 0;
      this.privacyMicrophoneOpacity = 1;
      this.privacyMicrophoneScale = 1;
    })
  }

  /**
   * 执行隐私灯2次呼吸动效
   * @param num
   * @param type
   */
  public async stage3Animate(privacySensorType: ESObject) {
    /*if (privacySensorType === privacyIndicatorManager.PrivacySensorType.MICROPHONE) {
      this.microphoneStage3();
    } else {
      this.cameraStage3();
    }*/
  }

  private reopenMicrophone() {
    if (this.cameraReOpenFlag) {
      // this.mViewModel?.turnOnIndicator(privacyIndicatorManager.PrivacySensorType.CAMERA, NO_ANIMATE);
      // 相机圆点初始化
      setTimeout(() => {
        // 状态初始化
        this.privacyCameraCircleOpacity = 0;
        this.privacyCameraCircleScale = 1;
        this.privacyCameraCircleTranslateX = 0;
      }, 50);
      this.cameraReOpenFlag = false;
    }
  }

  private microphoneStage3() {
    // stage3.图标消失，电池出现
    setTimeout(() => {
      animateTo({
        duration: 550,
        curve: Curve.Friction,
        expectedFrameRateRange: { min: 30, max: 30, expected: 30 },
        onFinish: () => {
          // 开灯
          this.privacyMicrophoneCircleOpacity = 1;
          this.reopenMicrophone();
          // this.mViewModel?.turnOnIndicator(privacyIndicatorManager.PrivacySensorType.MICROPHONE, NO_ANIMATE);
          AppStorageUtil.setOrCreate<boolean>('cacheMicroPhoneLightStatus', true);
          // 设置延时，防止圆点和开灯切换时跳变
          setTimeout(() => {
            // 状态初始化
            this.privacyMicrophoneCircleOpacity = 0;
            this.privacyMicrophoneCircleScale = 1;
          }, 50)
          // 延时，防止左移时有模糊
          setTimeout(() => {
            // 动效结束 状态置为false，删除头部元素触发下一次动效
            this.isCurAnimating = false;
            this.executeBatteryStageQueue.shift();
            this.privacyMicrophoneCircleTranslateX = 0;
            this.privacyMicrophoneTranslateX = this.isSystemLanguageRTL ? this.batteryWidth : -this.batteryWidth;
          }, 100);
        }
      }, () => { // stage3
        // 电池最终状态
        this.batteryTranslateX = 0;
        this.batteryOpacity = 1;
        this.batteryScale = 1;
        // 图标最终状态
        this.privacyMicrophoneTranslateX = this.isSystemLanguageRTL ? -this.circleTranslate : this.circleTranslate;
        this.privacyMicrophoneScale = circleSize.width / this.batteryHeight; // 同步变化成原点大小否则会突变
        // 圆点偏移和缩放
        this.privacyMicrophoneCircleTranslateX =
          this.isSystemLanguageRTL ? -this.circleTranslate : this.circleTranslate;
        this.privacyMicrophoneCircleScale = circleSize.width / this.batteryHeight;
      })
      // 图标透明度变化
      animateTo({
        duration: 100,
        curve: Curve.Friction,
        onFinish: () => {
          // 图标初始化
          this.privacyMicrophoneScale = 0.5;
          this.privacyMicrophoneCircleOpacity = 1;
          this.privacyMicrophoneOpacity = 0;
        }
      }, () => { // stage3
        this.privacyMicrophoneOpacity = 0.8;
      })
      if (this.cameraReOpenFlag) {
        // 相机变大再变小效果
        animateTo({
          duration: 300,
          curve: Curve.Sharp,
          onFinish: () => {
            animateTo({ duration: 250, curve: Curve.Sharp }, () => {
              this.privacyCameraCircleScale = circleSize.width / this.batteryHeight;
            })
          }
        }, () => {
          this.privacyCameraCircleScale = (circleSize.width / this.batteryHeight) * 1.4;
        })
      }
    }, this.iconStayTime);
  }

  /**
   * 待执行动效队列发生变化触发
   */
  refreshPrivacyStage() {
    if (this.isCurAnimating === false) {
      if (this.executeBatteryStageQueue.length > 0) {
        this.batteryStage = this.executeBatteryStageQueue[0];
        // 设置执行动画需要的属性
        this.setProperties();
        this.executeAnimate();
      }
    } else {
      log.showInfo(`now is animating, pls wait`);
    }
  }

  private async processImmersiveCameraOpen() {
    try {
      /*await this.mViewModel?.turnOnIndicator(privacyIndicatorManager.PrivacySensorType.CAMERA,
        ANIMATE_FROM_SMALL_TO_BIG);*/
    } catch (err) {
      log.showError(`Immersive Open Camera Error`);
    } finally {
      this.isCurAnimating = false;
      this.executeBatteryStageQueue?.shift();
      AppStorageUtil.setOrCreate<boolean>('cacheCameraLightStatus', true);
    }
  }

  private async processImmersiveMicroPhoneOpen() {
    try {
      /*await this.mViewModel?.turnOnIndicator(privacyIndicatorManager.PrivacySensorType.MICROPHONE,
        ANIMATE_FROM_SMALL_TO_BIG);*/
    } catch (err) {
      log.showError(`Immersive Open MicroPhone Error`);
    } finally {
      this.isCurAnimating = false;
      this.executeBatteryStageQueue?.shift();
      AppStorageUtil.setOrCreate<boolean>('cacheMicroPhoneLightStatus', true);
    }
  }

  private setProperties() {
    this.setBatterySize();
    this.setPrivacyCameraTranslateX();
    this.setPrivacyMicrophoneTranslateX();
  }

  async executeAnimate() {
    this.setBatterySize();
    let isImmersive: boolean = baseStateMgr.isImmersive();
    log.showInfo(`isImmersive now is ${isImmersive}`);
    switch (this.batteryStage) {
      case BatteryStage.cameraStage:
        this.isCurAnimating = true;
        if (isImmersive) { // 沉浸式只执行开灯简单动效
          this.processImmersiveCameraOpen();
        } else {
          this.cameraAppear();
        }
        break;
      case BatteryStage.microphoneStage:
        this.isCurAnimating = true;
        if (isImmersive) { // 沉浸式只执行开灯简单动效
          this.processImmersiveMicroPhoneOpen();
        } else {
          this.microphoneAppear();
        }
        break;
      case BatteryStage.cameraClose:
        this.isCurAnimating = true;
        try {
          /*await privacyIndicatorManager.turnOffIndicator(ANIMATE_FROM_BIG_TO_SMALL,
            privacyIndicatorManager.PrivacySensorType.CAMERA);*/
        } catch (err) {
          LogWithHa.error(log, `cameraClose Error`, StatusBarExceptionCode.PRIVACY_INDICATOR_FAIL, err, TAG);
        } finally {
          this.isCurAnimating = false;
          this.executeBatteryStageQueue?.shift();
          AppStorageUtil.setOrCreate<boolean>('cacheCameraLightStatus', false);
          /*log.showInfo(`${privacyIndicatorManager.PrivacySensorType.CAMERA} turnOffIndicator finished,` +
          ` status is ${this.cacheCameraLightStatus} ${AppStorage.get<boolean>('cacheCameraLightStatus')}`);*/
        }
        break;
      case BatteryStage.microphoneClose:
        this.isCurAnimating = true;
        /*try {
          await privacyIndicatorManager.turnOffIndicator(ANIMATE_FROM_BIG_TO_SMALL,
            privacyIndicatorManager.PrivacySensorType.MICROPHONE);
        } catch (err) {
          LogWithHa.error(log, `microphoneClose Error`, StatusBarExceptionCode.PRIVACY_INDICATOR_FAIL, err, TAG);
        } finally {
          this.isCurAnimating = false;
          this.executeBatteryStageQueue?.shift();
          AppStorageUtil.setOrCreate<boolean>('cacheMicroPhoneLightStatus', false);
          log.showInfo(`${privacyIndicatorManager.PrivacySensorType.MICROPHONE} turnOffIndicator finished,` +
            ` status is ${this.cacheMicroPhoneLightStatus} ${AppStorage.get<boolean>('cacheMicroPhoneLightStatus')}`);
        }*/
        break;
    }
  }

  private setBatterySize() {
    const batterySize = getBatteryHeight();
    if (batterySize) {
      this.batteryHeight = px2vp(batterySize.height);
      this.batteryWidth = px2vp(batterySize.width);
    } else {
      this.batteryHeight = 16;
      this.batteryWidth = 24;
      log.showWarn(`BatterySize Info error use default info ${this.batteryHeight} ${this.batteryWidth}`)
    }
    if (this.mViewModel) {
      this.circleTranslate = this.mViewModel.getCircleTranslate();
    }
  }

  private setPrivacyCameraTranslateX() {
    this.privacyCameraTranslateX = this.isSystemLanguageRTL ? this.batteryWidth : -this.batteryWidth;
  }

  private setPrivacyMicrophoneTranslateX() {
    this.privacyMicrophoneTranslateX = this.isSystemLanguageRTL ? this.batteryWidth : -this.batteryWidth;
  }

  private handleSingleHandModeChangeEvent = async (event: SingleHandModeChangeEvent): Promise<void> => {
    log.showInfo('handleSingleHandModeChangeEvent');
    this.mViewModel?.updateSingleHandModeInfo(event);
    await this.closeAllLight();
    await this.reopenAllLight();
  }

  private getMMarginRight(paddingRight?: string): number {
    try {
      let tempPaddingRight = Number.parseFloat(this.statusBarPaddingRight.replace('vp', ''));
      if (paddingRight) {
        tempPaddingRight = Number.parseFloat(paddingRight.replace('vp', ''));
      }
      // 2.0不依赖于电池做右组偏移
      if (SystemUICcmConfig.instance.isEnabledLive2) {
        return tempPaddingRight;
      }
      return tempPaddingRight + (productSeries.includes('XYAO') &&
          display.getDefaultDisplaySync().orientation === display.Orientation.PORTRAIT ? 4 : 0);
    } catch (err) {
      log.showWarn(`getMMarginRight error: ${err?.code}, ${err?.message}`);
      return 0;
    }
  }

  async watchCamera() {
    log.showInfo(`watchCamera this.cacheCameraLightStatus is ${this.cacheCameraLightStatus}`);
    // await this.checkPrivacyState(privacyIndicatorManager.PrivacySensorType.CAMERA);
    if (!this.cacheCameraLightStatus) {
      try {
        log.showInfo(`closeCamera watch, cacheCameraLightStatus is ${this.cacheCameraLightStatus} , need close`);
        /*await privacyIndicatorManager.turnOffIndicator(ANIMATE_FROM_BIG_TO_SMALL,
          privacyIndicatorManager.PrivacySensorType.CAMERA);*/
      } catch (err) {
        LogWithHa.warn(log, `watchCamera closeCamera error, code: ${err?.code}`,
          StatusBarExceptionCode.PRIVACY_INDICATOR_FAIL, err, TAG);
      }
    }
    if (this.cacheCameraLightStatus) {
      try {
        // 判断开灯位置改变，需先关灯再开灯
        let lightPosition = this.mViewModel?.isSameLightPosition();
        if (lightPosition) {
          log.showInfo(`camera lightPosition change, need close`);
          /*await privacyIndicatorManager.turnOffIndicator(NO_ANIMATE,
            privacyIndicatorManager.PrivacySensorType.CAMERA);*/
        }
        log.showInfo(`openCamera watch, cacheCameraLightStatus is ${this.cacheCameraLightStatus}, need open`);
        /*await this.mViewModel?.turnOnIndicator(privacyIndicatorManager.PrivacySensorType.CAMERA,
          ANIMATE_FROM_SMALL_TO_BIG);*/
      } catch (err) {
        LogWithHa.warn(log, `watchCamera openCamera error, code: ${err?.code}`,
          StatusBarExceptionCode.PRIVACY_INDICATOR_FAIL, err, TAG);
      }
    }
  }

  async closeAllLight() {
    if (this.cacheCameraLightStatus) {
      try {
        // await privacyIndicatorManager.turnOffIndicator(NO_ANIMATE, privacyIndicatorManager.PrivacySensorType.CAMERA);
        log.showInfo(`closeAllLight cacheCameraLightStatus is ${this.cacheCameraLightStatus}, need close `);
      } catch (err) {
        LogWithHa.error(log, `closeAllLight closeCamera error`,
          StatusBarExceptionCode.PRIVACY_INDICATOR_FAIL, err, TAG);
      }
    }
    if (this.cacheMicroPhoneLightStatus) {
      try {
        // await privacyIndicatorManager.turnOffIndicator(NO_ANIMATE,
        //   privacyIndicatorManager.PrivacySensorType.MICROPHONE);
        log.showInfo(`closeAllLight cacheMicroPhoneLightStatus is ${this.cacheMicroPhoneLightStatus}, need close`);
      } catch (err) {
        LogWithHa.error(log, `closeAllLight closeMicroPhone error`,
          StatusBarExceptionCode.PRIVACY_INDICATOR_FAIL, err, TAG);
      }
    }
  }

  async reopenAllLight() {
    if (this.cacheCameraLightStatus) {
      try {
       /* await this.mViewModel?.turnOnIndicator(privacyIndicatorManager.PrivacySensorType.CAMERA,
          ANIMATE_FROM_SMALL_TO_BIG);*/
        log.showInfo(`reopenAllLight cacheCameraLightStatus is ${this.cacheCameraLightStatus}, need reopen `);
      } catch (err) {
        log.showError(`reopenAllLight openCamera error`);
      }
    }
    if (this.cacheMicroPhoneLightStatus) {
      try {
        /*await this.mViewModel?.turnOnIndicator(privacyIndicatorManager.PrivacySensorType.MICROPHONE,
          ANIMATE_FROM_SMALL_TO_BIG);*/
        log.showInfo(`reopenAllLight cacheMicroPhoneLightStatus is ${this.cacheMicroPhoneLightStatus}, need reopen`);
      } catch (err) {
        log.showError(`reopenAllLight openMicroPhone error`);
      }
    }
  }

  async reopenAllLightNoAnimation(playAnimation: boolean = false) {
    const animationType = playAnimation ? ANIMATE_FROM_SMALL_TO_BIG : NO_ANIMATE;
    if (this.cacheCameraLightStatus) {
      try {
        // await this.mViewModel?.turnOnIndicator(privacyIndicatorManager.PrivacySensorType.CAMERA, animationType, false);
        log.showInfo(`reopenAllLightNoAnimation cacheCameraLightStatus`);
      } catch (err) {
        log.showError(`reopenAllLightNoAnimation openCamera error`);
      }
    }
    if (this.cacheMicroPhoneLightStatus) {
      try {
        /*await this.mViewModel?.turnOnIndicator(
          privacyIndicatorManager.PrivacySensorType.MICROPHONE, animationType, false);*/
        log.showInfo(`reopenAllLightNoAnimation cacheMicroPhoneLightStatus`);
      } catch (err) {
        log.showError(`reopenAllLightNoAnimation openMicroPhone error`);
      }
    }
  }

  async watchMicroPhone() {
    log.showInfo(`watchMicroPhone this.cacheMicroPhoneLightStatus is ${this.cacheMicroPhoneLightStatus}`);
    // await this.checkPrivacyState(privacyIndicatorManager.PrivacySensorType.MICROPHONE);
    if (!this.cacheMicroPhoneLightStatus) {
      try {
        log.showInfo(`closeMicroPhone watch, cacheMicroPhoneLightStatus is ${this.cacheMicroPhoneLightStatus}, need close`);
        /*await privacyIndicatorManager.turnOffIndicator(ANIMATE_FROM_BIG_TO_SMALL,
          privacyIndicatorManager.PrivacySensorType.MICROPHONE);*/
      } catch (err) {
        LogWithHa.warn(log, `closeMicroPhone error, code: ${err?.code}`,
          StatusBarExceptionCode.PRIVACY_INDICATOR_FAIL, err, TAG);
      }
    }
    if (this.cacheMicroPhoneLightStatus) {
      try {
        // 判断开灯位置改变，需先关灯再开灯
        let lightPosition = this.mViewModel?.isSameLightPosition();
        if (lightPosition) {
          log.showInfo(`microPhone lightPosition change, need close`);
          /*await privacyIndicatorManager.turnOffIndicator(NO_ANIMATE,
            privacyIndicatorManager.PrivacySensorType.MICROPHONE);*/
        }
        log.showInfo(`openMicroPhone watch, cacheMicroPhoneLightStatus is ${this.cacheMicroPhoneLightStatus}, need open`);
        /*await this.mViewModel?.turnOnIndicator(privacyIndicatorManager.PrivacySensorType.MICROPHONE,
          ANIMATE_FROM_SMALL_TO_BIG);*/
      } catch (err) {
        LogWithHa.warn(log, `openMicroPhone error, code: ${err?.code}`,
          StatusBarExceptionCode.PRIVACY_INDICATOR_FAIL, err, TAG);
      }
    }
  }

  /**
   *  增强状态栏隐私指示器展示鲁棒性，缓存与底层事件保持一致
   *
   * @param privacySensorType  隐私类型 0相机 1麦克风
   */
  async checkPrivacyState(privacySensorType: ESObject) {
    this.checkFakeLightNeedOnTheTree();
    /*if (privacySensorType === privacyIndicatorManager.PrivacySensorType.MICROPHONE) {
      let checkState = await this.mViewModel?.getPrivacyStateByType(privacySensorType);
      if (checkState !== undefined && this.cacheMicroPhoneLightStatus !== checkState) {
        log.showInfo(`now cacheMicroPhoneLightStatus error, need change to checkstate: ${checkState}`);
        AppStorageUtil.setOrCreate<boolean>('cacheMicroPhoneLightStatus', checkState);
      }
    }
    if (privacySensorType === privacyIndicatorManager.PrivacySensorType.CAMERA) {
      let checkState = await this.mViewModel?.getPrivacyStateByType(privacySensorType);
      if (checkState !== undefined && this.cacheCameraLightStatus !== checkState) {
        log.showInfo(`now cacheCameraLightStatus error, need change to checkstate: ${checkState}`);
        AppStorageUtil.setOrCreate<boolean>('cacheCameraLightStatus', checkState);
      }
    }*/
  }

  refreshPrivacyStateChange() {
    log.showInfo(`user changed, new value is ${this.privacyIndicatorUserChangeKey} need check light`);
    this.watchCamera();
    this.watchMicroPhone();
  }

  async refreshRTLLanguageStateChange() {
    log.showInfo(`RTL language state changed, state is ${this.isSystemLanguageRTL} need check light`);
    /*await this.checkPrivacyState(privacyIndicatorManager.PrivacySensorType.MICROPHONE);
    await this.checkPrivacyState(privacyIndicatorManager.PrivacySensorType.CAMERA);*/
    await this.closeAllLight();
    await this.reopenAllLight();
  }
}
