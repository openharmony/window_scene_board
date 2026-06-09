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

import {
  AppStorageUtil,
  CommonUtils,
  DataProperty,
  LogDomain,
  Logger,
} from '@ohos/basicutils';
import {
  CutoutEvent,
  EvtBus,
  DeviceHelper,
  EventManager,
  ConfigurationEvent,
  DropDownEvent,
  PluginSlot,
  GlobalContext
} from '@ohos/frameworkwrapper';
import { ResUtils, DisplayEvent } from '@ohos/windowscene';
import { RTLUtil } from '@ohos/componenthelper';
import { StyleConfigurationCommon, CommonStyle } from '@ohos/systemuicommon/Index';
import StyleConfiguration from '../common/StyleConfiguration';
import { SignalComponentStyle } from '../common/StyleConfiguration';
import Constants, { CardSituation } from '../common/constants';
import AirplaneController from '@ohos/airplanecomponent/src/main/ets/default/controller/AirplaneController';
import measure from '@ohos.measure';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import Sim from '@ohos.telephony.sim';
import SignalModel, { defaultEmergencyInfo, EmergencyInfo, emptySim, SimSpnInfo } from '../signalModel';
import { display } from '@kit.ArkUI';
import { LayoutUtils, STATUSBAR_MIN_LEFT_WIDTH, SystemUICommonUtil } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';
import { ResourceVm } from '@ohos/systemuicommon/newIndex';
import { AccessibilityVm } from '@ohos/systemuicommon/newIndex';
import { ArkUIAdapter, ViewName } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
// instrument ignore file

const TAG = 'SignalComponent-SignalOperatorInfo';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

const COMPONENT_ID_OPERATOR = TAG + '_Text_operator';
const COMPONENT_ID_HD = TAG + '_Image_hd';
const NO_CARD_NO_SERVICE: Resource = $r('app.string.no_card_no_service');
const NO_SERVICE: Resource = $r('app.string.net_null');
const SOS_ONLY: Resource = $r('app.string.sos_only');
const NO_CARD_SOS_ONLY: Resource = $r('app.string.no_card_sos_only');
const STRING_NULL: string = '';
const DEFAULT_X_OFFSET: number = 12;
const FONT_WEIGHT = FontWeight.Medium;
const PLUGIN_SLOT = 'status_bar_operator';
const SLOT_ONE = 0;
const SLOT_TWO = 1;
const ICON_SHOW_NAME = 'HD';

interface SingleCardParam {
  isFirst: boolean;
}

function isEmpty(str: string): boolean {
  return (str === null || str.trim().length === 0);
}

@Component
export default struct signalOperatorInfo {
  @StorageLink('dropDownEvent') @Watch('onDropdownChanged') dropDownEvent: DropDownEvent =
    DropDownPanelManager.getDropDownEvent();
  @StorageLink('mOperatorInfo') @Watch('hasTwoSim') operatorInfo: SimSpnInfo[] = [emptySim, emptySim, emptySim];
  @StorageLink('emergency') @Watch('hasTwoSim') emergency: EmergencyInfo = defaultEmergencyInfo;
  @StorageLink('mCutoutChange') @Watch('hasTwoSim') mCutoutChange: boolean = false;
  @StorageLink('hasSimCards') @Watch('hasTwoSim') hasSimCards: boolean[] = [false, false, false];
  @StorageLink('simCardIsActive') @Watch('hasTwoSim') simCardIsActive: boolean[] = [false, false, false];
  @StorageLink('mCardSituation') @Watch('hasTwoSim') cardSituation: CardSituation = CardSituation.NO_CARD;
  @StorageLink('mImsState') @Watch('hasTwoSim') mIMSInfo: number[] =
    [Constants.IS_REGISTER, Constants.IS_REGISTER, Constants.IS_REGISTER];
  @StorageLink('plmnNumeric') @Watch('hasTwoSim') plmnNumeric: string[] =
    [Constants.NET_NULL, Constants.NET_NULL, Constants.NET_NULL];
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @State availableWidth: number = 1;
  @State displayWidth: number = 1;
  @State orientation: number = display.Orientation.PORTRAIT;
  @State mAirplaneData: ToggleViewData = AirplaneController.getViewData();
  @State isMarquee: boolean = false;
  @State simCount: number = 0;
  @Consume @Watch('statusBarPaddingChange') statusBarPaddingRight: string;
  @Consume @Watch('statusBarPaddingChange') statusBarPaddingLeft: string;
  @Consume excludeSlotList: string[];
  @StorageLink('satelliteModeSwitch') satelliteModeSwitch: boolean = false;

