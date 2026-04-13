/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import lottie, { AnimationConfigWithData, AnimationItem } from '@ohos/lottie';
import resourceManager from '@ohos.resourceManager';
import util from '@ohos.util';
import BusinessError from '@ohos.base';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';

const TAG: string = 'JumpingNotes';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

@Component
export default struct JumpingNotes {
  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings)
  private animateItem: AnimationItem | null = null;
  private animateName: string = 'jumpingNotesAnimation'; // 动画名称
  private resourceManager: resourceManager.ResourceManager | undefined = undefined;
  private uiContext: UIContext = this.getUIContext();
  private animData: AnimationConfigWithData | undefined = undefined;
  @State lottieFileName: string = '';
  @State @Watch('playOrPauseAnim') isPlaying: boolean = false;

  playOrPauseAnim() {
    log.showInfo(`isPlaying: ${this.isPlaying}`);
    if (this.isPlaying) {
      this.animateItem?.play();
    } else {
      this.animateItem?.pause();
    }
  }

  // 页面销毁时释放动画资源
  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.animateItem?.removeEventListener('DOMLoaded');
    this.animateItem?.destroy();
    this.animateItem = null;
  }

  async loadAnimation() {
    if (!this.animData) {
      this.animData = await this.getLottieResource();
    }
    this.animateItem = lottie.loadAnimation({
      container: this.canvasRenderingContext,
      renderer: 'canvas', // canvas 渲染模式
      autoSkip: false,
      loop: true,
      autoplay: false,
      name: this.animateName,
      contentMode: 'Contain',
      animationData: this.animData
    })
    // 因为动画是异步加载，所以对animateItem的操作需要放在动画加载完成回调里操作
    this.animateItem.addEventListener('DOMLoaded', (args: Object): void => {
      log.showInfo(`addEventListener`)
      this.playOrPauseAnim();
    });
  }

  private async getLottieResource(): Promise<AnimationConfigWithData> {
    return new Promise<AnimationConfigWithData>((resolve, reject) => {
      try {
        this.resourceManager = this.uiContext.getHostContext()?.resourceManager;
        if (!this.resourceManager) {
          reject(null);
        }
        this.resourceManager?.getRawFileContent(this.lottieFileName).then(value => {
          log.showInfo(`get raw file success: ${this.lottieFileName}`);
          const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
          const retStr = textDecoder.decodeWithStream(value, { stream: false });
          resolve(JSON.parse(retStr));
        }).catch((error: BusinessError.BusinessError) => {
          log.showInfo(`get raw file content fail: ${this.lottieFileName}, err = ${JSON.stringify(error)}`);
          reject(null);
        });
      } catch (err) {
        log.error( `get lottie fail: ${this.lottieFileName}, err=${JSON.stringify(err)}`);
        reject(null);
      } finally {
        if (this.resourceManager) {
          this.resourceManager.release();
        }
      }
    })
  }

  build() {
    Row() {
      // 关联画布
      Canvas(this.canvasRenderingContext)
        .width(16)
        .height(12)
        .backgroundColor(Color.Gray)
        .onReady(() => {
          // 加载动画
          if (this.animateItem != null) {
            // 可在此生命回调周期中加载动画，可以保证动画尺寸正确
            this.animateItem?.resize();
          } else {
            // 抗锯齿的设置
            this.canvasRenderingContext.imageSmoothingEnabled = true;
            this.canvasRenderingContext.imageSmoothingQuality = 'medium';
            this.loadAnimation();
          }
        })
        .backgroundColor(Color.Transparent)
    }
    .backgroundColor(Color.Transparent)
  }
}