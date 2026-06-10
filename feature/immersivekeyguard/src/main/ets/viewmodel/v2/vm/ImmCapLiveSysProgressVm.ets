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
import { CapShowType, CapStyleSuffix } from '../../../common/constants/ImmCapConst';
import { IImmCapLiveSysProgressVm } from '../../../common/interface/IImmCapLiveSysProgressVm';
import { ImmersiveLiveSysProgressVm } from './ImmersiveLiveSysProgressVm';

// 进度条默认大小
const DEFAULT_SIZE = 10;

/**
 * 沉浸实况系统卡片进度环在胶囊使用时业务管理器
 */
@ObservedV2
export class ImmCapLiveSysProgressVm extends ImmersiveLiveSysProgressVm implements IImmCapLiveSysProgressVm {
  // 进度条大小控制
  @Computed get progressWidth(): Length {
    return this.extensionStyle?.getHeight() ?? DEFAULT_SIZE;
  }

  // 进度条大小控制
  @Computed get progressHeight(): Length {
    return this.extensionStyle?.getHeight() ?? DEFAULT_SIZE;
  }

  // 进度条透明度控制
  @Computed get progressOpacity(): number | undefined {
    return this.extensionStyle?.getAlpha();
  }

  // 胶囊进度条复用扩展区样式
  @Computed get extensionStyle(): WidgetStyleStateV2 | undefined {
    let styleH = this.vmInjector?.getImmItemHelperVm()?.getCapStyleH(CapStyleSuffix.ITEM_EXTENSION_STYLE);
    // 胶囊所有类型的进度条样式一致，用内容胶囊替代
    return styleH?.getItemSt(CapShowType.CAP_CONTENT);
  }
}