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
import { LiveCardOtherExtendDropdownVm, LiveNotification } from '@ohos/systemuicommon/newIndex';
import { LiveExtensionType } from '@ohos/systemuicommon/newTsIndex';
import { ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmersiveLiveOtherExtendVm } from '../../../common/interface/IImmersiveLiveOtherExtendVm';
import { IImmersiveLiveVmInjector } from '../../../common/interface/IImmersiveLiveVmInjector';
import { IImmersiveNtfVmInjector } from '../../../common/interface/IImmersiveNtfVmInjector';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { ImmOtherLiveExtendTapHandler } from '../gesture/ImmOtherLiveExtendTapHandler';

/**
 * 沉浸实况三方卡片扩展辅助区业务管理器
 */
@ObservedV2
export class ImmersiveLiveOtherExtendVm extends LiveCardOtherExtendDropdownVm implements IImmersiveLiveOtherExtendVm {
  // 业务注入器
  @Trace protected readonly vmInjector: IImmersiveLiveVmInjector;

  // 通用业务注入器
  @Trace protected readonly ntfInjector?: IImmersiveNtfVmInjector;

  // 单双击处理器
  private doubleTapHandler: ImmOtherLiveExtendTapHandler = new ImmOtherLiveExtendTapHandler();

  constructor(vmInjector: IImmersiveLiveVmInjector, live: LiveNotification) {
    super(vmInjector, live);
    this.vmInjector = vmInjector;
    this.ntfInjector = vmInjector?.getNtfVmInjector();
  }

  init(): void {
    super.init();
    this.doubleTapHandler.setClickCallback(this.triggerExtendWant);
  }

  destroy(): void {
    super.destroy();
    this.doubleTapHandler.setClickCallback(undefined);
  }

  // 三方卡片扩展辅助区文本样式
  @Computed
  get extViewTextStyle(): WidgetStyleStateV2 | undefined {
    return this.getHelperVm()?.getListStyleH(ListStyleSuffix.OTHER_EXT_VIEW_TEXT_STYLE)?.getItemSt(this.live.groupKey);
  }

  // 三方卡片扩展辅助区文本带wantAgent样式
  @Computed
  get extViewTextWantStyle(): WidgetStyleStateV2 | undefined {
    return this.getHelperVm()?.getListStyleH(ListStyleSuffix.OTHER_EXT_VIEW_WANT_STYLE)?.getItemSt(this.live.groupKey);
  }

  // 三方卡片扩展辅助区按钮样式
  @Computed
  get extViewButtonStyle(): WidgetStyleStateV2 | undefined {
    return this.getHelperVm()?.getListStyleH(ListStyleSuffix.OTHER_EXT_VIEW_BTN_STYLE)?.getItemSt(this.live.groupKey);
  }

  @Computed
  get textColor(): ResourceColor | undefined {
    return this.extViewTextStyle?.getFontColor() ?? super.textColor;
  }

  @Computed
  get fontFgBrightness(): BrightnessOptions | undefined {
    return this.extViewTextStyle?.getFgBrightness() ?? super.fontFgBrightness;
  }

  @Computed
  get opacity(): number | undefined {
    if (this.card.extensionType === LiveExtensionType.CAPSULE_TEXT) {
      return undefined;
    }
    if (this.live.wantAgent) {
      return this.extViewTextWantStyle?.getAlpha() ?? super.opacity;
    }
    return this.extViewTextStyle?.getAlpha() ?? super.opacity;
  }

  @Computed
  get isRenderGroup(): boolean {
    if (this.card.extensionType === LiveExtensionType.CAPSULE_TEXT) {
      return false;
    }
    return this.extViewTextStyle?.isRenderGroup() ?? super.isRenderGroup;
  }

  @Computed
  get buttonBgColor(): ResourceColor | undefined {
    return this.extViewButtonStyle?.getBgColor() ?? super.buttonBgColor;
  }

  @Computed
  get buttonBgBrightness(): BrightnessOptions | undefined {
    return this.extViewButtonStyle?.getBgBrightnessInner() ?? super.buttonBgBrightness;
  }

  @Computed
  get buttonTextOpacity(): number | undefined {
    return this.extViewButtonStyle?.getAlpha() ?? super.buttonTextOpacity;
  }

  @Computed
  get tapGesture(): TapGestureHandler | undefined {
    if (!this.card.extensionWantAgent && !this.live.isCollaNotification) {
      return undefined;
    }
    return new TapGestureHandler().onAction(() => {
      this.doubleTapHandler.requestOnClick();
    });
  }

  private getHelperVm(): IImmItemHelperVm {
    return this.vmInjector?.getImmItemHelperVm();
  }
}