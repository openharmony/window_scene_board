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

import StyleConfiguration, { ClockComponentStyle } from '../common/StyleConfiguration';
import { CommonStyle, StyleConfigurationCommon } from '@ohos/systemuicommon';
import { TIME_CHANGE_EVENT, TimeEventArgs, concatTime } from '@ohos/systemuicommon';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sEventManager, unsubscribe, EventConstants } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import i18n from '@ohos.i18n';
import { LengthMetrics } from '@kit.ArkUI';

const TAG = 'ClockComponent-clockIcon';
const COMPONENT_ID_TIME = TAG + '_Text_time';
const COMPONENT_ID_DATE = TAG + '_Text_date';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export default struct ClockIcon {
  @StorageLink('systemLanguage') @Watch('onLanguageChange') language: string = '';
  @StorageLink('hasUnReadNotification') @Watch('onReceiveNewNotification') hasUnReadNotification: boolean = false;
  @State date: Date = new Date();
  @State @Watch('onTimeChange') mTime: string = '';
  @State @Watch('onDateChange') mDate: string = '';
  @State style: ClockComponentStyle = StyleConfiguration.getClockComponentStyle();
  // 是否使用24小时制
  private styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  private is24HourFormat: boolean = false;
  unSubscriber?: unsubscribe;
  unSubscriberScreen?: unsubscribe;

  /**
   * 内容颜色
   */
  @Consume contentColor: string;

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.unSubscriber = sEventManager.subscribe(TIME_CHANGE_EVENT, (args: TimeEventArgs) => {
      this.updateTimeInfo(args.date);
      this.date = args.date;
    });
    this.unSubscriberScreen = sEventManager.subscribe(EventConstants.SCREEN_LOCK_EXIT, () => {
      log.showInfo(`screen lock exit refresh time ${new Date().toLocaleString()}`);
      this.updateTimeInfo(new Date());
    });
    this.updateTimeInfo(new Date());
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.unSubscriber && this.unSubscriber();
    this.unSubscriber = undefined;
    this.unSubscriberScreen && this.unSubscriberScreen();
    this.unSubscriberScreen = undefined;
  }

  private getFontSize(fontSize: number): string {
    return fontSize + 'vp';
  }

  @Builder
  monthsBuilder() {
    Text(this.mTime)
      .draggable(false)
      .fontColor(this.contentColor)
      .fontSize(this.getFontSize(ResUtils.getNumberFromLength(this.styleCommon.statusBarFontSize)))
      .fontWeight(FontWeight.Medium)
      .textAlign(TextAlign.Center)
      .id(COMPONENT_ID_TIME)
      .textShadow(this.getShadow())
      .clip(false)
      .renderGroup(false)
      .lineHeight(this.style.statusBarClockLineHeight)
  }

  @Builder
  dateBuilder() {
    Text(this.mDate)
      .draggable(false)
      .fontColor(this.contentColor)
      .fontSize(this.getFontSize(ResUtils.getNumberFromLength(this.styleCommon.statusBarFontSize)))
      .fontWeight(FontWeight.Medium)
      .textAlign(TextAlign.Center)
      .id(COMPONENT_ID_DATE)
      .textShadow(this.getShadow())
      .clip(false)
      .renderGroup(true)
      .lineHeight(this.style.statusBarClockLineHeight)
  }

  @Builder
  bellIconBuilder() {
    Badge({
      value: '',
      style: {
        badgeSize: (this.hasUnReadNotification ? ResUtils.getNumber($r('app.float.notification_bell_badge_size')) : 0),
        badgeColor: $r('sys.color.ohos_id_color_badge_red')
      },
    }) {
      Text() {
        SymbolSpan($r('sys.symbol.bell_fill'))
          .draggable(false)
          .id(TAG + '_ntf_flag')
          .fontSize($r('app.float.notification_bell_icon_size'))
          .fontColor([this.contentColor])
      }
      .opacity(0.9)
      .textShadow(this.getShadow())
    }
  }

  build() {
    Row() {
      Column() {
        this.monthsBuilder()
        this.dateBuilder()
      }
      .alignItems(HorizontalAlign.End)
      .justifyContent(FlexAlign.Center)
      Row() {
        this.bellIconBuilder();
      }
      .margin({ start: LengthMetrics.resource(this.style.statusBarBellIconPaddingLeftRight) })
    }
    .padding({
      top: $r('sys.float.padding_level2'),
      right: this.style.statusBarClockPaddingLeftRight,
      bottom: $r('sys.float.padding_level2'),
      left: this.style.statusBarClockPaddingLeftRight
    })
    .opacity($r('app.float.icon_component_opacity'))
  }

  private getShadow(): ShadowOptions | ShadowOptions[] {
    //白底字体时附上阴影
    if (this.contentColor === '#FFFFFF') {
      return [
        {
          radius: 2,
          color: '#33000000',
          offsetY: 1
        },
        {
          radius: 6,
          color: '#33000000',
          offsetY: 2
        }
      ]
    } else {
      return { radius: 0 };
    }
  }

  updateTimeInfo(date: Date) {
    log.showInfo(`updateTimeInfo date:${date.toString()}`);
    this.is24HourFormat = this.get24HourFormat();
    const formatTime: Intl.DateTimeFormatOptions =
      { timeStyle: 'short', hour12: !this.is24HourFormat, timeZone: this.getTimeZoneId() };
    const formatDate: Intl.DateTimeFormatOptions =
      { month: 'short', day: 'numeric', timeZone: this.getTimeZoneId() };
    this.mTime = this.formatDate(date, formatTime);
    this.mDate = this.formatDate(date, formatDate);
    log.showInfo(`updateTimeInfo mTime:${this.mTime} mDate:${this.mDate.toString()}`);
  }

  /**
   * 格式化时间信息
   *
   * @param displayDate 当前日期
   * @param format 时间日期格式化对象
   * @returns 显示日期/时间
   */
  formatDate(displayDate: Date, format: Intl.DateTimeFormatOptions): string {
    try {
      const date = new Date(displayDate);
      let locale: Intl.Locale = new Intl.Locale(i18n.System.getSystemLanguage());
      const dateFormat: Intl.DateTimeFormat = new Intl.DateTimeFormat(locale.toString(), format);
      const dateStr: string = dateFormat.format(date);
      // 存在内存泄漏，需要手动释放
      // MemoryUtils.removeNapiWrap(dateFormat, false);
      return dateStr;
    } catch (error) {
      log.showError(`formatDate Error = ${error?.name}, ${error?.code}, ${error?.message}`);
    }
    return '';
  }

  get24HourFormat(): boolean {
    return i18n.System.is24HourClock();
  }

  /**
   * 获取系统时区
   */
  private getTimeZoneId(): string {
    return i18n.getTimeZone().getID();
  }

  onLanguageChange(): void {
    this.updateTimeInfo(this.date);
  }

  onReceiveNewNotification(): void {
    log.showInfo('isHasUnReadNotification:' + this.hasUnReadNotification);
  }

  onTimeChange(): void {
    log.showInfo(`onTimeChange time ${this.mTime}`);
  }

  onDateChange(): void {
    log.showInfo(`onDateChange date ${this.date}`);
  }
}