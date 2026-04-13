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

import {LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import {
  GlobalContext,
  EvtBus,
  ConfigurationEvent,
  sEventManager,
  unsubscribe
} from '@ohos/frameworkwrapper';
// import { MemoryUtils } from '@ohos/windowscene';
import { LunarCalendar, TimeEventArgs, TimeManager } from '@ohos/systemuicommon';
import {
  GlobalStatusCache,
  ScreenLockStateManager,
  StatusCacheConst
} from '@ohos/screenlockcommon';
import commonEventManager from '@ohos.commonEventManager'
import { ScreenLockApi } from '@ohos/screenlockcommon';
import { BusinessError } from '@kit.BasicServicesKit';
import { DateTimeI18NUtil } from '../../common/DateTimeI18NUtil';
import I18n from '@ohos.i18n';
import common from '@ohos.app.ability.common';
import Intl from '@ohos.intl';
import { ClockWidgetModel } from '../../viewmodel/ClockWidgetModel';
import { DesktopModeManager } from '@ohos/launchercommon/src/main/ets/TsIndex';

const TAG = 'ClockData'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const TIME_CHANGE_EVENT = 'Time_Change_Event';

interface EventSubscribeInfo {
  events: Array<string>;
}

export interface ClockDataListener {
  onChanged: () => void;
}

export class ClockData {
  public lunarDate: string = '';
  public timeAccessibility: string = '';
  public clockTime: string = '';
  public dateStr: ResourceStr = '';
  public bigDateStr: ResourceStr = '';
  public weekStr: ResourceStr = '';
  public dateWithWeek: ResourceStr = '';
  public weekWithLunar: ResourceStr = '';
  public language: string = I18n.System.getSystemLanguage();
  public static isChinese = DateTimeI18NUtil.isChinese();
  private minute: number = 0;
  private hour: number = 0;
  private day: number = -1;
  private weekDay: number = -1;
  private month: number = -1;
  private year: number = -1;
  private clockDataListeners: ClockDataListener[] = []
  private context: Context = GlobalContext.getContext();
  private unSubscriber?: unsubscribe | null = null;
  private isAodPreviewScene: boolean = AppStorage.get<boolean>('isAodPreviewScene') === true;
  private use24hFormat: boolean = I18n.System.is24HourClock();
  private isLanguageChanged: boolean = false;

  constructor() {
    if (this.isAodPreviewScene) {
      // Aod预览场景进程独立,系统事件需要单独处理
      this.registerDateTimeEventForPreview();
      this.subscribeConfigurationEvent();
    } else {
      this.subscribeConfigurationEvent();
      this.registerDateTimeEvent();
    }
    this.updateTime();
  }

  public registerDataChanged(listener: ClockDataListener) {
    TimeManager.refreshTimeFormat()
    this.updateTime();
    if (!listener) {
      log.showInfo('Empty registration is not allowed.');
      return;
    }

    let item = this.clockDataListeners.find(item => item === listener);
    if (item) {
      log.showInfo('Repeated registration is not allowed.');
      return;
    }

    this.clockDataListeners.push(listener);
    listener.onChanged();
  }

  public unregisterDataChanged(listener: ClockDataListener) {
    if (!listener) {
      log.showInfo('Empty registration don\'t need to be deregistered.');
      return;
    }
    let index: number = this.clockDataListeners.indexOf(listener);
    if (index === -1) {
      log.showInfo('Unregistered listener don\'t need to be deregistered.');
      return;
    }
    this.clockDataListeners.splice(index, 1);
  }

  public registerDateTimeEvent(context: Context = GlobalContext.getContext()) {
    if (!context) {
      return;
    }
    this.context = context;
    this.unSubscriber = sEventManager.subscribe(TIME_CHANGE_EVENT, (args: TimeEventArgs) => {
      if (ScreenLockStateManager.getInstance().isInEdite) {
        this.updateTime();
      } else if (!this.needUpdateLockTime()) {
        return;
      } else {
        this.updateTime();
      }
    });
  }

  private registerDateTimeEventForPreview(): void {
    log.showInfo('registerDateTimeEvent');
    const context = AppStorage.get<common.UIExtensionContext>('AodUIExtensionContext');
    if (context === undefined) {
      return;
    }
    this.context = context;
    const commonEventSubscribeInfo: EventSubscribeInfo = {
      events: [
        commonEventManager.Support.COMMON_EVENT_TIME_CHANGED,
        commonEventManager.Support.COMMON_EVENT_TIMEZONE_CHANGED,
        commonEventManager.Support.COMMON_EVENT_TIME_TICK
      ]
    };
    let subscriber: commonEventManager.CommonEventSubscriber;
    commonEventManager.createSubscriber(commonEventSubscribeInfo,
      (err: BusinessError, data: commonEventManager.CommonEventSubscriber) => {
        log.showInfo('start createSubscriberCallBack');
        if (err && err.code !== 0) {
          log.showError(`Can't handle common event, err: ${err.message}`);
          return;
        }
        subscriber = data;
        commonEventManager.subscribe(subscriber, (err, data) => {
          log.showInfo('time change');
          if (data?.event === commonEventManager.Support.COMMON_EVENT_TIME_CHANGED && data?.data === '24HourChange') {
            this.use24hFormat = I18n.System.is24HourClock();
            log.showInfo(`updateTimeFormat use24hFormat: ${this.use24hFormat}`);
          }
          this.updateTime();
        })
      });
    this.updateTime();
  }

  private updateClockForPreview(date: Date): void {
    if (this.isAodPreviewScene === false) {
      return;
    }
    let result: string;
    if (this.use24hFormat) {
      let hours: number = date.getHours();
      let minutes: number = date.getMinutes();
      result = `${(hours > 9 ? '' : '0') + hours}:${(minutes > 9 ? '' : '0') + minutes}`;
    } else {
      let hours: number = date.getHours() % 12;
      let minutes: number = date.getMinutes();
      if (hours === 0) {
        hours = 12;
      }
      result = `${(hours > 9 ? '' : '0') + hours}:${(minutes > 9 ? '' : '0') + minutes}`;
    }
    this.clockTime = result;
    log.showInfo(`updateClockForPreview,time = ${this.clockTime}`);
  }

  private needUpdateLockTime(): boolean {
    const isScreenOnKey: boolean = GlobalStatusCache.getInstance()
      .getStatus(StatusCacheConst.SCREEN_ON_KEY, true) as boolean;
    const isDesktopEmergency = DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode();
    return (isScreenOnKey && ScreenLockApi.getLock() && Boolean(this.context)) || isDesktopEmergency;
  }

  public updateTime(): void {
    if (!this.context) {
      return;
    }
    let date = new Date();
    this.updateClock(date);
    this.updateWeekDay(date);
    this.updateDate(date);
    this.isLanguageChanged = false;
    this.clockDataListeners.forEach((listener: ClockDataListener) => {
      listener.onChanged();
    })
    log.showWarn(`onClockDataChange time:${this.clockTime}, week=${this.weekStr}`);
  }

  private updateClock(date: Date): void {
    this.clockTime = TimeManager.formatTime(date);
    let isAccessibilityMode: boolean = AppStorage.get<boolean>('isAccessibilityMode') ?? false;
    this.timeAccessibility = isAccessibilityMode ? this.getClockAccessibleMsg(date) : '';
    this.updateClockForPreview(date);
  }

  private getClockAccessibleMsg(date: Date): string {
    let options: Intl.DateTimeOptions = {
      hour: 'numeric',
      minute: 'numeric',
      hourCycle: I18n.System.is24HourClock() ? 'h24' : 'h12' };
    let dateFormat = new Intl.DateTimeFormat(I18n.System.getSystemLocale(), options);
    let result: string = dateFormat.format(date);
    // DateTimeFormat在native侧存在一些内存占用，需要在format实例使用完后手动调用removeNapiWrap触发此部分native内存回收
    // MemoryUtils.removeNapiWrap(dateFormat, false);
    return result;
  }

  private updateWeekDay(date: Date) {
    let weekDay = date.getDay();
    if (this.weekDay === weekDay && !this.isLanguageChanged) {
      return;
    }
    this.weekDay = weekDay;
    log.showInfo(`weekDay = ${weekDay}`)
    this.weekStr = DateTimeI18NUtil.getWeekTitle()[weekDay];
  }

  private updateDate(date: Date): void {
    let year = date.getFullYear();
    let month = date.getMonth();
    let day = date.getDate();
    if (year === this.year && month === this.month && day === this.day && !this.isLanguageChanged) {
      return;
    }
    this.year = year;
    this.month = month;
    this.day = day;
    const systemLanguage: string = I18n.System.getSystemLanguage();
    this.dateStr = DateTimeI18NUtil.getDateStr(systemLanguage, date);
    this.bigDateStr = DateTimeI18NUtil.getBigDateStr(systemLanguage, date);
    if (ClockData.isChinese) {
      let lunar = new LunarCalendar();
      lunar.init(year, month, day);
      let chinesMonth = lunar.getChineseMonth(false);
      let chinesDay = lunar.getChineseDay();
      log.showInfo(`update lunar year:${year}, month:${month} day:${day}, luMonth:${chinesMonth}, luDay:${chinesDay}`)
      this.lunarDate = chinesMonth + chinesDay;
    }
    this.dateWithWeek = DateTimeI18NUtil.getDateWithWeekStr(systemLanguage, date);
  }

  private subscribeConfigurationEvent() {
    EvtBus.on(ConfigurationEvent, (configEvent: ConfigurationEvent) => {
      this.isLanguageChanged = true;
      this.language = I18n.System.getSystemLanguage();
      ClockData.isChinese = DateTimeI18NUtil.isChinese(this.language);
    });
  }


}

export let clockData = SingletonHelper.getInstance(ClockData, TAG);