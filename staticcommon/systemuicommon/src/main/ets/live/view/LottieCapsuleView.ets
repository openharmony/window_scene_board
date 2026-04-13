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
import { ILiveCapsuleFaceLockVm, ShowStage } from '../interface/ILiveCapsuleFaceLockVm';
import { ILiveCapsuleVm } from '../interface/ILiveCapsuleVm';
import { LiveVmInjector } from '../LiveVmInjector';
import { LiveNotification } from '../model/LiveNotification';
import { BaseNodeController } from '../../framenode/BaseNodeController';

const TAG = 'LottieCapsuleView';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ComponentV2
export struct LottieCapsuleView {
  @Param @Require param: lottieParam;

  @Computed
  get capsuleVm(): ILiveCapsuleVm {
    return this.param.vmInjector.getCapsuleVm(this.param.live);
  }

  @Computed
  get liveCapsuleFaceLockVm(): ILiveCapsuleFaceLockVm {
    return this.param.vmInjector.getLiveCapsuleFaceLockVm(this.param.live);
  }

  aboutToAppear(): void {
    log.showWarn(`aboutToAppear, hashcode: ${this.param.live.hashCode}`);
  }

  aboutToDisappear(): void {
    log.showWarn(`aboutToDisappear, hashCode: ${this.param.live.hashCode}`);
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Canvas(this.liveCapsuleFaceLockVm.showCanvasRenderingContext)
        .width(this.capsuleVm.capsuleIconWidthPx + 'px')
        .height(this.capsuleVm.capsuleIconWidthPx + 'px')
        .opacity(this.liveCapsuleFaceLockVm.showOpacity)
        .scale({
          x: this.liveCapsuleFaceLockVm.showScaleX,
          y: this.liveCapsuleFaceLockVm.showScaleY,
        })
        .onReady(() => {
          log.showInfo(`onReady for show ${this.liveCapsuleFaceLockVm.showStage}`);
          this.liveCapsuleFaceLockVm.showFaceLock();
        })
      Canvas(this.liveCapsuleFaceLockVm.successCanvasRenderingContext)
        .width(this.capsuleVm.capsuleIconWidthPx + 'px')
        .height(this.capsuleVm.capsuleIconWidthPx + 'px')
        .opacity(this.liveCapsuleFaceLockVm.successOpacity)
        .scale({
          x: this.liveCapsuleFaceLockVm.successScaleX,
          y: this.liveCapsuleFaceLockVm.successScaleY,
        })
        .onReady(() => {
          if (this.liveCapsuleFaceLockVm.showStage === ShowStage.UPDATE) {
            log.showInfo(`onReady for update`);
            this.liveCapsuleFaceLockVm.showFaceLock();
          }
        })
    }
    .clip(true)
    .renderGroup(true)
    .width(this.capsuleVm.capsuleIconWidthPx + 'px')
    .height(this.capsuleVm.capsuleIconWidthPx + 'px')
    .borderRadius('100%')
    .pixelRound({
      start: PixelRoundCalcPolicy.NO_FORCE_ROUND,
      end: PixelRoundCalcPolicy.NO_FORCE_ROUND,
      top: PixelRoundCalcPolicy.NO_FORCE_ROUND,
      bottom: PixelRoundCalcPolicy.NO_FORCE_ROUND,
    })
  }
}

export interface lottieParam {
  live: LiveNotification,
  vmInjector: LiveVmInjector,
}

@Builder
function lottieCapsuleBuilder(param: lottieParam) {
  LottieCapsuleView({ param: param })
}

export class LottieCapsuleViewNode extends BaseNodeController<lottieParam> {
  public constructor(param: lottieParam) {
    super(lottieCapsuleBuilder, param);
  }
}