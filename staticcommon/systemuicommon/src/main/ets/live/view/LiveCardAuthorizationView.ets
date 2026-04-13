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

import { ResUtils } from '@ohos/windowscene';

import { ILiveCardAuthorizationVm } from '../interface/ILiveCardAuthorizationVm';
import { LiveVmInjector } from '../LiveVmInjector';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveNotification } from '../model/LiveNotification';

const TAG = 'LiveCardAuthorizationView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const leftButtonAction = 'left';
const rightButtonAction = 'right';

interface LiveCardAuthorizationButtonViewParam {
  text: Resource,
  onClickAction: () => void,
  buttonFlage: string;
}

@ComponentV2
export struct LiveCardAuthorizationView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;

  @Computed
  get authorizationVm(): ILiveCardAuthorizationVm {
    return this.liveVmInjector.getCardAuthorizationVm(this.live);
  }

  build() {
    if (this.live) {
      Column() {
        Text(this.authorizationVm.cardAuthorizationTip)
          .fontColor(this.authorizationVm.textFontColor)
          .opacity(this.authorizationVm.textOpacity)
          .fontSize(this.authorizationVm.textFontSize)
          .maxFontScale(this.authorizationVm.maxFontScale)
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .lineHeight(this.authorizationVm.textLineHeight)

        this.buildButtonZone();
      }
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .padding({
        left: $r('app.float.live_view_card_padding'),
        right: $r('app.float.live_view_card_padding'),
        top: $r('app.float.live_view_tip_padding_top')
      })
      .brightness(this.authorizationVm.brightness)
      .backgroundColor(this.authorizationVm.backgroundColor)
      // 点击卡片授权提示区域不跳转至应用
      .onClick(() => {})
    }
  }

  @Builder
  buildButtonZone() {
    Row() {
      this.LiveCardAuthorizationButtonView({
        text: $r('app.string.live_view_authorization_reject'),
        onClickAction: () => {
          this.authorizationVm.onAuthorizationChange(false);
        },
        buttonFlage: leftButtonAction,
      });

      Divider()
        .vertical(true)
        .height($r('app.float.live_view_card_button_line_height_vp'))
        .color(this.authorizationVm.dividerColor)
        .opacity(this.authorizationVm.dividerOpacity)

      this.LiveCardAuthorizationButtonView({
        text: $r('app.string.live_view_authorization_confirm'),
        onClickAction: () => {
          this.authorizationVm.onAuthorizationChange(true);
        },
        buttonFlage: rightButtonAction,
      });
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height(this.authorizationVm.buttonHeight)
  }

  @Builder
  LiveCardAuthorizationButtonView(param: LiveCardAuthorizationButtonViewParam) {
    if (param.text) {
      Stack() {
        if (param.buttonFlage === leftButtonAction) {
          this.buildLeftTextButton(param);
        } else {
          this.buildRightTextButton(param);
        }
      }
      .layoutWeight(1)
      .gesture(TapGesture({ count: 1 }).onAction(param.onClickAction))
      .padding($r('app.float.ntf_live_view_authorize_button_gap'))
      .responseRegion([
        {
          x: 0,
          y: 0,
          width: '100%',
          height: '100%'
        },
        {
          x: 0,
          y: '100%',
          width: '100%',
          height: '4vp'
        }
      ])
      .onTouch(event => {
        event.stopPropagation();
      })
    }
  }

  @Builder
  buildLeftTextButton(param: LiveCardAuthorizationButtonViewParam) {
    Row() {
      Text(param.text)
        .fontColor(this.authorizationVm.buttonTextFontColor)
        .fontSize(this.authorizationVm.buttonTextFontSize)
        .maxFontScale(this.authorizationVm.maxFontScale)
        .opacity(this.authorizationVm.buttonTextOpacity)
        .lineHeight(this.authorizationVm.buttonTextLineHeight)
        .buttonCommonStyle()
    }
    .rowStyle()
    .backgroundColor(this.authorizationVm.isLeftActionPressed ? $r('app.color.ntf_action_bg_selected_color') :
    $r('app.color.ntf_normal_transparent_color'))
    .borderRadius($r('app.float.ntf_live_view_authorize_button_roundangle'))
    .onTouch((touchEvent) => {
      this.authorizationVm.onTouchEvent(touchEvent, leftButtonAction);
    })
  }

  @Builder
  buildRightTextButton(param: LiveCardAuthorizationButtonViewParam) {
    Row() {
      Text(param.text)
        .fontColor(this.authorizationVm.buttonTextFontColor)
        .fontSize(this.authorizationVm.buttonTextFontSize)
        .maxFontScale(this.authorizationVm.maxFontScale)
        .opacity(this.authorizationVm.buttonTextOpacity)
        .lineHeight(this.authorizationVm.buttonTextLineHeight)
        .buttonCommonStyle()
    }
    .rowStyle()
    .backgroundColor(this.authorizationVm.isRightActionPressed ? $r('app.color.ntf_action_bg_selected_color') :
    $r('app.color.ntf_normal_transparent_color'))
    .borderRadius($r('app.float.ntf_live_view_authorize_button_roundangle'))
    .onTouch((touchEvent) => {
      this.authorizationVm.onTouchEvent(touchEvent, rightButtonAction);
    })
  }
}

@Extend(Text)
function buttonCommonStyle() {
  .draggable(false)
  .maxLines(1)
  .textOverflow({ overflow: TextOverflow.Ellipsis })
  .fontWeight(FontWeight.Medium)
}

@Extend(Row)
function rowStyle() {
  .width('100%')
  .height('100%')
  .justifyContent(FlexAlign.Center)
  .alignItems(VerticalAlign.Center)
}