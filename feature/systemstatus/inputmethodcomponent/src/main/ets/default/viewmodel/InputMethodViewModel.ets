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

import inputMethod from '@ohos.inputMethod';
import ResourceManager from '@ohos.resourceManager';
import InputMethodSubtype from '@ohos.InputMethodSubtype';
import { image } from '@kit.ImageKit';
import { LogDomain, LogHelper, PixelMapUtil } from '@ohos/basicutils/src/main/ets/TsIndex';
import { EventManager,
  EvtBus,
  InputMethodEvent, InputMethodEventType } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { BusinessError } from '@kit.BasicServicesKit';
import InputMethodUtils from '../common/InputMethodUtils';

const TAG = 'InputMethodViewModel'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Observed
export class InputMethodViewModel {
  public mInputMethodImage: string | PixelMap = '';
  private mIsStart: boolean = false;
  /**
   * 默认图标：透明图片
   */
  private readonly defaultIcon: PixelMap = this.initDefaultIcon();
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  private currentInputMethodSubtype: InputMethodSubtype | null = null;
  private currentInputMethod: inputMethod.InputMethodProperty | null = null;

  constructor() {
    log.showInfo('constructor');
    PixelMapUtil.addName(this.defaultIcon, `InputMethodViewModel_default`);
  }

  initViewModel() {
    if (this.mIsStart) {
      return;
    }
    log.showInfo('initViewModel');
    this.mIsStart = true;

    // 非同步查询输入法和输入法子类型，避免输入法框架服务不可用时，调用输入法接口导致桌面进程阻塞
    this.updateCurrentInputMethodSubtype();
    this.updateCurrentInputMethod();

    this.eventMgr.on(InputMethodEvent, (event) => {
      if (event.eventType === InputMethodEventType.INPUT_METHOD_LANGUAGE_CHANGED) {
        this.updateInputMethodSubtypeComponent(event.subtype);
      } else if (event.eventType === InputMethodEventType.INPUT_METHOD_CHANGED) {
        this.updateInputMethodComponent(event.methodProperty);
      }
    })
  }

  private async updateCurrentInputMethodSubtype(): Promise<void> {
    this.currentInputMethodSubtype = await InputMethodUtils.queryCurrentInputMethodSubtype();
    this.updateInputMethodSubtypeComponent(this.currentInputMethodSubtype);
  }

  private async updateCurrentInputMethod(): Promise<void> {
    this.currentInputMethod = await InputMethodUtils.queryCurrentInputMethod();
    this.updateInputMethodComponent(this.currentInputMethod);
  }

  initDefaultIcon() {
    let buffer = new Uint8Array([0, 0, 0, 0]);
    let opts: image.InitializationOptions = {
      pixelFormat: image.PixelMapFormat.RGBA_8888,
      size: {
        height: 1,
        width: 1
      }
    };
    return image.createPixelMapSync(buffer.buffer, opts);
  }

  resetInputMethodImage() {
    log.showInfo('resetInputMethodImage');
    this.mInputMethodImage = this.defaultIcon;
  }

  async updateInputMethodSubtypeComponent(inputMethodSubtype: InputMethodSubtype | null) {
    log.showInfo(`[updateInputMethodSubtypeComponent] subtype:${JSON.stringify(inputMethodSubtype)}`);
    let data = await ResUtils.getBundleInfo(TAG, inputMethodSubtype?.name);
    let resource: ResourceManager.Resource = {
      bundleName: inputMethodSubtype?.name ?? '',
      moduleName: data.entryModuleName,
      id: inputMethodSubtype?.iconId ?? 0
    }
    try {
      ResUtils.getOutMediaBase64(resource).then((icon: string) => {
        log.showInfo(`updateInputMethodSubtypeComponent getMediaBase64 success, icon:${icon}`);
        AppStorage.setOrCreate('inputMethodSubTypeIcon', icon);
      }).catch((error: BusinessError) => {
        log.showError('updateInputMethodSubtypeComponent getMediaBase64 error ' + error);
      });
    } catch (error) {
      log.showError('updateInputMethodSubtypeComponent getMediaBase64 error ' + error);
    }
  }

  async updateInputMethodComponent(method: inputMethod.InputMethodProperty | null) {
    log.showInfo(`[updateInputMethodComponent] method:${JSON.stringify(method)}`);
    this.resetInputMethodImage();

    if (method?.iconId === undefined) {
      log.showError(`updateInputMethodComponent get image failed, method:${JSON.stringify(method)}`);
      return;
    }

    // inputMethodProperty中未携带icon，从包管理获取
    if (method?.name === undefined) {
      log.showError(`updateInputMethodComponent failed, inputMethodInfo:${JSON.stringify(method)}`);
      return;
    }

    let data = await ResUtils.getBundleInfo(TAG, method?.name);
    let resource: ResourceManager.Resource = {
      bundleName: method?.name,
      moduleName: data.entryModuleName,
      id: method?.iconId ?? 0
    }
    try {
      ResUtils.getDrawableDescriptor(resource).then((drawableDescriptor: DrawableDescriptor) => {
        log.showInfo(`updateInputMethodComponent getDrawableDescriptor success, icon:${JSON.stringify(drawableDescriptor.getPixelMap())}`);
        this.mInputMethodImage = drawableDescriptor.getPixelMap();
      }).catch((error: BusinessError) => {
        log.showError('updateInputMethodComponent getDrawableDescriptor error ' + error);
      });
    } catch (error) {
      log.showError('updateInputMethodComponent getDrawableDescriptor error ' + error);
    }
  }
}

let inputMethodViewModel = new InputMethodViewModel();

export default inputMethodViewModel as InputMethodViewModel;