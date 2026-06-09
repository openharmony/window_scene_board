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
import { GlobalContext } from '@ohos/frameworkwrapper';
import lottie, { AnimationItem, AnimationSegment } from '@ohos/lottie';
import { curves } from '@kit.ArkUI';
import { SliderButtonAnimViewData, SliderButtonViewData, SliderIconViewData } from './SliderButtonViewData';
import { ColorResourceUtils } from '@ohos/systemuicommon/src/main/ets/template/common/ColorResourceUtils';


const TAG = 'Ctrl.SliderLottieViewMode';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const CANVAS_READY_RETRY_TIMEOUT: number = 100;

/**
 * 滑动条lottie图标操作类
 */
export class SliderLottieViewMode {
  private sliderLength: number;
  private readonly forwardSpeed: number = 2;
  private isCanvasReady: boolean = false;
  private lottieData: object | null = null;
  private animationItem?: AnimationItem;
  private sliderIconViewData: SliderIconViewData;
  private sliderButtonViewData: SliderButtonViewData;
  private animData: SliderButtonAnimViewData;
  // lottie动画的总帧数，用于区别animationItem.totalFrames只表示当前播放片段的总帧数
  private totalFrames: number = 0;
  private currentFrame: number = 0;
  private currentSegments: number[] = [0, 0];
  // 是否通过执行lottie动画片段更新icon，区别于跟手逐帧播放
  private updateIconByAnim: boolean = false;
  // 当帧位于动画播放片段的位置(用于通过动画片段刷新icon场景的颜色切换)
  private targetFrameOnSegments: number = 35;
  private colorTool: ColorResourceUtils = new ColorResourceUtils(GlobalContext.getContext().resourceManager);
  private retryCanvasReadyTime: number = 0;
  private retryCanvasReadyTaskId: number = -1;

  constructor(iconViewData: SliderIconViewData, sliderViewData: SliderButtonViewData,
    animData: SliderButtonAnimViewData) {
    this.sliderIconViewData = iconViewData;
    this.sliderButtonViewData = sliderViewData;
    this.animData = animData;
    this.sliderLength = this.sliderButtonViewData.isHorizontal ? this.sliderButtonViewData.sliderWidth :
    this.sliderButtonViewData.sliderHeight;
  }

  public needUpdateIconByAnim(updateIconByAnim: boolean) {
    this.updateIconByAnim = updateIconByAnim;
  }

  public setLottieData(lottieData: object | null) {
    this.lottieData = lottieData;
    log.showInfo(`setLottieData ${this.sliderIconViewData.lottieName}`)
    if (this.isCanvasReady) {
      this.reloadAnim();
    }
  }

  public setCurrentFrame(currentFrame: number) {
    this.currentFrame = currentFrame;
  }

  public getIconViewData(): SliderIconViewData {
    return this.sliderIconViewData;
  }

  public onCanvasReady(retryTime: number = 0) {
    if (retryTime > 3) {
      log.showError(`onCanvasReady, reloadAnim retryTime > 3`);
      return;
    }
    if (this.sliderIconViewData.mainCanvasRenderingContext?.height <= 0 ||
      this.sliderIconViewData.mainCanvasRenderingContext?.width <= 0 ||
      this.sliderIconViewData.mainCanvasRenderingContext?.canvas?.getUniqueId() === undefined) {
      log.showWarn(`onCanvasReady, canvas context size error or UniqueId undefined: retry timeout 100, time=${retryTime}`);
      if (this.retryCanvasReadyTaskId !== -1) {
        clearTimeout(this.retryCanvasReadyTaskId);
      }
      this.retryCanvasReadyTaskId = setTimeout(() => {
        this.retryCanvasReadyTaskId = -1;
        retryTime ++;
        this.onCanvasReady(retryTime);
      }, CANVAS_READY_RETRY_TIMEOUT);
      return;
    }
    this.isCanvasReady = true;
    this.reloadAnim();
    log.showInfo(`onCanvasReady, get total frames: ${this.animationItem?.totalFrames} lottieName: ${this.sliderIconViewData.lottieName}`);
  }

