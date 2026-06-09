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
import Curves from '@ohos.curves'
import {
  slWallpaperMgr,
  SLWallpaperState,
  StrongAuthConstants,
  IUserData,
  strongAuthManager
} from '@ohos/screenlockcommon';
import screenLockService from '../refactor/ScreenLockService';
import { AuthType } from '../refactor/AccountsModel';
import { BiometricsDisAbleReason, biometricsVerifyService } from '../common/BiometricsVerifyService';
import { screenLockDataModel } from '../common/ScreenLockDataModel';
import { UserStyle } from '../style/UserStyle';
import { CommonStyle } from '../style/CommonStyle';
import ScreenLockMar from '@ohos.screenLock';
import { CustomVoteDevice } from '../vm/CustomVoteDevice';
import Constants from '../common/Constants';
import StyleConfiguration, { ScreenlockComponentStyle } from '../common/StyleConfiguration';
import { enterpriseSpaceVerifyService } from '../vm/enterprise/EnterpriseMultiSpaceVerifyService';

const TAG = 'ScreenLock-BaseSceneUnlockTip';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Extend(Text)
function baseTipTextStyle(fontSize: Length) {
  .draggable(false)
  .focusable(false)
  .font({
    family: Constants.TOAST_FONT_FAMILY,
    weight: FontWeight.Bold,
    size: fontSize
  })
  .textAlign(TextAlign.Center)
  .textOverflow({ overflow: TextOverflow.None })
}

@Component
export struct BaseSceneUnlockTip {
  @StorageLink('isScreenLockWallpaperBrightOrDark') isBrightWallPaper: boolean = true;
  @State text: string = '';
  @State strongAuthPrompt: string = screenLockDataModel.getPromptValue();
  private firstUnLockScreen: boolean = screenLockService.firstUnLockScreen;
  private isReboot: boolean = CustomVoteDevice.isReboot;
  private effect: TransitionEffect =
    TransitionEffect.scale({ x: 0.8, y: 0.8 })
      .combine(TransitionEffect.opacity(0.0))
      .combine(TransitionEffect.scale({ x: 1.0, y: 1.0 }))
      .animation({ curve: Curves.spring(0, 1, 200, 18), duration: 350, delay: 100 })
      .combine(TransitionEffect.opacity(1.0))
      .animation({ curve: Curve.Sharp, duration: 350, delay: 100 });
  @Link visible: boolean;
  private transitionEffect: TransitionEffect | undefined = undefined;
  @State userStyle: UserStyle = UserStyle.getInstance();
  @State commonStyle: CommonStyle = CommonStyle.getInstance();
  @StorageLink('passwordType') @Watch('onPasswordTypeChange') passwordType: string = 'NONE';
  @StorageProp(StrongAuthConstants.STRONG_AUTH_REASON) @Watch('strongAuthStatusChanged') strongAuthStatus: number =
    strongAuthManager.getStrongAuthStatus();
  private biometrics: AuthType[] = [];
  private screenlockStyle: ScreenlockComponentStyle = StyleConfiguration.getScreenlockComponentStyle();
  @StorageLink('currentUserItem') userData: IUserData | null = null;
  @StorageLink('isPinAuthType') isPinType: boolean = true;


  private onBiometricsChange: Callback<void> = () => {
    this.biometrics = biometricsVerifyService.getRegisterBiometrics();
    this.text = this.getPrompt();
    log.showInfo(`onBiometricsChange this.text:${this.text}`);
  }

  /**
   * 锁屏壁纸状态，用于获取壁纸反色
   */
  @State slWallpaperState: SLWallpaperState = slWallpaperMgr.getSlWallpaperState();

  onPasswordTypeChange(): void {
    this.biometrics = biometricsVerifyService.getRegisterBiometrics();
    this.text = this.getPrompt();
    log.showInfo(`onPasswordTypeChange this.text:${this.text}`);
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.biometrics = biometricsVerifyService.getRegisterBiometrics();
    this.text = this.getPrompt();
    this.checkEnterpriseUseToken();
    biometricsVerifyService.addBiometricsChangeSubscribe(this.onBiometricsChange);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    biometricsVerifyService.deleteBiometricsChangeSubscribe(this.onBiometricsChange);
  }

  private getPrompt(): string {
    let prompt: string = this.getPromptValue();
    log.showInfo(`showInputTips:${prompt}`);
    return prompt;
  }

