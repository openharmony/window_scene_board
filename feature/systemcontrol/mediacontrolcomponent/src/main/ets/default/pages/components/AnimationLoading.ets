/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved. 2024-2025. All rights reserved.
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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
import lottie, { AnimationItem } from '@ohos/lottie'
import type ctx from '@ohos.app.ability.common';
import resourceManager from '@ohos.resourceManager';
import util from '@ohos.util';
import BusinessError from '@ohos.base';

const TAG: string = 'AnimationLoading';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

@Component
export struct AnimationLoading {
  @Prop deviceId: string | number;
  private resourceManager: resourceManager.ResourceManager | undefined = undefined;
  private fileName: string = 'circle.json';
  private mainRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private mainCanvasRenderingContext: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(this.mainRenderingSettings)
  private animationItem: AnimationItem | null = null;
  private canvasReady = false;
  uiContext: UIContext = this.getUIContext();

  private async getLottieResource(name: string): Promise<Object> {
    return new Promise<Object>((resolve, reject) => {
      try {
        this.resourceManager = this.uiContext.getHostContext()?.resourceManager;
        if (!this.resourceManager) {
          reject(null);
        }
        this.resourceManager?.getRawFileContent(name).then(value => {
          const textDecoder: util.TextDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
          const retStr = textDecoder.decodeWithStream(value, { stream: false });
          resolve(JSON.parse(retStr));
          log.debug(`try sync retStr: ${JSON.stringify(retStr)}`);
        }).catch((error: BusinessError.BusinessError) => {
          reject(null);
        });
      } catch (err) {
        reject(null);
      }
    })
  }

  private async loadAnimation() {
    const jsonData = await this.getLottieResource(this.fileName)
    log.debug(`try sync jsonData: ${JSON.stringify(jsonData)}`);

    if (this.animationItem != null) {
      this.animationItem.destroy()
      this.animationItem = null
    }
    log.debug(`lottie loadAnimation animationItem, ${JSON.stringify(this.animationItem)}`);

    if (this.canvasReady) {
      this.animationItem = lottie.loadAnimation({
        container: this.mainCanvasRenderingContext, // 渲染上下文
        renderer: 'canvas', // 渲染方式
        loop: true, // 是否循环播放,默认true
        autoplay: true, // 是否自动播放，默认true
        animationData: jsonData, // json对象数据
        name: this.deviceId.toString(),
        packageName: 'com.mediaCardLoading',
      });
      this.resourceManager = this.uiContext.getHostContext()?.resourceManager;
      if (!this.resourceManager) {
        return;
      }
      await this.resourceManager?.getColor($r('sys.color.font_emphasize').id).then(
        (value:number) => {
          this.animationItem?.changeColor([
            (value & 0x00FF0000) >> 16,
            (value & 0x0000FF00) >> 8,
            (value & 0x000000FF),
            ((value & 0xFF000000) >>> 24) / 255,
          ]);
        }
      );
      log.debug(`lottie loadAnimation animationItem, ${JSON.stringify(this.animationItem)}`);
    }
  }

  private callPlay() {
    this.animationItem?.play(this.deviceId.toString());
  }

  build() {
    Canvas(this.mainCanvasRenderingContext)
      .width('100%')
      .height('100%')
      .onReady(() => {
        lottie.destroy('loading');
        log.debug(`lottie destroy`);
        this.canvasReady = true;
        this.loadAnimation()
      })
      .onAppear(() => {
        this.callPlay()
      })
      .onDisAppear(() => {
        // 组件移除时，可销毁动画资源
        this.animationItem?.destroy(this.deviceId.toString());
      })
  }
}