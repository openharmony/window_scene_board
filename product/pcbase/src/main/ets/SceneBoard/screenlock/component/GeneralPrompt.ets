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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { UserStyle } from '../style/UserStyle';
import { CommonStyle } from '../style/CommonStyle';
import Constants from '../common/Constants';
import StyleConfiguration, { ScreenlockComponentStyle } from '../common/StyleConfiguration';

const TAG = 'ScreenLock-GeneralPrompt'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Extend(Text)
function baseTipTextStyle(fontSize: Length) {
  .draggable(false)
  .font({
    family: Constants.TOAST_FONT_FAMILY,
    weight: FontWeight.Bold,
    size: fontSize
  })
  .textAlign(TextAlign.Center)
  .textOverflow({ overflow: TextOverflow.None })
}

@Component
export struct GeneralPrompt {
  private promptId: string = '';
  private transitionEffect: TransitionEffect | undefined = undefined;
  private marginTop: number | Resource | string = 0;
  @Prop prompt: string | Resource | undefined;
  @Prop visible: boolean = true;
  @State userStyle: UserStyle = UserStyle.getInstance();
  @StorageLink('isScreenLockWallpaperBrightOrDark') isBrightWallPaper: boolean = true;
  private screenlockStyle: ScreenlockComponentStyle = StyleConfiguration.getScreenlockComponentStyle();

  build() {
    Stack() {
      Text(this.prompt)
        .focusable(false)
        .baseTipTextStyle(this.screenlockStyle.toastTextFontSize)
        .lineHeight(Constants.TOAST_LINE_HEIGHT)
        .maxLines(Constants.TOAST_MAXLINES)
        .fontColor(Color.Transparent)
        .textShadow(this.userStyle.style.promptShadow)
        .transition(this.transitionEffect)
      Text(this.prompt)
        .id(this.promptId)
        .baseTipTextStyle(this.screenlockStyle.toastTextFontSize)
        .lineHeight(Constants.TOAST_LINE_HEIGHT)
        .maxLines(Constants.TOAST_MAXLINES)
        .fontColor(this.isBrightWallPaper ? $r('app.color.screen_lock_toast_color_lg') :
        $r('app.color.screen_lock_toast_color_dk'))
        .foregroundBrightness(this.isBrightWallPaper ? CommonStyle.toastDarkBrightness :
        CommonStyle.toastLightBrightness)
        .transition(this.transitionEffect)
    }
    .visibility(this.visible ? Visibility.Visible : Visibility.None)
    .margin({
      top: this.marginTop
    })
  }
}