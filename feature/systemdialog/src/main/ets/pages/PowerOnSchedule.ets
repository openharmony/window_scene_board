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

import I18n from '@ohos.i18n';
import Intl from '@ohos.intl';
import { settings } from '@kit.BasicServicesKit';
import { poweroffController } from '../controller/PoweroffController';
import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import PowerOffStyleConstants from '../common/PoweroffStyleConstants';

const TAG = 'PowerOnSchedule';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

@Component
export struct PowerOnSchedule {
  /**
   * 是否展示
   */
  @State isShow: boolean = false;
  /**
   * 气泡提示信息
   */
  private popupMessage: ResourceStr = '';
  /**
   * 是否选中
   */
  @State isChecked: boolean = true;
  /**
   * 文本内容
   */
  @State content: ResourceStr = '';
  /**
   * 显示气泡回调
   */
  handleShowToast: (message: ResourceStr) => void = () => {
  };
  /**
   * 更新状态
   */
  handleChangeStatus: (status: boolean) => void = () => {
  };
  /**
   * 更新开关状态
   */
  handleSwitchPowerOn: (status: boolean) => void = () => {
  };

  aboutToAppear() {
    log.showInfo(TAG, `aboutToAppear`);
    this.init();
  }

  aboutToDisappear() {
    log.showInfo(TAG, `aboutToDisappear`);
  }

  private init(): void {
    this.isShow = this.isShowPowerOnSwitch();
    if (this.isShow) {
      const timestamp = this.getNextPowerOnTimestamp();
      this.handleSwitchPowerOn(true);
      // 如果值为-1表示单次已执行过
      if (Number(timestamp) > 0 && !CheckEmptyUtils.checkStrIsEmpty(timestamp)) {
        this.content = this.getShowTimeStr(Number.parseInt(timestamp));
        this.popupMessage = $r('app.string.power_schedule_switch_toast');
        this.handleChange(true);
      }
    }
  }

  /**
   * 获取设置定时开关机的开关状态
   */
  private isShowPowerOnSwitch(): boolean {
    const switchKey = PowerOffStyleConstants.SCHEDULED_POWER_ON_OFF_SWITCH;
    const domainName = settings.domainName.DEVICE_SHARED;
    const status = poweroffController.getValueSyncByContext(getContext(this), switchKey, '0', domainName);
    const result = Number.parseInt(status) > 0;
    log.showInfo(TAG, `get power on off status ${status} ${result}`);
    return result;
  }

  /**
   * 获取下一次定时开机的时间戳(毫秒)
   */
  private getNextPowerOnTimestamp(): string {
    const dateKey = PowerOffStyleConstants.SCHEDULED_POWER_ON_TIMER_DATE;
    const domainName = settings.domainName.DEVICE_SHARED;
    const timestamp = poweroffController.getValueSyncByContext(getContext(this), dateKey, '', domainName);
    log.showInfo(TAG, `get next power on timestamp ${timestamp}`);
    return timestamp;
  }

  /**
   * 转化目标时间戳为形如: 下午13:04 格式
   */
  private formatTimeAndRelease(targetTimestamp: number): string {
    const local: string = I18n.System.getSystemLocale();
    const option: Intl.DateTimeOptions = {
      locale: local,
      timeZone: I18n.getTimeZone()?.getID(),
      hourCycle: I18n.System.is24HourClock() ? 'h23' : 'h12',
      hour: '2-digit',
      minute: '2-digit',
    };
    const formatter: Intl.DateTimeFormat = new Intl.DateTimeFormat(local, option);
    // 目标日期对象
    const targetDate = new Date(targetTimestamp);
    const result = formatter.format(targetDate);

    // DateTimeFormat在native侧存在一些内存占用，需要在format实例使用完后手动调用removeNapiWrap触发此部分native内存回收
    // MemoryUtils.removeNapiWrap(formatter, false);
    log.showInfo(TAG, `formatTimeAndRelease ${result}`);
    return result;
  }

  /**
   * 转化目标时间戳为：今天|明天|后天|x天后
   */
  private formatRelativeTime(targetTimestamp: number): string {
    const curTimestamp = Date.now();
    const curDate = new Date(curTimestamp);
    // 创建一个目标日期对象
    const targetDate = new Date(targetTimestamp);
    const startDay = new Date(curDate.getFullYear(), curDate.getMonth(), curDate.getDate());
    const endDay = new Date(targetDate.getFullYear(), targetDate.getMonth(), targetDate.getDate());
    const diffTime = endDay.getTime() - startDay.getTime();
    // 计算天数差值
    const diffDays = diffTime / (1000 * 60 * 60 * 24);

    let local: string = I18n.System.getSystemLocale();
    // 计算相对时间
    const formatter = new Intl.RelativeTimeFormat(local, { numeric: 'auto' });
    const result = formatter.format(diffDays, 'day');
    // MemoryUtils.removeNapiWrap(formatter, false);
    return result;
  }

  /**
   * 获取定时开机提示信息文本
   */
  private getShowTimeStr(targetTimestamp: number): ResourceStr {
    const relativeTime = this.formatRelativeTime(targetTimestamp);
    const timeStr = this.formatTimeAndRelease(targetTimestamp);
    const message = `${relativeTime}${timeStr}`;
    const result = $r('app.string.power_schedule_switch_reminder', message);
    log.showInfo(TAG, `getShowTimeStr, message: ${message}`);
    return result;
  }

  /**
   * 更新选中状态
   */
  private handleChange(status: boolean): void {
    this.isChecked = status;
    this.handleChangeStatus(status);
    if (!status) {
      this.handleShowToast(this.popupMessage);
    }
  }

  @Builder
  buildItem() {
    Row({ space: 12 }) {
      // 多选框
      Column() {
        Checkbox({ name: 'scheduled_power_on', group: 'checkbox_group' })
          .selectedColor($r('sys.color.ohos_id_color_focused_bg'))
          .shape(CheckBoxShape.CIRCLE)
          .select(this.isChecked)
          .hitTestBehavior(HitTestMode.None)
          .borderRadius(80)
          .width(20)
          .height(20)
          .margin(2)
      }
      .justifyContent(FlexAlign.Start)
      .width(24)
      .height(24)
      .margin(0)

      // 文本
      Column() {
        Text(this.content)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(Color.White)
          .draggable(false)
          .textAlign(TextAlign.Start)
          .wordBreak(WordBreak.NORMAL)
          .maxFontScale(2)
          .margin({ top: 3 })
      }
      .alignItems(HorizontalAlign.Start) // column内的元素左对齐
      .layoutWeight(1)
    }
    .onClick((e: ClickEvent) => {
      this.handleChange(!this.isChecked);
    })
    .alignItems(VerticalAlign.Top) // row内的元素在垂直方向置顶
    .padding({ top: 12, bottom: 12 })
  }

  build() {
    if (this.isShow && this.content) {
      this.buildItem()
    }
  }
}
