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
import { LiveTimerData } from '@ohos/systemuicommon';
import { GlassLiveTimeComponent } from '../../common/component/GlassLiveTimeComponent';
import GlassPhoneCapsule from '../models/PhoneCapsule';
import { GlassStatusBarStyle } from './GlassStatusBarStyle';

const TAG: string = 'PhoneCapsuleIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

/**
 * 通话实况
 */
@Component
export struct PhoneCapsuleIcon {
  @State liveTimerData: LiveTimerData | undefined = undefined;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    this.liveTimerData = GlassPhoneCapsule.getInstance().liveTimerData;
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.liveTimerData = undefined;
  }

  build() {
    Row({ space: GlassStatusBarStyle.CAPSULE_BUTTON_COMPONENT_INTERVAL }) {
      Image($r('app.media.glass_ic_public_phone_filled'))
        .height(GlassStatusBarStyle.ICON_SIZE)
        .width(GlassStatusBarStyle.ICON_SIZE)
      GlassLiveTimeComponent({
        timeData: this.liveTimerData,
        viewFontSize: GlassStatusBarStyle.FONT_SIZE_24,
        viewFontColor: Color.White,
      })
        .height('24px')
    }
    .margin({
      right: GlassStatusBarStyle.MARGIN_LEFT_RIGHT,
      left: GlassStatusBarStyle.MARGIN_LEFT_RIGHT
    })
  }
}