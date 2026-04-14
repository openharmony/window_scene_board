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
import { LiveCardNavigationDropdownVm, LiveNotification } from '@ohos/systemuicommon/newIndex';
import { ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmersiveLiveNavigationVm } from '../../../common/interface/IImmersiveLiveNavigationVm';
import { IImmersiveLiveVmInjector } from '../../../common/interface/IImmersiveLiveVmInjector';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';

/**
 * 沉浸实况导航卡片业务管理器
 */
@ObservedV2
export class ImmersiveLiveNavigationVm extends LiveCardNavigationDropdownVm implements IImmersiveLiveNavigationVm {
  // 业务注入器
  @Trace protected readonly vmInjector: IImmersiveLiveVmInjector;
  // 通用业务注入器
  @Trace protected readonly ntfInjector?: IImmersiveNtfVmInjector;

  constructor(vmInjector: IImmersiveLiveVmInjector, live: LiveNotification) {
    super(vmInjector, live);
    this.vmInjector = vmInjector;
    this.ntfInjector = vmInjector?.getNtfVmInjector();
  }

  // 条目图标样式
  @Computed get itemIconStyle(): WidgetStyleStateV2 | undefined {
    let styleH = this.getItemHelper()?.getListStyleH(ListStyleSuffix.ITEM_ICON_STYLE);
    return styleH?.getItemSt(this.live.groupKey);
  }

  // 头部导航方向图标反色
  @Computed get imgColorFilter(): ColorFilter | undefined {
    // 父类存在filter，则允许AOD替代
    let superFilter = super.imgColorFilter;
    if (superFilter) {
      return this.itemIconStyle?.getColorFilter() ?? superFilter;
    }
    return superFilter;
  }

  // 底部导航方向图标反色
  @Computed get navDirsColorFilter(): ColorFilter | undefined {
    // 父类存在filter，则允许AOD替代
    let superFilter = super.navDirsColorFilter;
    if (superFilter) {
      return this.itemIconStyle?.getColorFilter() ?? superFilter;
    }
    return superFilter;
  }

  // 导航icon的透明度
  @Computed
  get navDirectionOpacity(): number | undefined {
    return this.itemIconStyle?.getAlpha();
  }

  // 车道图标透明度
  @Computed
  get navDirsOpacity(): number | undefined {
    return this.itemIconStyle?.getAlpha();
  }

  protected getItemHelper(): IImmItemHelperVm | undefined {
    return this.vmInjector?.getImmItemHelperVm();
  }
}