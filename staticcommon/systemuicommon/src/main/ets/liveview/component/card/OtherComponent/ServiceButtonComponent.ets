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
import { DarkModeState, fontScaleManager, FontScaleState } from '@ohos/systemuiutils';
import { LiveViewData } from '../../../data/LiveViewData';
import { OtherBaseTemplate } from '../../../data/template/OtherBaseTemplate';
import { LiveUseScene, LiveViewCommonConstants } from '../../../common/LiveConstants';
import { immersiveKgMgr } from '../../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { NotificationType } from '../../../../constants/NotificationType';
import { ColorModeViewData } from '../../../../template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '../../../../template/newStyle/ColorModeViewModel';
import { BrightnessOptionUtils } from '../../../../template/newStyle/BrightnessOptionUtils';
import { NotificationAction } from '../../../../model/NotificationContent';

const TAG = LiveViewCommonConstants.LOG_PREFIX + 'ServiceButtonComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 实况关联服务按钮
 */
@Component
export struct ServiceButtonComponent {
  @ObjectLink baseData: LiveViewData;
  @ObjectLink data: OtherBaseTemplate;
  @StorageLink('Notification_DarkModeModel_DarkModeStatus') darkModeState: DarkModeState = new DarkModeState();
  useScene: LiveUseScene = LiveUseScene.SCENE_LIVE_LIST;

  @State backgroundColors: Array<ResourceColor> = [];

  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();


  build() {
    Row() {
      ForEach(this.data.serviceButtons, (_: NotificationAction, index) => {
        this.buildDivider(index);
        this.buildButton(index);
        }, (_: NotificationAction, index) => this.baseData.hashCode + '#' + index
      )
    }
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor($r('app.color.theme_ntf_phone_action_bg_color'))
    .backgroundBrightnessInternal(this.colorModeViewData.customActionViewBg)
    .width('100%')
  }

  @Builder
  buildDivider(index: number) {
    if (index !== 0) {
      Divider()
        .vertical(true)
        .height(22)
        .visibility(this.getDividerVisible())
        .color($r('app.color.theme_ntf_phone_action_divider_color'))
        .opacity(1)
        .foregroundBrightness(this.colorModeViewData?.foregroundDividerOption)
        .flexShrink(0)
    }
  }

  @Builder
  buildButton(index: number) {
    Stack() {
      Text(this.data.serviceButtons[index]?.actionTitle)
        .draggable(false)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .opacity(1)
        .fontWeight(FontWeight.Medium)
        .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
        .maxFontScale(this.fontScaleState.getFontScale())
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontWeight(FontWeight.Medium)
        .lineHeight(this.fontScaleState.getScaleSize($r('app.float.live_view_card_text_line_height')))
        .width('100%')
        .textAlign(TextAlign.Center)
        .onTouch((event) => this.handleTouchEvent(event, index))
    }
    .visibility(this.data.serviceButtons[index]?.actionTitle ? Visibility.Visible : Visibility.None)
    .flexShrink(1)
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
    .gesture(GestureGroup(GestureMode.Parallel,
      TapGesture({ count: 1 }).onAction(event => this.handleClickEvent(index, 1)),
      TapGesture({ count: 2 }).onAction(event => this.handleClickEvent(index, 2))
    ))
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
    .backgroundColor(this.backgroundColors[index])
  }

  private getDividerVisible(): Visibility {
    for (let button of this.data.serviceButtons) {
      if (button.actionTitle) {
        return Visibility.Visible;
      }
    }
    return Visibility.None;
  }

  private handleTouchEvent(event: TouchEvent, index: number): void {
    if (!event) {
      return;
    }
    if (TouchType.Down === event.type) {
      this.backgroundColors[index] = $r('sys.color.ohos_id_color_hover');
    } else if (TouchType.Move == event.type) {
      if (!this.isTouchInArea(event.touches[0], event.target.area)) {
        this.backgroundColors = [];
      }
    } else {
      this.backgroundColors = [];
    }
  }

  private isTouchInArea(touch: TouchObject, area: Area): boolean {
    return touch.x >= 0 && touch.x <= area.width && touch.y >= 0 && touch.y <= area.height;
  }

  private handleClickEvent(index: number, clickCount?: number): void {
    if (!this.data.serviceButtons[index]?.wantAgent) {
      return;
    }

    log.showInfo(`triggerServiceButtonWant for ${this.baseData.hashCode}_serviceButton_${index}`);
    this.data.clickAction?.handleServiceButtonClick(this.data, this.data.serviceButtons[index]?.wantAgent,
      clickCount, this.notificationType, this.baseData?.creatorUid);
  }
}