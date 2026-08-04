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
import { LiveViewCommonConstants } from '../../../common/LiveConstants';
import { LiveTimerData } from '../../../data/extend/LiveTimerData';
import { immersiveKgMgr } from '../../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { AodStyleType, ImmersiveAodStyle } from '../../../../immersivekeyguardcommon/base/interface/ImmersiveAodStyle';
import { fontScaleManager } from '@ohos/systemuiutils/src/main/ets/fontScale/fontScaleManager';
import { FontScaleState } from '@ohos/systemuiutils/src/main/ets/fontScale/fontScaleState';
import { TimeTextStyle } from '../../../../immersivekeyguardcommon/base/interface/TimeTextStyle';
import { ResUtils } from '@ohos/windowscene';
import { NotificationType } from '../../../../constants/NotificationType';
import { LiveAccessibilityUtil } from '../../../common/liveAccessibilityUtil';
import { OuterHomeVm } from '../../../../../ets/vm/OuterHomeVm';
import { CommonUtils } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';

@Component
export struct LiveTimeComponent {
  @ObjectLink timeData: LiveTimerData;
  private timeTextStyle?: TimeTextStyle;
  @Prop viewFontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary');
  @Prop foreBrightnessOption: BrightnessOptions | undefined = undefined;
  @Prop isAodText: string | undefined = undefined;

  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  /**
   * AOD显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(
    this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD);
  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  @State outerHomeVm: OuterHomeVm = OuterHomeVm.get();

  private dateFormat: Date = new Date();
  private viewFontSize: Resource = $r('app.float.live_view_card_text_font_size');
  private marginBottom: number | Resource | Length = $r('app.float.live_view_card_title_margin_bottom');
  private isBigTextTimer: boolean = false;

  build() {
    if (this.timeData) {
      Text(this.getTimeText())
        .accessibilityText(this.getTimeAccessibilityText())
        .fontColor(this.viewFontColor)
        .foregroundBrightness(this.aodStyle?.isAod ? undefined : this.foreBrightnessOption)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .fontSize(this.getTextFontSize())
        .margin({
          bottom: this.timeTextStyle?.marginBottom ?? this.marginBottom,
        })
        .lineHeight(this.getLineHeight(this.outerHomeVm.isIgnoreFontScaleState))
        .height(this.outerHomeVm.isIgnoreFontScaleState ? this.getLineHeight(this.outerHomeVm.isIgnoreFontScaleState) :
          this.timeTextStyle?.height ?? 'auto')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .visibility(this.aodStyle?.isAod && !this.isAodText ? Visibility.None : Visibility.Visible)
        .scale({
          x: this.isAodBigTimer() && ResUtils.getNumber(this.viewFontSize) ?
            LiveViewCommonConstants.AOD_BIG_TIMER_FONT_SIZE / ResUtils.getNumber(this.viewFontSize) :
            1,
          y: this.isAodBigTimer() && ResUtils.getNumber(this.viewFontSize) ?
            LiveViewCommonConstants.AOD_BIG_TIMER_FONT_SIZE / ResUtils.getNumber(this.viewFontSize) :
            1,
          centerX: RTLUtil.isRTL() ? '100%' : 0,
          centerY: '50%',
        })
    }
  }

  /**
   * 锁屏界面LineHeight自适应
   * @returns
   */
  private getLineHeight(isIgnoreFontScaleState?: boolean | undefined): number | string {
    return this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD ? 'auto' :
    this.fontScaleState.getScaleSize($r('app.float.live_view_card_text_line_height'), isIgnoreFontScaleState);
  }

  private getTextFontSize(): string {
    if (this.outerHomeVm.isIgnoreFontScaleState) {
      return this.fontScaleState.getScaleSize(this.viewFontSize, this.outerHomeVm.isIgnoreFontScaleState);
    }
    if (this.timeTextStyle) {
      return this.fontScaleState.getCapSize(this.timeTextStyle?.fontSize);
    }
    if (this.isBigTextTimer) {
      return ResUtils.getNumber(this.viewFontSize) + 'vp';
    }
    return this.fontScaleState.getScaleSize(this.viewFontSize);
  }

  private getTimeText(): string {
    if (this.aodStyle?.isAod && this.isAodText) {
      return this.isAodText;
    }
    return LiveViewCommonConstants.formatDate(this.timeData?.initialTime, this.dateFormat, this.timeData?.isCountDown);
  }

  private getTimeAccessibilityText(): string {
    if (this.aodStyle?.isAod && this.isAodText) {
      return this.isAodText;
    }
    return LiveAccessibilityUtil.getTImeAccessibilityText(this.timeData);
  }

  /**
   * 获取是否AOD大字体计时控件场景
   *
   * @returns 是否AOD大字体计时控件场景
   */
  private isAodBigTimer(): boolean {
    return this.isBigTextTimer && this.aodStyle?.isAod && !CommonUtils.isEmpty(this.isAodText) ? true : false;
  }
}