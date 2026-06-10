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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import InputPwdTip from './InputPwdTip';
import curves from '@ohos.curves';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import {
  DevicesGrids,
  PassWordLayout,
  KeyboardPageType,
} from '../../common/LayoutConstants';
import { SlObserverProxy } from '../../observer/SlObserverProxy';
import ScreenLockKeyboardTipUtil from '../../common/ScreenLockKeyboardUtil';
import { SLWallpaperState, VerifyDataManager } from '@ohos/screenlockcommon';
import { slWallpaperMgr } from '@ohos/screenlockcommon';
import { PasswordManager, PasswordChangeListener } from '@ohos/screenlockcommon/src/main/ets/manager/PasswordManager';
import PasswordConstants from '../common/PasswordConstants';
import NumberPasswordInput from './NumberPasswordInput';
import { ScreenLockPasswordVm } from '../viewmodel/PasswordVm'

const TAG = 'CustomPSD';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const PAGE_TYPE: number = KeyboardPageType.PSD_CUSTOM;

@Component
export default struct CustomPSD {
  private persistentId: number = 0;
  private passwordVm?: ScreenLockPasswordVm;
  private onBack: Function = () => {};
  private onEmergencyKeyClick: Function = () => {};
  private isFullShowPwd: boolean = true;
  private readonly slObserverProxy: SlObserverProxy = new SlObserverProxy();
  offHandNormalizedSpeed: number = 0;
  @State keyboardHeight: number = 0;
  @State isPsdAccessAccessibility: boolean = false;
  @State inputWidth: number = 0;
  @State isShowEnter: boolean = true;
  /**
   * 锁屏壁纸状态，用于获取壁纸反色
   */
  @State slWallpaperState: SLWallpaperState = slWallpaperMgr.getSlWallpaperState();
  @Link psdViewScale: number;
  @Link psdViewOpacity: number;
  @Consume passWordWidth: number;
  @Consume @Watch('onPSDLayoutDataChange') displayHeight: number;
  @Consume @Watch('onPSDLayoutDataChange') displayWidth: number;
  @Consume @Watch('onPSDLayoutDataChange') psdLayoutData: PassWordLayout;
  @Consume @Watch('onPSDLayoutDataChange') deviceGridData: DevicesGrids;

  private onPSDLayoutDataChange(): void {
    this.keyboardHeight =
    ScreenLockKeyboardTipUtil.keyboardHeightCount(this.displayHeight, this.psdLayoutData.index, PAGE_TYPE);
    this.inputWidth = ScreenLockKeyboardTipUtil.inputTipWidthLayout(this.displayWidth, this.deviceGridData);
    log.showDebug(`CustomPSD onPSDLayoutDataChange inputWidth = ${this.inputWidth} displayWidth = ${this.displayWidth},displayHeight = ${this.displayHeight} index = ${this.psdLayoutData.index}`);
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.onPSDLayoutDataChange();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.slObserverProxy.release();
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
      Column() {
        InputPwdTip({ persistentId: this.persistentId });
        NumberPasswordInput({
          inputWidth: this.inputWidth,
          inputHeight: $r('app.float.pwd_input_row_height'),
          inputAccessText: $r('app.string.custom_mix_psd_area_accessible'),
          isShowEnter: this.isShowEnter,
          passwordVm: this.passwordVm,
          onEnterClick:(): void => this.passwordVm?.authPassword(true)
        })
          .margin({ top: $r('app.float.pwd_input_row_margin_top') })
      }
      .transition(
        TransitionEffect.asymmetric(
          TransitionEffect.opacity(0).animation({
            duration: Constants.PSD_ENTER_OPACITY_TIME,
            curve: Curve.Smooth
          }).combine(TransitionEffect.scale({ x: Constants.PSD_INIT_SCALE, y: Constants.PSD_INIT_SCALE })
            .animation({
              curve: curves.interpolatingSpring(0, 0,
                PasswordConstants.PSD_ELEMENT_STIFFNESS, PasswordConstants.PSD_ELEMENT_DAMPING)
            }))
          , TransitionEffect.IDENTITY)
      )
      .justifyContent(FlexAlign.End)
      .margin({ bottom: this.psdLayoutData.customPsdFlexMarginNumKeyBoard })

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
    .width(this.passWordWidth)
    .height('100%')
    .onAreaChange((oldValue: Area, newValue: Area) => {
      log.showInfo(`PSD layout, displayHeight: ${this.displayHeight}, displayWidth: ${this.displayWidth},
        index= ${this.psdLayoutData.index}, componentWidth: ${newValue.width}, componentHeight: ${newValue.height},
        componentPositionX: ${newValue.globalPosition?.x}, componentPositionY: ${newValue.globalPosition?.y}`);
    })
  }
}