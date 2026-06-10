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
import { ColorModeViewModel } from '@ohos/systemuicommon/Index';

/**
 * 锁屏胶囊视效管理
 */
export class ImmersiveCapsuleVisualManager extends SlAbstractVisualManager {
  /**
   * 锁屏通知胶囊业务配置的视效参数
   */
  private argsArr: SlVisualArgs[] = [
  /**
   * 锁屏内容胶囊主文本视效参数
   */
    SlVisualArgsBuilder.builder()
      .withPositionType(SlPositionType.SL_CAP_FIRST_FOREGROUND)
      .withAreaType(SlAreaType.CAPSULE)
      .withBrightness(BrightnessOptionUtils.getInstance().foregroundPrimaryOptionDark)
      .withDarkness(BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight)
      .withDefaultBrightColor($r('app.color.sl_cap_default_foreground_bright_color'))
      .withDefaultDarkColor($r('app.color.sl_cap_default_foreground_dark_color'))
      .build(),

    /**
     * 锁屏内容胶囊按钮视效参数
     */
    SlVisualArgsBuilder.builder()
      .withPositionType(SlPositionType.SL_CAP_FIRST_BUTTON)
      .withAreaType(SlAreaType.CAPSULE)
      .withBrightness(BrightnessOptionUtils.CAPSULE_EXTEND_LIGHT_OPTION)
      .withDarkness(BrightnessOptionUtils.CAPSULE_EXTEND_DARK_OPTION)
      .withDefaultBrightColor($r('app.color.sl_cap_default_bright_color'))
      .withDefaultDarkColor($r('app.color.sl_cap_default_dark_color'))
      .build(),

    /**
     * 锁屏内容胶囊背板视效参数
     */
    SlVisualArgsBuilder.builder()
      .withPositionType(SlPositionType.SL_CAP_FIRST_BACKGROUND)
      .withAreaType(SlAreaType.CAPSULE)
      .withBrightness(BrightnessOptionUtils.keyguardCapsuleBackFirstLightOption)
      .withDarkness(BrightnessOptionUtils.keyguardCapsuleBackFirstDarkOption)
      .withDefaultBrightColor($r('app.color.sl_cap_first_background_bright_color'))
      .withDefaultDarkColor($r('app.color.sl_cap_first_background_dark_color'))
      .build(),

    /**
     * 锁屏胶囊辅助区文本视效参数
     */
    SlVisualArgsBuilder.builder()
      .withPositionType(SlPositionType.SL_CAP_SUPPORT_TEXT_BRIGHT)
      .withAreaType(SlAreaType.CAPSULE)
      .withBrightness(ColorModeViewModel.getInstance().getViewData().immersiveCapTextDarkOption)
      .withDarkness(ColorModeViewModel.getInstance().getViewData().immersiveCapTextLightOption)
      .withDefaultBrightColor($r('app.color.sl_cap_default_foreground_bright_color'))
      .withDefaultDarkColor($r('app.color.sl_cap_default_foreground_dark_color'))
      .build(),

    /**
     * 锁屏胶囊辅助区背板视效参数
     */
    SlVisualArgsBuilder.builder()
      .withPositionType(SlPositionType.SL_CAP_SUPPORT_BACK_BRIGHT)
      .withAreaType(SlAreaType.CAPSULE)
      .withBrightness(ColorModeViewModel.getInstance().getViewData().immersiveCapBgcDarkOption)
      .withDarkness(ColorModeViewModel.getInstance().getViewData().immersiveCapBgcLightOption)
      .withDefaultBrightColor($r('app.color.sl_cap_default_bright_color'))
      .withDefaultDarkColor($r('app.color.sl_cap_default_dark_color'))
      .build(),

    /**
     * 锁屏阴影胶囊前景视效参数
     */
    SlVisualArgsBuilder.builder()
      .withPositionType(SlPositionType.SL_CAP_SECOND_FOREGROUND)
      .withAreaType(SlAreaType.CAPSULE)
      .withBrightness(BrightnessOptionUtils.getInstance().foregroundSecondaryDarkOption)
      .withDarkness(BrightnessOptionUtils.getInstance().foregroundSecondaryOption)
      .withDefaultBrightColor($r('app.color.sl_cap_second_foreground_bright_color'))
      .withDefaultDarkColor($r('app.color.sl_cap_second_foreground_dark_color'))
      .build(),

    /**
     * 锁屏阴影胶囊按钮视效参数
     */
    SlVisualArgsBuilder.builder()
      .withPositionType(SlPositionType.SL_CAP_SECOND_BUTTON)
      .withAreaType(SlAreaType.CAPSULE)
      .withBrightness(BrightnessOptionUtils.CAPSULE_EXTEND_LIGHT_OPTION)
      .withDarkness(BrightnessOptionUtils.CAPSULE_EXTEND_DARK_OPTION)
      .withDefaultBrightColor($r('app.color.sl_cap_default_bright_color'))
      .withDefaultDarkColor($r('app.color.sl_cap_default_dark_color'))
      .build(),

    /**
     * 锁屏阴影胶囊背板视效参数
     */
    SlVisualArgsBuilder.builder()
      .withPositionType(SlPositionType.SL_CAP_SECOND_BACKGROUND)
      .withAreaType(SlAreaType.CAPSULE)
      .withBrightness(BrightnessOptionUtils.keyguardCapsuleBackSecondLightOption)
      .withDarkness(BrightnessOptionUtils.keyguardCapsuleBackSecondDarkOption)
      .withDefaultBrightColor($r('app.color.sl_cap_second_background_bright_color'))
      .withDefaultDarkColor($r('app.color.sl_cap_second_background_dark_color'))
      .build()
  ];

  /**
   * 组件当前所在锁屏区域
   *
   */
  getAreaType(): SlAreaType {
    return SlAreaType.CAPSULE;
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