  /**
   * 事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 当前语言
   */
  private language: string = '';

  /**
   * 是否已经触发过跑马灯运行
   */
  private isRunMarquee: boolean = false;

  aboutToAppear() {
    this.simCount = Sim.getMaxSimCount();
    log.showInfo(TAG, `signalOperatorInfo aboutToAppear this.simCount is ${this.simCount}`);
    this.changeLanguage();
    this.hasTwoSim();
    this.isMarquee = true;
    this.eventMgr.on(DisplayEvent, this.handleDisplayEvent);
  }

  aboutToDisappear() {
    log.showInfo(TAG, 'signalOperatorInfo aboutToDisappear');
    this.eventMgr.offAll();
  }

  changeLanguage() {
    this.eventMgr.on(ConfigurationEvent, (configEvent: ConfigurationEvent) => {
      if (CommonUtils.isEmpty(this.language)) {
        this.language = configEvent.config?.language ?? '';
        return;
      }
      // 语言切换，刷新字串，刷新有效宽度
      let language = configEvent.config?.language;
      if (language && this.language != language) {
        this.language = language;
        this.availableWidth = getAvailableWidth(this.orientation, this.displayWidth,
          this.statusBarPaddingLeft, this.statusBarPaddingRight);
      }
    });
  }

  hasTwoSim(): void {
    log.showInfo(TAG, `hasTwoSim hasSimCards: ${this.hasSimCards.join('->')}, simCardIsActive: ${this.simCardIsActive.join('->')}, cardSituation: ${this.cardSituation}`);
    this.availableWidth = getAvailableWidth(this.orientation, this.displayWidth,
      this.statusBarPaddingLeft, this.statusBarPaddingRight)
  }

  onDropdownChanged() {
    if (!this.dropDownEvent.isPanelExpand()) {
      this.isMarquee = false;
      this.isRunMarquee = false;
      return;
    }

    if (!this.isRunMarquee) {
      this.isRunMarquee = true;
      this.isMarquee = true;
    }
  }

  private handleDisplayEvent = (event: DisplayEvent): void => {
    let newDisplayWidth = event.display?.scbScreenProperty?.width ?? 0;
    let newOrientation = DeviceHelper.getOrientation();
    if (newOrientation !== this.orientation || this.displayWidth !== newDisplayWidth) {
      this.orientation = newOrientation
      this.displayWidth = newDisplayWidth
      log.showInfo(TAG, `newDisplayWidth ${this.displayWidth} newOrientation ${this.orientation}`)
      this.availableWidth = getAvailableWidth(this.orientation, this.displayWidth,
        this.statusBarPaddingLeft, this.statusBarPaddingRight)
    }
  }

  private statusBarPaddingChange(): void {
    this.availableWidth = getAvailableWidth(this.orientation, this.displayWidth,
      this.statusBarPaddingLeft, this.statusBarPaddingRight)
  }

  private isHdIconShow = (isFistParam: boolean): boolean => {
    // 显示天通卫星图标后，禁止显示HD图标
    if (this.satelliteModeSwitch) {
      return false;
    }
    return this.mIMSInfo[isFistParam ? 0 : 1] === Constants.IS_HD_REGISTER_TECH;
  }

  private isNotVoiceIconShow = (isFistParam: boolean): boolean => {
    const slotID = isFistParam ? 0 : 1;
    // 启用天通卫星或 非电信卡，不显示禁用通话图标
    if (this.satelliteModeSwitch || !this.isTelecom(this.plmnNumeric[slotID]) ) {
      return false;
    }
    return this.mIMSInfo[slotID] === Constants.IS_UNREGISTER;
  }

  private isVoWifiIconShow = (isFistParam: boolean): boolean => {
    // 显示天通卫星图标后，禁止显示VOWIFI图标
    if (this.satelliteModeSwitch) {
      return false;
    }
    return this.mIMSInfo[isFistParam ? 0 : 1] === Constants.IS_WLAN_REGISTER_TECH;
  }

  isTelecom(plmn: string): boolean {
    switch (plmn) {
      case Constants.TELECOM_CDMA_PLMN:
      case Constants.TELECOM_CDMA2_PLMN:
      case Constants.TELECOM_FDD_PLMN:
        return true;
      default:
        return false;
    }
  }

