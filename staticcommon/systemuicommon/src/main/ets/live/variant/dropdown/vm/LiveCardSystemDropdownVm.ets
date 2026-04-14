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
import { SystemUIUseScene } from '../../../../constants/SystemuiConstants';
import { LiveStyle } from '../../../constants/LiveStyle';
import { LiveCardSystemVm } from '../../../vm/LiveCardSystemVm';

/**
 * 通知中心面板实况卡片vm
 */
@ObservedV2
export class LiveCardSystemDropdownVm extends LiveCardSystemVm {
  @Trace public static expandActionButtonMap: Map<SystemUIUseScene, string> = new Map();

  @Computed get simIconColor(): Array<ResourceColor> {
    return [LiveStyle.SYS_TEXT_COLOR_SECONDARY];
  }

  get titleFontColor(): ResourceColor | undefined {
    return $r('sys.color.ohos_id_color_text_primary');
  }

  get textFontColor(): ResourceColor | undefined {
    return LiveStyle.LIVE_CARD_TEXT_FONT_COLOR;
  }

  @Computed
  get hasActionButtons(): boolean {
    if (!this.live.isCharge()) {
      return false;
    }
    if (!this.live.actionButtons?.length) {
      return false;
    }
    return this.vmInjector.scene === SystemUIUseScene.DROPDOWN;
  }

  @Computed
  get isShowActionButtons(): boolean {
    return LiveCardSystemDropdownVm.expandActionButtonMap.get(this.vmInjector.scene) === this.live.hashCode;
  }

  getSolidTextColor(): ResourceColor | undefined {
    if (!this.vmInjector.getColorVm().isSolidEnable()) {
      return undefined;
    }
    return this.vmInjector.getColorVm()
      .calcSecondarySolidColor('#FFFFFF', this.textForegroundBrightness,
        this.vmInjector.getColorVm().liveBgPickColor);
  }

  @Computed
  get textForegroundBrightness(): BrightnessOptions | undefined {
    return this.vmInjector.getColorVm().ntfLiveFontFgBrightness;
  }
}