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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { CommonStyle } from '../style/CommonStyle';
import { UserStyle } from '../style/UserStyle';
import { LostModeConstants, LostModeViewData, SpecialModeViewModel } from '../vm/SpecialModeViewModel';

const TAG = 'ScreenLock-SlLayoutViewData';
const log = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Component
export struct LostModePrompt {
  @State lostModeData: LostModeViewData | undefined = undefined;
  @State userStyle: UserStyle = UserStyle.getInstance();
  @State commonStyle: CommonStyle = CommonStyle.getInstance();
  @Link lostModeInfoMarginTop: number;

  aboutToAppear(): void {
    this.lostModeData = SpecialModeViewModel.getInstance().specialViewData.lastModeData;
    log.showInfo(`isLostMode: ${this.lostModeData.isLostMode}`);
  }

  aboutToDisappear(): void {

  }

  build() {
    if (this.lostModeData?.isLostMode) {
      Column() {
        Text(this.lostModeData?.lostModeLockedInfo.trim())
          .id(LostModeConstants.LOCK_INFO_KEY)
          .font({
            family: this.commonStyle.fontFamilyHeiTi,
            size: this.commonStyle.promptFontSize
          })
          .align(Alignment.Center)
          .textAlign(TextAlign.Center)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .fontColor(this.userStyle.style.lostModeTextColor)
          .margin({
            top: DeviceHelper.isSuperFoldMachine() ? this.lostModeInfoMarginTop :
            $r('app.float.lost_mode_prompt_margin_top'),
          })

        Text(this.lostModeData?.lostModeContact)
          .id(LostModeConstants.LOCK_CONTACT_KEY)
          .font({
            family: this.commonStyle.fontFamilyHeiTi,
            size: this.commonStyle.promptFontSize
          })
          .align(Alignment.Center)
          .textAlign(TextAlign.Center)
          .fontColor(this.userStyle.style.lostModeTextColor)
          .margin({
            top: this.userStyle.lostModeContactMarginTop
          })
      }
      .height('100%')
      .width(this.commonStyle.displayWidth - this.commonStyle.promptMargin * 2)
    }
  }
}