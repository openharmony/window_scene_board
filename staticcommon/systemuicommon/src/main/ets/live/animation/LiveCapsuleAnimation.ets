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
import { AnimateParams, AnimationBase } from '../../animation/AnimationBase';
import curves from '@ohos.curves';
import { LiveVmInjector } from '../LiveVmInjector';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveNotification } from '../model/LiveNotification';
import { ILiveVmInjector } from '../interface/ILiveVmInjector';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'LiveCapsuleAnimation');
const CAPSULE_CURVE = curves.springMotion(0.513, 0.69);

export class LiveCapsuleAnimation extends AnimationBase {
  private live: LiveNotification;
  private vmInjector: ILiveVmInjector;

  constructor(live: LiveNotification, vmInjector: ILiveVmInjector) {
    super(AnimationBase.NAMES.LIVE_CAPSULE_ANIMATION);
    this.vmInjector = vmInjector;
    this.live = live;
  }

  public async updateRemindAnimation(): Promise<void> {
    let capsuleVm = this.vmInjector.getCapsuleVm(this.live);
    let marqueeVm = this.vmInjector.getCapsuleMarqueeVm(this.live);
    let layoutVm = this.vmInjector.getCapsuleListLayoutVm();

    let cmds: AnimateParams[] = [];
    cmds.push({
      duration: 333,
      curve: CAPSULE_CURVE,
      event: () => {
        capsuleVm.offsetX = capsuleVm.fixedOffsetX;
        capsuleVm.width = capsuleVm.fixedWidth;
        marqueeVm.textWidth = marqueeVm.fixedTextWidth;
        marqueeVm.textSize = marqueeVm.textSize;
        marqueeVm.opacity = 1;
        marqueeVm.isRunning = true;
        layoutVm.capsuleListWidth = layoutVm.capsuleListFixedWidth;
      }
    })
    // 更新的时候渐变底板会闪一下
    cmds.push({
      duration: 1,
      curve: Curve.Linear,
      delay: 50,
      event: () => {
        capsuleVm.updateLinearGradient();
      }
    })
    return this.executeAnimation(cmds, 'updateInstant');
  }
}