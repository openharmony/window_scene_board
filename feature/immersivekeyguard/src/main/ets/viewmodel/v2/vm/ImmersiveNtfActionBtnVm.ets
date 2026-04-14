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

import { NotificationActionButtonVm } from '@ohos/notificationcomponent/newIndex';
import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { NormalNotification } from '@ohos/systemuicommon/newTsIndex';
import { ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmersiveNtfActionBtnVm } from '../../../common/interface/IImmersiveNtfActionBtnVm';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';

/**
 * 沉浸列表条目action按钮业务管理
 */
@ObservedV2
export class ImmersiveNtfActionBtnVm extends NotificationActionButtonVm implements IImmersiveNtfActionBtnVm {
  // 业务注入器
  @Trace protected readonly vmInjector: IImmersiveNtfVmInjector;

  constructor(vmInjector: IImmersiveNtfVmInjector, ntf: NormalNotification) {
    super(vmInjector, ntf);
    this.vmInjector = vmInjector;
  }

  @Computed
  get itemExtActionStyle(): WidgetStyleStateV2 | undefined {
    return this.getItemHelperVm()?.getListStyleH(ListStyleSuffix.EXT_ACTION_STYLE)?.getItemSt(this.ntf?.groupKey);
  }

  /**
   * 按钮文本字体颜色
   */
  @Computed
  get fontColor(): ResourceColor | undefined {
    return this.itemExtActionStyle?.getFontColor() ?? super.fontColor;
  }

  /**
   * 按钮文本字体背景提亮参数
   */
  @Computed
  get fontFgBrightness(): BrightnessOptions | undefined {
    return this.itemExtActionStyle?.getFontColor() ? undefined : super.fontFgBrightness;
  }

  /**
   * 按钮文字透明度
   */
  @Computed
  get fontOpacity(): number | undefined {
    return this.itemExtActionStyle?.getAlpha() ?? super.fontOpacity;
  }

  private getItemHelperVm(): IImmItemHelperVm {
    return this.vmInjector?.getImmItemHelperVm();
  }
}