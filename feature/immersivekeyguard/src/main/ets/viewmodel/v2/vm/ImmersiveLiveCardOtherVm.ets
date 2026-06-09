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
import { LiveCardOtherDropdownVm, LiveNotification, ResourceVm } from '@ohos/systemuicommon/newIndex';
import { ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { ImmersiveComHelper } from '../../../common/helper/ImmersiveComHelper';
import { IImmersiveListVm } from '../../../common/interface/IImmersiveListVm';
import { IImmersiveLiveCardOtherVm } from '../../../common/interface/IImmersiveLiveCardOtherVm';
import { IImmersiveLiveVmInjector } from '../../../common/interface/IImmersiveLiveVmInjector';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { ImmListData } from '../../../model/data/v2/ImmListData';

/**
 * 沉浸实况三方卡片业务管理器
 */
@ObservedV2
export class ImmersiveLiveCardOtherVm extends LiveCardOtherDropdownVm implements IImmersiveLiveCardOtherVm {
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

  // 三方实况扩展区分割线样式
  @Computed
  get itemExtDividerStyle(): WidgetStyleStateV2 | undefined {
    let helper = this.getItemHelper()?.getListStyleH(ListStyleSuffix.EXT_DIVIDER_STYLE);
    return helper?.getItemSt(this.live?.groupKey);
  }

  // 分割线颜色
  @Computed
  get dividerFgColor(): ResourceColor {
    // AOD取值，非AOD复用
    return this.itemExtDividerStyle?.getFillColor() ?? super.dividerFgColor;
  }

  /**
   * 主标题文本隐藏
   * 计时器文本，AOD场景隐藏
   *
   * @returns true隐藏文本
   */
  @Computed get isHideTitleText(): boolean {
    return this.listItemData?.isHideTitleText() ?? false;
  }

  /**
   * 副文本隐藏
   * 计时器文本，AOD场景隐藏
   *
   * @returns true隐藏文本
   */
  @Computed get isHideContentText(): boolean {
    return this.listItemData?.isHideContentText() ?? false;
  }

  /**
   * 带有计时器的文本
   *
   * @param content 原文本
   * @returns 转换文本
   */
  public getTimerContent(content: string): string {
    if (!(Boolean(content) && ImmersiveComHelper.testTimeRegx(content))) {
      return super.getTimerContent(content);
    }
    // 存在计时器，则判断AOD场景
    let aodText = this.listItemData?.getComTimerAodText();
    if (aodText) {
      return ResourceVm.instance.getString(aodText);
    }
    return super.getTimerContent(content);
  }

  protected getItemHelper(): IImmItemHelperVm | undefined {
    return this.vmInjector?.getImmItemHelperVm();
  }
}