  public onCanvasDisappear() {
    log.showInfo(`canvas disappear: ${this.sliderIconViewData.lottieName}`);
    this.isCanvasReady = false;
    lottie.destroy(this.sliderIconViewData.lottieName);
  }

  private reloadAnim() {
    if (this.isAnimationItemReady()) {
      log.showInfo('AnimationItem is ready or already loaded.');
      return;
    }
    log.showInfo(`reloadAnim initialSegment:${this.sliderIconViewData.initialSegment} lottieName:${this.sliderIconViewData.lottieName}`);
    this.animationItem = lottie.loadAnimation({
      container: this.sliderIconViewData.mainCanvasRenderingContext, // 渲染上下文
      renderer: 'canvas', // 渲染方式
      loop: false, // 是否循环播放,默认true
      autoplay: false, // 是否自动播放，默认true
      packageName: 'com.controlCenter.' + this.sliderIconViewData.lottieName,
      name: this.sliderIconViewData.lottieName,
      animationData: this.lottieData// 播放的动画json数据
    })
    this.animationItem.addEventListener('DOMLoaded', this.domListenerCallback)
    this.animationItem.addEventListener('destroy', (args: Object): void => {
      log.showInfo(`addEventListener destroy, thisName:${this.animationItem?.name}`);
      this.animationItem?.removeEventListener('DOMLoaded', this.domListenerCallback);
      this.animationItem = undefined;
      if (this.isCanvasReady) {
        this.reloadAnim()
      }
    })
  }

  private isAnimationItemReady(): boolean {
    // Check if lottieData is null or canvas is not ready
    if (this.lottieData === null) {
      log.showWarn('lottieData is null, return');
      return true;
    }
    if (this.isCanvasReady === false) {
      log.showWarn('Canvas is not ready, return');
      return true;
    }
    // Check if animationItem is already loaded
    if (this.animationItem?.isLoaded) {
      log.showWarn(`Lottie animation has been loaded, destroy: ${this.sliderIconViewData.lottieName}`);
      lottie.destroy(this.sliderIconViewData.lottieName);
      return true;
    }
    return false;
  }

  private domListenerCallback = (args: Object): void => {
    log.showInfo(`addEventListener DOMLoaded, ${this.animationItem?.name}`);
    this.refreshIcon();
    this.totalFrames = this.animationItem?.totalFrames ?? 100;
    let isSysColor = AppStorage.get('isSysColor') as boolean;
    if (isSysColor) {
      return;
    }
    // 变化颜色
    let isDarkMode: boolean = GlobalContext.getContext().config.colorMode as number === 0;
    let iconColor = isDarkMode ? this.colorTool.getArrayColor($r('app.color.control_center_brightness_sun_write')) :
    this.colorTool.getArrayColor($r('app.color.control_center_brightness_sun_black'));
    log.showInfo('init lottie color isDarkMode:' + isDarkMode);
    this.changeLottieColor(iconColor, false);
  }

  public refreshIcon() {
    if (this.animationItem === undefined) {
      log.showWarn('refresh icon but lottie is undefined, reload');
      this.reloadAnim();
      return;
    }
    log.showInfo(`refreshLottie, sliderUIValue: ${this.animData.uiValue}`);
    if (this.updateIconByAnim) {
      log.showInfo(`refreshLottie, lottieName: ${this.sliderIconViewData.lottieName} updateIconByAnim: ${this.updateIconByAnim}`);
      this.animationItem.goToAndStop(this.currentFrame, true);
    } else {
      this.playCurrentFrame(this.animData.uiValue);
    }
  }

