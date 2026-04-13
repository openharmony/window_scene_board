/**
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
import { LiveNotification, LiveCardOtherFlightDropdownVm } from '@ohos/systemuicommon/newIndex';
import { ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmersiveLiveOtherFlightVm } from '../../../common/interface/IImmersiveLiveOtherFlightVm';
import { IImmersiveLiveVmInjector } from '../../../common/interface/IImmersiveLiveVmInjector';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';

/**
 * 沉浸实况三方卡片左右卡片扩展区业务管理器
 */
@ObservedV2
export class ImmersiveLiveOtherFlightVm extends LiveCardOtherFlightDropdownVm implements IImmersiveLiveOtherFlightVm {
  // 业务注入器
  @Trace protected readonly vmInjector: IImmersiveLiveVmInjector;

  // 通用业务注入器
  @Trace protected readonly ntfInjector?: IImmersiveNtfVmInjector;

  constructor(vmInjector: IImmersiveLiveVmInjector, live: LiveNotification) {
    super(vmInjector, live);
    this.vmInjector = vmInjector;
    this.ntfInjector = vmInjector?.getNtfVmInjector();
  }

  // 三方实况扩展区标题样式
  @Computed
  get itemExtTitleStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.vmInjector?.getImmItemHelperVm()?.getListStyleH(ListStyleSuffix.EXT_TITLE_STYLE);
    return helper?.getItemSt(this.live.groupKey);
  }

  // 三方实况扩展区内容样式
  @Computed
  get itemExtContentStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.vmInjector?.getImmItemHelperVm()?.getListStyleH(ListStyleSuffix.EXT_CONTENT_STYLE);
    return helper?.getItemSt(this.live.groupKey);
  }

  // 三方实况扩展区标题文本颜色
  @Computed
  get layoutTitleColor(): ResourceColor | undefined {
    return this.itemExtTitleStyle?.getFontColor() ?? super.layoutTitleColor;
  }

  // 三方实况扩展区内容文本颜色
  @Computed
  get layoutContentColor(): ResourceColor | undefined {
    return this.itemExtContentStyle?.getFontColor() ?? super.layoutContentColor;
  }

  // 航班模板空白文本颜色
  @Computed
  get layoutSpaceTextColor(): ResourceColor {
    return this.itemExtTitleStyle?.getFontColor() ?? super.layoutSpaceTextColor;
  }

  // 航班模板空白边框颜色
  @Computed
  get layoutSpaceTextBorderColor(): ResourceColor {
    return this.itemExtContentStyle?.getFontColor() ?? super.layoutSpaceTextBorderColor;
  }

  // 航班模板中间摘要文本颜色
  @Computed
  get layoutAdditionalTextColor(): ResourceColor {
    return this.itemExtContentStyle?.getFontColor() ?? super.layoutAdditionalTextColor;
  }
}