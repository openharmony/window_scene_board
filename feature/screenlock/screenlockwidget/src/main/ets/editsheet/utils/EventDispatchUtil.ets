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

import commonEventManager from '@ohos.commonEventManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'EventDispatchUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class EventDispatchUtil {
  private static instance: EventDispatchUtil;
  private stage: string = 'exit';

  /**
   * 获取 EventDispatchUtil 单例的静态方法
   *
   * @returns EventDispatchUtil 单例
   */
  public static getInstance(): EventDispatchUtil {
    if (!EventDispatchUtil.instance) {
      EventDispatchUtil.instance = new EventDispatchUtil();
    }
    return EventDispatchUtil.instance;
  }

  /**
   * 处理进入退出主题画廊或壁纸库事件
   *
   * @param clickType 分为wallpaper/theme/aodStyle
   * @param stage 分为enter/exist
   */
  public handleEvent(clickType: string, stage: string): void {
    log.info(TAG, `handleEvent, clickType = ${clickType}, stage = ${stage}`);
    if (stage !== this.stage) {
      this.publishEvent(clickType, stage);
      this.stage = stage;
    }
  }

  private constructor() {
  }

  private publishEvent(clickType: string, stage: string): void {
    const publishData: commonEventManager.CommonEventPublishData = {
      subscriberPermissions: ['ohos.permission.ACTIVATE_THEME_PACKAGE'],
      parameters: { 'clickType': clickType, 'stage': stage },
    }
    try {
      commonEventManager.publish('editToolClickType', publishData, () => {
        log.info(TAG, `successful to publish message, stage = ${stage}`);
      });
    } catch (err) {
      log.showError(TAG, `Publish message about isEnterTheme, code = ${err?.code}`);
    }
  }
}