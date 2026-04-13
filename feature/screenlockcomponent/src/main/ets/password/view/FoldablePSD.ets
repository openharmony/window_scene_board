/**
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
import DigitalPSD from './DigitalPSD';
import CustomPSD from './CustomPSD';
import Constants from '../../common/Constants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper';
import curves from '@ohos.curves';
import { CommonConstants, slWallpaperMgr, SLWallpaperState, VerifyDataManager } from '@ohos/screenlockcommon';
import { AuthSubType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { ScreenLockPasswordVm } from '../viewmodel/PasswordVm'
import { DevicesGrids, PassWordLayout } from '../../common/LayoutConstants.ets';
import ScreenLockKeyboardTipUtil from '../../common/ScreenLockKeyboardUtil';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { LengthMetrics } from '@kit.ArkUI';
import FoldablePSDViewModel, { FoldablePSDModel } from '../viewmodel/FoldablePSDViewModel';
import { DigitalPasswordVm, PatternPasswordVm, UnfixedPasswordVm } from '../viewmodel/PasswordVm';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { slStateHelper } from '../../common/helper/SlStateHelper';

const TAG = 'FoldDigitalPSD';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const BIG_FOLD_ARROW_WIDTH: string = '50%';
const PASSWORD_WIDTH: string = '50%';
const ULTRA_SCREEN_G_STATE_ARROW_WIDTH: string = '25%';

@Component
export default struct FoldablePSD {
  private persistentId: number = 0;
  private passwordVm?: ScreenLockPasswordVm;
  private onBack: Function = () => {};
  private offHandNormalizedSpeed: number = 0;
  private passwordType: string = '';
  private onEmergencyKeyClick: Function = () => {};
  private mFoldablePSDViewModel: FoldablePSDViewModel = new FoldablePSDViewModel();
  @StorageLink('isLeft') isLeft: boolean = false;
  @StorageLink('isRight') isRight: boolean = false;
  @Provide passWordWidth:number = 0;
  @State slWallpaperState: SLWallpaperState = slWallpaperMgr.getSlWallpaperState();
  @State passWordHeight:number = 0;
  @Prop keyboardPosition: number = Constants.NO_TOUCH_OR_SCREEN_MIDDLE;
  @State mFoldablePSDModel: FoldablePSDModel = new FoldablePSDModel();
  @State componentArrowMarginBottom: number = 246;
  @State componentArrowMarginLeft: number = 85;
  @State slFoldablePSDAnimCtrl: WidgetAnimState | undefined = slStateHelper.getSlFoldablePSDAnimCtrl();
  @Consume @Watch('onPSDLayoutDataChange') displayHeight: number;
  @Consume @Watch('onPSDLayoutDataChange') displayWidth: number;
  @Consume @Watch('onPSDLayoutDataChange') psdLayoutData: PassWordLayout;
  @Consume @Watch('onPSDLayoutDataChange') deviceGridData: DevicesGrids;
  @Link psdViewScale: number;
  @Link psdViewOpacity: number;

  private onPSDLayoutDataChange():void {
    this.passWordWidth = ScreenLockKeyboardTipUtil.keyboardWidthLayout(this.displayWidth, this.deviceGridData);
    this.componentArrowMarginLeft =
      ScreenLockKeyboardTipUtil.componentArrowMarginLeft(this.displayWidth, this.deviceGridData);
    this.componentArrowMarginBottom =
      ScreenLockKeyboardTipUtil.componentArrowMarginBottom(this.displayHeight, this.psdLayoutData, this.passwordType);
    log.showInfo(`PSDColumChange,passWordWidth:${this.passWordWidth},deviceGridData:${this.psdLayoutData.index},` +
      `displayHeight:${this.displayHeight},displayWidth:${this.displayWidth}`);
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.passwordVm = this.getPasswordVm();
    this.passwordVm.init();
    this.mFoldablePSDViewModel.viewModelInit(this.mFoldablePSDModel);
    this.mFoldablePSDViewModel.doInit();
    this.onPSDLayoutDataChange();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.passwordVm?.release();
    this.mFoldablePSDViewModel.doRelease();
  }

  private getFoldablePSDTranslate(): TranslateOptions {
    if (this.slFoldablePSDAnimCtrl?.isSceneAnimating() && DeviceHelper.isUltraScreenProduct()) {
      return {
        x: this.slFoldablePSDAnimCtrl.getTranX() ?? 0,
      };
    }
    return {
      x: 0,
    };
  }

  private getPasswordVm(): ScreenLockPasswordVm {
    switch (VerifyDataManager.getInstance().pwdType) {
      case AuthSubType.PIN_SIX:
      case AuthSubType.PIN_FOUR:
        return new DigitalPasswordVm(this.persistentId);
      case AuthSubType.PIN_NUMBER:
      case AuthSubType.PIN_MIXED:
        return new UnfixedPasswordVm(this.persistentId);
      case AuthSubType.PIN_PATTERN:
        return new PatternPasswordVm(this.persistentId);
    }
    return new DigitalPasswordVm(this.persistentId);
  }

  @Builder
  componentPSD(isFullShowPwd: boolean) {
    if (this.passwordType === CommonConstants.PIN_TYPE_SIX || this.passwordType === CommonConstants.PIN_TYPE_FOUR) {
      DigitalPSD({
        onBack: (): void => this.onBack(),
        onEmergencyKeyClick: () => {
          this.onEmergencyKeyClick()
        },
        offHandNormalizedSpeed: this.offHandNormalizedSpeed,
        passwordVm: this.passwordVm,
        isFullShowPwd: isFullShowPwd,
        psdViewScale: this.psdViewScale,
        psdViewOpacity: this.psdViewOpacity,
        persistentId: this.persistentId
      })
    } else {
      CustomPSD({
        onBack: (): void => this.onBack(),
        onEmergencyKeyClick: () => {
          this.onEmergencyKeyClick()
        },
        offHandNormalizedSpeed: this.offHandNormalizedSpeed,
        passwordVm: this.passwordVm,
        isFullShowPwd: isFullShowPwd,
        psdViewScale: this.psdViewScale,
        psdViewOpacity: this.psdViewOpacity,
        persistentId: this.persistentId
      })
    }
  }

  @Builder
  componentArrow(angleValue: number, isRight: boolean) {
    Column() {
      Stack({ alignContent: Alignment.Center }) {
        Column() {
        }
        .width('100%')
        .height('100%')
        .borderRadius('32vp')
        .backgroundColor(BrightnessOptionUtils.brightColor)
        .backgroundBrightnessInternal(this.getBrightness())
        Image($r('app.media.ic_switch_right'))
          .draggable(false)
          .rotate({ angle: angleValue })
          .fillColor(this.slWallpaperState?.getWallpaperReverseColor())
          .width('100%')
          .height('100%')
          .onTouch((event: TouchEvent) => {
            if (event.type !== TouchType.Down) {
              return;
            }
            log.showInfo(`this.pwdInputPosition = ${this.keyboardPosition}`);
            if (this.keyboardPosition === Constants.SCREEN_LEFT) {
              this.keyboardPosition = Constants.SCREEN_RIGHT;
            } else if (this.keyboardPosition === Constants.SCREEN_RIGHT) {
              this.keyboardPosition = Constants.SCREEN_LEFT;
            } else if (this.keyboardPosition === Constants.NO_TOUCH_OR_SCREEN_MIDDLE) {
              this.keyboardPosition = isRight ? Constants.SCREEN_RIGHT : Constants.SCREEN_LEFT;
            }
          });
      }
      .width('32vp')
      .height('32vp')
      .margin(isRight ? (RTLUtil.isRTL() ? { start: LengthMetrics.vp(this.componentArrowMarginLeft) } :
        { end: LengthMetrics.vp(this.componentArrowMarginLeft) }) :
        (RTLUtil.isRTL() ? { end: LengthMetrics.vp(this.componentArrowMarginLeft) } :
          { start: LengthMetrics.vp(this.componentArrowMarginLeft) }))
    }
    .width('100%')
    .margin({ bottom: this.componentArrowMarginBottom })
    .alignItems(isRight ? (RTLUtil.isRTL() ? HorizontalAlign.Start : HorizontalAlign.End) :
      (RTLUtil.isRTL() ? HorizontalAlign.End : HorizontalAlign.Start))
    .justifyContent(FlexAlign.End)
    .transition(
      TransitionEffect.asymmetric(
        TransitionEffect.opacity(0).animation({
          duration: Constants.PSD_ENTER_OPACITY_TIME,
          delay: Constants.DELAY_TIME_PER_TURN
        }).combine(TransitionEffect.scale({ x: Constants.PSD_INIT_SCALE, y: Constants.PSD_INIT_SCALE })
          .animation({
            curve: curves.interpolatingSpring(this.offHandNormalizedSpeed, Constants.PSD_MASS, Constants.PSD_STIFFNESS, Constants.PSD_DAMPING),
            delay: Constants.DELAY_TIME_PER_TURN
          })
          .combine(TransitionEffect.translate({
            x: 0,
            y: -Constants.DIST_PER_TURN * Constants.PSD_TRANS_Y_FACTOR
          })
            .animation({
              curve: curves.interpolatingSpring(this.offHandNormalizedSpeed, Constants.PSD_MASS, Constants.PSD_STIFFNESS, Constants.PSD_DAMPING),
              delay: Constants.DELAY_TIME_PER_TURN
            })))
        , TransitionEffect.IDENTITY)
    )
  }

  build() {
    if (this.isFoldFullDisplay() && !DeviceHelper.isSmallFoldProduct()) {
      Row() {
        Column() {
          this.componentArrow(180, false);
        }
        .width(this.getArrowWidth(false))
        .visibility(this.isLeftArrow() ? Visibility.Visible : Visibility.Hidden)

        Column() {
          this.componentPSD(false);
        }.width(this.getPasswordWidth())

        Column() {
          this.componentArrow(0, true);
        }
        .width(this.getArrowWidth(true))
        .visibility(this.isRightArrow()? Visibility.Visible : Visibility.Hidden)
      }
      .justifyContent(FlexAlign.Center)
      .direction(Direction.Ltr)
      .alignItems(VerticalAlign.Bottom)
      .translate(this.getFoldablePSDTranslate())
      .width('100%')
      .height('100%')
      .scale({
        x: this.psdViewScale,
        y: this.psdViewScale
      })
      .opacity(this.psdViewOpacity)
    } else {
      this.componentPSD(true);
    }
  }

  private isFoldFullDisplay(): boolean {
    log.showInfo(`isFoldFullDisplay = ${this.mFoldablePSDModel.isExpand}`);
    return this.mFoldablePSDModel.isExpand;
  }

  private isRightArrow() {
    this.isRight = this.keyboardPosition === Constants.SCREEN_LEFT || this.isUltraScreenGStatusMiddleKeyboard();
    return this.keyboardPosition === Constants.SCREEN_LEFT || this.isUltraScreenGStatusMiddleKeyboard();
  }

  private isLeftArrow() {
    this.isLeft = this.keyboardPosition === Constants.SCREEN_RIGHT || this.isUltraScreenGStatusMiddleKeyboard();
    return this.keyboardPosition === Constants.SCREEN_RIGHT || this.isUltraScreenGStatusMiddleKeyboard();
  }

  private getArrowWidth(isRight: boolean): Length {
    const needShowArrow: boolean = isRight ? this.isRightArrow() : this.isLeftArrow();
    if (!this.mFoldablePSDModel.isUltraScreenGState) {
      // 非超大屏G态时，箭头不显示或宽度固定50% (此时密码盘的宽度固定为50%)
      return needShowArrow ? BIG_FOLD_ARROW_WIDTH : 0;
    }
    // 超大屏G态场景
    if (this.keyboardPosition === Constants.NO_TOUCH_OR_SCREEN_MIDDLE) {
      // 如果密码盘位于中间，此时需同时显示左右箭头，箭头宽度均设置成25%
      return ULTRA_SCREEN_G_STATE_ARROW_WIDTH;
    } else {
      // 超大屏G态, 且密码盘不位于中间, 需要调整密码盘与箭头的宽度比例
      return needShowArrow ? (1 - this.mFoldablePSDModel.gStateKeyboardWidthPercent) * 100 + '%' : 0;
    }
  }

  private getPasswordWidth(): Length {
    if (this.mFoldablePSDModel.isUltraScreenGState && this.keyboardPosition !== Constants.NO_TOUCH_OR_SCREEN_MIDDLE) {
      // 超大屏G态, 且密码盘不位于中间, 需要调整密码盘与箭头的宽度比例
      return this.mFoldablePSDModel.gStateKeyboardWidthPercent * 100 + '%';
    } else {
      return PASSWORD_WIDTH;
    }
  }

  private isUltraScreenGStatusMiddleKeyboard() : boolean {
    return this.mFoldablePSDModel.isUltraScreenGState && this.keyboardPosition === Constants.NO_TOUCH_OR_SCREEN_MIDDLE;
  }

  private getBrightness(): BrightnessOptions {
    return slWallpaperMgr.getSlWallpaperState().isLightWallpaper ? BrightnessOptionUtils.passwordDarkOption :
    BrightnessOptionUtils.passwordLightOption;
  }
}

