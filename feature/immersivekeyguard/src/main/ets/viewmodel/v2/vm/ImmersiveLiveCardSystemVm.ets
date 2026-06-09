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
import { LiveCardSystemDropdownVm, LiveNotification } from '@ohos/systemuicommon/newIndex';
import { ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmersiveListVm } from '../../../common/interface/IImmersiveListVm';
import { IImmersiveLiveCardSystemVm } from '../../../common/interface/IImmersiveLiveCardSystemVm';
import { IImmersiveLiveVmInjector } from '../../../common/interface/IImmersiveLiveVmInjector';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { ImmListData } from '../../../model/data/v2/ImmListData';
import { slImmBindSt } from '../../../model/data/v2/SlImmBindStateV2';

/**
 * 系统实况卡片业务管理器
 */
@ObservedV2
export class ImmersiveLiveCardSystemVm extends LiveCardSystemDropdownVm implements IImmersiveLiveCardSystemVm {
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

  // 列表条目副文本样式
  @Computed
  get itemContentStyle(): WidgetStyleStateV2 | undefined {
    let helper =  this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.ITEM_CONTENT_STYLE);
    return helper?.getItemSt(this.live.groupKey);
  }

  // 系统实况副文本样式
  @Computed
  get sysContentStyle(): WidgetStyleStateV2 | undefined {
    let helper =  this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.SYS_LIVE_CONTENT_STYLE);
    return helper?.getItemSt(this.live.groupKey);
  }

  // sim卡图标颜色
  @Computed get simIconColor(): Array<ResourceColor> {
    // 与副文本颜色保持一致
    let contentColor = this.itemContentStyle?.getFontColor();
    if (contentColor) {
      return [contentColor];
    }
    return super.simIconColor;
  }

  /**
   * 内容文本提亮参数
   */
  @Computed
  get textForegroundBrightness(): BrightnessOptions | undefined {
    // AOD场景提亮参数
    if (slImmBindSt.isAodMode()) {
      return this.sysContentStyle?.getFgBrightness();
    }
    return super.textForegroundBrightness;
  }

  /**
   * 副文本前景色
   *
   * @returns 前景色
   */
  getSolidTextColor(): ResourceColor | undefined {
    // AOD场景前景颜色
    if (slImmBindSt.isAodMode()) {
      return this.sysContentStyle?.getFgColor();
    }
    return super.getSolidTextColor();
  }

  /**
   * 主标题文本
   * phone计时器AOD场景，固定文本
   *
   * @returns 文本内容
   */
  @Computed get title(): ResourceStr {
    // 隐私场景，优先级更高
    let isPrivacy = this.listItemData?.isDataPrivacy();
    if (isPrivacy) {
      return super.title;
    }
    // phone计时器AOD场景
    let phoneText = this.listItemData?.getPhoneAodText();
    if (phoneText) {
      return phoneText;
    }
    return super.title;
  }

  /**
   * 副文本
   * phone计时器AOD场景，固定文本
   *
   * @returns 文本内容
   */
  @Computed get text(): ResourceStr {
    // 隐私场景，优先级更高
    let isPrivacy = this.listItemData?.isDataPrivacy();
    if (isPrivacy) {
      return super.text;
    }
    // phone计时器AOD场景
    let phoneText = this.listItemData?.getPhoneAodText();
    if (phoneText) {
      return phoneText;
    }
    return super.text;
  }

  /**
   * 副文本是否上树
   * 计时器主文本隐藏时，副文本保持上树
   *
   * @returns true保持上树
   */
  @Computed get isContentAppear(): boolean {
    if (this.isHideTitleText) {
      return true;
    }
    return super.isContentAppear;
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

  protected getItemHelperVm(): IImmItemHelperVm {
    return this.vmInjector?.getImmItemHelperVm();
  }
}