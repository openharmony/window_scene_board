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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScreenSessionManager, SCBPropertyChangeReason } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSessionManager';
import { SCBScreenProperty } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSession';
import Constants from '../common/constants';
import { LowerStatusDialogType } from './ShutdownCustomDialog';
import { display } from '@kit.ArkUI';
import measure from '@ohos.measure';

const TAG = 'OuterShutdownCustomDialog';
const dialogPaddingVertical = 8;
const dialogPaddingHorizontal = 16;
const dialogMarginHorizontal = 16;
const dialogFontSize = 14;
const dialogLineHeight = 17;
const outerDialogFontMaxScale = 2;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const emergencyDialogContent: ResourceStr = $r('app.string.battery_emergency_dialog_content',
  Constants.BATTERY_LEVEL_LOW_TIMEOUT);
const shutDownDialogContent: ResourceStr = $r('app.string.shutdown_dialog_content_new',
  Constants.BATTERY_LEVEL_LOW_TIMEOUT);

/**
 * 低电量关机弹框提醒 扩展新形态小折叠产品
 */
@CustomDialog
export struct OuterShutdownCustomDialog {
  dialogController?: CustomDialogController;
  @State dialogWidth: number = 1;
  @Prop dialogType: LowerStatusDialogType = LowerStatusDialogType.SHUTDOWN;

  aboutToDisappear() {
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(
      this.screenPropertyChangeCallbackFunc, undefined, true, 0);
  }

  aboutToAppear() {
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(
      this.screenPropertyChangeCallbackFunc, undefined, false, 0);
    this.getDialogWidth();
  }

  private getDialogWidth(): void {
    try {
      if (canIUse('SystemCapability.WindowManager.WindowManager.Core')) {
        this.dialogWidth = px2vp(display.getDefaultDisplaySync().width) - (dialogMarginHorizontal * 2);
        return;
      }
    } catch (error) {
      log.error(`getDialogWidth error. ${error?.message}`);
    }
    this.dialogWidth = 1;
  }

  private calTextLines(text: ResourceStr, fontSize: number, fontWeight: FontWeight, lineHeight: number): number {
    try {
      if (canIUse('SystemCapability.ArkUI.ArkUI.Full')) {
        return Math.round(px2vp(measure.measureText({
          textContent: text,
          fontSize: fontSize,
          lineHeight: lineHeight,
          fontWeight: fontWeight
        })));
      }
    } catch (error) {
      log.error(`calTextLines error. ${error?.message}`);
    }
    return 0;
  }

  private getDialogContent(): ResourceStr {
    log.showInfo(`getDialogContent: ${this.dialogType}`);
    if (this.dialogType === LowerStatusDialogType.EMERGENCY_MODE) {
      return emergencyDialogContent;
    }
    return shutDownDialogContent;
  }

  private screenPropertyChangeCallbackFunc = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(`propertyChange width: ${px2vp(screenProperty.width)} height:${px2vp(screenProperty.height)}`);
    if (reason === SCBPropertyChangeReason.FOLD_TO_EXPAND || reason === SCBPropertyChangeReason.EXPAND_TO_FOLD) {
      this.getDialogWidth();
    }
  };

  build() {
    Column() {
      Text(this.getDialogContent())
        .fontSize(dialogFontSize)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .draggable(false)
        .textAlign(this.calTextLines(this.getDialogContent(), dialogFontSize,
          FontWeight.Regular, dialogLineHeight) > (
            this.dialogWidth - (dialogLineHeight * 2)) ? TextAlign.Start : TextAlign.Center)
        .lineHeight(dialogLineHeight)
        .margin({
          top: dialogPaddingVertical,
          bottom: dialogPaddingVertical,
          left: dialogPaddingHorizontal,
          right: dialogPaddingHorizontal,
        })
        .maxFontScale(outerDialogFontMaxScale)
    }
    .width(this.dialogWidth)
    .alignItems(HorizontalAlign.Center)
    .accessibilityGroup(true)
    .accessibilityLevel('yes')
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK, undefined, { disableSystemAdaptation: true })
    .borderRadius($r('sys.float.ohos_id_corner_radius_tips_instant_tip'))
    .clip(true)
  }
}