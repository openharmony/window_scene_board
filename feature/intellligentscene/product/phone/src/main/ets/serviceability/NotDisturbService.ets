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

import settings from '@ohos.settings';
import Want from '@ohos.app.ability.Want';
import ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import { LogUtil } from '@ohos/scene.common/src/main/ets/utils/LogUtil';
import { GlobalContext } from '@ohos/scene.common/src/main/ets/utils/GlobalContext';
import { SettingsDataUtils } from '@ohos/scene.common/src/main/ets/utils/SettingsDataUtils';
import {
  DISTURB_MODE_TRIGGER_END_TIME,
  DISTURB_MODE_TRIGGER_START_TIME,
  NotDisturbTimerManager
} from '@ohos/scene.notdisturb/src/main/ets/NotDisturbTimerManager';
import {
  FOCUS_MODE_ENABLED,
  NotDisturbUtils,
  NOT_DISTURB_VALUE_ENABLE,
  NOT_DISTURB_VALUE_ERROR
} from '@ohos/scene.notdisturb/src/main/ets/utils/NotDisturbUtils';
import { NotDisturbReportSources } from '@ohos/scene.notdisturb/src/main/ets/model/NotDisturbTimerPararm';

/* instrument ignore file */
/**
 * 免打扰定时 WantAgent 回调 Service（移植自 settings NotDisturbService 并适配 scene）
 * 不改动情景模式 UI；承接 systemTimer 到期后的开关切换。
 */
const TAG: string = 'NotDisturbService';
const ONE_MINUTE: number = 60 * 1000;
const TIMER_CONTEXT_KEY: string = 'TimerContext';

export default class NotDisturbService extends ServiceExtensionAbility {
  async onCreate(want: Want) {
    LogUtil.showInfo(TAG, 'onCreate');
    GlobalContext.getInstance().set(TIMER_CONTEXT_KEY, this.context);
  }

  async onRequest(want: Want, startId: number) {
    // scene 侧承接定时，不再像 settings 那样在支持情景模式时直接 return
    LogUtil.showInfo(TAG,
      `onRequest abilityName:${want.abilityName} bundleName:${want.bundleName} startId:${startId}`);
    let modeValue = SettingsDataUtils.getSettingsDataWithContext(this.context,
      FOCUS_MODE_ENABLED, '', settings.domainName.USER_SECURITY);
    NotDisturbTimerManager.getInstance().initOtherConfig(this.context);
    LogUtil.showInfo(TAG, `onRequest focus_mode_enable modeValue: ${modeValue}`);
    if (modeValue === NOT_DISTURB_VALUE_ENABLE) {
      SettingsDataUtils.setSettingsDataWithContext(this.context, DISTURB_MODE_TRIGGER_START_TIME,
        NOT_DISTURB_VALUE_ERROR, settings.domainName.USER_PROPERTY);
      SettingsDataUtils.setSettingsDataWithContext(this.context, DISTURB_MODE_TRIGGER_END_TIME,
        NOT_DISTURB_VALUE_ERROR, settings.domainName.USER_PROPERTY);
      NotDisturbTimerManager.getInstance().closeTypeOncesDb();
      NotDisturbTimerManager.getInstance().refreshTimer(true);
    } else {
      let nowTime = new Date().getTime();
      let startTime = Number(SettingsDataUtils.getSettingsDataWithContext(this.context,
        DISTURB_MODE_TRIGGER_START_TIME, NOT_DISTURB_VALUE_ERROR, settings.domainName.USER_PROPERTY));
      LogUtil.showInfo(TAG, `onRequest newtime: ${nowTime}  startTime: ${startTime}`);
      if (nowTime - startTime >= ONE_MINUTE || nowTime < startTime) {
        NotDisturbTimerManager.getInstance().refreshTimer();
        return;
      }
      SettingsDataUtils.setSettingsDataWithContext(this.context, FOCUS_MODE_ENABLED,
        NOT_DISTURB_VALUE_ENABLE, settings.domainName.USER_SECURITY);
      let endTime = Number(SettingsDataUtils.getSettingsDataWithContext(this.context,
        DISTURB_MODE_TRIGGER_END_TIME, NOT_DISTURB_VALUE_ERROR, settings.domainName.USER_PROPERTY));
      NotDisturbUtils.reportNotDisturb('on', NotDisturbReportSources.TIMER);
      LogUtil.showInfo(TAG, `onRequest DISTURB_MODE_TRIGGER_END_TIME endTime: ${endTime}  set focus_mode_enable 1`);
      NotDisturbTimerManager.getInstance().startTimeAlarm(endTime);
    }
  }

  onDestroy() {
    LogUtil.showInfo(TAG, 'onDestroy');
    GlobalContext.getInstance().remove(TIMER_CONTEXT_KEY);
  }
}
