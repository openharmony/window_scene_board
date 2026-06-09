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
import { CustomMessageBase } from './CustomMessageBase';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'VirtualKeyBoardCustomMessage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
// 虚拟键盘公共事件
const vKEvents = 'usual.event.imf.virtual_keyboard_status_bar';

export class VirtualKeyBoardCustomMessage extends CustomMessageBase {
  // 虚拟键盘消息订阅
  private subScriber : commonEventManager.CommonEventSubscriber | null = null;
  private subScriberInfo:commonEventManager.CommonEventSubscribeInfo = {
    events:[vKEvents]
  };

  protected initDiff(): boolean {
    this.registerVirtualKeyBoard();
    return true;
  }

  //虚拟键盘监听逻辑控制显隐
  private registerVirtualKeyBoard(): void {
    let isVisible: boolean = false;
    if (this.subScriber) {
      log.showInfo('subscriber is exist!');
      return;
    }
    this.subScriber = commonEventManager.createSubscriberSync(this.subScriberInfo);
    if (this.subScriber === null) {
      log.showError('registerVirtualKeyBoard: create subscriber error!');
      return;
    }
    log.showInfo('registerVirtualKeyBoard success');
    commonEventManager.subscribe(this.subScriber,
      async (err: BusinessError, data: commonEventManager.CommonEventData) => {
        if (err) {
          log.showError('registerVirtualKeyBoard: Can not handle common event, err: ' + err.code + 'err: ' + err.message);
          return;
        }
        if (data.event === vKEvents) {
          let parameters = data.parameters;
          isVisible = parameters !== undefined && parameters['visible'] === true;
          log.showInfo(`registerVirtualKeyBoard: virtual keyboard isVisible: ${isVisible}`);
          this.updateVisible(isVisible);
        }
      })
    this.updateVisible(isVisible);
  }


  protected deInitDiff(): void {
    this.unregisterVirtualKeyBoard();
  }

  private unregisterVirtualKeyBoard(): void {
    log.showInfo('unregister common event change');
    if (this.subScriber) {
      commonEventManager.unsubscribe(this.subScriber);
      this.subScriber = null;
    }
  }
}