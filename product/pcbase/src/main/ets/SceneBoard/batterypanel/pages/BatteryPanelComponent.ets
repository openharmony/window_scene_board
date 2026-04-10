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

import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { PluginSlot, HiSysEventUtil, EvtBus, DeviceHelper } from '@ohos/frameworkwrapper';
import { windowMgr, StartAbilityUtil, ResUtils } from '@ohos/windowscene';
import { settingsDataManager } from '@ohos/frameworkwrapper';
import charger from '@ohos.charger';
import Window from '@ohos.window';
import lazy NotificationController from '@ohos/batterycomponent/src/main/ets/pc/NotificationController';
import { Log, LogDomain, LogHelper } from '@ohos/basicutils';
import batteryInfo from '@ohos.batteryInfo';
import { ExtAppConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import StyleConfiguration from '../common/StyleConfiguration';
import { CommonComponentStyle, BatteryPanelComponentStyle } from '../common/StyleConfiguration';
import Constants from '../common/Constants';
import { NormalPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import StyleConstants from '../../../common/constants/StyleConstants';
import BatteryChargeTextController from '../common/BatteryChargeTextController';
import SettingsUtil from '../../soundpanel/util/SettingsUtil';
import { StatusBarTipsChangeEvent } from '@ohos/systemuicommon';
import { ChargeStatus } from '../utils/enum';

const TAG = 'BatteryPanel-BatteryPanelComponent';

const COMPONENT_ID_BATTERY_TEXT = TAG + '_Text_batteryText'
const COMPONENT_ID_BATTERY_CHARGING_TEXT = TAG + '_Text_batteryChargingText'
const COMPONENT_ID_MORE = TAG + '_Text_more';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const MORE_KEY = 'h1_systemUI_product_pc_batteryPanelComponents_more';
const ASW_UI_STATE = 'asw_ui_state'
const USER_CUSTOM_MAX_CHARGE_VALUE = 'UsercustomedMAXChargeValue';
const USER_SMT_CHG_STATE = 'UserSmtChgState';

/**
 * 窗口名
 */
const WINDOW_NAME = PluginSlot.SLOT_STATUS_BATTERY_PANEL;
const keyboard = 4;

enum TurboChargingStatus {
  TURBO_CHANGING_DEFAULT = '0',
  TURBO_CHANGING_PRE = '1',
  TURBO_CHANGING_START = '2'
}

@Component
export default struct BatteryPanelComponent {
  private eventType: string = HiSysEventUtil.TOUCH_EVENT;
  @StorageLink('batterySoc') @Watch('resizePanelWindow') batterySoc: number = 100;
  @StorageLink('batteryCharging') @Watch('resizePanelWindow') batteryCharging: boolean = false;
  @StorageLink('isNotChargingStatus') @Watch('resizePanelWindow') isNotChargingStatus: boolean = false;
  @StorageLink('customFullCharge') @Watch('resizePanelWindow') customFullCharge: boolean = false; // 自定义本次充满
  @StorageLink('smartFullCharge') @Watch('resizePanelWindow') smartFullCharge: boolean = false; // 智能充电本次充满
  @StorageLink('chargerType') @Watch('refreshChargeText')
  chargerType: charger.ChargeType = charger.ChargeType.NONE;
  @StorageProp('turboChargeStatus') @Watch('refreshChargeText')
  turboChargeStatus: string = TurboChargingStatus.TURBO_CHANGING_DEFAULT;
  @State chargeText: Resource | undefined = undefined;
  @State styleCommon: CommonComponentStyle = StyleConfiguration.getCommonComponentStyle();
  @State style: BatteryPanelComponentStyle = StyleConfiguration.getBatteryPanelComponentStyle();
  @Consume mHeight: number;
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @Consume persistentId: number;
  @State isSelected: boolean = false;
  @State isHover: boolean = false;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State @Watch('refreshChargeText') aswUiState: string | undefined = undefined;
  @State @Watch('refreshChargeText') userSmtChgStateStr: string | undefined = undefined;
  @State @Watch('refreshChargeText') userCustomMaxChargeValue: string = '';
  // 控制是否显示智能充电和自定义充电
  @State @Watch('resizePanelWindow') isSmartChargingOrCustomCharging: boolean = false;

  onProduceStatusBarTipsEvent(): StatusBarTipsChangeEvent {
    return this.getStatusBarTipsChangeEvent();
  }

  @Styles
  normalStyles() {
    .border({
      width: $r('app.float.ntf_pc_menu_item_border'),
      color: $r('app.color.ntf_pc_click_menu_item_normal_border_color')
    })
  }

  @Styles
  focusedStyles() {
    .border({
      width: $r('app.float.ntf_pc_menu_item_border'),
      color: $r('app.color.ntf_pc_click_menu_item_focused_border_color')
    })
  }

  aboutToAppear() {
    Log.showInfo(TAG, `BatteryPanelComponent, aboutToAppear`);
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    EvtBus.produceOn(StatusBarTipsChangeEvent, this.onProduceStatusBarTipsEvent.bind(this));
    this.setUserSmtChgState();
    this.setAswUiState();
    this.setUserCustomMAXChargeValue();
    this.registerSmartCharge();
    this.registerAswUiCharge();
    this.registerUserCustomMAXChargeValue();
    this.resizePanelWindow();
    NotificationController.getInstance().init();
    BatteryChargeTextController.getInstance().init();
    this.refreshChargeText();
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `BatteryPanelComponent, aboutToDisAppear`);
    EvtBus.produceOff(StatusBarTipsChangeEvent, this.onProduceStatusBarTipsEvent.bind(this));
    NotificationController.getInstance().unInit();
    BatteryChargeTextController.getInstance().destroy();
    this.unRegisterAswUiCharge();
    this.unRegisterSmartCharge();
    this.unRegisterUserCustomMAXChargeValue();
  }

  resizePanelWindow() {
    let defaultRect = windowMgr.getWindowPosition(WINDOW_NAME);
    let heightWin = defaultRect.height;
    log.showInfo(`batteryInfo.chargingStatus: ${batteryInfo.chargingStatus}`);
    this.isNotChargingStatus = batteryInfo.chargingStatus === batteryInfo.BatteryChargeState.DISABLE;
    if (!this.showBatteryChargingText()) {
      heightWin = Constants.WINDOW_HEIGHT_UNCHARGING;
      this.mHeight = Constants.WINDOW_HEIGHT_UNCHARGING;
    } else {
      heightWin = Constants.WINDOW_HEIGHT;
      this.mHeight = Constants.WINDOW_HEIGHT;
    }
    let updateRect: Window.Rect = {
      top: defaultRect.top,
      left: defaultRect.left,
      width: defaultRect.width,
      height: vp2px(heightWin)
    };
    Log.showInfo(TAG, `onBatteryCharging: updateRect: ${JSON.stringify(updateRect)}`);
    windowMgr.updateWindowPosition(WINDOW_NAME, updateRect);
    this.refreshChargeText();
  }

  build() {
    Column() {
      this.chargeStatusText()

      this.MyDivider(this.style.batteryPanelMarginLeft, 'Divider')

      this.moreBatterySettings()
    }
    .width('100%')
    .onDisAppear(() => {
      this.reset();
    })
    .onAppear(() => {
      this.resizePanelWindow();
    })
  }

  @Builder
  chargeStatusText() {
    Column() {
      Row() {
        Text(this.getBatteryText(this.batteryCharging))
          .draggable(false)
          .id(COMPONENT_ID_BATTERY_TEXT)
          .fontColor(this.colorModeViewData.wifiOffTextColor)
          .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
          .fontSize(this.panelInfo?.listTextSize)
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontFamily('HarmonyHeiTi')
      }
      .margin({
        left: this.styleCommon.panelSubTextMargin,
        right: this.styleCommon.panelSubTextMargin
      });

      // 新设计：电池设置，需要改成Footnote类型
      if (this.showBatteryChargingText() && this.chargeText !== undefined) {
        Row() {
          Text(this.chargeText)
            .draggable(false)
            .id(COMPONENT_ID_BATTERY_CHARGING_TEXT)
            .fontColor(this.colorModeViewData.wifiOffTextColor)
            .foregroundBrightness(this.colorModeViewData.foregroundTertiaryGlossOption)
            .fontSize(this.panelInfo?.listAssistedTextSize)
            .fontWeight(FontWeight.Regular)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontFamily('HarmonyHeiTi');
        }
        .margin({
          left: this.styleCommon.panelChargingTextMarginLeft,
          right: this.styleCommon.panelChargingTextMarginLeft
        });
      }
    }
    .padding({
      top: this.styleCommon.panelSubTextMarginTop,
      bottom: this.styleCommon.panelChargingTextMarginTop
    })
    .width('100%')
    .justifyContent(FlexAlign.SpaceAround)
    .alignItems(HorizontalAlign.Start)
    .height(this.showBatteryChargingText() ?
    this.styleCommon.panelContentChargingHeight : this.styleCommon.panelContentHeight)
  }

  @Builder
  moreBatterySettings() {
    Row() {
      Row() {
        this.moreBatterySettingsButton()
      }
      .height(this.style.batteryPanelButtonHeight)
      .width('100%')
      .borderRadius(this.panelInfo?.hoverRadius)
    }
    .key(MORE_KEY)
    .padding({ left: this.style.batteryPanelBetweenSize, right: this.style.batteryPanelBetweenSize })
    .height(this.style.batteryPanelButtonHeight)
    .width('100%')
    .margin({
      top: this.style.batteryPanelMarginBottom
    })
  }

  @Builder
  moreBatterySettingsButton() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Text($r('app.string.battery_more_settings'))
        .draggable(false)
        .id(COMPONENT_ID_MORE)
        .fontSize(this.panelInfo?.footnoteTextSize)
        .fontWeight(FontWeight.Medium)
        .fontFamily('HarmonyHeiTi')
        .fontColor(this.colorModeViewData.wifiOffTextColor)
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .focusable(true);
    }
    .padding({ left: this.style.batteryPanelPadding, right: this.style.batteryPanelPadding })
    .height(this.style.batteryPanelButtonHeight)
    .borderRadius(this.panelInfo?.hoverRadius)
    .backgroundColor(this.getBackgroundColor())
    .stateStyles({
      normal: this.normalStyles,
      focused: this.focusedStyles
    })
    .onClick((event?: ClickEvent): void => {
      if (event) {
        this.onClickEvent(event);
      }
    })
    .onTouch((event?: TouchEvent): void => {
      if (event) {
        this.onTouchEvent(event);
      }
    })
    .onHover((isHover) => {
      this.isHover = isHover || false;
    })
    .onMouse((event?: MouseEvent): void => {
      if (event) {
        this.onMouseEvent(event);
      }
    })
  }

  private reset() {
    this.isSelected = false;
    this.isHover = false;
  }

  @Builder
  MyDivider(marginLeft: Length = this.style.batteryPanelMarginLeft, key: string = '') {
    Divider()
      .strokeWidth(1)
      .color(this.panelInfo?.separatorColor)
      .key(`${TAG}_${key}`)
      .margin({
        left: marginLeft,
        right: this.style.batteryPanelMarginRight,
      })
  }

  private onMouseEvent(event: MouseEvent) {
    if (event.button === MouseButton.Left && event.action === MouseAction.Press) {
      this.isSelected = true;
      this.eventType = HiSysEventUtil.MOUSE_EVENT;
    } else if (event.button === MouseButton.Left && event.action === MouseAction.Release) {
      this.isSelected = false;
    } else {
      log.showDebug(`onTouch event button: ${event.button}`);
    }
  }

  private onTouchEvent(event: TouchEvent) {
    if (event.type === TouchType.Down) {
      this.isSelected = true;
      this.eventType = HiSysEventUtil.TOUCH_EVENT;
    } else if (event.type === TouchType.Up) {
      this.isSelected = false;
    } else {
      log.showDebug(`onTouch event type: ${event.type}`);
    }
    if (event.stopPropagation) {
      event.stopPropagation();
    } else {
      return;
    }
  }

  private getBackgroundColor(): ResourceColor {
    if (this.isSelected) {
      return this.panelInfo?.isDark ?
      StyleConstants.DEFAULT_DARK_PRESS_COLOR : StyleConstants.DEFAULT_PRESS_COLOR;
    } else if (this.isHover) {
      return this.panelInfo?.isDark ?
      StyleConstants.DEFAULT_DARK_HOVER_COLOR : StyleConstants.DEFAULT_HOVER_COLOR;
    } else {
      return $r('app.color.transparent');
    }
  }

  private onClickEvent(event: ClickEvent) {
    if (event.source === keyboard) {
      this.eventType = HiSysEventUtil.SHORTCUT_EVENT;
    } else {
      log.showInfo(`onClickEvent, event source: ${event.source}`);
    }
    this.execClickAction();
  }

  private execClickAction() {
    HiSysEventUtil.reportSoundMenu(HiSysEventUtil.CLICK_MORE, this.eventType);
    // 点击跳转页面，隐藏面板
    windowMgr.hideWindowWithAnim(WINDOW_NAME);
    const is2In1Pc: boolean = DeviceHelper.is2In1DevicePcType();
    StartAbilityUtil.startAbilityFromOther({
      bundleName: ExtAppConstants.PKG_PC_SETTINGS,
      abilityName: ExtAppConstants.ABILITY_PC_SETTINGS_AUDIO,
      uri: is2In1Pc ? 'battery' : 'pc_powerandbattery_settings',
      moduleName: is2In1Pc ? 'phone_settings' : 'pc_settings',
    });
  }

  private showBatteryChargingText() {
    log.showInfo(`isNotChargingStatus: ${this.isNotChargingStatus},batteryCharging: ${this.batteryCharging},isSmartChargingOrCustomCharging: ${this.isSmartChargingOrCustomCharging}`);
    // 1.充电器在位时显示文本; 2.非复充状态且触发了智能充电或自定义充电时显示文本
    if (!this.batteryCharging ||
      (this.isNotChargingStatus && this.batterySoc !== 100) && !this.isSmartChargingOrCustomCharging) {
      return false;
    }
    return true;
  }

  private registerSmartCharge() {
    try {
      SettingsUtil.registerKeyObserverGeneral(USER_SMT_CHG_STATE, () => {
        this.setUserSmtChgState();
      });
      return true;
    } catch (error) {
      log.showError(`Failed to register asw_ui_state observer: ${error?.code},${error?.message}`);
      return false;
    }
  }

  // 获取智能充电生效状态
  private async setUserSmtChgState() {
    let userSmtChgStateStr = await SettingsUtil.getValue(USER_SMT_CHG_STATE);
    if (!userSmtChgStateStr) {
      log.showError('get userSmtChgStateStr error!');
      return false;
    }
    this.userSmtChgStateStr = userSmtChgStateStr;
    this.smartFullCharge = false; // 每次智能充电重新生效则取消本次充满
    log.showInfo(`userSmtChgState : ${this.userSmtChgStateStr}`);
    return true;
  }

  private registerAswUiCharge() {
    try {
      SettingsUtil.registerKeyObserverGeneral(ASW_UI_STATE, () => {
        this.setAswUiState();
      });
      return true;
    } catch (error) {
      log.showError(`Failed to register asw_ui_state observer: ${error?.code},${error?.message}`);
      return false;
    }
  }

  // 获取自定义充电模式开关状态
  private async setAswUiState() {
    let aswUiState = await SettingsUtil.getValue(ASW_UI_STATE);
    if (!aswUiState) {
      log.showError('get aswUiState error!');
      return false;
    }
    this.aswUiState = aswUiState;
    log.showInfo(`aswUiState : ${this.aswUiState}`);
    return true;
  }

  private registerUserCustomMAXChargeValue() {
    try {
      SettingsUtil.registerKeyObserverGeneral(USER_CUSTOM_MAX_CHARGE_VALUE, () => {
        this.setUserCustomMAXChargeValue();
        this.customFullCharge = false; // 自定义电量值（包括自定义开关）改变就取消本次充满
      })
      return true;
    } catch (error) {
      log.showError(`Failed to register asw_ui_state observer: ${error?.code},${error?.message}`);
      return false;
    }
  }

  // 获取最大自定义电量
  private async setUserCustomMAXChargeValue() {
    let userCustomMaxChargeValue = await SettingsUtil.getValue(USER_CUSTOM_MAX_CHARGE_VALUE);
    if (!userCustomMaxChargeValue) {
      log.showError('get userCustomMaxChargeValue error!');
      return false;
    }
    this.userCustomMaxChargeValue = userCustomMaxChargeValue;
    log.showInfo(`userCustomMaxChargeValue : ${this.userCustomMaxChargeValue}`);
    return true;
  }

  private getBatteryText(charging: boolean) {
    log.showInfo(`chargingStatus : ${batteryInfo.chargingStatus}`);
    if (charging || batteryInfo.chargingStatus === batteryInfo.BatteryChargeState.DISABLE) {
      return this.style.adapterText;
    }
    return this.style.batteryText;
  }

  private getBatteryChargingText(isHoverTips: boolean): Resource | undefined {
    log.showInfo(`getBatteryText Soc: ${this.batterySoc}, aswUiState: ${this.aswUiState},
      customFullCharge: ${this.customFullCharge}, smartFullCharge: ${this.smartFullCharge}`);
    let chargeStatus = this.getBatteryChargeStatus();
    settingsDataManager.setValue(null, 'batteryChargeStatus', chargeStatus.toString());
    switch (chargeStatus) {
      case ChargeStatus.UNCHARGE:
        return undefined;
      case ChargeStatus.SMART_CHARGE:
        return isHoverTips ? this.style.batterySmartChargingText : this.style.batteryPanelSmartChargingText;
      case ChargeStatus.CUSTOM_CHARGE:
        return isHoverTips ? this.style.batteryCustomChargingText : this.style.batteryPanelCustomChargingText;
      case ChargeStatus.FULL_CHARGE:
        return isHoverTips ? this.style.batteryChargingFullText : this.style.batteryPanelChargingFullText;
      case ChargeStatus.SUPER_CHARGE:
        return isHoverTips ? this.style.batterySuperChargingText : this.style.batteryPanelSuperChargingText;
      case ChargeStatus.TURBO_CHARGE:
        return isHoverTips ? this.style.batteryTurboChargingText : this.style.batteryPanelTurboChargingText;
      default:
        return isHoverTips ? this.style.batteryChargingText : this.style.batteryPanelChargingText;
    }
  }

  private getBatteryChargeStatus(): ChargeStatus {
    if (!this.showBatteryChargingText()) {
      return ChargeStatus.UNCHARGE;
    } else if (this.aswUiState === '0' && this.userSmtChgStateStr === '1' &&
      !this.smartFullCharge) { // 智能充电 且 生效 且 未设置本次充满
      return ChargeStatus.SMART_CHARGE;
    } else if (this.aswUiState === '1' &&
      this.batterySoc >= parseInt(this.userCustomMaxChargeValue) &&
      !this.customFullCharge) { // 自定义充电 且 电量大于设定值 且 未设置本次充满
      return ChargeStatus.CUSTOM_CHARGE;
    } else if (this.batterySoc === 100) {
      return ChargeStatus.FULL_CHARGE;
    } else {
      switch (this.chargerType) {
        case charger.ChargeType.WIRED_QUICK:
        case charger.ChargeType.WIRELESS_QUICK:
          return ChargeStatus.NORMAL_CHARGE;
        case charger.ChargeType.WIRED_SUPER_QUICK:
        case charger.ChargeType.WIRELESS_SUPER_QUICK:
          // 在chargeType为SUPER_QUICK的时候，需要判断当前有没有开启Turbo充电，如果开启了则显示turbo充电
          try {
            this.turboChargeStatus = batteryInfo.getBatteryConfig('turbo_status');
          } catch (err) {
            log.showError('get turbo_status failed.');
          }
          log.showInfo(`turboChargeStatus: ${this.turboChargeStatus}`);
          if (this.turboChargeStatus === TurboChargingStatus.TURBO_CHANGING_START) {
            return ChargeStatus.TURBO_CHARGE;
          }
          return ChargeStatus.SUPER_CHARGE;
        default:
          log.showInfo(`get battery text failed cause chargeType: ${this.chargerType}`);
          break;
      }
      return ChargeStatus.NORMAL_CHARGE;
    }
  }

  private refreshChargeText() {
    this.chargeText = this.getBatteryChargingText(false);
    // 时时更新智能充电或自定义充电的显示状态
    this.isSmartChargingOrCustomCharging = this.aswUiState === '0' && this.userSmtChgStateStr === '1' ||
      this.aswUiState === '1' && this.batterySoc >= parseInt(this.userCustomMaxChargeValue);
    log.showInfo(`refreshChargeText: ${this.chargeText}`);
    EvtBus.post(StatusBarTipsChangeEvent, this.getStatusBarTipsChangeEvent());
  }

  private getStatusBarTipsChangeEvent(): StatusBarTipsChangeEvent {
    let tips: string = ResUtils.getInnerStringNumS(this.style.batteryPower, `${this.batterySoc}%`);
    let chargeStatusTips = this.getBatteryChargingText(true);
    if (chargeStatusTips) {
      tips = ResUtils.getInnerStringNumS(this.style.batteryPower, `${ResUtils.getInnerStringNumS(chargeStatusTips, `${this.batterySoc}%`)}`);
    }
    log.showInfo(`hoverTips: ${tips}`);
    return StatusBarTipsChangeEvent.create(WINDOW_NAME, tips);
  }

  private unRegisterAswUiCharge() {
    SettingsUtil.unregisterKeyObserverGeneral(ASW_UI_STATE);
  }

  private unRegisterSmartCharge() {
    SettingsUtil.unregisterKeyObserverGeneral(USER_SMT_CHG_STATE);
  }

  private unRegisterUserCustomMAXChargeValue() {
    SettingsUtil.unregisterKeyObserverGeneral(USER_CUSTOM_MAX_CHARGE_VALUE);
  }
}
