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

import { LiveVmInjector } from '../LiveVmInjector';
// import { Metaball, MetaballAttribute, BallParams } from '@hms.hds.Metaball';
import { ILiveMetaBallVm } from '../interface/ILiveMetaBallVm';
import { StatusBarCapsulePosition } from '../../statusbar/model/StatusBarCapsulePosition';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SystemUICcmConfig } from '../../utils/SystemUICcmConfig';
import { curves } from '@kit.ArkUI';
import { ILiveMetaBallVisibleVm } from '../interface/ILiveMetaBallVisibleVm';
import { ResourceVm } from '../../vm/ResourceVm';

const TAG = 'LiveMetaBallView';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 实况融球组件
 */
@ComponentV2
export struct LiveMetaBallView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;

  @Computed get capsulePosition(): StatusBarCapsulePosition {
    return this.liveVmInjector.getCapsuleListVm().position!;
  }
  @Computed get liveMetaBallVm(): ILiveMetaBallVm {
    return this.liveVmInjector.getMetaBallVm();
  }

  @Computed get liveMetaBallVisibleVm(): ILiveMetaBallVisibleVm {
    return this.liveVmInjector.getMetaBallVisibleVm();
  }

  // private params: BallParams [] = [];

  aboutToAppear(): void {
    log.showInfo(`LiveMetaBallView, aboutToAppear`)
    // this.params = this.liveMetaBallVm.getBallParam(this.capsulePosition);
  }

  aboutToDisappear(): void {
    this.liveMetaBallVm.onDisappear();
    log.showInfo(`LiveMetaBallView, aboutToDisappear`)
  }

  build() {
    // Metaball({
    //   ballParams : this.params,
    //   controller: this.liveMetaBallVm.controller
    // })
    //   .width(this.liveMetaBallVm.getWidth(this.capsulePosition))
    //   .height(this.liveMetaBallVm.getHeight(this.capsulePosition))
    //   .scale({
    //     x: this.liveMetaBallVm.scaleX,
    //     y: this.liveMetaBallVm.scaleY,
    //     centerX: '50%',
    //     centerY: '50%',
    //   })
    //   .position(this.liveMetaBallVm.getPosition(this.capsulePosition))
    //   .translate({ y: this.liveMetaBallVm.offsetY })
    //   .hitTestBehavior(HitTestMode.None)
    //   .onAppear(() => {
    //     log.showInfo(` Metaball on appear`);
    //     this.liveMetaBallVisibleVm.appearPromise?.resolve();
    //     this.liveMetaBallVisibleVm.appearPromise = undefined;
    //   })
    //   .onDisAppear(() => {
    //     log.showInfo(`Metaball on disappear`);
    //   })
    //   .rotate({ y: 1, angle: ResourceVm.instance.isRTL ? 180 : 0 })
  }
}