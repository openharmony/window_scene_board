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
import { SystemParamUtils } from '@ohos/frameworkwrapper';
import { slWallpaperMgr, CommonConstants,
  ScreenLockVerifyService,
  VerifyStateListener,
  VerifyResult,
  VerifyDataManager,
  KeyGuardMode
} from '@ohos/screenlockcommon';
import { ScreenLockPasswordVm } from '../viewmodel/PasswordVm'
import { AuthType, AuthSubType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { PasswordManager, PasswordChangeListener } from '@ohos/screenlockcommon/src/main/ets/manager/PasswordManager';
import { SLWallpaperState } from '@ohos/screenlockcommon';
import { PasswordLayoutConfig } from '../common/PasswordLayoutConfig';
import PasswordConstants from '../common/PasswordConstants'
import { SpecialModeManager, SpecialModeViewData } from '../../common/SpecialModeManager';
import { ResUtils } from '@ohos/windowscene';

const TAG = 'PasswdMask'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Component
export default struct PasswdMask {
  private passwordVm?: ScreenLockPasswordVm;
  private isHddProduct: boolean = SystemParamUtils.isHddProduct();
  private credentialLength: number = CommonConstants.PW_SIX_LEN;
  @State translateXArr: number[] = [];
  @State dotOpacity: number[] = [];
  @State shadowRadius:number[] = [];
  @Consume passwordLayoutConfig: PasswordLayoutConfig;
  @State specialModeViewData: SpecialModeViewData = SpecialModeManager.getInstance().getSpecialModeViewData();

  /**
   * 锁屏壁纸状态，用于获取壁纸反色
   */
  @State slWallpaperState: SLWallpaperState = slWallpaperMgr.getSlWallpaperState();

  private passwordChangeListener: PasswordChangeListener = {
    onPasswordChange: (isAdd: boolean, passwordLength: number): void => {
      if (passwordLength === 0) {
        this.dotOpacity.fill(0);
      } else if (isAdd && passwordLength <= this.dotOpacity.length) {
        let passwdMaskIndex = passwordLength - 1;
        this.dotOpacity[passwdMaskIndex] = 1;
        if (!this.isHddProduct) {
          this.shadowRadius[passwdMaskIndex] = vp2px(7);
          log.showInfo('onKeyPress');
          animateTo({ curve: Curve.Sharp, duration: 150 }, () => {
            this.shadowRadius[passwdMaskIndex] = 0;
          });
        }
      } else if (!isAdd && passwordLength <= this.dotOpacity.length) {
        let passwdMaskIndex = passwordLength;
        this.dotOpacity[passwdMaskIndex] = 0;
        if (!this.isHddProduct) {
          this.shadowRadius[passwdMaskIndex] = 0;
        }
      }
    }
  };

  private verifyResultListener: VerifyStateListener = {
    onVerifyResult: (authType: AuthType, verifyResult: VerifyResult): void => {
      if (authType === AuthType.PIN && verifyResult === VerifyResult.FAIL) {
        this.doErrorAnimation(this.credentialLength - 1);
      }
    }
  };

  public aboutToAppear(): void {
    this.credentialLength = VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN).credentialLength;
    let passwordLength = this.passwordVm?.passwordLength ?? 0;
    for (let i = 0; i < this.credentialLength; i++) {
      this.dotOpacity.push(i < passwordLength ? 1 : 0);
      if (!this.isHddProduct) {
        this.shadowRadius.push(0);
      }
    }
    PasswordManager.getInstance().registerObserver(this.passwordChangeListener);
    ScreenLockVerifyService.getInstance().registerObserver(this.verifyResultListener);
    log.showInfo('aboutToAppear');
  }

  aboutToDisappear(): void {
    PasswordManager.getInstance().unRegisterObserver(this.passwordChangeListener);
    ScreenLockVerifyService.getInstance().unRegisterObserver(this.verifyResultListener);
    log.showInfo('aboutToDisappear');
  }

  public sharpAnimation(event: Callback<void>, onFinish?: Callback<void>): void {
    animateTo({
      duration: 50,
      curve: Curve.Sharp,
      onFinish:onFinish
    }, event);
  }

  private getFillColor(): Resource | string | undefined {
    if (this.specialModeViewData.curMode !== KeyGuardMode.DEFAULT) {
      return $r('app.color.date_time_light_color');
    }
    return this.slWallpaperState?.getWallpaperReverseColor();
  }

  private getAccessibilityText(): string {
    let inputPwdTotalCount: number =
      (VerifyDataManager.getInstance().getVerifyInfo(AuthType.PIN).authSubType === AuthSubType.PIN_SIX ?
        6 : 4);
    let inputPwdTotalCountText =
      ResUtils.getInnerPluralByResource($r('app.plural.psd_totle_length'), inputPwdTotalCount);
    let inputPwdCountText =
      ResUtils.getInnerPluralByResource($r('app.plural.psd_entered_length'), this.passwordVm?.passwordLength);
    return inputPwdCountText + ', ' + inputPwdTotalCountText;
  }

  private doErrorAnimation(index: number): void {
    if (index < 0) {
      return;
    }
    if (!this.passwordVm) {
      log.showInfo('PSDViewModel is null');
      this.dotOpacity.fill(0, 0, index);
      return;
    }
    this.passwordVm.disableInputWhenAnim = true;
    let moveLeft = () => {
      this.translateXArr[index] = PasswordConstants.DOT_ERR_ANI_LEFT;
    };
    let moveRight = () => {
      this.translateXArr[index] = PasswordConstants.DOT_ERR_ANI_RIGHT;
    }
    let moveOrigin = () => {
      this.translateXArr[index] = PasswordConstants.DOT_ERR_ANI_DEFAULT;
    }
    this.sharpAnimation(moveLeft, () => {
      this.dotOpacity[index] = 0;
      this.doErrorAnimation(index - 1);
      this.sharpAnimation(moveRight, () => {
        this.sharpAnimation(moveOrigin, () => {
          if (index === 0 && this.passwordVm) {
            this.passwordVm.disableInputWhenAnim = false;
          }
        });
      });
    })
  }

  build() {
    Row({ space: this.passwordLayoutConfig.layoutConfig.passwdMaskSpace }) {
      ForEach(this.dotOpacity, (opacity: number, index: number) => {
        if (!this.isHddProduct) {
          Image(opacity ? $r('app.media.ic_solid_dot') : $r('app.media.ic_hollow_dot'))
            .draggable(false)
            .width(this.passwordLayoutConfig.layoutConfig.passwdMaskDotWidthAndHeight)
            .height(this.passwordLayoutConfig.layoutConfig.passwdMaskDotWidthAndHeight)
            .shadow({ color: Color.White, radius: this.shadowRadius[index], fill: true })
            .fillColor(this.getFillColor())
            .borderRadius(this.passwordLayoutConfig.layoutConfig.passwdMaskDotWidthAndHeight)
            .accessibilityText(index === 0 ? this.getAccessibilityText() : '')
            .translate({
              x: this.translateXArr[index],
            })
            .transition(TransitionEffect.OPACITY.animation({ duration: 50, curve: Curve.Sharp }))
        } else {
          Image(opacity ? $r('app.media.ic_solid_dot') : $r('app.media.ic_hollow_dot'))
            .draggable(false)
            .width($r('app.float.digitalpwd_passwdmask_dot_width_height'))
            .height($r('app.float.digitalpwd_passwdmask_dot_width_height'))
            .accessibilityText(index === 0 ? this.getAccessibilityText() : '')
            .fillColor(this.getFillColor())
            .translate({
              x: this.translateXArr[index],
            })
        }
      })
    }
    .accessibilityGroup(true, { accessibilityPreferred: true })
    .accessibilityLevel('yes')
    .accessibilityRole(AccessibilityRoleType.TEXT_INPUT)
    .accessibilityDescription(' ')
    .padding({
      left: $r('app.float.digitalpwd_passwdmask_padding'),
      right: $r('app.float.digitalpwd_passwdmask_padding')
    })
    .clip(false)
    .justifyContent(FlexAlign.Center)
    .align(Alignment.Top)
    .width($r('app.float.digitalpwd_passwdmask_width'))
    .height(this.passwordLayoutConfig.layoutConfig.passwdMaskDotWidthAndHeight)
    .margin({ top: this.passwordLayoutConfig.layoutConfig.digitalPwdMaskMarginTop })
  }
}