  /**
   * 通过播放指定片段动效更新图标
   */
  public refreshIconAnim(segments: number[]) {
    let targetFrame = segments[1];
    if (targetFrame === this.currentFrame) {
      log.showInfo('targetFrame not change, ' + this.currentFrame);
      return;
    }
    if (this.animationItem === undefined) {
      log.showWarn('refresh icon but lottie is undefined, reload');
      this.reloadAnim();
      return;
    }
    log.showInfo(`refreshIconWithAnim, segments ${segments} `);
    this.targetFrameOnSegments = Math.max(targetFrame - segments[0], 0);
    this.animationItem.setSpeed(this.forwardSpeed);
    this.animationItem.playSegments(segments as AnimationSegment, true);
    this.currentFrame = targetFrame;
    this.currentSegments = segments;
  }

  // 根据currentLoc播放指定帧
  public playCurrentFrame(currentEndPositionX: number): void {
    if (this.animationItem === undefined) {
      log.showWarn('playCurrentFrame but lottie is undefined, reload');
      this.reloadAnim();
      this.currentFrame = 0;
      return;
    }
    currentEndPositionX = Math.ceil(currentEndPositionX);
    let isOver: boolean = currentEndPositionX < 0 || currentEndPositionX > this.sliderLength;
    let result: number = 0;
    // 超出进度条范围
    if (isOver) {
      if (currentEndPositionX < 0) {
        result = this.sliderIconViewData.startFrameIndex -
          Math.abs(currentEndPositionX) *
          this.getFramesPerVpWhenBeforeSun(currentEndPositionX);
      } else {
        result = this.sliderIconViewData.endFrameIndex +
          (currentEndPositionX - this.sliderLength) * this.getFramesPerVpWhenOverSun(currentEndPositionX);
      }
    } else {
      // 在进度条范围内
      result = this.sliderIconViewData.startFrameIndex + currentEndPositionX * this.getFramesPerVp();
    }
    if (result < 0) {
      result = 0;
    } else if (result > this.sliderIconViewData.totalFrames) {
      result = this.sliderIconViewData.totalFrames;
    }
    this.currentFrame = result;
    log.showInfo(`playCurrentFrame to ${result}`)
    this.animationItem.goToAndStop(result, true);
  }

  // 超出进度条范围滑动，需要有越滑越慢效果
  private getFramesPerVpWhenBeforeSun(currentLoc: number): number {
    let frames = this.getFramesPerVp() *
      (1 - curves.initCurve(Curve.EaseOut).interpolate((0 - currentLoc) / 500));
    return frames;
  }

  // 超出进度条范围滑动，需要有越滑越慢效果
  private getFramesPerVpWhenOverSun(currentLoc: number): number {
    let frames = this.getFramesPerVp() *
      (1 - curves.initCurve(Curve.EaseOut).interpolate((currentLoc - this.sliderLength) / 500));
    return frames;
  }

  private getFramesPerVp(): number {
    return (this.sliderIconViewData.endFrameIndex - this.sliderIconViewData.startFrameIndex + 1) / this.sliderLength;
  }

  /**
   * 切换lottie颜色，需要播放到动效结束后的帧
   *
   * @param lottieColor lottie动画颜色
   * @param needReload 是否需要重新刷新lottie
   */
  public changeLottieColor(lottieColor: number[], needReload: boolean = true): void {
    if (this.animationItem === undefined) {
      log.showInfo('changeLottieColor animationItem undefined, return');
      return;
    }
    let startFromZero = this.animationItem.totalFrames === this.totalFrames;
    // 需要先获取当前动画的帧，切换颜色会将动画帧重置到0
    let currentFrame =
      (this.updateIconByAnim && !startFromZero) ? this.targetFrameOnSegments :
        this.animationItem.currentFrame as number;
    if (this.currentSegments[0] !== this.currentSegments[1] && needReload) {
      // 升级23后，片段播放场景需要重新加载音量lottie
      this.reloadAnim();
      return;
    }
    this.animationItem.changeColor(lottieColor);
    this.animationItem.goToAndStop(currentFrame, true);
    log.showInfo(`changeLottieColor currentFrame ${currentFrame}, animationItem.currentFrame ${this.animationItem.currentFrame}, first ${this.animationItem.firstFrame}, segments ${this.currentSegments}`);
  }
}
