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
import { AnimateParams } from '../../animation/AnimationBase';
import { LiveStyle } from '../constants/LiveStyle';
import { ILiveCapsuleLightWaveVm } from '../interface/ILiveCapsuleLightWaveVm';
import { LiveItemBaseVm } from './LiveBaseVm';
import { curves } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'LiveCapsuleLightVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const CAPSULE_LIGHT_WAVE_CURVE = curves.cubicBezierCurve(0.00, 0.00, 0.54, 1.00);
const LIGHT_FINISH_DELAY = 500;

@ObservedV2
export class LiveCapsuleLightWaveVm extends LiveItemBaseVm implements ILiveCapsuleLightWaveVm {
  protected readonly TAG: string = 'LiveCapsuleLightWaveVm';

  @Trace public positionX = -40;
  @Trace public lightShow: boolean = false;
  @Trace public scaleX: number = 1;

  setAnimStartState(offset: number) {
    this.positionX = offset;
  }

  setAnimFinishState() {
    this.lightShow = false;
    this.positionX = -60;
  }

  doWaveAnim(delay: number, lightOffset: number): AnimateParams[] {
    return [
      {
        curve: CAPSULE_LIGHT_WAVE_CURVE,
        duration: 500,
        delay: delay,
        event: () => {
          this.positionX = lightOffset;
        }
      }, {
        curve: Curve.Linear,
        delay: LIGHT_FINISH_DELAY + delay,
        duration: 1,
        event: () => {
          this.setAnimFinishState();
        }
      }
    ];
  }
}
