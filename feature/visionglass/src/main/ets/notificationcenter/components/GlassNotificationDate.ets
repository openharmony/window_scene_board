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

import { ConfigurationEvent, EventManager, EvtBus, TimeChangeEvent } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { GlassLayoutSize, NtfColor, NtfSize } from '../../common/constants/GlassLayoutConstants';
import DateTime from '../../common/utils/DateTime';
import NotificationConstant from '../common/NotificationConstant';
import { DateTimeUtil } from '../common/utils/DateTimeUtil';

@Component
export struct GlassNotificationDate {
  private eventMgr: EventManager = EvtBus.createEventManager();
  @State date: string = DateTimeUtil.getCurrentDate();
  @State weekInfo: string = DateTimeUtil.formatDateNoMonthDay(new Date());
  @Consume mDateTime: DateTime;

  aboutToAppear(): void {
    this.eventMgr
      .on(ConfigurationEvent, this.onConfigurationEvent)
      .on(TimeChangeEvent, this.onTimeChangeEvent)
    this.updateTimeAndDate();
  }

  aboutToDisappear(): void {
    this.eventMgr.offAll()
  }

  private updateTimeAndDate(): void {
    this.date = DateTimeUtil.getCurrentDate();
    this.weekInfo = DateTimeUtil.formatDateNoMonthDay(new Date());
  }

  onConfigurationEvent = () => {
    this.updateTimeAndDate();
  }
  onTimeChangeEvent = () => {
    this.updateTimeAndDate();
  }

  build() {
    Row() {
      Text(this.mDateTime.clockTime)
        .fontColor(NtfColor.NTF_TITLE_TIME_COLOR)
        .fontSize(GlassLayoutSize.FONT_SIZE_72)
        .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
      Row() {
        Text(this.date)
          .fontColor(NtfColor.NTF_TITLE_TIME_COLOR)
          .fontSize(NtfSize.NTF_TITLE_DATE_FONT_SIZE)
          .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
          .margin({ left: NotificationConstant.NTF_MARGIN_15 })
        Text(this.weekInfo)
          .fontColor(NtfColor.NTF_TITLE_DATE_COLOR)
          .fontSize(NtfSize.NTF_TITLE_DATE_FONT_SIZE)
          .fontFamily(GlassLayoutSize.HARMONYOS_SANS_SC)
      }
      .layoutWeight(1)
      .height(NtfSize.NTF_TITLE_DATE_FONT_SIZE)
    }
    .alignItems(VerticalAlign.Bottom)
    .height(NotificationConstant.TIME_SIZE_72)
  }
}