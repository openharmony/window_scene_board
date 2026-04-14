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

import { LengthMetrics } from '@ohos.arkui.node';
import { LiveCardOtherModel } from '../model/LiveCardOtherModel';
import { LiveCardType, LiveExtensionType } from '../model/LiveCommonModel';
import { LiveVmInjector } from '../LiveVmInjector';
import { ILiveCardOtherExtendVm } from '../interface/ILiveCardOtherExtendVm';
import { LiveNotification } from '../model/LiveNotification';
import { SystemUIColorVm } from '../../vm/SystemUIColorVm';
import { BaseGesture } from '../../vm/BaseGesture';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'LiveCardOtherVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 三方卡片辅助区
 */
@ComponentV2
export struct LiveCardOtherExtendView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;

  colorVm: SystemUIColorVm = this.liveVmInjector.getColorVm();
  @Computed get card(): LiveCardOtherModel {
    return this.live.card as LiveCardOtherModel;
  }
  @Computed get useSysIconSize(): boolean {
    return this.card.cardType === LiveCardType.NO_LAYOUT;
  }
  @Computed get extendVm(): ILiveCardOtherExtendVm {
    return this.liveVmInjector.getCardOtherExtendVm(this.live);
  }
  @Computed get baseGesture(): BaseGesture {
    const gesture = new BaseGesture();
    if (this.extendVm?.tapGesture) {
      gesture.addGesture(this.extendVm.tapGesture);
    }
    return gesture;
  }

  build() {
    if (this.card && this.card?.extensionType !== LiveExtensionType.DEFAULT) {
      Row() {
        if (this.card?.extensionType === LiveExtensionType.NORMAL_TEXT) {
          Text(this.card?.extensionText ?? '')
            .fontFamily('HarmonyOS-Sans')
            .fontWeight(FontWeight.Regular)
            .maxFontSize(this.extendVm.normalTextMaxFont)
            .minFontSize(this.extendVm.normalTextMinFont)
            .fontFeature('\"ss08\" on')
            .fontColor(this.extendVm.textColor)
            .foregroundBrightness(this.extendVm?.fontFgBrightness)
            .textAlign(TextAlign.Center)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .width(this.extendVm.normalTextWidth)
            .height(this.extendVm.normalTextHeight)
            .renderGroup(this.extendVm.isRenderGroup)
        } else if (this.card?.extensionType === LiveExtensionType.CAPSULE_TEXT) {
          Button({
            type: ButtonType.Capsule,
            stateEffect: true
          }) {
            Text(this.card?.extensionText ?? '')
              .fontFamily('HarmonyOS-Sans')
              .fontWeight(FontWeight.Bold)
              .maxFontSize(this.extendVm.normalTextMaxFont)
              .minFontSize(this.extendVm.normalTextMinFont)
              .fontFeature('\"ss08\" on')
              .fontColor(this.extendVm.textColor)
              .foregroundBrightness(this.extendVm?.fontFgBrightness)
              .opacity(this.extendVm.buttonTextOpacity)
              .textAlign(TextAlign.Center)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .height(this.extendVm.capsuleButtonTextHeight)
              .margin({
                top: LengthMetrics.vp(this.extendVm.capsuleButtonTopMargin),
                bottom: LengthMetrics.vp(this.extendVm.capsuleButtonTopMargin),
                end: LengthMetrics.vp(this.extendVm.capsuleButtonLeftMargin),
                start: LengthMetrics.vp(this.extendVm.capsuleButtonLeftMargin)
              })
              .renderGroup(this.extendVm.isRenderGroup)
          }
          .height(this.extendVm.capsuleButtonHeight)
          .constraintSize({
            minWidth: this.extendVm.capsuleButtonWidth,
            maxWidth: this.extendVm.capsuleButtonMaxWidth,
            maxHeight: this.extendVm.capsuleButtonHeight,
          })
          .backgroundColor(this.extendVm.buttonBgColor)
          .backgroundBrightnessInternal(this.extendVm?.buttonBgBrightness)
        } else if (this.card?.extensionType === LiveExtensionType.PICTURE && this.card?.extensionPic) {
          Image(this.card?.extensionPic)
            .objectFit(ImageFit.Contain)
            .draggable(false)
            .interpolation(ImageInterpolation.Medium)
            .width(this.extendVm.extendWidth)
            .height('100%')
            .onError((error) => {
              log.showWarn(`extend picture load error: ${error?.message},${this.card?.extensionPic}`);
            })
        } else if (this.card?.extensionType === LiveExtensionType.ICON && this.card?.extensionPic) {
          Image(this.card?.extensionPic)
            .objectFit(ImageFit.ScaleDown)
            .draggable(false)
            .interpolation(ImageInterpolation.Medium)
            .constraintSize({
              maxWidth: this.useSysIconSize ? this.extendVm.buttonLength : this.extendVm.extendWidth,
              maxHeight: this.useSysIconSize ? this.extendVm.buttonLength : this.extendVm.extendHeight
            })
            .onError((error) => {
            log.showWarn(`extend icon load error: ${error?.message},${this.card?.extensionPic}`);
          })
        }
      }
      .opacity(this.extendVm.opacity)
      .accessibilityLevel('yes')
      .accessibilityGroup(true)
      .height(this.extendVm.extendHeight)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .borderRadius($r('app.float.live_view_extend_border_radius'))
      .clip(true)
      .gestureModifier(this.baseGesture)
      .accessibilityRole(this.extendVm.tapGesture ? AccessibilityRoleType.BUTTON : undefined)
    }
  }
}