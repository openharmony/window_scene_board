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
import { LogDomain, Logger, } from '@ohos/basicutils';
import util from '@ohos.util';
import type common from '@ohos.app.ability.common';
import lottie, { AnimationItem, AnimationSegment } from '@ohos/lottie';
import Constants, { VolumeAnimType } from '../common/Constants';
import VolumeComponentStyle from '../common/VolumeComponentStyle';

const TAG = 'VolumeControl-Progress-Canvas';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

@Component
export default struct VolumeProgressCanvasComponent {
  @Prop volumeAnimType: number;
  @Prop @Watch('onVolumeValueChanged') volumeMediaValue: number;
  @Prop isRTL: boolean;
  @Prop volumeIconScale: number;
  @Prop @Watch('onVolumeCanvasVisibleChanged') volumeCanvasVisible: Visibility;
  onVolumeIconTouched: (event?: TouchEvent) => void = () => {};
  private volumeComponentStyle = VolumeComponentStyle.getVolumeComponentStyle();
  private animationJsonName: string = 'lottie_volume_media.json';
  private mainRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.mainRenderingSettings);
  public volumeIndex: number = 0;
  private volumeIconId: string = 'VolumeControl-Progress_Image_icon';
  private animationItem: AnimationItem | undefined = undefined;
  private preVolumeValue: number = Constants.DEFAULT_MAX_VOLUME; // 音量默认最大值
  private lottieData: object | null = null;

  private onVolumeCanvasVisibleChanged(): void {
    log.showInfo(TAG, `onVolumeCanvasVisibleChanged ${this.volumeCanvasVisible}`);
    if (this.volumeCanvasVisible === Visibility.Visible) {
      this.preVolumeValue = this.volumeMediaValue;
      this.getAnimationItem();
    }
  }

  private onVolumeValueChanged(): void {
    log.showInfo(TAG, `onVolumeValueChanged ${this.volumeMediaValue}`);
    this.getAnimationItem();
    this.preVolumeValue = this.volumeMediaValue;
  }

  /* 加载对应的动画 */
  public loadLottieData(jsonName: string, callback: (value: object) => void): void {
    log.showDebug(TAG, 'loadLottieData, jsonName = ' + jsonName);
    let resStr = util.TextDecoder.create('utf-8', {
      ignoreBOM: true
    });
    try {
      let context = getContext(this) as common.UIAbilityContext;
      context.resourceManager.getRawFileContent(jsonName, (err: Error, data: Uint8Array) => {
        if (data === null || data === undefined || data.buffer === undefined) {
          log.showError(TAG, `loadLottieData getRawFile error`);
          return;
        }
        let lottieStr = resStr.decodeWithStream(new Uint8Array(data.buffer));
        let lottieData: object | null = JSON.parse(lottieStr);
        log.showInfo(TAG, `loadLottieData, lottieData: ${jsonName}`);
        if (callback && lottieData !== null) {
          callback(lottieData);
        }
      });
    } catch (err) {
      log.showError(TAG, 'context is undefined');
    }
  }

  /**
   * 获取lottie三档动画的档位数
   * @param value
   * @returns
   */
  private getLottieLevel(value: number) {
    let lottieValue: number;
    if (value > 10) {
      lottieValue = 2;
    } else if (value > 5) {
      lottieValue = 1;
    } else {
      lottieValue = 0;
    }
    return lottieValue;
  }

  /**
   * 播放指定范围的帧动画
   */
  private getAnimationItem() {
    // 面板展开时按键才设置媒体音频图标微缩动效 避免执行无视觉效果动画
    if (this.volumeAnimType === VolumeAnimType.TYPE_KEY_DOWN_THIN ||
      this.volumeAnimType === VolumeAnimType.TYPE_KEY_UP_THIN) {
      return;
    }
    log.showInfo(TAG, `currentValue ${this.preVolumeValue}, ${this.volumeMediaValue}`);
    // 获取当前音量值对应的lottie动画档位数
    let currentValue = this.getLottieLevel(this.volumeMediaValue);
    // 设置媒体图标初始状态
    if (this.preVolumeValue === this.volumeMediaValue) {
      let initKeyFrame = this.volumeMediaValue === 0 ? this.volumeComponentStyle.mediaLottieKeyFrames[currentValue][0] :
      this.volumeComponentStyle.mediaLottieKeyFrames[currentValue][1];
      if (this.isRTL && this.volumeMediaValue === 0) {
        // 处理镜像模式
        initKeyFrame = this.volumeComponentStyle.mediaLottieKeyFrames[Constants.RTL_KEY_FRAMES][0];
      }
      // 通过播放一帧来达到goToAndStop效果，规避playSegments后goToAndStop只能在playSegments指定的范围内操作，超出导致绘制空图标的问题
      this.animationItem?.playSegments([initKeyFrame, initKeyFrame + 1], true);
      return;
    }
    // 获取上一次音量值对应的lottie动画档位数
    const lastValue = this.getLottieLevel(this.preVolumeValue);
    if (currentValue === lastValue && (this.volumeMediaValue !== 0 && this.preVolumeValue !== 0)) {
      return;
    }
    let keyFrames: AnimationSegment;
    // 当前音量 < 上一次音量, 即表示: 减音量
    if (this.volumeMediaValue < this.preVolumeValue) {
      let reverseLevel = this.volumeMediaValue > 0 ? currentValue + 1 : currentValue;
      // 如果当前是镜像模式且音量档位为0, 则用镜像关键帧
      if (this.isRTL && this.volumeMediaValue === 0) {
        reverseLevel = Constants.RTL_KEY_FRAMES;
      }
      keyFrames =
        Array.from(this.volumeComponentStyle.mediaLottieKeyFramesReverse[reverseLevel]) as AnimationSegment;
    } else {
      // 加音量
      if (this.isRTL && currentValue === 0) {
        currentValue = Constants.RTL_KEY_FRAMES;
      }
      keyFrames = this.volumeComponentStyle.mediaLottieKeyFrames[currentValue] as AnimationSegment;
    }
    this.animationItem?.playSegments(keyFrames, true);
  }

  private showLottieData() {
    this.preVolumeValue = this.volumeMediaValue;
    if (this.lottieData) {
      log.showInfo(TAG, 'lottie data is exist');
      this.reloadAnimation().then(() => {
        this.getAnimationItem();
      });
    } else {
      this.loadLottieData(this.animationJsonName, (value) => {
        this.lottieData = value;
        this.reloadAnimation().then(() => {
          this.getAnimationItem();
        });
      })
    }
  }

  async reloadAnimation() {
    if (!this.animationItem) {
      log.showInfo(TAG, `Set animationItem:${this.volumeIconId}`);
      this.animationItem = lottie.loadAnimation({
        container: this.canvasRenderingContext, // 渲染上下文
        renderer: 'canvas', // 渲染方式
        loop: false, // 是否循环播放,默认true
        autoplay: false, // 是否自动播放，默认true
        animationData: this.lottieData, // 播放的动画json数据
        name: this.volumeIconId, // 动画id
      });
    }

    let color: number = Constants.DEFAULT_LOTTIE_ICON_COLOR; // 默认lottie图标颜色
    try {
      color = await getContext(this).resourceManager.getColor($r('app.color.volume_channel_icon_color').id);
    } catch (e) {
      log.error(TAG, `get lottieIconColor failed`, e);
    }
    this.animationItem?.changeColor([
      (color & 0x00FF0000) >> 16,
      (color & 0x0000FF00) >> 8,
      (color & 0x000000FF),
      ((color & 0xFF000000) >>> 24) / 255,
    ]);
  }

  build() {
    Canvas(this.canvasRenderingContext)
      .draggable(false)
      .id(this.volumeIconId)
      .width(Constants.SYMBOL_GLYPH_FONT_SIZE)
      .height(Constants.SYMBOL_GLYPH_FONT_SIZE)
      .scale({
        x: this.isRTL ? -this.volumeIconScale : this.volumeIconScale,
        y: this.volumeIconScale,
        centerX: '50%',
        centerY: '50%'
      })
      .margin({ bottom: Constants.ICON_MARGIN_BOTTOM })
      .hitTestBehavior(HitTestMode.Transparent)
      .renderGroup(true)
      .onReady(() => {
        log.showInfo(TAG, `Canvas onReady:${this.volumeIconId}`);
        this.showLottieData();
      })
      .onDisAppear(() => {
        log.showInfo(TAG, `Canvas disappear:${this.volumeIconId}`);
        lottie.destroy(this.volumeIconId);
        this.animationItem?.destroy();
        this.animationItem = undefined;
        this.lottieData = null;
      })
      .visibility(this.volumeCanvasVisible)
      .onTouch(this.onVolumeIconTouched)
  }
}
