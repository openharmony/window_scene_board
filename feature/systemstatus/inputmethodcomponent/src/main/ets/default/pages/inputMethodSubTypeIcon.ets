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
import { ResUtils } from '@ohos/windowscene';
import { StyleConfigurationCommon,
  CommonStyle
} from '@ohos/systemuicommon';
import StyleConfiguration, { StartsBarInputMethodComponentStyle } from '../common/StyleConfiguration';
import ViewModel from '../viewmodel/InputMethodViewModel';
import { CommonConstants } from '@ohos/launchercommon';
const TAG = 'InputMethodSubTypeIcon';
const COMPONENT_ID_INPUT_METHOD = TAG + '_Image_inputMethod';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const CONTENT_COLOR_WHITE = '#FFFFFF';

@Component
export default struct InputMethodSubTypeIcon {
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @State style: StartsBarInputMethodComponentStyle = StyleConfiguration.getStartsBarInputMethodComponentStyle();
  @StorageLink('inputMethodSubTypeIcon') mInputMethodImage: string = '';
  @StorageLink('isScreenLockWallpaperBrightOrDark') isBrightOrDark: boolean = true;
  @State isScreenLock: boolean = false;
  @Consume contentColor: string;

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    ViewModel.initViewModel();
    this.initStyle();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  initStyle(): void {
    this.styleCommon.statusBarMarginLeftRight = ResUtils.getNumberFromLength(this.styleCommon.statusBarMarginLeftRight);
    this.style.statusBarInputMethodWidth = ResUtils.getNumberFromLength(this.style.statusBarInputMethodWidth);
    this.style.statusBarInputMethodHeight = ResUtils.getNumberFromLength(this.style.statusBarInputMethodHeight);
    this.style.hadStatusBarInputMethodWidth = ResUtils.getNumberFromLength(this.style.hadStatusBarInputMethodWidth);
    this.style.hadStatusBarInputMethodHeight = ResUtils.getNumberFromLength(this.style.hadStatusBarInputMethodHeight);
  }

  build() {
    Image(this.mInputMethodImage)
      .draggable(false)
      .id(COMPONENT_ID_INPUT_METHOD)
      .objectFit(ImageFit.Contain)
      .shadow(this.getShadow())
      .width(this.getInputMethodIconWidth())
      .height(this.getInputMethodIconHeight())
      .colorFilter(this.getColorFilter())
      .autoResize(false)
      .interpolation(ImageInterpolation.Medium)
  }

  private getInputMethodIconWidth(): Length {
    if (this.isScreenLock || !DeviceHelper.isHAD()) {
      return this.style.statusBarInputMethodWidth;
    }
    return this.style.hadStatusBarInputMethodWidth;
  }

  private getInputMethodIconHeight(): Length {
    if (this.isScreenLock || !DeviceHelper.isHAD()) {
      return this.style.statusBarInputMethodHeight;
    }
    return this.style.hadStatusBarInputMethodHeight;
  }

  private getColorFilter(): ColorFilter {
    let device: string | undefined = AppStorage.get('device');
    if (device != CommonConstants.DEFAULT_DEVICE_TYPE && this.isScreenLock) {
      log.showInfo(`this.isBrightOrDark is ${this.isBrightOrDark}`);
      return !this.isBrightOrDark ? [0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0] :
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.9, 0];
    } else {
      return this.isWhiteIcon() ? [0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0] :
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.9, 0];
    }
  }

  private getShadow(): ShadowOptions {
    if (this.isWhiteIcon()) {
      return {
        radius: 4,
        color: $r('app.color.input_method_shadow_color'),
        offsetY: 2,
      }
    }
    return {
      radius: 0
    }
  }

  private isWhiteIcon(): Boolean {
    if (this.isScreenLock) {
      return !this.isBrightOrDark;
    }
    return this.contentColor === CONTENT_COLOR_WHITE;
  }
}
