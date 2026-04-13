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

import { WAnimProperty, WBaseProperty } from '@ohos/screenlockcommon';
import { WidgetPropertyConfig } from '@ohos/screenlockcommon/Index';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ImmComAnimConfig } from '../../../../model/data/config/ImmComAnimConfig';
import { ChildHybridBaseAnim } from './ChildHybridBaseAnim';

/**
 * 列表过渡胶囊动效中时钟子模块
 * 时钟存在跟手位移时，需要动效复位
 */
export class ChildClockInListToCap extends ChildHybridBaseAnim {
  public buildEndCfg(endCfg: ImmComPtConfig): void {
  }

  public onHybridAnim(animCfg: ImmComAnimConfig): void {
    this.initEndClock(animCfg);
  }

  private initEndClock(animCfg: ImmComAnimConfig): void {
    // 时钟无跟手偏移，无需动效复位
    if (!this.getClockAnimVm()?.hasClockTranY()) {
      return;
    }
    // 时钟跟随主动效复位
    let clockAnimSt = this.getClockAnimVm()?.getClockViewAnimSt();
    // 动效初始配置
    let initCfg = animCfg.getInitCfg();
    initCfg?.bindConfig(this.getClockV1Key(), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, this.animStartScene).addPtState(clockAnimSt));
    // 动效结束配置
    let finishCfg = animCfg.getFinishCfg();
    finishCfg?.bindConfig(this.getClockV1Key(), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, this.animFinishScene).addPtState(clockAnimSt));
    // 主动效终值配置
    let endMainCfg = animCfg.getEndCfg(this.getCfgMainName());
    endMainCfg?.bindConfig(this.getClockV1Key(), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.SCALE_X, 1).bindConfig(WBaseProperty.SCALE_Y, 1)
      .bindConfig(WBaseProperty.TRAN_Y, 0).addPtState(clockAnimSt));
  }
}