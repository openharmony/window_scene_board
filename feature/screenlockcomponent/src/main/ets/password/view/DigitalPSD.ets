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


import Constants from '../../common/Constants';
import NumKeyBoard from '../../password/view/NumkeyBoard';
import InputPwdTip from './InputPwdTip';
import PasswdMask from './PasswdMask';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import curves from '@ohos.curves';
import { ScreenLockPasswordVm } from '../viewmodel/PasswordVm'
import { PassWordLayout, KeyboardPageType } from '../../common/LayoutConstants';
import ScreenLockKeyboardTipUtil from '../../common/ScreenLockKeyboardUtil';
import PasswordConstants from '../common/PasswordConstants';

const TAG = 'DigitalPSD';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const PAGE_TYPE: number = KeyboardPageType.PSD_DIGITAL;

@Component
export default struct DigitalPSD {
  private persistentId: number = 0;
  private passwordVm?: ScreenLockPasswordVm;
  private onBack: Function = () => {};
  private onEmergencyKeyClick: Function = () => {};
  private isFullShowPwd: boolean = true;
  offHandNormalizedSpeed: number = 0;
  @State translateXArr: number[] = [];
  @State keyboardHeight: number = 0;
  @State isPsdAccessAccessibility: boolean = true;
  @Link psdViewScale: number;
  @Link psdViewOpacity: number;
  @Consume passWordWidth: number;
  @Consume @Watch('onDisplayHeightChange') psdLayoutData: PassWordLayout;
  @Consume @Watch('onDisplayHeightChange') displayHeight: number;
  @Consume displayWidth: number;

  private onDisplayHeightChange(): void {
    this.keyboardHeight =
    ScreenLockKeyboardTipUtil.keyboardHeightCount(this.displayHeight, this.psdLayoutData.index, PAGE_TYPE);
    log.showDebug(`onDisplayHeightChange keyboardHeight = ${this.keyboardHeight},index = ${this.psdLayoutData.index} displayHeight = ${this.displayHeight}`);
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.onDisplayHeightChange();
    log.showInfo(`DigitalPSD psdLayoutData index = ${this.psdLayoutData.index}`);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
      Column() {
        InputPwdTip({ persistentId: this.persistentId });
        PasswdMask({ passwordVm: this.passwordVm })
      }
      .transition(
        TransitionEffect.asymmetric(
          TransitionEffect.opacity(0).animation({
            duration: Constants.PSD_ENTER_OPACITY_TIME,
            curve: Curve.Smooth
          }).combine(TransitionEffect.scale({ x: Constants.PSD_INIT_SCALE, y: Constants.PSD_INIT_SCALE, })
            .animation({
              curve: curves.interpolatingSpring(0, 0,
                PasswordConstants.PSD_ELEMENT_STIFFNESS, PasswordConstants.PSD_ELEMENT_DAMPING)
            }))
          , TransitionEffect.IDENTITY)
      )
      .justifyContent(FlexAlign.End)
      .margin({ bottom: this.psdLayoutData.digitalPsdFlexMarginNumKeyBoard })
      .width('100%')

      NumKeyBoard({
        keyBoardHeight: this.keyboardHeight,
        keyBoardMargin: { bottom: this.psdLayoutData.psdBottomMargin },
        passwordVm: this.passwordVm,
        onKeyBackPress: (): void => this.onBack(),
        onEmergencyKeyClick: () => {
          this.onEmergencyKeyClick()
        },
        offHandNormalizedSpeed: this.offHandNormalizedSpeed,
        isPsdAccessAccessibility: this.isPsdAccessAccessibility
      })
    }
    .scale({x: this.isFullShowPwd ? this.psdViewScale : 1, y: this.isFullShowPwd ? this.psdViewScale : 1})
    .opacity(this.isFullShowPwd ? this.psdViewOpacity : 1)
    .id('Digital_PSD_Input_Tip')
    .width(this.passWordWidth)
    .height('100%')
    .onAreaChange((oldValue: Area, newValue: Area) => {
      log.showInfo(`PSD layout, displayHeight: ${this.displayHeight}, displayWidth: ${this.displayWidth},
        index= ${this.psdLayoutData.index}, componentWidth: ${newValue.width}, componentHeight: ${newValue.height},
        componentPositionX: ${newValue.globalPosition?.x}, componentPositionY: ${newValue.globalPosition?.y}`);
    })
  }
}
