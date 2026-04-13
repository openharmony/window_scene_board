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

import commonEventManager from '@ohos.commonEventManager';
import { TaskpoolUtil, LogDomain, LogHelper } from '@ohos/basicutils';
import { AccountMgr } from '@ohos/frameworkwrapper';

const TAG = 'EventBroadcast'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export enum SysUiWindowType {
  /* 通知中心 */
  WINDWO_NTF_CENTER = 'ntf_center',

  /* 控制中心 */
  WINDOW_CTR_CENTER = 'ctr_center',

  /* 横幅 */
  WINDOW_BANNER = 'banner_pannel',
}

export class EventBroadcast {
  /**
   * 广播面板的显示和隐藏事件
   *
   * @param window 显示和隐藏的面板名称
   * @param isShow 显示时为true，隐藏时为false
   * @param data 需要携带的自定义信息
   */
  static broadcastEvent(window: string, isShow: boolean, data?: Map<string, string>): void {
    log.showInfo(`window is ${window} isShow ${isShow}`);
    let options : commonEventManager.CommonEventPublishData = {
      subscriberPermissions: ['ohos.permission.SUBSCRIBE_NOTIFICATION_WINDOW_STATE'],
      parameters: {
        'window': window,
        'isShow': isShow,
      }
    }

    data?.forEach((value, key) => {
      if (options.parameters !== undefined ) {
        options.parameters[key] = value;
      }
    });

    AccountMgr.getCurrentAccountId().then((userId)=>{
      if (options.parameters) {
        options.parameters.userId = userId;
      }
      TaskpoolUtil.doTask(publishEvent, options);
    })
  }
}

function publishEvent(options : commonEventManager.CommonEventPublishData): void {
  'use concurrent';
  const TAG = 'EventBroadcast';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  try {
    const userId = options.parameters?.userId as number;
    commonEventManager.publishAsUser('sysui_window_state_change', userId, options, (err) => {
      if (err) {
        log.showWarn('%{public}d publish broadcast event failed, code:%{public}d, msg:%{public}s', userId, err?.code, err?.message);
        return;
      }
      log.showInfo('%{public}d publish broadcast event success', userId);
    });
  } catch (err) {
    log.showWarn('publish failed, catch error code:' + err?.code + ', message:' + err?.message);
  }
}