/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import util from '@ohos.util';
import lottie, { AnimationConfigWithData, AnimationItem } from '@ohos/lottie';
import resourceManager from '@ohos.resourceManager';
import BusinessError from '@ohos.base';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import BrightnessUtils, { BrightnessTypeEnum } from '../../Util/BrightnessUtils'

const TAG: string = 'AnimationIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
let idCounter = 0;
const lottieFilePool: Map<string, AnimationConfigWithData> = new Map();

interface AnimationFileName {
  in: string,
  out?: string,
}

export class AnimationIconController {
  private instance: AnimationIcon | null = null;
  private resourceManager: resourceManager.ResourceManager | null = null;
  private fileName: AnimationFileName = {in: '', out: ''};
  private hasInit: boolean = false;
  private fileMap: Map<string, object> = new Map();
  private isTouched = false;
  private isLastIn: boolean = false;
  private darkLayer: Map<string, number> | undefined;
  private isOnlyOnTouch: boolean = false;
  private isNeedForceUpdate: boolean = false;

  public release() {
    this.instance = null;
    this.fileMap.clear();
    this.darkLayer?.clear();
  }

  public setInstance(instance: AnimationIcon) {
    this.instance = instance;
    this.syncInfo();
  }

  public setForceUpdate() {
    log.debug(`setForceUpdate update call[${this.instance?.name}] `);
    this.isNeedForceUpdate = true;
    this.isTouched = false;
  }

  public setTouched(isTouched = true) {
    this.isTouched = isTouched;
    log.debug(`setTouched ${this.isTouched} call[${this.instance?.name}]`);
  }

  public resetTouched() {
    this.isTouched = false;
  }

  public call(isIn: boolean = true, needRefresh: boolean = false) {
    log.debug(`start call[${this.instance?.name}]: isIn=${isIn}, isLastIn=${this.isLastIn}, ${this.isTouched}`);
    if (this.isLastIn === isIn && this.fileName?.out && !this.isNeedForceUpdate) {
      return;
    }

    this.isLastIn = isIn;
    this.isNeedForceUpdate = false;
    if (!this.hasInit) {
      return;
    }
    const anim = this.getAnim(isIn);
    if (!this.isTouched && this.fileName?.out) {
      this.instance?.reload(anim);
    } else if (!needRefresh) {
      // 下一个动画文件
      const nextAnim = this.fileName?.out ? this.getAnim(!isIn) : '';
      this.instance?.playAnim(anim, nextAnim);
    } else {
      this.instance?.playAnim(anim);
    }
    if (this.isOnlyOnTouch && this.instance) {
      this.isTouched = false;
      this.instance.isTouched = false;
    }
  }

  /**
   * init controller with lottie file name list
   * @param fileName file or files in directory, eg: 'resources/rawfile/data.json' => 'data.json'
   * @param isIn init status when file is more than one, default is first file
   */
  public async init(fileName: AnimationFileName, isIn = true, darkLayer?: Map<string, number>, onlyOnTouch = false) {
    if (this.hasInit && JSON.stringify(fileName) === JSON.stringify(this.fileName)) {
      return;
    }
    log.debug(`start init animation controller: ${isIn}`);
    if (!fileName) {
      log.error('animation init fail: invalid file name');
      return;
    }
    this.isLastIn = isIn;
    this.darkLayer = darkLayer;
    this.isOnlyOnTouch = onlyOnTouch;
    this.fileName = fileName;
    const fileMap: Map<string, Object> = new Map();
    const files = [fileName.in, fileName.out];
    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      if (!file) {
        continue;
      }
      if (lottieFilePool[file]) {
        fileMap[file] = lottieFilePool[file];
      } else {
        await this.getLottieResource(file)
          .then((value: Object) => {
            fileMap[file] = value;
            lottieFilePool[file] = value;
          });
      }
    }
    this.fileMap = fileMap;
    this.hasInit = true;
    this.syncInfo();
  }

  syncInfo() {
    log.debug( `try sync settings: ${!!this.instance}, ${this.hasInit}`);
    if (this.instance && this.hasInit) {
      this.instance.darkLayer = this.darkLayer;
      this.instance.fileMap = this.fileMap;
      log.debug(`try sync anim settings[${this.instance.name}]: ${this.getAnim(this.isLastIn)}, isLastIn=${this.isLastIn}`);
      this.instance.currentFile = this.getAnim(this.isLastIn);
      this.instance?.reload(this.instance.currentFile);
      this.instance.lottiePlay = this.fileMap[this.instance.currentFile];
      this.instance.initDone = true;
    }
  }

  private getAnim(isIn: boolean) {
    if (!this.fileName?.out) {
      return this.fileName?.in;
    }
    if (this.isTouched) {
      return isIn ? this.fileName.in : this.fileName.out;
    } else {
      return isIn ? this.fileName.out : this.fileName.in;
    }
  }

  private async getLottieResource(name: string): Promise<Object> {
    log.debug('try get lottie: ' + name);
    return new Promise<Object>((resolve, reject) => {
      try {
        let context = getContext(this);
        this.resourceManager = context.resourceManager;
        this.resourceManager.getRawFileContent(name).then(value => {
          const textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
          const retStr = textDecoder.decodeWithStream(value, { stream: false });
          resolve(JSON.parse(retStr));
        }).catch((error: BusinessError.BusinessError) => {
          log.error(`get raw file content fail: ${name}, err =`, error);
          reject(null);
        });
      } catch (err) {
        log.error(`get lottie fail: ${name}, err=`, err);
        reject(null);
      }
    })
  }
}

