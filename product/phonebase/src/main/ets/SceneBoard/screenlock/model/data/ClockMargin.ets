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

import curves from '@ohos.curves';

/**
 * 时钟边距类
 */
export class ClockMargin {
  @Track public clockWidgetLeftMargin: number = 0;
  @Track public clockWidgetRightMargin: number = 0;
  @Track public clockWidgetTopMargin: number = 0;
  @Track public clockBorderLeftMargin: number = 0;
  @Track public clockBorderTopMargin: number = 0;

  public updateClockMargin(widgetLeftMargin: number, widgetRightMargin: number, widgetTopMargin: number,
    borderLeftMargin: number, borderTopMargin: number) {
    this.clockWidgetLeftMargin = widgetLeftMargin;
    this.clockWidgetRightMargin = widgetRightMargin;
    this.clockWidgetTopMargin = widgetTopMargin;
    this.clockBorderLeftMargin = borderLeftMargin;
    this.clockBorderTopMargin = borderTopMargin;
  }

  public animateToMargin(widgetLeftMargin: number, widgetRightMargin: number, widgetTopMargin: number,
    borderLeftMargin: number, borderTopMargin: number) {
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 228, 30)
    }, () => {
      this.updateClockMargin(widgetLeftMargin, widgetRightMargin, widgetTopMargin, borderLeftMargin, borderTopMargin);
    });
  }

  public updateClockHorizontalMargin(widgetLeftMargin: number, widgetRightMargin: number,
    borderLeftMargin: number) {
    this.clockWidgetLeftMargin = widgetLeftMargin;
    this.clockWidgetRightMargin = widgetRightMargin;
    this.clockBorderLeftMargin = borderLeftMargin;
  }

  public updateClockVerticalMargin(widgetTopMargin: number,
    borderTopMargin: number) {
    this.clockWidgetTopMargin = widgetTopMargin;
    this.clockBorderTopMargin = borderTopMargin;
  }

  public animateToHorizontalMargin(widgetLeftMargin: number, widgetRightMargin: number,
    borderLeftMargin: number) {
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 228, 30)
    }, () => {
      this.updateClockHorizontalMargin(widgetLeftMargin, widgetRightMargin, borderLeftMargin);
    });
  }
}