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
import { LiveCardSystemButtonDropdownVm, LiveNotification } from '@ohos/systemuicommon/newIndex';
import { ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmersiveLiveSysBtnVm } from '../../../common/interface/IImmersiveLiveSysBtnVm';
import { IImmersiveLiveVmInjector } from '../../../common/interface/IImmersiveLiveVmInjector';

/**
 * 沉浸实况系统卡片按钮业务管理器
 */
@ObservedV2
export class ImmersiveLiveSysBtnVm extends LiveCardSystemButtonDropdownVm implements IImmersiveLiveSysBtnVm {
  // 业务注入器
  @Trace protected readonly vmInjector: IImmersiveLiveVmInjector;

  constructor(vmInjector: IImmersiveLiveVmInjector, live: LiveNotification) {
    super(vmInjector, live);
    this.vmInjector = vmInjector;
  }

  @Computed
  get liveButtonStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.vmInjector?.getImmItemHelperVm()?.getListStyleH(ListStyleSuffix.SYS_LIVE_BUTTON_STYLE);
    return helper?.getItemSt(this.live.groupKey);
  }

  @Computed
  get buttonOpacity(): number | undefined {
    return this.liveButtonStyle?.getAlpha();
  }
}