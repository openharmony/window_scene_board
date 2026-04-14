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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { GestureNavigationState, GestureType, ResUtils, scbGestureManager } from '@ohos/windowscene';
import Constants from '../../common/Constants';
import { DevicesGrids } from '../../common/LayoutConstants';
import {
  GlobalStatusCache,
  KeyGuardMode,
  KeyguardStatusService,
  slWallpaperMgr,
  SLWallpaperState,
  StatusCacheConst,
  StrongAuthReasonFlags,
  StrongAuthStateManager,
  vibratorMgr
} from '@ohos/screenlockcommon';
import curves from '@ohos.curves';
import { InputPwdDefaultPromptViewModel } from '../../fingerprint/InputPwdDefaultPromptViewModel';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { sFontScaleUtil } from '@ohos/screenlockwidget/src/main/ets/common/utils/FontScaleUtil';
import {
  interruptMgr
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/manager/PromiseInterruptManager';
import { InterruptName } from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/common/ImmersiveInterruptName';
import ScreenLockKeyboardTipUtil from '../../common/ScreenLockKeyboardUtil';
import { ToastPromptViewModel } from '../../fingerprint/ToastPromptViewModel';
import { SpecialModeChangeListener, SpecialModeManager } from '../../common/SpecialModeManager';
import { SlObserverProxy } from '../../observer/SlObserverProxy';
import { PasswordLayoutConfig } from '../common/PasswordLayoutConfig';
import { PasswordChangeListener, PasswordManager } from '@ohos/screenlockcommon/src/main/ets/manager/PasswordManager';
import { CoreStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';

const TAG = 'InputPwdTip';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const INPUT_WIDTH_THAN_KEYBOARD: number = 20;
const INPUT_WIDTH_THAN_KEYBOARD_SMALL_OUTER_SCREEN: number = 72;
const PWD_LOTTIE_NUM = 4;

@Component
export default struct InputPwdTip {
  private persistentId: number = 0;
  private readonly slObserverProxy: SlObserverProxy = new SlObserverProxy();

  @State isShowFaceCanvas: boolean = false;
  @State passwordErrorTips: string = '';
  @State inputPasswordTip: string = '';
  @Consume inputPwdDefaultPromptViewModel: InputPwdDefaultPromptViewModel;
  @Consume toastPromptViewModel: ToastPromptViewModel;
  @State isFaceUnlockSwitchOpen: boolean = false;
  @State isSpecialMode: boolean = false;
  @State zoomRatio: number = 1.0;
  @StorageLink('isPwdVisible') isPwdVisible: boolean = false;
  @State tipTranslateX: number = 0;
  @Consume @Watch('onDisplayWidthChange')displayWidth: number;
  @Consume @Watch('onDisplayWidthChange') deviceGridData: DevicesGrids;
  @State inputPwdTipWidth: number | string = '100%';
  @Consume passwordLayoutConfig : PasswordLayoutConfig;
  /**
   * 锁屏壁纸状态，用于获取壁纸反色
   */
  @State slWallpaperState: SLWallpaperState = slWallpaperMgr.getSlWallpaperState();
  @State faceUnlockVerifyStateChangeAccessText: string = '';
  @State needStrongAuth: boolean = StrongAuthStateManager.getInstance().isNeedStrongAuth();
  private strongAuthTip: string = StrongAuthStateManager.getInstance().getStrongAuthPwdTip();

  private readonly _specialModeListener: SpecialModeChangeListener = {
    onSpecialModeChange: (curMode: KeyGuardMode): void => {
      this.isSpecialMode = curMode !== KeyGuardMode.DEFAULT;
      PasswordManager.getInstance().clearErrorTips();
      GlobalStatusCache.getInstance().setStatus(StatusCacheConst.IS_SPECIAL_MODE_BOUNCER_FOCUS_KEY, this.isSpecialMode);
    }
  };

  private readonly passwordTipsChangeListener: PasswordChangeListener = {
    onPasswordTipsChange: (passwordTips: string): void => {
      this.passwordErrorTips = passwordTips;
      this.refreshInputPwdTip();
    }
  };

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.initObserver();
    this.onDisplayWidthChange();

    this.passwordErrorTips = PasswordManager.getInstance().passwordErrorTips;
    this.refreshInputPwdTip();
  }

  private initObserver() {
    this.slObserverProxy.observerStrongAuthState((strongAuthState: StrongAuthReasonFlags): void => {
      if (strongAuthState !== StrongAuthReasonFlags.NO_NEED_STRONG_AUTH) {
        // 强认证状态触发立刻刷新提示语，强认证状态恢复跟随密码页消失
        this.needStrongAuth = true;
        this.strongAuthTip = StrongAuthStateManager.getInstance().getStrongAuthPwdTip();
      }
    });

    this.isSpecialMode = KeyguardStatusService.isSpecialMode();
    SpecialModeManager.getInstance().registerObserver(this._specialModeListener);
    PasswordManager.getInstance().registerObserver(this.passwordTipsChangeListener);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    SpecialModeManager.getInstance().unRegisterObserver(this._specialModeListener);
    this.slObserverProxy.release();
    // 即时释放拦截
    interruptMgr.getInterrupt(InterruptName.NTF_ITEM_ANIM_PARAS).releaseInterrupt();
    PasswordManager.getInstance().unRegisterObserver(this.passwordTipsChangeListener);
  }

  private onDisplayWidthChange(): void {
    // 键盘keyboard的宽度 + than宽度
    this.inputPwdTipWidth =
      ScreenLockKeyboardTipUtil.keyboardWidthLayout(this.displayWidth, this.deviceGridData) + this.getThanWidth();
    log.showInfo(`inputPwdTipWidth: ${this.inputPwdTipWidth}`);
  }

  private getThanWidth(): number {
    return this.passwordLayoutConfig.layoutConfig.outerScreenFlag ? INPUT_WIDTH_THAN_KEYBOARD_SMALL_OUTER_SCREEN :
      INPUT_WIDTH_THAN_KEYBOARD;
  }

  build() {
    Column() {
      this.inputPwdTip();
    }
    .width('100%')
    .justifyContent(FlexAlign.End)
    .margin({ top: this.passwordLayoutConfig.layoutConfig.inputPwdTipWithFaceMarginTop })
  }

  @Styles tipText() {
    .onAppear(() => {
      this.registerNavigationGestureCallback();
      if (AccessibilityUtil.isAccessibilityMode()) {
        AccessibilityUtil.requestFocusAccessibility(Constants.COMPONENT_ID_ENTER_PSD);
      }
      this.refreshInputPwdTip();
    })
    .onDisAppear(() => {
      scbGestureManager.unRegisterGestureEvent(GestureType.NAVIGATION, 'InputPwdTip');
    })
  }

  @Builder
  inputPwdTip() {
    Text(this.refreshInputPwdTip())
      .draggable(false)
      .id(Constants.COMPONENT_ID_ENTER_PSD)
      .minFontSize(this.passwordLayoutConfig.layoutConfig.inputPwdTipMinFontSize)
      .maxFontSize(this.passwordLayoutConfig.layoutConfig.inputPwdTipMaxFontSize)
      .minFontScale(sFontScaleUtil.getMinFontSize())
      .maxFontScale(sFontScaleUtil.getMaxFontSize(this.passwordLayoutConfig.layoutConfig.outerScreenFlag, false))
      .fontWeight(FontWeight.Medium)
      .fontFamily($r('app.float.pwd_prompt_font_family'))
      .fontColor(this.isSpecialMode ? $r('app.color.date_time_light_color') :
      this.slWallpaperState?.getWallpaperReverseColor())
      .textAlign(TextAlign.Center)
      .maxLines(3)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .width(this.inputPwdTipWidth)
      .translate({ x: this.tipTranslateX })
      .tipText()
  }

  private openTipsAnimate: () => void = () => {
    animateTo({
      curve: curves.initCurve(Curve.Friction),
      duration: 60,
    }, () => {
      this.tipTranslateX = 6;
    })
    animateTo({
      curve: curves.initCurve(Curve.Friction),
      delay: 60,
      duration: 120,
    }, () => {
      this.tipTranslateX = -11;
    })
    animateTo({
      curve: curves.initCurve(Curve.Friction),
      delay: 180,
      duration: 120
    }, () => {
      this.tipTranslateX = 9;
    })
    animateTo({
      curve: curves.initCurve(Curve.Friction),
      delay: 300,
      duration: 120
    }, () => {
      this.tipTranslateX = -7;
    })
    animateTo({
      curve: curves.initCurve(Curve.Friction),
      delay: 420,
      duration: 100
    }, () => {
      this.tipTranslateX = 5;
    })
    animateTo({
      curve: curves.initCurve(Curve.Friction),
      delay: 520,
      duration: 80
    }, () => {
      this.tipTranslateX = 0;
    })
  }

  private registerNavigationGestureCallback(): void {
    scbGestureManager.registerGestureEvent(GestureType.NAVIGATION, 'InputPwdTip',
      (type: GestureNavigationState, event: GestureEvent) => {
        switch (type) {
          case GestureNavigationState.START:
            log.showInfo('GestureNavigationState START');
            this.openTipsAnimate();
            vibratorMgr.startVibration();
            break;
          case GestureNavigationState.END:
            log.showInfo('GestureNavigationState END');
            break;
          default:
            break;
        }
      })
  }

  private refreshInputPwdTip(): string {
    let inputText = this.getInputPwdTip();
    if (this.inputPasswordTip !== inputText) {
      this.inputPasswordTip = inputText;
      log.showInfo(`inputPwdTip changed: ${inputText}`);
    }
    return inputText;
  }

  private getInputPwdTip(): string {
    if (CoreStateTypeUtils.isUnlockStateScreenOn(this.slObserverProxy.getCoreFsmState(this.persistentId))) {
      return this.inputPasswordTip;
    }
    if (!!this.passwordErrorTips) {
      return this.passwordErrorTips;
    }
    if (this.needStrongAuth) {
      return this.isEnterEditor() ?
      ResUtils.getInnerString($r('app.string.edit_after_unlock')) : this.strongAuthTip;
    }
    return this.isEnterEditor() ? ResUtils.getInnerString($r('app.string.edit_after_unlock')) :
    ResUtils.getInnerString(this.inputPwdDefaultPromptViewModel.defaultPrompt);
  }

  private isEnterEditor(): boolean {
    return CoreStateTypeUtils.isBounceToEditState(this.slObserverProxy.getCoreFsmState(this.persistentId));
  }
}