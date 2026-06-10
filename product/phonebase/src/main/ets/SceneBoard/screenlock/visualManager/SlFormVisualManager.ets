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
import {
  SlVisualArgs,
  SlVisualArgsBuilder,
  SlAreaType,
  SlPositionType,
  SolidColorListener
} from '@ohos/screenlockcommon';
import { SlAbstractVisualManager } from '@ohos/screenlockcommon/Index';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';

/**
 * 锁屏卡片视效管理
 */
export class SlFormVisualManager extends SlAbstractVisualManager {
  /**
   * 锁屏卡片业务配置的视效参数
   */
  private argsArr: SlVisualArgs[] = [
  /**
   * 普通场景卡片前景视效参数
   */
    SlVisualArgsBuilder.builder()
      .withPositionType(SlPositionType.SL_FORM_FOREGROUND)
      .withAreaType(SlAreaType.FORM)
      .withBrightness(BrightnessOptionUtils.keyguardTimeLightOption)
      .withDarkness(BrightnessOptionUtils.keyguardTimeDarkOption)
      .withDefaultBrightColor($r('app.color.sl_default_foreground_bright_color'))
      .withDefaultDarkColor($r('app.color.sl_default_foreground_dark_color'))
      .build(),

    /**
     * 赋色卡片场景前景视效参数
     */
    SlVisualArgsBuilder.builder()
      .withPositionType(SlPositionType.SL_FORM_FOREGROUND_CHANGE_COLOR)
      .withAreaType(SlAreaType.FORM)
      .withBrightness(BrightnessOptionUtils.keyguardTimeLightOptionForFillColor)
      .withDarkness(BrightnessOptionUtils.keyguardTimeDarkOptionForFillColor)
      .withDefaultBrightColor($r('app.color.screenlock_change_color'))
      .withDefaultDarkColor($r('app.color.screenlock_change_color'))
      .build(),

    /**
     * 卡片背板视效参数
     */
    SlVisualArgsBuilder.builder()
      .withPositionType(SlPositionType.SL_FORM_PANEL)
      .withAreaType(SlAreaType.FORM)
      .withBrightness(BrightnessOptionUtils.keyguardCardBackgroundLightOption)
      .withDarkness(BrightnessOptionUtils.keyguardCardBackgroundDarkOption)
      .withDefaultBrightColor($r('app.color.sl_form_panel_bright_color'))
      .withDefaultDarkColor($r('app.color.sl_form_panel_dark_color'))
      .build(),
  ];

  /**
   * 组件当前所在锁屏区域
   *
   */
  getAreaType(): SlAreaType {
    return SlAreaType.FORM;
  }

  /**
   * 查询当前模块所有视效参数
   *
   * @param positionType 参数使用位置
   * @returns 视效参数数组
   */
  getAllVisualArgs(): SlVisualArgs[] {
    return this.argsArr;
  }
}