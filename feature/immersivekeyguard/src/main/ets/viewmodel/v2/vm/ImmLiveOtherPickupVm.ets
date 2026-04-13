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
import { LiveCardOtherPickupVm, LiveNotification } from '@ohos/systemuicommon/newIndex';
import { ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { ImmersiveComHelper } from '../../../common/helper/ImmersiveComHelper';
import { IImmersiveListVm } from '../../../common/interface/IImmersiveListVm';
import { IImmersiveLiveVmInjector } from '../../../common/interface/IImmersiveLiveVmInjector';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmLiveOtherPickupVm } from '../../../common/interface/IImmLiveCardOtherPickupVm';
import { ImmListData } from '../../../model/data/v2/ImmListData';

/**
 * 取餐模板扩展区业务
 */
@ObservedV2
export class ImmLiveOtherPickupVm extends LiveCardOtherPickupVm implements IImmLiveOtherPickupVm {
  // 业务注入器
  @Trace protected readonly vmInjector: IImmersiveLiveVmInjector;

  // 通用业务注入器
  @Trace protected readonly ntfInjector?: IImmersiveNtfVmInjector;

  constructor(vmInjector: IImmersiveLiveVmInjector, live: LiveNotification) {
    super(vmInjector, live);
    this.vmInjector = vmInjector;
    this.ntfInjector = vmInjector?.getNtfVmInjector();
  }

  // 列表业务层
  @Computed
  get immListVm(): IImmersiveListVm | undefined {
    return this.ntfInjector?.getImmersiveListVm();
  }

  // 列表条目数据
  @Computed
  get listItemData(): ImmListData | undefined {
    return this.immListVm?.getListData(this.live?.groupKey);
  }

  // 三方实况取餐扩展区副文本样式
  @Computed
  get extContentStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.vmInjector?.getImmItemHelperVm()?.getListStyleH(ListStyleSuffix.EXT_PICKUP_CON_STYLE);
    return helper?.getItemSt(this.live.groupKey);
  }

  // 扩展区副文本字体大小
  @Computed get contentFontSize(): string | number {
    if (!this.isTimerAod()) {
      return super.contentFontSize;
    }
    // 计时器AOD场景，文本大小调整
    let fontSize = this.extContentStyle?.getFontSize();
    if (fontSize) {
      return `${fontSize}vp`;
    }
    return super.contentFontSize;
  }

  // 扩展区副文本字重
  @Computed get contentFontWeight(): FontWeight | number | string {
    if (!this.isTimerAod()) {
      return super.contentFontWeight;
    }
    // 计时器AOD场景，文本字重调整
    let fontWeight = this.extContentStyle?.getFontWeight();
    if (fontWeight) {
      return fontWeight;
    }
    return super.contentFontWeight;
  }

  // 扩展区副文本下划线底部间距
  @Computed get lineMarginBottom(): number {
    if (!this.isTimerAod()) {
      return super.lineMarginBottom;
    }
    // 计时器AOD场景，间距调整
    let marginB = this.extContentStyle?.getMarginB();
    return marginB ?? super.lineMarginBottom;
  }

  private isTimerAod(): boolean {
    if (!this.listItemData?.isTimerAodScene()) {
      return false;
    }
    // 检测原副文本中是否含有计时器
    return Boolean(this.card?.layoutContent) && ImmersiveComHelper.testTimeRegx(this.card?.layoutContent);
  }
}