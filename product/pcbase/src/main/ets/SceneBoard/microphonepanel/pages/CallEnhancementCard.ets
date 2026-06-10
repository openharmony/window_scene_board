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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import audio from '@ohos.multimedia.audio';
import systemDateTime from '@ohos.systemDateTime';
import { NormalPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import StyleConfiguration, { ClickableMenuStyle, SoundDeviceStyle } from '../common/StyleConfiguration';
import MicrophonePanelViewModel, { CurrentInputDeviceChangeForUIListener,
  InputCardItemProp,
  InputDevicesChangeForUIListener } from '../viewmodel/MicrophonePanelViewModel';
import AIAudioEffectSettingModel, { AIAudioEnhanceProp,
  callReinforceStatusChangeListener } from '../model/AIAudioEffectSettingModel';
import XmlParseUtil from '../util/XmlParseUtil';
import SettingsUtil from '../../soundpanel/util/SettingsUtil';
import Constants, { SettingsKeyConstants } from '../common/Constants';

const TAG = 'MicrophonePanel-CallEnhancementCard';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const COMPONENT_ID_DEVICE_ICON = TAG + '_Image_Icon';
const COMPONENT_ID_DEVICE_NAME = TAG + '_Text_deviceName';
const COMPONENT_ID_APP_BUNDLENAME = TAG + '_App_BundleName_';
const COMPONENT_ID_RADIO = TAG + '_checked_icon';

@Component
export default struct CallEnhancementCard {
  // setting for UI
  @State styleClickable: ClickableMenuStyle = StyleConfiguration.getClickableMenuStyle();
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Consume persistentId: number;
  @State isPNRSelected: boolean = false;
  @State isPNRHover: boolean = false;
  @State isAINRSelected: boolean = false;
  @State isAINRHover: boolean = false;
  @Consume isRTL: boolean;
  style: SoundDeviceStyle = StyleConfiguration.getSoundDeviceStyle();
  // settings for status
  // 静谧空间：PNR，纯净人声：AINR
  @StorageLink('MicrophonePanelCurrentPNREnable') isPNREnable: boolean = false;
  @StorageLink('MicrophonePanelCurrentAINREnable') isAINREnable: boolean = false;
  @State @Watch('currentInputAudioDeviceIndexChange') currentInputAudioDeviceIndex: number = Constants.DEFAULT_DEVICE_ID;
  @State isPNRAvailable: boolean = false;
  private currentInputAudioDevice: InputCardItemProp | undefined;
  private isSigned: boolean = false;

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
    this.initPrivacyAgreementListener();
    AIAudioEffectSettingModel.registerCallReinforceStatusChangeListener(this.callReinforceStatusChangeForUIListener);
    MicrophonePanelViewModel.registerStateChangeListener(this);
    MicrophonePanelViewModel.registerInputDevicesForUIListener(this.inputDevicesChangeForUIListener);
    MicrophonePanelViewModel.registerCurrentInputDeviceForUIListener(this.currentInputDeviceChangeForUIListener);
    this.currentInputAudioDeviceIndex = MicrophonePanelViewModel.getCurrentInputAudioDeviceIndex();
    this.currentInputAudioDeviceIndexChange();
  }

  aboutToDisappear() {
    log.showInfo(`${TAG} aboutToDisappear`);
    AIAudioEffectSettingModel.unregisterCallReinforceStatusChangeListener(this.callReinforceStatusChangeForUIListener);
    MicrophonePanelViewModel.unregisterStateChangeListener(this);
    MicrophonePanelViewModel.unregisterInputDevicesForUIListener(this.inputDevicesChangeForUIListener);
    MicrophonePanelViewModel.unregisterCurrentInputDeviceForUIListener(this.currentInputDeviceChangeForUIListener);
    SettingsUtil.unregisterKeyObserverSystem(SettingsKeyConstants.PRIVACY_AGREEMENT_SIGNED);
  }

  build() {
    Column() {
      this.singleCardItem();
      this.multipleCardItem();
    }
    .padding({ left: this.style.menuMarginLeftRight, right: this.style.menuMarginLeftRight})
    .width(Constants.CARD_WIDTH)
    .height(Constants.CARD_CALL_ENHANCEMENT_HEIGHT)
  }

  @Builder cardIcon(image: Resource, key: string) {
    Image(image)
      .draggable(false)
      .id(key)
      .objectFit(ImageFit.Contain)
      .width(this.style.imageWidth)
      .height(this.style.imageHeight)
      .fillColor(this.colorModeViewData.commonIconOffColor)
      .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
      .edgeAntialiasing(Constants.EDGEANTIALIASING_VALUE)
      .rotate({ y: 1, angle: this.isRTL ? 180 : 0 })
  }

  @Builder checkedIcon() {
    Image($r('app.media.ic_selected'))
      .draggable(false)
      .id(COMPONENT_ID_RADIO)
      .width(this.style.imageWidth)
      .height(this.style.imageHeight)
      .fillColor(this.panelInfo?.selectedListTextColor)
      .edgeAntialiasing(Constants.EDGEANTIALIASING_VALUE)
  }

  @Builder singleCardItem() {
    Row() {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        this.cardIcon($r('app.media.ic_single_space'), COMPONENT_ID_DEVICE_ICON + 'PNR');

        Text($r('app.string.single_quiet_space')).draggable(false)
          .id(COMPONENT_ID_DEVICE_NAME)
          .fontColor(this.isPNREnable ? this.panelInfo?.selectedListTextColor : this.colorModeViewData.wifiOffTextColor)
          .foregroundBrightness(this.isPNREnable ? undefined : this.colorModeViewData.foregroundPrimaryOption)
          .fontSize(this.panelInfo?.listTextSize)
          .fontWeight(FontWeight.Medium)
          .fontFamily('HarmonyHeiTi')
          .focusable(true)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({
            left: this.style.soundDeviceGap,
            right: this.style.soundDeviceGap
          })

        Blank()

        if (this.isPNREnable) {
          this.checkedIcon();
        }
      }
      .key(COMPONENT_ID_APP_BUNDLENAME)
      .backgroundColor(this.getSingleBackgroundColor())
      .height(this.styleClickable.stackHeight)
      .borderRadius(this.panelInfo?.hoverRadius)
      .padding({
        left: this.styleClickable.stackPadding,
        right: this.styleClickable.stackPadding
      })
      .onClick((event: ClickEvent): void => {
        this.onPNRClickEvent(event);
      })
      .onHover((isHover) => {
        this.isPNRHover = !!isHover;
      })
      .onTouch((event: TouchEvent): void => {
        if (event.type === TouchType.Down) {
          this.isPNRSelected = true;
        } else if (event.type === TouchType.Up) {
          this.isPNRSelected = false;
        }
      })
    }
    .justifyContent(FlexAlign.Center)
    .height(Constants.CARD_NOISE_HEIGHT)
    .borderRadius(this.panelInfo?.hoverRadius)
    .stateStyles({
      normal: this.normalStyles,
      focused: this.focusedStyles
    })
    .opacity(this.isPNRAvailable ? Constants.ENABLE_OPACITY : Constants.DISABLE_OPACITY)
    .enabled(this.isPNRAvailable)
  }

  @Builder multipleCardItem() {
    Row() {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        this.cardIcon($r('app.media.ic_multiplayer_vocal'), COMPONENT_ID_DEVICE_ICON + 'AINR');

        Text($r('app.string.multiplayer_pure_vocal')).draggable(false)
          .id(COMPONENT_ID_DEVICE_NAME)
          .fontColor(this.isAINREnable ?
            this.panelInfo?.selectedListTextColor : this.colorModeViewData.wifiOffTextColor)
          .foregroundBrightness(this.isAINREnable ? undefined : this.colorModeViewData.foregroundPrimaryOption)
          .fontSize(this.panelInfo?.listTextSize)
          .fontWeight(FontWeight.Medium)
          .fontFamily('HarmonyHeiTi')
          .focusable(true)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({
            left: this.style.soundDeviceGap,
            right: this.style.soundDeviceGap
          })

        Blank()

        if (this.isAINREnable) {
          this.checkedIcon();
        }
      }
      .key(COMPONENT_ID_APP_BUNDLENAME)
      .backgroundColor(this.getMultipleBackgroundColor())
      .height(this.styleClickable.stackHeight)
      .borderRadius(this.panelInfo?.hoverRadius)
      .margin({ top: Constants.MICROPHONE_SETTINGS_DEVICES_GAP })
      .padding({
        left: this.styleClickable.stackPadding,
        right: this.styleClickable.stackPadding
      })
      .onClick((event: ClickEvent): void => {
        this.onAINRClickEvent(event);
      })
      .onHover((isHover) => {
        this.isAINRHover = !!isHover;
      })
      .onTouch((event: TouchEvent): void => {
        if (event.type === TouchType.Down) {
          this.isAINRSelected = true;
        } else if (event.type === TouchType.Up) {
          this.isAINRSelected = false;
        }
      })
    }
    .justifyContent(FlexAlign.Center)
    .height(Constants.CARD_NOISE_HEIGHT)
    .borderRadius(this.panelInfo?.hoverRadius)
    .stateStyles({
      normal: this.normalStyles,
      focused: this.focusedStyles
    })
  }

  // 通话增强状态变更的监听回调
  private callReinforceStatusChangeForUIListener: callReinforceStatusChangeListener = {
    onCallReinforceStatusChange: (enhanceProp: string) => {
      if (enhanceProp === AIAudioEnhanceProp.ENHANCE_SINGLE) {
        this.isPNREnable = true;
        this.isAINREnable = false;
      } else if (enhanceProp === AIAudioEnhanceProp.ENHANCE_DEFAULT) {
        this.isPNREnable = false;
        this.isAINREnable = false;
      } else {
        this.isPNREnable = false;
        this.isAINREnable = true;
      }
    }
  };

  // 输入设备UI参数变更的监听回调
  private inputDevicesChangeForUIListener: InputDevicesChangeForUIListener = {
    onInputDevicesChangeForUI: (devices: InputCardItemProp[]) => {
      log.showInfo(`inputDevicesChangeForUIListener listen audioInputDevices change, length: ${devices.length}`);
      this.currentInputAudioDeviceIndexChange();
    }
  }

  // 输入焦点设备UI参数变更的监听回调
  private currentInputDeviceChangeForUIListener: CurrentInputDeviceChangeForUIListener = {
    onCurrentInputDeviceChangeForUI: (idex: number) => {
      this.currentInputAudioDeviceIndex = idex;
    }
  };

  private async currentInputAudioDeviceIndexChange(): Promise<void> {
    log.info(`currentInputAudioDevice Change, index: ${this.currentInputAudioDeviceIndex}`);
    let audioInputDevices = MicrophonePanelViewModel.getAudioInputDevices();
    let index = audioInputDevices.findIndex((inputDevice) => {
      return inputDevice.deviceIndex === this.currentInputAudioDeviceIndex;
    });
    if (index === -1) {
      this.isPNREnable = false;
      this.isAINREnable = false;
      this.isPNRAvailable = false;
      this.currentInputAudioDevice = undefined;
      return;
    }
    this.currentInputAudioDevice = audioInputDevices[index];
    log.info(`currentInputAudioDevice Change, info: ` +
      `${this.currentInputAudioDevice.type} - ${this.currentInputAudioDevice.title}`);
    this.judgeSingleEnable();
    const key: string = SettingsKeyConstants.SOUND_USER_SELECTIONS + this.currentInputAudioDevice.type;
    const userSelect: string = await SettingsUtil.getSystemValue(key, Constants.CALL_REINFORCE_USER_SELECTION_MULTIPLE);
    this.judgeReinforceCallStatus(userSelect);
  }

  private judgeSingleEnable(): void {
    if (this.currentInputAudioDevice) {
      if (this.isWired(this.currentInputAudioDevice.type) ||
        (this.isBluetooth(this.currentInputAudioDevice.type) &&
        XmlParseUtil.getDeviceSupport(this.currentInputAudioDevice.title))) {
        this.isPNRAvailable = true;
      } else {
        this.isPNRAvailable = false;
      }
    }
  }

  private isWired(deviceType: number): boolean {
    return deviceType === audio.DeviceType.USB_HEADSET ||
      deviceType === audio.DeviceType.WIRED_HEADSET ||
      deviceType === audio.DeviceType.WIRED_HEADPHONES;
  }

  private isBluetooth(deviceType: number): boolean {
    return deviceType === audio.DeviceType.BLUETOOTH_SCO ||
      deviceType === audio.DeviceType.BLUETOOTH_A2DP;
  }

  private judgeReinforceCallStatus(userSelect: string): void {
    if (userSelect === Constants.CALL_REINFORCE_USER_SELECTION_SINGLE) {
      if (this.isPNRAvailable) {
        this.isPNREnable = true;
        this.isAINREnable = false;
      }
    } else if (userSelect == Constants.CALL_REINFORCE_USER_SELECTION_DEFAULT) {
      this.isPNREnable = false;
      this.isAINREnable = false;
    } else if (userSelect == Constants.CALL_REINFORCE_USER_SELECTION_MULTIPLE) {
      this.isPNREnable = false;
      this.isAINREnable = true;
    } else {
      if (this.isSigned && this.isPNRAvailable) {
        this.isPNREnable = true;
        this.isAINREnable = false;
      } else {
        this.isPNREnable = false;
        this.isAINREnable = true;
      }
    }
  }

  private async initPrivacyAgreementListener(): Promise<void> {
    if (await this.getPrivacyAgreementStatus()) {
      this.isSigned = true;
      log.info(`agreement is signed`);
      return;
    }
    try {
      SettingsUtil.registerKeyObserverSystem(SettingsKeyConstants.PRIVACY_AGREEMENT_SIGNED, async () => {
        this.isSigned = await this.getPrivacyAgreementStatus();
        log.info(`signed status: ${this.isSigned}, isPNRAvailable: ${this.isPNRAvailable}`);
        if (this.isSigned && this.isPNRAvailable) {
          this.isPNREnable = true;
          this.isAINREnable = false;
          this.doSavaSelection(Constants.CALL_REINFORCE_USER_SELECTION_SINGLE);
          AIAudioEffectSettingModel.setCallReinforceStatus(AIAudioEnhanceProp.ENHANCE_SINGLE);
        }
      });
    } catch (e) {
      log.error(`SoundAIEffectListener regStatus fail`);
    }
  }

  private async getPrivacyAgreementStatus(): Promise<boolean> {
    return await SettingsUtil.getSystemValue(SettingsKeyConstants.PRIVACY_AGREEMENT_SIGNED, '') ===
    Constants.VOLUME_PRIVACY_AGREEMENT_AGREE;
  }

  private getSingleBackgroundColor(): ResourceColor {
    if (this.isPNRSelected) {
      return this.styleClickable.stackBgColorSelected;
    }
   if (this.isPNRHover) {
     return this.styleClickable.stackBgColorHover;
   }
    return this.styleClickable.stackBgColorUnSelected;
  }

  private getMultipleBackgroundColor(): ResourceColor {
    if (this.isAINRSelected) {
      return this.styleClickable.stackBgColorSelected;
    }
    if (this.isAINRHover) {
      return this.styleClickable.stackBgColorHover;
    }
    return this.styleClickable.stackBgColorUnSelected;
  }

  private onPNRClickEvent(event: ClickEvent) {
    if (this.isPNREnable) {
      this.doSavaSelection(Constants.CALL_REINFORCE_USER_SELECTION_DEFAULT);
      AIAudioEffectSettingModel.setCallReinforceStatus(AIAudioEnhanceProp.ENHANCE_DEFAULT);
    } else {
      if (this.isSigned) {
        this.isAINREnable = false;
        this.doSavaSelection(Constants.CALL_REINFORCE_USER_SELECTION_SINGLE);
        AIAudioEffectSettingModel.setCallReinforceStatus(AIAudioEnhanceProp.ENHANCE_SINGLE);
      } else {
        this.onShowPermissionAbility();
        return;
      }
    }
    this.isPNREnable = !this.isPNREnable;
  }

  private onAINRClickEvent(event: ClickEvent) {
    if (this.isAINREnable) {
      this.doSavaSelection(Constants.CALL_REINFORCE_USER_SELECTION_DEFAULT);
      AIAudioEffectSettingModel.setCallReinforceStatus(AIAudioEnhanceProp.ENHANCE_DEFAULT);
    } else {
      this.isPNREnable = false;
      this.doSavaSelection(Constants.CALL_REINFORCE_USER_SELECTION_MULTIPLE);
      AIAudioEffectSettingModel.setCallReinforceStatus(AIAudioEnhanceProp.ENHANCE_MULTIPLE);
    }
    this.isAINREnable = !this.isAINREnable;
  }

  private doSavaSelection(status: string): void {
    log.info(`do sava user selection ${this.currentInputAudioDevice?.type} - ${status}`);
    if (this.currentInputAudioDevice) {
      let key: string = SettingsKeyConstants.SOUND_USER_SELECTIONS + this.currentInputAudioDevice.type;
      SettingsUtil.setSystemValue(key, status);
    }
  }

  private async onShowPermissionAbility(): Promise<void> {
    try {
      // 发布公共事件
      let res: string = await SettingsUtil.getSystemValue(SettingsKeyConstants.PRIVACY_AGREEMENT_DIALOG_EJECTS,
        Constants.VOLUME_PRIVACY_AGREEMENT_DISAGREE);
      let num = Number(res);
      log.info(`try call up privacy agreement dialog count: ${num}`);
      SettingsUtil.setSystemValue(SettingsKeyConstants.PRIVACY_AGREEMENT_DIALOG_EJECTS, '' + (++num));
      SettingsUtil.setSystemValue(SettingsKeyConstants.PRIVACY_AGREEMENT_TRIGGER_TIME,
        systemDateTime.getTime(false).toString());
    } catch (e) {
      log.error(`show PermissionAbility fail`);
    }
  }

  private reset(): void {
    this.isPNRSelected = false;
    this.isPNRHover = false;
    this.isAINRSelected = false;
    this.isAINRHover = false;
  }

  onStateChange(panelState: boolean): void {
    log.showInfo(`onStateChange panelState: ${panelState}`);
    if (!panelState) {
      this.reset();
    }
  }
}
