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

import { AbstractToggleStyleFactory } from '@ohos/controlcentercommon/src/main/ets/toggle/AbstractToggleFactory';
import { EventHandler, ToggleParam, ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import StyleConfiguration, { ToggleBaseComponentStyle } from '@ohos/systemuicommon/src/main/ets/template/common/StyleConfiguration';
import { LengthMetrics } from '@kit.ArkUI';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { VibratorManagerAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/VibratorManagerAdapter';

const TAG = 'Model.PhoneStyleFactory:';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export class PhoneStyleFactory implements AbstractToggleStyleFactory {
  private style: ToggleBaseComponentStyle = StyleConfiguration.getStyle();

  public static getInstance(): PhoneStyleFactory {
    return SingletonHelper.getInstance(PhoneStyleFactory, 'PhoneStyleFactory');
  }

  // 创建基础开关，通常为图标加标题的形式
  createBasicStyle(): ToggleStyle {
    let basicToggleParam: ToggleParam =
      new ToggleParam()
        .hasLabel(true)
        .iconDiameter(StyleConfiguration.getStyle().iconDiameter)
        .canvasDiameter(StyleConfiguration.getStyle().iconDiameter * 2)
        .iconBgDiameter(this.style.buttonDiameter)
        .iconBgBorderRadius(this.style.buttonDiameter / 2)
        .bgWidth(this.style.buttonDiameter)
        .bgHeight(this.style.buttonDiameter + this.style.buttonLabelSpace +
        this.style.buttonLabelHeight)
        .iconLabelPadding({
          top: this.style.otherIconPadding,
          end: LengthMetrics.vp(this.style.otherIconPaddingRight)
        })
        .labelPadding({
          top: undefined
        })
        .labelFocusable(false)
    let basicToggleEventHandler: EventHandler =
      new EventHandler()
        .onIconClick((viewModel: ToggleBaseViewModel) => {
          if (viewModel?.handleOneClick) {
            viewModel.handleOneClick();
          }
        })
        .onIconLongPressOnAction((viewModel: ToggleBaseViewModel) => {
          // 按照优先级处理
          if (viewModel?.customCommonData.isSupportLongClickAction) {
            // 支持长按处理
            if (viewModel?.openDetailPageFunc) {
              viewModel.openDetailPageFunc();
              VibratorManagerAdapter.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
                CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, 'CC');
            } else if (viewModel?.startServiceFunc) {
              viewModel.startServiceFunc();
              VibratorManagerAdapter.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
                CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, 'CC');
            }
          }
        })
        .onIconLongPressOnActionEnd((viewModel: ToggleBaseViewModel) => {
          // 既没有二级页面，也不能跳转应用，长按抬手之后做一键执行的处理
          if (viewModel?.handleOneClick) {
            if (!viewModel?.openDetailPageFunc && !viewModel?.startServiceFunc) {
              viewModel?.handleOneClick();
            } else if ((viewModel?.openDetailPageFunc || viewModel?.startServiceFunc) &&
              !viewModel?.customCommonData.isSupportLongClickAction) {
              viewModel?.handleOneClick();
            }
          }
        })
        .onLabelClick((viewModel: ToggleBaseViewModel) => {
          if (viewModel?.handleOneClick) {
            viewModel.handleOneClick();
          }
        })
        .onLabelLongPressOnAction((viewModel: ToggleBaseViewModel) => {
          // 按照优先级处理
          if (viewModel?.openDetailPageFunc) {
            viewModel.openDetailPageFunc();
            VibratorManagerAdapter.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, 'CC');
          } else if (viewModel?.startServiceFunc) {
            viewModel.startServiceFunc();
            VibratorManagerAdapter.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, 'CC');
          }
        })
        .onLabelLongPressOnActionEnd((viewModel: ToggleBaseViewModel) => {
          // 既没有二级页面，也不能跳转应用，长按抬手之后做一键执行的处理
          if (!viewModel?.openDetailPageFunc && !viewModel?.startServiceFunc && viewModel?.handleOneClick) {
            viewModel?.handleOneClick();
          }
        })
    return new ToggleStyle(basicToggleParam, basicToggleEventHandler);
  }

  // 创建带附加内容的开关，例如显示wifi名称的wifi开关
  createTaggedStyle(): ToggleStyle {
    let taggedToggleParam: ToggleParam =
      new ToggleParam()
        .hasLabel(true)
        .fontWeight(this.style.topButtonFontWeight)
        .iconDiameter(this.style.topIconDiameter)
        .canvasDiameter(this.style.topButtonDiameter)
        .iconBgDiameter(this.style.topButtonDiameter)
        .iconBgBorderRadius(this.style.topButtonDiameter / 2)
        .labelWidth(this.style.longButtonWidth - this.style.longButtonLeftMargin * 2 - this.style.topButtonDiameter -
        this.style.longButtonRightMargin)
        .labelHeight($r('app.float.Control_center_long_button_height'))
        .labelFocusable(true)
        .labelAlign(TextAlign.Start)
        .labelWordBreak(WordBreak.BREAK_ALL)
    let taggedToggleHandler: EventHandler =
      new EventHandler()
        .onIconClick((viewModel: ToggleBaseViewModel) => {
          viewModel?.handleOneClick();
        })
        .onIconLongPressOnAction((viewModel: ToggleBaseViewModel, event?: GestureEvent, toggleId?: string) => {
          if (viewModel?.openDetailPageFunc) {
            viewModel.openDetailPageFunc(toggleId);
            VibratorManagerAdapter.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, 'CC');
          }
        })
        .onLabelClick((viewModel: ToggleBaseViewModel, event?: ClickEvent, toggleId?: string) => {
          if (viewModel?.openDetailPageFunc) {
            viewModel.openDetailPageFunc(toggleId);
          }
        })
        .onLabelLongPressOnAction((viewModel: ToggleBaseViewModel, event?: GestureEvent, toggleId?: string) => {
          if (viewModel?.openDetailPageFunc) {
            viewModel.openDetailPageFunc(toggleId);
            VibratorManagerAdapter.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, 'CC');
          }
        })
    return new ToggleStyle(taggedToggleParam, taggedToggleHandler);
  }
}