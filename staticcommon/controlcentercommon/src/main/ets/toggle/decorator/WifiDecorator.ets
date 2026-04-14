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
import { VibratorUtil } from '@ohos/systemuiutils/src/main/ets/utils/VibratorUtil';
import { EventHandler, ToggleStyle } from '../interface/ToggleStyle';
import { ToggleBaseViewModel } from '../vm/ToggleBaseViewModel';

export class WifiDecorator {
  decorateEventHandler(style: ToggleStyle): ToggleStyle {
    let wifiHandler: EventHandler =
      new EventHandler()
        .onIconClick((viewModel: ToggleBaseViewModel) => {
          viewModel?.handleOneClick();
        })
        .onIconLongPressOnAction((viewModel: ToggleBaseViewModel) => {
          // 在wifi已经打开的情况下，长按才打开二级页面
          if (viewModel.getViewData().isOn === true && viewModel?.openDetailPageFunc) {
            viewModel.openDetailPageFunc();
            VibratorUtil.startVibration(VibratorUtil.VIBRATION_EFFECT_MEDIUM,
              VibratorUtil.VIBRATION_ATTRIBUTE_LONG_PRESS);
          }
        })
        .onIconLongPressOnActionEnd((viewModel: ToggleBaseViewModel) => {
          if (viewModel?.getViewData().isOn === false) {
            viewModel.handleOneClick();
          }
        })
        .onLabelClick((viewModel: ToggleBaseViewModel) => {
          if (viewModel.getViewData().isOn === true && viewModel?.openDetailPageFunc) {
            viewModel.openDetailPageFunc();
          } else {
            viewModel.handleOneClick();
          }
        })
        .onLabelLongPressOnAction((viewModel: ToggleBaseViewModel) => {
          if (viewModel.getViewData().isOn === true && viewModel?.openDetailPageFunc) {
            viewModel.openDetailPageFunc();
            VibratorUtil.startVibration(VibratorUtil.VIBRATION_EFFECT_MEDIUM,
              VibratorUtil.VIBRATION_ATTRIBUTE_LONG_PRESS);
          }
        })
        .onLabelLongPressOnActionEnd((viewModel: ToggleBaseViewModel) => {
          // 在开关关闭的情况下，长按抬手执行一键执行操作
          if (viewModel?.getViewData().isOn === false) {
            viewModel.handleOneClick();
          }
        })
    if (style) {
      style.eventHandler = wifiHandler;
    }
    return style;
  }
}