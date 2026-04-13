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
import {
  SlAreaType,
  SlPositionType,
  SlVisualArgs,
  SlVisualArgsBuilder,
  SolidColorListener
} from '@ohos/screenlockcommon';
import { SlAbstractVisualManager } from '@ohos/screenlockcommon/Index';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';

/**
 * 锁屏沉浸卡片视效管理
 */
export class ImmersiveCardVisualManager extends SlAbstractVisualManager {
  /**
   * 沉浸卡片业务配置的视效参数
   */
  private argsArr: SlVisualArgs[] = [
  /**
   * 沉浸态大卡片背景视效参数
   */
    SlVisualArgsBuilder.builder()
      .withPositionType(SlPositionType.SL_IMMERSIVE_CARD_BG)
      .withAreaType(SlAreaType.IMMERSIVE_CARD)
      .withBrightness(BrightnessOptionUtils.keyguardImmersiveCardOption)
      .withDarkness(BrightnessOptionUtils.keyguardImmersiveDarkCardOption)
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