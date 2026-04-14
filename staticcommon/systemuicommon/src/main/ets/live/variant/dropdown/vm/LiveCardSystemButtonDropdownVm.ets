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

import { LiveCardSystemButtonVm } from '../../../vm/LiveCardSystemButtonVm';
import { image } from '@kit.ImageKit';
import { LiveButtonModel } from '../../../model/LiveCommonModel';
import { EnvVm } from '../../../../vm/EnvVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveHiSysEvent } from '../../../sysEvent/LiveHiSysEvent';
import { DropdownVm } from '../../../../vm/DropdownVm';
import { ClickRegion } from '../../../../maintenance/StatisticsConstants';
import { LiveButtonState, SysTypeCode } from '../../../../liveview/common/LiveConstants';
import { ClickNotificationMaintenance } from '../../../../maintenance/ClickNotificationMaintenance';
import { SystemUIUseScene } from '../../../../constants/SystemuiConstants';
import { LiveStyle } from '../../../constants/LiveStyle';
import { SystemEffectVm } from '../../../../vm/SystemEffectVm';
import { SystemUIColorVm } from '../../../../vm/SystemUIColorVm';
import { ClickPosition } from '../../../../banner/common/info/BannerState';

const TAG = 'LiveCardSystemButtonVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class LiveCardSystemButtonDropdownVm extends LiveCardSystemButtonVm {
  @Computed get isShowBorder(): boolean {
    return !EnvVm.instance.isDarkMode;
  }

  getIcon(button: LiveButtonModel): image.PixelMap | undefined {
    if (this.live.typeCode === SysTypeCode.SCREEN_RECORDING) {
      this.filterColor = undefined;
      if (!EnvVm.instance.isDarkMode && button.onOffState === LiveButtonState.OFF) {
        this.filterColor = LiveStyle.BLACK_COLOR_FILTER;
      }
    }
    return EnvVm.instance.isDarkMode ? button.darkIcon : button.lightIcon;
  }

  getLiveButtonNoBrightnessBgColor(buttonData: LiveButtonModel): ResourceColor | undefined {
    if (!this.colorVm.isNtfBrightnessDisable) {
      return this.buttonBgColor;
    }
    if (buttonData) {
      if (buttonData.onOffState === LiveButtonState.ON) {
        return this.colorVm.calcSecondarySolidColor($r('app.color.live_btn_on_disable_brightness_bg_color'),
          this.colorVm.systemButtonOnBgBrightness, this.colorVm.liveBgPickColor);
      }
      if (buttonData.onOffState === LiveButtonState.OFF) {
        return this.colorVm.calcSecondarySolidColor($r('app.color.live_btn_off_disable_brightness_bg_color'),
          this.colorVm.systemButtonOffBgBrightness, this.colorVm.liveBgPickColor);
      }
    }
    return this.colorVm.calcSecondarySolidColor($r('app.color.live_btn_off_disable_brightness_bg_color'),
      this.colorVm.systemButtonBgBrightness, this.colorVm.liveBgPickColor);
  }

  getButtonBgBrightness(button: LiveButtonModel): BrightnessOptions | undefined {
    if (SystemEffectVm.instance.isCloseBrightness()) {
      return undefined;
    }
    if (button.onOffState === LiveButtonState.ON) {
      return this.colorVm.isNtfBrightnessDisable ? undefined : this.colorVm.systemButtonOnBgBrightness;
    }
    if (button.onOffState === LiveButtonState.OFF) {
      return this.colorVm.isNtfBrightnessDisable ? undefined : this.colorVm.systemButtonOffBgBrightness;
    }
    if (this.colorVm.systemButtonOffBgBrightness.rate === 0) {
      log.showWarn(`systemButtonOffBgBrightness error, rate = 0`);
    }
    return this.colorVm.isNtfBrightnessDisable ? undefined : this.colorVm.systemButtonOffBgBrightness;
  }

  public onClickButton = (button: LiveButtonModel): void => {
    log.showInfo(`Click button for ${this.live.hashCode}, button name: ${button.name}`);
    if (button.hidePanel) {
      DropdownVm.instance.hidePanel(true);
    }
    ClickNotificationMaintenance.saveInfo({
      data: this.live,
      clickRegion: ClickRegion.LIVE_BUTTON,
      scene: SystemUIUseScene.DROPDOWN,
      buttonName: button.name,
    });
    this.vmInjector.getStarterVm().triggerButton(this.live, button);
    LiveHiSysEvent.reportLiveButtonClickEvent(this.live);
  };
}