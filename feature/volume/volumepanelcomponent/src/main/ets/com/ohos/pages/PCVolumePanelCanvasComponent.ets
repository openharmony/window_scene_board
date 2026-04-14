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
import util from '@ohos.util';
import type common from '@ohos.app.ability.common';
import lottie, { AnimationItem, AnimationSegment } from '@ohos/lottie';
import lazy StyleConfiguration, { VolumePanelComponentStyle } from '../common/PCStyleConfiguration';
import { LengthMetrics } from '@kit.ArkUI';
import { RTLUtil } from '@ohos/componenthelper';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import Constants from '../common/Constants';
import { ColorResourceUtils } from '@ohos/systemuicommon';
import VolumeComponentStyle from '../common/VolumeComponentStyle';
import lazy PanelViewModel, { VolumeViewData } from '../viewmodel/PCVolumePanelViewModel';

const TAG = 'VolumeControl-Panel-Canvas';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export default struct VolumePanelCanvasComponent {
  @Prop @Watch('onVolumeValueChanged') volumeValue: number; // 当前音量
  private mainRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.mainRenderingSettings);
  private style: VolumePanelComponentStyle = StyleConfiguration.getVolumePanelComponentStyle();
  private animationJsonName: string = 'lottie_volume_media.json';
  private lottieData: object | null = null;
  private volumeIconScale: number = 1;
  private volumeIconId: string = 'VolumePanel-Progress_Image_icon';
  private animationItem: AnimationItem | undefined = undefined;
  private preVolumeValue: number = Constants.DEFAULT_MAX_VOLUME; // 上一次音量
  private colorTool: ColorResourceUtils = new ColorResourceUtils(getContext(this).resourceManager);
  private isCanvasReady: boolean = false;
  private volumeComponentStyle: VolumeComponentStyle = VolumeComponentStyle.getVolumeComponentStyle();
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State viewData: VolumeViewData = PanelViewModel.getViewData();
  @StorageLink('VolumeSymbolIcon') volumeSymbolIcon: string | undefined = undefined;

  private onVolumeValueChanged(): void {
    log.showInfo(`onVolumeValueChanged ${this.volumeValue}`);
    this.getAnimationItem();
    this.preVolumeValue = this.volumeValue;
  }

  private showLottieData() {
    this.preVolumeValue = this.volumeValue;
    if (this.lottieData) {
      log.showInfo('lottie data is exist');
      this.reloadAnimation();
    } else {
      this.loadLottieData(this.animationJsonName, (value) => {
        this.lottieData = value;
        this.reloadAnimation();
      })
    }
  }

  async reloadAnimation() {
    if (!this.animationItem) {
      if (this.lottieData === null) {
        log.showWarn('volumeLottieData is null, return');
        return;
      }
      if (!this.isCanvasReady) {
        log.showWarn('canvas is not ready, return');
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
      this.animationItem.addEventListener('DOMLoaded', this.domListenerCallback);
      this.animationItem.removeEventListener('destroy', this.destroyListenerCallback)
      this.animationItem.addEventListener('destroy', this.destroyListenerCallback)
    }
  }

  private domListenerCallback = (args: Object): void => {
    log.showInfo(`addEventListener loaded, name:${this.animationItem?.name}`);
    this.getAnimationItem();
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

  /**
   * 播放指定范围的帧动画
   */
  private getAnimationItem() {
    if (!this.animationItem) {
      log.showWarn('getAnimationItem but lottie is undefined, reloadAnimation');
      this.reloadAnimation();
      return;
    }

    log.showInfo(`currentValue ${this.preVolumeValue}, ${this.volumeValue}`);
    // 获取当前音量值对应的lottie动画档位数
    let currentValue = this.getLottieLevel(this.volumeValue);
    // 1. 初始状态
    if (this.preVolumeValue === this.volumeValue) {
      let initKeyFrame = this.volumeValue === 0 ? 0 :
      this.volumeComponentStyle.mediaLottieKeyFrames[currentValue][1];

      if (initKeyFrame === 0) {
        if (RTLUtil.isRTL()) {
          initKeyFrame = this.volumeComponentStyle.mediaLottieKeyFrames[Constants.RTL_KEY_FRAMES][0];
          this.animationItem?.playSegments([initKeyFrame, initKeyFrame + 1], true);
        } else {
          this.animationItem?.stop();
        }
      } else {
        this.animationItem?.playSegments([initKeyFrame - 1, initKeyFrame], true);
      }
      log.showInfo(`this.preVolumeValue === this.volumeValue ${initKeyFrame}`)
      return;
    }
    // 获取上一次音量值对应的lottie动画档位数
    const lastValue = this.getLottieLevel(this.preVolumeValue);
    if (currentValue === lastValue && (this.volumeValue !== 0 && this.preVolumeValue !== 0)) {
      return;
    }

    let keyFrames: AnimationSegment;
    // 2. 当前音量 < 上一次音量: 减音量
    if (this.volumeValue < this.preVolumeValue) {
      let reverseLevel = this.volumeValue > 0 ? currentValue + 1 : currentValue;
      if (RTLUtil.isRTL() && this.volumeValue === 0) {
        reverseLevel = Constants.RTL_KEY_FRAMES;
      }
      keyFrames = Array.from(this.volumeComponentStyle.mediaLottieKeyFrames[reverseLevel]).reverse() as AnimationSegment;
      log.showInfo(`reducekeyFrames ${keyFrames}`)
      this.animationItem?.setSpeed(2)
    } else {
      // 3. 加音量
      if (RTLUtil.isRTL() && currentValue === 0) {
        currentValue = Constants.RTL_KEY_FRAMES;
      }
      keyFrames = this.volumeComponentStyle.mediaLottieKeyFrames[currentValue] as AnimationSegment;
      log.showInfo(`addkeyFrames ${keyFrames}`)
    }
    if (this.viewData.volumeUIValue < 10) {
      this.animationItem?.changeColor(this.colorTool.getArrayColor($r('app.color.pc_volume_panel_canvas_white')));
    } else {
      this.animationItem?.changeColor(this.colorTool.getArrayColor($r('app.color.pc_volume_panel_canvas_black')));
    }
    this.animationItem?.playSegments(keyFrames, true);
  }

  /**
   * 获取lottie三档动画的档位数
   * @param value
   * @returns
   */
  private getLottieLevel(value: number) {
    let lottieValue: number;
    if (value >= 10) {
      lottieValue = 2;
    } else if (value >= 5) {
      lottieValue = 1;
    } else {
      lottieValue = 0;
    }
    return lottieValue;
  }

  getPrimaryFgOption(): BrightnessOptions | undefined {
    if (this.viewData.volumeUIValue < 10) {
      return this.colorModeViewData.getVolumeForegroundOption(false);
    } else {
      return this.colorModeViewData.getVolumeForegroundOption(true);
    }
  }

  build() {
    if (this.volumeSymbolIcon) {
      SymbolGlyph($r(this.volumeSymbolIcon))
        .draggable(false)
        .id(this.volumeIconId)
        .margin({ start: LengthMetrics.vp(5) })
        .fontSize('18vp')
        .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_OPACITY)
        .renderGroup(true)
        .foregroundBrightness(this.getPrimaryFgOption())
    } else {
      Canvas(this.canvasRenderingContext)
        .draggable(false)
        .id(this.volumeIconId)
        .width(this.style.imageWidth)
        .height(this.style.imageHeight)
        .margin({ start: LengthMetrics.vp(3) })
        .scale({
          x: RTLUtil.isRTL() ? -this.volumeIconScale : this.volumeIconScale,
          y: this.volumeIconScale,
          centerX: '50%',
          centerY: '50%'
        })
        .renderGroup(true)
        .foregroundBrightness(this.getPrimaryFgOption())
        .onReady(() => {
          log.showInfo(`Volume Canvas onReady:${this.volumeIconId}`);
          this.isCanvasReady = true;
          this.showLottieData();
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
}