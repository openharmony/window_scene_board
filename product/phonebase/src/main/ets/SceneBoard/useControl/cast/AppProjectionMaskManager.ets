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

import { ControlType, SCBAppUseControlManager, ResUtils } from '@ohos/windowscene';

const PHONE_MARGIN: string = '16vp';
const MASK_IMAGE_SIZE: string = '52vp';
const MASK_FONT_SIZE: number = 24;

export function registerAppProjectionMaskParam() {
  SCBAppUseControlManager.getInstance().registerComponentBuilderParam(ControlType.APP_PROJECTION, {
    loadBundleName: 'com.ohos.huaweicast',
    loadAbilityName: 'ScreenAbility',
    useControlMainMaskBuilder: recentAppProjectionMaskBuilder,
    useControlRecentMaskBuilder: recentAppProjectionMaskBuilder,
    isNeedShowUseControlComponent: undefined
  });
  SCBAppUseControlManager.getInstance().updateControlAppInfo(ControlType.APP_PROJECTION, [{
    bundleName: 'com.ohos.huaweicast',
    appIndex: 0,
    isNeedControl: true,
    isControlRecentOnly: true
  }]);
}

@Builder
export function recentAppProjectionMaskBuilder() {
  Stack() {
    Column() {
    }
    .backgroundEffect({
      radius: ResUtils.getNumber($r('app.float.app_lock_mask_blur_radius')),
      color: $r('app.color.app_lock_mask_color'),
      brightness: ResUtils.getNumber($r('app.float.app_lock_mask_brightness')),
      saturation: ResUtils.getNumber($r('app.float.app_lock_mask_saturate'))
    }, { disableSystemAdaptation: true })
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)

    Column() {
      SymbolGlyph($r('sys.symbol.mirror_projection'))
        .fontSize(MASK_IMAGE_SIZE)
        .fontColor([$r('sys.color.icon_tertiary')])
      Text($r('app.string.app_projecting'))
        .fontSize(MASK_FONT_SIZE)
        .fontColor($r('sys.color.font_tertiary'))
        .margin({ top: $r('app.float.margin_value_8') })
        .textAlign(TextAlign.Center)
    }
    .margin({
      left: PHONE_MARGIN,
      right: PHONE_MARGIN
    });
  }
  .width('100%')
  .height('100%')
}