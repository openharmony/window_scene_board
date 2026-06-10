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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { localEventManager } from '@ohos/frameworkwrapper';
import { ASCFWindowMgr } from '@ohos/windowscene';
import { ReceiveEventInfo } from '../bean/ReceiveEventInfo';
import EventConstants from '../constants/EventConstants';

const TAG = 'ASCFWindowManagerListener';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);


export class ASCFWindowManagerListener {
  /**
   * 注册应用信息更新监听器
   */
  public registerAppUpdateListener(): void {
    // 应用卸载/安装监听
    localEventManager.registerEventListener(this.appEventListener, [
      EventConstants.EVENT_REQUEST_RECOMMEND_FORM_ADD, EventConstants.EVENT_REQUEST_RECOMMEND_FORM_UPDATE,
      EventConstants.EVENT_REQUEST_RECOMMEND_FORM_DELETE
    ]);
    log.showInfo('local listener on create');
  }

  /**
   * 反注册应用信息更新监听器
   */
  public unRegisterAppUpdateListener(): void {
    localEventManager.unregisterEventListener(this.appEventListener);
    log.showInfo('local listener on destroy');
  }

  private readonly appEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: string): void => {
      log.showInfo(`appEventListener: ${event}, params: ${params}`);
      if ([EventConstants.EVENT_REQUEST_RECOMMEND_FORM_ADD,
        EventConstants.EVENT_REQUEST_RECOMMEND_FORM_UPDATE].includes(event)) {
        ASCFWindowMgr.updateWindowModePreference(params);
      }
    }
  };
}

// 单例
export let ASCFWindowMgrListener: ASCFWindowManagerListener =
  SingletonHelper.getInstance(ASCFWindowManagerListener, TAG);