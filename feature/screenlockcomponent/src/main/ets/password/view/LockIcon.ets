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

import {
  AccessibilityUtil,
  GlobalStatusCache,
  KeyGuardMode,
  LockStateInfo,
  ScreenLockStateManager,
  SlVisualArgs,
  StatusCacheConst,
  StrongAuthReasonFlags,
  StrongAuthStateManager,
  VerifyDataManager,
  VerifyInfo
} from '@ohos/screenlockcommon';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper';
import { ResUtils, SCBSceneSessionManager, SCBSystemBarProperty } from '@ohos/windowscene';
import TemporaryPromptViewModel from '../../fingerprint/TemporaryPromptViewModel';
import { DynamicFontSize, sFontScaleUtil } from '@ohos/screenlockwidget/src/main/ets/common/utils/FontScaleUtil';
import measure from '@ohos.measure';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { slStateHelper } from '../../common/helper/SlStateHelper';
import { SlLockIconBindState } from '../viewmodel/SlLockIconBindState';

import {
  interruptMgr
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/manager/PromiseInterruptManager';
import { InterruptName } from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/common/ImmersiveInterruptName';
import Constants from '../../common/Constants';
import { LengthMetrics } from '@ohos.arkui.node';
import { SlWidgetId } from '@ohos/screenlockcommon/src/main/ets/constants/SlWidgetConst';
import ScreenLockSpaceAnimationViewModel from '../viewmodel/ScreenLockSpaceAnimationViewModel';
import { SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { SlObserverProxy } from '../../observer/SlObserverProxy';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { CoreStateType, CoreStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { SpecialModeChangeListener, SpecialModeManager, SpecialModeViewData } from '../../common/SpecialModeManager';
import {
  StartAbilityOverlayAnimateData
} from '@ohos/systemuicommon/src/main/ets/liveview/common/StartAbilityOverlayAnimateData';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { SlLockIconStaticState } from '../viewmodel/SlLockIconStaticState';
import PasswordConstants from '../common/PasswordConstants';
import { SlClockStaticState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockStaticState';
import { ScreenLockSpaceAniData, spaceAniHelper, WidgetAnimState } from '@ohos/screenlockcommon/Index';

const TAG = 'LockIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const COMPONENT_ID_LOCK_ICON = TAG + '_Image_lock';
const COMPONENT_ID_LOCK_TIP = TAG + '_Text_lock';
const COMPONENT_ID_TEMPORARY_PROMPT = TAG + 'Temporary_Text_prompt';
const COMPONENT_ID_LOCK_ANIM = TAG + '_LOCK_ANIM';

// blendMode parameter
const BlendMode_SRC_OVER: number = 1000;
const BlendMode_DESTINATION_IN: number = 6;
const MARQUEE_WIDTH = 284;
const MAX_RTL_SIZE: string = '15vp';
const COLOR_BLACK: string = '#000000';
const COLOR_WHITE: string = '#FFFFFF';
const LOCK_ICON_LOTTIE_NUM = 5;

@Component
export default struct LockIcon {
  private persistentId: number = 0;
  private readonly slObserverProxy: SlObserverProxy = new SlObserverProxy();
  @State isPageShow: boolean = ScreenLockStateManager.getInstance().isPageShow;
  @State isLocked: boolean = ScreenLockStateManager.getInstance().isLocked;
  @State faceAccessibilityText: string = '';
  @State hasPwd: boolean = false;
  @State isShowFaceCanvas: boolean = false;
  @State isShowText: boolean = true;
  @State isFaceLocked: boolean = false;
  @State textOpacity: number = 1;
  @State spaceAniOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniLockIconState();
  @Link startAbilityAnimateData: StartAbilityOverlayAnimateData;
  @State slBindState?: ISlState = slStateHelper.getSlBindState();
  @State unlockTips: string = '';
  @State unlockIcon: Resource = $r('app.media.ic_public_lock');
  @Link temporaryPromptViewModel: TemporaryPromptViewModel | undefined;
  @Prop globalOpacity: number = Constants.MAX_VIEW_OPACITY;
  @Prop isLightWallpaper: boolean = false;
  @State fontScale: DynamicFontSize = sFontScaleUtil.realDynamicSize;
  @State specialModeViewData: SpecialModeViewData = SpecialModeManager.getInstance().getSpecialModeViewData();
  @State smallOuterScreenLockIconColor: string = '#FFFFFF';
  @State isSpecialMode: boolean =
    SpecialModeManager.getInstance().getSpecialModeViewData().curMode !== KeyGuardMode.DEFAULT;
  @State curState: CoreStateType = CoreStateType.INIT_STATE;
  @Prop clockStrokeColor?: string = '';
  @State slLockIconBindState: SlLockIconBindState = slStateHelper.getSlLockBindState(); // 锁头布局状态管理
  @State slLockIconAnimCtrl: WidgetAnimState | undefined = slStateHelper.getSlLockAnimState(); // 锁头动效状态管理
  @Prop normalBrightArgs?: SlVisualArgs;
  @Prop enableEffect: boolean = true;
  private enableBright: boolean = true;
  private enableSolid: boolean = true;

  private slLockIconStaticState?: SlLockIconStaticState =
    slUiStateMgr.getSlState(SlMainStateType.SL_LOCK_ICON_WG_STATIC_STATE) as SlLockIconStaticState;
  private slClockStaticCtrl: SlClockStaticState = slStateHelper.getSlClockStaticState(); // 时钟组件静态变量管理
  private readonly _specialModeListener: SpecialModeChangeListener = {
    onSpecialModeChange: (curMode: KeyGuardMode): void => {
      this.isSpecialMode = curMode !== KeyGuardMode.DEFAULT;
    }
  };
  private systemBarPropertyCallback = (property: SCBSystemBarProperty) => {
    log.showInfo(`systemBarPropertyCallback ${property?.contentcolor}`);
    this.smallOuterScreenLockIconColor = property?.contentcolor;
  }

  aboutToAppear() {
    SpecialModeManager.getInstance().registerObserver(this._specialModeListener);
    sFontScaleUtil.init();
    this.initObserver();
  }

  private initObserver() {
    this.slObserverProxy.getVerifyInfo(AuthType.PIN, (verifyInfo: VerifyInfo): void => {
      this.hasPwd = !VerifyDataManager.getInstance().hasNoPwd;
    });
    this.slObserverProxy.getLockState((lockState: LockStateInfo): void => {
      this.isPageShow = lockState.isPageShow;
      this.isLocked = lockState.isLocked;
      this.refreshUnlockTip(this.getUnlockTip());
    });
    this.curState =
      this.slObserverProxy.getCoreFsmState(this.persistentId, (oldState: CoreStateType, newState: CoreStateType) => {
        this.curState = newState;
      });
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear`);
    this.slObserverProxy.release();
    // 即时释放拦截
    interruptMgr.getInterrupt(InterruptName.NTF_ITEM_ANIM_PARAS).releaseInterrupt();
    SpecialModeManager.getInstance().unRegisterObserver(this._specialModeListener);
  }

  private refreshUnlockTip(unlockTips: string) {
    this.unlockTips = unlockTips;
    this.isShowText = !!this.unlockTips;
    this.textOpacity = 1;
    log.showInfo(`refreshUnlockTip ${this.unlockTips}`);
  }

  private getUnlockTip(): string {
    // 解锁成功，锁屏退出期间，提示文字不变，避免用户感知闪
    if (!this.isPageShow) {
      return this.unlockTips;
    }
    let unlockTips = '';
    if (StrongAuthStateManager.getInstance().getPromptAuthStatus() === StrongAuthReasonFlags.USER_REBOOT) {
      unlockTips = StrongAuthStateManager.getInstance().getStrongAuthLockTip();
    } else if (!this.isLocked) {
      unlockTips = '';
    }
    return unlockTips;
  }

  private getUnlockText(): string {
    return this.unlockTips;
  }

  @Builder
  inputTextBuilder() {
    if (this.isShowText) {
      if (this.checkScroll(this.getUnlockText())) {
        Marquee({
          start: true,
          loop: 2,
          step: 2,
          fromStart: true,
          src: this.getUnlockText()
        })
          .id(COMPONENT_ID_LOCK_TIP)
          .fontColor(this.getLockIconColor())
          .fontSize(this.fontScale.unlockIconFontSize)
          .fontWeight(DeviceHelper.isPadOr2in1PcType() ? FontWeight.Medium : FontWeight.Normal)
          .margin({
            start: LengthMetrics.vp(4),
            top:  LengthMetrics.vp(1)
          })
          .width(MARQUEE_WIDTH)
          .onDisAppear(() => {
            log.showInfo('Marquee disAppeared');
          })
      } else {
        Text(this.getUnlockText())
          .draggable(false)
          .id(COMPONENT_ID_LOCK_TIP)
          .fontColor(this.getLockIconColor())
          .fontSize(this.fontScale.unlockIconFontSize)
          .fontWeight(DeviceHelper.isPadOr2in1PcType() ? FontWeight.Medium : FontWeight.Normal)
          .margin({
            start: LengthMetrics.vp(4),
            top: LengthMetrics.vp(1)
          })
          .opacity(this.textOpacity)
          .accessibilityLevel(this.isShowFaceCanvas ? 'no' : 'yes')
          .onDisAppear(() => {
            log.showInfo('lockHeadTip disAppeared');
          })
      }
    }
  }

  @Builder
  LockIconBuilder() {
    Stack() {
      if (this.hasPwd) {
        Image(this.getLockIcon())
          .draggable(false)
          .id(COMPONENT_ID_LOCK_ICON)
          .fillColor(this.getLockIconColor())
          .visibility(this.isShowFaceCanvas ? Visibility.None : Visibility.Visible)
          .width('100%')
          .height('100%')
      }
    }
    .width(this.getLockIconWidth())
    .height(this.getLockIconHeight())
    .align(Alignment.Center)
    .draggable(false)
  }

  build() {
    Stack() {
      Text(this.temporaryPromptViewModel?.temporaryPrompt)
        .draggable(false)
        .id(COMPONENT_ID_TEMPORARY_PROMPT)
        .fontColor(this.getLockIconColor())
        .fontSize(RTLUtil.isRTL() ? MAX_RTL_SIZE : this.fontScale.unlockIconFontSize)
        .minFontScale(sFontScaleUtil.getMinFontSize(false))
        .maxFontScale(sFontScaleUtil.getMaxFontSize(false, false))
        .margin({
          start: LengthMetrics.vp(4),
          top: LengthMetrics.vp(1),
        })
        .textAlign(TextAlign.Center)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .accessibilityGroup(true)
        .accessibilityLevel('yes')
        .visibility(this.temporaryPromptViewModel?.isShowTemporaryPrompt ? Visibility.Visible : Visibility.None)
        .accessibilityText(this.temporaryPromptViewModel?.temporaryPrompt)

        Flex({
          direction: FlexDirection.Row,
          justifyContent: FlexAlign.Center,
          alignItems: ItemAlign.Center
        }) {
          this.LockIconBuilder();
          this.inputTextBuilder();
        }
        .id(COMPONENT_ID_LOCK_ANIM)
        .visibility(this.getLockIconVisible())
        .accessibilityGroup(true)
        .accessibilityLevel(VerifyDataManager.getInstance().getVerifyInfo(AuthType.FACE).isSupportUnlock ? 'yes' : 'no')
        .accessibilityFocusDrawLevel(1)
        .accessibilityText(this.faceAccessibilityText)
        .focusable(false)
        .width('100%')

      Column() {
      }
      .useEffect(this.enableEffect)
      .blendMode(BlendMode_DESTINATION_IN)
      .width('100%')
      .height('100%')
      .accessibilityLevel('no')

      if (this.enableBright && this.enableEffect) {
        Column() {
        }
        .width('100%')
        .height('100%')
        .blendMode(this.getBlendMode())
        .backgroundColor(this.getBackgroundColor())
        .backgroundBrightnessInternal(this.getBrightnessOption())
        .accessibilityLevel('no')
      }
    }
    .blendMode(BlendMode_SRC_OVER)
    .width('100%')
    .height('100%')
    .scale(this.getLockIconScale())
    .translate(this.getLockIconTranslate())
    .opacity(this.getOpacity())
  }

  private getLockIconVisible(): Visibility {
    // 锁屏密码页，锁屏编辑，假AOD态下锁头均不显示
    let notInMainPage =
      CoreStateTypeUtils.isInFakeAodMainPage(this.curState) || CoreStateTypeUtils.isInEditMainPage(this.curState) ||
      CoreStateTypeUtils.isInBouncePage(this.curState);
    if (notInMainPage && AccessibilityUtil.isAccessibilityMode()) {
      return Visibility.None;
    }
    return this.temporaryPromptViewModel?.isShowTemporaryPrompt ? Visibility.Hidden : Visibility.Visible;
  }

  private getLockIconTranslate(): TranslateOptions {
    if (this.slLockIconAnimCtrl?.isSceneAnimating()) {
      return {
        x: this.slLockIconAnimCtrl.getTranX() ?? 0,
      };
    }
    return {
      x: 0,
    };
  }

  private getLockIconScale(): ScaleOptions { // 锁头缩放
    // 跟手滑动解锁场景
    if (ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation()) {
      let screenHeight: number =
        GlobalStatusCache.getInstance().getStatus(StatusCacheConst.SCREEN_HEIGHT_KEY, 0) as number;
      return {
        x: this.spaceAniOpt.getSpaceScale(),
        y: this.spaceAniOpt.getSpaceScale(),
        centerX: '50%',
        centerY: ScreenLockSpaceAnimationViewModel.getScaleCenterY(SlWidgetId.LOCK_HEAD, screenHeight)
      };
    }
    // 通知卡片一镜到底
    if (this.startAbilityAnimateData.ntfAnimScaleValue < 1) {
      return {
        x: this.startAbilityAnimateData.ntfAnimScaleValue,
        y: this.startAbilityAnimateData.ntfAnimScaleValue,
        centerX: this.slLockIconStaticState?.getWidgetScreenPivot()?.centerX ?? '50%',
        centerY: this.slLockIconStaticState?.getWidgetScreenPivot()?.centerY ?? '50%'
      }
    }
    // AOD一镜到底场景
    if (this.slLockIconAnimCtrl?.isSceneAnimating()) {
      return {
        x: this.slLockIconAnimCtrl?.getScaleX(),
        y: this.slLockIconAnimCtrl?.getScaleY()
      };
    }

    // 默认值
    return {
      x: this.slLockIconBindState?.getLayoutScale(),
      y: this.slLockIconBindState?.getLayoutScale()
    };
  }

  private getOpacity(): number { // 锁头透明度
    // 跟手滑动解锁场景
    if (ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation()) {
      log.debug(`getOpacity ${this.spaceAniOpt.getSpaceScale()}, globalOpacity: ${this.globalOpacity}`);
      return this.spaceAniOpt.getSpaceScale() * this.globalOpacity;
    }
    // AOD一镜到底场景
    if (this.slLockIconAnimCtrl?.isSceneAnimating()) {
      let alpha = this.slLockIconAnimCtrl?.getAlpha();
      if (alpha !== undefined) {
        log.debug(`getOpacity alpha: ${alpha}, globalOpacity: ${this.globalOpacity}`);
        return alpha * this.globalOpacity;
      }
    }
    // 默认值
    let opacity = this.slLockIconBindState?.getLayoutOpacity();
    log.debug(`getOpacity opacity: ${opacity}, globalOpacity: ${this.globalOpacity}`);
    return opacity * this.globalOpacity;
  }

  private getBlendMode(): BlendMode | undefined {
    if (this.enableSolid || !this.enableBright) {
      return BlendMode_DESTINATION_IN;
    }
    return BlendMode.NORMAL;
  }

  private getLockIconColor(): ResourceColor | undefined {
    if (this.isSpecialMode) {
      return $r('app.color.date_time_light_color');
    }
    if (this.enableSolid) {
      if (this.slLockIconBindState?.getChangeColor()) {
        return this.clockStrokeColor;
      }
      return this.normalBrightArgs?.getSolidColor();
    }

    if (!this.enableBright) {
      if (this.slLockIconBindState?.getChangeColor()) {
        return this.clockStrokeColor;
      }
      return undefined;
    }
    if (this.slLockIconBindState?.getChangeColor()) {
      return BrightnessOptionUtils.changeColor(this.clockStrokeColor);
    }
    return this.isLightWallpaper ? $r('app.color.date_time_dark_color') : BrightnessOptionUtils.brightColor;
  }

  private getBackgroundColor(): ResourceColor | undefined {
    if (!this.enableBright) {
      if (this.slLockIconBindState?.getChangeColor()) {
        return this.clockStrokeColor;
      }
      return this.normalBrightArgs?.getBrightnessColor(this.isLightWallpaper);
    }
    if (this.slLockIconBindState?.getChangeColor()) {
      return BrightnessOptionUtils.changeColor(this.clockStrokeColor);
    }
    return BrightnessOptionUtils.brightColor;
  }

  private getBrightnessOption(): BrightnessOptions | undefined {
    if (!this.enableBright) {
      return undefined;
    }
    if (this.slLockIconBindState?.getChangeColor()) {
      return this.isLightWallpaper ?
      BrightnessOptionUtils.keyguardTimeDarkOptionForFillColor :
      BrightnessOptionUtils.keyguardTimeLightOptionForFillColor;
    }
    return this.isLightWallpaper ? BrightnessOptionUtils.keyguardTimeDarkOption :
    BrightnessOptionUtils.keyguardTimeLightOption;
  }

  private getLockIconWidth(): number {
    return PasswordConstants.DEFAULT_LOCK_ICON_WIDTH;
  }

  private getLockIconHeight(): number {
    return PasswordConstants.DEFAULT_LOCK_ICON_HEIGHT;
  }

  private getLockIcon(): Resource {
    // 解锁成功，锁屏退出期间，小锁图标不变，避免用户感知闪
    if (!this.isPageShow) {
      return this.unlockIcon;
    }
    this.unlockIcon = this.isLocked ? $r('app.media.ic_public_lock') : $r('app.media.ic_public_unlock');
    return this.unlockIcon;
  }

  private checkScroll(text: string) {
    let textWidthPx = measure.measureText({
      textContent: text,
      fontSize: DeviceHelper.isPhone() ? this.fontScale.unlockIconFontSize : '16fp',
      fontWeight: DeviceHelper.isPadOr2in1PcType() ? FontWeight.Medium : FontWeight.Normal,
      fontFamily: $r('app.float.pwd_prompt_font_family'),
    })
    let textWidth = px2vp(textWidthPx);
    log.showDebug(`checkScroll, textWidth:${textWidth}, MARQUEE_WIDTH: ${MARQUEE_WIDTH}`);
    return textWidth > MARQUEE_WIDTH;
  }
}
