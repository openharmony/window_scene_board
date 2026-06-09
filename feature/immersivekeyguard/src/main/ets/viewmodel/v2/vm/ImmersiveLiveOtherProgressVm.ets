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

import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { LiveCardOtherProgressDropdownVm, LiveNotification } from '@ohos/systemuicommon/newIndex';
import { ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmersiveLiveOtherProgressVm } from '../../../common/interface/IImmersiveLiveOtherProgressVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmersiveLiveVmInjector } from '../../../common/interface/IImmersiveLiveVmInjector';

/**
 * 沉浸实况三方卡片进度条业务管理器
 */
@ObservedV2
export class ImmersiveLiveOtherProgressVm extends LiveCardOtherProgressDropdownVm
  implements IImmersiveLiveOtherProgressVm {
  // 业务注入器
  @Trace protected readonly vmInjector: IImmersiveLiveVmInjector;

  // 通用业务注入器
  @Trace protected readonly ntfInjector?: IImmersiveNtfVmInjector;

  constructor(vmInjector: IImmersiveLiveVmInjector, live: LiveNotification) {
    super(vmInjector, live);
    this.vmInjector = vmInjector;
    this.ntfInjector = vmInjector?.getNtfVmInjector();
  }

  // 三方实况扩展区样式
  @Computed
  get liveExtendStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.vmInjector?.getImmItemHelperVm()?.getListStyleH(ListStyleSuffix.OTHER_LIVE_EXTEND_STYLE);
    return helper?.getItemSt(this.live.groupKey);
  }

  // 进度条实况扩展区透明度
  @Computed
  get extendOpacity(): number | undefined {
    return this.liveExtendStyle?.getAlpha();
  }
}