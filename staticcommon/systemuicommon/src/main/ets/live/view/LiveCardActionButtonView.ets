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

import { LiveVmInjector } from '../LiveVmInjector';
import { ResourceVm } from '../../vm/ResourceVm';
import { LiveNotification } from '../model/LiveNotification';
import { LiveCardOtherModel } from '../model/LiveCardOtherModel';
import { ILiveActionButtonVm } from '../interface/ILiveActionButtonVm';
import { NotificationAction } from '../../model/NotificationContent';

/**
 * 实况关联服务按钮
 */
@ComponentV2
export struct LiveCardActionButtonView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;
  colorVm = this.liveVmInjector.getColorVm();

  @Computed
  get card(): LiveCardOtherModel {
    return this.live.card as LiveCardOtherModel;
  }

  @Computed
  get actionButtonVm(): ILiveActionButtonVm {
    return this.liveVmInjector.getLiveActionButtonVm(this.live);
  }

  build() {
    Row() {
      Repeat(this.actionButtonVm.actionButtons).each((data) => {
        this.buildDivider(data.index);
        this.buildButton(data.index);
      }).key((_, index: number) => this.live.hashCode + '#' + index)
    }
    .accessibilityText(' ')
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor(this.actionButtonVm.backgroundColor)
    .backgroundBrightnessInternal(this.colorVm.actionButtonBgBrightness)
    .width('100%')
  }

  @Builder
  buildDivider(index: number) {
    if (index !== 0) {
      Divider()
        .vertical(true)
        .height(22)
        .visibility(this.actionButtonVm.getDividerVisible())
        .color($r('app.color.theme_ntf_phone_action_divider_color'))
        .opacity(this.actionButtonVm?.dividerAlpha)
        .foregroundBrightness(this.actionButtonVm?.dividerFgBrightness)
        .flexShrink(0)
    }
  }

  @Builder
  buildButton(index: number) {
    Stack() {
      Text(this.actionButtonVm.actionButtons[index]?.actionTitle)
        .draggable(false)
        .fontColor(this.actionButtonVm.fontColor)
        .fontWeight(FontWeight.Medium)
        .fontSize(this.actionButtonVm.fontSize)
        .maxFontScale(ResourceVm.instance.getLiveFontScale())
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontWeight(FontWeight.Medium)
        .lineHeight(this.actionButtonVm.lineHeight)
        .width('100%')
        .textAlign(TextAlign.Center)
        .onTouch((event) => this.actionButtonVm.handleTouchEvent(event, index))
    }
    .visibility(this.actionButtonVm.actionButtons[index]?.actionTitle ? Visibility.Visible : Visibility.None)
    .flexShrink(1)
    .responseRegion([
      { x: 0, y: 0, width: '100%', height: '100%' },
      { x: 0, y: '100%', width: '100%', height: '4vp'}
    ])
    .onClick(this.actionButtonVm.hasClickEvent(index) ? () => this.actionButtonVm.handleClickEvent(index) : undefined)
    .onTouch(event => {
      event.stopPropagation();
    })
    .width('100%')
    .padding({
      left: '12vp',
      right: '12vp',
      top: '8vp',
      bottom: '8vp'
    })
    .backgroundColor(this.actionButtonVm.backgroundColors[index])
  }
}