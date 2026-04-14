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
import { LiveVmInjector } from '../LiveVmInjector';
import { LiveStyle } from '../constants/LiveStyle';

const TAG = 'LiveHeadsUpFaceLockView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ComponentV2
export struct LiveHeadsUpFaceLockView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  headsUpVm = this.liveVmInjector.getLiveHeadsUpVm();
  colorVm = this.liveVmInjector.getColorVm();
  faceLockVm = this.liveVmInjector.getLiveHeadsUpFaceLockVm();

  aboutToAppear() {
    log.showInfo(`aboutToAppear face lock`);
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear face lock`);
    this.faceLockVm.destroyAnimation();
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Stack() {
      }
      .backgroundColor(this.faceLockVm.backgroundColor ? 'rgba(0, 0, 0, 0.8)' : Color.Black)
      .borderRadius(this.faceLockVm.borderRadius)
      .width('100%')
      .height('100%')
      .backgroundBlurStyle(this.faceLockVm.backgroundColor ? BlurStyle.COMPONENT_ULTRA_THICK : undefined,
        this.faceLockVm.backgroundColor ? {
          colorMode: ThemeColorMode.DARK,
          adaptiveColor: AdaptiveColor.DEFAULT,
          scale: 0.8155
        } : undefined)
      .shadow(this.faceLockVm.backgroundColor ? ShadowStyle.OUTER_DEFAULT_MD : undefined)
      .opacity(this.faceLockVm.opacity)
      .scale({ x: this.faceLockVm.scaleX, y: this.faceLockVm.scaleY })
      Canvas(this.faceLockVm.showCanvasRenderingContext)
        .width(LiveStyle.FACE_LOCK_BANNER_SIZE)
        .height(LiveStyle.FACE_LOCK_BANNER_SIZE)
        .opacity(this.faceLockVm.showOpacity)
        .scale({
          x: this.faceLockVm.showScaleX,
          y: this.faceLockVm.showScaleY,
        })
      Canvas(this.faceLockVm.successCanvasRenderingContext)
        .width(LiveStyle.FACE_LOCK_BANNER_SIZE)
        .height(LiveStyle.FACE_LOCK_BANNER_SIZE)
        .opacity(this.faceLockVm.successOpacity)
        .scale({
          x: this.faceLockVm.successScaleX,
          y: this.faceLockVm.successScaleY,
        })
    }
    .width(this.faceLockVm.width)
    .height(this.faceLockVm.height)
    .translate({ y: this.faceLockVm.translateY })
    .id(this.faceLockVm.componentId)
    .onAppear(() => {
      log.showInfo(`LiveHeadsUpFaceLockView onAppear`);
      this.headsUpVm.onContentAppear();
    })
    .onDisAppear(this.headsUpVm.onContentDisappear)
  }
}