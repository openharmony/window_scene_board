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
import Constants from '../common/Constants';
import ctrlAltDelPanelModel from '../model/CtrlAltDelPanelModel';
import { ColorMetrics, LengthMetrics } from '@ohos.arkui.node';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { FunctionListInfo, FunctionListSize } from '../common/FunctionListInfo';

const TAG = 'FunctionItemView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct FunctionItemView {
  @Prop functionItem: FunctionListInfo = ctrlAltDelPanelModel.functionList[0];
  @Prop itemListSize: FunctionListSize = {
    textWidth: Constants.FUNCTION_TEXT_WIDTH,
    itemWidth: Constants.FUNCTION_ITEM_WIDTH,
    itemHeight: Constants.FUNCTION_ITEM_HEIGHT
  };
  @State fillBackgroundColor: Resource | Color = Color.Transparent;
  @StorageLink('FocusMoveIndex') focusMoveIndex: number = 0;
  private textWidth: number = Constants.FUNCTION_ITEM_MARGIN_LEFT + Constants.FUNCTION_ITEM_MARGIN_RIGHT +
   Constants.FUNCTION_ITEM_WIDTH;

  build() {
    Stack() {
      Row() {
        Image(this.functionItem.imageRes)
          .width(Constants.FUNCTION_ICON_WIDTH)
          .height(Constants.FUNCTION_ICON_HEIGHT)
          .objectFit(ImageFit.Fill)
          .draggable(false)
          .syncLoad(true)
          .matchTextDirection(true)
          .margin({ left: $r('app.float.ctrl_alt_del_icon_margin'), right: $r('app.float.ctrl_alt_del_icon_margin') })
        Text() {
          Span(this.functionItem.name)
            .fontFamily('HarmonyHeiTi')
            .fontColor($r('sys.color.font_primary'))
            .width(this.itemListSize.textWidth)
            .fontSize($r('app.float.ctrl_alt_del_description_font_size'))
            .fontWeight(FontWeight.Medium)
            .align(Alignment.Center)
        }
        .width(this.itemListSize.textWidth)
        .textAlign(TextAlign.Start)
        .margin({ left: $r('app.float.ctrl_alt_del_font_margin'), right: $r('app.float.ctrl_alt_del_font_margin') })
      }
      .id(this.functionItem.id)
      .focusable(this.functionItem.id === ctrlAltDelPanelModel.functionList[this.focusMoveIndex].id)
      .alignItems(VerticalAlign.Center)
      .backgroundColor(this.fillBackgroundColor)
      .width(this.itemListSize.itemWidth)
      .height(this.itemListSize.itemHeight)
      .borderRadius(Constants.FUNCTION_ITEM_RADIUS)
      .borderWidth(Constants.FUNCTION_ITEM_FOCUS_BORDER_WIDTH)
      .borderColor(this.functionItem.id === ctrlAltDelPanelModel.functionList[this.focusMoveIndex].id ? Color.White :
      Color.Transparent)
      .focusBox({
        margin: LengthMetrics.vp(0),
        strokeColor: ColorMetrics.resourceColor('#FFFFFF'),
        strokeWidth: LengthMetrics.vp(0)
      })
      .onHover((isHover: boolean) => {
        if (isHover) {
          this.fillBackgroundColor = $r('sys.color.interactive_hover');
        } else {
          this.fillBackgroundColor = Color.Transparent;
        }
      })
      .onClick((event: ClickEvent) => {
        this.functionItem.action();
      })
    }
    .alignContent(Alignment.Start)
    .margin({ bottom: 8 })
    .width(this.itemListSize.itemWidth)
    .height(this.itemListSize.itemHeight)
    .borderRadius(Constants.FUNCTION_ITEM_RADIUS)
    .backgroundColor(this.functionItem.id ===
    ctrlAltDelPanelModel.functionList[this.focusMoveIndex].id ? $r('sys.color.interactive_hover') : Color.Transparent)
  }
}