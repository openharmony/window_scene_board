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
import { ResUtils } from '@ohos/windowscene';
import DateTimeModel from '../model/DateTimeModel';
import { IThemeParam } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import UnlockClockAnimParam from '../../../common/UnlockClockAnimParam';
import { ClockWidgetVD } from '../viewmodel/ClockWidgetVD';
import { ClockStyleConst, ClockTimeTextParam } from '../common/Constants';
import StyleConfiguration, { ScreenlockComponentStyle } from '../../../common/StyleConfiguration';

const TAG = 'ScreenLock-TimeView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const COMPONENT_ID_DIGITAL_TEXT_VIEW = TAG + '_Text_Digital_Text';

@Extend(Text)
function timeTextStyle(param: ClockTimeTextParam) {
  .fontSize(param.fontSize)
  .lineHeight(param.fontSize)
  .height(0.85 * param.fontSize)
  .textAlign(TextAlign.Center)
  .fontWeight(param.fontWeight)
  .fontColor(param.fontColor)
  .fontFamily(param.fontFamily)
  .maxLines(1)
  .maxFontScale(1)
  .minFontScale(1)
  .draggable(false)
  .letterSpacing(-2)
  .id(`${COMPONENT_ID_DIGITAL_TEXT_VIEW}`)
  .clip(false)
}

@Component
export struct TimeView {
  @Link dateTimeModel: DateTimeModel;
  @Prop textAlign: TextAlign;
  @Link themeClockParam: IThemeParam;
  @StorageProp('systemLanguage') @Watch('updateLanguageStatus') systemLanguage: string = '';
  @Prop @Watch('onAnimClockParamUpdate') clockAnim: UnlockClockAnimParam;
  @Link clockWidgetVD: ClockWidgetVD;
  @Prop textShadow: ShadowOptions;
  private timeViewStyle: ScreenlockComponentStyle = StyleConfiguration.getScreenlockComponentStyle();

  private updateLanguageStatus() {
    log.showInfo(`systemLanguage change to ${this.systemLanguage}`);
    this.dateTimeModel.setDateTime();
  }

  onAnimClockParamUpdate(): void {
    if (this.clockAnim.isOpenCoverAnimation) {
      log.showInfo('Skip the correction of clock date translate.');
      return;
    }
    log.showInfo(`DigitalClock onAnimClockParamUpdate editStatus = ${this.clockAnim?.dateViewTranslate}`);
    if (this.clockAnim.dateViewTranslate !== UnlockClockAnimParam.DEFAULT_TRANSLATE) {
      this.clockAnim.dateViewTranslate =
        '-' + ResUtils.getNumber($r('app.float.edit_clockwidget_date_text_line_height'));
    }
  }

  build() {
    Text(this.dateTimeModel.clockTime)
      .timeTextStyle({
        fontSize: this.clockWidgetVD.rotateParam!.timeFontSize,
        fontColor: ClockStyleConst.CLOCK_WIDGE_OPAQUE.fontColor,
        fontFamily: this.themeClockParam.fontFamily,
        fontWeight: this.timeViewStyle.clockFontBold
      })
      .textShadow(this.textShadow)
      .opacity(this.clockAnim.timeViewOpacity)
      .translate({
        y: this.clockAnim.timeViewDigitalTranslate
      })
      .scale({
        x: this.clockAnim.timeViewDigitalScale,
        y: this.clockAnim.timeViewDigitalScale,
      })
  }
}