  build() {
    Row() {
      if (this.mAirplaneData.isOn) {
        AirPlaneComponent({
          isMarquee: this.isMarquee,
          availableWidth: this.availableWidth,
        })
      } else if (this.simCount > 0) {
        // simCount 表示设备可用插卡数量，只有卡数量大于0，才显示运营商信息
        if ([CardSituation.SINGLE_CARD_0, CardSituation.SINGLE_CARD_1].includes(this.cardSituation)) {
          this.buildSinglesCard({ isFirst: this.cardSituation === CardSituation.SINGLE_CARD_0 });
        } else if ([CardSituation.NO_CARD, CardSituation.NO_CARD_EMPTY].includes(this.cardSituation)) {
          this.buildNoCard();
        } else if ([CardSituation.DUAL_CARD_0_1, CardSituation.TRIPLE_CARD].includes(this.cardSituation)) {
          this.buildDualCard();
        } else if ([CardSituation.DUAL_CARD_SKY_0, CardSituation.DUAL_CARD_SKY_1].includes(this.cardSituation)) {
          this.buildSinglesAndSkyToneCard({ isFirst: this.cardSituation === CardSituation.DUAL_CARD_SKY_0 });
        } else if (this.cardSituation === CardSituation.SINGLE_CARD_SKY) {
          this.buildOnlySkyTone();
        }
      }
    }
    .height('100%')
  }
  @Builder
  buildDualCard() {
    Column() {
      SingleOperatorInfo({
        operatorName: this.operatorInfo[0].simName,
        isDomestic: this.operatorInfo[0].isDomestic,
        emergency: this.emergency.cardOne,
        hdIconShow: this.isHdIconShow(true),
        notVoiceIconShow: this.isNotVoiceIconShow(true),
        voWifiIconShow: this.isVoWifiIconShow(true),
        isTwoLine: true,
        isMarquee: this.isMarquee,
        availableWidth: this.availableWidth,
        hasSimCard: this.hasSimCards[0],
      })
      SingleOperatorInfo({
        operatorName: this.operatorInfo[1].simName,
        isDomestic: this.operatorInfo[1].isDomestic,
        emergency: this.emergency.cardTwo,
        hdIconShow: this.isHdIconShow(false),
        notVoiceIconShow: this.isNotVoiceIconShow(false),
        voWifiIconShow: this.isVoWifiIconShow(false),
        isTwoLine: true,
        isMarquee: this.isMarquee,
        availableWidth: this.availableWidth,
        hasSimCard: this.hasSimCards[1],
      })
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildSinglesCard(params: SingleCardParam) {
    SingleOperatorInfo({
      operatorName: params.isFirst ? this.operatorInfo[0].simName : this.operatorInfo[1].simName,
      isDomestic: params.isFirst ? this.operatorInfo[0].isDomestic : this.operatorInfo[1].isDomestic,
      emergency: params.isFirst ? this.emergency.cardOne : this.emergency.cardTwo,
      hdIconShow: this.isHdIconShow(params.isFirst),
      notVoiceIconShow: this.isNotVoiceIconShow(params.isFirst),
      voWifiIconShow: this.isVoWifiIconShow(params.isFirst),
      isTwoLine: false,
      isMarquee: this.isMarquee,
      availableWidth: this.availableWidth,
      hasSimCard: true,
    })
  }

  @Builder
  buildNoCard() {
    SingleOperatorInfo({
      emergency: this.emergency.default,
      isTwoLine: false,
      isMarquee: this.isMarquee,
      availableWidth: this.availableWidth,
      hasSimCard: false,
    })
  }

  @Builder
  buildSinglesAndSkyToneCard(params: SingleCardParam) {
    Column() {
      // 天际通在前 正常运营商在后
      SingleOperatorInfo({
        operatorName: this.operatorInfo[2].simName,
        isTwoLine: true,
        isMarquee: this.isMarquee,
        availableWidth: this.availableWidth
      })
      SingleOperatorInfo({
        operatorName: params.isFirst ? this.operatorInfo[0].simName : this.operatorInfo[1].simName,
        isDomestic: params.isFirst ? this.operatorInfo[0].isDomestic : this.operatorInfo[1].isDomestic,
        emergency: params.isFirst ? this.emergency.cardOne : this.emergency.cardTwo,
        hdIconShow: this.isHdIconShow(params.isFirst),
        notVoiceIconShow: this.isNotVoiceIconShow(params.isFirst),
        voWifiIconShow: this.isVoWifiIconShow(params.isFirst),
        isTwoLine: true,
        isMarquee: this.isMarquee,
        availableWidth: this.availableWidth,
        hasSimCard: true,
      })
    }
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildOnlySkyTone() {
    SingleOperatorInfo({
      operatorName: this.operatorInfo[2].simName,
      isTwoLine: false,
      isMarquee: this.isMarquee,
      availableWidth: this.availableWidth
    })
  }

}

@Component
struct SingleOperatorInfo {
  @StorageLink('mCardSituation') @Watch('getShowName') cardSituation: CardSituation = CardSituation.NO_CARD;
  @Prop @Watch('getShowName') operatorName: string = STRING_NULL;
  @Prop isDomestic: boolean = false;
  @Prop @Watch('getShowName') emergency: number = Constants.REG_STATE_IN_SERVICE;
  @Prop hdIconShow: boolean = false;
  @Prop notVoiceIconShow: boolean = false;
  @Prop voWifiIconShow: boolean = false;
  @Prop isTwoLine: boolean = false;
  @Prop @Watch('getShowName') hasSimCard: boolean = false;
  @Prop needCheckMarquee: boolean = false;
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @State style: SignalComponentStyle = StyleConfiguration.getSignalComponentStyle();
  @Link availableWidth: number;
  @Link isMarquee: boolean;
  private context = GlobalContext.getContext();
  @Consume @Watch('onExcludeSlotListChange') excludeSlotList: string[];

  @State showName: string = '';

  /**
   * 内容颜色
   */
  @Consume contentColor: string;

  /**
   * 事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 当前语言
   */
  private language: string = '';

  /**
   * 是否可见
   */
  private pluginVisibility: boolean = false;

  aboutToAppear() {
    this.showName = this.getShowName();
    this.changeLanguage();
    log.showInfo(TAG, 'singleOperatorInfo aboutToAppear');
  }

  aboutToDisappear() {
    this.eventMgr.offAll();
    log.showInfo(TAG, 'singleOperatorInfo aboutToDisappear');
  }

  changeLanguage() {
    this.eventMgr.on(ConfigurationEvent, (configEvent: ConfigurationEvent) => {
      if (CommonUtils.isEmpty(this.language)) {
        this.language = configEvent.config?.language ?? '';
        this.getShowName();
        return;
      }
      // 语言切换，刷新字串
      let language = configEvent.config?.language;
      if (language && this.language != language) {
        this.language = language;
        this.getShowName();
      }
    });
  }

  private onExcludeSlotListChange(): void {
    log.showInfo(TAG, 'onExcludeSlotListChange');
    if (this.excludeSlotList.includes(PLUGIN_SLOT)) {
      this.pluginVisibility = false;
      return;
    }
    if (this.pluginVisibility === false) {
      this.showName = this.getShowName();
      log.showInfo(TAG, `update showName: ${this.showName}`);
      this.pluginVisibility = true;
    }
  }

  getShowName(): string {
    try {
      let showName = this.context?.resourceManager.getStringSync(NO_SERVICE.id);
      log.showInfo(TAG, `getShowName, emergency: ${this.emergency}, hasSimCard: ${this.hasSimCard}, cardSituation: ${this.cardSituation}`);
      // 无卡
      if (this.cardSituation === CardSituation.NO_CARD_EMPTY) {
        if (this.emergency === Constants.REG_STATE_EMERGENCY_CALL_ONLY) {
          showName = this.context?.resourceManager.getStringSync(NO_CARD_SOS_ONLY.id);
        }

        if (this.emergency === Constants.REG_STATE_NO_SERVICE || this.emergency === Constants.REG_STATE_POWER_OFF) {
          showName = this.context?.resourceManager.getStringSync(NO_CARD_NO_SERVICE.id);
        }
        this.showName = showName;
        return showName;
      }

      if (this.emergency === Constants.REG_STATE_IN_SERVICE && !isEmpty(this.operatorName)) {
        // 有服务且运营商名称有效 显示正常的运营商名称
        showName = this.operatorName;
      } else if (this.emergency === Constants.REG_STATE_NO_SERVICE ||
        this.emergency === Constants.REG_STATE_POWER_OFF) {
        showName = this.context?.resourceManager.getStringSync(NO_SERVICE.id);
      } else if (this.emergency === Constants.REG_STATE_EMERGENCY_CALL_ONLY) {
        // 紧急呼叫 区分是否有卡，分别显示 SOS_ONLY 和 NO_CARD_SOS_ONLY
        showName = this.context?.resourceManager.getStringSync(SOS_ONLY.id);
      }
      this.showName = showName;
      return showName;
    } catch (e) {
      log.showError(TAG, `get show name error`);
    }
    return '';
  }

  build() {
    Row() {
      if (this.isExceedingLength() && this.availableWidth) {
        if (this.isMarquee || this.isDomestic) {
          this.marqueeOperatorNameBuilder();
        } else {
          this.handleOperatorName();
        }
      } else {
        this.operatorText()
      }
      if (!isEmpty(this.operatorName) && this.emergency === Constants.REG_STATE_IN_SERVICE) {
        if (this.hdIconShow) {
          Image(!this.isTwoLine ? $r('app.media.ic_statusbar_signal_hd') : $r('app.media.ic_statusbar_signal_double_hd')).draggable(false)
            .id(COMPONENT_ID_HD)
            .width(!this.isTwoLine ? $r('app.float.signal_hd_icon_width') : $r('app.float.signal_hd_icon_width_two'))
            .height(!this.isTwoLine ? $r('app.float.signal_hd_icon_height') : $r('app.float.signal_hd_icon_height_two'))
            .fillColor(this.contentColor)
            .accessibilityGroup(AccessibilityVm.instance.isEnabled)
            .accessibilityLevel('yes')
            .accessibilityText(ICON_SHOW_NAME)
            .accessibilityRole(AccessibilityRoleType.TEXT)
        } else if (this.notVoiceIconShow) {
          Image($r('app.media.ic_statusbar_hd_warning')).draggable(false)
            .id(COMPONENT_ID_HD)
            .width(!this.isTwoLine ? $r('app.float.signal_hd_icon_width') : $r('app.float.signal_hd_icon_width_two'))
            .height(!this.isTwoLine ? $r('app.float.signal_hd_icon_height') : $r('app.float.signal_hd_icon_height_two'))
            .fillColor(this.contentColor)
        } else if (this.voWifiIconShow) {
          Image(!this.isTwoLine ? $r('app.media.ic_statusbar_vowifi') : $r('app.media.ic_statusbar_incall_double_vowifi')).draggable(false)
            .id(COMPONENT_ID_HD)
            .height(!this.isTwoLine ? $r('app.float.signal_hd_icon_height') : $r('app.float.signal_hd_icon_height_two'))
            .fillColor(this.contentColor)
        }
      }
    }
  }

  @Builder
  marqueeOperatorNameBuilder() {
    Marquee({
      start: true,
      loop: this.isDomestic ? -1 : Constants.OPERATOR_NAME_LOOP,
      step: Constants.OPERATOR_NAME_STEP,
      fromStart: true,
      src: this.showName
    })
      .fontColor(this.contentColor)
      .width(px2vp(this.getCurOperatorAvailableWidth()))
      .fontWeight(FONT_WEIGHT)
      .fontSize(!this.isTwoLine ?
      $r('app.float.signal_operator_font_size') : $r('app.float.signal_operator_font_size_two'))
      .onStart(() => {
        AppStorageUtil.setOrCreate('isMarqueeRunning', true, new DataProperty(true, false));
      })
      .onFinish(() => {
        this.isMarquee = false;
        AppStorageUtil.setOrCreate('isMarqueeRunning', false, new DataProperty(true, false));
      })
      .accessibilityGroup(AccessibilityVm.instance.isEnabled)
      .accessibilityLevel('yes')
      .accessibilityText(this.showName)
      .onDisAppear(() => {
        AppStorageUtil.setOrCreate('isMarqueeRunning', false, new DataProperty(true, false));
      })
  }

  @Builder
  operatorText() {
    Text() {
      Span(this.showName);
    }
    .wordBreak(WordBreak.BREAK_ALL)
    .draggable(false)
    .id(COMPONENT_ID_OPERATOR)
    .fontColor(this.contentColor)
    .fontWeight(FONT_WEIGHT)
    .textAlign(TextAlign.Start)
    .textOverflow({overflow: TextOverflow.None})
    .maxLines(Constants.OPERATOR_NAME_MAX_LINE)
    .fontSize(!this.isTwoLine ?
    $r('app.float.signal_operator_font_size') : $r('app.float.signal_operator_font_size_two'))
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.showName)
  }

  // 获取当前运营商名称在状态栏上的可用宽度(单位px)
  getCurOperatorAvailableWidth(): number {
    let availableWidth: number = this.availableWidth;
    // HD\通话不可用\VoWifi图标启用时 额外减去该图标长度
    if (this.hdIconShow || this.notVoiceIconShow || this.voWifiIconShow) {
      let iconWidth: Resource = !this.isTwoLine ? $r('app.float.signal_hd_icon_width') : $r('app.float.signal_hd_icon_width_two')
      availableWidth -= vp2px(ResUtils.getNumber(iconWidth));
      log.showInfo(TAG, `available width HD icon ${availableWidth}`)
    }

    if (SignalModel.getCutoutInfo()?.cutoutPosition === CutoutEvent.CUTOUT_MID) {
      // 在中挖孔条件下，需要减去4vp宽度。
      const reservedSpace: number = vp2px(4);
      if (availableWidth > reservedSpace) {
        availableWidth = availableWidth - reservedSpace;
      }
    }
    log.showInfo(TAG, `available width ${availableWidth}`)
    return availableWidth;
  }

  getMeasureTextWidth(target: string | Resource): number {
    let width: number = measure.measureText({
      textContent: target,
      fontSize: !this.isTwoLine ?
      $r('app.float.signal_operator_font_size') : $r('app.float.signal_operator_font_size_two'),
      fontWeight: FONT_WEIGHT,
    });
    return width;
  }

  /**
   * 判断运营商名称是否超长
   */
  isExceedingLength(): boolean {
    return this.getCurOperatorAvailableWidth() < this.getMeasureTextWidth(this.showName);
  }

  @Builder
  handleOperatorName() {
    Row() {
      Text() {
        Span(this.showName);
      }
      .wordBreak(WordBreak.BREAK_ALL)
      .draggable(false)
      .id(COMPONENT_ID_OPERATOR)
      .fontColor(this.contentColor)
      .width(px2vp(this.getCurOperatorAvailableWidth()))
      .textOverflow({overflow: TextOverflow.Ellipsis})
      .maxLines(Constants.OPERATOR_NAME_MAX_LINE)
      .fontWeight(FONT_WEIGHT)
      .textAlign(TextAlign.Start)
      .fontSize(!this.isTwoLine ?
      $r('app.float.signal_operator_font_size') : $r('app.float.signal_operator_font_size_two'))
      .transition(TransitionEffect.translate({ x:
        this.getOperatorTranslate(px2vp(this.getCurOperatorAvailableWidth())) })
        .animation({duration: Constants.OPERATOR_NAME_DURATION}));
    }
    .clip(true)
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.showName);
  }

  private getOperatorTranslate(translate: number): number {
    let isRTL: boolean = ResourceVm.instance.isTextRTL(this.showName);
    return isRTL ? -translate : translate;
  }
}

@Component
struct AirPlaneComponent {
  @Link isMarquee: boolean;
  @Prop availableWidth: number;
  @StorageLink('satelliteModeSwitch') satelliteModeSwitch: boolean = false;
  @StorageLink('mOperatorInfo') @Watch('checkIsSupport') operatorInfo: SimSpnInfo[] = [emptySim, emptySim, emptySim];
  @StorageLink('mImsState') @Watch('checkIsSupport') mIMSInfo: number[] = [Constants.IS_REGISTER, Constants.IS_REGISTER, Constants.IS_REGISTER];
  @State voWifiSupportSlotOne: string | undefined = undefined;
  @State voWifiSupportSlotTwo: string | undefined = undefined;
  @Prop airName: Resource = $r('app.string.air_plane_mode');
  @Consume @Watch('onExcludeSlotListChange') excludeSlotList: string[];
  /**
   * 内容颜色
   */
  @Consume contentColor: string;
  /**
   * 事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 当前语言
   */
  private language: string = '';

