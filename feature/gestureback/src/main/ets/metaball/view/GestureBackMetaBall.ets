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

import { GlobalContext } from '@ohos/frameworkwrapper';
import { SCBScreenProperty } from '@ohos/windowscene';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { GestureBackConstants } from '../../common/GestureBackConstants';
import { GestureBackMetaBallModel } from '../viewmodel/GestureBackMetaBallModel';

const META_BALL_INIT_OPACITY: number = 0.7;
const META_BALL_COLOR: string = '#2E3033';
const ARROW_LINE_CAP: CanvasLineCap = 'round';
const BRIGHTNESS_DARK: string = 'brightness(1.05)';
const BRIGHTNESS_LIGHT: string = 'brightness(0.95)';
const TAG = 'GestureBackMetaBall';

@Observed
export class MetaBallParams {
  public width: number = px2vp(StyleConstants.GESTURE_NAVIGATION_BACK_CANVAS_WIDTH);
  public positionX: number = 0;
}

@Component
export struct GestureBackMetaBall {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D | null = new CanvasRenderingContext2D(this.settings)
  // back融球视图的逻辑处理类
  private metaBallModel: GestureBackMetaBallModel = GestureBackMetaBallModel.getInstance();
  @StorageLink('currColorMode') @Watch('onColorModeChange') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
  // back融球的相关的视图状态变量
  @State metaBallParams: MetaBallParams = this.metaBallModel.metaBallParams;

  aboutToAppear(): void {
    if (this.context) {
      this.metaBallModel.setDrawContext(this.context);
    }
  }

  aboutToDisappear(): void {
    this.context = null;
  }

  private onColorModeChange(): void {
    if (this.context) {
      this.context.filter =
        (this.currColorMode === GestureBackConstants.DARK_COLOR_MODE) ? BRIGHTNESS_DARK : BRIGHTNESS_LIGHT;
    }
  }

  build() {
    Canvas(this.context)
      .onReady(() => {
        if (this.context) {
          this.context.fillStyle = META_BALL_COLOR;
          this.context.lineCap = ARROW_LINE_CAP;
        }
      })
      .position({ x: this.metaBallParams.positionX })
      .width(this.metaBallParams.width)
      .height('100%')
      .opacity(META_BALL_INIT_OPACITY)
      .hitTestBehavior(HitTestMode.None)
      .id(`${TAG}_Canvas`)
  }
}