  private getPromptValue(): string {
    if (!!this.strongAuthPrompt) {
      log.showInfo(`strongAuthPrompt : ${this.strongAuthPrompt}`);
      return this.strongAuthPrompt;
    } else if (this.passwordType === 'NONE') {
      return '';
    } else if (this.firstUnLockScreen || this.strongAuthStatus === StrongAuthConstants.USER_REBOOT) {
      log.showInfo(`reboot,firstUnLockScreen: ${this.firstUnLockScreen},strongAuthStatus: ${this.strongAuthStatus} `);
      if (this.isReboot) {
        return ResUtils.getInnerString($r('app.string.restart_enter_pin'));
      } else {
        return ResUtils.getInnerString($r('app.string.user_not_logged_in_enter_pin'));
      }
    } else if (this.getStrongAuthStatus() === StrongAuthConstants.USER_TIMEOUT) {
      return this.showTimeoutTips();
    } else if (biometricsVerifyService.getDisableReason().indexOf(BiometricsDisAbleReason.PASSWORD_FREEZING) >= 0 &&
      this.biometrics.length > 0) {
      return ResUtils.getInnerString($r('app.string.auth_by_pwd_after_pwd_disable'));
    } else if (this.biometrics.indexOf(AuthType.FACE) >= 0 && this.biometrics.indexOf(AuthType.FINGERPRINT) >= 0) {
      return ResUtils.getInnerString($r('app.string.screen_unlock_with_pwd_or_face_tip_pc'));
    } else if (this.biometrics.indexOf(AuthType.FACE) >= 0) {
      return ResUtils.getInnerString($r('app.string.auth_by_pwd_or_face_tip_pc'));
    } else if (this.biometrics.indexOf(AuthType.FINGERPRINT) >= 0) {
      return ResUtils.getInnerString($r('app.string.auth_by_fp_or_pwd'));
    } else {
      return '';
    }
  }

  private async checkEnterpriseUseToken(): Promise<void> {
    // 企业用户token过期后，需要先认证pin码，在认证企业密码，pin码认证后，企业用户属于登录状态，切换用户需要刷新token过期提示
    if (this.userData?.isDomain && this.userData?.isLoggedIn && !this.isPinType) {
      const expired = await enterpriseSpaceVerifyService.isAuthExpired();
      log.showInfo(`isAuthExpired finish, expired: ${expired}`);
      if (expired) {
        this.text = ResUtils.getInnerString($r('app.string.multispace_enterprise_login_expired'));
      }
    }
  }

  private showTimeoutTips(): string {
    if (this.biometrics.indexOf(AuthType.FACE) >= 0 && this.biometrics.indexOf(AuthType.FINGERPRINT) >= 0) {
      return ResUtils.getInnerString($r('app.string.please_enter_psd_for_security_fingerprint_face'));
    } else if (this.biometrics.indexOf(AuthType.FACE) >= 0) {
      return ResUtils.getInnerString($r('app.string.please_enter_psd_for_security_face'));
    } else if (this.biometrics.indexOf(AuthType.FINGERPRINT) >= 0) {
      return ResUtils.getInnerString($r('app.string.please_enter_psd_for_security_fingerprint'));
    } else {
      return ResUtils.getInnerString($r('app.string.please_enter_psd_for_security'));
    }
  }

  private getStrongAuthStatus(): number {
    log.showInfo(`strongAuthStatus : ${this.strongAuthStatus}`);
    return this.strongAuthStatus;
  }

  private strongAuthStatusChanged() {
    log.showInfo(`strongAuthStatusChanged : ${this.strongAuthStatus}`);
    this.text = this.getPrompt();
  }


  build() {
    Stack() {
      Text(this.text)
        .baseTipTextStyle(this.screenlockStyle.toastTextFontSize)
        .transition(this.effect)
        .maxLines(1)
        .fontColor(Color.Transparent)
        .textShadow(this.userStyle.style.promptShadow)
        .transition(this.transitionEffect)
      Text(this.text)
        .baseTipTextStyle(this.screenlockStyle.toastTextFontSize)
        .id('BaseSceneUnlockTip')
        .transition(this.effect)
        .maxLines(2)
        .fontColor(this.isBrightWallPaper ? $r('app.color.screen_lock_toast_color_lg') :
        $r('app.color.screen_lock_toast_color_dk'))
        .foregroundBrightness(this.isBrightWallPaper ? CommonStyle.toastDarkBrightness :
        CommonStyle.toastLightBrightness)
        .textShadow(this.userStyle.style.promptShadow)
        .transition(this.transitionEffect)
        .width(this.commonStyle.displayWidth - this.commonStyle.promptMargin * 2)
    }
    .visibility(this.visible && this.text ? Visibility.Visible : Visibility.None)
    .margin({ top: '12vp' })
  }
}