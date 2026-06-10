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

import { Log } from '@ohos/basicutils';
import { DeviceHelper, EventManager, EvtBus } from '@ohos/frameworkwrapper';
import { DisplayEvent, ResUtils } from '@ohos/windowscene';
import { RTLUtil } from '@ohos/componenthelper';
import MediumButton from '../buttons/MediumButton';
import { Constants } from '../utils/Contants';
import { AdaptCutMargin, ScreenLockCutOutUtil } from '../../common/utils/ScreenLockCutOutUtil';
import curves from '@ohos.curves';
import { LengthMetrics } from '@kit.ArkUI';
import { slStateHelper } from '../../common/utils/SlStateHelper';
import { SlEditorBindState } from '../models/SlEditorBindState';

const TAG: string = 'ActionSheet';
const FRAME_TIME_DELAY: number = 5 * 16;

@Component
export default struct ActionSheet {
  @Prop isHideTopButton: boolean;
  @Prop showGuide: boolean;
  @Prop isClockVisable: boolean;
  @Consume isEdited: boolean;
  @State animating: boolean = false;
  @Consume @Watch('refreshOrientation') isFoldExpand: boolean;
  leftCallback?: () => void;
  rightCallback?: () => void;

  @State adaptCut: AdaptCutMargin = {
    marginTop: ResUtils.getNumber(DeviceHelper.isPadOr2in1PcType() ? $r('app.float.actionsheet_padding_h') : $r('app.float.actionsheet_padding_v')),
    marginLeft: ResUtils.getNumber($r('app.float.actionsheet_padding_h')),
    marginRight: ResUtils.getNumber($r('app.float.actionsheet_padding_h'))
  };
  @Link blurRadius: number;
  @Link actionScale: number;
  @Link actionOpacity: number;
  /**
   * 横竖屏状态
   */
  @State @Watch('refreshOrientation') orientation: number = DeviceHelper.getOrientation();

  // 编辑面板UI绑定状态
  @State private slEditorBindState: SlEditorBindState = slStateHelper.getEditorBindState();

  private eventMgr: EventManager = EvtBus.createEventManager();

  private updateFoldState(): void {
    ScreenLockCutOutUtil.getMarginToAdaptCut(this.adaptCut);
  }

  aboutToAppear() {
    ScreenLockCutOutUtil.getMarginToAdaptCut(this.adaptCut);
    this.eventMgr.on(DisplayEvent, this.handleDisplayEvent);
    setTimeout(() => this.appearAnimation(), 100);
  }

  aboutToDisappear(): void {
    this.eventMgr.offAll();
  }

  private handleDisplayEvent = (event: DisplayEvent): void => {
    // 横竖屏状态切换
    let curOrientation = DeviceHelper.getOrientation();
    if (this.orientation !== curOrientation) {
      this.orientation = curOrientation;
    }
  }

  private refreshOrientation(): void {
    ScreenLockCutOutUtil.getMarginToAdaptCut(this.adaptCut);
  }

  private appearAnimation(): void {
    setTimeout(() => {
      this.animating = true;
    }, FRAME_TIME_DELAY);
    animateTo({
      duration: 200,
      curve: curves.cubicBezierCurve(0.4, 0.0, 0.4, 1.0)
    }, () => {
      this.actionOpacity = 1;
    });
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 228, 30),
      onFinish: () => { this.animating = false}
    }, () => {
      this.actionScale = 1;
    });
  }

  private getBtnInAndOutOpacityEffect(): TransitionEffect {
    return TransitionEffect.asymmetric(TransitionEffect.OPACITY.animation({ duration: 200, curve: Curve.Sharp, delay: 200 })
      .combine(TransitionEffect.scale({ x: 0.7, y: 0.7 })
        .animation({ duration: 500, curve: Curve.Friction, delay: 200 })), TransitionEffect.OPACITY.animation({ duration: 150, curve: Curve.Sharp, delay: 100 })
      .combine(TransitionEffect.scale({ x: 0.7, y: 0.7 }).animation({ duration: 300, curve: Curve.Friction })))
  }

  @Styles
  blurAndShadowStyle() {
    .backgroundEffect({
      policy: 1,
      radius: Constants.BLUR_RADIUS,
      brightness: 1.1,
    }, { disableSystemAdaptation: true })
    .shadow({
      radius: Constants.SHADOW_RADIUS,
      color: Constants.PANE_SHADOW_COLOR,
      offsetY: Constants.FLOAT_BTN_SHADOW_OFFSETY,
    })
  }

  build() {
    EffectComponent() {
      Row() {
        MediumButton({
          animating: this.animating,
          showGuide: this.showGuide,
          text: this.showGuide ? $r('app.string.theme_edit_cancel') : $r('app.string.psd_back'),
          blurRadius: this.blurRadius,
          onButtonClick: () => {
            Log.info(TAG, 'leftCallback');
            this.leftCallback && this.leftCallback();
          }
        }).margin({ start: LengthMetrics.vp(RTLUtil.isRTL() ? this.adaptCut.marginRight : this.adaptCut.marginLeft) })
          .transition(this.getBtnInAndOutOpacityEffect())
          .scale({
            x: this.actionScale * this.slEditorBindState.getLayoutScale(),
            y: this.actionScale * this.slEditorBindState.getLayoutScale()
          })
          .opacity(this.actionOpacity * this.slEditorBindState.getButtonAlpha())

        MediumButton({
          animating: this.animating,
          showGuide: this.showGuide,
          bgColor: this.isEdited ? Color.Blue : '#33FFFFFF',
          blurRadius: this.blurRadius,
          text: $r('app.string.theme_edit_apply'),
          onButtonClick: () => {
            Log.info(TAG, 'rightCallback');
            this.rightCallback && this.rightCallback();
          }
        })
          .margin({ end: LengthMetrics.vp(RTLUtil.isRTL() ? this.adaptCut.marginLeft : this.adaptCut.marginRight) })
          .transition(this.getBtnInAndOutOpacityEffect())
          .visibility(this.isClockVisable ? Visibility.Visible : Visibility.Hidden)
          .scale({
            x: this.actionScale * this.slEditorBindState.getLayoutScale(),
            y: this.actionScale * this.slEditorBindState.getLayoutScale()
          })
          .opacity(this.actionOpacity * this.slEditorBindState.getButtonAlpha())
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .hitTestBehavior(HitTestMode.None)
    }
    .width('100%')
    .blurAndShadowStyle()
    .margin({
      top: this.adaptCut.marginTop,
      bottom: $r('app.float.actionsheet_padding_v'),
    })
    .freeze(this.animating)
    .visibility(this.isHideTopButton ? Visibility.Hidden : Visibility.Visible)
    .hitTestBehavior(HitTestMode.None)
  }
}
