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
import { ResUtils } from '@ohos/windowscene';
import ViewModel from '../vm/MixedPSDViewModel';
import { PCMixedPSDViewModel } from '../vm/PCMixedPSDViewModel';
import { TipPriorityConstants } from '../common/TipPriority';
import { CommonStyle } from '../style/CommonStyle';

import { UserStyle } from '../style/UserStyle';
import Constants from '../common/Constants';
import StyleConfiguration, { ScreenlockComponentStyle } from '../common/StyleConfiguration';

const TAG = 'ScreenLock-PasswordVerifyTip'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Extend(Text)
function baseTipTextStyle(fontSize: Length) {
  .draggable(false)
  .font({
    family: Constants.TOAST_FONT_FAMILY,
    weight: FontWeight.Bold,
    size: fontSize
  })
  .textAlign(TextAlign.Center)
  .textOverflow({ overflow: TextOverflow.None })
}

@Component
export struct PasswordVerifyTip {
  private promptId: string = '';
  private transitionEffect: TransitionEffect | undefined = undefined;
  @Link viewModel: PCMixedPSDViewModel;
  @Prop prompt: string | Resource | undefined;
  @Link visible: boolean;
  @State userStyle: UserStyle = UserStyle.getInstance();
  @State commonStyle: CommonStyle = CommonStyle.getInstance();
  @StorageLink('isScreenLockWallpaperBrightOrDark') isBrightOrDark: boolean = true;
  private lastText:string = '';
  private globalShowPriority: number | undefined = undefined;
  public onTipChange: (tip: string, showPriority: number | undefined) => void =
    (tip: string, showPriority: number | undefined) => {
    };
  private timeCountDownMatchReg = new RegExp('');
  private screenlockStyle: ScreenlockComponentStyle = StyleConfiguration.getScreenlockComponentStyle();

  aboutToAppear(): void {
    this.timeCountDownMatchReg =
      new RegExp(ResUtils.getInnerString($r('app.string.psd_try_again_after_time1')).replace('%s', '.*'));
  }

  build() {
    Column() {
      Stack() {
        Text(this.refreshPasswordVerifyTip())
          .focusable(false)
          .baseTipTextStyle(this.screenlockStyle.toastTextFontSize)
          .maxLines(Constants.TOAST_MAXLINES)
          .width(this.commonStyle.displayWidth - this.commonStyle.promptMargin * 2)
          .fontColor(Color.Transparent)
          .textShadow(this.userStyle.style.promptShadow)
          .transition(this.transitionEffect)
        Text(this.refreshPasswordVerifyTip())
          .id(this.promptId)
          .baseTipTextStyle(this.screenlockStyle.toastTextFontSize)
          .maxLines(Constants.TOAST_MAXLINES)
          .width(this.commonStyle.displayWidth - this.commonStyle.promptMargin * 2)
          .fontColor(this.isBrightOrDark ? $r('app.color.screen_lock_toast_color_lg') :
          $r('app.color.screen_lock_toast_color_dk'))
          .foregroundBrightness(this.isBrightOrDark ? CommonStyle.toastDarkBrightness :
          CommonStyle.toastLightBrightness)
          .transition(this.transitionEffect)
      }.alignContent(Alignment.Center)
    }
    .id('PasswordVerifyTip')
    .visibility(this.visible ? Visibility.Visible : Visibility.None)
    .width(this.commonStyle.displayWidth - this.commonStyle.promptMargin * 2)
    .margin({ top: '12vp' })
    .justifyContent(FlexAlign.Center)
  }

  private refreshPasswordVerifyTip(): string {
    let text: string = this.viewModel.prompt || '';
    this.globalShowPriority = undefined;
    if (this.viewModel && !this.viewModel.haveTryUnlock) {
      return text;
    } else if (this.timeCountDownMatchReg.test(text)) {
      if (this.viewModel.userRetry) {
        this.globalShowPriority = TipPriorityConstants.TIP_PRIORITY_PASSWORD_LOCKED_TIMEOUT_RESHOW;
      } else {
        this.globalShowPriority = TipPriorityConstants.TIP_PRIORITY_FINGER_PRINT_LOCKED_TIMEOUT;
      }
    } else {
      if (!(this.viewModel.userRetry || text !== this.lastText)) {
        return text;
      }
    }
    setTimeout(() => {
      // 主动刷新，倒计时，提示语句变化会触发提示语句优先级调度
      if (this.lastText != text) {
        this.lastText = text;
      }
      if (this.viewModel.userRetry) {
        this.viewModel.userRetry = false;
      }
      this.onTipChange(text, this.globalShowPriority);
    }, 0);
    return text;
  }
}