  /**
   * 是否可见
   */
  private pluginVisibility: boolean = false;

  aboutToAppear() {
    this.changeLanguage();
  }

  aboutToDisappear() {
    this.eventMgr.offAll();
    log.showInfo(TAG, 'airPlaneComponent aboutToDisappear');
  }
  changeLanguage() {
    this.eventMgr.on(ConfigurationEvent, (configEvent: ConfigurationEvent) => {
      if (CommonUtils.isEmpty(this.language)) {
        this.language = configEvent.config?.language ?? '';
        this.airName = $r('app.string.air_plane_mode');
        this.checkIsSupport();
        return;
      }
      // 语言切换，刷新字串
      let language = configEvent.config?.language;
      if (language && this.language != language) {
        this.language = language;
        this.airName = $r('app.string.air_plane_mode');
        this.checkIsSupport();
      }
    });
  }

  private onExcludeSlotListChange(): void {
    log.showInfo(TAG, 'onExcludeSlotListChange');
    if (this.excludeSlotList.includes(PLUGIN_SLOT)) {
      this.pluginVisibility = false;
      return;
    }
    if (this.pluginVisibility === false) {
      this.airName = $r('app.string.air_plane_mode');
      log.showInfo(TAG, `update airName: ${this.airName}`);
      this.pluginVisibility = true;
    }
  }

