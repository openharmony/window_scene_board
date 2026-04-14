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

import { CapAnimScene, CapShowType } from '../../../common/constants/ImmCapConst';
import { CapAnimBaseChain } from './CapAnimBaseChain';

/**
 * 胶囊生命周期动效强提醒动效检测器
 */
export class CapAnimRemindChain extends CapAnimBaseChain {
  public checkLifeCycleAnim(): CapAnimScene | undefined {
    // 当前正在强提醒状态，不允许其他强提醒
    if (this.getCapBindSt()?.isCapRemind()) {
      // 下游检测
      return super.checkLifeCycleAnim();
    }
    // 胶囊数据新增场景，排序非内容胶囊，则执行强提醒翻转动效
    let addData = this.getCapCheckList()?.get(CapShowType.CAP_ADD);
    if (addData && addData.getCapShowType() !== CapShowType.CAP_CONTENT) {
      // 标识数据为强提醒数据
      this.getCapCheckList()?.set(CapShowType.CAP_REMIND, addData);
      return CapAnimScene.ANIM_REMIND;
    }
    // 胶囊数据更新场景，排序非内容胶囊，且应用标识强提醒，则执行强提醒翻转动效
    let updateData = this.getCapCheckList()?.get(CapShowType.CAP_UPDATE);
    if (updateData && updateData.getCapShowType() !== CapShowType.CAP_CONTENT &&
      updateData.isRemindShow()) {
      // 标识数据为强提醒数据
      this.getCapCheckList()?.set(CapShowType.CAP_REMIND, updateData);
      return CapAnimScene.ANIM_REMIND;
    }
    // 下游检测
    return super.checkLifeCycleAnim();
  }
}