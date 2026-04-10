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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import i18n from '@ohos.i18n';
import settings from '@ohos.settings';
import data_dataShare from '@ohos.data.dataShare';
import { LunarCalendar } from '@ohos/systemuicommon';
import { BusinessError } from '@ohos.base';
import { commonEventManager } from '@kit.BasicServicesKit';
import { DateTimeI18NUtil } from '@ohos/screenlockwidget/src/main/ets/clock/common/DateTimeI18NUtil';

const TAG = 'ScreenLock-DateTime';
const URI_VAR: string =
  'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=' + settings.date.TIME_FORMAT;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

interface EventSubscribeInfo {
  events: Array<string>;
}

export default class DateTimeModel {
  public clockTime: string = '';
  public date: string = '';
  public weekDay: ResourceStr = '';
  public lunarDate: string = '';
  public mEventSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  public is24hFormat: boolean = false;
  private mSettingsHelper: data_dataShare.DataShareHelper | null = null;
  public mCommonEventSubscribeInfo: EventSubscribeInfo = {
    events: [
      commonEventManager.Support.COMMON_EVENT_TIME_CHANGED,
      commonEventManager.Support.COMMON_EVENT_TIMEZONE_CHANGED,
      commonEventManager.Support.COMMON_EVENT_TIME_TICK,
      commonEventManager.Support.COMMON_EVENT_USER_SWITCHED
    ]
  }

  constructor(isAutoSetDateTime = true) {
    if (isAutoSetDateTime) {
      this.is24hFormat = i18n.System.is24HourClock();
      this.setDateTime();
    }
  }

  /**
   * register date time event
   */
  public registerDateTimeEvent(context: Context = GlobalContext.getContext(), callback?: () => boolean) {
    const handleTimeFormatChange = () => {
      this.is24hFormat = i18n.System.is24HourClock();
      log.showInfo(`timeFormat change: ${this.is24hFormat}`);
      this.setDateTime();
    };

    data_dataShare.createDataShareHelper(context, URI_VAR).then((dataHelper) => {
      this.mSettingsHelper = dataHelper;
      try {
        this.mSettingsHelper.on('dataChange', URI_VAR, () => {
          handleTimeFormatChange();
        });
      } catch (e) {
        log.showInfo('Cannot listen timeformate change');
      }
    })

    log.showInfo('registerDateTimeEvent')
    commonEventManager.createSubscriber(this.mCommonEventSubscribeInfo,
      (err: BusinessError, data: commonEventManager.CommonEventSubscriber) => {
        log.showInfo('start createSubscriberCallBack');
        if (err && err.code !== 0) {
          log.showError(`Can't handle common event, err: ${err.message}`);
          return;
        }
        this.mEventSubscriber = data;
        commonEventManager.subscribe(data, (err, data) => {
          if (callback?.() ?? true) {
            this.setDateTime();
          }
        })
      })
    handleTimeFormatChange();
  }


  public setDateTime() {
    let lunar = new LunarCalendar();
    let dateTime = new Date();
    let hours = dateTime.getHours();
    let hour: string = '';
    // not 24-hour clock format hour
    if (!this.is24hFormat) {
      hours %= 12;
      if (hours == 0) {
        hours = 12;
      }
    }
    if (hours < 10) {
      hour = `0${hours}`;
    } else {
      hour = `${hours}`;
    }

    let minutes = dateTime.getMinutes();
    // format minute
    if (minutes < 10) {
      this.clockTime = `${hour}:0${minutes}`;
    } else {
      this.clockTime = `${hour}:${minutes}`;
    }

    const systemLanguage: string = AppStorage.get('systemLanguage') ?? i18n.System.getSystemLanguage();
    const weekTitle: string[] = DateTimeI18NUtil.getWeekTitle(systemLanguage, dateTime);
    this.weekDay = weekTitle[dateTime.getDay()];
    this.date = DateTimeI18NUtil.getDateStr(systemLanguage, dateTime);

    lunar.init(dateTime.getFullYear(), dateTime.getMonth(), dateTime.getDate());
    this.lunarDate = lunar.getChineseMonth(false) + lunar.getChineseDay();
    log.showInfo(`time = ${this.clockTime}`);
  }

  /**
   * register date time event
   */
  public unregisterDateTimeEvent() {
    try {
      log.showInfo('unregisterDateTimeEvent');
      this.mSettingsHelper?.off('dataChange', URI_VAR);
      if (this.mEventSubscriber) {
        commonEventManager.unsubscribe(this.mEventSubscriber);
        this.mEventSubscriber = null;
      }
    } catch (error) {
      log.showError('unregisterDateTimeEvent failed.');
    }
  }
}