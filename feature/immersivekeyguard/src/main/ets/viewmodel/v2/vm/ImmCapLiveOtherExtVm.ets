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
import { ImmersiveLiveOtherExtendVm } from './ImmersiveLiveOtherExtendVm';
import { IImmCapLiveOtherExtVm } from '../../../common/interface/IImmCapLiveOtherExtVm';
import { ImmCapDataArray } from '../../../model/data/v2/ImmCapDataArray';
import { ImmCapData } from '../../../model/data/v2/ImmCapData';
import { CapShowType, CapStyleSuffix } from '../../../common/constants/ImmCapConst';

/**
 * 沉浸实况三方卡片扩展区在胶囊使用时业务管理器
 */
@ObservedV2
export class ImmCapLiveOtherExtVm extends ImmersiveLiveOtherExtendVm implements IImmCapLiveOtherExtVm {
  // 胶囊数据集
  @Computed get capDataArr(): ImmCapDataArray | undefined {
    return this.ntfInjector?.getImmersiveCapVm()?.getSlCapData();
  }

  // 当前胶囊数据
  @Computed get capData(): ImmCapData | undefined {
    return this.capDataArr?.findCapData(this.live?.groupKey);
  }

  // 系统实况按钮样式
  @Computed get sysBtnStyle(): WidgetStyleStateV2 | undefined {
    let styleH = this.vmInjector?.getImmItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_BUTTON_STYLE);
    // 胶囊所有类型的系统按钮样式一致，用内容胶囊替代
    return styleH?.getItemSt(CapShowType.CAP_CONTENT);
  }

  // 扩展区通用样式
  @Computed get extStyle(): WidgetStyleStateV2 | undefined {
    let styleH = this.vmInjector?.getImmItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_EXTENSION_STYLE);
    // 胶囊所有类型的扩展区样式一致，用内容胶囊替代
    return styleH?.getItemSt(CapShowType.CAP_CONTENT);
  }

  // 扩展区文本样式
  @Computed get extTextStyle(): WidgetStyleStateV2 | undefined {
    let styleH = this.vmInjector?.getImmItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_EXT_TEXT_STYLE);
    // 胶囊所有类型的扩展区文本样式一致，用内容胶囊替代
    return styleH?.getItemSt(CapShowType.CAP_CONTENT);
  }

  // 扩展区按钮样式
  @Computed get extBtnStyle(): WidgetStyleStateV2 | undefined {
    let styleH = this.vmInjector?.getImmItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_EXT_BTN_STYLE);
    // 胶囊所有类型的扩展区按钮样式一致，用内容胶囊替代
    return styleH?.getItemSt(CapShowType.CAP_CONTENT);
  }

  // 扩展区宽度(图片按钮形态)
  @Computed get extendWidth(): number | string | undefined {
    return this.extStyle?.getWidth();
  }

  // 扩展区高度
  @Computed get extendHeight(): number | string | undefined {
    return this.extStyle?.getHeight();
  }

  // 扩展区系统按钮大小，保持扩展区大小
  @Computed get buttonLength(): number | string | undefined {
    return this.extStyle?.getHeight();
  }

  // 扩展区通用透明度
  @Computed get opacity(): number | undefined {
    // 扩展区可点击跳转时，使用系统按钮透明度
    if (this.capData?.hasExtWant()) {
      return this.sysBtnStyle?.getAlpha();
    }
    // 其他情况使用扩展区通用透明度
    return this.extStyle?.getAlpha();
  }

  // 扩展区文本宽度
  @Computed get normalTextWidth(): number | string | undefined {
    return this.extTextStyle?.getWidth();
  }

  // 扩展区文本高度
  @Computed get normalTextHeight(): number | string | undefined {
    return this.extTextStyle?.getHeight();
  }

  // 扩展区文本最大字号
  @Computed get normalTextMaxFont(): Length | undefined {
    return this.extTextStyle?.getMaxFontSize();
  }

  // 扩展区文本最小字号
  @Computed get normalTextMinFont(): Length | undefined {
    return this.extTextStyle?.getMinFontSize();
  }

  // 扩展区文本颜色
  @Computed get textColor(): ResourceColor | undefined {
    return this.extTextStyle?.getFontColor();
  }

  // 扩展区文本前景模糊
  @Computed get fontFgBrightness(): BrightnessOptions | undefined {
    return this.extTextStyle?.getFgBrightness();
  }

  // 扩展区按钮背景高度
  @Computed get capsuleButtonHeight(): number | string | undefined {
    return this.extBtnStyle?.getBgHeight();
  }

  // 扩展区按钮背景宽度
  @Computed get capsuleButtonWidth(): Length | undefined {
    return this.extBtnStyle?.getBgWidth();
  }

  // 扩展区按钮背景最大宽度
  @Computed get capsuleButtonMaxWidth(): Length | undefined {
    return this.extBtnStyle?.getBgWidth();
  }

  // 扩展区按钮文本高度
  @Computed get capsuleButtonTextHeight(): number | string | undefined {
    return this.extBtnStyle?.getHeight();
  }

  // 扩展区按钮间距
  @Computed get capsuleButtonTopMargin(): number | undefined {
    return this.extBtnStyle?.getMarginT();
  }

  // 扩展区按钮间距
  @Computed get capsuleButtonLeftMargin(): number | undefined {
    return this.extBtnStyle?.getMarginL();
  }

  // 扩展区按钮背景颜色
  @Computed get buttonBgColor(): ResourceColor | undefined {
    return this.extBtnStyle?.getBgColor();
  }

  // 扩展区按钮背景模糊
  @Computed get buttonBgBrightness(): BrightnessOptions | undefined {
    return this.extBtnStyle?.getBgBrightnessInner();
  }

  // 扩展区按钮文本透明度
  @Computed get buttonTextOpacity(): number | undefined {
    return this.extBtnStyle?.getAlpha();
  }
}