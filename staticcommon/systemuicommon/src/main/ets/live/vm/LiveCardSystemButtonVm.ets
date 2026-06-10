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

import { ILiveCardSystemButtonVm } from '../interface/ILiveCardSystemButtonVm';
import { LiveItemBaseVm } from './LiveBaseVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveButtonModel } from '../model/LiveCommonModel';
import { LiveButtonState, SysTypeCode } from '../../liveview/common/LiveConstants';
import { SystemUIColorVm } from '../../vm/SystemUIColorVm';
import { image } from '@kit.ImageKit';
import { ClickNotificationMaintenance } from '../../maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../maintenance/StatisticsConstants';
import { SystemUIUseScene } from '../../constants/SystemuiConstants';
import { LiveHiSysEvent } from '../sysEvent/LiveHiSysEvent';
import { SystemEffectVm } from '../../vm/SystemEffectVm';
import { LiveStyle } from '../constants/LiveStyle';

const TAG = 'LiveCardSystemButtonVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class LiveCardSystemButtonVm extends LiveItemBaseVm implements ILiveCardSystemButtonVm {
  /**
   * 按钮大小
   */
  get buttonSize(): Length {
    return 40;
  }

  /**
   * 按钮透明度
   */
  get buttonOpacity(): number | undefined {
    return 1;
  }

  /**
   * 按钮填充颜色
   */
  public filterColor: ColorFilter | undefined = undefined;
  /**
   * 是否显示描边
   */
  @Computed get isShowBorder(): boolean {
    return false;
  }

  public buttonBgColor: ResourceColor = '#FF000000';

  @Computed get colorVm(): SystemUIColorVm {
    return this.vmInjector.getColorVm();
  }

  getId(button: LiveButtonModel): string {
    return this.vmInjector.getId(`${TAG}_${this.live.hashCode}_${button.name}`);
  }

  getIcon(button: LiveButtonModel): image.PixelMap | undefined {
    if (this.live.typeCode === SysTypeCode.SCREEN_RECORDING) {
      if (button.onOffState === LiveButtonState.OFF) {
        this.filterColor = LiveStyle.WHITE_COLOR_FILTER;
      } else {
        this.filterColor = undefined;
      }
    }
    log.showInfo(`button ${button.name}, ${button.iconResource?.id}, ${button?.lightIcon} ${button?.darkIcon}`);
    return button.darkIcon;
  }

  getLiveButtonNoBrightnessBgColor(buttonData: LiveButtonModel): ResourceColor | undefined {
    let systemLiveBtnBgColor: ResourceColor = '#FF000000';
    if (!SystemEffectVm.instance.isCloseBrightness()) {
      return systemLiveBtnBgColor;
    }
    if (buttonData) {
      if (this.live.typeCode === SysTypeCode.SCREEN_RECORDING) {
        if (buttonData.onOffState === LiveButtonState.ON) {
          return this.colorVm.calcSecondarySolidColor(LiveStyle.LIVE_BUTTON_ON_BRIGHTNESS_BG_COLOR,
            this.colorVm.screenRecordButtonOnBgBrightness, this.colorVm.liveBgPickColor);
        }
        if (buttonData.onOffState === LiveButtonState.OFF) {
          return this.colorVm.calcSecondarySolidColor($r('app.color.live_btn_off_disable_brightness_bg_color'),
            this.colorVm.screenRecordButtonOffBgBrightness, this.colorVm.liveBgPickColor);
        }
      }
      if (buttonData.onOffState === LiveButtonState.ON) {
        return this.colorVm.calcSecondarySolidColor(LiveStyle.LIVE_BUTTON_ON_BRIGHTNESS_BG_COLOR,
          this.colorVm.systemButtonOnBgBrightness, this.colorVm.liveBgPickColor);
      }
      if (buttonData.onOffState === LiveButtonState.OFF) {
        return this.colorVm.calcSecondarySolidColor($r('app.color.live_btn_off_disable_brightness_bg_color'),
          this.colorVm.systemButtonOffBgBrightness, this.colorVm.liveBgPickColor);
      }
    }
    return this.colorVm.calcSecondarySolidColor($r('app.color.live_btn_off_disable_brightness_bg_color'),
      this.colorVm.systemButtonOffBgBrightness, this.colorVm.liveBgPickColor);
  }

  getButtonBgBrightness(button: LiveButtonModel): BrightnessOptions | undefined {
    if (SystemEffectVm.instance.isCloseBrightness()) {
      return undefined;
    }
    if (this.live.typeCode === SysTypeCode.SCREEN_RECORDING) {
      if (button.onOffState === LiveButtonState.ON) {
        return this.colorVm.screenRecordButtonOnBgBrightness;
      }
      if (button.onOffState === LiveButtonState.OFF) {
        return this.colorVm.screenRecordButtonOffBgBrightness;
      }
    }
    if (button.onOffState === LiveButtonState.ON) {
      return this.colorVm.systemButtonOnBgBrightness;
    }
    if (button.onOffState === LiveButtonState.OFF) {
      return this.colorVm.systemButtonOffBgBrightness;
    }
    return this.colorVm.systemButtonOffBgBrightness;
  }

  public onClickButton = (button: LiveButtonModel): void => {
    log.showInfo(`Click button for ${this.live.hashCode}, button name: ${button.name}`);
    ClickNotificationMaintenance.saveInfo({
      data: this.live,
      clickRegion: ClickRegion.LIVE_BUTTON,
      scene: SystemUIUseScene.LIVE,
      buttonName: button.name,
    });
    this.vmInjector.getStarterVm().triggerButton(this.live, button);
    LiveHiSysEvent.reportLiveButtonClickEvent(this.live);
  };
}