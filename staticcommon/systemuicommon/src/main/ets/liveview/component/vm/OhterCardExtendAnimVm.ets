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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AnimateParams, AnimationBase } from '../../../animation/AnimationBase';
import { AnimationNames } from '../../../animation/AnimationNames';
import { LiveUseScene } from '../../common/LiveConstants';

const TAG = 'OhterCardExtendAnimVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Observed
export class OhterCardExtendAnimVm extends AnimationBase {
  public static instances: Set<OhterCardExtendAnimVm> = new Set();

  public static getInstanceByScene(hashCode: string, useScene: LiveUseScene): OhterCardExtendAnimVm | undefined {
    let instance: OhterCardExtendAnimVm | undefined;
    for (const item of OhterCardExtendAnimVm.instances) {
      if (item.hashCode === hashCode && item.useScene === useScene) {
        instance = item;
        break;
      }
    }

    return instance;
  }

  public opacity: number = 1;

  private hashCode?: string;

  private useScene?: LiveUseScene;

  constructor() {
    super(AnimationNames.OTHER_CARD_EXTEND_ANIMATION);
  }

  init(hashCode: string, useScene: LiveUseScene): void {
    log.showInfo(`init hash: ${hashCode} useScene: ${useScene}`);
    this.hashCode = hashCode;
    this.useScene = useScene;
    this.setAnimation();
    OhterCardExtendAnimVm.instances.add(this);
  }

  public destroy(): void {
    OhterCardExtendAnimVm.instances.delete(this);
  }

  public reset() {
    this.opacity = 0;
  }

  public setAnimation(delay: number = 0): void {
    this.clearAnimations();
    const cmd: AnimateParams = {
      duration: 200,
      curve: Curve.Friction,
      delay: delay,
      event: () => {
        this.opacity = 1;
      }
    };

    this.addAnimation([cmd]);
  }
}