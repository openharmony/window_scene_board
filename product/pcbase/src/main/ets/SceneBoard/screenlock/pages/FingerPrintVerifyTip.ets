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

import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { PCBasePromptViewModel } from '../vm/PCBasePromptViewModel';
import FingerprintViewModel from '../refactor/FingerprintViewModel';
import { TipPriorityConstants } from '../common/TipPriority';
import { CommonStyle } from '../style/CommonStyle';
import { UserStyle } from '../style/UserStyle';
import Constants from '../common/Constants';
import { MeasureUtils } from '@kit.ArkUI';
import StyleConfiguration, { ScreenlockComponentStyle } from '../common/StyleConfiguration';

const TAG = 'ScreenLock-FingerPrintVerifyTip'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Component
export struct FingerPrintVerifyTip {
  private promptId: string = '';
  private transitionEffect: TransitionEffect | undefined = undefined;
  @Consume customizePromptVM: PCBasePromptViewModel;
  @Prop prompt: string | Resource | undefined;
  @Link visible: boolean;
  @State userStyle: UserStyle = UserStyle.getInstance();
  @State commonStyle: CommonStyle = CommonStyle.getInstance();
  @StorageLink('isScreenLockWallpaperBrightOrDark') isBrightWallPaper: boolean = true;
  @Consume
  private fingerprintViewModel: FingerprintViewModel;
  private globalShowPriority: number | undefined = undefined;
  public onTipChange: (tip: string, showPriority: number | undefined) => void =
    (tip: string, showPriority: number | undefined) => {
    };
  private timeCountDownMatchReg:RegExp = new RegExp('');
  private timeCountDownMatchReg2:RegExp = new RegExp('');
  private lastText: string = '';
  private screenlockStyle: ScreenlockComponentStyle = StyleConfiguration.getScreenlockComponentStyle();
  private uiContextMeasure: MeasureUtils = this.getUIContext().getMeasureUtils();
  private lineHeight: number | string = Constants.TOAST_LINE_HEIGHT;

  aboutToAppear(): void {
    this.timeCountDownMatchReg =
      new RegExp(ResUtils.getInnerString($r('app.string.fp_try_again_pin_after_time')).replace('%s', '.*'));
    this.timeCountDownMatchReg2 =
      new RegExp(ResUtils.getInnerString($r('app.string.fp_try_again_after_time')).replace('%s', '.*'));
  }

  build() {
    Column() {
      if (this.fingerprintViewModel.getIsFingerprintEnable()) {
        Text(this.refreshFingerPrintVerifyTip())
          .draggable(false)
          .id(this.promptId)
          .font({
            family: Constants.TOAST_FONT_FAMILY,
            weight: FontWeight.Bold,
            size: this.screenlockStyle.toastTextFontSize
          })
          .lineHeight(this.lineHeight)
          .maxLines(1)
          .fontColor(this.isBrightWallPaper ? $r('app.color.screen_lock_toast_color_lg') :
          $r('app.color.screen_lock_toast_color_dk'))
          .foregroundBrightness(this.isBrightWallPaper ? CommonStyle.toastDarkBrightness :
          CommonStyle.toastLightBrightness)
          .fontColor(this.userStyle.style.promptColor)
          .textOverflow({ overflow: TextOverflow.None })
          .textShadow(this.userStyle.style.promptShadow)
          .transition(this.transitionEffect)
      }
    }
    .id('FingerPrintVerifyTip')
    .visibility(this.visible ? Visibility.Visible : Visibility.None)
    .width(this.commonStyle.displayWidth - this.commonStyle.promptMargin * 2)
    .margin({ top: '12vp' })
    .justifyContent(FlexAlign.Center)
  }

  private getTipTextHeight(tipText: string): number | string {
    let height: number | string = Constants.TOAST_LINE_HEIGHT;
    log.showInfo(`height ${height}`)
    if (CheckEmptyUtils.checkStrIsEmpty(tipText)) {
      return height;
    }
    height = this.getTextHeight(tipText, this.screenlockStyle.toastTextFontSize, height);
    log.showInfo(`tipText: ${tipText} TipTextHeight: ${height}`)
    return height;
  }

  private getTextHeight(tipText: string, size: number | string | Resource, height: number): number {
    let needTextHeight: number = Math.round(px2vp(this.uiContextMeasure.measureTextSize({
      textContent: tipText,
      fontSize: size,
      fontWeight: FontWeight.Bold,
      maxLines: 1
    }).height as number)) + 2;
    log.showInfo(`needTextHeight ${needTextHeight}`)
    return needTextHeight > height ? needTextHeight : height;
  }

  private refreshFingerPrintVerifyTip(): string {
    let text: string = this.customizePromptVM.prompt || '';
    this.lineHeight = this.getTipTextHeight(text);
    this.globalShowPriority = undefined;
    if (!this.customizePromptVM.haveTryUnlock || !this.customizePromptVM.isShowPrompt) {
      return text;
    } else if (this.timeCountDownMatchReg.test(text) || this.timeCountDownMatchReg2.test(text)) {
      if (this.customizePromptVM.userRetry) {
        this.globalShowPriority = TipPriorityConstants.TIP_PRIORITY_FINGER_PRINT_LOCKED_TIMEOUT_RESHOW;
      } else {
        this.globalShowPriority = TipPriorityConstants.TIP_PRIORITY_FINGER_PRINT_LOCKED_TIMEOUT;
      }
    } else {
      if (!(this.customizePromptVM.userRetry || text !== this.lastText)) {
        return text;
      }
    }
    setTimeout(() => {
      // 主动刷新，倒计时，提示语句变化会触发提示语句优先级调度
      if (this.lastText != text) {
        this.lastText = text;
      }
      if (this.customizePromptVM.userRetry) {
        this.customizePromptVM.userRetry = false;
      }
      this.onTipChange(text, this.globalShowPriority);
    }, 0);
    return text;
  }
}