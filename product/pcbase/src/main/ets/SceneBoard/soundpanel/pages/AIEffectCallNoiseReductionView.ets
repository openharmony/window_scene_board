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

import { LogDomain, Logger } from '@ohos/basicutils';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import StyleConfiguration, { ClickableMenuStyle, SoundDeviceStyle } from '../common/StyleConfiguration';
import audioEffectSettingModel,
{ AIAudioEffectProp, effectNoiseReductStatusChangeListener } from '../../microphonepanel/model/AIAudioEffectSettingModel';
import { HorizontalCardComponent } from './HorizontalCardComponent';

const TAG = 'SoundPanel-AIEffectCallNoiseReductionView';
const log = Logger.getLogHelper(LogDomain.SCB);

@Component
export default struct AIEffectCallNoiseReductionView {
  @State isCallNoiseReductionEnable: boolean = false;
  @State style: SoundDeviceStyle = StyleConfiguration.getSoundDeviceStyle();
  @State styleClickable: ClickableMenuStyle = StyleConfiguration.getClickableMenuStyle();
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  build() {
    HorizontalCardComponent({
      title: this.isCallNoiseReductionEnable ? $r('app.string.call_noise_reduce_open') :
        $r('app.string.call_noise_reduce_off'),
      isChecked: this.isCallNoiseReductionEnable,
      clickFunc: () => this.callNoiseReductionClickFunc()
    })
  }

  aboutToAppear(): void {
    const effectProp: string = audioEffectSettingModel.getEffectNoiseReductStatus();
    log.showInfo(TAG, `aboutToAppear, effectProp: ${effectProp}`);
    this.refreshNoiseReductStatus(effectProp);
    audioEffectSettingModel.registerEffectNoiseReductStatusChangeListener(this.effectNoiseReductStatusChangeListener);
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, `aboutToDisappear`);
    audioEffectSettingModel.unregisterEffectNoiseReductStatusChangeListener(this.effectNoiseReductStatusChangeListener);
  }

  private effectNoiseReductStatusChangeListener: effectNoiseReductStatusChangeListener = {
    onEffectNoiseReductStatusChange: (effectProp: string) => {
      log.showInfo(TAG, `effectNoiseReductStatusChangeListener onChange effectProp: ${effectProp}`);
      this.refreshNoiseReductStatus(effectProp);
    }
  }

  private refreshNoiseReductStatus(effectProp: string): void {
    if (effectProp === AIAudioEffectProp.NOISE_REDUCT_ON) {
      this.isCallNoiseReductionEnable = true;
    } else {
      this.isCallNoiseReductionEnable = false;
    }
  }

  private async doCallNoiseReduceEnable(): Promise<boolean> {
    log.showInfo(TAG, `do CallNoiseReductEnable`);
    return await audioEffectSettingModel.setEffectNoiseReductStatus(AIAudioEffectProp.NOISE_REDUCT_ON);
  }

  private async doCallNoiseReduceDisable(): Promise<boolean> {
    log.showInfo(TAG, `do CallNoiseReductDisable`);
    return await audioEffectSettingModel.setEffectNoiseReductStatus(AIAudioEffectProp.NOISE_REDUCT_OFF);
  }

  private callNoiseReductionClickFunc(): void {
    this.isCallNoiseReductionEnable = !this.isCallNoiseReductionEnable;
    if (this.isCallNoiseReductionEnable) {
      this.doCallNoiseReduceEnable();
    } else {
      this.doCallNoiseReduceDisable();
    }
  }
}
