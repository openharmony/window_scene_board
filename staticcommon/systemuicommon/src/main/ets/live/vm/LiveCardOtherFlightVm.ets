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

import { ILiveCardOtherFlightVm } from '../interface/ILiveCardOtherFlightVm';
import { LiveCardOtherLayoutVm } from './LiveBaseVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AccessibilityVm } from '../../vm/AccessibilityVm';
import { ResourceVm } from '../../vm/ResourceVm';
import { LayoutStyle } from '../../liveview/common/LiveConstants';
import { LiveCardFlightModel } from '../model/LiveCardFlightModel';
import { LiveStyle } from '../constants/LiveStyle';

const TAG = 'LiveCardOtherFlightVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class LiveCardOtherFlightVm extends LiveCardOtherLayoutVm<LiveCardFlightModel>
implements ILiveCardOtherFlightVm {
  @Computed get layoutTitleSize(): Length {
    return this.card?.style === LayoutStyle.SUB_TYPE_BALANCE
      ? ResourceVm.instance.getNumberVp($r('sys.float.ohos_id_text_size_sub_title1'))
      : ResourceVm.instance.getNumberVp($r('sys.float.ohos_id_text_size_headline7'));
  }

  @Computed
  get layoutTitleColor(): ResourceColor | undefined {
    return LiveStyle.LIVE_CARD_TITLE_FONT_COLOR;
  }

  @Computed get layoutTitleMargin(): Margin | undefined {
    return this.card?.style === LayoutStyle.SUB_TYPE_BALANCE
      ? { bottom: $r('app.float.live_view_card_flight_title_margin_bottom') }
      : undefined;
  }

  @Computed get layoutContentSize(): Length {
    return this.card?.style === LayoutStyle.SUB_TYPE_BALANCE
      ? ResourceVm.instance.getNumberVp($r('sys.float.ohos_id_text_size_body1'))
      : ResourceVm.instance.getNumberVp($r('sys.float.ohos_id_text_size_body3'));
  }

  @Computed
  get layoutContentColor(): ResourceColor | undefined {
    return LiveStyle.LIVE_CARD_TEXT_FONT_COLOR;
  }

  @Computed get isLayoutFirstRTL(): boolean {
    return this.isLayoutRTL([this.card.layoutFirstTitle, this.card.layoutFirstContent]);
  }

  @Computed get isLayoutLastRTL(): boolean {
    return this.isLayoutRTL([this.card.layoutLastTitle, this.card.layoutLastContent]);
  }

  @Computed get layoutLastTitleBadgeText(): string {
    return this.getBadgeText(this.card.layoutLastTitleSuperscript);
  }

  @Computed get layoutLastTitleBadgeAccessibilityText(): string {
    return this.getBadgeAccessibilityText(this.layoutLastTitleBadgeText);
  }

  @Computed get layoutLastContentBadgeText(): string {
    return this.getBadgeText(this.card.layoutLastContentSuperscript);
  }

  @Computed get layoutLastContentBadgeAccessibilityText(): string {
    return this.getBadgeAccessibilityText(this.layoutLastContentBadgeText);
  }

  @Computed get layoutSpaceContentScale(): number {
    return this.card.liveCardWeatherInfo?.isWeatherCapsuleShow ? 0.9 : 1;
  }

  get layoutSpaceTextColor(): ResourceColor {
    return LiveStyle.LIVE_CARD_TEXT_FONT_COLOR;
  }

  get layoutSpaceTextBorderColor(): ResourceColor {
    return LiveStyle.LIVE_CARD_TEXT_FONT_COLOR;
  }

  get layoutAdditionalTextColor(): ResourceColor {
    return LiveStyle.LIVE_CARD_TEXT_FONT_COLOR;
  }

  protected isLayoutRTL(strings: Array<string | undefined>): boolean {
    return strings.some(text => ResourceVm.instance.isTextRTL(text ?? ''));
  }

  /**
   * 获取角标，格式限制为+X
   */
  protected getBadgeText(badgeText?: string): string {
    if (!badgeText) {
      return '';
    }
    badgeText = badgeText.slice(0, 2);
    return /\+\d/.test(badgeText) ? badgeText : '';
  }

  /**
   * 在符号后加[n0]，可将语境分离，+X不会读成正X
   */
  protected getBadgeAccessibilityText(accessibilityText: string): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    return accessibilityText ? accessibilityText.split('').join('[n0]') : '';
  }
}