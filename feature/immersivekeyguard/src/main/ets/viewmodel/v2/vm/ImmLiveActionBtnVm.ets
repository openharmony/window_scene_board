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

import { LiveActionButtonDropdownVm, LiveNotification } from '@ohos/systemuicommon/newIndex';
import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmersiveLiveVmInjector } from '../../../common/interface/IImmersiveLiveVmInjector';
import { IImmLiveActionBtnVm } from '../../../common/interface/IImmLiveActionBtnVm';
import { ListStyleSuffix } from '../../../common/constants/ImmListConst';

// 实况action按钮业务
@ObservedV2
export class ImmLiveActionBtnVm extends LiveActionButtonDropdownVm implements IImmLiveActionBtnVm {
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
  @Computed get itemExtDividerStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.vmInjector?.getImmItemHelperVm()?.getListStyleH(ListStyleSuffix.EXT_DIVIDER_STYLE);
    return helper?.getItemSt(this.live?.groupKey);
  }

  // 三方实况扩展区服务按钮样式
  @Computed get itemExtActionStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.vmInjector?.getImmItemHelperVm()?.getListStyleH(ListStyleSuffix.EXT_ACTION_STYLE);
    return helper?.getItemSt(this.live?.groupKey);
  }

  // 分割线透明度
  @Computed get dividerAlpha(): number | undefined {
    return this.itemExtDividerStyle?.getAlpha();
  }

  // 分割线前景提亮
  @Computed get dividerFgBrightness(): BrightnessOptions | undefined {
    return this.itemExtDividerStyle?.getFgBrightness() ?? super.dividerFgBrightness;
  }

  // 服务按钮文本透明度
  @Computed get actionTextAlpha(): number | undefined {
    return this.itemExtActionStyle?.getAlpha();
  }

  // 服务按钮文本颜色
  @Computed get fontColor(): ResourceColor {
    // AOD颜色取值，非AOD复用
    return this.itemExtActionStyle?.getFontColor() ?? super.fontColor;
  }
}