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
import { LiveButtonModel } from '@ohos/systemuicommon/newTsIndex';
import { CapShowType, CapStyleSuffix } from '../../../common/constants/ImmCapConst';
import { IImmCapLiveSysBtnVm } from '../../../common/interface/IImmCapLiveSysBtnVm';
import { ImmersiveLiveSysBtnVm } from './ImmersiveLiveSysBtnVm';

// 按钮默认大小
const DEFAULT_SIZE = 10;

/**
 * 沉浸实况系统卡片按钮在胶囊中使用时业务管理器
 */
@ObservedV2
export class ImmCapLiveSysBtnVm extends ImmersiveLiveSysBtnVm implements IImmCapLiveSysBtnVm {
  // 按钮大小控制
  @Computed get buttonSize(): Length {
    return this.btnStyle?.getHeight() ?? DEFAULT_SIZE;
  }

  // 按钮透明度控制
  @Computed get buttonOpacity(): number | undefined {
    return this.btnStyle?.getAlpha();
  }

  // 胶囊按钮样式
  @Computed get btnStyle(): WidgetStyleStateV2 | undefined {
    let styleH = this.vmInjector?.getImmItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_BUTTON_STYLE);
    // 胶囊所有类型的按钮样式一致，用内容胶囊替代
    return styleH?.getItemSt(CapShowType.CAP_CONTENT);
  }

  // 按钮背景颜色
  public getLiveButtonNoBrightnessBgColor(buttonData: LiveButtonModel): ResourceColor | undefined {
    return this.btnStyle?.getBgColor();
  }

  // 按钮背景模糊
  public getButtonBgBrightness(button: LiveButtonModel): BrightnessOptions | undefined {
    return this.btnStyle?.getBgBrightnessInner();
  }
}