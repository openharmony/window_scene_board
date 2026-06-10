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
import {
  LogDomain, Logger,
} from '@ohos/basicutils';
import inputMethod from '@ohos.inputMethod';
import InputMethodSubtype from '@ohos.InputMethodSubtype';
import { AsyncCallback } from '@kit.BasicServicesKit';

const DEFAULT_INIT_TIMES: number = 5;
const WAIT_SWITCH_INTERVAL: number = 20;
const sleep = (delay: number): Promise<number> => new Promise((resolve) => setTimeout(resolve, delay));
const TAG = 'InputMethodUtils';
const log = Logger.getLogHelper(LogDomain.SCB);

//封装输入法接口，避免输入法框架服务不可用时，调用输入法接口导致桌面进程阻塞
export default class InputMethodUtils {

  static async queryCurrentInputMethodSubtype(): Promise<InputMethodSubtype | null> {
    let currentInputMethodSubtype: InputMethodSubtype | null = null;
    let waitTime: number = 0;
    for (let i = 0; i < DEFAULT_INIT_TIMES; i++) {
      waitTime = i === 0 ? 0 : WAIT_SWITCH_INTERVAL;
      log.showInfo(TAG, `query input method subtype times: ${i}`);
      setTimeout(()=>{
        currentInputMethodSubtype = inputMethod.getCurrentInputMethodSubtype();
      }, 0);
      await sleep(waitTime);
      if (currentInputMethodSubtype) {
        log.showInfo(TAG, 'input method subtype ready!');
        break;
      }
      log.showInfo(TAG, 'no input method subtype ready! Retry...');
    }
    return currentInputMethodSubtype;
  }

  static async queryCurrentInputMethod(): Promise<inputMethod.InputMethodProperty | null> {
    let currentInputMethod: inputMethod.InputMethodProperty | null = null;
    let waitTime: number = 0;
    for (let i = 0; i < DEFAULT_INIT_TIMES; i++) {
      waitTime = i === 0 ? 0 : WAIT_SWITCH_INTERVAL;
      log.showInfo(TAG, `query input method times: ${i}`);
      setTimeout(()=>{
        currentInputMethod = inputMethod.getCurrentInputMethod();
      }, 0);
      await sleep(waitTime);
      if (currentInputMethod) {
        log.showInfo(TAG, 'input method ready!');
        break;
      }
      log.showInfo(TAG, 'no input method ready! Retry...');
    }
    return currentInputMethod;
  }

  static async queryInputMethodSetting(): Promise<inputMethod.InputMethodSetting | undefined> {
    let inputMethodSetting: inputMethod.InputMethodSetting | undefined = undefined;
    let waitTime: number = 0;
    for (let i = 0; i < DEFAULT_INIT_TIMES; i++) {
      waitTime = i === 0 ? 0 : WAIT_SWITCH_INTERVAL;
      log.showInfo(TAG, `query InputMethodSetting times: ${i}`);
      setTimeout(()=>{
        inputMethodSetting = inputMethod.getSetting();
      }, 0);
      await sleep(waitTime);
      if (inputMethodSetting) {
        log.showInfo(TAG, 'InputMethodSetting ready!');
        break;
      }
      log.showInfo(TAG, 'no InputMethodSetting ready! Retry...');
    }
    return inputMethodSetting;
  }

  static switchInputMethod(target: inputMethod.InputMethodProperty | undefined,
    callback: AsyncCallback<boolean>): void {
    setTimeout(() => {
      inputMethod.switchInputMethod(target, callback);
    }, 0);
  }

  static switchCurrentInputMethodSubtype(target: InputMethodSubtype | undefined,
    callback: AsyncCallback<boolean>): void {
    setTimeout(() => {
      inputMethod.switchCurrentInputMethodSubtype(target, callback);
    }, 0);
  }
}