  private checkIsSupport(): void {
     if (this.mIMSInfo[SLOT_ONE] === Constants.IS_WLAN_REGISTER_TECH &&
        !CommonUtils.isEmpty(this.operatorInfo[SLOT_ONE].simName)) {
       this.voWifiSupportSlotOne = this.operatorInfo[SLOT_ONE].simName;
     } else {
       this.voWifiSupportSlotOne = undefined;
     }
    if (this.mIMSInfo[SLOT_TWO] === Constants.IS_WLAN_REGISTER_TECH &&
      !CommonUtils.isEmpty(this.operatorInfo[SLOT_TWO].simName)) {
      this.voWifiSupportSlotTwo = this.operatorInfo[SLOT_TWO].simName;
    } else {
      this.voWifiSupportSlotTwo = undefined;
    }
    log.showInfo(TAG, `checkVoWifiSupportCount ${this.voWifiSupportSlotOne === undefined}
    ${this.voWifiSupportSlotTwo === undefined}`)
  }


  @Builder
  showNameOneRow(param: ShowNameOneRowParam) {
    Row() {
      if (this.isExceededLimit(param.showName, param.isDoubleRow)) {
        if (this.isMarquee) {
          Marquee({
            start: true,
            loop: Constants.OPERATOR_NAME_LOOP,
            step: Constants.OPERATOR_NAME_STEP,
            fromStart: true,
            src: param.showName
          })
            .fontColor(this.contentColor)
            .width(px2vp(this.availableWidth))
            .fontWeight(FONT_WEIGHT)
            .fontSize(param.isDoubleRow ? $r('app.float.signal_operator_font_size_two') : $r('app.float.signal_operator_font_size'))
            .onFinish(() => {
              this.isMarquee = false;
            })
        } else {
          Row() {
            Text(param.showName)
              .wordBreak(WordBreak.BREAK_ALL)
              .draggable(false)
              .fontColor(this.contentColor)
              .width(px2vp(this.availableWidth))
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(Constants.OPERATOR_NAME_MAX_LINE)
              .fontWeight(FONT_WEIGHT)
              .textAlign(TextAlign.Start)
              .fontSize(param.isDoubleRow ? $r('app.float.signal_operator_font_size_two') : $r('app.float.signal_operator_font_size'))
              .transition(TransitionEffect.translate({ x: getTranslate(ResUtils.getNumber($r('app.float.signal_operator_width')))})
                .animation({ duration: Constants.OPERATOR_NAME_DURATION }))
          }.clip(true)
        }
      } else {
        Text(param.showName)
          .draggable(false)
          .fontColor(this.contentColor)
          .fontWeight(FONT_WEIGHT)
          .textAlign(TextAlign.Start)
          .fontSize(param.isDoubleRow ? $r('app.float.signal_operator_font_size_two') : $r('app.float.signal_operator_font_size'))
      }
      if (param.isShowVoWifiIcon) {
        Image(param.isDoubleRow ? $r('app.media.ic_statusbar_incall_double_vowifi') : $r('app.media.ic_statusbar_vowifi')).draggable(false)
          .id(COMPONENT_ID_HD)
          .height(param.isDoubleRow ? $r('app.float.signal_hd_icon_height_two') : $r('app.float.signal_hd_icon_height'))
          .fillColor(this.contentColor)
      }
    }
  }

