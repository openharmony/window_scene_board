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

import ScreenLockService from '../../refactor/ScreenLockService';
import DateTimeModel from './model/DateTimeModel';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { IThemeParam } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import UnlockClockAnimParam from '../../common/UnlockClockAnimParam';
import { ScreenLockLayoutManager } from '../../common/ScreenLockLayoutManager';
import {
  SCBScreenPowerEvent,
  SCBScreenPowerEventStatus,
  SCBScreenPowerEventType
} from '../../../scenemanager/SCBScreen';
import { TimeView } from './subview/TimeView';
import { DateView } from './subview/DateView';
import { ClockStyleConst, ClockStyleParam, ClockWidgetId } from './common/Constants';
import { SignView } from './subview/SignView';
import { ClockWidgetVD } from './viewmodel/ClockWidgetVD';
import { ClockRotateAni } from './viewmodel/ClockRotateAni';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import Constants from '../../common/Constants';

const TAG = 'ScreenLock-ClockWidget';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const COMPONENT_ID_DIGITAL_CLOCK_VIEW = TAG + '_Text_Digital_Clock';

@Extend(Stack)
function blendStyle(blendStyles: number, blendApply: BlendApplyType) {
  .pixelRound({
    start: PixelRoundCalcPolicy.FORCE_FLOOR,
    top: PixelRoundCalcPolicy.FORCE_FLOOR,
    end: PixelRoundCalcPolicy.FORCE_CEIL,
    bottom: PixelRoundCalcPolicy.FORCE_CEIL
  })
}

@Component
export default struct ClockWidget {
  @State dateTimeModel: DateTimeModel = new DateTimeModel();
  @StorageProp('isScreenOn') @Watch('onScreenOn') isScreenOn: boolean = ScreenLockService.isScreenOn;
  @Link themeClockParam: IThemeParam;
  @Prop clockAnim: UnlockClockAnimParam;
  private registerTaskId: number = -1;
  private gridWidth: number = ScreenLockLayoutManager.getInstance().gridWidth;
  private clockWidth: number = this.gridWidth * ScreenLockLayoutManager.getInstance().clockGridColumns;
  private clockHeight: number = this.gridWidth * ScreenLockLayoutManager.getInstance().clockGridRows;
  @StorageLink('screenPowerEvent') @Watch('onScreenPowerEventChange') powerEvent: SCBScreenPowerEvent =
    new SCBScreenPowerEvent();
  @State clockWidgetVD: ClockWidgetVD = new ClockWidgetVD();
  private clockRotateAni: ClockRotateAni = new ClockRotateAni();
  @StorageLink('isScreenLockWallpaperBrightOrDark') @Watch('getBrightnessOption') isBrightWallPaper: boolean = false;

  private onScreenPowerEventChange(): void {
    if (this.powerEvent.eventType === SCBScreenPowerEventType.DISPLAY_ON &&
      this.powerEvent.eventStatus === SCBScreenPowerEventStatus.END) {
      this.dateTimeModel.setDateTime();
    }
  }

  private getBrightnessOption(): BrightnessOptions | undefined {
    return this.isBrightWallPaper ? BrightnessOptionUtils.lockIconNormalOption :
    BrightnessOptionUtils.keyguardTimeLightOption;
  }

  async aboutToAppear() {
    log.showInfo('ClockWidget aboutToAppear');
    this.dateTimeModel.setDateTime();
    this.registerTaskId = setTimeout((): void => this.dateTimeModel.registerDateTimeEvent(), 100);
    this.clockWidgetVD.initData();
    this.clockRotateAni.initAnimate(this.clockWidgetVD, false);
  }

  aboutToDisappear() {
    log.showInfo('ClockWidget aboutToDisappear');
    clearTimeout(this.registerTaskId);
    this.dateTimeModel.unregisterDateTimeEvent();
    this.clockRotateAni.destroy();
  }

  onScreenOn() {
    this.dateTimeModel.setDateTime();
  }

  @Builder
  clockBuilder(param: ClockStyleParam) {
    Column() {
      TimeView({
        dateTimeModel: this.dateTimeModel,
        themeClockParam: this.themeClockParam,
        clockAnim: this.clockAnim,
        clockWidgetVD: this.clockWidgetVD,
        textShadow: param.timeShadow,
      })
        .id(ClockWidgetId.TIME)

      Blank()
        .height(this.clockWidgetVD.rotateParam?.timeAndDateSpace)

      DateView({
        dateTimeModel: this.dateTimeModel,
        themeClockParam: this.themeClockParam,
        clockAnim: this.clockAnim,
        clockWidgetVD: this.clockWidgetVD,
        textShadow: param.dateShadow,
      })
        .id(ClockWidgetId.DATE)
    }.opacity(param.opacityLevel)
  }

  build() {
    RelativeContainer() {
      Stack() {
        this.clockBuilder(ClockStyleConst.CLOCK_WIDGE_WITH_SHADOW_OPACITY)
        EffectComponent() {
          Stack() {
            this.clockBuilder(ClockStyleConst.CLOCK_WIDGE_OPAQUE)

            Stack()
              .useEffect(true)
              .backgroundColor(this.isBrightWallPaper ? '#00000000' : ClockStyleConst.CLOCK_WIDGE_OPAQUE.fontColor)
              .width('100%')
              .height('100%')
            Column() {
            }
            .width('100%')
            .height('100%')
            .backgroundColor('#00000000')
          }
        }
        .backgroundEffect(this.isBrightWallPaper ? ClockStyleConst.clockWidgeBrightnessBright :
        ClockStyleConst.clockWidgeBrightness)
      }
      .alignRules({
        center: { anchor: ClockWidgetId.ROOT, align: VerticalAlign.Center },
        middle: { anchor: ClockWidgetId.ROOT, align: HorizontalAlign.Center }
      })


      SignView({
        themeClockParam: this.themeClockParam,
        signatureText: this.themeClockParam.signatureText,
        signatureVisible: this.themeClockParam.signatureVisible,
      })
        .id(ClockWidgetId.SIGN)
        .alignRules({
          top: { anchor: ClockWidgetId.ROOT, align: VerticalAlign.Bottom },
          middle: { anchor: ClockWidgetId.ROOT, align: HorizontalAlign.Center }
        })
    }
    .width(this.clockWidth)
    .height(this.clockHeight)
    .id(COMPONENT_ID_DIGITAL_CLOCK_VIEW)
    .border({
      color: $r('app.color.screenlock_clock_widget_border_color')
    })
    .scale({
      x: this.clockAnim.timeViewScale,
      y: this.clockAnim.timeViewScale,
      centerX: '50%',
      centerY: '100%'
    })
  }
}