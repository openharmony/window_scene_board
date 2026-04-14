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

import { ExtendStyle } from '@ohos/systemuicommon/src/main/ets/liveview/common/Extendstyle';
import { ImmersiveCapsuleConstants } from '../../common/constants/ImmersiveCapsuleConstants';
import { LiveOtherExtendData } from '@ohos/systemuicommon/src/main/ets/TsIndex';

export class ImmersiveExtendStyle implements ExtendStyle {
  /**
   * 三方辅助区宽度
   */
  public extendWidth: number = 36;
  public extendHeight: number = 36;
  /**
   * 普通文本参数
   */
  public normalTextWidth: number = 36;
  public normalTextHeight: number = 36;
  public normalTextMaxFont: number = 14;
  public normalTextMinFont: number = 10;
  public textColor: ResourceColor = ImmersiveCapsuleConstants.getMainTextFontColor();
  /**
   * 胶囊文本参数
   */
  public capsuleButtonWidth: number = 56;
  public capsuleButtonMaxWidth: number = 56;
  public capsuleButtonHeight: number = 20;
  public capsuleButtonTextHeight: number = 10;
  public capsuleButtonTopMargin: number = 2;
  public capsuleButtonLeftMargin: number = 2;
  public capsuleBackgroundColor?: ResourceColor = ImmersiveCapsuleConstants.getProgressBackgroundColor();

  /**
   * 系统按钮参数
   */
  public buttonSpace: number = 8;
  public buttonHeight: number = 36;
  public buttonLength: number = 36;
  public buttonBorderRadius: number = 18;
  public buttonBackground: ResourceColor = ImmersiveCapsuleConstants.getButtonBackground();
  public buttonColor: ResourceColor = ImmersiveCapsuleConstants.getButtonColor();

  /**
   * 进度按钮参数
   */
  public progressHeight: number = 36;
  public progressWidth: number = 36;
  public progressStrokeWidth: number = 6;
  public progressBackgroundColor: ResourceColor = ImmersiveCapsuleConstants.getProgressBackgroundColor();
  public progressColor?: ResourceColor = ImmersiveCapsuleConstants.getProgressColor();

  public onExtentClick?: (data?: LiveOtherExtendData, clickCount?: number) => void;
}