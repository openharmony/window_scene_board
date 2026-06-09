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

import base from '@ohos.base';
import common from '@ohos.app.ability.common';
import i18n from '@ohos.i18n';
import settings from '@ohos.settings';
import dataShare from '@ohos.data.dataShare';
import commonEventManager from '@ohos.commonEventManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'DateTime';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);
const URI: string = settings.getUriSync(settings.date.TIME_FORMAT);
const CONFIGURATION_CHANGE: string = 'configuration_change';
const DAY_HOURS: string = '24';

/**
 * 时间
 */
export default class DateTime {
  public clockTime: string = '';
  private is24hFormat: boolean = i18n.System.is24HourClock();
  private helper: dataShare.DataShareHelper | null = null;
  private subscriber: commonEventManager.CommonEventSubscriber | null = null;
  private environmentCallbackId: number = -1;
  private context: common.Context | null = null;

  public init(context: common.Context): void {
    this.updateDateTime();
    // 注册时制变化的监听
    this.registerTimeFormatChangeEvent(context);
    // 注册时间变化、时区变化的监听
    this.registerTimeChangeEvent();
  }

  public updateDateTime(): void {
    let date = new Date();
    this.updateTime(date);
  }

  private updateTime(date: Date): void {
    let hours: number = date.getHours();
    let minutes: number = date.getMinutes();
    if (!this.is24hFormat) {
      hours = hours % 12;
      if (hours === 0) {
        hours = 12;
      }
    }
    this.clockTime = `${(hours > 9 ? '' : '0') + hours}:${(minutes > 9 ? '' : '0') + minutes}`;
  }

  private registerTimeFormatChangeEvent(context: common.Context): void {
    try {
      dataShare.createDataShareHelper(context, URI).then((helper: dataShare.DataShareHelper) => {
        this.helper = helper;
        this.helper.on('dataChange', URI, () => {
          this.dealTimeFormatChange(context);
        });
      }).catch((error: base.BusinessError) => {
        log.showError(`createDataShareHelper error, code: ${error.code}, message: ${error.message}`);
      })
    } catch (error) {
      log.showError(`DataShareHelper failed, code: ${error.code}, message: ${error.message}`);
    }
  }

  private dealTimeFormatChange(context: common.Context): void {
    log.showInfo('Time format change');
    try {
      this.is24hFormat = settings.getValueSync(context, settings.date.TIME_FORMAT, '') === DAY_HOURS;
    } catch (error) {
      log.showError(`getValueSync failed, code: ${error.code}, message: ${error.message}`);
    }
    this.updateDateTime();
  }

  private registerTimeChangeEvent(): void {
    try {
      commonEventManager.createSubscriber({
        events: [
          commonEventManager.Support.COMMON_EVENT_TIME_CHANGED,
          commonEventManager.Support.COMMON_EVENT_TIMEZONE_CHANGED,
          commonEventManager.Support.COMMON_EVENT_TIME_TICK,
        ]
      }).then((subscriber: commonEventManager.CommonEventSubscriber) => {
        log.showInfo('createSubscriber succeed');
        this.subscriber = subscriber;
        commonEventManager.subscribe(this.subscriber, () => {
          log.showInfo('time change');
          this.updateDateTime();
        });
      }).catch((error: base.BusinessError) => {
        log.showError(`createSubscriber error, code: ${error.code}, message: ${error.message}`);
      })
    } catch (error) {
      log.showError(`CommonEventManager failed, code: ${error.code}, message: ${error.message}`);
    }
  }

  public release(): void {
    try {
      this.helper?.off('dataChange', URI);
      this.helper = null;
      commonEventManager.unsubscribe(this.subscriber, (err) => {
        if (err) {
          log.showError(`unsubscribe fail ,error is ${err.message} `);
          return;
        }
        this.subscriber = null;
      });
      this.context?.getApplicationContext().off('environment', this.environmentCallbackId);
      this.context?.eventHub.off(CONFIGURATION_CHANGE);
      this.context = null;
      this.environmentCallbackId = -1;
      log.showInfo(`release callback finish`);
    } catch (error) {
      log.showError(`release callback failed, code: ${error.code}, message: ${error.message}`);
    }
  }
}

