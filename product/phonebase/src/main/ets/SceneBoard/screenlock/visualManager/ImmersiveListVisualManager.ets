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
 * 锁屏通知列表视效管理
 */
export class ImmersiveListVisualManager extends SlAbstractVisualManager {
  /**
   * 锁屏通知列表业务配置的视效参数
   */
  private argsArr: SlVisualArgs[] = [
  /**
   * 通知列表前景视效参数
   */
    SlVisualArgsBuilder.builder()
      .withPositionType(SlPositionType.SL_NTF_LIST_FOREGROUND)
      .withAreaType(SlAreaType.NTF_LIST)
      .withBrightness(BrightnessOptionUtils.getInstance().foregroundDividerDarkOption)
      .withDarkness(BrightnessOptionUtils.getInstance().foregroundDividerOption)
      .withDefaultBrightColor($r('app.color.sl_ntf_list_foreground_bright_color'))
      .withDefaultDarkColor($r('app.color.sl_ntf_list_foreground_dark_color'))
      .build(),

    /**
     * 通知列表背板视效参数
     */
    SlVisualArgsBuilder.builder()
      .withPositionType(SlPositionType.SL_NTF_LIST_BACK)
      .withAreaType(SlAreaType.NTF_LIST)
      .withBrightness(BrightnessOptionUtils.keyguardCardDarkOption)
      .withDarkness(BrightnessOptionUtils.keyguardCardOption)
      .withDefaultBrightColor($r('app.color.sl_ntf_list_back_bright_color'))
      .withDefaultDarkColor($r('app.color.sl_ntf_list_back_dark_color'))
      .build()
  ];

  /**
   * 组件当前所在锁屏区域
   *
   */
  getAreaType(): SlAreaType {
    return SlAreaType.NTF_LIST;
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