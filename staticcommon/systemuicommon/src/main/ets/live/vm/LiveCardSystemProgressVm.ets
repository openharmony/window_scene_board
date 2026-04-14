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

import { ILiveCardSystemProgressVm } from '../interface/ILiveCardSystemProgressVm';
import { LiveItemBaseVm } from './LiveBaseVm';
import { LiveCardSystemModel } from '../model/LiveCardSystemModel';
import { SysTypeCode } from '../../liveview/common/LiveConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import notificationManager from '@ohos.notificationManager';
import { LiveStyle } from '../constants/LiveStyle';
import { SystemEffectVm } from '../../vm/SystemEffectVm';
import { SystemUIColorVm } from '../../vm/SystemUIColorVm';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'LiveCardSystemProgressVm');
const PROGRESS_MAX_VALUE = 100;

@ObservedV2
export class LiveCardSystemProgressVm extends LiveItemBaseVm implements ILiveCardSystemProgressVm {
  @Computed get colorVm(): SystemUIColorVm {
    return this.vmInjector.getColorVm();
  }

  get progressHeight(): Length {
    return 40;
  }

  get progressWidth(): Length {
    return 40;
  }

  get progressStrokeWidth(): Length {
    return 6;
  }

  get progressOpacity(): number | undefined {
    return undefined;
  }

  getProgressColor(): ResourceColor {
    if (this.live.isCharge()) {
      return (this.live.card as LiveCardSystemModel).progress?.color ?? LiveStyle.PROGRESS_COLOR_DARK;
    }
    return LiveStyle.PROGRESS_COLOR_DARK;
  }

  @Computed get progressValue(): number {
    const progress = (this.live.card as LiveCardSystemModel).progress;
    if (!progress?.maxValue) {
      return 0;
    }
    return (progress?.currentValue ?? 0) * PROGRESS_MAX_VALUE / progress.maxValue;
  }

  @Computed
  get isShowText(): boolean {
    return this.live.isCharge();
  }

  @Computed get isShowButton(): boolean {
    return this.live.typeCode === SysTypeCode.UPLOAD_DOWNLOAD;
  }
  @Trace public isButtonPaused: boolean = false;

  public onClickButton = async (): Promise<void> => {
    log.showInfo(`Click progress button for ${this.live.hashCode}, isPaused: ${this.isButtonPaused}`);
    const buttonOptions: notificationManager.ButtonOptions = {
      buttonName: this.isButtonPaused ? 'start' : 'stop',
    };
    const bundle = this.live.agentBundle ?? {
      bundle: this.live.creatorBundleName,
      uid: this.live.creatorUid,
    };
    this.isButtonPaused = !this.isButtonPaused;
    try {
      await notificationManager.triggerSystemLiveView(bundle, this.live.id, buttonOptions);
    } catch (e) {
      log.error('Trigger system liveView fail:', e);
    }
  };

  getLiveProgressNoBrightnessBgColor(): ResourceColor | undefined {
    let systemLiveBtnBgColor: ResourceColor = '#FF000000';
    if (!SystemEffectVm.instance.isCloseBrightness()) {
      return systemLiveBtnBgColor;
    }
    return this.colorVm.calcSecondarySolidColor($r('app.color.live_btn_off_disable_brightness_bg_color'),
      this.colorVm.systemButtonOffBgBrightness, this.colorVm.liveBgPickColor);
  }

  getProgressBgBrightness(): BrightnessOptions | undefined {
    if (SystemEffectVm.instance.isCloseBrightness()) {
      return undefined;
    }
    return this.colorVm.systemButtonOffBgBrightness;
  }
}