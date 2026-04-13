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

import { ComponentPosition, WidgetAnimStateV2, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { CapTypeChainV2 } from '../../../common/anim/v2/CapTypeChainV2';
import {
  CapAnimScene,
  CapAnimSuffix,
  CapCacheSuffix,
  CapShowType,
  CapStyleSuffix
} from '../../../common/constants/ImmCapConst';
import { IImmersiveCapAnimVm } from '../../../common/interface/IImmersiveCapAnimVm';
import { IImmersiveCapVm } from '../../../common/interface/IImmersiveCapVm';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { ImmCapDataArray } from '../../../model/data/v2/ImmCapDataArray';
import { ImmAnimBaseMgrV2 } from './ImmAnimBaseManagerV2';

/**
 * 沉浸胶囊模块动效管理业务
 */
export class ImmCapAnimMgrV2 extends ImmAnimBaseMgrV2 implements IImmersiveCapAnimVm {
  // 胶囊默认链条，强提醒 > 内容 > 阴影
  private readonly defaultCapChain: CapTypeChainV2 = new CapTypeChainV2(CapShowType.CAP_REMIND)
    .addChain(new CapTypeChainV2(CapShowType.CAP_CONTENT))
    .addChain(new CapTypeChainV2(CapShowType.CAP_SHADOW));

  getDefaultCapChain(): CapTypeChainV2 {
    return this.defaultCapChain;
  }

  getValidCapChain(rootChain?: CapTypeChainV2): CapTypeChainV2 | undefined {
    // 链条类型有效，则认为链条有效
    let tarChain = rootChain;
    while (tarChain) {
      if (this.isCapValid(tarChain?.getCapType())) {
        return tarChain;
      }
      tarChain = tarChain?.getNext();
    }
    return tarChain;
  }

  isCapValid(type: CapShowType): boolean {
    // 存在对应类型数据，则认定类型有效
    return Boolean(this.getCapData()?.getCapData(type));
  }

  isCapRemind(type: CapShowType): boolean {
    return type === CapShowType.CAP_REMIND;
  }

  isCapContent(type: CapShowType): boolean {
    return type === CapShowType.CAP_CONTENT;
  }

  isCapShadow(type: CapShowType): boolean {
    return type === CapShowType.CAP_SHADOW;
  }

  isCapNone(type: CapShowType): boolean {
    return type === CapShowType.CAP_NONE;
  }

  getRootAnimSt(): WidgetAnimStateV2 {
    return this.getCapVm()?.getSlAnimState();
  }

  getItemComAnimSt(type: CapShowType): WidgetAnimStateV2 | undefined {
    let helper = this.getItemHelper()?.getCapAnimH(CapAnimSuffix.ITEM_COMMON_ANIM);
    return helper?.getItemSt(type);
  }

  getItemInnerAnimSt(type: CapShowType): WidgetAnimStateV2 | undefined {
    let helper = this.getItemHelper()?.getCapAnimH(CapAnimSuffix.ITEM_INNER_ANIM);
    return helper?.getItemSt(type);
  }

  getRootStyle(): WidgetStyleStateV2 {
    return this.getCapVm()?.getSlStyleState();
  }

  getItemComStyle(type: CapShowType): WidgetStyleStateV2 | undefined {
    let helper = this.getItemHelper()?.getCapStyleH(CapStyleSuffix.ITEM_COMMON_STYLE);
    return helper?.getItemSt(type);
  }

  getValidItemComStyle(type: CapShowType): WidgetStyleStateV2 {
    // 目标类型无样式，则与阴影胶囊样式保持一致
    let style = this.getItemComStyle(type);
    if (style) {
      return style;
    }
    return this.getItemComStyle(CapShowType.CAP_SHADOW) as WidgetStyleStateV2;
  }

  getRootPos(): ComponentPosition | undefined {
    return this.getCapVm()?.getSlCacheState()?.getWidgetPosition();
  }

  getItemPos(type: CapShowType): ComponentPosition | undefined {
    let helper = this.getItemHelper()?.getCapCacheH(CapCacheSuffix.ITEM_COMMON_CACHE);
    return helper?.getItemSt(type)?.getWidgetPosition();
  }

  getValidItemPos(type: CapShowType): ComponentPosition {
    // 目标类型无位置，则与阴影胶囊位置保持一致
    let pos = this.getItemPos(type);
    if (pos) {
      return pos;
    }
    return this.getItemPos(CapShowType.CAP_SHADOW) as ComponentPosition;
  }

  startLifeCycleAnim(scene?: CapAnimScene): void {
    // 无动效场景
    if (scene === undefined || scene === CapAnimScene.ANIM_NONE) {
      return;
    }
    // 开启生命周期动效
    this.getVmInjector()?.getCapLifeCycleAnimFactory()?.createImmAnim(scene)?.onLifeCycleAnim();
  }

  private getCapData(): ImmCapDataArray | undefined {
    return this.getCapVm()?.getSlCapData();
  }

  private getCapVm(): IImmersiveCapVm {
    return this.getVmInjector()?.getImmersiveCapVm();
  }

  private getItemHelper(): IImmItemHelperVm {
    return this.getVmInjector()?.getImmItemHelperVm();
  }
}