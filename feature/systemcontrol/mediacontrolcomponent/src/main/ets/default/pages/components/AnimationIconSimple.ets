/*
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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

import lottie, { AnimationConfigWithData, AnimationItem } from '@ohos/lottie';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import resourceManager from '@ohos.resourceManager';
import util from '@ohos.util';
import BusinessError from '@ohos.base';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';

const TAG: string = 'AnimationIconSimple';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

@Component
export default struct AnimationIconSimple {

  @Prop name: string;
  @Prop @Watch('fileSrcUpdate') src: string;
  @Prop active: boolean;
  @Prop @Watch('updateColor') color: number[];
  resourceManager: resourceManager.ResourceManager | undefined = undefined;
  private mainRenderingSettings: RenderingContextSettings | null = new RenderingContextSettings(true);
  private mainCanvasRenderingContext: CanvasRenderingContext2D | null =
    this.mainRenderingSettings ? new CanvasRenderingContext2D(this.mainRenderingSettings) : null;
  @State curFileSrc: string = '';
  @State initDone: boolean = false;
  private curLottieFile: AnimationConfigWithData | undefined;
  private animationItem: AnimationItem | undefined;
  public isTouched = false;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  uiContext: UIContext = this.getUIContext();

  @Prop @Watch('isPlayAnim') isPlaying: boolean;
  @StorageLink('isDarkMode') isDarkMode: boolean = false;
  @StorageLink('isSysColor') isSysColor: boolean = true;

  aboutToAppear() {
    log.debug(`simple icon atp: ${this.name}, fileName=${this.src}, ${JSON.stringify(this.color)}`);
  }

  destroyAnim() {
    log.showInfo(`destroy lottie file ${this.name}`);
    lottie.destroy(this.name);
    this.animationItem = undefined;
    this.curLottieFile = undefined;
  }

  isPlayAnim() {
    if (this.animationItem && !this.isPlaying) {
      log.debug('albumAnim playing pause')
      this.animationItem?.pause(this.name);
    } else if (this.animationItem && this.isPlaying) {
      this.animationItem?.goToAndPlay(0, true, this.name);
    }
  }

  static animDestory(aniName: string): void {
    lottie.destroy(aniName);
    log.debug(`destroy`);
  }

  async fileSrcUpdate() {
    log.debug(`file src update: fileName=${this.src}, curFileSrc=${this.curFileSrc}.`);
    if (!this.src) {
      return;
    }
    if (this.src === this.curFileSrc) {
      return;
    }
    try {
      await this.getLottieResource(this.src)
        .then((value: AnimationConfigWithData) => {
          this.curLottieFile = value;
          this.loadAnim();
        })
    } catch (err) {
      log.error(`failt to get lottie file resource: ${this.src}.`);
    }
  }

  private async getLottieResource(name: string): Promise<AnimationConfigWithData> {
    log.debug('try get lottie: ' + name);
    return new Promise<AnimationConfigWithData>((resolve, reject) => {
      try {
        this.resourceManager = this.uiContext.getHostContext()?.resourceManager;
        if (!this.resourceManager) {
          reject(null);
        }
        this.resourceManager?.getRawFileContent(name).then(value => {
          log.debug(`get raw file success: ${name}`);
          const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
          const retStr = textDecoder.decodeWithStream(value, { stream: false });
          resolve(JSON.parse(retStr));
        }).catch((error: BusinessError.BusinessError) => {
          log.debug(`get raw file content fail: ${name}, err = ${JSON.stringify(error)}`);
          reject(null);
        });
      } catch (err) {
        log.error( `get lottie fail: ${name}, err=${JSON.stringify(err)}`);
        reject(null);
      } finally {
        if (this.resourceManager) {
          this.resourceManager.release();
        }
      }
    })
  }

  loadAnim() {
    log.debug(`load animation: ${this.curFileSrc}`);
    if (!this.curLottieFile) {
      log.error(`lottie file not ready: ${this.curFileSrc}`);
      return;
    }
    this.animationItem = lottie.loadAnimation({
      container: this.mainCanvasRenderingContext,
      renderer: 'canvas',
      loop: true,
      autoplay: false,
      animationData: this.curLottieFile,
      name: this.name,
      packageName: 'com.mediaCardSimple',
    });
    this.updateColor();
    this.initDone = true;
    if (this.isPlaying) {
      this.animationItem?.goToAndPlay(0, true, this.name);
    }
  }

  updateColor() {
    log.debug(`update Color: ${this.curFileSrc}, ${this.color}, ${!!this.animationItem}`);
    if (this.animationItem && this.color) {
      this.animationItem.changeColor(this.color);
    }
  }

  build() {
    Column() {
      Canvas(this.mainCanvasRenderingContext)
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Transparent)
        .onReady(()=>{
          log.debug('canvas on ready: ' + this.initDone);
          log.debug(`onReady: name = ${this.name},currentFile=${this.curFileSrc}`);
          this.fileSrcUpdate();
        })
        .onDisAppear(() => {
          log.showInfo(`canvas on disappear， destroy: ${this.name}`);
          this.destroyAnim();
        })
    }
    .backgroundColor(Color.Transparent)
    .width(34)
    .height(34)
  }
}