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
import DateTimeModel from '../model/DateTimeModel';
import { IThemeParam } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import UnlockClockAnimParam from '../../../common/UnlockClockAnimParam';
import I18n from '@ohos.i18n';
import { ClockWidgetVD } from '../viewmodel/ClockWidgetVD';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { ClockDateTextParam, ClockStyleConst } from '../common/Constants';

const TAG = 'ScreenLock-DateView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Component
export struct DateView {
  @Link dateTimeModel: DateTimeModel;
  @State lunarVisible: boolean = false;
  @Prop clockAnim: UnlockClockAnimParam;
  @Link clockWidgetVD: ClockWidgetVD;
  @Prop themeClockParam: IThemeParam;
  @Prop textShadow: ShadowOptions;
  @StorageProp('systemLanguage') @Watch('updateLanguageStatus') systemLanguage: string = '';
  @State isZh: boolean = I18n.System.getSystemLanguage().indexOf('zh') >= 0;
  private chineseLanguages = ['zh-Hans-CN', 'zh-Hans', 'zh-Hant-CN', 'zh-Hant'];

  private updateLanguageStatus() {
    log.showInfo(`systemLanguage change to ${this.systemLanguage}`);
    this.lunarVisible = this.chineseLanguages.includes(this.systemLanguage);
    this.isZh = I18n.System.getSystemLanguage().indexOf('zh') >= 0;
  }

  aboutToAppear() {
    this.lunarVisible = this.chineseLanguages.includes(this.systemLanguage);
  }

  @Builder
  dateComponentBuilder(param: ClockDateTextParam) {
    Text(param.textContent)
      .fontColor(param.fontColor)
      .fontWeight('medium')
      .draggable(false)
      .fontSize(this.clockWidgetVD.rotateParam!.dateFontSize)
      .textAlign(TextAlign.Center)
      .clip(false)
      .textShadow(param.shadowOptions)
  }

  build() {
    Row({ space: 12 }) {
      this.dateComponentBuilder({
        textContent: this.dateTimeModel.date,
        fontColor: ClockStyleConst.CLOCK_WIDGE_OPAQUE.fontColor,
      })
      this.dateComponentBuilder({
        textContent: this.dateTimeModel.weekDay,
        fontColor: ClockStyleConst.CLOCK_WIDGE_OPAQUE.fontColor,
      })
      if (this.lunarVisible) {
        this.dateComponentBuilder({
          textContent: this.dateTimeModel.lunarDate,
          fontColor: ClockStyleConst.CLOCK_WIDGE_OPAQUE.fontColor,
        })
      }
    }
    .margin({
      left: 5,
      right: 5
    })
    .opacity(this.clockAnim.dateViewOpacity)
    .scale({
      x: this.clockAnim.dateViewScale,
      y: this.clockAnim.dateViewScale
    })
    .translate({
      y: this.clockAnim.dateViewTranslate
    })
  }
}