  build() {
    Row() {
      if (this.voWifiSupportSlotTwo && this.voWifiSupportSlotOne){
        Column() {
          this.showNameOneRow({ showName: this.voWifiSupportSlotOne, isDoubleRow: true, isShowVoWifiIcon: true })
          this.showNameOneRow({ showName: this.voWifiSupportSlotTwo, isDoubleRow: true, isShowVoWifiIcon: true })
        }
        .alignItems(HorizontalAlign.Start)
      } else if (this.voWifiSupportSlotOne) {
        this.showNameOneRow({ showName: this.voWifiSupportSlotOne, isDoubleRow: false, isShowVoWifiIcon: true })
      } else if (this.voWifiSupportSlotTwo) {
        this.showNameOneRow({ showName: this.voWifiSupportSlotTwo, isDoubleRow: false, isShowVoWifiIcon: true })
      } else {
        this.showNameOneRow({ showName: ResUtils.getInnerString(this.airName),
          isDoubleRow: false, isShowVoWifiIcon: false });
      }
    }
    .id(TAG + '_AirPlaneComponent')
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }

  private getAccessibilityText(): string {
    const res = GlobalContext.getContext()?.resourceManager;
    return res.getStringByNameSync('air_plane_mode');
  }

  /**
   * Whether the limit is exceeded
   *
   * @param airPlaneMode 飞行模式
   * @returns  boolean
   */
  isExceededLimit(airPlaneMode: string, isDoubleRow: boolean): boolean {
    if ((!CommonUtils.isInvalid(airPlaneMode))) {
      let textWidth: number = measure.measureText({
        textContent: airPlaneMode,
        fontSize: isDoubleRow ? $r('app.float.signal_operator_font_size_two') : $r('app.float.signal_operator_font_size')
      })
      let limitLength: number = this.availableWidth;
      log.showInfo(TAG, `get airPlaneMode: limitLength : ${limitLength}, textWidth : ${textWidth}`);
      if (limitLength < textWidth) {
        return true;
      }
    }
    return false;
  }
}

function getAvailableWidth(orientation: number, displayWidth: number, leftPadding: string,
  rightPadding: string): number {
  // 获取运营商名称可用宽度
  let availableWidth: number = displayWidth;
  // 状态栏内容显示时左侧有一个 padding 需要排除该宽度
  let GROUP_ID_PRE: string = 'sbg';
  let xOffset: number = 0;
  if (leftPadding !== undefined && rightPadding !== undefined) {
    if (RTLUtil.isRTL()) {
      xOffset = vp2px(parseFloat(rightPadding)) * 2;
    } else {
      xOffset = vp2px(parseFloat(leftPadding)) * 2;
    }
  }
  log.showInfo(TAG, `xOffset:${xOffset} left:${leftPadding} right:${rightPadding}`);
  if (xOffset > availableWidth) {
    xOffset = DEFAULT_X_OFFSET; // 屏幕旋转等场景可能导致取到的xOffset值错误，此时用默认值12.
  }
  availableWidth -= xOffset;
  if (SignalModel.getCutoutInfo().cutoutRect && (SignalModel.getCutoutInfo().cutoutRect.top > 0)) {
    let cutRectWidth: number = vp2px(SignalModel.getCutoutInfo().cutoutRect.width);
    switch (SignalModel.getCutoutInfo().cutoutPosition) {
    // 以下 vp2px(2) 为UX设计的中线间隔2VP 这里使用px做计算，所以转换一下
      case CutoutEvent.CUTOUT_LEFT:
        if (LayoutUtils.isXTProductType() && SignalModel?.getCutoutInfo().cutoutRect?.left > STATUSBAR_MIN_LEFT_WIDTH) {
          availableWidth = getAvailableWidthForUltraScreen(displayWidth, leftPadding, rightPadding);
          log.showInfo(TAG, `available width left hole ${availableWidth}`);
          break;
        }
        // 左挖孔 挖孔会在 竖屏、横屏时占用状态栏宽度
        if (orientation === display.Orientation.LANDSCAPE || orientation === display.Orientation.PORTRAIT) {
          availableWidth = (availableWidth - cutRectWidth) / 2 - vp2px(2)
          log.showInfo(TAG, `available width left hole ${availableWidth}`)
          break;
        }
      case CutoutEvent.CUTOUT_RIGHT:
        // 右挖孔 挖孔会在 竖屏、反向横屏时占用状态栏宽度
        if (orientation === display.Orientation.LANDSCAPE_INVERTED || orientation === display.Orientation.PORTRAIT) {
          availableWidth = (availableWidth - cutRectWidth) / 2 - vp2px(2)
          log.showInfo(TAG, `available width right hole ${availableWidth}`)
          break;
        }
      case CutoutEvent.CUTOUT_MID:
        availableWidth = (availableWidth - cutRectWidth) / 2
        log.showInfo(TAG, `available width mid hole ${availableWidth}`)
        break;
      default:
        availableWidth = availableWidth / 2 - vp2px(2)
        log.showInfo(TAG, `available width normal ${availableWidth}`)
    }
  } else {
    // 无挖孔 和 刘海
    availableWidth = availableWidth / 2 - vp2px(2)
    log.showInfo(TAG, `available width default ${availableWidth}`)
  }
  return availableWidth;
}

function getTranslate(translate: number): number {
  return RTLUtil.isRTL() ? -translate : translate;
}

function getAvailableWidthForUltraScreen(displayWidth: number, leftPadding: string, rightPadding: string): number {
  let xOffsetLeft: number = leftPadding === undefined ? DEFAULT_X_OFFSET : vp2px(parseFloat(leftPadding));
  let xOffsetRight: number = rightPadding === undefined ? DEFAULT_X_OFFSET : vp2px(parseFloat(rightPadding));

  if (RTLUtil.isRTL()) {
    return displayWidth -
    vp2px(SignalModel.getCutoutInfo().cutoutRect.left + SignalModel.getCutoutInfo().cutoutRect.width) -
      xOffsetRight - vp2px(2);
  }
  return vp2px(SignalModel.getCutoutInfo().cutoutRect.left) - xOffsetLeft - vp2px(2);
}

class ShowNameOneRowParam {
  public showName: string = '';
  public isDoubleRow: boolean = false;
  public isShowVoWifiIcon: boolean = false;
}