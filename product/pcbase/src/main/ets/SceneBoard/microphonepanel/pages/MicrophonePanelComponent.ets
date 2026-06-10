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
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  DeviceHelper,
  HiSysEventUtil,
  PluginSlot,
  EvtBus,
  PluginPosition,
  WindowPositionChangeEvent,
} from '@ohos/frameworkwrapper';
import { windowMgr, StartAbilityUtil } from '@ohos/windowscene';
import { ExtAppConstants } from '@ohos/commonconstants';
import window from '@ohos.window';
import i18n from '@ohos.i18n';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import StyleConfiguration, { ClickableMenuStyle,
  MicrophonePanelComponentStyle } from '../common/StyleConfiguration';
import { NormalPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import MicrophonePanelViewModel, {
  AppCapturerCardItemProp,
  AppCapturerCardItemsForUIListener,
  InputCardItemProp, InputDevicesChangeForUIListener } from '../viewmodel/MicrophonePanelViewModel';
import Constants from '../common/Constants';
import InputDevice from './InputDevice';
import XmlParseUtil from '../util/XmlParseUtil';
import AppCapturerCardItem from './AppCapturerCardItem';
import RecordNoiseReductionCard from './RecordNoiseReductionCard';
import CallEnhancementCard from './CallEnhancementCard';

const TAG = 'microphonePanel-microphonePanelComponent';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const MORE_KEY = 'h1_systemUI_product_pc_microphonePanelComponents_more';
const COMPONENT_ID_TEXT_USING = TAG + '_text_using';
const COMPONENT_ID_TEXT_INPUT = TAG + '_text_intput';
const COMPONENT_ID_TEXT_AI = TAG + '_text_ai';
const COMPONENT_ID_MORE = TAG + '_text_settings';
const KEYBOARD = 4;
/**
 * 窗口名
 */
const WINDOW_NAME = PluginSlot.SLOT_STATUS_MICROPHONE_PANEL;

@Component
export default struct microphonePanelComponent {
  // settings for UI
  @State styleClickable: ClickableMenuStyle = StyleConfiguration.getClickableMenuStyle();
  @Consume persistentId: number;
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @State isSelected: boolean = false;
  @State isHover: boolean = false;
  @Provide isRTL: boolean = false;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Consume mHeight: number;
  private eventType: string = HiSysEventUtil.TOUCH_EVENT;
  private isHad: boolean = DeviceHelper.isHAD();
  style: MicrophonePanelComponentStyle = StyleConfiguration.getMicrophonePanelComponentStyle();
  // settings for status
  @State audioInputDevices: InputCardItemProp[] = [];
  @State appCapturerCardItems: AppCapturerCardItemProp[] = [];

  @Styles normalStyles() {
    .border( {
      width: '2vp',
      color: '#00000000'
    })
  }

  @Styles focusedStyles() {
    .border( {
      width: '2vp',
      color: '#ff0a59f7'
    })
  }

  aboutToAppear() {
    log.showInfo(`${TAG} aboutToAppear`);
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    MicrophonePanelViewModel.registerStateChangeListener(this);
    MicrophonePanelViewModel.registerInputDevicesForUIListener(this.inputDevicesChangeForUIListener);
    this.audioInputDevices = MicrophonePanelViewModel.getAudioInputDevices();
    MicrophonePanelViewModel.registerCapturerInfoArrayForUIListener(this.appCapturerChangeForUIListener);
    this.appCapturerCardItems = MicrophonePanelViewModel.getAppCapturerCardItems();
    this.updateWindowPosition();
  }

  aboutToDisappear() {
    log.showInfo(`microphonePanelComponent, aboutToDisAppear`);
    MicrophonePanelViewModel.unregisterStateChangeListener(this);
    MicrophonePanelViewModel.unregisterInputDevicesForUIListener(this.inputDevicesChangeForUIListener);
    MicrophonePanelViewModel.unregisterCapturerInfoArrayForUIListener(this.appCapturerChangeForUIListener);
    this.reset();
  }

  // 输入设备UI参数变更的监听回调
  private inputDevicesChangeForUIListener: InputDevicesChangeForUIListener = {
    onInputDevicesChangeForUI: (devices: InputCardItemProp[]) => {
      log.showInfo(`inputDevicesChangeForUIListener listen audioInputDevices change, length: ${devices.length}`);
      this.audioInputDevices = devices;
      this.updateWindowPosition();
    }
  }

  // 应用Capturer使用UI参数变更的监听回调
  private appCapturerChangeForUIListener: AppCapturerCardItemsForUIListener = {
    onCapturerInfoArrayForUI: (appCapturerCardItems: AppCapturerCardItemProp[]) => {
      log.showInfo(`appCapturerChangeForUIListener listen length: ${appCapturerCardItems.length}`);
      this.appCapturerCardItems = appCapturerCardItems;
      this.updateWindowPosition();
    }
  }

  updateWindowPosition(): void {
    let defaultRect = windowMgr.getWindowPosition(WINDOW_NAME);
    let height = this.isHad ? Constants.HAD_WINDOW_HEIGHT : Constants.WINDOW_HEIGHT;
    let appCapturerCardHeight = Constants.CARD_DEFAULT_HEIGHT;
    if (this.appCapturerCardItems.length > 0) {
      appCapturerCardHeight = Constants.CARD_HEIGHT +
        (this.appCapturerCardItems.length - 1) * Constants.CARD_MORE_HEIGHT;
    }
    let inputDevicesHeight = Constants.CARD_DEFAULT_HEIGHT;
    if (this.audioInputDevices.length > 0) {
      inputDevicesHeight = Constants.CARD_HEIGHT + (this.audioInputDevices.length - 1) * Constants.CARD_MORE_HEIGHT;
    }
    const callReinforceSupport = XmlParseUtil.getCallReinforceSupport();
    const recordReductSupport = XmlParseUtil.getRecordNoiseReductforceSupport();
    let aiEffectTitleHeight =
      callReinforceSupport || recordReductSupport ? Constants.TITLE_HEIGHT : Constants.CARD_DEFAULT_HEIGHT;
    let callEnhancementCardHeight = callReinforceSupport && recordReductSupport ? Constants.CARD_CALL_HEIGHT :
      callReinforceSupport ? Constants.CARD_CALL_DEFAULT_HEIGHT : Constants.CARD_DEFAULT_HEIGHT;
    let recordNoiseReductionCardHeight =
      recordReductSupport ? Constants.CARD_NOISE_HEIGHT : Constants.CARD_DEFAULT_HEIGHT;
    height = height + appCapturerCardHeight + inputDevicesHeight + aiEffectTitleHeight +
      callEnhancementCardHeight + recordNoiseReductionCardHeight;
    let heightWin = vp2px(height);
    this.mHeight = height;
    let updateRect: window.Rect = {
      top: defaultRect.top,
      left: defaultRect.left,
      width: defaultRect.width,
      height: heightWin
    };
    log.showInfo(`${TAG} MicrophonePanelHeightChange, height: ${heightWin}, updateRect: ${JSON.stringify(updateRect)}`);
    EvtBus.post(WindowPositionChangeEvent, { windowName: WINDOW_NAME,
      position: PluginPosition.POSITION_RIGHT, area: updateRect });
  }

  @Builder MyDivider(marginLeft: Length = this.style.microphonePanelMarginLeft, key: string = '') {
    Divider()
      .strokeWidth(1)
      .color(this.panelInfo?.separatorColor)
      .key(`${TAG}_${key}`)
      .margin({
        left: marginLeft,
        right: this.style.microphonePanelMarginRight,
        top: this.style.microphonePanelDividerMarginTop,
        bottom: this.style.microphonePanelDividerMarginTop
      })
  }

  @Builder MyText(title: ResourceStr, id: string) {
    Row() {
      Text(title).draggable(false)
        .id(id)
        .fontColor(this.colorModeViewData.wifiOffTextColor)
        .foregroundBrightness(this.colorModeViewData.foregroundTertiaryGlossOption)
        .fontSize(this.panelInfo?.subTitleTextSize)
        .fontWeight(FontWeight.Regular)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .alignItems(VerticalAlign.Center)
    .height(this.style.microphonePanelTextUsingHeight)
    .padding({
      left: this.style.microphonePanelPaddingLeft,
      right: this.style.microphonePanelPaddingRight
    })
  }

  build() {
    Column() {

      if (this.appCapturerCardItems.length > 0) {
        this.MyText($r('app.string.microphone_using'), COMPONENT_ID_TEXT_USING);

        Column({ space: Constants.MICROPHONE_SETTINGS_DEVICES_GAP }) {
          ForEach(this.appCapturerCardItems, (item: AppCapturerCardItemProp) => {
            AppCapturerCardItem({
              mBundleName: item.bundleName,
              mAppName: item.appName,
              mIcon: item.icon
            })
          });
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .height(Constants.CARD_NOISE_HEIGHT + (this.appCapturerCardItems.length - 1) * Constants.CARD_MORE_HEIGHT)

        this.MyDivider(this.style.microphonePanelMarginLeft, 'First_Divider');
      }

      if (this.audioInputDevices.length > 0) {
        this.MyText($r('app.string.microphone_input'), COMPONENT_ID_TEXT_INPUT);
        Column({ space: Constants.MICROPHONE_SETTINGS_DEVICES_GAP }) {
          ForEach(this.audioInputDevices, (item: InputCardItemProp) => {
            InputDevice({
              mDeviceType: item.type,
              mDeviceName: item.title,
              mDeviceIndex: item.viewIndex,
              mDeviceAddress: item.address
            })
          });
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .height(Constants.CARD_NOISE_HEIGHT + (this.audioInputDevices.length - 1) * Constants.CARD_MORE_HEIGHT)

        this.MyDivider(this.style.microphonePanelMarginLeft, 'Second_Divider')
      }

      if (XmlParseUtil.getCallReinforceSupport() || XmlParseUtil.getRecordNoiseReductforceSupport()) {
        this.MyText(XmlParseUtil.getLogSupport() ?
        $r('app.string.sound') : $r('app.string.ai_sound'), COMPONENT_ID_TEXT_AI);
      }

      if (XmlParseUtil.getCallReinforceSupport()) {
        CallEnhancementCard();

        this.MyDivider(this.style.microphonePanelMarginLeft, 'Third_Divider');
      }

      if (XmlParseUtil.getRecordNoiseReductforceSupport()) {
        RecordNoiseReductionCard();
      }

      this.MyDivider(this.style.microphonePanelMarginLeft, 'Fourth_Divider');

      Row() {
        Row() {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
            Text($r('app.string.microphone_settings'))
              .draggable(false)
              .id(COMPONENT_ID_MORE)
              .fontColor(this.colorModeViewData.wifiOffTextColor)
              .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
              .fontSize(this.panelInfo?.footnoteTextSize)
              .fontWeight(FontWeight.Medium)
              .fontFamily('HarmonyHeiTi')
              .focusable(true)
              .margin({
                left: Constants.MICROPHONE_SETTINGS_HORIZONTAL_MARGIN,
                right: Constants.MICROPHONE_SETTINGS_HORIZONTAL_MARGIN
              })
          }
          .height(Constants.CARD_NOISE_HEIGHT)
          .borderRadius(this.panelInfo?.hoverRadius)
          .backgroundColor(this.getBackgroundColor())
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
        }
        .height(Constants.CARD_NOISE_HEIGHT)
        .width(Constants.CARD_WIDTH)
        .borderRadius(this.panelInfo?.hoverRadius)
        .stateStyles({
          normal: this.normalStyles,
          focused: this.focusedStyles
        })
      }.key(MORE_KEY)
      .padding({ left: this.style.microphonePanelBetweenSize, right: this.style.microphonePanelBetweenSize})
      .height(Constants.CARD_NOISE_HEIGHT)
      .width(Constants.CARD_WIDTH)
      .margin({ bottom: this.style.microphonePanelDividerMarginTop })
    }
    .alignItems(HorizontalAlign.Start)
    .width(Constants.CARD_WIDTH)
    .onDisAppear(() => {
      this.reset();
    })
  }

  private onTouchEvent(event: TouchEvent) {
    log.showInfo(`onTouchEvent, event: ${JSON.stringify(event)}`);
    if (event.type == TouchType.Down) {
      this.isSelected = true;
      this.eventType = HiSysEventUtil.TOUCH_EVENT;
    } else if (event.type == TouchType.Up) {
      this.isSelected = false;
    }
    if (event.stopPropagation) {
      event.stopPropagation();
    }
  }

  private onClickEvent(event: ClickEvent) {
    log.showInfo(`onSingleClickEvent, event: ${JSON.stringify(event)}`);

    if (event.source === KEYBOARD) {
      this.eventType = HiSysEventUtil.SHORTCUT_EVENT;
    }
    this.execClickAction();
  }

  private execClickAction() {
    HiSysEventUtil.reportSoundMenu(HiSysEventUtil.CLICK_MORE, this.eventType);
    // 点击跳转页面，隐藏面板
    let parameters: Record<string, string> = {
      'subUri' : 'audio_input_tab'
    }
    windowMgr.hideWindowWithAnim(WINDOW_NAME);
    const is2In1Pc: boolean = DeviceHelper.is2In1DevicePcType();
    StartAbilityUtil.startAbilityFromOther({
      bundleName: ExtAppConstants.PKG_PC_SETTINGS,
      abilityName: ExtAppConstants.ABILITY_PC_SETTINGS_AUDIO,
      uri: is2In1Pc ? 'volume_settings' : 'pc_audio_settings',
      moduleName: is2In1Pc ? 'phone_settings' : 'pc_settings',
      parameters: parameters
    });
  }

  private getBackgroundColor(): ResourceColor {
    if (this.isSelected) {
      return this.styleClickable.stackBgColorSelected;
    }
    if (this.isHover) {
      return this.styleClickable.stackBgColorHover;
    }
    return this.styleClickable.stackBgColorUnSelected;
  }

  private updateLanguageRTL(): void {
    try {
      const systemLanguage: string = i18n.System.getSystemLanguage();
      this.isRTL = !!i18n.isRTL(systemLanguage);
    } catch (e) {
      log.showError(`updateLanguageRTL getSystemLanguage error: ${e?.message}`);
    }
  }

  private reset() {
    this.isSelected = false;
    this.isHover = false;
  }

  onStateChange(panelState: boolean) {
    log.showInfo(`onStateChange panelState: ${panelState}`);
    if (panelState) {
      this.updateLanguageRTL();
    } else {
      this.reset();
    }
  }
}
