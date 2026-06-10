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

import { LogDomain, Logger } from '@ohos/basicutils';
import { FloatingBallInjector } from '../injector/FloatingBallInjector';
import { IFloatingBallInjector } from '../interface/IFloatingBallInjector';
import { FloatingBall } from '../model/FloatingBallModel';
import { FloatingBallStyle } from '../constants/FloatingBallStyle';
import { FBTemplate } from '../constants/FloatingConstants';
import lazy { NormalTemplate } from './template/NormalTemplate';
import lazy { SimpleTemplate } from './template/SimpleTemplate';
import lazy { StaticTemplate } from './template/StaticTemplate';
import lazy { EmphasisTemplate } from './template/EmphasisTemplate';
import { ScreenProperty } from '../model/ScreenProperty';
import { ColorUtil } from '@ohos/systemuicommon/src/main/ets/utils/ColorUtil';

const TAG = 'FloatingBallList';
const log = Logger.getLogHelper(LogDomain.WINDOW);

@ComponentV2
export struct FloatingBallListView {
  @Param @Require floatingBallList: FloatingBall[];
  @Param @Require screenProperty: ScreenProperty;
  @Consumer() injector: IFloatingBallInjector = FloatingBallInjector.HOLDER;
  private static readonly LONG_PRESS_TIME: number = 800;
  private listVm = this.injector.getListVm();

  aboutToAppear(): void {
    log.showInfo(TAG, `aboutToAppear`);
  }

  aboutToDisappear() {
    log.showInfo(TAG, 'aboutToDisAppear');
  }

  build() {
    this.renderList();
  }

  @Builder
  renderList() {
    ForEach(
      this.floatingBallList,
      (item: FloatingBall, index?: number) => {
        Row() { // 元素列表
          if (item.template === FBTemplate.STATIC) {
            StaticTemplate(item, this.listVm)
          } else if (item.template === FBTemplate.NORMAL) {
            NormalTemplate(item)
          } else if (item.template === FBTemplate.EMPHATIC) {
            EmphasisTemplate(item, this.listVm)
          } else if (item.template === FBTemplate.SIMPLE) {
            SimpleTemplate(item, this.listVm)
          }
        }
        .justifyContent(FlexAlign.Center) // Row内子元素水平方向对齐方式
        .height(FloatingBallStyle.ROW_HEIGHT)
        .borderRadius(FloatingBallStyle.RADIUS)
        .backgroundColor(this.getBackgroundAndUpdateTitleColor(item))
        .width('100%')
        .parallelGesture(
          GestureGroup(GestureMode.Exclusive,
            LongPressGesture({ repeat: false, duration: FloatingBallListView.LONG_PRESS_TIME })
              .onAction((event: GestureEvent) => {
                const persistentId: number = item?.specificSession?.session?.persistentId;
                this.listVm.onLongPressShowMenu(event, persistentId);
              }),
            // 单击
            TapGesture({count: 1})
              .onAction((event: GestureEvent) => {
                this.listVm.onClick(item);
              })
          )
        )
        .opacity(item.opacity)
        .scale({
          x: item.scale,
          y: item.scale,
        })
        .translate({ y: item.translateY })
        .zIndex(item.zIndex)
      },
      (item: FloatingBall, index) => `${item.specificSession.session.persistentId}-${item.template}`
    )
  }

  /**
   * 获取背景颜色并更新标题颜色
   * @param ball
   * @returns
   */
  public getBackgroundAndUpdateTitleColor(ball: FloatingBall): ResourceColor | undefined {
    // 如果带了背景色，不根据深浅模式切换背景色和字体颜色
    if (ball.backgroundColor) {
      const isUseLightColor = ColorUtil.checkUseLightColor(ball.backgroundColor);
      ball.fontColor = isUseLightColor ? FloatingBallStyle.FONT_WHITE : FloatingBallStyle.FONT_BLACK;
      ball.contentFontColor = isUseLightColor ?
        FloatingBallStyle.CONTENT_FONT_WHITE : FloatingBallStyle.CONTENT_FONT_BLACK;
      return ball.backgroundColor;
    }
    // 不带背景色，颜色根据系统变换
    ball.fontColor = FloatingBallStyle.FONT_COLOR_PRIMARY;
    ball.contentFontColor = FloatingBallStyle.FONT_COLOR_SECONDARY;
    return FloatingBallStyle.BG_COLOR;
  }
}