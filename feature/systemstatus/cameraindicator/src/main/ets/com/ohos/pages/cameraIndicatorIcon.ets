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
import { ResUtils } from '@ohos/windowscene';
import { StyleConfigurationCommon,
  CommonStyle
} from '@ohos/systemuicommon/Index';
import StyleConfiguration, { StartsBarCameraComponentStyle } from '../common/StyleConfiguration';

const TAG = 'PC-CameraComponent-CameraIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);


@Component
export default struct CameraIndicatorIcon {
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @State style: StartsBarCameraComponentStyle = StyleConfiguration.getStartsBarCameraComponentStyle();
  @Consume contentColor: string;

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.initStyle();
  }

  initStyle(): void {
    this.styleCommon.statusBarMarginLeftRight = ResUtils.getNumberFromLength(this.styleCommon.statusBarMarginLeftRight);
    this.style.statusBarCameraWidth = ResUtils.getNumberFromLength(this.style.statusBarCameraWidth);
    this.style.statusBarCameraHeight = ResUtils.getNumberFromLength(this.style.statusBarCameraHeight);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  build() {
    Row() {
      Image($r('app.media.ic_pc_camera'))
        .draggable(false)
        .fillColor(this.contentColor)
        .objectFit(ImageFit.Contain)
        .autoResize(false)
        .width(this.style.statusBarCameraWidth)
        .height(this.style.statusBarCameraHeight)
        .interpolation(ImageInterpolation.Medium)
    }.height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}
