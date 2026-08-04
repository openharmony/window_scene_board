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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveViewCommonConstants } from '../../../common/LiveConstants';
import { fontScaleManager } from '@ohos/systemuiutils/src/main/ets/fontScale/fontScaleManager';
import { FontScaleState } from '@ohos/systemuiutils/src/main/ets/fontScale/fontScaleState';
import { AodStyleType, ImmersiveAodStyle } from '../../../../immersivekeyguardcommon/base/interface/ImmersiveAodStyle';
import { OuterHomeVm } from '../../../../../ets/vm/OuterHomeVm'

const TAG = LiveViewCommonConstants.LOG_PREFIX + 'CardButtonComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const AUTH_BUTTON_OPACITY_AOD = 0.1;
const AUTH_BUTTON_OPACITY_NORMAL = 0.6;

/**
 * 卡片授权提示按钮
 */
@Component
export struct CardButtonComponent {
  @Prop text: Resource;
  /**
   * AOD显示样式
   */
  @Prop aodStyle: ImmersiveAodStyle | undefined;
  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  /**
   * action是否按压状态
   */
  @State isActionPressed: boolean = false;
  @State outerHomeVm: OuterHomeVm = OuterHomeVm.get();
  onClickAction: () => void = () => {
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  build() {
    Stack() {
      this.buildTextButton();
    }
    .layoutWeight(1)
    .padding($r('app.float.ntf_live_view_authorize_button_gap'))
    .onClick(this.onClickAction)
    .gesture(TapGesture({ count: 1 }).onAction(this.onClickAction))
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

  @Builder
  buildTextButton() {
    Row() {
      Text(this.text)
        .draggable(false)
        .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.AUTH_TIP_BUTTON_COLOR) :
        $r('sys.color.ohos_id_color_text_primary'))
        .fontSize(this.fontScaleState.getScaleSize($r('app.float.live_view_card_button_font_size'),
          this.outerHomeVm.isIgnoreFontScaleState))
        .opacity(this.aodStyle?.isAod ? AUTH_BUTTON_OPACITY_AOD : AUTH_BUTTON_OPACITY_NORMAL)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontWeight(FontWeight.Medium)
        .lineHeight(this.fontScaleState.getScaleSize($r('app.float.live_view_card_button_line_height'),
          this.outerHomeVm.isIgnoreFontScaleState))
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.getBgColor())
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .borderRadius($r('app.float.ntf_live_view_authorize_button_roundangle'))
    .onTouch((touchEvent) => {
      this.handleTouchEvent(touchEvent);
    })
  }

  /**
   * 获取按钮背景色
   *
   * @return 背景色
   */
  private getBgColor(): ResourceColor {
    // 按压状态
    if (this.isActionPressed) {
      return $r('app.color.ntf_action_bg_selected_color');
    }

    return $r('app.color.ntf_normal_transparent_color');
  }

  /**
   * 处理触摸事件
   * 1. 触摸按下时 显示背景色;
   * 2. 触摸后移动到组件外时 不显示背景色; 且再移回组件区域也不重新显示背景色
   * 3. 触摸抬起\取消\或其他情况 不显示背景色;
   *
   * @param event 触摸事件
   */
  private handleTouchEvent(event: TouchEvent): void {
    if (!event) {
      return;
    }

    if (TouchType.Down === event.type) {
      this.isActionPressed = true;
    } else if (TouchType.Move == event.type) {
      if (!this.isTouchInArea(event.touches[0], event.target.area)) {
        this.isActionPressed = false;
      }
    } else {
      this.isActionPressed = false;
    }
  }

  private isTouchInArea(touch: TouchObject, area: Area): boolean {
    return touch.x >= 0 && touch.x <= area.width && touch.y >= 0 && touch.y <= area.height;
  }
}
