/*
 * Copyright (c) 2026 Huawei Device Co., Ltd. All rights reserved.
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

import StaticSubscriberExtensionAbility from '@ohos.application.StaticSubscriberExtensionAbility';
import commonEventManager from '@ohos.commonEventManager';
import { AbilityContextManager } from '@ohos/scene.common/src/main/ets/ability/AbilityContextManager';
import { GlobalContext } from '@ohos/scene.common/src/main/ets/utils/GlobalContext';
import { LogUtil } from '@ohos/scene.common/src/main/ets/utils/LogUtil';
import { SceneTimeScheduleManager } from '@ohos/scene.statemanage/src/main/ets/manager/SceneTimeScheduleManager';

/* instrument ignore file */
const TAG: string = 'TimeChangeScheduleSubscriber';
const TIMER_CONTEXT_KEY: string = 'TimerContext';
const EVENT_TIME_CHANGED: string = 'usual.event.TIME_CHANGED';
const EVENT_TIMEZONE_CHANGED: string = 'usual.event.TIMEZONE_CHANGED';

/**
 * 进程未驻留时接收 TIME_CHANGED/TIMEZONE_CHANGED，拉起 SceneTimeScheduleService 同步定时启停。
 */
export default class TimeChangeScheduleSubscriber extends StaticSubscriberExtensionAbility {
  async onReceiveEvent(event: commonEventManager.CommonEventData): Promise<void> {
    LogUtil.showInfo(TAG, `receive event: ${event?.event}`);
    if (!event?.event) {
      LogUtil.showError(TAG, 'onReceiveEvent occurs error');
      return;
    }
    if (event.event !== EVENT_TIME_CHANGED && event.event !== EVENT_TIMEZONE_CHANGED) {
      return;
    }
    AbilityContextManager.addContext(this.context);
    GlobalContext.getInstance().set(TIMER_CONTEXT_KEY, this.context);
    // 静态订阅生命周期短，拉起 Service 执行切换
    SceneTimeScheduleManager.getInstance().requestApplyViaService(this.context);
  }
}
