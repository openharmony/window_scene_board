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
import { LengthMetrics } from '@kit.ArkUI';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import StyleConfiguration, { ToggleBaseComponentStyle } from '@ohos/systemuicommon/src/main/ets/template/common/StyleConfiguration';
import { SingletonHelper } from '@ohos/basicutils';
import { CommonConstants, vibratorMgr } from '@ohos/launchercommon';

export class PCToggleFactory implements AbstractToggleStyleFactory {
  private style: ToggleBaseComponentStyle = StyleConfiguration.getStyle();

  public static getInstance(): PCToggleFactory {
    return SingletonHelper.getInstance(PCToggleFactory, 'PCToggleFactory');
  }

  // 创建基础开关，通常为图标加标题的形式
  createBasicStyle(): ToggleStyle {
    let quickToggleParam: ToggleParam =
      new ToggleParam()
        .hasLabel(true)
        .labelWidth(undefined)
        .iconLabelPadding({
          top: undefined,
          end: undefined
        })
        .iconFocusable(true)
        .iconFocusBoxStrokeWidth(LengthMetrics.vp(2))
        .labelConstraintSize({ maxWidth: this.style.buttonLabelWidth })
        .labelFocusable(false)
        .bgBorderWidth(0)
        .bgBorderColor(Color.Transparent)
        .labelWordBreak(WordBreak.BREAK_WORD)
        .labelPadding({
          top: this.style.buttonLabelPadding
        })
    let basicToggleEventHandler: EventHandler =
      new EventHandler()
        .onIconClick((viewModel: ToggleBaseViewModel) => {
          viewModel?.handleOneClick();
        })
        .onIconLongPressOnAction((viewModel: ToggleBaseViewModel, event?: GestureEvent) => {
          console.log('PC not handle one-click-run through longPress');
          // 按照优先级处理
          if (viewModel?.openDetailPageFunc) {
            viewModel.openDetailPageFunc();
          } else if (viewModel?.startServiceFunc) {
            viewModel.startServiceFunc();
          }
          if (event?.source !== SourceType.Mouse) {
            vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, 'CC');
          }
        })
        .onLabelClick((viewModel: ToggleBaseViewModel) => {
          if (viewModel?.openDetailPageFunc) {
            viewModel.openDetailPageFunc();
          }
        })
        .onLabelLongPressOnAction((viewModel: ToggleBaseViewModel, event?: GestureEvent) => {
          console.log('PC not handle one-click-run through longPress');
          // 按照优先级处理
          if (viewModel?.openDetailPageFunc) {
            viewModel.openDetailPageFunc();
          } else if (viewModel?.startServiceFunc) {
            viewModel.startServiceFunc();
          }
          if (event?.source !== SourceType.Mouse) {
            vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, 'CC');
          }
        })
    let attributes: AttributeModifier<StackAttribute | RowAttribute> = new PCBasicToggleBgStyle();
    return new ToggleStyle(quickToggleParam, basicToggleEventHandler, attributes);
  }

  // 创建带附加内容的开关，例如显示wifi名称的wifi开关
  createTaggedStyle(): ToggleStyle {
    let topToggleParam: ToggleParam =
      new ToggleParam()
        .hasLabel(true)
        .labelAlign(TextAlign.Start)
        .labelWidth(80)
        .labelHeight('100%')
        .labelFocusable(false)
        .fontWeight(this.style.topButtonFontWeight)
        .labelWordBreak(WordBreak.BREAK_WORD)
        .maxFontSize(undefined)
        .minFontSize(undefined)
    let expandedToggleEventHandler: EventHandler =
      new EventHandler()
        .onIconClick((viewModel: ToggleBaseViewModel) => {
          viewModel?.handleOneClick();
        })
        .onIconLongPressOnAction((viewModel: ToggleBaseViewModel, event?: GestureEvent) => {
          if (viewModel?.openDetailPageFunc) {
            viewModel.openDetailPageFunc();
          }
          if (event?.source !== SourceType.Mouse) {
            vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, 'CC');
          }
        })
        .onLabelClick((viewModel: ToggleBaseViewModel) => {
          if (viewModel?.openDetailPageFunc) {
            viewModel.openDetailPageFunc();
          }
        })
        .onLabelLongPressOnAction((viewModel: ToggleBaseViewModel, event?: GestureEvent) => {
          if (viewModel?.openDetailPageFunc) {
            viewModel.openDetailPageFunc();
          }
          if (event?.source !== SourceType.Mouse) {
            vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
              CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, 'CC');
          }
        })
    let attributes: AttributeModifier<StackAttribute | RowAttribute> = new PCExpandedToggleBgStyle();
    // 如果开关有注册定制的style，则优先返回开关定制样式
    return new ToggleStyle(topToggleParam, expandedToggleEventHandler, attributes);
  }
}

export class PCBasicToggleBgStyle implements AttributeModifier<StackAttribute | RowAttribute> {

  private style: ToggleBaseComponentStyle = StyleConfiguration.getStyle();

  applyNormalAttribute(instance: StackAttribute | RowAttribute): void {
    // 属性变化触发apply函数时，变化前已设置并且变化后未设置的属性会恢复为默认值
    instance
      .pointLight(undefined)
      .shadow({
        radius: this.style.toggleIconShadowRadius,
        color: this.style.toggleIconShadowColor,
        offsetY: this.style.toggleIconShadowOffsetY
      })
  }
}

export class PCExpandedToggleBgStyle implements AttributeModifier<StackAttribute | RowAttribute> {

  private style: ToggleBaseComponentStyle = StyleConfiguration.getStyle();

  applyNormalAttribute(instance: StackAttribute | RowAttribute): void {
    // 属性变化触发apply函数时，变化前已设置并且变化后未设置的属性会恢复为默认值
    instance
      .pointLight(undefined)
      .shadow({
        radius: this.style.toggleIconShadowRadius,
        color: this.style.toggleIconShadowColor,
        offsetY: this.style.toggleIconShadowOffsetY
      })
  }
}