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

import { SingletonHelper } from '@ohos/basicutils';
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import StyleConfiguration, { ToggleBaseComponentStyle } from '@ohos/systemuicommon/src/main/ets/template/common/StyleConfiguration';
import { AbstractToggleStyleFactory } from '@ohos/controlcentercommon/src/main/ets/toggle/AbstractToggleFactory';
import { EventHandler, ToggleParam, ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { VibratorManagerAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/VibratorManagerAdapter';

export class SingleFoldFactory implements AbstractToggleStyleFactory {
  private style: ToggleBaseComponentStyle = StyleConfiguration.getStyle();

  public static getInstance(): SingleFoldFactory {
    return SingletonHelper.getInstance(SingleFoldFactory, 'SingleFoldFactory');
  }

  // 创建基础开关，通常为图标加标题的形式
  createBasicStyle(): ToggleStyle {
    // params only own to singleFoldPhone
    let basicToggleParam: ToggleParam =
      new ToggleParam()
        .hasLabel(false)
        .iconDiameter(this.style.wifiButtonDiameter)
        .canvasDiameter(this.style.wifiButtonDiameter * 2)
        .iconBgDiameter(this.style.buttonDiameterSingleFold)
        .iconBgBorderRadius(this.style.buttonDiameterSingleFold / 2)
        .bgWidth(this.style.buttonDiameterSingleFold + this.style.newIconPadding * 2)
        .bgHeight(this.style.buttonDiameterSingleFold + this.style.newIconPadding)
        .geometryTransitionId('_singleFold')
    let basicToggleEventHandler: EventHandler =
      new EventHandler()
        .onIconClick((viewModel: ToggleBaseViewModel) => {
          if (viewModel?.handleOneClick) {
            viewModel.handleOneClick();
          }
        })
        .onIconLongPressOnActionEnd((viewModel: ToggleBaseViewModel) => {
          if (viewModel?.handleOneClick) {
            viewModel.handleOneClick();
          }
        })
    return new ToggleStyle(basicToggleParam, basicToggleEventHandler);
  }

  // 创建带附加内容的开关，例如显示wifi名称的wifi开关
  createTaggedStyle(): ToggleStyle {
    // params only own to singleFoldPhone
    let taggedToggleParam: ToggleParam =
      new ToggleParam()
        .hasLabel(true)
        .iconDiameter(this.style.topIconDiameter)
        .canvasDiameter(this.style.topButtonDiameterSingleFold)
        .iconBgDiameter(this.style.topButtonDiameterSingleFold)
        .iconBgBorderRadius(this.style.topButtonDiameterSingleFold / 2)
        .fontWeight(this.style.topButtonFontWeight)
        .labelWordBreak(WordBreak.BREAK_ALL)
        .labelFocusable(true)
        .labelAlign(TextAlign.Start)
        .labelHeight($r('app.float.Control_center_long_button_text_height'))
        .labelWidth($r('app.float.Control_center_small_screen_long_button_text_width'))
    let taggedToggleHandler: EventHandler =
      new EventHandler()
        .onIconClick((viewModel: ToggleBaseViewModel) => {
          if (viewModel?.handleOneClick) {
            viewModel.handleOneClick();
          }
        })
        .onIconLongPressOnAction((viewModel: ToggleBaseViewModel) => {
          if (viewModel?.openDetailPageFunc) {
            viewModel.openDetailPageFunc();
            VibratorManagerAdapter.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, 'CC');
          }
        })
        .onLabelClick((viewModel: ToggleBaseViewModel) => {
          if (viewModel?.openDetailPageFunc) {
            viewModel.openDetailPageFunc();
          }
        })
        .onLabelLongPressOnAction((viewModel: ToggleBaseViewModel) => {
          if (viewModel?.openDetailPageFunc) {
            viewModel.openDetailPageFunc();
            VibratorManagerAdapter.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, 'CC');
          }
        })
    return new ToggleStyle(taggedToggleParam, taggedToggleHandler);
  }
}