@Component
export default struct AnimationIcon {
  private isPC: boolean = DeviceHelper.isPC();
  public controller: AnimationIconController | undefined;
  public darkLayer: Map<string, number> | undefined;
  public lottiePlay: Object | undefined;
  public isTouched = false;
  public name = '';
  @Link active: boolean;
  @Prop @Watch('colorChange') color: number[];
  @Prop iconTypeKey: string = 'card';
  @State fileMap: Map<string, Object> = new Map();
  @State currentFile: string = '';
  @State nextFile: string = ''; // 下一个动画文件，用于重置lottie动画
  @State @Watch('initDoneAction') initDone: boolean = false;
  private mainRenderingSettings: RenderingContextSettings | null = new RenderingContextSettings(true);
  private mainCanvasRenderingContext: CanvasRenderingContext2D | null =
    this.mainRenderingSettings ? new CanvasRenderingContext2D(this.mainRenderingSettings) : null;
  private animationItem: AnimationItem | undefined = undefined;
  private canvasReady = false;
  @StorageLink('isMarkingRenderGroupOfControl') isMarkingRenderGroupOfControl: boolean = false; // 增加UI缓存，防止丢帧
  @Prop isDarkMode: boolean = false;
  @StorageLink('isSysColor') isSysColor: boolean = true;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Prop isAod: boolean | undefined = false;
  private isDestroyed = false;

  colorChange() {
    log.debug(`color changes-${this.name}-${this.color}, ${this.currentFile}, ${!!this.animationItem}`);
    if (!this.animationItem) {
      return;
    }
    if (!this.animationItem.isPaused) {
      return;
    }
    log.debug(`color changes success`);
    const currentFrame: number = this.animationItem.currentFrame;
    const targetLayer: number = this.darkLayer?.get(this.currentFile) || 0;
    this.animationItem.changeColor(this.color, targetLayer);
    this.animationItem.goToAndStop(currentFrame, true);
  }

  aboutToAppear() {
    this.name = `${this.iconTypeKey}-lottie-${idCounter++}`;
    if (this.controller) {
      this.controller.setTouched(false);
      this.controller.setInstance(this);
    }
    log.debug(`animation icon inited: ${this.name}, ${this.currentFile}, ${this.active}`);
  }

  aboutToDisappear(): void {
    if (this.controller) {
      this.controller = undefined;
    }
    // 删除引用关系，释放内存
    this.mainCanvasRenderingContext = null;
    this.mainRenderingSettings = null;
    this.isDestroyed = true;
    lottie.destroy(this.name);
  }

  initDoneAction() {
    if (this.canvasReady) {
      this.refresh('initDone');
    }
  }

