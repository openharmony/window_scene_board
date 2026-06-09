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
import Constants from '../common/Constants'
import { CommonStyle } from '../style/CommonStyle';

const TAG = 'ScreenLock-ResetPinText';
const log: Logger = Logger.getLogHelper(LogDomain.KG);
const COMPONENT_ID_BUTTON_RESET_PIN = TAG + '_Button_reset_pin';

@Component
export default struct ResetPinText {
  @Consume isPowerMenuPanelShowed: boolean;
  @StorageLink('passwordType') passwordType: string = 'NONE';
  @StorageLink('isScreenLockWallpaperBrightOrDark') isBrightOrDark: boolean = true;
  @StorageLink('isResetPwdPanelShow') isResetPwdPanelShow: boolean = false;
  @Link isPinChangeTextShow: boolean;
  @Link passwordViewBlur: number;
  @Link passwordViewOpacity: number;
  @Link passwordViewScale: number;
  @Link passwordViewTranslate: number | string;
  @StorageLink('isPinAvailable') isPinAvailable: boolean = true;

  build() {
    if (this.isPinChangeTextShow && this.passwordType !== 'NONE' && (!this.isResetPwdPanelShow)) {
      Text($r('app.string.change_lock_screen_psd'))
        .onTouch(event => {
          event.stopPropagation();
        })
        .id(COMPONENT_ID_BUTTON_RESET_PIN)
        .onClick(() => {
          this.isResetPwdPanelShow = !this.isResetPwdPanelShow;
          this.isPowerMenuPanelShowed = false;
          this.isPinAvailable = true;
          this.isPinChangeTextShow = false;
        })
        .focusable(!this.isPowerMenuPanelShowed && !this.isResetPwdPanelShow)
        .fontColor(this.isBrightOrDark ? '#99000000' : '#FFFFFFFF')
        .foregroundBrightness(this.isBrightOrDark ? CommonStyle.toastDarkBrightness : CommonStyle.toastLightBrightness)
        .fontSize('18vp')
        .fontWeight(FontWeight.Bold)
        .fontFamily('HarmonyHeiTi')
        .visibility(this.isPinChangeTextShow ? Visibility.Visible : Visibility.Hidden)
        .margin({ top: $r('app.float.screenLock_resettext_margin_topbottom'),
          left: $r('app.float.screenLock_resettext_margin_leftright'),
          right: $r('app.float.screenLock_resettext_margin_leftright'),
          bottom: $r('app.float.screenLock_resettext_margin_topbottom') })
    }
  }
}