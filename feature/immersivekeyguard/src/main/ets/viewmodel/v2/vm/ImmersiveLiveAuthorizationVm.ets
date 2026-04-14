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

import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { LiveCardAuthorizationDropdownVm, LiveNotification } from '@ohos/systemuicommon/newIndex';
import { ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmersiveLiveAuthorizationVm } from '../../../common/interface/IImmersiveLiveAuthorizationVm';
import { IImmersiveLiveVmInjector } from '../../../common/interface/IImmersiveLiveVmInjector';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';

/**
 * 沉浸实况卡片授权业务管理器
 */
@ObservedV2
export class ImmersiveLiveAuthorizationVm extends LiveCardAuthorizationDropdownVm
  implements IImmersiveLiveAuthorizationVm {
  // 业务注入器
  @Trace protected readonly vmInjector: IImmersiveLiveVmInjector;

  // 通用业务注入器
  @Trace protected readonly ntfInjector?: IImmersiveNtfVmInjector;

  constructor(vmInjector: IImmersiveLiveVmInjector, live: LiveNotification) {
    super(vmInjector, live);
    this.vmInjector = vmInjector;
    this.ntfInjector = vmInjector?.getNtfVmInjector();
  }

  // 三方实况扩展区分割线样式
  @Computed
  get itemExtDividerStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.vmInjector?.getImmItemHelperVm()?.getListStyleH(ListStyleSuffix.EXT_DIVIDER_STYLE);
    return helper?.getItemSt(this.live?.groupKey);
  }

  // 三方实况扩展区鉴权按钮样式
  @Computed
  get itemExtAuthorStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.vmInjector?.getImmItemHelperVm()?.getListStyleH(ListStyleSuffix.EXT_AUTHOR_STYLE);
    return helper?.getItemSt(this.live?.groupKey);
  }

  // 分割线颜色
  @Computed
  get dividerColor(): ResourceColor {
    return this.itemExtDividerStyle?.getFillColor() ?? super.dividerColor;
  }

  // 分割线透明度
  @Computed
  get dividerOpacity(): number {
    return this.itemExtDividerStyle?.getAlpha() ?? super.dividerOpacity;
  }

  // 按钮文本颜色
  @Computed
  get buttonTextFontColor(): ResourceColor {
    return this.itemExtAuthorStyle?.getFontColor() ?? super.buttonTextFontColor;
  }

  // 描述文本颜色
  @Computed
  get textFontColor(): ResourceColor {
    return this.itemExtAuthorStyle?.getFontColor() ?? super.textFontColor;
  }

  // 按钮文本透明度
  @Computed
  get textOpacity(): number | undefined {
    return this.itemExtAuthorStyle?.getAlpha();
  }

  // 按钮文本提亮度
  @Computed
  get brightness(): number {
    return this.itemExtAuthorStyle?.getBrightness() ?? super.brightness;
  }

  // 按钮文本背景颜色
  @Computed
  get backgroundColor(): ResourceColor | undefined {
    return this.itemExtAuthorStyle?.getBgColor();
  }
}