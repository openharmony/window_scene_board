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

// import { hdsEffect } from '@kit.UIDesignKit';
import { SCBSessionRect, SCBKeyboardManager, PatternAction, SCBKeyboardPanelSession } from '@ohos/windowscene';
import inputMethodUtil from './SCBInputMethodUtil';

const DEFAULT_HEIGHT: string = '800px';
const DEFAULT_WIDTH: number = 1260;
const DEFAULT_POSITION: number = 280;
const THUMB_SCALE: ScaleOptions = { x: 7, y: 6 };

const SCALE_CURVE: string = '0.04, 0.18, 0.20, 1.00';
const OPACITY_CURVE: string = '0.03, 0.32, 0.20, 1.00';
const POSITION_CURVE1: string = '0.00, 0.00, 0.66, 0.82';
const POSITION_CURVE2: string = '0.19, 0.67, 0.50, 1.00';
const SECTOR_MARGIN: number = 120;

/**
 * Keyboard panel sector component for FlowLightMode
 */
@Component
export struct SectorComponent {
  @ObjectLink panelRect: SCBSessionRect;
  @ObjectLink keyboardPanelSession: SCBKeyboardPanelSession;
  private expectedRate: ExpectedFrameRateRange = { expected: 30, min: 30, max: 30 };
  private sectorHeight: number = 0;
  private isDarkMode: boolean = false;
  @State addOpacity: number = 0;
  @State curPosition: number = DEFAULT_POSITION;
  @State curScale: ScaleOptions = { x: 1, y: 1 };
  @Link isShowSector: boolean;

  startAnimation() {
    let pattern = SCBKeyboardManager.getInstance().getPanelSession()?.getPatternOption();
    if (pattern === PatternAction.THUMB) {
      // 拇指模式直接放大，有亮暗变化，不做扇形变化
      this.curScale = THUMB_SCALE;
      this.curPosition = 0;
    } else {
      this.curScale = { x: 1, y: 1 };
      this.curPosition = DEFAULT_POSITION;
      // 扇形动画
      this.getUIContext().animateTo({
        expectedFrameRateRange: this.expectedRate,
        duration: 1600, curve: SCALE_CURVE, onFinish: () => {
          this.curPosition = DEFAULT_POSITION;
          this.curScale = { x: 1, y: 1 };
          this.addOpacity = 0.05;
        }
      }, () => {
        this.curScale = { x: this.panelRect?.width?.getPx() > DEFAULT_WIDTH ? 7.0 : 5.0, y: 4.0 };
      });
      this.getUIContext().animateTo({ expectedFrameRateRange: this.expectedRate, duration: 720,
        curve: POSITION_CURVE1 }, () => { this.curPosition = 0; });
      this.getUIContext().animateTo({ expectedFrameRateRange: this.expectedRate, delay: 880, duration: 500,
        curve: POSITION_CURVE2 }, () => { this.curPosition = -100; });
    }
    // 透明度变化
    this.getUIContext().animateTo({
      expectedFrameRateRange: this.expectedRate, duration: 200, curve: OPACITY_CURVE }, () => {
        this.addOpacity = inputMethodUtil.isDarkImmersive(this.keyboardPanelSession?.keyboardViewMode) ? 0.2 : 0.7;
    });
    this.getUIContext().animateTo({ 
      expectedFrameRateRange: this.expectedRate, delay: 780, duration: 820, curve: Curve.Sharp }, () => {
        this.addOpacity = 0;
        this.isShowSector = false;
    });
  }

  @Builder
  keyboardSectorBuilder() {
    Image($r('app.media.image_blend_mask'))
    .objectFit(ImageFit.Contain)
    .size({ width: '100%', height: DEFAULT_HEIGHT })
    .translate({ x: 0, y: this.curPosition + 'px' })
    .scale(this.curScale)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Stack({ alignContent: Alignment.Bottom }) {
        this.keyboardSectorBuilder()
      }
      .size({ width: '100%', height: (this.sectorHeight - SECTOR_MARGIN) + 'px' })
      .opacity(this.addOpacity)
      .clip(true)
      .onAppear(() => {
        this.startAnimation();
      })
    }
    .size({ width: '100%', height: '100%' })
  }
}