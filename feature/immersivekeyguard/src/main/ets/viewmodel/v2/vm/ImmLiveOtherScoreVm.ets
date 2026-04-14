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
import { LiveCardOtherScoreVm, LiveNotification } from '@ohos/systemuicommon/newIndex';
import { ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmersiveLiveVmInjector } from '../../../common/interface/IImmersiveLiveVmInjector';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmLiveOtherScoreVm } from '../../../common/interface/IImmLiveCardOtherScoreVm';

/**
 * 比分模板扩展区业务
 */
@ObservedV2
export class ImmLiveOtherScoreVm extends LiveCardOtherScoreVm implements IImmLiveOtherScoreVm {
  // 业务注入器
  @Trace protected readonly vmInjector: IImmersiveLiveVmInjector;

  // 通用业务注入器
  @Trace protected readonly ntfInjector?: IImmersiveNtfVmInjector;

  constructor(vmInjector: IImmersiveLiveVmInjector, live: LiveNotification) {
    super(vmInjector, live);
    this.vmInjector = vmInjector;
    this.ntfInjector = vmInjector?.getNtfVmInjector();
  }

  // 三方实况比分扩展区计时文本样式
  @Computed
  get extTimerStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.vmInjector?.getImmItemHelperVm()?.getListStyleH(ListStyleSuffix.EXT_SCORE_TIMER_STYLE);
    return helper?.getItemSt(this.live.groupKey);
  }

  // 扩展区计时文本宽度
  @Computed get timerContentWidth(): string | number {
    return this.extTimerStyle?.getWidth() ?? super.timerContentWidth;
  }
}