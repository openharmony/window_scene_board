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
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import { NormalPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import AIAudioEffectSettingModel, { AIAudioEnhanceProp,
  enhanceNoiseReductStatusChangeListener} from '../model/AIAudioEffectSettingModel';
import MicrophonePanelViewModel, {
  AppCapturerCardItemProp,
  AppCapturerCardItemsForUIListener } from '../viewmodel/MicrophonePanelViewModel';
import StyleConfiguration, { ClickableMenuStyle, SoundDeviceStyle } from '../common/StyleConfiguration';
import Constants from '../common/Constants';

const TAG = 'MicrophonePanel-RecordNoiseReductionCard';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const COMPONENT_ID_DEVICE_NAME = TAG + '_text_recordName';
const COMPONENT_ID_APP_BUNDLENAME = TAG + '_card_record';

@Component
export default struct RecordNoiseReductionCard {
  // setting for UI
  @State styleClickable: ClickableMenuStyle = StyleConfiguration.getClickableMenuStyle();
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Consume persistentId: number;
  @State isSelected: boolean = false;
  @State isHover: boolean = false;
  style: SoundDeviceStyle = StyleConfiguration.getSoundDeviceStyle();
  // settings for status
  @StorageLink('MicrophonePanelCurrentRecordNoiseReductEnable') isReductNow: boolean = false;
  @State isExistCapturer: boolean = false;

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
    this.isReductNow = AIAudioEffectSettingModel.getEnhanceNoiseReductStatus() === AIAudioEnhanceProp.NOISE_REDUCT_ON;
    AIAudioEffectSettingModel
      .registerEnhanceNoiseReductStatusChangeListener(this.enhanceNoiseReductStatusChangeListener);
    MicrophonePanelViewModel.registerStateChangeListener(this);
    MicrophonePanelViewModel.registerCapturerInfoArrayForUIListener(this.appCapturerCardItemsForUIListener);
  }

  aboutToDisappear() {
    log.showInfo(`${TAG} aboutToDisappear`);
    AIAudioEffectSettingModel
      .unregisterEnhanceNoiseReductStatusChangeListener(this.enhanceNoiseReductStatusChangeListener);
    MicrophonePanelViewModel.unregisterStateChangeListener(this);
    MicrophonePanelViewModel.unregisterCapturerInfoArrayForUIListener(this.appCapturerCardItemsForUIListener);
  }

  build() {
    Column() {
      Row() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
          Text(this.isReductNow ?
          $r('app.string.record_noise_reduct_off') : $r('app.string.record_noise_reduct_on')).draggable(false)
            .id(COMPONENT_ID_DEVICE_NAME)
            .fontColor(this.colorModeViewData.wifiOffTextColor)
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .fontSize(this.panelInfo?.listTextSize)
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .focusable(true)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({
              left: Constants.MICROPHONE_SETTINGS_HORIZONTAL_MARGIN,
              right: Constants.MICROPHONE_SETTINGS_HORIZONTAL_MARGIN
            })
        }
        .key(COMPONENT_ID_APP_BUNDLENAME)
        .backgroundColor(this.getSingleBackgroundColor())
        .height(this.styleClickable.stackHeight)
        .borderRadius(this.panelInfo?.hoverRadius)
        .onClick((event: ClickEvent): void => {
          this.onClickEvent(event);
        })
        .onHover((isHover) => {
          this.isHover = !!isHover;
        })
        .onTouch((event: TouchEvent): void => {
          if (event.type === TouchType.Down) {
            this.isSelected = true;
          } else if (event.type === TouchType.Up) {
            this.isSelected = false;
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
      .opacity(this.isExistCapturer ? Constants.DISABLE_OPACITY : Constants.ENABLE_OPACITY)
      .enabled(!this.isExistCapturer)
    }
    .padding({ left: this.style.menuMarginLeftRight, right: this.style.menuMarginLeftRight})
    .width(Constants.CARD_WIDTH)
    .height(Constants.CARD_NOISE_HEIGHT)

  }

  // 通话增强状态变更的监听回调
  private enhanceNoiseReductStatusChangeListener: enhanceNoiseReductStatusChangeListener = {
    onEnhanceNoiseReductStatusChange: (enhanceProp: string) => {
      if (enhanceProp === AIAudioEnhanceProp.NOISE_REDUCT_ON) {
        this.isReductNow = true;
      } else {
        this.isReductNow = false;
      }
    }
  };

  // 输入焦点设备UI参数变更的监听回调
  private appCapturerCardItemsForUIListener: AppCapturerCardItemsForUIListener = {
    onCapturerInfoArrayForUI: (appCapturerCardItems: AppCapturerCardItemProp[]) => {
      this.isExistCapturer = appCapturerCardItems.length !== 0;
    }
  };

  private getSingleBackgroundColor(): ResourceColor {
    if (this.isSelected) {
      return this.styleClickable.stackBgColorSelected;
    }
   if (this.isHover) {
     return this.styleClickable.stackBgColorHover;
   }
    return this.styleClickable.stackBgColorUnSelected;
  }

  private onClickEvent(event: ClickEvent) {
    if (this.isReductNow) {
      AIAudioEffectSettingModel.setEnhanceNoiseReductStatus(AIAudioEnhanceProp.NOISE_REDUCT_OFF);
    } else {
      AIAudioEffectSettingModel.setEnhanceNoiseReductStatus(AIAudioEnhanceProp.NOISE_REDUCT_ON);
    }
    this.isReductNow = !this.isReductNow;
  }

  private reset(): void {
    this.isSelected = false;
    this.isHover = false;
  }

  onStateChange(panelState: boolean): void {
    log.showInfo(`onStateChange panelState: ${panelState}`);
    if (!panelState) {
      this.reset();
    }
  }
}
