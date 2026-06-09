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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import util from '@ohos.util';
import type common from '@ohos.app.ability.common';
import lottie, { AnimationItem } from '@ohos/lottie';
import { curves, LengthMetrics } from '@kit.ArkUI';
import { RTLUtil } from '@ohos/componenthelper';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import viewModel, { BrightnessProgress, VolumeDraggingViewData } from '../viewModel/BrightnessVM';
import { ColorResourceUtils } from '@ohos/systemuicommon';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/src/main/ets/template/newStyle/BrightnessOptionUtils';

const TAG = 'Brightness-Panel-Canvas';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export default struct BrightnessPanelCanvas {
  private readonly START_FRAME_INDEX: number = 61; // frame
  private readonly END_FRAME_INDEX: number = 300; // frame
  private readonly TOTAL_FRAMES: number = 360; // frame
  private readonly BRIGHTNESS_WIDTH: number = 312 //vp
  // link不会创建新的对象，同时从trace上看，改成link后ViewPU.viewPropertyHasChanged不会在动效中执行，优化动效性能
  @Link @Watch('onBrightnessValueChanged') brightnessValue: number; // 当前亮度
  @State @Watch('onDraggingViewDataChanged') draggingViewData: VolumeDraggingViewData = viewModel.getDraggingViewData();
  @State viewData: BrightnessProgress = viewModel.getViewData();
  @State overSunFrame: number = 0;
  private preBrightUIValue: number = this.BRIGHTNESS_WIDTH;
  private mainRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.mainRenderingSettings);
  private animationJsonName: string = 'lottie_brightness_dark.json';
  private lottieData: object | null = null;
  private volumeIconScale: number = 1;
  private volumeIconId: string = 'SCBBrightness_Panel_Image_icon';
  private animationItem: AnimationItem | undefined = undefined;
  private isCanvasReady: boolean = false;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private colorTool: ColorResourceUtils = new ColorResourceUtils(getContext(this).resourceManager);

  // 亮度调节范围内
  private onBrightnessValueChanged(): void {
    if (this.viewData.brightnessUIValue < 10) {
      this.animationItem?.changeColor(this.colorTool.getArrayColor($r('app.color.brightness_sun_white')));
    } else {
      this.animationItem?.changeColor(this.colorTool.getArrayColor($r('app.color.brightness_sun_black')));
    }
    log.showInfo(`onBrightnessValueChanged ${this.brightnessValue}, ${this.viewData.brightnessUIValue}`);
    this.playCurrentFrame(this.viewData.brightnessUIValue);
    this.preBrightUIValue = this.viewData.brightnessUIValue;
  }

  // 亮度调节范围外
  private onDraggingViewDataChanged(): void {
    let isOver: boolean = !(this.draggingViewData.currentEndPositionX >= 0 &&
      this.draggingViewData.currentEndPositionX <= this.BRIGHTNESS_WIDTH);

    if (isOver) {
      if (!this.draggingViewData.isDragging) { // 1. 松手
        // 超出亮度条范围 并松手触发回弹动效
        if (this.draggingViewData.currentEndPositionX < 0) {
          this.scrollBeforeSun();
        } else if (this.draggingViewData.currentEndPositionX > this.BRIGHTNESS_WIDTH) {
          this.scrollAfterSun();
        }
      } else { // 2. 拖动
        this.playCurrentFrame(this.draggingViewData.currentEndPositionX);
      }
      log.showInfo(`onDraggingViewDataChanged ${this.draggingViewData.isDragging}, ${this.draggingViewData.currentEndPositionX}`);
    }
  }

  public showLottieData() {
    this.preBrightUIValue = this.viewData.brightnessUIValue;
    if (this.lottieData) {
      log.showInfo('lottie data is exist');
      this.reloadAnimation()
    } else {
      this.loadLottieData(this.animationJsonName, (value) => {
        this.lottieData = value;
        this.reloadAnimation()
      })
    }
  }

  // 当前动效
  private playCurrentFrame(currentEndPositionX: number): void {
    if (!this.animationItem) {
      log.showWarn('getAnimationItem but lottie is undefined, reloadAnimation');
      this.reloadAnimation();
      return;
    }

    let preBrightUIValue: number = Math.ceil(this.preBrightUIValue);
    currentEndPositionX = Math.ceil(currentEndPositionX);
    let result: number = 0;
    let preResult: number = 0;
    let isOver: boolean = !(currentEndPositionX >= 0 && currentEndPositionX <= this.BRIGHTNESS_WIDTH);
    log.showInfo(`playCurrentFrame: ${preBrightUIValue}; ${currentEndPositionX}`);

    // 超出亮度条范围
    if (isOver) {
      if (currentEndPositionX < 0) {
        result = this.START_FRAME_INDEX -
          Math.abs(currentEndPositionX) * this.getFramesPerVpWhenBeforeSun(currentEndPositionX);
        if (result <= 0) {
          result = 0;
        }
        this.animationItem?.playSegments([result + 1, result], true);
      } else {
        result = this.END_FRAME_INDEX +
          (currentEndPositionX - this.BRIGHTNESS_WIDTH) * this.getFramesPerVpWhenOverSun(currentEndPositionX);
        if (result >= this.TOTAL_FRAMES) {
          result = this.TOTAL_FRAMES;
        }
        this.animationItem?.playSegments([result - 1, result], true);
      }
      log.showInfo(`isOver, ${result}`);
      this.overSunFrame = result;
      return;
    } else { // 亮度条范围内
      preResult = this.START_FRAME_INDEX + preBrightUIValue * this.getFramesPerVp();
      result = this.START_FRAME_INDEX + currentEndPositionX * this.getFramesPerVp();
      this.animationItem?.setSpeed(6);
      this.animationItem?.playSegments([preResult, result], true);
    }
  }

  private getFramesPerVp(): number {
    return (this.END_FRAME_INDEX - this.START_FRAME_INDEX + 1) / this.BRIGHTNESS_WIDTH;
  }

  // 超出亮度条范围滑动，需要有越滑越慢效果
  private getFramesPerVpWhenBeforeSun(currentLoc: number): number {
    let frames = this.getFramesPerVp() *
      (1 - curves.initCurve(Curve.EaseOut).interpolate((0 - currentLoc) / 500));
    return frames;
  }

  // 超出亮度条范围滑动，需要有越滑越慢效果
  private getFramesPerVpWhenOverSun(currentLoc: number): number {
    let frames = this.getFramesPerVp() *
      (1 - curves.initCurve(Curve.EaseOut).interpolate((currentLoc - this.BRIGHTNESS_WIDTH) / 500));
    return frames;
  }

  // 回弹动效 BeforeSun
  public scrollBeforeSun() {
    this.animationItem?.setSpeed(6);
    // 当playSegments起点和终点一致的时候会播放整段动画
    if (this.overSunFrame === this.START_FRAME_INDEX) {
      return;
    }
    this.animationItem?.changeColor(this.colorTool.getArrayColor($r('app.color.brightness_sun_white')));
    this.animationItem?.playSegments([this.overSunFrame, this.START_FRAME_INDEX], true);
  }

  // 回弹动效 AfterSun
  public scrollAfterSun() {
    this.animationItem?.setSpeed(6);
    // 当playSegments起点和终点一致的时候会播放整段动画
    if (this.overSunFrame === this.END_FRAME_INDEX) {
      return;
    }
    this.animationItem?.changeColor(this.colorTool.getArrayColor($r('app.color.brightness_sun_black')));
    this.animationItem?.playSegments([this.overSunFrame, this.END_FRAME_INDEX], true);
  }

  async reloadAnimation() {
    if (!this.animationItem) {
      if (this.lottieData === null) {
        log.showInfo('sunLottieData is null, return');
        return;
      }
      if (!this.isCanvasReady) {
        log.showInfo('canvas is not ready, return');
        return;
      }
      log.showInfo(`Set animationItem:${this.volumeIconId}`);
      lottie.destroy(this.volumeIconId);
      this.animationItem = lottie.loadAnimation({
        container: this.canvasRenderingContext, // 渲染上下文
        renderer: 'canvas', // 渲染方式
        loop: false, // 是否循环播放,默认true
        autoplay: false, // 是否自动播放，默认true
        animationData: this.lottieData, // 播放的动画json数据
        name: this.volumeIconId, // 动画id
      });

      // 因为动画是异步加载，所以对animateItem的操作需要放在动画加载完成回调里操作
      this.animationItem.addEventListener('DOMLoaded', this.domListenerCallback)
      this.animationItem.removeEventListener('destroy', this.destroyListenerCallback)
      this.animationItem.addEventListener('destroy', this.destroyListenerCallback)
    }
  }

  private domListenerCallback = (args: Object): void => {
    log.showInfo(`addEventListener loaded, name:${this.animationItem?.name}`);
    this.playCurrentFrame(this.viewData.brightnessUIValue);
  }

  private destroyListenerCallback = (args: Object): void => {
    log.showInfo(`addEventListener destroy, name:${this.animationItem?.name}`);
    this.animationItem?.removeEventListener('DOMLoaded', this.domListenerCallback)
    this.animationItem = undefined;
    if (this.isCanvasReady) {
      this.reloadAnimation();
    }
  }

  /* 加载对应的动画 */
  public loadLottieData(jsonName: string, callback: (value: object) => void): void {
    log.showDebug('loadLottieData, jsonName = ' + jsonName);
    let resStr = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    try {
      let context = getContext(this) as common.UIAbilityContext;
      context.resourceManager.getRawFileContent(jsonName, (err: Error, data: Uint8Array) => {
        if (data === null || data === undefined || data.buffer === undefined) {
          log.showError(`loadLottieData getRawFile error`);
          return;
        }
        let lottieStr = resStr.decodeWithStream(new Uint8Array(data.buffer));
        let lottieData: object | null = JSON.parse(lottieStr);
        log.showInfo(`loadLottieData, lottieData: ${jsonName}`);
        if (callback && lottieData !== null) {
          callback(lottieData);
        }
      });
    } catch (err) {
      log.showError('context is undefined');
    }
  }

  getPrimaryFgOption(): BrightnessOptions | undefined {
    if (this.viewData.brightnessUIValue < 10) {
      return BrightnessOptionUtils.getInstance().foregroundPrimaryOptionOnBackgroundDark;
    } else {
      return BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight;
    }
  }

  build() {
    Canvas(this.canvasRenderingContext)
      .draggable(false)
      .id(this.volumeIconId)
      .width($r('app.float.brightness_image_width'))
      .height($r('app.float.brightness_image_height'))
      .margin({ start: LengthMetrics.vp(10) })
      .scale({
        x: RTLUtil.isRTL() ? -this.volumeIconScale : this.volumeIconScale,
        y: this.volumeIconScale,
        centerX: '50%',
        centerY: '50%',
      })
      .renderGroup(true)
      .foregroundBrightness(this.getPrimaryFgOption())
      .onReady(() => {
        log.showInfo(`Volume Canvas onReady:${this.volumeIconId}`);
        this.showLottieData();
        this.isCanvasReady = true;
      })
      .onDisAppear(() => {
        log.showInfo(`Volume Canvas disappear:${this.volumeIconId}`);
        lottie.destroy(this.volumeIconId);
        this.animationItem?.destroy();
        this.animationItem?.removeEventListener('destroy', this.destroyListenerCallback)
        this.animationItem = undefined;
        this.lottieData = null;
        this.isCanvasReady = false;
      })
  }
}