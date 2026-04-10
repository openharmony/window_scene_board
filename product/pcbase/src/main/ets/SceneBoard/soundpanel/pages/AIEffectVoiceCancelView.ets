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

import { LogDomain, Logger } from '@ohos/basicutils';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import StyleConfiguration, { ClickableMenuStyle, SoundDeviceStyle } from '../common/StyleConfiguration';
import audioEffectSettingModel,
{ AIAudioEffectProp, voiceCancelStatusChangeListener } from '../../microphonepanel/model/AIAudioEffectSettingModel';
import { HorizontalCardComponent } from './HorizontalCardComponent';

const TAG = 'SoundPanel-AIEffectVoiceCancelView';
const log = Logger.getLogHelper(LogDomain.SCB);

@Component
export default struct AIEffectVoiceCancelView {
  @State isVocalCancelNow: boolean = false;
  @State isVocalExtractNow: boolean = false;
  @State style: SoundDeviceStyle = StyleConfiguration.getSoundDeviceStyle();
  @State styleClickable: ClickableMenuStyle = StyleConfiguration.getClickableMenuStyle();
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  build() {
    Column() {
      HorizontalCardComponent({
        title: $r('app.string.voice_cancel'),
        isChecked: this.isVocalCancelNow,
        imageHeader: () => {
          this.effectImageHeader(true);
        },
        clickFunc: () => this.vocalCancelClickFunc()
      })
      Column() {}
      .height($r('app.float.sound_slider_bar_margin_left'))
      HorizontalCardComponent({
        title: $r('app.string.voice_extract'),
        isChecked: this.isVocalExtractNow,
        imageHeader: () => {
          this.effectImageHeader(false);
        },
        clickFunc: () => this.vocalExtractClickFunc()
      })
    }
    .width('100%')
  }

  @Builder effectImageHeader(isVocalCancel: boolean) {
    Image(isVocalCancel ? $r('app.media.ic_pc_voice_cancel') : $r('app.media.ic_pc_voice_booster'))
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.style.imageWidth)
      .height(this.style.imageHeight)
      .fillColor(this.colorModeViewData.commonIconOffColor)
      .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
      .edgeAntialiasing(0.4)
      .matchTextDirection(true)
  }

  aboutToAppear(): void {
    const effectProp: string = audioEffectSettingModel.getVoiceCancelStatus();
    log.showInfo(TAG, `aboutToAppear, effectProp: ${effectProp}`);
    this.refreshVoiceCancelStatus(effectProp);
    audioEffectSettingModel.registerVoiceCancelStatusChangeListener(this.voiceCancelStatusChangeListener);
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, `aboutToDisappear`);
    audioEffectSettingModel.unregisterVoiceCancelStatusChangeListener(this.voiceCancelStatusChangeListener);
  }

  private voiceCancelStatusChangeListener: voiceCancelStatusChangeListener = {
    onVoiceCancelStatusChange: (effectProp: string) => {
      log.showInfo(TAG, `voiceCancelStatusChangeListener onVoiceCancelStatusChange effectProp: ${effectProp}`);
      this.refreshVoiceCancelStatus(effectProp);
    }
  }

  private refreshVoiceCancelStatus(effectProp: string): void {
    if (effectProp === AIAudioEffectProp.EFFECT_CANCEL) {
      this.isVocalCancelNow = true;
      this.isVocalExtractNow = false;
    } else if (effectProp === AIAudioEffectProp.EFFECT_EXTRACT) {
      this.isVocalCancelNow = false;
      this.isVocalExtractNow = true;
    } else {
      this.isVocalCancelNow = false;
      this.isVocalExtractNow = false;
    }
  }

  private vocalCancelClickFunc(): void {
    this.isVocalCancelNow = !this.isVocalCancelNow;
    if (this.isVocalCancelNow) {
      this.doVoiceCancelEnable();
      this.isVocalExtractNow = false;
    } else {
      this.doVoiceDisable();
    }
  }

  private vocalExtractClickFunc(): void {
    this.isVocalExtractNow = !this.isVocalExtractNow;
    if (this.isVocalExtractNow) {
      this.doVoiceExtractEnable();
      this.isVocalCancelNow = false;
    } else {
      this.doVoiceDisable();
    }
  }

  private async doVoiceCancelEnable(): Promise<boolean> {
    log.showInfo(TAG, `do VoiceCancelEnable`);
    if (!await audioEffectSettingModel.setVoiceCancelStatus(AIAudioEffectProp.EFFECT_CANCEL)) {
      return false;
    }
    return true;
  }

  private async doVoiceExtractEnable(): Promise<boolean> {
    log.showInfo(TAG, `do VoiceExtractEnable`);
    if (!await audioEffectSettingModel.setVoiceCancelStatus(AIAudioEffectProp.EFFECT_EXTRACT)) {
      return false;
    }
    return true;
  }

  private async doVoiceDisable(): Promise<boolean> {
    log.showInfo(TAG, `do VocalCancelDisable`);
    if (!await audioEffectSettingModel.setVoiceCancelStatus(AIAudioEffectProp.EFFECT_DEFAULT)) {
      return false;
    }
    return true;
  }
}
