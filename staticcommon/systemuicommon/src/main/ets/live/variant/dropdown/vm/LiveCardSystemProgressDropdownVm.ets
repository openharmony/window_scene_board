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
import { LiveCardSystemProgressVm } from '../../../vm/LiveCardSystemProgressVm';
import { LiveCardSystemModel } from '../../../model/LiveCardSystemModel';
import { LiveStyle } from '../../../constants/LiveStyle';
import { EnvVm } from '../../../../vm/EnvVm';
import { SystemEffectVm } from '../../../../vm/SystemEffectVm';

const TAG = 'LiveCardSystemProgressDropdownVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class LiveCardSystemProgressDropdownVm extends LiveCardSystemProgressVm {
  getProgressColor(): ResourceColor {
    if (this.live.isCharge()) {
      return (this.live.card as LiveCardSystemModel).progress?.color ?? LiveStyle.PROGRESS_COLOR_DARK;
    }
    return EnvVm.instance.isDarkMode ? LiveStyle.PROGRESS_COLOR_DARK : LiveStyle.PROGRESS_COLOR_LIGHT;
  }

  getLiveProgressNoBrightnessBgColor(): ResourceColor {
    if (!this.colorVm.isNtfBrightnessDisable) {
      return '#FF000000';
    }
    return this.colorVm.calcSecondarySolidColor($r('app.color.live_btn_off_disable_brightness_bg_color'),
      this.colorVm.systemButtonBgBrightness, this.colorVm.liveBgPickColor);
  }

  getProgressBgBrightness(): BrightnessOptions | undefined {
    if (SystemEffectVm.instance.isCloseBrightness()) {
      return undefined;
    }
    return this.colorVm.isNtfBrightnessDisable ? undefined : this.colorVm.systemButtonOffBgBrightness;
  }
}