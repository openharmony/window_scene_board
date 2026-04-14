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

import { ILiveCardSystemVm } from '../interface/ILiveCardSystemVm';
import { LiveItemBaseVm } from './LiveBaseVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveCardSystemModel } from '../model/LiveCardSystemModel';
import { PhoneSimStatus, SysTypeCode } from '../../liveview/common/LiveConstants';
import { LiveStyle } from '../constants/LiveStyle';
import { AccessibilityVm } from '../../vm/AccessibilityVm';
import { ResourceVm } from '../../vm/ResourceVm';
import { SystemUIUseScene } from '../../constants/SystemuiConstants';
import { TextEmojiHelper } from '../../utils/TextEmojiHelper';

const TAG = 'LiveCardSystemVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const BUTTON_MAX_NUM = 2;
const SHOW_ACTION_BUTTON_WHITE_MAP: Map<SystemUIUseScene, SysTypeCode[]> = new Map([
  [SystemUIUseScene.LIVE, [SysTypeCode.WIRELESS_PROJECTION]],
]);

@ObservedV2
export class LiveCardSystemVm extends LiveItemBaseVm implements ILiveCardSystemVm {
  @Trace public simIconSize: number | undefined;
  public fontFixedAreaHeight: number = 32;

  @Computed
  get contentRenderGroup(): boolean {
    return !TextEmojiHelper.isEmoji(typeof this.text === 'string' ? this.text :
      ResourceVm.instance.getString(this.text));
  }

  @Computed
  get maxFontScale(): number {
    return ResourceVm.instance.getLiveFontScale(ResourceVm.DEFAULT_MAX_SCALE);
  }

  @Computed get card(): LiveCardSystemModel {
    return this.live.card as LiveCardSystemModel;
  }

  @Computed get simIconColor(): Array<ResourceColor> {
    return [LiveStyle.LIVE_CARD_TEXT_FONT_COLOR];
  }

  get titleFontColor(): ResourceColor | undefined {
    return LiveStyle.LIVE_CARD_TITLE_FONT_COLOR;
  }

  get textFontColor(): ResourceColor | undefined {
    return LiveStyle.LIVE_CARD_TEXT_FONT_COLOR;
  }

  get textFontSize(): Length | undefined {
    return LiveStyle.SYSTEM_CARD_TEXT_FONT_SIZE;
  }

  get title(): ResourceStr {
    if (this.isHideContent()) {
      return this.live.appLabel;
    }
    if (this.card.timer && this.card.isTimerInTitle) {
      return this.vmInjector.getTimerVm().getTimerText(this.card.timer);
    }
    log.showInfo(`system card ${this.live.hashCode}, title length: ${this.card.title.length}`);
    return this.card.title;
  }

  get isBigTitle(): boolean {
    if (this.isHideContent()) {
      return false;
    }
    return Boolean(this.card.timer && this.card.isTimerInTitle && this.live.typeCode === SysTypeCode.BIG_TEXT_TIMER);
  }

  @Computed get titleFontSize(): Length {
    return this.isBigTitle ? $r('sys.float.ohos_id_text_size_headline6') : $r('sys.float.ohos_id_text_size_sub_title3');
  }

  @Computed
  get hasActionButtons(): boolean {
    if (this.live.actionButtons) {
      return this.live.actionButtons.length > 0 && this.live.actionButtons.length <= BUTTON_MAX_NUM;
    }
    return false;
  }

  @Computed
  get isShowActionButtons(): boolean {
    if (SHOW_ACTION_BUTTON_WHITE_MAP.get(this.vmInjector.scene)?.includes(this.live.typeCode)) {
      return true;
    }
    return false;
  }

  @Computed get titleLineHeight(): Length {
    return this.isBigTitle
      ? 'auto'
      : ResourceVm.instance.getLiveFontSize($r('app.float.live_view_card_text_line_height'));
  }

  get isContentAppear(): boolean {
    // 大计时器文本时，副文本不显示
    return !this.isBigTitle;
  }

  get text(): ResourceStr {
    if (this.isHideContent()) {
      return ResourceVm.instance.getPluralString($r('app.plural.live_hide_content'), 1);
    }
    if (this.card.isTimerInTitle) {
      return this.card.content
    } else {
      return this.card.timer ? this.vmInjector.getTimerVm().getTimerText(this.card.timer) : this.card.content;
    }
  }

  @Computed get textLineHeight(): Length {
    return ResourceVm.instance.getLiveFontSize(LiveStyle.CARD_TEXT_LINE_HEIGHT);
  }

  @Computed get simIcon(): Resource | undefined {
    let sim1 = LiveStyle.SIM1_SYMBOL_RESOURCE;
    let sim2 = LiveStyle.SIM2_SYMBOL_RESOURCE;
    if (!sim1 || !sim2) {
      return undefined;
    }
    switch (this.card.simIconStatus) {
      case PhoneSimStatus.STATUS_SIM_1:
        return sim1 as Resource;
      case PhoneSimStatus.STATUS_SIM_2:
        return sim2 as Resource;
      default:
        return undefined;
    }
  }

  public isHideContent(): boolean {
    return false;
  }

  getTitleAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    if (this.card.timer && this.card.isTimerInTitle) {
      return this.vmInjector.getTimerVm().getTimerAccessibilityText(this.card.timer);
    }
    return this.card.title;
  }

  getContentAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    if (this.card.isTimerInTitle) {
      return this.card.content;
    } else {
      return this.card.timer ? this.vmInjector.getTimerVm().getTimerAccessibilityText(this.card.timer)
        : this.card.content;
    }
  }

  getCardHeight(): number {
    return LiveStyle.LIVE_SYSTEM_CARD_HEIGHT +
    ResourceVm.instance.getLiveFontScaleHeightDiff(this.fontFixedAreaHeight);
  }

  getSolidTextColor(): ResourceColor | undefined {
    if (!this.vmInjector.getColorVm().isSolidEnable()) {
      return undefined;
    }
    return this.vmInjector.getColorVm()
      .calcSecondarySolidColor('#FFFFFF', this.textForegroundBrightness,
        this.vmInjector.getColorVm().liveBgPickColor);
  }

  @Computed
  get textForegroundBrightness(): BrightnessOptions | undefined {
    return this.vmInjector.getColorVm().liveFontFgBrightness;
  }
}