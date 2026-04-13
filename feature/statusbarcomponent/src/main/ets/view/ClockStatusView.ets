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
import { PluginInfo, PluginSlot } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { IStatusBarIconAnimVm, StatusBarVmInjector } from '@ohos/systemuicommon/newIndex';
import { ClockShowType, ClockWidth } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarEnum';
import { TimeFormatEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { InnerEventUtil } from '@ohos/systemuicommon/src/main/ets/utils/InnerEventUtil';
import { StatusBarClockIconVm } from '../vm/StatusBarClockIconVm';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { i18n } from '@kit.LocalizationKit';

// instrument ignore file

const TAG = 'ClockStatusView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const COMPONENT_ID_TIME_TEXT = 'TimeView_Text_timeText';

// 定义时间订阅者，用于保存创建成功的订阅者对象，后续使用其完成订阅及退订的动作
let subscriber: commonEventManager.CommonEventSubscriber;
// 时间订阅者信息
let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    'usual.event.TIME_CHANGED'
  ]
};

@ComponentV2
export struct ClockStatusView {
  @Local format: string = i18n.System.is24HourClock() ? 'HH' : 'hh';
  @Param @Require pluginInfo: PluginInfo;
  @Consumer() statusBarVmInjector: StatusBarVmInjector = StatusBarVmInjector.HOLDER;
  @Local date: Date = new Date();
  iconListVm = this.statusBarVmInjector.getStatusBarIconListVm();
  private fontSize: number = ResUtils.getNumber($r('app.float.plugin_phone_clock_font_size'));
  /**
   * 字体样式，默认Medium
   */
  private fontWeight: FontWeight = FontWeight.Medium;
  @Local private isTimeFormat24: boolean = true;

  initFormatValue(): void {
    // 创建订阅者
    try {
      commonEventManager.createSubscriber(subscribeInfo,
        (err: BusinessError, commonEventSubscriber: commonEventManager.CommonEventSubscriber) => {
          if (err) {
            log.error(`ClockStatusView Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
          } else {
            log.showInfo(`ClockStatusView Succeeded in creating subscriber.`);
            subscriber = commonEventSubscriber;
            // 订阅公共事件
            try {
              commonEventManager.subscribe(subscriber,
                (err: BusinessError, data: commonEventManager.CommonEventData) => {
                if (err) {
                  log.error(`ClockStatusView Failed to subscribe. Code is ${err.code}, message is ${err.message}`);
                  return;
                }
                log.showInfo(`ClockStatusView Succeeded to receive common event, data is ok`);
                this.format = i18n.System.is24HourClock() ? 'HH' : 'hh';
              });
            } catch (error) {
              let err: BusinessError = error as BusinessError;
              log.error(`ClockStatusView Failed to subscribe. Code is ${err.code}, message is ${err.message}`);
            }
          }
        });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      log.error(`ClockStatusView Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
    }
  }

  aboutToAppear(): void {
    this.clockVm.init(this.pluginInfo);
    InnerEventUtil.on(TimeFormatEvent, this.onTimeFormatEvent);
    log.showInfo(`about to appear`)
    this.initFormatValue();
    log.showInfo(`normalClockWidth: ${ClockWidth.NORMAL_WIDTH}, extrudeClockWidth: ${ClockWidth.EXTRUDE_WIDTH}`)
  }

  aboutToDisappear(): void {
    try {
      if (subscriber) {
        commonEventManager.unsubscribe(subscriber);
      }
    } catch (error) {
      log.showError('commonEventManager unsubscribe error', error);
    }
    log.showInfo(`about to disappear`)
  }

  @Computed
  get getStatusBarIconAnimVm(): IStatusBarIconAnimVm {
    return this.statusBarVmInjector.getStatusBarIconAnimVm();
  }

  @Computed
  get textScale(): number {
    return this.statusBarVmInjector.getStatusBarIconAnimVm().clockTextScale;
  }

  @Computed
  get clockVm(): StatusBarClockIconVm {
    return this.statusBarVmInjector.getStatusBarIconVm(PluginSlot.SLOT_STATUS_CLOCK) as StatusBarClockIconVm;
  }

  onTimeFormatEvent = (event: TimeFormatEvent) => {
    log.showInfo(`onTimeFormatEvent, ${event.isTimeFormat24()}`);
    this.isTimeFormat24 = event.isTimeFormat24();
  }

  @Computed get hour() {
    let curHour = this.date.getHours();
    if (!this.isTimeFormat24 && curHour === 0) {
      curHour = 12;
    }
    if (!this.isTimeFormat24 && curHour > 12) {
      curHour -= 12;
    }
    return curHour.toString().padStart(2, '0')
  }

  @Computed get minute() {
    return this.date.getMinutes().toString().padStart(2, '0')
  }

  getAccessibilityText() {
    const text = this.hour + ':' + this.minute;
    return text;
  }

  build() {
    Row() {
      Flex({
        direction: this.getStatusBarIconAnimVm.isExtrudeType ? FlexDirection.Column : FlexDirection.Row,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Center
      }) {
        Row() {
          TextClock()
            .format(this.format)
            .dateTimeOptions({ hour: '2-digit' })
            .draggable(false)
            .id(COMPONENT_ID_TIME_TEXT)
            .fontSize(this.fontSize + 'vp')
            .fontWeight(this.fontWeight)
            .fontFamily('HarmonyHeiTi')
            .fontColor(this.iconListVm.contentColor)
            .clip(false)

          Text(':')
            .fontSize(this.fontSize + 'vp')
            .fontColor(this.iconListVm.contentColor)
            .fontWeight(this.fontWeight)
            .lineHeight('100%')
            .opacity(this.clockVm.separatorOpacity)
            .visibility(this.getStatusBarIconAnimVm.isExtrudeType ? Visibility.None : Visibility.Visible)
            .id(COMPONENT_ID_TIME_TEXT)
        }
        .scale({
          x: this.textScale,
          y: this.textScale,
          centerX: '50%',
          centerY: '50%'
        })
        .direction(Direction.Ltr) // 镜像语言下 时间冒号不能反向

        TextClock()
          .format('mm')
          .dateTimeOptions({ hour: '2-digit' })
          .draggable(false)
          .id(COMPONENT_ID_TIME_TEXT)
          .fontSize(this.fontSize + 'vp')
          .fontWeight(this.fontWeight)
          .fontFamily('HarmonyHeiTi')
          .fontColor(this.iconListVm.contentColor)
          .clip(false)
          .scale({
            x: this.textScale,
            y: this.textScale,
            centerX: '50%',
            centerY: '50%'
          })
          .onDateChange((value) => {
            this.date = new Date(value * 1000);
          })
      }
      .opacity(this.clockVm.capsuleLayoutOpacity)
      .width(this.getStatusBarIconAnimVm.isExtrudeType ? this.clockVm.statusBarClockExtrudeWidth :
        this.clockVm.statusBarClockNormalWidth)
      .height('100%')
      .id(TAG)
      .accessibilityLevel('yes')
      .accessibilityGroup(true)
      .accessibilityText(this.getAccessibilityText())
      .direction(Direction.Ltr) // 镜像语言下 时间数字不能反向
    }
    .height('100%')
    .justifyContent(FlexAlign.Start)
  }

}