  async refresh(from: string) {
    log.debug(`load animation name:${this.name}, ${this.currentFile}, from=${from}, canvasReady=${this.canvasReady}`);
    if (!this.canvasReady) {
      return;
    }
    let item = await this.loadAnimationInner(this.name, this.lottiePlay);
    item.setSpeed(1);
    this.setDarkMode(item);
    if (!this.isDestroyed) {
      this.animationItem = item;
    } else {
      log.showError(`release animationicon after isDestoryed`);
      lottie.destroy(this.name);
    }
  }

  async loadAnimationInner(animName: string, lottiePlay: Object | undefined): Promise<AnimationItem> {
    return new Promise<AnimationItem>((resolve, reject) => {
      const item: AnimationItem = lottie.loadAnimation({
        container: this.mainCanvasRenderingContext,
        renderer: 'canvas',
        loop: false,
        autoplay: false,
        animationData: lottiePlay,
        packageName: 'com.mediaCard',
        name: animName,
      });
      item.addEventListener('DOMLoaded', (args: Object): void => {
        resolve(item);
      });
    });
  }

  setDarkMode(item: AnimationItem) {
    if (!item?.isPaused) {
      return;
    }
    log.debug(`AnimationIcon setDarkMode color=${this.color}`);
    const currentFrame: number = item.currentFrame;
    const targetLayer: number = this.darkLayer?.get(this.currentFile) || 0;
    item.changeColor(this.color, targetLayer);
    item.goToAndStop(currentFrame, true);
  }

  getBrightness() {
    if (this.isSysColor && !this.isAod) {
      if (this.iconTypeKey === 'item') {
        return this.isDarkMode ?
          BrightnessUtils.getInstance().getBrightnessOptionByType(BrightnessTypeEnum.ICON_BRIGHTNESS_DARK)
          : BrightnessUtils.getInstance().getBrightnessOptionByType(BrightnessTypeEnum.ICON_BRIGHTNESS_LIGHT);
      } else {
        return this.colorModeViewData.foregroundPrimaryOption;
      }
    } else {
      return undefined;
    }
  }

  async reload(fileName?: string, isInit?: string): Promise<void> {
    log.debug(`reload animation name:${this.name}, ${fileName}, ${this.currentFile}, isInit:${isInit}`);
    if (fileName) {
      if (!this.fileMap[fileName]) {
        log.error(`reload animation not found: ${fileName}`);
        return;
      }
      this.currentFile = fileName;
      this.lottiePlay = this.fileMap[this.currentFile];
      log.warn(`lottie.destroy reload name ${this.name}`);
      lottie.destroy(this.name);
      await this.refresh('reload');
    } else if (Object.keys(this.fileMap).length === 1) {
      log.warn(`lottie.destroy reload-else name ${this.name}`);
      lottie.destroy(this.name);
      await this.refresh('reload');
    }
  }

  async playAnim(fileName?: string, nextFileName?: string) {
    log.debug(`play animation: ${fileName}`);
    await this.reload(fileName);
    lottie.play(this.name);
    // 记录下一个动画文件
    this.nextFile = nextFileName || '';
  }

  build() {
    Canvas(this.mainCanvasRenderingContext)
      .width('100%')
      .height('100%')
      .renderGroup(this.isMarkingRenderGroupOfControl) // 增加UI缓存，防止丢帧
      .onAppear(() => {
        log.debug(`canvas on ready-${this.name}: ${!!this.lottiePlay}`);
        this.canvasReady = true;
        // 快速进出时，重置lottie动画
        if (this.nextFile && this.iconTypeKey === 'center') {
          this.currentFile = this.nextFile;
          this.lottiePlay = this.fileMap[this.currentFile];
        }
        if (this.lottiePlay) {
          this.refresh('onReady');
        }
      })
      .onDisAppear(() => {
        log.debug('canvas on disappear：' + this.name);
        lottie.destroy(this.name);
      })
      .onTouch((event?: TouchEvent) => {
        if (event?.type === TouchType.Down) {
          this.isTouched = true;
          this.controller?.setTouched();
        }
      })
      .backgroundColor(Color.Transparent)
      .foregroundBrightness(this.getBrightness())
      .opacity(this.isPC ? (this.active ? 1 : 0.3) : 1)
  }
}