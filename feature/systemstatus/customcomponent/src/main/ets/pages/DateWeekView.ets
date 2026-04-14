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

import { CommonUtils, LogHelper, LogDomain } from '@ohos/basicutils';
import { DateWeekVM } from '../vm/DateWeekVM';

const COMPONENT_ID_DATE_TEXT = 'DateWeekView_Text_dateText';
const TAG = 'PhoneNotificationCenterTitle_DateWeekView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 日期-星期组件
 * 主要用于通知中心、锁屏
 *
 * @since 2022-12-12
 */
@Component
export struct DateWeekView {
  /**
   * 日期文本
   */
  @State dateText: string = '';

  @Prop isRenderGroupEnable: boolean = false;

  /**
   * 字体大小
   */
  private fontSize: Resource | string = '';

  /**
   * 字体颜色
   */
  private fontColor: ResourceColor = '#00000000';

  /**
   * 字体样式，默认Regular
   */
  private fontWeight: FontWeight = FontWeight.Regular;

  /**
   * 唯一标示
   */
  private slot: string = '';

  /**
   * VM
   */
  private dateWeekVM: DateWeekVM = new DateWeekVM();

  /**
   * 文本阴影
   */
  private textShadow: ShadowOptions | null = null;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear.`);
    this.dateWeekVM.init(this.slot, this);
  }

  aboutToDisappear(): void {
    this.dateWeekVM.onDestroy();
  }

  /**
   * 复写，日期文本更新回调
   *
   * @param dateText 日期文本
   */
  onTimeTextUpdate(dateText: string): void {
    this.dateText = dateText;
  }

  build() {
    if (!CommonUtils.isEmpty(this.dateText)) {
      Text(this.dateText).draggable(false)
        .id(COMPONENT_ID_DATE_TEXT)
        .fontSize(this.fontSize)
        .fontColor(this.fontColor)
        .fontWeight(this.fontWeight)
        .maxLines(1)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
        .textShadow(this.textShadow)
        .renderGroup(this.isRenderGroupEnable)
        .clip(false)
    }
  }
}